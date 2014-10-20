Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbaJTQZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 12:25:57 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:35262 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbaJTQZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 12:25:52 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: rjw@rjwysocki.net
Cc: peterz@infradead.org, nicolas.pitre@linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: [PATCH 2/5] sched: idle: Get the next timer event and pass it the cpuidle framework
Date: Mon, 20 Oct 2014 18:25:40 +0200
Message-Id: <1413822343-1972-2-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413822343-1972-1-git-send-email-daniel.lezcano@linaro.org>
References: <1413822343-1972-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following the logic of the previous patch, retrieve from the idle task the
expected timer sleep duration and pass it to the cpuidle framework.

Take the opportunity to remove the unused headers in the menu.c file.

This patch does not change the current behavior.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/cpuidle/cpuidle.c          | 11 +++++------
 drivers/cpuidle/governors/ladder.c |  3 ++-
 drivers/cpuidle/governors/menu.c   |  8 ++------
 include/linux/cpuidle.h            |  8 +++++---
 kernel/sched/idle.c                | 16 ++++++++++++----
 5 files changed, 26 insertions(+), 20 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 372c36f..64f5800 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -8,16 +8,12 @@
  * This code is licenced under the GPL.
  */
 
-#include <linux/clockchips.h>
 #include <linux/kernel.h>
 #include <linux/mutex.h>
-#include <linux/sched.h>
 #include <linux/notifier.h>
 #include <linux/pm_qos.h>
 #include <linux/cpu.h>
 #include <linux/cpuidle.h>
-#include <linux/ktime.h>
-#include <linux/hrtimer.h>
 #include <linux/module.h>
 #include <trace/events/power.h>
 
@@ -155,11 +151,13 @@ int cpuidle_enter_state(struct cpuidle_device *dev, struct cpuidle_driver *drv,
  *
  * @drv: the cpuidle driver
  * @dev: the cpuidle device
+ * @latency_req: the latency constraint when choosing an idle state
+ * @next_timer_event: the duration until the timer expires
  *
  * Returns the index of the idle state.
  */
 int cpuidle_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
-		   int latency_req)
+		   int latency_req, int next_timer_event)
 {
 	if (off || !initialized)
 		return -ENODEV;
@@ -170,7 +168,8 @@ int cpuidle_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 	if (unlikely(use_deepest_state))
 		return cpuidle_find_deepest_state(drv, dev);
 
-	return cpuidle_curr_governor->select(drv, dev, latency_req);
+	return cpuidle_curr_governor->select(drv, dev, latency_req,
+					     next_timer_event);
 }
 
 /**
diff --git a/drivers/cpuidle/governors/ladder.c b/drivers/cpuidle/governors/ladder.c
index 18f0da9..fb396d6 100644
--- a/drivers/cpuidle/governors/ladder.c
+++ b/drivers/cpuidle/governors/ladder.c
@@ -64,7 +64,8 @@ static inline void ladder_do_selection(struct ladder_device *ldev,
  * @dev: the CPU
  */
 static int ladder_select_state(struct cpuidle_driver *drv,
-			       struct cpuidle_device *dev, int latency_req)
+			       struct cpuidle_device *dev,
+			       int latency_req, int next_timer_event)
 {
 	struct ladder_device *ldev = &__get_cpu_var(ladder_devices);
 	struct ladder_device_state *last_state;
diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 96f8fb0..a17515f 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -13,10 +13,6 @@
 #include <linux/kernel.h>
 #include <linux/cpuidle.h>
 #include <linux/pm_qos.h>
-#include <linux/time.h>
-#include <linux/ktime.h>
-#include <linux/hrtimer.h>
-#include <linux/tick.h>
 #include <linux/sched.h>
 #include <linux/math64.h>
 #include <linux/module.h>
@@ -288,7 +284,7 @@ again:
  * @dev: the CPU
  */
 static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
-		       int latency_req)
+		       int latency_req, int next_timer_event)
 {
 	struct menu_device *data = &__get_cpu_var(menu_devices);
 	int i;
@@ -303,7 +299,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 	data->last_state_idx = CPUIDLE_DRIVER_STATE_START - 1;
 
 	/* determine the expected residency time, round up */
-	data->next_timer_us = ktime_to_us(tick_nohz_get_sleep_length());
+	data->next_timer_us = next_timer_event;
 
 	get_iowait_load(&nr_iowaiters, &cpu_load);
 	data->bucket = which_bucket(data->next_timer_us, nr_iowaiters);
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index fb465c1..d477746 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -122,7 +122,8 @@ struct cpuidle_driver {
 extern void disable_cpuidle(void);
 
 extern int cpuidle_select(struct cpuidle_driver *drv,
-			  struct cpuidle_device *dev, int latency_req);
+			  struct cpuidle_device *dev,
+			  int latency_req, int next_timer_event);
 extern int cpuidle_enter(struct cpuidle_driver *drv,
 			 struct cpuidle_device *dev, int index);
 extern void cpuidle_reflect(struct cpuidle_device *dev, int index);
@@ -150,7 +151,8 @@ extern struct cpuidle_driver *cpuidle_get_cpu_driver(struct cpuidle_device *dev)
 #else
 static inline void disable_cpuidle(void) { }
 static inline int cpuidle_select(struct cpuidle_driver *drv,
-				 struct cpuidle_device *dev, int latency_req)
+				 struct cpuidle_device *dev,
+				 int latency_req, int next_timer_event)
 {return -ENODEV; }
 static inline int cpuidle_enter(struct cpuidle_driver *drv,
 				struct cpuidle_device *dev, int index)
@@ -206,7 +208,7 @@ struct cpuidle_governor {
 
 	int  (*select)		(struct cpuidle_driver *drv,
 				 struct cpuidle_device *dev,
-				 int latency_req);
+				 int latency_req, int next_timer_event);
 	void (*reflect)		(struct cpuidle_device *dev, int index);
 
 	struct module 		*owner;
diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index 25ba94d..f439161 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -75,7 +75,8 @@ void __weak arch_cpu_idle(void)
  * set, and it returns with polling set.  If it ever stops polling, it
  * must clear the polling bit.
  */
-static void cpuidle_idle_call(unsigned int latency_req)
+static void cpuidle_idle_call(unsigned int latency_req,
+			      unsigned int next_timer_event)
 {
 	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
 	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
@@ -108,7 +109,7 @@ static void cpuidle_idle_call(unsigned int latency_req)
 	 * Ask the cpuidle framework to choose a convenient idle state.
 	 * Fall back to the default arch idle method on errors.
 	 */
-	next_state = cpuidle_select(drv, dev, latency_req);
+	next_state = cpuidle_select(drv, dev, latency_req, next_timer_event);
 	if (next_state < 0) {
 use_default:
 		/*
@@ -183,7 +184,7 @@ exit_idle:
  */
 static void cpu_idle_loop(void)
 {
-	unsigned int latency_req;
+	unsigned int latency_req, next_timer_event;
 
 	while (1) {
 		/*
@@ -211,6 +212,12 @@ static void cpu_idle_loop(void)
 			latency_req = pm_qos_request(PM_QOS_CPU_DMA_LATENCY);
 
 			/*
+			 * The next timer event in us
+			 */
+			next_timer_event = ktime_to_us(
+				tick_nohz_get_sleep_length());
+
+			/*
 			 * In poll mode we reenable interrupts and spin.
 			 *
 			 * If the latency req is zero, we don't want to
@@ -227,7 +234,8 @@ static void cpu_idle_loop(void)
 			    tick_check_broadcast_expired())
 				cpu_idle_poll();
 			else
-				cpuidle_idle_call(latency_req);
+				cpuidle_idle_call(latency_req,
+						  next_timer_event);
 
 			arch_cpu_idle_exit();
 		}
-- 
1.9.1

