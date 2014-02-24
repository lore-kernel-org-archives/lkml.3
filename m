Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972AbaBXNz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 08:55:58 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:42991 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944AbaBXNz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 08:55:56 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        rjw@rjwysocki.net
Cc: nicolas.pitre@linaro.org, preeti@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 4/5] idle: Move idle conditions in cpuidle_idle main function
Date: Mon, 24 Feb 2014 14:55:50 +0100
Message-Id: <1393250151-6982-4-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393250151-6982-1-git-send-email-daniel.lezcano@linaro.org>
References: <1393250151-6982-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the condition before entering idle into the cpuidle main
function located in idle.c. That simplify the idle mainloop functions and
increase the readibility of the conditions to enter truly idle.

This patch is code reorganization and does not change the behavior of the
function.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 kernel/sched/idle.c |   40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

Index: cpuidle-next/kernel/sched/idle.c
===================================================================
--- cpuidle-next.orig/kernel/sched/idle.c
+++ cpuidle-next/kernel/sched/idle.c
@@ -75,6 +75,23 @@ static int cpuidle_idle_call(void)
 	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
 	int next_state, entered_state;
 
+	/*
+	 * In poll mode we reenable interrupts and spin.
+	 *
+	 * Also if we detected in the wakeup from idle path that the
+	 * tick broadcast device expired for us, we don't want to go
+	 * deep idle as we know that the IPI is going to arrive right
+	 * away
+	 */
+	if (cpu_idle_force_poll || tick_check_broadcast_expired())
+		return cpu_idle_poll();
+
+	if (current_clr_polling_and_test()) {
+		local_irq_enable();
+		__current_set_polling();
+		return 0;
+	}
+
 	stop_critical_timings();
 	rcu_idle_enter();
 
@@ -115,6 +132,8 @@ out:
 	rcu_idle_exit();
 	start_critical_timings();
 
+	__current_set_polling();
+
 	return 0;
 }
 
@@ -136,25 +155,8 @@ static void cpu_idle_loop(void)
 			local_irq_disable();
 			arch_cpu_idle_enter();
 
-			/*
-			 * In poll mode we reenable interrupts and spin.
-			 *
-			 * Also if we detected in the wakeup from idle
-			 * path that the tick broadcast device expired
-			 * for us, we don't want to go deep idle as we
-			 * know that the IPI is going to arrive right
-			 * away
-			 */
-			if (cpu_idle_force_poll || tick_check_broadcast_expired()) {
-				cpu_idle_poll();
-			} else {
-				if (!current_clr_polling_and_test()) {
-					cpuidle_idle_call();
-				} else {
-					local_irq_enable();
-				}
-				__current_set_polling();
-			}
+			cpuidle_idle_call();
+
 			arch_cpu_idle_exit();
 			/*
 			 * We need to test and propagate the TIF_NEED_RESCHED
