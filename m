Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbaJTQZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 12:25:52 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:41926 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbaJTQZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 12:25:49 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: rjw@rjwysocki.net
Cc: peterz@infradead.org, nicolas.pitre@linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: [PATCH 1/5] sched: idle: cpuidle: Check the latency req before idle
Date: Mon, 20 Oct 2014 18:25:39 +0200
Message-Id: <1413822343-1972-1-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the pmqos latency requirement is set to zero that means "poll in all the
cases".

That is correctly implemented on x86 but not on the other archs.

As how is written the code, if the latency request is zero, the governor will
return zero, so corresponding, for x86, to the poll function, but for the
others arch the default idle function. For example, on ARM this is wait-for-
interrupt with a latency of '1', so violating the constraint.

In order to fix that, do the latency requirement check *before* calling the
cpuidle framework in order to jump to the poll function without entering
cpuidle. That has several benefits:

 1. It clarifies and unifies the code
 2. It fixes x86 vs other archs behavior
 3. Factors out the call to the same function
 4. Prevent to enter the cpuidle framework with its expensive cost in
    calculation

As the latency_req is needed in all the cases, change the select API to take
the latency_req as parameter in case it is not equal to zero.

As a positive side effect, it introduces the latency constraint specified
externally, so one more step to the cpuidle/scheduler integration.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/cpuidle/cpuidle.c          |  5 +++--
 drivers/cpuidle/governors/ladder.c |  9 +--------
 drivers/cpuidle/governors/menu.c   |  8 ++------
 include/linux/cpuidle.h            |  7 ++++---
 kernel/sched/idle.c                | 18 ++++++++++++++----
 5 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index ee9df5e..372c36f 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -158,7 +158,8 @@ int cpuidle_enter_state(struct cpuidle_device *dev, struct cpuidle_driver *drv,
  *
  * Returns the index of the idle state.
  */
-int cpuidle_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
+int cpuidle_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
+		   int latency_req)
 {
 	if (off || !initialized)
 		return -ENODEV;
@@ -169,7 +170,7 @@ int cpuidle_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 	if (unlikely(use_deepest_state))
 		return cpuidle_find_deepest_state(drv, dev);
 
-	return cpuidle_curr_governor->select(drv, dev);
+	return cpuidle_curr_governor->select(drv, dev, latency_req);
 }
 
 /**
diff --git a/drivers/cpuidle/governors/ladder.c b/drivers/cpuidle/governors/ladder.c
index 044ee0d..18f0da9 100644
--- a/drivers/cpuidle/governors/ladder.c
+++ b/drivers/cpuidle/governors/ladder.c
@@ -64,18 +64,11 @@ static inline void ladder_do_selection(struct ladder_device *ldev,
  * @dev: the CPU
  */
 static int ladder_select_state(struct cpuidle_driver *drv,
-				struct cpuidle_device *dev)
+			       struct cpuidle_device *dev, int latency_req)
 {
 	struct ladder_device *ldev = &__get_cpu_var(ladder_devices);
 	struct ladder_device_state *last_state;
 	int last_residency, last_idx = ldev->last_state_idx;
-	int latency_req = pm_qos_request(PM_QOS_CPU_DMA_LATENCY);
-
-	/* Special case when user has set very strict latency requirement */
-	if (unlikely(latency_req == 0)) {
-		ladder_do_selection(ldev, last_idx, 0);
-		return 0;
-	}
 
 	last_state = &ldev->states[last_idx];
 
diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 34db2fb..96f8fb0 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -287,10 +287,10 @@ again:
  * @drv: cpuidle driver containing state data
  * @dev: the CPU
  */
-static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
+static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
+		       int latency_req)
 {
 	struct menu_device *data = &__get_cpu_var(menu_devices);
-	int latency_req = pm_qos_request(PM_QOS_CPU_DMA_LATENCY);
 	int i;
 	unsigned int interactivity_req;
 	unsigned long nr_iowaiters, cpu_load;
@@ -302,10 +302,6 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 
 	data->last_state_idx = CPUIDLE_DRIVER_STATE_START - 1;
 
-	/* Special case when user has set very strict latency requirement */
-	if (unlikely(latency_req == 0))
-		return 0;
-
 	/* determine the expected residency time, round up */
 	data->next_timer_us = ktime_to_us(tick_nohz_get_sleep_length());
 
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index 25e0df6..fb465c1 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -122,7 +122,7 @@ struct cpuidle_driver {
 extern void disable_cpuidle(void);
 
 extern int cpuidle_select(struct cpuidle_driver *drv,
-			  struct cpuidle_device *dev);
+			  struct cpuidle_device *dev, int latency_req);
 extern int cpuidle_enter(struct cpuidle_driver *drv,
 			 struct cpuidle_device *dev, int index);
 extern void cpuidle_reflect(struct cpuidle_device *dev, int index);
@@ -150,7 +150,7 @@ extern struct cpuidle_driver *cpuidle_get_cpu_driver(struct cpuidle_device *dev)
 #else
 static inline void disable_cpuidle(void) { }
 static inline int cpuidle_select(struct cpuidle_driver *drv,
-				 struct cpuidle_device *dev)
+				 struct cpuidle_device *dev, int latency_req)
 {return -ENODEV; }
 static inline int cpuidle_enter(struct cpuidle_driver *drv,
 				struct cpuidle_device *dev, int index)
@@ -205,7 +205,8 @@ struct cpuidle_governor {
 					struct cpuidle_device *dev);
 
 	int  (*select)		(struct cpuidle_driver *drv,
-					struct cpuidle_device *dev);
+				 struct cpuidle_device *dev,
+				 int latency_req);
 	void (*reflect)		(struct cpuidle_device *dev, int index);
 
 	struct module 		*owner;
diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index 11e7bc4..25ba94d 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -5,6 +5,7 @@
 #include <linux/cpu.h>
 #include <linux/cpuidle.h>
 #include <linux/tick.h>
+#include <linux/pm_qos.h>
 #include <linux/mm.h>
 #include <linux/stackprotector.h>
 
@@ -74,7 +75,7 @@ void __weak arch_cpu_idle(void)
  * set, and it returns with polling set.  If it ever stops polling, it
  * must clear the polling bit.
  */
-static void cpuidle_idle_call(void)
+static void cpuidle_idle_call(unsigned int latency_req)
 {
 	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
 	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
@@ -107,7 +108,7 @@ static void cpuidle_idle_call(void)
 	 * Ask the cpuidle framework to choose a convenient idle state.
 	 * Fall back to the default arch idle method on errors.
 	 */
-	next_state = cpuidle_select(drv, dev);
+	next_state = cpuidle_select(drv, dev, latency_req);
 	if (next_state < 0) {
 use_default:
 		/*
@@ -182,6 +183,8 @@ exit_idle:
  */
 static void cpu_idle_loop(void)
 {
+	unsigned int latency_req;
+
 	while (1) {
 		/*
 		 * If the arch has a polling bit, we maintain an invariant:
@@ -205,19 +208,26 @@ static void cpu_idle_loop(void)
 			local_irq_disable();
 			arch_cpu_idle_enter();
 
+			latency_req = pm_qos_request(PM_QOS_CPU_DMA_LATENCY);
+
 			/*
 			 * In poll mode we reenable interrupts and spin.
 			 *
+			 * If the latency req is zero, we don't want to
+			 * enter any idle state and we jump to the poll
+			 * function directly
+			 *
 			 * Also if we detected in the wakeup from idle
 			 * path that the tick broadcast device expired
 			 * for us, we don't want to go deep idle as we
 			 * know that the IPI is going to arrive right
 			 * away
 			 */
-			if (cpu_idle_force_poll || tick_check_broadcast_expired())
+			if (!latency_req || cpu_idle_force_poll ||
+			    tick_check_broadcast_expired())
 				cpu_idle_poll();
 			else
-				cpuidle_idle_call();
+				cpuidle_idle_call(latency_req);
 
 			arch_cpu_idle_exit();
 		}
-- 
1.9.1

