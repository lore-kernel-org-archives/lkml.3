Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbaDPCpS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 22:45:18 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:43716 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbaDPCoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 22:44:24 -0400
From: Alex Shi <alex.shi@linaro.org>
To: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, daniel.lezcano@linaro.org, efault@gmx.de
Cc: wangyun@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mgorman@suse.de
Subject: [PATCH V5 3/8] sched: remove source_load and target_load
Date: Wed, 16 Apr 2014 10:43:24 +0800
Message-Id: <1397616209-27275-4-git-send-email-alex.shi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397616209-27275-1-git-send-email-alex.shi@linaro.org>
References: <1397616209-27275-1-git-send-email-alex.shi@linaro.org>
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
index 12a35ea..cad2b6d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1015,8 +1015,6 @@ bool should_numa_migrate_memory(struct task_struct *p, struct page * page,
 }
 
 static unsigned long weighted_cpuload(const int cpu);
-static unsigned long source_load(int cpu);
-static unsigned long target_load(int cpu);
 static unsigned long power_of(int cpu);
 static long effective_load(struct task_group *tg, int cpu, long wl, long wg);
 
@@ -3951,45 +3949,11 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
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
@@ -4202,8 +4166,8 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 
 	this_cpu  = smp_processor_id();
 	prev_cpu  = task_cpu(p);
-	load	  = source_load(prev_cpu);
-	this_load = target_load(this_cpu);
+	load	  = weighted_cpuload(prev_cpu);
+	this_load = weighted_cpuload(this_cpu);
 
 	/*
 	 * If sync wakeup then subtract the (maximum possible)
@@ -4259,7 +4223,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 
 	if (balanced ||
 	    (this_load <= load &&
-	     this_load + target_load(prev_cpu) <= tl_per_task)) {
+	     this_load + weighted_cpuload(prev_cpu) <= tl_per_task)) {
 		/*
 		 * This domain has SD_WAKE_AFFINE and
 		 * p is cache cold in this domain, and
@@ -4301,11 +4265,7 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p, int this_cpu)
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
@@ -5763,11 +5723,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
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
1.8.3.2

