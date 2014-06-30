Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbaF3QH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:07:59 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:46158 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756570AbaF3QHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:07:05 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org
Cc: preeti@linux.vnet.ibm.com, Morten.Rasmussen@arm.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org, dietmar.eggemann@arm.com,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v3 11/12] sched: replace capacity_factor by utilization
Date: Mon, 30 Jun 2014 18:05:42 +0200
Message-Id: <1404144343-18720-12-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org>
References: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The scheduler tries to compute how many tasks a group of CPUs can handle by
assuming that a task's load is SCHED_LOAD_SCALE and a CPU capacity is
SCHED_POWER_SCALE.
We can have a better idea of the capacity of a group of CPUs and of the
utilization of this group thanks to the rework of group_power_orig and
group_utilization. We can deduct how many capacity is still available.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/fair.c | 107 +++++++++++++++++++---------------------------------
 1 file changed, 38 insertions(+), 69 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a6b4b25..cf65284 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5534,13 +5534,13 @@ struct sg_lb_stats {
 	unsigned long sum_weighted_load; /* Weighted load of group's tasks */
 	unsigned long load_per_task;
 	unsigned long group_capacity;
+	unsigned long group_capacity_orig;
 	unsigned long group_utilization; /* Total utilization of the group */
 	unsigned int sum_nr_running; /* Nr tasks running in the group */
-	unsigned int group_capacity_factor;
 	unsigned int idle_cpus;
 	unsigned int group_weight;
 	int group_imb; /* Is there an imbalance in the group ? */
-	int group_has_free_capacity;
+	int group_out_of_capacity;
 #ifdef CONFIG_NUMA_BALANCING
 	unsigned int nr_numa_running;
 	unsigned int nr_preferred_running;
@@ -5781,31 +5781,6 @@ void update_group_capacity(struct sched_domain *sd, int cpu)
 }
 
 /*
- * Try and fix up capacity for tiny siblings, this is needed when
- * things like SD_ASYM_PACKING need f_b_g to select another sibling
- * which on its own isn't powerful enough.
- *
- * See update_sd_pick_busiest() and check_asym_packing().
- */
-static inline int
-fix_small_capacity(struct sched_domain *sd, struct sched_group *group)
-{
-	/*
-	 * Only siblings can have significantly less than SCHED_CAPACITY_SCALE
-	 */
-	if (!(sd->flags & SD_SHARE_CPUCAPACITY))
-		return 0;
-
-	/*
-	 * If ~90% of the cpu_capacity is still there, we're good.
-	 */
-	if (group->sgc->capacity * 32 > group->sgc->capacity_orig * 29)
-		return 1;
-
-	return 0;
-}
-
-/*
  * Group imbalance indicates (and tries to solve) the problem where balancing
  * groups is inadequate due to tsk_cpus_allowed() constraints.
  *
@@ -5839,32 +5814,24 @@ static inline int sg_imbalanced(struct sched_group *group)
 	return group->sgc->imbalance;
 }
 
-/*
- * Compute the group capacity factor.
- *
- * Avoid the issue where N*frac(smt_capacity) >= 1 creates 'phantom' cores by
- * first dividing out the smt factor and computing the actual number of cores
- * and limit unit capacity with that.
- */
-static inline int sg_capacity_factor(struct lb_env *env, struct sched_group *group)
+static inline int group_has_free_capacity(struct sg_lb_stats *sgs,
+			struct lb_env *env)
 {
-	unsigned int capacity_factor, smt, cpus;
-	unsigned int capacity, capacity_orig;
-
-	capacity = group->sgc->capacity;
-	capacity_orig = group->sgc->capacity_orig;
-	cpus = group->group_weight;
+	if ((sgs->group_capacity_orig * 100) > (sgs->group_utilization * env->sd->imbalance_pct)
+	|| (sgs->sum_nr_running < sgs->group_weight))
+		return 1;
 
-	/* smt := ceil(cpus / capacity), assumes: 1 < smt_capacity < 2 */
-	smt = DIV_ROUND_UP(SCHED_CAPACITY_SCALE * cpus, capacity_orig);
-	capacity_factor = cpus / smt; /* cores */
+	return 0;
+}
 
-	capacity_factor = min_t(unsigned,
-		capacity_factor, DIV_ROUND_CLOSEST(capacity, SCHED_CAPACITY_SCALE));
-	if (!capacity_factor)
-		capacity_factor = fix_small_capacity(env->sd, group);
+static inline int group_is_overloaded(struct sg_lb_stats *sgs,
+			struct lb_env *env)
+{
+	if ((sgs->group_capacity_orig * 100) < (sgs->group_utilization * env->sd->imbalance_pct)
+	&& (sgs->sum_nr_running > sgs->group_weight))
+		return 1;
 
-	return capacity_factor;
+	return 0;
 }
 
 /**
@@ -5905,6 +5872,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 			sgs->idle_cpus++;
 	}
 
+	sgs->group_capacity_orig = group->sgc->capacity_orig;
 	/* Adjust by relative CPU capacity of the group */
 	sgs->group_capacity = group->sgc->capacity;
 	sgs->avg_load = (sgs->group_load*SCHED_CAPACITY_SCALE) / sgs->group_capacity;
@@ -5915,10 +5883,8 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 	sgs->group_weight = group->group_weight;
 
 	sgs->group_imb = sg_imbalanced(group);
-	sgs->group_capacity_factor = sg_capacity_factor(env, group);
 
-	if (sgs->group_capacity_factor > sgs->sum_nr_running)
-		sgs->group_has_free_capacity = 1;
+	sgs->group_out_of_capacity = group_is_overloaded(sgs, env);
 }
 
 /**
@@ -5942,7 +5908,7 @@ static bool update_sd_pick_busiest(struct lb_env *env,
 	if (sgs->avg_load <= sds->busiest_stat.avg_load)
 		return false;
 
-	if (sgs->sum_nr_running > sgs->group_capacity_factor)
+	if (sgs->group_out_of_capacity)
 		return true;
 
 	if (sgs->group_imb)
@@ -6041,17 +6007,20 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
 
 		/*
 		 * In case the child domain prefers tasks go to siblings
-		 * first, lower the sg capacity factor to one so that we'll try
+		 * first, lower the sg capacity to one so that we'll try
 		 * and move all the excess tasks away. We lower the capacity
 		 * of a group only if the local group has the capacity to fit
-		 * these excess tasks, i.e. nr_running < group_capacity_factor. The
+		 * these excess tasks, i.e. group_capacity > 0. The
 		 * extra check prevents the case where you always pull from the
 		 * heaviest group when it is already under-utilized (possible
 		 * with a large weight task outweighs the tasks on the system).
 		 */
 		if (prefer_sibling && sds->local &&
-		    sds->local_stat.group_has_free_capacity)
-			sgs->group_capacity_factor = min(sgs->group_capacity_factor, 1U);
+		    group_has_free_capacity(&sds->local_stat, env)) {
+			if (sgs->sum_nr_running > 1)
+				sgs->group_out_of_capacity = 1;
+			sgs->group_capacity = min(sgs->group_capacity, SCHED_CAPACITY_SCALE);
+		}
 
 		if (update_sd_pick_busiest(env, sds, sg, sgs)) {
 			sds->busiest = sg;
@@ -6223,11 +6192,11 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 		 * Except of course for the group_imb case, since then we might
 		 * have to drop below capacity to reach cpu-load equilibrium.
 		 */
-		load_above_capacity =
-			(busiest->sum_nr_running - busiest->group_capacity_factor);
-
-		load_above_capacity *= (SCHED_LOAD_SCALE * SCHED_CAPACITY_SCALE);
-		load_above_capacity /= busiest->group_capacity;
+		load_above_capacity = busiest->sum_nr_running * SCHED_LOAD_SCALE;
+		if (load_above_capacity > busiest->group_capacity)
+			load_above_capacity -= busiest->group_capacity;
+		else
+			load_above_capacity = ~0UL;
 	}
 
 	/*
@@ -6290,6 +6259,7 @@ static struct sched_group *find_busiest_group(struct lb_env *env)
 	local = &sds.local_stat;
 	busiest = &sds.busiest_stat;
 
+	/* ASYM feature bypasses nice load balance check */
 	if ((env->idle == CPU_IDLE || env->idle == CPU_NEWLY_IDLE) &&
 	    check_asym_packing(env, &sds))
 		return sds.busiest;
@@ -6310,8 +6280,8 @@ static struct sched_group *find_busiest_group(struct lb_env *env)
 		goto force_balance;
 
 	/* SD_BALANCE_NEWIDLE trumps SMP nice when underutilized */
-	if (env->idle == CPU_NEWLY_IDLE && local->group_has_free_capacity &&
-	    !busiest->group_has_free_capacity)
+	if (env->idle == CPU_NEWLY_IDLE && group_has_free_capacity(local, env) &&
+	    busiest->group_out_of_capacity)
 		goto force_balance;
 
 	/*
@@ -6369,7 +6339,7 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 	int i;
 
 	for_each_cpu_and(i, sched_group_cpus(group), env->cpus) {
-		unsigned long capacity, capacity_factor, wl;
+		unsigned long capacity, wl;
 		enum fbq_type rt;
 
 		rq = cpu_rq(i);
@@ -6398,9 +6368,6 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 			continue;
 
 		capacity = capacity_of(i);
-		capacity_factor = DIV_ROUND_CLOSEST(capacity, SCHED_CAPACITY_SCALE);
-		if (!capacity_factor)
-			capacity_factor = fix_small_capacity(env->sd, group);
 
 		wl = weighted_cpuload(i);
 
@@ -6408,7 +6375,9 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 		 * When comparing with imbalance, use weighted_cpuload()
 		 * which is not scaled with the cpu capacity.
 		 */
-		if (capacity_factor && rq->nr_running == 1 && wl > env->imbalance)
+
+		if (rq->nr_running == 1 && wl > env->imbalance &&
+		    ((capacity * env->sd->imbalance_pct) >= (rq->cpu_capacity_orig * 100)))
 			continue;
 
 		/*
-- 
1.9.1

