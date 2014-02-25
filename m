Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbaBYIJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 03:09:45 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:50742 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaBYII7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 03:08:59 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        rjw@rjwysocki.net
Cc: nicolas.pitre@linaro.org, preeti@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH V3 4/5] idle: Move idle conditions in cpuidle_idle main function
Date: Tue, 25 Feb 2014 09:08:52 +0100
Message-Id: <1393315733-32321-4-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393315733-32321-1-git-send-email-daniel.lezcano@linaro.org>
References: <1393315733-32321-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the condition before entering idle into the cpuidle main
function located in idle.c. That simplify the idle mainloop functions and
increase the readibility of the conditions to enter truly idle.

This patch is code reorganization and does not change the behavior of the
function.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>
---

V3:
    * reorganized cpuidle_idle_call function as Suggested by Peter Zijlstra
	https://lkml.org/lkml/2014/2/24/492

---
 kernel/sched/idle.c |   85 ++++++++++++++++++++++++++++------------------------
 1 file changed, 46 insertions(+), 39 deletions(-)

Index: cpuidle-next/kernel/sched/idle.c
===================================================================
--- cpuidle-next.orig/kernel/sched/idle.c
+++ cpuidle-next/kernel/sched/idle.c
@@ -73,46 +73,58 @@ static int cpuidle_idle_call(void)
 {
 	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
 	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
-	int next_state, entered_state, ret;
+	int next_state, entered_state;
 	bool broadcast;
 
-	stop_critical_timings();
-	rcu_idle_enter();
-
-	ret = cpuidle_enabled(drv, dev);
-	if (ret < 0) {
-		arch_cpu_idle();
-		goto out;
-	}
-
-	/* ask the governor for the next state */
-	next_state = cpuidle_select(drv, dev);
-
-	if (need_resched()) {
-		dev->last_residency = 0;
-		/* give the governor an opportunity to reflect on the outcome */
-		cpuidle_reflect(dev, next_state);
+	if (current_clr_polling_and_test()) {
 		local_irq_enable();
-		goto out;
+		__current_set_polling();
+		return 0;
 	}
 
-	trace_cpu_idle_rcuidle(next_state, dev->cpu);
+	stop_critical_timings();
+	rcu_idle_enter();
 
-	broadcast = !!(drv->states[next_state].flags & CPUIDLE_FLAG_TIMER_STOP);
+	if (cpuidle_enabled(drv, dev) == 0) {
 
-	if (broadcast)
-		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu);
+		/* ask the governor for the next state */
+		next_state = cpuidle_select(drv, dev);
 
-	entered_state = cpuidle_enter(drv, dev, next_state);
+		if (current_clr_polling_and_test()) {
+			dev->last_residency = 0;
+			entered_state = next_state;
+			local_irq_enable();
+		} else {
+			trace_cpu_idle_rcuidle(next_state, dev->cpu);
+
+			broadcast = !!(drv->states[next_state].flags &
+				       CPUIDLE_FLAG_TIMER_STOP);
+
+			if (broadcast)
+				clockevents_notify(
+					CLOCK_EVT_NOTIFY_BROADCAST_ENTER,
+					&dev->cpu);
+
+			entered_state = cpuidle_enter(drv, dev, next_state);
+
+			if (broadcast)
+				clockevents_notify(
+					CLOCK_EVT_NOTIFY_BROADCAST_EXIT,
+					&dev->cpu);
 
-	if (broadcast)
-		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);
+			trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
+		}
 
-	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
+		/* give the governor an opportunity to reflect on the outcome */
+		cpuidle_reflect(dev, next_state);
+	} else {
+		if (current_clr_polling_and_test())
+			local_irq_enable();
+		else
+			arch_cpu_idle();
+	}
+	__current_set_polling();
 
-	/* give the governor an opportunity to reflect on the outcome */
-	cpuidle_reflect(dev, entered_state);
-out:
 	if (WARN_ON_ONCE(irqs_disabled()))
 		local_irq_enable();
 
@@ -139,7 +151,7 @@ static void cpu_idle_loop(void)
 
 			local_irq_disable();
 			arch_cpu_idle_enter();
-
+
 			/*
 			 * In poll mode we reenable interrupts and spin.
 			 *
@@ -149,16 +161,11 @@ static void cpu_idle_loop(void)
 			 * know that the IPI is going to arrive right
 			 * away
 			 */
-			if (cpu_idle_force_poll || tick_check_broadcast_expired()) {
+			if (cpu_idle_force_poll || tick_check_broadcast_expired())
 				cpu_idle_poll();
-			} else {
-				if (!current_clr_polling_and_test()) {
-					cpuidle_idle_call();
-				} else {
-					local_irq_enable();
-				}
-				__current_set_polling();
-			}
+			else
+				cpuidle_idle_call();
+
 			arch_cpu_idle_exit();
 			/*
 			 * We need to test and propagate the TIF_NEED_RESCHED
