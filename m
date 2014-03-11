Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbaCKMhs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:37:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35563 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796AbaCKMhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:37:45 -0400
Date: Tue, 11 Mar 2014 05:37:10 -0700
From: tip-bot for Daniel Lezcano <tipbot@zytor.com>
Message-ID: <tip-907e30f1bb4a9656d351aa705c1e5931da908701@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, nico@linaro.org, tglx@linutronix.de,
        daniel.lezcano@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, nico@linaro.org, tglx@linutronix.de,
        daniel.lezcano@linaro.org
In-Reply-To: <1393832934-11625-1-git-send-email-daniel.lezcano@linaro.org>
References: <1393832934-11625-1-git-send-email-daniel.lezcano@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/idle] idle/cpuidle:
  Split cpuidle_idle_call main function into smaller functions
Git-Commit-ID: 907e30f1bb4a9656d351aa705c1e5931da908701
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

Commit-ID:  907e30f1bb4a9656d351aa705c1e5931da908701
Gitweb:     http://git.kernel.org/tip/907e30f1bb4a9656d351aa705c1e5931da908701
Author:     Daniel Lezcano <daniel.lezcano@linaro.org>
AuthorDate: Mon, 3 Mar 2014 08:48:50 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 11 Mar 2014 11:52:45 +0100

idle/cpuidle: Split cpuidle_idle_call main function into smaller functions

In order to allow better integration between the cpuidle framework and the
scheduler, reducing the distance between these two sub-components will
facilitate this integration by moving part of the cpuidle code in the idle
task file and, because idle.c is in the sched directory, we have access to
the scheduler's private structures.

This patch splits the cpuidle_idle_call main entry function into 3 calls
to a newly added API:

 1. select the idle state
 2. enter the idle state
 3. reflect the idle state

The cpuidle_idle_call calls these three functions to implement the main
idle entry function.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Acked-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: rjw@rjwysocki.net
Cc: preeti@linux.vnet.ibm.com
Link: http://lkml.kernel.org/r/1393832934-11625-1-git-send-email-daniel.lezcano@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 drivers/cpuidle/cpuidle.c | 96 ++++++++++++++++++++++++++++++++++++-----------
 include/linux/cpuidle.h   | 19 ++++++++++
 2 files changed, 94 insertions(+), 21 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 09d05ab..1506d69 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -65,6 +65,26 @@ int cpuidle_play_dead(void)
 }
 
 /**
+ * cpuidle_enabled - check if the cpuidle framework is ready
+ * @dev: cpuidle device for this cpu
+ * @drv: cpuidle driver for this cpu
+ *
+ * Return 0 on success, otherwise:
+ * -NODEV : the cpuidle framework is not available
+ * -EBUSY : the cpuidle framework is not initialized
+ */
+int cpuidle_enabled(struct cpuidle_driver *drv, struct cpuidle_device *dev)
+{
+	if (off || !initialized)
+		return -ENODEV;
+
+	if (!drv || !dev || !dev->enabled)
+		return -EBUSY;
+
+	return 0;
+}
+
+/**
  * cpuidle_enter_state - enter the state and update stats
  * @dev: cpuidle device for this cpu
  * @drv: cpuidle driver for this cpu
@@ -108,6 +128,51 @@ int cpuidle_enter_state(struct cpuidle_device *dev, struct cpuidle_driver *drv,
 }
 
 /**
+ * cpuidle_select - ask the cpuidle framework to choose an idle state
+ *
+ * @drv: the cpuidle driver
+ * @dev: the cpuidle device
+ *
+ * Returns the index of the idle state.
+ */
+int cpuidle_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
+{
+	return cpuidle_curr_governor->select(drv, dev);
+}
+
+/**
+ * cpuidle_enter - enter into the specified idle state
+ *
+ * @drv:   the cpuidle driver tied with the cpu
+ * @dev:   the cpuidle device
+ * @index: the index in the idle state table
+ *
+ * Returns the index in the idle state, < 0 in case of error.
+ * The error code depends on the backend driver
+ */
+int cpuidle_enter(struct cpuidle_driver *drv, struct cpuidle_device *dev,
+		  int index)
+{
+	if (cpuidle_state_is_coupled(dev, drv, index))
+		return cpuidle_enter_state_coupled(dev, drv, index);
+	return cpuidle_enter_state(dev, drv, index);
+}
+
+/**
+ * cpuidle_reflect - tell the underlying governor what was the state
+ * we were in
+ *
+ * @dev  : the cpuidle device
+ * @index: the index in the idle state table
+ *
+ */
+void cpuidle_reflect(struct cpuidle_device *dev, int index)
+{
+	if (cpuidle_curr_governor->reflect)
+		cpuidle_curr_governor->reflect(dev, index);
+}
+
+/**
  * cpuidle_idle_call - the main idle loop
  *
  * NOTE: no locks or semaphores should be used here
@@ -116,26 +181,21 @@ int cpuidle_enter_state(struct cpuidle_device *dev, struct cpuidle_driver *drv,
 int cpuidle_idle_call(void)
 {
 	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
-	struct cpuidle_driver *drv;
-	int next_state, entered_state;
+	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
+	int next_state, entered_state, ret;
 	bool broadcast;
 
-	if (off || !initialized)
-		return -ENODEV;
-
-	/* check if the device is ready */
-	if (!dev || !dev->enabled)
-		return -EBUSY;
-
-	drv = cpuidle_get_cpu_driver(dev);
+	ret = cpuidle_enabled(drv, dev);
+	if (ret < 0)
+		return ret;
 
 	/* ask the governor for the next state */
-	next_state = cpuidle_curr_governor->select(drv, dev);
+	next_state = cpuidle_select(drv, dev);
+
 	if (need_resched()) {
 		dev->last_residency = 0;
 		/* give the governor an opportunity to reflect on the outcome */
-		if (cpuidle_curr_governor->reflect)
-			cpuidle_curr_governor->reflect(dev, next_state);
+		cpuidle_reflect(dev, next_state);
 		local_irq_enable();
 		return 0;
 	}
@@ -146,14 +206,9 @@ int cpuidle_idle_call(void)
 	    clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu))
 		return -EBUSY;
 
-
 	trace_cpu_idle_rcuidle(next_state, dev->cpu);
 
-	if (cpuidle_state_is_coupled(dev, drv, next_state))
-		entered_state = cpuidle_enter_state_coupled(dev, drv,
-							    next_state);
-	else
-		entered_state = cpuidle_enter_state(dev, drv, next_state);
+	entered_state = cpuidle_enter(drv, dev, next_state);
 
 	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
 
@@ -161,8 +216,7 @@ int cpuidle_idle_call(void)
 		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);
 
 	/* give the governor an opportunity to reflect on the outcome */
-	if (cpuidle_curr_governor->reflect)
-		cpuidle_curr_governor->reflect(dev, entered_state);
+	cpuidle_reflect(dev, entered_state);
 
 	return 0;
 }
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index 50fcbb0..accc2dd 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -119,6 +119,15 @@ struct cpuidle_driver {
 
 #ifdef CONFIG_CPU_IDLE
 extern void disable_cpuidle(void);
+
+extern int cpuidle_enabled(struct cpuidle_driver *drv,
+			  struct cpuidle_device *dev);
+extern int cpuidle_select(struct cpuidle_driver *drv,
+			  struct cpuidle_device *dev);
+extern int cpuidle_enter(struct cpuidle_driver *drv,
+			 struct cpuidle_device *dev, int index);
+extern void cpuidle_reflect(struct cpuidle_device *dev, int index);
+
 extern int cpuidle_idle_call(void);
 extern int cpuidle_register_driver(struct cpuidle_driver *drv);
 extern struct cpuidle_driver *cpuidle_get_driver(void);
@@ -141,6 +150,16 @@ extern int cpuidle_play_dead(void);
 extern struct cpuidle_driver *cpuidle_get_cpu_driver(struct cpuidle_device *dev);
 #else
 static inline void disable_cpuidle(void) { }
+static inline int cpuidle_enabled(struct cpuidle_driver *drv,
+				  struct cpuidle_device *dev)
+{return -ENODEV; }
+static inline int cpuidle_select(struct cpuidle_driver *drv,
+				 struct cpuidle_device *dev)
+{return -ENODEV; }
+static inline int cpuidle_enter(struct cpuidle_driver *drv,
+				struct cpuidle_device *dev, int index)
+{return -ENODEV; }
+static inline void cpuidle_reflect(struct cpuidle_device *dev, int index) { }
 static inline int cpuidle_idle_call(void) { return -ENODEV; }
 static inline int cpuidle_register_driver(struct cpuidle_driver *drv)
 {return -ENODEV; }
