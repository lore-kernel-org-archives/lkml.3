Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbaCKMiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:38:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35575 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796AbaCKMh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:37:58 -0400
Date: Tue, 11 Mar 2014 05:37:22 -0700
From: tip-bot for Daniel Lezcano <tipbot@zytor.com>
Message-ID: <tip-30cdd69e2a266505ca8229c944d361ff350a6959@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, nicolas.pitre@linaro.org, tglx@linutronix.de,
        daniel.lezcano@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, nicolas.pitre@linaro.org, tglx@linutronix.de,
        daniel.lezcano@linaro.org
In-Reply-To: <1393832934-11625-2-git-send-email-daniel.lezcano@linaro.org>
References: <1393832934-11625-2-git-send-email-daniel.lezcano@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/idle] cpuidle/idle:
  Move the cpuidle_idle_call function to idle.c
Git-Commit-ID: 30cdd69e2a266505ca8229c944d361ff350a6959
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  30cdd69e2a266505ca8229c944d361ff350a6959
Gitweb:     http://git.kernel.org/tip/30cdd69e2a266505ca8229c944d361ff350a6959
Author:     Daniel Lezcano <daniel.lezcano@linaro.org>
AuthorDate: Mon, 3 Mar 2014 08:48:51 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 11 Mar 2014 11:52:45 +0100

cpuidle/idle: Move the cpuidle_idle_call function to idle.c

The cpuidle_idle_call does nothing more than calling the three individuals
function and is no longer used by any arch specific code but only in the
cpuidle framework code.

We can move this function into the idle task code to ensure better
proximity to the scheduler code.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: rjw@rjwysocki.net
Cc: preeti@linux.vnet.ibm.com
Link: http://lkml.kernel.org/r/1393832934-11625-2-git-send-email-daniel.lezcano@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 drivers/cpuidle/cpuidle.c | 49 -----------------------------------------
 include/linux/cpuidle.h   |  2 --
 kernel/sched/idle.c       | 56 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 56 insertions(+), 51 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 1506d69..166a732 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -173,55 +173,6 @@ void cpuidle_reflect(struct cpuidle_device *dev, int index)
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
-
-	if (broadcast)
-		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);
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
index accc2dd..8d97962 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -128,7 +128,6 @@ extern int cpuidle_enter(struct cpuidle_driver *drv,
 			 struct cpuidle_device *dev, int index);
 extern void cpuidle_reflect(struct cpuidle_device *dev, int index);
 
-extern int cpuidle_idle_call(void);
 extern int cpuidle_register_driver(struct cpuidle_driver *drv);
 extern struct cpuidle_driver *cpuidle_get_driver(void);
 extern struct cpuidle_driver *cpuidle_driver_ref(void);
@@ -160,7 +159,6 @@ static inline int cpuidle_enter(struct cpuidle_driver *drv,
 				struct cpuidle_device *dev, int index)
 {return -ENODEV; }
 static inline void cpuidle_reflect(struct cpuidle_device *dev, int index) { }
-static inline int cpuidle_idle_call(void) { return -ENODEV; }
 static inline int cpuidle_register_driver(struct cpuidle_driver *drv)
 {return -ENODEV; }
 static inline struct cpuidle_driver *cpuidle_get_driver(void) {return NULL; }
diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index b7976a1..d5aaf5e 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -63,6 +63,62 @@ void __weak arch_cpu_idle(void)
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
+	broadcast = !!(drv->states[next_state].flags & CPUIDLE_FLAG_TIMER_STOP);
+
+	if (broadcast &&
+	    clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu))
+		return -EBUSY;
+
+	trace_cpu_idle_rcuidle(next_state, dev->cpu);
+
+	entered_state = cpuidle_enter(drv, dev, next_state);
+
+	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
+
+	if (broadcast)
+		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);
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
