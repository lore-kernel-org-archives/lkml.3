Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbaCCHtd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 02:49:33 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:39485 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbaCCHt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 02:49:28 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, tglx@linutronix.de,
        rjw@rjwysocki.net
Cc: nicolas.pitre@linaro.org, preeti@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: [PATCH V4 4/5] idle: Move idle conditions in cpuidle_idle main function
Date: Mon,  3 Mar 2014 08:48:53 +0100
Message-Id: <1393832934-11625-4-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393832934-11625-1-git-send-email-daniel.lezcano@linaro.org>
References: <20140228125604.GN27965@twins.programming.kicks-ass.net>
 <1393832934-11625-1-git-send-email-daniel.lezcano@linaro.org>
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

V4:
    * took into account clockevents_notify(ENTER) could fail
    * removed an extra current_clr_polling_and_test added in V3
V3:
    * reorganized cpuidle_idle_call function as Suggested by Peter Zijlstra
	https://lkml.org/lkml/2014/2/24/492

---
 kernel/sched/idle.c |   84 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 47 insertions(+), 37 deletions(-)

Index: cpuidle-next/kernel/sched/idle.c
===================================================================
--- cpuidle-next.orig/kernel/sched/idle.c
+++ cpuidle-next/kernel/sched/idle.c
@@ -76,44 +76,59 @@ static int cpuidle_idle_call(void)
 	int next_state, entered_state, ret;
 	bool broadcast;
 
+	if (current_clr_polling_and_test()) {
+		local_irq_enable();
+		__current_set_polling();
+		return 0;
+	}
+
 	stop_critical_timings();
 	rcu_idle_enter();
 
 	ret = cpuidle_enabled(drv, dev);
-	if (ret < 0) {
-		arch_cpu_idle();
-		goto out;
-	}
 
-	/* ask the governor for the next state */
-	next_state = cpuidle_select(drv, dev);
+	if (!ret) {
+		/* ask the governor for the next state */
+		next_state = cpuidle_select(drv, dev);
+
+		if (current_clr_polling_and_test()) {
+			dev->last_residency = 0;
+			entered_state = next_state;
+			local_irq_enable();
+		} else {
+			broadcast = !!(drv->states[next_state].flags &
+				       CPUIDLE_FLAG_TIMER_STOP);
+
+			if (broadcast)
+				ret = clockevents_notify(
+					CLOCK_EVT_NOTIFY_BROADCAST_ENTER,
+					&dev->cpu);
+
+			if (!ret) {
+				trace_cpu_idle_rcuidle(next_state, dev->cpu);
+
+				entered_state = cpuidle_enter(drv, dev,
+							      next_state);
+
+				trace_cpu_idle_rcuidle(PWR_EVENT_EXIT,
+						       dev->cpu);
+
+				if (broadcast)
+					clockevents_notify(
+						CLOCK_EVT_NOTIFY_BROADCAST_EXIT,
+						&dev->cpu);
 
-	if (need_resched()) {
-		dev->last_residency = 0;
-		/* give the governor an opportunity to reflect on the outcome */
-		cpuidle_reflect(dev, next_state);
-		local_irq_enable();
-		goto out;
+				/* give the governor an opportunity to reflect on the outcome */
+				cpuidle_reflect(dev, entered_state);
+			}
+		}
 	}
 
-	broadcast = !!(drv->states[next_state].flags & CPUIDLE_FLAG_TIMER_STOP);
-
-	if (broadcast &&
-	    clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu))
-		return -EBUSY;
-
-	trace_cpu_idle_rcuidle(next_state, dev->cpu);
-
-	entered_state = cpuidle_enter(drv, dev, next_state);
-
-	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
+	if (ret)
+		arch_cpu_idle();
 
-	if (broadcast)
-		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);
+	__current_set_polling();
 
-	/* give the governor an opportunity to reflect on the outcome */
-	cpuidle_reflect(dev, entered_state);
-out:
 	if (WARN_ON_ONCE(irqs_disabled()))
 		local_irq_enable();
 
@@ -150,16 +165,11 @@ static void cpu_idle_loop(void)
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
 		}
 
