Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbaCMGCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 02:02:30 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:54303 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbaCMGC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 02:02:29 -0400
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
Subject: [PATCH 3/8] sched: remove source_load and target_load
Date: Thu, 13 Mar 2014 13:57:24 +0800
Message-Id: <1394690249-14130-4-git-send-email-alex.shi@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1394690249-14130-1-git-send-email-alex.shi@linaro.org>
References: <1394690249-14130-1-git-send-email-alex.shi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have no load_idx any more, so source/target_load always return the
same value as weighted_cpuload. So we can remove these 2 functions.

Signed-off-by: Alex Shi <alex.shi@linaro.org>
---
 kernel/sched/fair.c | 54 +++++------------------------------------------------
 1 file changed, 5 insertions(+), 49 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 4aee391..6469907 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1015,8 +1015,6 @@ bool should_numa_migrate_memory(struct task_struct *p, struct page * page,
 }
 
 static unsigned long weighted_cpuload(const int cpu);
-static unsigned long source_load(int cpu);
-static unsigned long target_load(int cpu);
 static unsigned long power_of(int cpu);
 static long effective_load(struct task_group *tg, int cpu, long wl, long wg);
 
@@ -3950,45 +3948,11 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 }
 
 #ifdef CONFIG_SMP
-/* Used instead of source_load when we know the type == 0 */
 static unsigned long weighted_cpuload(const int cpu)
 {
 	return cpu_rq(cpu)->cfs.runnable_load_avg;
 }
 
-/*
- * Return a low guess at the load of a migration-source cpu weighted
- * according to the scheduling class and "nice" value.
- *
- * We want to under-estimate the load of migration sources, to
- * balance conservatively.
- */
-static unsigned long source_load(int cpu)
-{
-	struct rq *rq = cpu_rq(cpu);
-	unsigned long total = weighted_cpuload(cpu);
-
-	if (!sched_feat(LB_BIAS))
-		return total;
-
-	return min(rq->cpu_load, total);
-}
-
-/*
- * Return a high guess at the load of a migration-target cpu weighted
- * according to the scheduling class and "nice" value.
- */
-static unsigned long target_load(int cpu)
-{
-	struct rq *rq = cpu_rq(cpu);
-	unsigned long total = weighted_cpuload(cpu);
-
-	if (!sched_feat(LB_BIAS))
-		return total;
-
-	return max(rq->cpu_load, total);
-}
-
 static unsigned long power_of(int cpu)
 {
 	return cpu_rq(cpu)->cpu_power;
@@ -4201,8 +4165,8 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 
 	this_cpu  = smp_processor_id();
 	prev_cpu  = task_cpu(p);
-	load	  = source_load(prev_cpu);
-	this_load = target_load(this_cpu);
+	load	  = weighted_cpuload(prev_cpu);
+	this_load = weighted_cpuload(this_cpu);
 
 	/*
 	 * If sync wakeup then subtract the (maximum possible)
@@ -4258,7 +4222,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 
 	if (balanced ||
 	    (this_load <= load &&
-	     this_load + target_load(prev_cpu) <= tl_per_task)) {
+	     this_load + weighted_cpuload(prev_cpu) <= tl_per_task)) {
 		/*
 		 * This domain has SD_WAKE_AFFINE and
 		 * p is cache cold in this domain, and
@@ -4300,11 +4264,7 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p, int this_cpu)
 		avg_load = 0;
 
 		for_each_cpu(i, sched_group_cpus(group)) {
-			/* Bias balancing toward cpus of our domain */
-			if (local_group)
-				load = source_load(i);
-			else
-				load = target_load(i);
+			load = weighted_cpuload(i);
 
 			avg_load += load;
 		}
@@ -5762,11 +5722,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 	for_each_cpu_and(i, sched_group_cpus(group), env->cpus) {
 		struct rq *rq = cpu_rq(i);
 
-		/* Bias balancing toward cpus of our domain */
-		if (local_group)
-			load = target_load(i);
-		else
-			load = source_load(i);
+		load = weighted_cpuload(i);
 
 		sgs->group_load += load;
 		sgs->sum_nr_running += rq->nr_running;
-- 
1.8.1.2

