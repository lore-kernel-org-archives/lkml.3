Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbaKCRDM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:03:12 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:64211 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbaKCRDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:03:05 -0500
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        preeti@linux.vnet.ibm.com, Morten.Rasmussen@arm.com,
        kamalesh@linux.vnet.ibm.com, linux-arm-kernel@lists.infradead.org
Cc: riel@redhat.com, efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v9 08/10] sched: replace capacity_factor by usage
Date: Mon,  3 Nov 2014 17:54:45 +0100
Message-Id: <1415033687-23294-9-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415033687-23294-1-git-send-email-vincent.guittot@linaro.org>
References: <1415033687-23294-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The scheduler tries to compute how many tasks a group of CPUs can handle by
assuming that a task's load is SCHED_LOAD_SCALE and a CPU's capacity is
SCHED_CAPACITY_SCALE. group_capacity_factor divides the capacity of the group
by SCHED_LOAD_SCALE to estimate how many task can run in the group. Then, it
compares this value with the sum of nr_running to decide if the group is
overloaded or not. But the group_capacity_factor is hardly working for SMT
 system, it sometimes works for big cores but fails to do the right thing for
 little cores.

Below are two examples to illustrate the problem that this patch solves:

1- If the original capacity of a CPU is less than SCHED_CAPACITY_SCALE
(640 as an example), a group of 3 CPUS will have a max capacity_factor of 2
(div_round_closest(3x640/1024) = 2) which means that it will be seen as
overloaded even if we have only one task per CPU.

2 - If the original capacity of a CPU is greater than SCHED_CAPACITY_SCALE
(1512 as an example), a group of 4 CPUs will have a capacity_factor of 4
(at max and thanks to the fix [0] for SMT system that prevent the apparition
of ghost CPUs) but if one CPU is fully used by rt tasks (and its capacity is
reduced to nearly nothing), the capacity factor of the group will still be 4
(div_round_closest(3*1512/1024) = 5 which is cap to 4 with [0]).

So, this patch tries to solve this issue by removing capacity_factor and
replacing it with the 2 following metrics :
-The available CPU's capacity for CFS tasks which is already used by
 load_balance.
-The usage of the CPU by the CFS tasks. For the latter, utilization_avg_contrib
has been re-introduced to compute the usage of a CPU by CFS tasks.

group_capacity_factor and group_has_free_capacity has been removed and replaced
by group_no_capacity. We compare the number of task with the number of CPUs and
we evaluate the level of utilization of the CPUs to define if a group is
overloaded or if a group has capacity to handle more tasks.

For SD_PREFER_SIBLING, a group is tagged overloaded if it has more than 1 task
so it will be selected in priority (among the overloaded groups). Since [1],
SD_PREFER_SIBLING is no more concerned by the computation of load_above_capacity
because local is not overloaded.

Finally, the sched_group->sched_group_capacity->capacity_orig has been removed
because it's no more used during load balance.

[1] https://lkml.org/lkml/2014/8/12/295

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/core.c  |  12 -----
 kernel/sched/fair.c  | 150 +++++++++++++++++++++++++--------------------------
 kernel/sched/sched.h |   2 +-
 3 files changed, 75 insertions(+), 89 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 45ae52d..37fb92c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5373,17 +5373,6 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 			break;
 		}
 
-		/*
-		 * Even though we initialize ->capacity to something semi-sane,
-		 * we leave capacity_orig unset. This allows us to detect if
-		 * domain iteration is still funny without causing /0 traps.
-		 */
-		if (!group->sgc->capacity_orig) {
-			printk(KERN_CONT "\n");
-			printk(KERN_ERR "ERROR: domain->cpu_capacity not set\n");
-			break;
-		}
-
 		if (!cpumask_weight(sched_group_cpus(group))) {
 			printk(KERN_CONT "\n");
 			printk(KERN_ERR "ERROR: empty group\n");
@@ -5868,7 +5857,6 @@ build_overlap_sched_groups(struct sched_domain *sd, int cpu)
 		 * die on a /0 trap.
 		 */
 		sg->sgc->capacity = SCHED_CAPACITY_SCALE * cpumask_weight(sg_span);
-		sg->sgc->capacity_orig = sg->sgc->capacity;
 
 		/*
 		 * Make sure the first group of this domain contains the
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 884578e..db392a6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5717,11 +5717,10 @@ struct sg_lb_stats {
 	unsigned long group_capacity;
 	unsigned long group_usage; /* Total usage of the group */
 	unsigned int sum_nr_running; /* Nr tasks running in the group */
-	unsigned int group_capacity_factor;
 	unsigned int idle_cpus;
 	unsigned int group_weight;
 	enum group_type group_type;
-	int group_has_free_capacity;
+	int group_no_capacity;
 #ifdef CONFIG_NUMA_BALANCING
 	unsigned int nr_numa_running;
 	unsigned int nr_preferred_running;
@@ -5855,7 +5854,6 @@ static void update_cpu_capacity(struct sched_domain *sd, int cpu)
 	capacity >>= SCHED_CAPACITY_SHIFT;
 
 	cpu_rq(cpu)->cpu_capacity_orig = capacity;
-	sdg->sgc->capacity_orig = capacity;
 
 	capacity *= scale_rt_capacity(cpu);
 	capacity >>= SCHED_CAPACITY_SHIFT;
@@ -5871,7 +5869,7 @@ void update_group_capacity(struct sched_domain *sd, int cpu)
 {
 	struct sched_domain *child = sd->child;
 	struct sched_group *group, *sdg = sd->groups;
-	unsigned long capacity, capacity_orig;
+	unsigned long capacity;
 	unsigned long interval;
 
 	interval = msecs_to_jiffies(sd->balance_interval);
@@ -5883,7 +5881,7 @@ void update_group_capacity(struct sched_domain *sd, int cpu)
 		return;
 	}
 
-	capacity_orig = capacity = 0;
+	capacity = 0;
 
 	if (child->flags & SD_OVERLAP) {
 		/*
@@ -5903,19 +5901,15 @@ void update_group_capacity(struct sched_domain *sd, int cpu)
 			 * Use capacity_of(), which is set irrespective of domains
 			 * in update_cpu_capacity().
 			 *
-			 * This avoids capacity/capacity_orig from being 0 and
+			 * This avoids capacity from being 0 and
 			 * causing divide-by-zero issues on boot.
-			 *
-			 * Runtime updates will correct capacity_orig.
 			 */
 			if (unlikely(!rq->sd)) {
-				capacity_orig += capacity_orig_of(cpu);
 				capacity += capacity_of(cpu);
 				continue;
 			}
 
 			sgc = rq->sd->groups->sgc;
-			capacity_orig += sgc->capacity_orig;
 			capacity += sgc->capacity;
 		}
 	} else  {
@@ -5926,39 +5920,24 @@ void update_group_capacity(struct sched_domain *sd, int cpu)
 
 		group = child->groups;
 		do {
-			capacity_orig += group->sgc->capacity_orig;
 			capacity += group->sgc->capacity;
 			group = group->next;
 		} while (group != child->groups);
 	}
 
-	sdg->sgc->capacity_orig = capacity_orig;
 	sdg->sgc->capacity = capacity;
 }
 
 /*
- * Try and fix up capacity for tiny siblings, this is needed when
- * things like SD_ASYM_PACKING need f_b_g to select another sibling
- * which on its own isn't powerful enough.
- *
- * See update_sd_pick_busiest() and check_asym_packing().
+ * Check whether the capacity of the rq has been noticeably reduced by side
+ * activity. The imbalance_pct is used for the threshold.
+ * Return true is the capacity is reduced
  */
 static inline int
-fix_small_capacity(struct sched_domain *sd, struct sched_group *group)
+check_cpu_capacity(struct rq *rq, struct sched_domain *sd)
 {
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
+	return ((rq->cpu_capacity * sd->imbalance_pct) <
+				(rq->cpu_capacity_orig * 100));
 }
 
 /*
@@ -5996,37 +5975,54 @@ static inline int sg_imbalanced(struct sched_group *group)
 }
 
 /*
- * Compute the group capacity factor.
- *
- * Avoid the issue where N*frac(smt_capacity) >= 1 creates 'phantom' cores by
- * first dividing out the smt factor and computing the actual number of cores
- * and limit unit capacity with that.
+ * group_has_capacity returns true if the group has spare capacity that could
+ * be used by some tasks. We consider that a group has spare capacity if the
+ * number of task is smaller than the number of CPUs or if the usage is lower
+ * than the available capacity for CFS tasks. For the latter, we use a
+ * threshold to stabilize the state, to take into account the variance of the
+ * tasks' load and to return true if the available capacity in meaningful for
+ * the load balancer. As an example, an available capacity of 1% can appear
+ * but it doesn't make any benefit for the load balance.
  */
-static inline int sg_capacity_factor(struct lb_env *env, struct sched_group *group)
+static inline bool
+group_has_capacity(struct lb_env *env, struct sg_lb_stats *sgs)
 {
-	unsigned int capacity_factor, smt, cpus;
-	unsigned int capacity, capacity_orig;
+	if ((sgs->group_capacity * 100) >
+			(sgs->group_usage * env->sd->imbalance_pct))
+		return true;
 
-	capacity = group->sgc->capacity;
-	capacity_orig = group->sgc->capacity_orig;
-	cpus = group->group_weight;
+	if (sgs->sum_nr_running < sgs->group_weight)
+		return true;
+
+	return false;
+}
 
-	/* smt := ceil(cpus / capacity), assumes: 1 < smt_capacity < 2 */
-	smt = DIV_ROUND_UP(SCHED_CAPACITY_SCALE * cpus, capacity_orig);
-	capacity_factor = cpus / smt; /* cores */
+/*
+ *  group_is_overloaded returns true if the group has more tasks than it can
+ *  handle. We consider that a group is overloaded if the number of tasks is
+ *  greater than the number of CPUs and the tasks already use all available
+ *  capacity for CFS tasks. For the latter, we use a threshold to stabilize
+ *  the state, to take into account the variance of tasks' load and to return
+ *  true if available capacity is no more meaningful for load balancer
+ */
+static inline bool
+group_is_overloaded(struct lb_env *env, struct sg_lb_stats *sgs)
+{
+	if (sgs->sum_nr_running <= sgs->group_weight)
+		return false;
 
-	capacity_factor = min_t(unsigned,
-		capacity_factor, DIV_ROUND_CLOSEST(capacity, SCHED_CAPACITY_SCALE));
-	if (!capacity_factor)
-		capacity_factor = fix_small_capacity(env->sd, group);
+	if ((sgs->group_capacity * 100) <
+			(sgs->group_usage * env->sd->imbalance_pct))
+		return true;
 
-	return capacity_factor;
+	return false;
 }
 
-static enum group_type
-group_classify(struct sched_group *group, struct sg_lb_stats *sgs)
+static enum group_type group_classify(struct lb_env *env,
+		struct sched_group *group,
+		struct sg_lb_stats *sgs)
 {
-	if (sgs->sum_nr_running > sgs->group_capacity_factor)
+	if (sgs->group_no_capacity)
 		return group_overloaded;
 
 	if (sg_imbalanced(group))
@@ -6087,11 +6083,9 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 		sgs->load_per_task = sgs->sum_weighted_load / sgs->sum_nr_running;
 
 	sgs->group_weight = group->group_weight;
-	sgs->group_capacity_factor = sg_capacity_factor(env, group);
-	sgs->group_type = group_classify(group, sgs);
 
-	if (sgs->group_capacity_factor > sgs->sum_nr_running)
-		sgs->group_has_free_capacity = 1;
+	sgs->group_no_capacity = group_is_overloaded(env, sgs);
+	sgs->group_type = group_classify(env, group, sgs);
 }
 
 /**
@@ -6213,17 +6207,20 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
 
 		/*
 		 * In case the child domain prefers tasks go to siblings
-		 * first, lower the sg capacity factor to one so that we'll try
+		 * first, lower the sg capacity so that we'll try
 		 * and move all the excess tasks away. We lower the capacity
 		 * of a group only if the local group has the capacity to fit
-		 * these excess tasks, i.e. nr_running < group_capacity_factor. The
-		 * extra check prevents the case where you always pull from the
-		 * heaviest group when it is already under-utilized (possible
-		 * with a large weight task outweighs the tasks on the system).
+		 * these excess tasks. The extra check prevents the case where
+		 * you always pull from the heaviest group when it is already
+		 * under-utilized (possible with a large weight task outweighs
+		 * the tasks on the system).
 		 */
 		if (prefer_sibling && sds->local &&
-		    sds->local_stat.group_has_free_capacity)
-			sgs->group_capacity_factor = min(sgs->group_capacity_factor, 1U);
+		    group_has_capacity(env, &sds->local_stat) &&
+		    (sgs->sum_nr_running > 1)) {
+			sgs->group_no_capacity = 1;
+			sgs->group_type = group_overloaded;
+		}
 
 		if (update_sd_pick_busiest(env, sds, sg, sgs)) {
 			sds->busiest = sg;
@@ -6402,11 +6399,12 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
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
@@ -6469,6 +6467,7 @@ static struct sched_group *find_busiest_group(struct lb_env *env)
 	local = &sds.local_stat;
 	busiest = &sds.busiest_stat;
 
+	/* ASYM feature bypasses nice load balance check */
 	if ((env->idle == CPU_IDLE || env->idle == CPU_NEWLY_IDLE) &&
 	    check_asym_packing(env, &sds))
 		return sds.busiest;
@@ -6489,8 +6488,8 @@ static struct sched_group *find_busiest_group(struct lb_env *env)
 		goto force_balance;
 
 	/* SD_BALANCE_NEWIDLE trumps SMP nice when underutilized */
-	if (env->idle == CPU_NEWLY_IDLE && local->group_has_free_capacity &&
-	    !busiest->group_has_free_capacity)
+	if (env->idle == CPU_NEWLY_IDLE && group_has_capacity(env, local) &&
+	    busiest->group_no_capacity)
 		goto force_balance;
 
 	/*
@@ -6549,7 +6548,7 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 	int i;
 
 	for_each_cpu_and(i, sched_group_cpus(group), env->cpus) {
-		unsigned long capacity, capacity_factor, wl;
+		unsigned long capacity, wl;
 		enum fbq_type rt;
 
 		rq = cpu_rq(i);
@@ -6578,9 +6577,6 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 			continue;
 
 		capacity = capacity_of(i);
-		capacity_factor = DIV_ROUND_CLOSEST(capacity, SCHED_CAPACITY_SCALE);
-		if (!capacity_factor)
-			capacity_factor = fix_small_capacity(env->sd, group);
 
 		wl = weighted_cpuload(i);
 
@@ -6588,7 +6584,9 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 		 * When comparing with imbalance, use weighted_cpuload()
 		 * which is not scaled with the cpu capacity.
 		 */
-		if (capacity_factor && rq->nr_running == 1 && wl > env->imbalance)
+
+		if (rq->nr_running == 1 && wl > env->imbalance &&
+		    !check_cpu_capacity(rq, env->sd))
 			continue;
 
 		/*
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index aaaa3e4..8fd30c1 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -759,7 +759,7 @@ struct sched_group_capacity {
 	 * CPU capacity of this group, SCHED_LOAD_SCALE being max capacity
 	 * for a single CPU.
 	 */
-	unsigned int capacity, capacity_orig;
+	unsigned int capacity;
 	unsigned long next_update;
 	int imbalance; /* XXX unrelated to capacity but shared group state */
 	/*
-- 
1.9.1

