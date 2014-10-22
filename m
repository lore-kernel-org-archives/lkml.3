Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997AbaJVN6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 09:58:18 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:35955 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbaJVN6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 09:58:11 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, rafael.j.wysocki@intel.com, mingo@kernel.org,
        peterz@infradead.org, preeti@linux.vnet.ibm.com,
        Morten.Rasmussen@arm.com, mturquette@linaro.org,
        tuukka.tikkanen@linaro.org, nicolas.pitre@linaro.org,
        patches@linaro.org
Subject: [RFD PATCH 06/10] sched: idle: Add io latency information for the next event
Date: Wed, 22 Oct 2014 15:57:49 +0200
Message-Id: <1413986273-28522-7-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413986273-28522-1-git-send-email-daniel.lezcano@linaro.org>
References: <1413986273-28522-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we want to improve the sleep duration estimation, the IO latency expected
duration is passed to the cpuidle framework. The governors will have to deal
with if they are interested in this information.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/cpuidle/cpuidle.c          |  4 ++--
 drivers/cpuidle/governors/ladder.c |  3 ++-
 drivers/cpuidle/governors/menu.c   |  5 +++--
 include/linux/cpuidle.h            | 12 +++++++++---
 kernel/sched/idle.c                | 27 ++++++++++++++++-----------
 5 files changed, 32 insertions(+), 19 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 1abd5a0..bf42e17 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -155,7 +155,7 @@ int cpuidle_enter_state(struct cpuidle_device *dev, struct cpuidle_driver *drv,
  * Returns the index of the idle state.
  */
 int cpuidle_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
-		   int latency_req, int next_event)
+		   struct cpuidle_times *times)
 {
 	if (off || !initialized)
 		return -ENODEV;
@@ -166,7 +166,7 @@ int cpuidle_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 	if (unlikely(use_deepest_state))
 		return cpuidle_find_deepest_state(drv, dev);
 
-	return cpuidle_curr_governor->select(drv, dev, latency_req, next_event);
+	return cpuidle_curr_governor->select(drv, dev, times);
 }
 
 /**
diff --git a/drivers/cpuidle/governors/ladder.c b/drivers/cpuidle/governors/ladder.c
index 17381c3..a84993c 100644
--- a/drivers/cpuidle/governors/ladder.c
+++ b/drivers/cpuidle/governors/ladder.c
@@ -65,10 +65,11 @@ static inline void ladder_do_selection(struct ladder_device *ldev,
  */
 static int ladder_select_state(struct cpuidle_driver *drv,
 			       struct cpuidle_device *dev,
-			       int latency_req, int next_event)
+			       struct cpuidle_times *times)
 {
 	struct ladder_device *ldev = &__get_cpu_var(ladder_devices);
 	struct ladder_device_state *last_state;
+	int latency_req = times->latency_req;
 	int last_residency, last_idx = ldev->last_state_idx;
 
 	last_state = &ldev->states[last_idx];
diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 9da11ce..88382d5 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -284,9 +284,10 @@ again:
  * @dev: the CPU
  */
 static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
-		       int latency_req, int next_event)
+		       struct cpuidle_times *times)
 {
 	struct menu_device *data = &__get_cpu_var(menu_devices);
+	int latency_req = times->latency_req;
 	int i;
 	unsigned int interactivity_req;
 	unsigned long nr_iowaiters, cpu_load;
@@ -299,7 +300,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 	data->last_state_idx = CPUIDLE_DRIVER_STATE_START - 1;
 
 	/* determine the expected residency time, round up */
-	data->next_timer_us = next_event;
+	data->next_timer_us = times->next_timer_event;
 
 	get_iowait_load(&nr_iowaiters, &cpu_load);
 	data->bucket = which_bucket(data->next_timer_us, nr_iowaiters);
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index b379ae5..e99823f 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -83,6 +83,12 @@ struct cpuidle_device {
 #endif
 };
 
+struct cpuidle_times {
+	unsigned int latency_req;
+	unsigned int next_timer_event;
+	unsigned int next_io_event;
+};
+
 DECLARE_PER_CPU(struct cpuidle_device *, cpuidle_devices);
 DECLARE_PER_CPU(struct cpuidle_device, cpuidle_dev);
 
@@ -123,7 +129,7 @@ extern void disable_cpuidle(void);
 
 extern int cpuidle_select(struct cpuidle_driver *drv,
 			  struct cpuidle_device *dev,
-			  int latency_req, int next_event);
+			  struct cpuidle_times *times);
 extern int cpuidle_enter(struct cpuidle_driver *drv,
 			 struct cpuidle_device *dev, int index);
 extern void cpuidle_reflect(struct cpuidle_device *dev, int index);
@@ -152,7 +158,7 @@ extern struct cpuidle_driver *cpuidle_get_cpu_driver(struct cpuidle_device *dev)
 static inline void disable_cpuidle(void) { }
 static inline int cpuidle_select(struct cpuidle_driver *drv,
 				 struct cpuidle_device *dev,
-				 int latency_req, int next_event)
+				 struct cpuidle_times *times)
 {return -ENODEV; }
 static inline int cpuidle_enter(struct cpuidle_driver *drv,
 				struct cpuidle_device *dev, int index)
@@ -208,7 +214,7 @@ struct cpuidle_governor {
 
 	int  (*select)		(struct cpuidle_driver *drv,
 				 struct cpuidle_device *dev,
-				 int latency_req, int next_event);
+				 struct cpuidle_times *times);
 	void (*reflect)		(struct cpuidle_device *dev, int index);
 
 	struct module 		*owner;
diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index 7b6a148..6057020 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -4,7 +4,7 @@
 #include <linux/sched.h>
 #include <linux/cpu.h>
 #include <linux/cpuidle.h>
-#include <linux/tick.h>
+#include <linux/ktime.h>
 #include <linux/pm_qos.h>
 #include <linux/mm.h>
 #include <linux/stackprotector.h>
@@ -14,6 +14,7 @@
 #include <trace/events/power.h>
 
 #include "sched.h"
+#include "io_latency.h"
 
 static int __read_mostly cpu_idle_force_poll;
 
@@ -79,9 +80,9 @@ static void cpuidle_idle_call(void)
 {
 	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
 	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
-	struct timespec t;
-	int latency_req = pm_qos_request(PM_QOS_CPU_DMA_LATENCY);
-	unsigned int broadcast;
+	struct cpuidle_times times;
+	int next_state, entered_state;
+	bool broadcast;
 
 	/*
 	 * Check if the idle task must be rescheduled. If it is the
@@ -105,25 +106,29 @@ static void cpuidle_idle_call(void)
 	 */
 	rcu_idle_enter();
 
+	times.latency_req = pm_qos_request(PM_QOS_CPU_DMA_LATENCY);
 	/*
 	 * The latency requirement does not allow any latency, jump to
-	 * the default idle function
+	 * the default idle function without entering the cpuidle code
 	 */
-	if (latency_req == 0)
+	if (times.latency_req == 0)
 		goto use_default;
 
-	t = ktime_to_timespec(tick_nohz_get_sleep_length());
+	/*
+	 * Retrieve the next timer event
+	 */
+	times.next_timer_event = ktime_to_us(tick_nohz_get_sleep_length());
 
-	/* 
-	 * The next timer event for this in us
+	/*
+	 * Retrieve the next IO guessed event 
 	 */
-	next_event = t.tv_sec * USEC_PER_SEC + t.tv_nsec / NSEC_PER_USEC;
+	times.next_io_event = io_latency_get_sleep_length(this_rq());
 
 	/*
 	 * Ask the cpuidle framework to choose a convenient idle state.
 	 * Fall back to the default arch idle method on errors.
 	 */
-	next_state = cpuidle_select(drv, dev, latency_req, next_event);
+	next_state = cpuidle_select(drv, dev, &times);
 	if (next_state < 0) {
 use_default:
 		/*
-- 
1.9.1

