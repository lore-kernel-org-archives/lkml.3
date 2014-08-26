Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742AbaHZLIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 07:08:30 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:59294 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757680AbaHZLIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 07:08:06 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        preeti@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org
Cc: riel@redhat.com, Morten.Rasmussen@arm.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org, dietmar.eggemann@arm.com,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v5 11/12] sched: replace capacity_factor by utilization
Date: Tue, 26 Aug 2014 13:06:54 +0200
Message-Id: <1409051215-16788-12-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409051215-16788-1-git-send-email-vincent.guittot@linaro.org>
References: <1409051215-16788-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The scheduler tries to compute how many tasks a group of CPUs can handle by
assuming that a task's load is SCHED_LOAD_SCALE and a CPU capacity is
SCHED_CAPACITY_SCALE.
We can now have a better idea of the capacity of a group of CPUs and of the
utilization of this group thanks to the rework of group_capacity_orig and the
group_utilization. We can now deduct how many capacity is still available.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/fair.c | 121 ++++++++++++++++++++++------------------------------
 1 file changed, 51 insertions(+), 70 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2f95d1c..80bd64e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5673,13 +5673,13 @@ struct sg_lb_stats {
 	unsigned long sum_weighted_load; /* Weighted load of group's tasks */
 	unsigned long load_per_task;
 	unsigned long group_capacity;
+	unsigned long group_capacity_orig;
 	unsigned long group_utilization; /* Total utilization of the group */
 	unsigned int sum_nr_running; /* Nr tasks running in the group */
-	unsigned int group_capacity_factor;
 	unsigned int idle_cpus;
 	unsigned int group_weight;
 	enum group_type group_type;
-	int group_has_free_capacity;
+	int group_out_of_capacity;
 #ifdef CONFIG_NUMA_BALANCING
 	unsigned int nr_numa_running;
 	unsigned int nr_preferred_running;
@@ -5901,31 +5901,6 @@ void update_group_capacity(struct sched_domain *sd, int cpu)
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
@@ -5959,38 +5934,37 @@ static inline int sg_imbalanced(struct sched_group *group)
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
+	if ((sgs->group_capacity_orig * 100) >
+			(sgs->group_utilization * env->sd->imbalance_pct))
+		return 1;
+
+	if (sgs->sum_nr_running < sgs->group_weight)
+		return 1;
 
-	capacity = group->sgc->capacity;
-	capacity_orig = group->sgc->capacity_orig;
-	cpus = group->group_weight;
+	return 0;
+}
 
-	/* smt := ceil(cpus / capacity), assumes: 1 < smt_capacity < 2 */
-	smt = DIV_ROUND_UP(SCHED_CAPACITY_SCALE * cpus, capacity_orig);
-	capacity_factor = cpus / smt; /* cores */
+static inline int group_is_overloaded(struct sg_lb_stats *sgs,
+			struct lb_env *env)
+{
+	if (sgs->sum_nr_running <= sgs->group_weight)
+		return 0;
 
-	capacity_factor = min_t(unsigned,
-		capacity_factor, DIV_ROUND_CLOSEST(capacity, SCHED_CAPACITY_SCALE));
-	if (!capacity_factor)
-		capacity_factor = fix_small_capacity(env->sd, group);
+	if ((sgs->group_capacity_orig * 100) <
+			(sgs->group_utilization * env->sd->imbalance_pct))
+		return 1;
 
-	return capacity_factor;
+	return 0;
 }
 
 static enum group_type
-group_classify(struct sched_group *group, struct sg_lb_stats *sgs)
+group_classify(struct sched_group *group, struct sg_lb_stats *sgs,
+			struct lb_env *env)
 {
-	if (sgs->sum_nr_running > sgs->group_capacity_factor)
+	if (group_is_overloaded(sgs, env))
 		return group_overloaded;
 
 	if (sg_imbalanced(group))
@@ -6043,6 +6017,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 			sgs->idle_cpus++;
 	}
 
+	sgs->group_capacity_orig = group->sgc->capacity_orig;
 	/* Adjust by relative CPU capacity of the group */
 	sgs->group_capacity = group->sgc->capacity;
 	sgs->avg_load = (sgs->group_load*SCHED_CAPACITY_SCALE) / sgs->group_capacity;
@@ -6051,11 +6026,10 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 		sgs->load_per_task = sgs->sum_weighted_load / sgs->sum_nr_running;
 
 	sgs->group_weight = group->group_weight;
-	sgs->group_capacity_factor = sg_capacity_factor(env, group);
-	sgs->group_type = group_classify(group, sgs);
 
-	if (sgs->group_capacity_factor > sgs->sum_nr_running)
-		sgs->group_has_free_capacity = 1;
+	sgs->group_type = group_classify(group, sgs, env);
+
+	sgs->group_out_of_capacity = group_is_overloaded(sgs, env);
 }
 
 /**
@@ -6185,17 +6159,21 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
 
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
+			sgs->group_capacity = min(sgs->group_capacity,
+						SCHED_CAPACITY_SCALE);
+		}
 
 		if (update_sd_pick_busiest(env, sds, sg, sgs)) {
 			sds->busiest = sg;
@@ -6373,11 +6351,12 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 	 */
 	if (busiest->group_type == group_overloaded &&
 	    local->group_type   == group_overloaded) {
-		load_above_capacity =
-			(busiest->sum_nr_running - busiest->group_capacity_factor);
-
-		load_above_capacity *= (SCHED_LOAD_SCALE * SCHED_CAPACITY_SCALE);
-		load_above_capacity /= busiest->group_capacity;
+		load_above_capacity = busiest->sum_nr_running *
+					SCHED_LOAD_SCALE;
+		if (load_above_capacity > busiest->group_capacity)
+			load_above_capacity -= busiest->group_capacity;
+		else
+			load_above_capacity = ~0UL;
 	}
 
 	/*
@@ -6440,6 +6419,7 @@ static struct sched_group *find_busiest_group(struct lb_env *env)
 	local = &sds.local_stat;
 	busiest = &sds.busiest_stat;
 
+	/* ASYM feature bypasses nice load balance check */
 	if ((env->idle == CPU_IDLE || env->idle == CPU_NEWLY_IDLE) &&
 	    check_asym_packing(env, &sds))
 		return sds.busiest;
@@ -6460,8 +6440,9 @@ static struct sched_group *find_busiest_group(struct lb_env *env)
 		goto force_balance;
 
 	/* SD_BALANCE_NEWIDLE trumps SMP nice when underutilized */
-	if (env->idle == CPU_NEWLY_IDLE && local->group_has_free_capacity &&
-	    !busiest->group_has_free_capacity)
+	if (env->idle == CPU_NEWLY_IDLE &&
+			group_has_free_capacity(local, env) &&
+			busiest->group_out_of_capacity)
 		goto force_balance;
 
 	/*
@@ -6519,7 +6500,7 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 	int i;
 
 	for_each_cpu_and(i, sched_group_cpus(group), env->cpus) {
-		unsigned long capacity, capacity_factor, wl;
+		unsigned long capacity, wl;
 		enum fbq_type rt;
 
 		rq = cpu_rq(i);
@@ -6548,9 +6529,6 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 			continue;
 
 		capacity = capacity_of(i);
-		capacity_factor = DIV_ROUND_CLOSEST(capacity, SCHED_CAPACITY_SCALE);
-		if (!capacity_factor)
-			capacity_factor = fix_small_capacity(env->sd, group);
 
 		wl = weighted_cpuload(i);
 
@@ -6558,7 +6536,10 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 		 * When comparing with imbalance, use weighted_cpuload()
 		 * which is not scaled with the cpu capacity.
 		 */
-		if (capacity_factor && rq->nr_running == 1 && wl > env->imbalance)
+
+		if (rq->nr_running == 1 && wl > env->imbalance &&
+		    ((capacity * env->sd->imbalance_pct) >=
+				(rq->cpu_capacity_orig * 100)))
 			continue;
 
 		/*
-- 
1.9.1

