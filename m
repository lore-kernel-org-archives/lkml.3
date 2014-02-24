Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbaBXN4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 08:56:16 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37120 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949AbaBXNz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 08:55:57 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        rjw@rjwysocki.net
Cc: nicolas.pitre@linaro.org, preeti@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 5/5] idle: Add more comments to the code
Date: Mon, 24 Feb 2014 14:55:51 +0100
Message-Id: <1393250151-6982-5-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393250151-6982-1-git-send-email-daniel.lezcano@linaro.org>
References: <1393250151-6982-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idle main function is a complex and a critical function. Added more
comments to the code.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Acked-by: Nicolas Pitre <nico@linaro.org>
---
 Changelog:

 V2:
     * fixed typo in comment
---
 kernel/sched/idle.c |   40 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 36 insertions(+), 4 deletions(-)

Index: cpuidle-next/kernel/sched/idle.c
===================================================================
--- cpuidle-next.orig/kernel/sched/idle.c
+++ cpuidle-next/kernel/sched/idle.c
@@ -86,15 +86,34 @@ static int cpuidle_idle_call(void)
 	if (cpu_idle_force_poll || tick_check_broadcast_expired())
 		return cpu_idle_poll();
 
+	/*
+	 * Check if the idle task must be rescheduled. If it is the case,
+	 * exit the function after re-enabling the local irq and set again
+	 * the polling flag
+	 */
 	if (current_clr_polling_and_test()) {
 		local_irq_enable();
 		__current_set_polling();
 		return 0;
 	}
 
+	/*
+	 * During the idle period, stop measuring the disabled irqs
+	 * critical sections latencies
+	 */
 	stop_critical_timings();
+
+	/*
+	 * Tell the RCU framework we are entering an idle section,
+	 * so no more rcu read side critical sections and one more
+	 * step to the grace period
+	 */
 	rcu_idle_enter();
 
+	/*
+	 * Check if the cpuidle framework is ready, otherwise fallback
+	 * to the default arch specific idle method
+	 */
 	next_state = cpuidle_enabled(drv, dev);
 	if (next_state < 0) {
 		arch_cpu_idle();
@@ -102,13 +121,16 @@ static int cpuidle_idle_call(void)
 	}
 
 	/*
-	 * Ask the governor for the next state, this call can fail for
-	 * different reasons: cpuidle is not enabled or an idle state
-	 * fulfilling the constraints was not found. In this case, we
-	 * fall back to the default idle function
+	 * Ask the governor to choose an idle state it thinks it is
+	 * convenient to go to. There is *always* a convenient idle
+	 * state
 	 */
 	next_state = cpuidle_select(drv, dev);
 
+	/*
+	 * The idle task must be scheduled, it is pointless to go to idle,
+	 * just update no idle residency and get out of this function
+	 */
 	if (need_resched()) {
 		dev->last_residency = 0;
 		/* give the governor an opportunity to reflect on the outcome */
@@ -119,6 +141,12 @@ static int cpuidle_idle_call(void)
 
 	trace_cpu_idle_rcuidle(next_state, dev->cpu);
 
+	/*
+	 * Enter the idle state previously returned by the governor
+	 * decision. This function will block until an interrupt
+	 * occurs and will take care of re-enabling the local
+	 * interrupts
+	 */
 	entered_state = cpuidle_enter(drv, dev, next_state);
 
 	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
@@ -155,6 +183,10 @@ static void cpu_idle_loop(void)
 			local_irq_disable();
 			arch_cpu_idle_enter();
 
+			/*
+			 * It is up to the underlying functions to
+			 * enable the local interrupts again
+			 */
 			cpuidle_idle_call();
 
 			arch_cpu_idle_exit();
