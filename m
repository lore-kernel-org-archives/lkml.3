Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbaCCHti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 02:49:38 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:42834 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbaCCHte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 02:49:34 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, tglx@linutronix.de,
        rjw@rjwysocki.net
Cc: nicolas.pitre@linaro.org, preeti@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: [PATCH V4 5/5] idle: Add more comments to the code
Date: Mon,  3 Mar 2014 08:48:54 +0100
Message-Id: <1393832934-11625-5-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393832934-11625-1-git-send-email-daniel.lezcano@linaro.org>
References: <20140228125604.GN27965@twins.programming.kicks-ass.net>
 <1393832934-11625-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idle main function is a complex and a critical function. Added more
comments to the code.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Acked-by: Nicolas Pitre <nico@linaro.org>
---
Changelog:

V4:
 * updated comments with new code
V3:
 * no changes
V2:
 * fixed typo in comment
---
 kernel/sched/idle.c |   59 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 57 insertions(+), 2 deletions(-)

Index: cpuidle-next/kernel/sched/idle.c
===================================================================
--- cpuidle-next.orig/kernel/sched/idle.c
+++ cpuidle-next/kernel/sched/idle.c
@@ -76,21 +76,49 @@ static int cpuidle_idle_call(void)
 	int next_state, entered_state, ret;
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
 	ret = cpuidle_enabled(drv, dev);
 
 	if (!ret) {
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
@@ -100,6 +128,14 @@ static int cpuidle_idle_call(void)
 				       CPUIDLE_FLAG_TIMER_STOP);
 
 			if (broadcast)
+				/*
+				 * Tell the time framework to switch
+				 * to a broadcast timer because our
+				 * local timer will be shutdown. If a
+				 * local timer is used from another
+				 * cpu as a broadcast timer, this call
+				 * may fail if it is not available
+				 */
 				ret = clockevents_notify(
 					CLOCK_EVT_NOTIFY_BROADCAST_ENTER,
 					&dev->cpu);
@@ -107,6 +143,14 @@ static int cpuidle_idle_call(void)
 			if (!ret) {
 				trace_cpu_idle_rcuidle(next_state, dev->cpu);
 
+				/*
+				 * Enter the idle state previously
+				 * returned by the governor
+				 * decision. This function will block
+				 * until an interrupt occurs and will
+				 * take care of re-enabling the local
+				 * interrupts
+				 */
 				entered_state = cpuidle_enter(drv, dev,
 							      next_state);
 
@@ -118,17 +162,28 @@ static int cpuidle_idle_call(void)
 						CLOCK_EVT_NOTIFY_BROADCAST_EXIT,
 						&dev->cpu);
 
-				/* give the governor an opportunity to reflect on the outcome */
+				/*
+				 * Give the governor an opportunity to reflect on the
+				 * outcome
+				 */
 				cpuidle_reflect(dev, entered_state);
 			}
 		}
 	}
 
+	/*
+	 * We can't use the cpuidle framework, let's use the default
+	 * idle routine
+	 */
 	if (ret)
 		arch_cpu_idle();
 
 	__current_set_polling();
 
+	/*
+	 * It is up to the idle functions to enable back the local
+	 * interrupt
+	 */
 	if (WARN_ON_ONCE(irqs_disabled()))
 		local_irq_enable();
 
