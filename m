Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbaBYBwi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 20:52:38 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:53772 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbaBYBwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 20:52:32 -0500
From: Alex Shi <alex.shi@linaro.org>
To: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, daniel.lezcano@linaro.org, fweisbec@gmail.com,
        linux@arm.linux.org.uk, tony.luck@intel.com, fenghua.yu@intel.com,
        james.hogan@imgtec.com, alex.shi@linaro.org, jason.low2@hp.com,
        viresh.kumar@linaro.org, hanjun.guo@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        fengguang.wu@intel.com, linaro-kernel@lists.linaro.org,
        wangyun@linux.vnet.ibm.com, mgorman@suse.de
Subject: [PATCH 07/11] sched: replace source_load by weighted_cpuload
Date: Tue, 25 Feb 2014 09:50:50 +0800
Message-Id: <1393293054-11378-8-git-send-email-alex.shi@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1393293054-11378-1-git-send-email-alex.shi@linaro.org>
References: <1393293054-11378-1-git-send-email-alex.shi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, without load_idx source_load is just weighted_cpuload, so
replace it to reduce a conception for cpu load.

Signed-off-by: Alex Shi <alex.shi@linaro.org>
---
 kernel/sched/fair.c | 21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c5821b5..5feb51b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1015,7 +1015,6 @@ bool should_numa_migrate_memory(struct task_struct *p, struct page * page,
 }
 
 static unsigned long weighted_cpuload(const int cpu);
-static unsigned long source_load(int cpu);
 static unsigned long target_load(int cpu, int imbalance_pct);
 static unsigned long power_of(int cpu);
 static long effective_load(struct task_group *tg, int cpu, long wl, long wg);
@@ -3949,27 +3948,15 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 }
 
 #ifdef CONFIG_SMP
-/* Used instead of source_load when we know the type == 0 */
+/* weighted cpu load with runnable time, 'nice' value on CFS class */
 static unsigned long weighted_cpuload(const int cpu)
 {
 	return cpu_rq(cpu)->cfs.runnable_load_avg;
 }
 
 /*
- * Return a low guess at the load of a migration-source cpu weighted
- * according to the scheduling class and "nice" value.
- *
- * We want to under-estimate the load of migration sources, to
- * balance conservatively.
- */
-static unsigned long source_load(int cpu)
-{
-	return weighted_cpuload(cpu);
-}
-
-/*
  * Return a high guess at the load of a migration-target cpu weighted
- * according to the scheduling class and "nice" value.
+ * according to the runnable time and "nice" value.
  */
 static unsigned long target_load(int cpu, int imbalance_pct)
 {
@@ -4297,7 +4284,7 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p, int this_cpu)
 		for_each_cpu(i, sched_group_cpus(group)) {
 			/* Bias balancing toward cpus of our domain */
 			if (local_group)
-				load = source_load(i);
+				load = weighted_cpuload(i);
 			else
 				load = target_load(i, imbalance);
 
@@ -5752,7 +5739,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 		if (local_group && env->idle != CPU_IDLE)
 			load = target_load(i, bias);
 		else
-			load = source_load(i);
+			load = weighted_cpuload(i);
 
 		sgs->group_load += load;
 		sgs->sum_nr_running += rq->nr_running;
-- 
1.8.1.2

