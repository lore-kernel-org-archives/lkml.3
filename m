Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbaBXN4t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 08:56:49 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:47917 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbaBXNzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 08:55:55 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        rjw@rjwysocki.net
Cc: nicolas.pitre@linaro.org, preeti@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 3/5] idle: Reorganize the idle loop
Date: Mon, 24 Feb 2014 14:55:49 +0100
Message-Id: <1393250151-6982-3-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393250151-6982-1-git-send-email-daniel.lezcano@linaro.org>
References: <1393250151-6982-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have the main cpuidle function in idle.c, move some code from
the idle mainloop to this function for the sake of clarity.

That removes if then else indentation difficult to follow when looking at the
code. This patch does not change the current behavior.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Acked-by: Nicolas Pitre <nico@linaro.org>
---

Changelog:

V2:
   * fixed type in patch's description

---
 include/linux/cpuidle.h |    2 ++
 kernel/sched/idle.c     |   40 +++++++++++++++++++++-------------------
 2 files changed, 23 insertions(+), 19 deletions(-)

Index: cpuidle-next/include/linux/cpuidle.h
===================================================================
--- cpuidle-next.orig/include/linux/cpuidle.h
+++ cpuidle-next/include/linux/cpuidle.h
@@ -180,6 +180,8 @@ static inline int cpuidle_enable_device(
 {return -ENODEV; }
 static inline void cpuidle_disable_device(struct cpuidle_device *dev) { }
 static inline int cpuidle_play_dead(void) {return -ENODEV; }
+static inline struct cpuidle_driver *cpuidle_get_cpu_driver(
+	struct cpuidle_device *dev) {return NULL; }
 #endif
 
 #ifdef CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED
Index: cpuidle-next/kernel/sched/idle.c
===================================================================
--- cpuidle-next.orig/kernel/sched/idle.c
+++ cpuidle-next/kernel/sched/idle.c
@@ -63,7 +63,6 @@ void __weak arch_cpu_idle(void)
 	local_irq_enable();
 }
 
-#ifdef CONFIG_CPU_IDLE
 /**
  * cpuidle_idle_call - the main idle function
  *
@@ -76,11 +75,21 @@ static int cpuidle_idle_call(void)
 	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
 	int next_state, entered_state;
 
+	stop_critical_timings();
+	rcu_idle_enter();
+
 	next_state = cpuidle_enabled(drv, dev);
-	if (next_state < 0)
-		return next_state;
+	if (next_state < 0) {
+		arch_cpu_idle();
+		goto out;
+	}
 
-	/* ask the governor for the next state */
+	/*
+	 * Ask the governor for the next state, this call can fail for
+	 * different reasons: cpuidle is not enabled or an idle state
+	 * fulfilling the constraints was not found. In this case, we
+	 * fall back to the default idle function
+	 */
 	next_state = cpuidle_select(drv, dev);
 
 	if (need_resched()) {
@@ -88,7 +97,7 @@ static int cpuidle_idle_call(void)
 		/* give the governor an opportunity to reflect on the outcome */
 		cpuidle_reflect(dev, next_state);
 		local_irq_enable();
-		return 0;
+		goto out;
 	}
 
 	trace_cpu_idle_rcuidle(next_state, dev->cpu);
@@ -99,15 +108,15 @@ static int cpuidle_idle_call(void)
 
 	/* give the governor an opportunity to reflect on the outcome */
 	cpuidle_reflect(dev, entered_state);
+out:
+	if (WARN_ON_ONCE(irqs_disabled()))
+		local_irq_enable();
+
+	rcu_idle_exit();
+	start_critical_timings();
 
 	return 0;
 }
-#else
-static inline int cpuidle_idle_call(void)
-{
-	return -ENODEV;
-}
-#endif
 
 /*
  * Generic idle loop implementation
@@ -140,14 +149,7 @@ static void cpu_idle_loop(void)
 				cpu_idle_poll();
 			} else {
 				if (!current_clr_polling_and_test()) {
-					stop_critical_timings();
-					rcu_idle_enter();
-					if (cpuidle_idle_call())
-						arch_cpu_idle();
-					if (WARN_ON_ONCE(irqs_disabled()))
-						local_irq_enable();
-					rcu_idle_exit();
-					start_critical_timings();
+					cpuidle_idle_call();
 				} else {
 					local_irq_enable();
 				}
