Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbaHFNTg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 09:19:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41139 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbaHFNT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 09:19:27 -0400
From: Mel Gorman <mgorman@suse.de>
To: Rafael J Wysocki <rafael.j.wysocki@intel.com>,
        Nicolas Pitre <nico@linaro.org>
Cc: Mike Galbraith <mgalbraith@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 4/4] cpuidle: menu: Lookup CPU runqueues less
Date: Wed,  6 Aug 2014 14:19:21 +0100
Message-Id: <1407331161-4642-5-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1407331161-4642-1-git-send-email-mgorman@suse.de>
References: <1407331161-4642-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The menu governer makes separate lookups of the CPU runqueue to get
load and number of IO waiters but it can be done with a single lookup.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 drivers/cpuidle/governors/menu.c | 17 +++++++----------
 include/linux/sched.h            |  3 +--
 kernel/sched/core.c              |  7 +++++++
 kernel/sched/proc.c              |  7 -------
 4 files changed, 15 insertions(+), 19 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 90d8109..fef0225 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -135,12 +135,9 @@ struct menu_device {
 #define LOAD_INT(x) ((x) >> FSHIFT)
 #define LOAD_FRAC(x) LOAD_INT(((x) & (FIXED_1-1)) * 100)
 
-static int get_loadavg(void)
+static inline int get_loadavg(unsigned long load)
 {
-	unsigned long this = this_cpu_load();
-
-
-	return LOAD_INT(this) * 10 + LOAD_FRAC(this) / 10;
+	return LOAD_INT(load) * 10 + LOAD_FRAC(load) / 10;
 }
 
 static inline int which_bucket(unsigned int duration, unsigned long nr_iowaiters)
@@ -176,13 +173,13 @@ static inline int which_bucket(unsigned int duration, unsigned long nr_iowaiters
  * to be, the higher this multiplier, and thus the higher
  * the barrier to go to an expensive C state.
  */
-static inline int performance_multiplier(unsigned long nr_iowaiters)
+static inline int performance_multiplier(unsigned long nr_iowaiters, unsigned long load)
 {
 	int mult = 1;
 
 	/* for higher loadavg, we are more reluctant */
 
-	mult += 2 * get_loadavg();
+	mult += 2 * get_loadavg(load);
 
 	/* for IO wait tasks (per cpu!) we add 5x each */
 	mult += 10 * nr_iowaiters;
@@ -297,7 +294,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 	int latency_req = pm_qos_request(PM_QOS_CPU_DMA_LATENCY);
 	int i;
 	unsigned int interactivity_req;
-	unsigned long nr_iowaiters;
+	unsigned long nr_iowaiters, cpu_load;
 
 	if (data->needs_update) {
 		menu_update(drv, dev);
@@ -313,7 +310,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 	/* determine the expected residency time, round up */
 	data->next_timer_us = ktime_to_us(tick_nohz_get_sleep_length());
 
-	nr_iowaiters = nr_iowait_cpu(smp_processor_id());
+	get_iowait_load(&nr_iowaiters, &cpu_load);
 	data->bucket = which_bucket(data->next_timer_us, nr_iowaiters);
 
 	/*
@@ -332,7 +329,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 	 * duration / latency ratio. Adjust the latency limit if
 	 * necessary.
 	 */
-	interactivity_req = data->predicted_us / performance_multiplier(nr_iowaiters);
+	interactivity_req = data->predicted_us / performance_multiplier(nr_iowaiters, cpu_load);
 	if (latency_req > interactivity_req)
 		latency_req = interactivity_req;
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0376b05..a696d48 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -168,8 +168,7 @@ extern int nr_processes(void);
 extern unsigned long nr_running(void);
 extern unsigned long nr_iowait(void);
 extern unsigned long nr_iowait_cpu(int cpu);
-extern unsigned long this_cpu_load(void);
-
+extern void get_iowait_load(unsigned long *nr_waiters, unsigned long *load);
 
 extern void calc_global_load(unsigned long ticks);
 extern void update_cpu_load_nohz(void);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index bc1638b..cfbbbf3 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2385,6 +2385,13 @@ unsigned long nr_iowait_cpu(int cpu)
 	return atomic_read(&this->nr_iowait);
 }
 
+void get_iowait_load(unsigned long *nr_waiters, unsigned long *load)
+{
+	struct rq *this = this_rq();
+	*nr_waiters = atomic_read(&this->nr_iowait);
+	*load = this->cpu_load[0];
+}
+
 #ifdef CONFIG_SMP
 
 /*
diff --git a/kernel/sched/proc.c b/kernel/sched/proc.c
index 16f5a30..8ecd552 100644
--- a/kernel/sched/proc.c
+++ b/kernel/sched/proc.c
@@ -8,13 +8,6 @@
 
 #include "sched.h"
 
-unsigned long this_cpu_load(void)
-{
-	struct rq *this = this_rq();
-	return this->cpu_load[0];
-}
-
-
 /*
  * Global load-average calculations
  *
-- 
1.8.4.5

