Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbaBYIJn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 03:09:43 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:58256 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbaBYIJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 03:09:00 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        rjw@rjwysocki.net
Cc: nicolas.pitre@linaro.org, preeti@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH V3 5/5] idle: Add more comments to the code
Date: Tue, 25 Feb 2014 09:08:53 +0100
Message-Id: <1393315733-32321-5-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393315733-32321-1-git-send-email-daniel.lezcano@linaro.org>
References: <1393315733-32321-1-git-send-email-daniel.lezcano@linaro.org>
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
 kernel/sched/idle.c |   43 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 41 insertions(+), 2 deletions(-)

Index: cpuidle-next/kernel/sched/idle.c
===================================================================
--- cpuidle-next.orig/kernel/sched/idle.c
+++ cpuidle-next/kernel/sched/idle.c
@@ -76,20 +76,48 @@ static int cpuidle_idle_call(void)
 	int next_state, entered_state;
 	bool broadcast;
 
+	/*
+	 * Check if the idle task must be rescheduled. If it is the
+	 * case, exit the function after re-enabling the local irq and
+	 * set again the polling flag
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
 	if (cpuidle_enabled(drv, dev) == 0) {
 
-		/* ask the governor for the next state */
+		/*
+		 * Ask the governor to choose an idle state it thinks
+		 * it is convenient to go to. There is *always* a
+		 * convenient idle state
+		 */
 		next_state = cpuidle_select(drv, dev);
 
+		/*
+		 * The idle task must be scheduled, it is pointless to
+		 * go to idle, just update no idle residency and get
+		 * out of this function
+		 */
 		if (current_clr_polling_and_test()) {
 			dev->last_residency = 0;
 			entered_state = next_state;
@@ -104,7 +132,13 @@ static int cpuidle_idle_call(void)
 				clockevents_notify(
 					CLOCK_EVT_NOTIFY_BROADCAST_ENTER,
 					&dev->cpu);
-
+			/*
+			 * Enter the idle state previously returned by
+			 * the governor decision. This function will
+			 * block until an interrupt occurs and will
+			 * take care of re-enabling the local
+			 * interrupts
+			 */
 			entered_state = cpuidle_enter(drv, dev, next_state);
 
 			if (broadcast)
@@ -164,6 +198,11 @@ static void cpu_idle_loop(void)
 			if (cpu_idle_force_poll || tick_check_broadcast_expired())
 				cpu_idle_poll();
 			else
+				/*
+				 * It is up to the underlying
+				 * functions to enable the local
+				 * interrupts again
+				 */
 				cpuidle_idle_call();
 
 			arch_cpu_idle_exit();
