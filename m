Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbaJVN6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 09:58:12 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:55894 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbaJVN6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 09:58:07 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, rafael.j.wysocki@intel.com, mingo@kernel.org,
        peterz@infradead.org, preeti@linux.vnet.ibm.com,
        Morten.Rasmussen@arm.com, mturquette@linaro.org,
        tuukka.tikkanen@linaro.org, nicolas.pitre@linaro.org,
        patches@linaro.org
Subject: [RFD PATCH 04/10] sched: idle: Compute next timer event and pass it the cpuidle framework
Date: Wed, 22 Oct 2014 15:57:47 +0200
Message-Id: <1413986273-28522-5-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413986273-28522-1-git-send-email-daniel.lezcano@linaro.org>
References: <1413986273-28522-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following the logic of the previous patch, retrieve from the idle task the
expected timer sleep duration and pass it to the cpuidle framework.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/cpuidle/cpuidle.c          |  4 ++--
 drivers/cpuidle/governors/ladder.c |  3 ++-
 drivers/cpuidle/governors/menu.c   |  8 ++------
 include/linux/cpuidle.h            |  8 +++++---
 kernel/sched/idle.c                | 11 +++++++++--
 5 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 372c36f..658be9f 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -159,7 +159,7 @@ int cpuidle_enter_state(struct cpuidle_device *dev, struct cpuidle_driver *drv,
  * Returns the index of the idle state.
  */
 int cpuidle_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
-		   int latency_req)
+		   int latency_req, int next_event)
 {
 	if (off || !initialized)
 		return -ENODEV;
@@ -170,7 +170,7 @@ int cpuidle_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 	if (unlikely(use_deepest_state))
 		return cpuidle_find_deepest_state(drv, dev);
 
-	return cpuidle_curr_governor->select(drv, dev, latency_req);
+	return cpuidle_curr_governor->select(drv, dev, latency_req, next_event);
 }
 
 /**
diff --git a/drivers/cpuidle/governors/ladder.c b/drivers/cpuidle/governors/ladder.c
index 18f0da9..17381c3 100644
--- a/drivers/cpuidle/governors/ladder.c
+++ b/drivers/cpuidle/governors/ladder.c
@@ -64,7 +64,8 @@ static inline void ladder_do_selection(struct ladder_device *ldev,
  * @dev: the CPU
  */
 static int ladder_select_state(struct cpuidle_driver *drv,
-			       struct cpuidle_device *dev, int latency_req)
+			       struct cpuidle_device *dev,
+			       int latency_req, int next_event)
 {
 	struct ladder_device *ldev = &__get_cpu_var(ladder_devices);
 	struct ladder_device_state *last_state;
diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 96f8fb0..9da11ce 100644
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
+		       int latency_req, int next_event)
 {
 	struct menu_device *data = &__get_cpu_var(menu_devices);
 	int i;
@@ -303,7 +299,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 	data->last_state_idx = CPUIDLE_DRIVER_STATE_START - 1;
 
 	/* determine the expected residency time, round up */
-	data->next_timer_us = ktime_to_us(tick_nohz_get_sleep_length());
+	data->next_timer_us = next_event;
 
 	get_iowait_load(&nr_iowaiters, &cpu_load);
 	data->bucket = which_bucket(data->next_timer_us, nr_iowaiters);
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index fb465c1..b379ae5 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -122,7 +122,8 @@ struct cpuidle_driver {
 extern void disable_cpuidle(void);
 
 extern int cpuidle_select(struct cpuidle_driver *drv,
-			  struct cpuidle_device *dev, int latency_req);
+			  struct cpuidle_device *dev,
+			  int latency_req, int next_event);
 extern int cpuidle_enter(struct cpuidle_driver *drv,
 			 struct cpuidle_device *dev, int index);
 extern void cpuidle_reflect(struct cpuidle_device *dev, int index);
@@ -150,7 +151,8 @@ extern struct cpuidle_driver *cpuidle_get_cpu_driver(struct cpuidle_device *dev)
 #else
 static inline void disable_cpuidle(void) { }
 static inline int cpuidle_select(struct cpuidle_driver *drv,
-				 struct cpuidle_device *dev, int latency_req)
+				 struct cpuidle_device *dev,
+				 int latency_req, int next_event)
 {return -ENODEV; }
 static inline int cpuidle_enter(struct cpuidle_driver *drv,
 				struct cpuidle_device *dev, int index)
@@ -206,7 +208,7 @@ struct cpuidle_governor {
 
 	int  (*select)		(struct cpuidle_driver *drv,
 				 struct cpuidle_device *dev,
-				 int latency_req);
+				 int latency_req, int next_event);
 	void (*reflect)		(struct cpuidle_device *dev, int index);
 
 	struct module 		*owner;
diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index 72955e9..7b6a148 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -79,8 +79,8 @@ static void cpuidle_idle_call(void)
 {
 	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
 	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
+	struct timespec t;
 	int latency_req = pm_qos_request(PM_QOS_CPU_DMA_LATENCY);
-	int next_state, entered_state;
 	unsigned int broadcast;
 
 	/*
@@ -112,11 +112,18 @@ static void cpuidle_idle_call(void)
 	if (latency_req == 0)
 		goto use_default;
 
+	t = ktime_to_timespec(tick_nohz_get_sleep_length());
+
+	/* 
+	 * The next timer event for this in us
+	 */
+	next_event = t.tv_sec * USEC_PER_SEC + t.tv_nsec / NSEC_PER_USEC;
+
 	/*
 	 * Ask the cpuidle framework to choose a convenient idle state.
 	 * Fall back to the default arch idle method on errors.
 	 */
-	next_state = cpuidle_select(drv, dev, latency_req);
+	next_state = cpuidle_select(drv, dev, latency_req, next_event);
 	if (next_state < 0) {
 use_default:
 		/*
-- 
1.9.1

