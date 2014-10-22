Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbaJVOEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 10:04:09 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:60462 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764AbaJVN6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 09:58:03 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, rafael.j.wysocki@intel.com, mingo@kernel.org,
        peterz@infradead.org, preeti@linux.vnet.ibm.com,
        Morten.Rasmussen@arm.com, mturquette@linaro.org,
        tuukka.tikkanen@linaro.org, nicolas.pitre@linaro.org,
        patches@linaro.org
Subject: [RFD PATCH 03/10] sched: idle: cpudidle: Pass the latency req from idle.c
Date: Wed, 22 Oct 2014 15:57:46 +0200
Message-Id: <1413986273-28522-4-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413986273-28522-1-git-send-email-daniel.lezcano@linaro.org>
References: <1413986273-28522-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we get the latency_req from cpuidle_idle_call, just pass it to the
cpuidle layer instead of duplicating the code across the governors.

That has the benefit of moving little by little the different timings
we want to integrate with the scheduler near this one.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/cpuidle/cpuidle.c          | 5 +++--
 drivers/cpuidle/governors/ladder.c | 3 +--
 drivers/cpuidle/governors/menu.c   | 4 ++--
 include/linux/cpuidle.h            | 7 ++++---
 kernel/sched/idle.c                | 3 ++-
 5 files changed, 12 insertions(+), 10 deletions(-)

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
index a7f18e7..18f0da9 100644
--- a/drivers/cpuidle/governors/ladder.c
+++ b/drivers/cpuidle/governors/ladder.c
@@ -64,12 +64,11 @@ static inline void ladder_do_selection(struct ladder_device *ldev,
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
 
 	last_state = &ldev->states[last_idx];
 
diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 4ed3915..96f8fb0 100644
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
index 3042b924..72955e9 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -5,6 +5,7 @@
 #include <linux/cpu.h>
 #include <linux/cpuidle.h>
 #include <linux/tick.h>
+#include <linux/pm_qos.h>
 #include <linux/mm.h>
 #include <linux/stackprotector.h>
 
@@ -115,7 +116,7 @@ static void cpuidle_idle_call(void)
 	 * Ask the cpuidle framework to choose a convenient idle state.
 	 * Fall back to the default arch idle method on errors.
 	 */
-	next_state = cpuidle_select(drv, dev);
+	next_state = cpuidle_select(drv, dev, latency_req);
 	if (next_state < 0) {
 use_default:
 		/*
-- 
1.9.1

