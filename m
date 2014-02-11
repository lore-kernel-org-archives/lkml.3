Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbaBKPMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 10:12:42 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:35636 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbaBKPLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 10:11:40 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        rjw@rjwysocki.net
Cc: nicolas.pitre@linaro.org, preeti@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] idle: Reorganize the idle loop
Date: Tue, 11 Feb 2014 16:11:29 +0100
Message-Id: <1392131491-5265-3-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392131491-5265-1-git-send-email-daniel.lezcano@linaro.org>
References: <1392131491-5265-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have the main cpuidle function in idle.c, move some code from
the idle mainloop to this function for the sake of clarity.

That removes if then else indentation difficult to follow when looking at the
code. This patch does not the change the current behavior.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 include/linux/cpuidle.h |    2 ++
 kernel/sched/idle.c     |   39 ++++++++++++++++++++-------------------
 2 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index 0befaff..a8d5bd3 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -175,6 +175,8 @@ static inline int cpuidle_enable_device(struct cpuidle_device *dev)
 {return -ENODEV; }
 static inline void cpuidle_disable_device(struct cpuidle_device *dev) { }
 static inline int cpuidle_play_dead(void) {return -ENODEV; }
+static inline struct cpuidle_driver *cpuidle_get_cpu_driver(
+	struct cpuidle_device *dev) {return NULL; }
 #endif
 
 #ifdef CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED
diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index 6963822..8b10891 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -63,7 +63,6 @@ void __weak arch_cpu_idle(void)
 	local_irq_enable();
 }
 
-#ifdef CONFIG_CPU_IDLE
 /**
  * cpuidle_idle_call - the main idle function
  *
@@ -76,17 +75,26 @@ static int cpuidle_idle_call(void)
 	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
 	int next_state, entered_state;
 
-	/* ask the governor for the next state */
+	stop_critical_timings();
+	rcu_idle_enter();
+
+	/* Ask the governor for the next state, this call can fail for
+	 * different reasons: cpuidle is not enabled or an idle state
+	 * fulfilling the constraints was not found. In this case, we fall
+	 * back to the default idle function
+	 */
 	next_state = cpuidle_select(drv, dev);
-	if (next_state < 0)
-		return next_state;
+	if (next_state < 0) {
+		arch_cpu_idle();
+		goto out;
+	}
 
 	if (need_resched()) {
 		dev->last_residency = 0;
 		/* give the governor an opportunity to reflect on the outcome */
 		cpuidle_reflect(dev, next_state);
 		local_irq_enable();
-		return 0;
+		goto out;
 	}
 
 	trace_cpu_idle_rcuidle(next_state, dev->cpu);
@@ -97,15 +105,15 @@ static int cpuidle_idle_call(void)
 
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
@@ -138,14 +146,7 @@ static void cpu_idle_loop(void)
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
-- 
1.7.9.5

