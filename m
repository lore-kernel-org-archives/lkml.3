Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934519AbaDKNz4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 09:55:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39776 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934320AbaDKNzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 09:55:54 -0400
Message-Id: <20140411135218.617896630@infradead.org>
User-Agent: quilt/0.60-1
Date: Fri, 11 Apr 2014 15:42:51 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, tglx@linutronix.de, luto@amacapital.net,
        nicolas.pitre@linaro.org, daniel.lezcano@linaro.org,
        peterz@infradead.org, umgwanakikbuti@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 8/8] sched,idle: Reflow cpuidle_idle_call()
References: <20140411134243.160989490@infradead.org>
Content-Disposition: inline; filename=sched-idle-polling-reflow.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apply goto to reduce lines and nesting levels.

Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/idle.c |  138 +++++++++++++++++++++++-----------------------------
 1 file changed, 62 insertions(+), 76 deletions(-)

--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -73,7 +73,7 @@ static int cpuidle_idle_call(void)
 {
 	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
 	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
-	int next_state, entered_state, ret;
+	int next_state, entered_state;
 	bool broadcast;
 
 	/*
@@ -102,90 +102,64 @@ static int cpuidle_idle_call(void)
 	 * Check if the cpuidle framework is ready, otherwise fallback
 	 * to the default arch specific idle method
 	 */
-	ret = cpuidle_enabled(drv, dev);
+	if (cpuidle_enabled(drv, dev))
+		goto use_default;
 
-	if (!ret) {
-		/*
-		 * Ask the governor to choose an idle state it thinks
-		 * it is convenient to go to. There is *always* a
-		 * convenient idle state
-		 */
-		next_state = cpuidle_select(drv, dev);
-
-		/*
-		 * The idle task must be scheduled, it is pointless to
-		 * go to idle, just update no idle residency and get
-		 * out of this function
-		 */
-		if (current_clr_polling_and_test()) {
-			dev->last_residency = 0;
-			entered_state = next_state;
-			local_irq_enable();
-		} else {
-			broadcast = !!(drv->states[next_state].flags &
-				       CPUIDLE_FLAG_TIMER_STOP);
-
-			if (broadcast) {
-				/*
-				 * Tell the time framework to switch
-				 * to a broadcast timer because our
-				 * local timer will be shutdown. If a
-				 * local timer is used from another
-				 * cpu as a broadcast timer, this call
-				 * may fail if it is not available
-				 */
-				ret = clockevents_notify(
-					CLOCK_EVT_NOTIFY_BROADCAST_ENTER,
-					&dev->cpu);
-			}
-
-			if (!ret) {
-				trace_cpu_idle_rcuidle(next_state, dev->cpu);
-
-				/*
-				 * Enter the idle state previously
-				 * returned by the governor
-				 * decision. This function will block
-				 * until an interrupt occurs and will
-				 * take care of re-enabling the local
-				 * interrupts
-				 */
-				entered_state = cpuidle_enter(drv, dev,
-							      next_state);
-
-				trace_cpu_idle_rcuidle(PWR_EVENT_EXIT,
-						       dev->cpu);
-
-				if (broadcast)
-					clockevents_notify(
-						CLOCK_EVT_NOTIFY_BROADCAST_EXIT,
-						&dev->cpu);
-
-				/*
-				 * Give the governor an opportunity to reflect on the
-				 * outcome
-				 */
-				cpuidle_reflect(dev, entered_state);
-			}
-		}
-	}
+	/*
+	 * Ask the governor to choose an idle state it thinks
+	 * it is convenient to go to. There is *always* a
+	 * convenient idle state
+	 */
+	next_state = cpuidle_select(drv, dev);
 
 	/*
-	 * We can't use the cpuidle framework, let's use the default
-	 * idle routine
+	 * The idle task must be scheduled, it is pointless to
+	 * go to idle, just update no idle residency and get
+	 * out of this function
 	 */
-	if (ret) {
-		if (!current_clr_polling_and_test())
-			arch_cpu_idle();
-		else
-			local_irq_enable();
+	if (current_clr_polling_and_test()) {
+		dev->last_residency = 0;
+		entered_state = next_state;
+		local_irq_enable();
+		goto exit_idle;
 	}
 
+	broadcast = !!(drv->states[next_state].flags & CPUIDLE_FLAG_TIMER_STOP);
+
+	/*
+	 * Tell the time framework to switch to a broadcast timer
+	 * because our local timer will be shutdown. If a local timer
+	 * is used from another cpu as a broadcast timer, this call may
+	 * fail if it is not available
+	 */
+	if (broadcast &&
+	    clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu))
+		goto use_default;
+
+	trace_cpu_idle_rcuidle(next_state, dev->cpu);
+
+	/*
+	 * Enter the idle state previously returned by the governor decision.
+	 * This function will block until an interrupt occurs and will take
+	 * care of re-enabling the local interrupts
+	 */
+	entered_state = cpuidle_enter(drv, dev, next_state);
+
+	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
+
+	if (broadcast)
+		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);
+
+	/*
+	 * Give the governor an opportunity to reflect on the outcome
+	 */
+	cpuidle_reflect(dev, entered_state);
+
+exit_idle:
 	__current_set_polling();
 
 	/*
-	 * It is up to the idle functions to enable back the local
-	 * interrupt
+	 * It is up to the idle functions to reenable local interrupts
 	 */
 	if (WARN_ON_ONCE(irqs_disabled()))
 		local_irq_enable();
@@ -194,6 +168,18 @@ static int cpuidle_idle_call(void)
 	start_critical_timings();
 
 	return 0;
+
+	/*
+	 * We can't use the cpuidle framework, let's use the default idle
+	 * routine
+	 */
+use_default:
+	if (current_clr_polling_and_test())
+		local_irq_enable();
+	else
+		arch_cpu_idle();
+
+	goto exit_idle;
 }
 
 /*


