Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbaEWPyb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 11:54:31 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53995 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196AbaEWPy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 11:54:27 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org
Cc: preeti@linux.vnet.ibm.com, Morten.Rasmussen@arm.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v2 11/11] sched: replace capacity by activity
Date: Fri, 23 May 2014 17:53:05 +0200
Message-Id: <1400860385-14555-12-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The scheduler tries to compute how many tasks a group of CPUs can handle by
assuming that a task's load is SCHED_LOAD_SCALE and a CPU capacity is
SCHED_POWER_SCALE.
We can now have a better idea of the utilization of a group fo CPUs thanks to
group_actitvity and deduct how many capacity is still available.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/fair.c | 94 ++++++++++++++---------------------------------------
 1 file changed, 24 insertions(+), 70 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2501e49..05b9502 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5538,11 +5538,10 @@ struct sg_lb_stats {
 	unsigned long group_power;
 	unsigned long group_activity; /* Total activity of the group */
 	unsigned int sum_nr_running; /* Nr tasks running in the group */
-	unsigned int group_capacity;
+	long group_capacity;
 	unsigned int idle_cpus;
 	unsigned int group_weight;
 	int group_imb; /* Is there an imbalance in the group ? */
-	int group_has_capacity; /* Is there extra capacity in the group? */
 #ifdef CONFIG_NUMA_BALANCING
 	unsigned int nr_numa_running;
 	unsigned int nr_preferred_running;
@@ -5785,31 +5784,6 @@ void update_group_power(struct sched_domain *sd, int cpu)
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
-	 * Only siblings can have significantly less than SCHED_POWER_SCALE
-	 */
-	if (!(sd->flags & SD_SHARE_CPUPOWER))
-		return 0;
-
-	/*
-	 * If ~90% of the cpu_power is still there, we're good.
-	 */
-	if (group->sgp->power * 32 > group->sgp->power_orig * 29)
-		return 1;
-
-	return 0;
-}
-
-/*
  * Group imbalance indicates (and tries to solve) the problem where balancing
  * groups is inadequate due to tsk_cpus_allowed() constraints.
  *
@@ -5843,33 +5817,6 @@ static inline int sg_imbalanced(struct sched_group *group)
 	return group->sgp->imbalance;
 }
 
-/*
- * Compute the group capacity.
- *
- * Avoid the issue where N*frac(smt_power) >= 1 creates 'phantom' cores by
- * first dividing out the smt factor and computing the actual number of cores
- * and limit power unit capacity with that.
- */
-static inline int sg_capacity(struct lb_env *env, struct sched_group *group)
-{
-	unsigned int capacity, smt, cpus;
-	unsigned int power, power_orig;
-
-	power = group->sgp->power;
-	power_orig = group->sgp->power_orig;
-	cpus = group->group_weight;
-
-	/* smt := ceil(cpus / power), assumes: 1 < smt_power < 2 */
-	smt = DIV_ROUND_UP(SCHED_POWER_SCALE * cpus, power_orig);
-	capacity = cpus / smt; /* cores */
-
-	capacity = min_t(unsigned, capacity, DIV_ROUND_CLOSEST(power, SCHED_POWER_SCALE));
-	if (!capacity)
-		capacity = fix_small_capacity(env->sd, group);
-
-	return capacity;
-}
-
 /**
  * update_sg_lb_stats - Update sched_group's statistics for load balancing.
  * @env: The load balancing environment.
@@ -5918,10 +5865,9 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 	sgs->group_weight = group->group_weight;
 
 	sgs->group_imb = sg_imbalanced(group);
-	sgs->group_capacity = sg_capacity(env, group);
+	sgs->group_capacity = group->sgp->power_orig - sgs->group_activity;
+
 
-	if (sgs->group_capacity > sgs->sum_nr_running)
-		sgs->group_has_capacity = 1;
 }
 
 /**
@@ -5945,7 +5891,15 @@ static bool update_sd_pick_busiest(struct lb_env *env,
 	if (sgs->avg_load <= sds->busiest_stat.avg_load)
 		return false;
 
-	if (sgs->sum_nr_running > sgs->group_capacity)
+	/* The group has an obvious long run overload */
+	if (sgs->group_capacity < 0)
+		return true;
+
+	/*
+	 * The group has a short run overload because more tasks than available
+	 * CPUs are running
+	 */
+	if (sgs->sum_nr_running > sgs->group_weight)
 		return true;
 
 	/*
@@ -6052,8 +6006,8 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
 		 * with a large weight task outweighs the tasks on the system).
 		 */
 		if (prefer_sibling && sds->local &&
-		    sds->local_stat.group_has_capacity)
-			sgs->group_capacity = min(sgs->group_capacity, 1U);
+		    sds->local_stat.group_capacity > 0)
+			sgs->group_capacity = min(sgs->group_capacity, 1L);
 
 		if (update_sd_pick_busiest(env, sds, sg, sgs)) {
 			sds->busiest = sg;
@@ -6228,7 +6182,7 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 		 * have to drop below capacity to reach cpu-load equilibrium.
 		 */
 		load_above_capacity =
-			(busiest->sum_nr_running - busiest->group_capacity);
+			(busiest->sum_nr_running - busiest->group_weight);
 
 		load_above_capacity *= (SCHED_LOAD_SCALE * SCHED_POWER_SCALE);
 		load_above_capacity /= busiest->group_power;
@@ -6294,6 +6248,7 @@ static struct sched_group *find_busiest_group(struct lb_env *env)
 	local = &sds.local_stat;
 	busiest = &sds.busiest_stat;
 
+	/* ASYM feature bypasses nice load balance check */
 	if ((env->idle == CPU_IDLE || env->idle == CPU_NEWLY_IDLE) &&
 	    check_asym_packing(env, &sds))
 		return sds.busiest;
@@ -6313,8 +6268,8 @@ static struct sched_group *find_busiest_group(struct lb_env *env)
 		goto force_balance;
 
 	/* SD_BALANCE_NEWIDLE trumps SMP nice when underutilized */
-	if (env->idle == CPU_NEWLY_IDLE && local->group_has_capacity &&
-	    !busiest->group_has_capacity)
+	if (env->idle == CPU_NEWLY_IDLE && (local->group_capacity > 0)
+			&& (busiest->group_capacity < 0))
 		goto force_balance;
 
 	/*
@@ -6372,7 +6327,7 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 	int i;
 
 	for_each_cpu_and(i, sched_group_cpus(group), env->cpus) {
-		unsigned long power, capacity, wl;
+		unsigned long power, wl;
 		enum fbq_type rt;
 
 		rq = cpu_rq(i);
@@ -6400,18 +6355,17 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 		if (rt > env->fbq_type)
 			continue;
 
-		power = power_of(i);
-		capacity = DIV_ROUND_CLOSEST(power, SCHED_POWER_SCALE);
-		if (!capacity)
-			capacity = fix_small_capacity(env->sd, group);
-
 		wl = weighted_cpuload(i);
 
 		/*
 		 * When comparing with imbalance, use weighted_cpuload()
 		 * which is not scaled with the cpu power.
 		 */
-		if (capacity && rq->nr_running == 1 && wl > env->imbalance)
+
+		power = power_of(i);
+
+		if (rq->nr_running == 1 && wl > env->imbalance &&
+		    ((power * env->sd->imbalance_pct) >= (rq->cpu_power_orig * 100)))
 			continue;
 
 		/*
-- 
1.9.1

