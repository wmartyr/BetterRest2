//
//  ContentView.swift
//  BetterRest2
//
//  Created by Woodrow Martyr on 17/11/2024.
//

import CoreML
import SwiftUI

struct ContentView: View {
    
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    @State private var sleepTime = defaultWakeTime
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    var body: some View {
        NavigationStack {
            Form {
//                VStack(alignment: .leading, spacing: 0) {
//                    Text("When do you want to wake up?")
//                        .font(.headline)
//                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
//                        .labelsHidden()
//                }
//                VStack(alignment: .leading, spacing: 0) {
//                    Text("Desired amount of sleep")
//                        .font(.headline)
//                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
//                }
//                VStack(alignment: .leading, spacing: 0) {
//                    Text("Daily coffee intake")
//                        .font(.headline)
//                    Stepper("^[\(coffeeAmount) cup](inflect: true)", value: $coffeeAmount, in: 1...20)
//                }
                Section("When do you want to wake up?") {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .onChange(of: wakeUp) {
                            sleepTime = calculateBedtime()
                        }
                        .onAppear() {
                            sleepTime = calculateBedtime()
                        }
                }
                Section("Desired amount of sleep") {
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                        .onChange(of: sleepAmount) {
                            sleepTime = calculateBedtime()
                        }
                }
                Section("Daily coffee intake") {
//                    Stepper("^[\(coffeeAmount) cup](inflect: true)", value: $coffeeAmount, in: 1...20)
                    Picker(selection: $coffeeAmount, label: Text("Number of cups")) {
                        ForEach(1...20, id: \.self) {
                            Text("^[\($0) cup](inflect: true)")
                        }
                    }
                    .onChange(of: coffeeAmount) {
                        sleepTime = calculateBedtime()
                    }
                }
                Section("Ideal Bedtime") {
                    Text("\(sleepTime.formatted(date: .omitted, time: .shortened))")
                        .font(.largeTitle)
                }
            }
            .navigationTitle("Better Rest 2")
//            .toolbar {
//                Button("Calculate", action: calculateBedtime)
//            }
//            .alert(alertTitle, isPresented: $showingAlert) {
//                Button("Ok") {}
//            } message: {
//                Text(alertMessage)
//            }
        }
    }
    
//    func calculateBedtime() {
//        do {
//            let config = MLModelConfiguration()
//            let model = try SleepCalculator(configuration: config)
//            
//            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
//            let hour = (components.hour ?? 0) * 60 * 60
//            let minute = (components.minute ?? 0) * 60
//            
//            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
//            let sleepTime = wakeUp - prediction.actualSleep
//            
//            alertTitle = "Your ideal bedtime is..."
//            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
//        } catch {
//            alertTitle = "Error"
//            alertMessage = "Sorry, there was a problem calculating your bedtime."
//        }
//        showingAlert = true
//    }
    
    func calculateBedtime() -> Date{
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            return wakeUp - prediction.actualSleep
//            let sleep = wakeUp - prediction.actualSleep
//            sleepTime = sleep
            
        } catch {
            return wakeUp
//            sleepTime = wakeUp
        }
    }
}

#Preview {
    ContentView()
}
