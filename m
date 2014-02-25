Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150AbaBYIJL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 03:09:11 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:54850 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbaBYIJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 03:09:03 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        rjw@rjwysocki.net
Cc: nicolas.pitre@linaro.org, preeti@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH V3 2/5] cpuidle/idle: Move the cpuidle_idle_call function to idle.c
Date: Tue, 25 Feb 2014 09:08:50 +0100
Message-Id: <1393315733-32321-2-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393315733-32321-1-git-send-email-daniel.lezcano@linaro.org>
References: <1393315733-32321-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpuidle_idle_call does nothing more than calling the three individuals
function and is no longer used by any arch specific code but only in the
cpuidle framework code. 

We can move this function into the idle task code to ensure better
proximity to the scheduler code.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>
---
 drivers/cpuidle/cpuidle.c |   48 ----------------------------------------
 include/linux/cpuidle.h   |    2 -
 kernel/sched/idle.c       |   55 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 55 insertions(+), 50 deletions(-)

Index: cpuidle-next/drivers/cpuidle/cpuidle.c
===================================================================
--- cpuidle-next.orig/drivers/cpuidle/cpuidle.c
+++ cpuidle-next/drivers/cpuidle/cpuidle.c
@@ -173,54 +173,6 @@ void cpuidle_reflect(struct cpuidle_devi
 }
 
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
-	int next_state, entered_state, ret;
-	bool broadcast;
-
-	ret = cpuidle_enabled(drv, dev);
-	if (ret < 0)
-		return ret;
-
-	/* ask the governor for the next state */
-	next_state = cpuidle_select(drv, dev);
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
-	broadcast = !!(drv->states[index].flags & CPUIDLE_FLAG_TIMER_STOP);
-
-	if (broadcast)
-		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu);
-
-	entered_state = cpuidle_enter(drv, dev, next_state);
-
-	if (broadcast)
-		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);
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
Index: cpuidle-next/include/linux/cpuidle.h
===================================================================
--- cpuidle-next.orig/include/linux/cpuidle.h
+++ cpuidle-next/include/linux/cpuidle.h
@@ -128,7 +128,6 @@ extern int cpuidle_enter(struct cpuidle_
 			 struct cpuidle_device *dev, int index);
 extern void cpuidle_reflect(struct cpuidle_device *dev, int index);
 
-extern int cpuidle_idle_call(void);
 extern int cpuidle_register_driver(struct cpuidle_driver *drv);
 extern struct cpuidle_driver *cpuidle_get_driver(void);
 extern struct cpuidle_driver *cpuidle_driver_ref(void);
@@ -160,7 +159,6 @@ static inline int cpuidle_enter(struct c
 				struct cpuidle_device *dev, int index)
 {return -ENODEV; }
 static inline void cpuidle_reflect(struct cpuidle_device *dev, int index) { }
-static inline int cpuidle_idle_call(void) { return -ENODEV; }
 static inline int cpuidle_register_driver(struct cpuidle_driver *drv)
 {return -ENODEV; }
 static inline struct cpuidle_driver *cpuidle_get_driver(void) {return NULL; }
Index: cpuidle-next/kernel/sched/idle.c
===================================================================
--- cpuidle-next.orig/kernel/sched/idle.c
+++ cpuidle-next/kernel/sched/idle.c
@@ -63,6 +63,61 @@ void __weak arch_cpu_idle(void)
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
+	int next_state, entered_state, ret;
+	bool broadcast;
+
+	ret = cpuidle_enabled(drv, dev);
+	if (ret < 0)
+		return ret;
+
+	/* ask the governor for the next state */
+	next_state = cpuidle_select(drv, dev);
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
+	broadcast = !!(drv->states[next_state].flags & CPUIDLE_FLAG_TIMER_STOP);
+
+	if (broadcast)
+		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu);
+
+	entered_state = cpuidle_enter(drv, dev, next_state);
+
+	if (broadcast)
+		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);
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
