Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637AbaA3OJa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 09:09:30 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:42060 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129AbaA3OJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 09:09:27 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: nicolas.pitre@linaro.org, peterz@infradead.org, mingo@redhat.com,
        tglx@linutronix.de, rjw@rjwysocki.net
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: [RFC PATCH 2/3] cpuidle: move the cpuidle_idle_call function to idle.c
Date: Thu, 30 Jan 2014 15:09:21 +0100
Message-Id: <1391090962-15032-3-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391090962-15032-1-git-send-email-daniel.lezcano@linaro.org>
References: <1391090962-15032-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now the cpuidle_idle_call does nothing more than calling the three individuals
function, we can move this function into the idle task code to ensure better
proximity to the scheduler code.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/cpuidle/cpuidle.c |   37 -------------------------------------
 include/linux/cpuidle.h   |    2 --
 kernel/sched/idle.c       |   44 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 44 insertions(+), 39 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index a8fbb28..a039344 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -176,43 +176,6 @@ void cpuidle_reflect(struct cpuidle_device *dev, int index)
 EXPORT_SYMBOL(cpuidle_reflect);
 
 /**
- * cpuidle_idle_call - the main idle loop
- *
- * NOTE: no locks or semaphores should be used here
- * return non-zero on failure
- */
-int cpuidle_idle_call(void)
-{
-	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
-	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
-	int next_state, entered_state;
-
-	/* ask the governor for the next state */
-	next_state = cpuidle_select(drv, dev);
-	if (next_state < 0)
-		return next_state;
-
-	if (need_resched()) {
-		dev->last_residency = 0;
-		/* give the governor an opportunity to reflect on the outcome */
-		cpuidle_reflect(dev, next_state);
-		local_irq_enable();
-		return 0;
-	}
-
-	trace_cpu_idle_rcuidle(next_state, dev->cpu);
-
-	entered_state = cpuidle_enter(drv, dev, next_state);
-
-	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
-
-	/* give the governor an opportunity to reflect on the outcome */
-	cpuidle_reflect(dev, entered_state);
-
-	return 0;
-}
-
-/**
  * cpuidle_install_idle_handler - installs the cpuidle idle loop handler
  */
 void cpuidle_install_idle_handler(void)
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index 1ebe9ff..74cdfc9 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -126,7 +126,6 @@ extern int cpuidle_enter(struct cpuidle_driver *drv,
 			 struct cpuidle_device *dev, int index);
 extern void cpuidle_reflect(struct cpuidle_device *dev, int index);
 
-extern int cpuidle_idle_call(void);
 extern int cpuidle_register_driver(struct cpuidle_driver *drv);
 extern struct cpuidle_driver *cpuidle_get_driver(void);
 extern struct cpuidle_driver *cpuidle_driver_ref(void);
@@ -148,7 +147,6 @@ extern int cpuidle_play_dead(void);
 extern struct cpuidle_driver *cpuidle_get_cpu_driver(struct cpuidle_device *dev);
 #else
 static inline void disable_cpuidle(void) { }
-static inline int cpuidle_idle_call(void) { return -ENODEV; }
 static inline int cpuidle_register_driver(struct cpuidle_driver *drv)
 {return -ENODEV; }
 static inline struct cpuidle_driver *cpuidle_get_driver(void) {return NULL; }
diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index 65d0427..3e85d38 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -62,6 +62,50 @@ void __weak arch_cpu_idle(void)
 	local_irq_enable();
 }
 
+#ifdef CONFIG_CPU_IDLE
+/**
+ * cpuidle_idle_call - the main idle function
+ *
+ * NOTE: no locks or semaphores should be used here
+ * return non-zero on failure
+ */
+static int cpuidle_idle_call(void)
+{
+	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
+	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
+	int next_state, entered_state;
+
+	/* ask the governor for the next state */
+	next_state = cpuidle_select(drv, dev);
+	if (next_state < 0)
+		return next_state;
+
+	if (need_resched()) {
+		dev->last_residency = 0;
+		/* give the governor an opportunity to reflect on the outcome */
+		cpuidle_reflect(dev, next_state);
+		local_irq_enable();
+		return 0;
+	}
+
+	trace_cpu_idle_rcuidle(next_state, dev->cpu);
+
+	entered_state = cpuidle_enter(drv, dev, next_state);
+
+	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
+
+	/* give the governor an opportunity to reflect on the outcome */
+	cpuidle_reflect(dev, entered_state);
+
+	return 0;
+}
+#else
+static inline int cpuidle_idle_call(void)
+{
+	return -ENODEV;
+}
+#endif
+
 /*
  * Generic idle loop implementation
  */
-- 
1.7.9.5

