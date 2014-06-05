Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551AbaFEOgw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:36:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48435 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbaFEOgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:36:42 -0400
Date: Thu, 5 Jun 2014 07:35:57 -0700
From: tip-bot for Nicolas Pitre <tipbot@zytor.com>
Message-ID: <tip-5yeix833vvgf2uyj5o36hpu9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        nicolas.pitre@linaro.org, morten.rasmussen@arm.com, nico@linaro.org,
        vincent.guittot@linaro.org, rjw@rjwysocki.net, tglx@linutronix.de,
        daniel.lezcano@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        nicolas.pitre@linaro.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, nico@linaro.org, tglx@linutronix.de,
        rjw@rjwysocki.net, daniel.lezcano@linaro.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Let 'struct sched_group_power'
  care about CPU capacity
Git-Commit-ID: 63b2ca30bdb3dbf60bc7ac5f46713c0d32308261
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  63b2ca30bdb3dbf60bc7ac5f46713c0d32308261
Gitweb:     http://git.kernel.org/tip/63b2ca30bdb3dbf60bc7ac5f46713c0d32308261
Author:     Nicolas Pitre <nicolas.pitre@linaro.org>
AuthorDate: Mon, 26 May 2014 18:19:37 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Jun 2014 11:52:26 +0200

sched: Let 'struct sched_group_power' care about CPU capacity

It is better not to think about compute capacity as being equivalent
to "CPU power".  The upcoming "power aware" scheduler work may create
confusion with the notion of energy consumption if "power" is used too
liberally.

Since struct sched_group_power is really about compute capacity of sched
groups, let's rename it to struct sched_group_capacity. Similarly sgp
becomes sgc. Related variables and functions dealing with groups are also
adjusted accordingly.

Signed-off-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linaro-kernel@lists.linaro.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Link: http://lkml.kernel.org/n/tip-5yeix833vvgf2uyj5o36hpu9@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h |   2 +-
 kernel/sched/core.c   |  81 +++++++++++++++----------------
 kernel/sched/fair.c   | 131 +++++++++++++++++++++++++-------------------------
 kernel/sched/sched.h  |  16 +++---
 4 files changed, 115 insertions(+), 115 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6790c3b..a96f035 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1013,7 +1013,7 @@ typedef const int (*sched_domain_flags_f)(void);
 struct sd_data {
 	struct sched_domain **__percpu sd;
 	struct sched_group **__percpu sg;
-	struct sched_group_power **__percpu sgp;
+	struct sched_group_capacity **__percpu sgc;
 };
 
 struct sched_domain_topology_level {
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index afcc842..2e1fb09 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5221,14 +5221,13 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 		}
 
 		/*
-		 * Even though we initialize ->power to something semi-sane,
-		 * we leave power_orig unset. This allows us to detect if
+		 * Even though we initialize ->capacity to something semi-sane,
+		 * we leave capacity_orig unset. This allows us to detect if
 		 * domain iteration is still funny without causing /0 traps.
 		 */
-		if (!group->sgp->power_orig) {
+		if (!group->sgc->capacity_orig) {
 			printk(KERN_CONT "\n");
-			printk(KERN_ERR "ERROR: domain->cpu_power not "
-					"set\n");
+			printk(KERN_ERR "ERROR: domain->cpu_capacity not set\n");
 			break;
 		}
 
@@ -5250,9 +5249,9 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 		cpulist_scnprintf(str, sizeof(str), sched_group_cpus(group));
 
 		printk(KERN_CONT " %s", str);
-		if (group->sgp->power != SCHED_POWER_SCALE) {
-			printk(KERN_CONT " (cpu_power = %d)",
-				group->sgp->power);
+		if (group->sgc->capacity != SCHED_POWER_SCALE) {
+			printk(KERN_CONT " (cpu_capacity = %d)",
+				group->sgc->capacity);
 		}
 
 		group = group->next;
@@ -5466,7 +5465,7 @@ static struct root_domain *alloc_rootdomain(void)
 	return rd;
 }
 
-static void free_sched_groups(struct sched_group *sg, int free_sgp)
+static void free_sched_groups(struct sched_group *sg, int free_sgc)
 {
 	struct sched_group *tmp, *first;
 
@@ -5477,8 +5476,8 @@ static void free_sched_groups(struct sched_group *sg, int free_sgp)
 	do {
 		tmp = sg->next;
 
-		if (free_sgp && atomic_dec_and_test(&sg->sgp->ref))
-			kfree(sg->sgp);
+		if (free_sgc && atomic_dec_and_test(&sg->sgc->ref))
+			kfree(sg->sgc);
 
 		kfree(sg);
 		sg = tmp;
@@ -5496,7 +5495,7 @@ static void free_sched_domain(struct rcu_head *rcu)
 	if (sd->flags & SD_OVERLAP) {
 		free_sched_groups(sd->groups, 1);
 	} else if (atomic_dec_and_test(&sd->groups->ref)) {
-		kfree(sd->groups->sgp);
+		kfree(sd->groups->sgc);
 		kfree(sd->groups);
 	}
 	kfree(sd);
@@ -5707,17 +5706,17 @@ build_overlap_sched_groups(struct sched_domain *sd, int cpu)
 
 		cpumask_or(covered, covered, sg_span);
 
-		sg->sgp = *per_cpu_ptr(sdd->sgp, i);
-		if (atomic_inc_return(&sg->sgp->ref) == 1)
+		sg->sgc = *per_cpu_ptr(sdd->sgc, i);
+		if (atomic_inc_return(&sg->sgc->ref) == 1)
 			build_group_mask(sd, sg);
 
 		/*
-		 * Initialize sgp->power such that even if we mess up the
+		 * Initialize sgc->capacity such that even if we mess up the
 		 * domains and no possible iteration will get us here, we won't
 		 * die on a /0 trap.
 		 */
-		sg->sgp->power = SCHED_POWER_SCALE * cpumask_weight(sg_span);
-		sg->sgp->power_orig = sg->sgp->power;
+		sg->sgc->capacity = SCHED_POWER_SCALE * cpumask_weight(sg_span);
+		sg->sgc->capacity_orig = sg->sgc->capacity;
 
 		/*
 		 * Make sure the first group of this domain contains the
@@ -5755,8 +5754,8 @@ static int get_group(int cpu, struct sd_data *sdd, struct sched_group **sg)
 
 	if (sg) {
 		*sg = *per_cpu_ptr(sdd->sg, cpu);
-		(*sg)->sgp = *per_cpu_ptr(sdd->sgp, cpu);
-		atomic_set(&(*sg)->sgp->ref, 1); /* for claim_allocations */
+		(*sg)->sgc = *per_cpu_ptr(sdd->sgc, cpu);
+		atomic_set(&(*sg)->sgc->ref, 1); /* for claim_allocations */
 	}
 
 	return cpu;
@@ -5819,16 +5818,16 @@ build_sched_groups(struct sched_domain *sd, int cpu)
 }
 
 /*
- * Initialize sched groups cpu_power.
+ * Initialize sched groups cpu_capacity.
  *
- * cpu_power indicates the capacity of sched group, which is used while
+ * cpu_capacity indicates the capacity of sched group, which is used while
  * distributing the load between different sched groups in a sched domain.
- * Typically cpu_power for all the groups in a sched domain will be same unless
- * there are asymmetries in the topology. If there are asymmetries, group
- * having more cpu_power will pickup more load compared to the group having
- * less cpu_power.
+ * Typically cpu_capacity for all the groups in a sched domain will be same
+ * unless there are asymmetries in the topology. If there are asymmetries,
+ * group having more cpu_capacity will pickup more load compared to the
+ * group having less cpu_capacity.
  */
-static void init_sched_groups_power(int cpu, struct sched_domain *sd)
+static void init_sched_groups_capacity(int cpu, struct sched_domain *sd)
 {
 	struct sched_group *sg = sd->groups;
 
@@ -5842,8 +5841,8 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 	if (cpu != group_balance_cpu(sg))
 		return;
 
-	update_group_power(sd, cpu);
-	atomic_set(&sg->sgp->nr_busy_cpus, sg->group_weight);
+	update_group_capacity(sd, cpu);
+	atomic_set(&sg->sgc->nr_busy_cpus, sg->group_weight);
 }
 
 /*
@@ -5934,8 +5933,8 @@ static void claim_allocations(int cpu, struct sched_domain *sd)
 	if (atomic_read(&(*per_cpu_ptr(sdd->sg, cpu))->ref))
 		*per_cpu_ptr(sdd->sg, cpu) = NULL;
 
-	if (atomic_read(&(*per_cpu_ptr(sdd->sgp, cpu))->ref))
-		*per_cpu_ptr(sdd->sgp, cpu) = NULL;
+	if (atomic_read(&(*per_cpu_ptr(sdd->sgc, cpu))->ref))
+		*per_cpu_ptr(sdd->sgc, cpu) = NULL;
 }
 
 #ifdef CONFIG_NUMA
@@ -6337,14 +6336,14 @@ static int __sdt_alloc(const struct cpumask *cpu_map)
 		if (!sdd->sg)
 			return -ENOMEM;
 
-		sdd->sgp = alloc_percpu(struct sched_group_power *);
-		if (!sdd->sgp)
+		sdd->sgc = alloc_percpu(struct sched_group_capacity *);
+		if (!sdd->sgc)
 			return -ENOMEM;
 
 		for_each_cpu(j, cpu_map) {
 			struct sched_domain *sd;
 			struct sched_group *sg;
-			struct sched_group_power *sgp;
+			struct sched_group_capacity *sgc;
 
 		       	sd = kzalloc_node(sizeof(struct sched_domain) + cpumask_size(),
 					GFP_KERNEL, cpu_to_node(j));
@@ -6362,12 +6361,12 @@ static int __sdt_alloc(const struct cpumask *cpu_map)
 
 			*per_cpu_ptr(sdd->sg, j) = sg;
 
-			sgp = kzalloc_node(sizeof(struct sched_group_power) + cpumask_size(),
+			sgc = kzalloc_node(sizeof(struct sched_group_capacity) + cpumask_size(),
 					GFP_KERNEL, cpu_to_node(j));
-			if (!sgp)
+			if (!sgc)
 				return -ENOMEM;
 
-			*per_cpu_ptr(sdd->sgp, j) = sgp;
+			*per_cpu_ptr(sdd->sgc, j) = sgc;
 		}
 	}
 
@@ -6394,15 +6393,15 @@ static void __sdt_free(const struct cpumask *cpu_map)
 
 			if (sdd->sg)
 				kfree(*per_cpu_ptr(sdd->sg, j));
-			if (sdd->sgp)
-				kfree(*per_cpu_ptr(sdd->sgp, j));
+			if (sdd->sgc)
+				kfree(*per_cpu_ptr(sdd->sgc, j));
 		}
 		free_percpu(sdd->sd);
 		sdd->sd = NULL;
 		free_percpu(sdd->sg);
 		sdd->sg = NULL;
-		free_percpu(sdd->sgp);
-		sdd->sgp = NULL;
+		free_percpu(sdd->sgc);
+		sdd->sgc = NULL;
 	}
 }
 
@@ -6479,7 +6478,7 @@ static int build_sched_domains(const struct cpumask *cpu_map,
 
 		for (sd = *per_cpu_ptr(d.sd, i); sd; sd = sd->parent) {
 			claim_allocations(i, sd);
-			init_sched_groups_power(i, sd);
+			init_sched_groups_capacity(i, sd);
 		}
 	}
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e401e44..36bd4d2 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4369,8 +4369,8 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
 			avg_load += load;
 		}
 
-		/* Adjust by relative CPU power of the group */
-		avg_load = (avg_load * SCHED_POWER_SCALE) / group->sgp->power;
+		/* Adjust by relative CPU capacity of the group */
+		avg_load = (avg_load * SCHED_POWER_SCALE) / group->sgc->capacity;
 
 		if (local_group) {
 			this_load = avg_load;
@@ -5532,7 +5532,7 @@ struct sg_lb_stats {
 	unsigned long group_load; /* Total load over the CPUs of the group */
 	unsigned long sum_weighted_load; /* Weighted load of group's tasks */
 	unsigned long load_per_task;
-	unsigned long group_power;
+	unsigned long group_capacity;
 	unsigned int sum_nr_running; /* Nr tasks running in the group */
 	unsigned int group_capacity_factor;
 	unsigned int idle_cpus;
@@ -5553,7 +5553,7 @@ struct sd_lb_stats {
 	struct sched_group *busiest;	/* Busiest group in this sd */
 	struct sched_group *local;	/* Local group in this sd */
 	unsigned long total_load;	/* Total load of all groups in sd */
-	unsigned long total_pwr;	/* Total power of all groups in sd */
+	unsigned long total_capacity;	/* Total capacity of all groups in sd */
 	unsigned long avg_load;	/* Average load across all groups in sd */
 
 	struct sg_lb_stats busiest_stat;/* Statistics of the busiest group */
@@ -5572,7 +5572,7 @@ static inline void init_sd_lb_stats(struct sd_lb_stats *sds)
 		.busiest = NULL,
 		.local = NULL,
 		.total_load = 0UL,
-		.total_pwr = 0UL,
+		.total_capacity = 0UL,
 		.busiest_stat = {
 			.avg_load = 0UL,
 		},
@@ -5681,7 +5681,7 @@ static void update_cpu_power(struct sched_domain *sd, int cpu)
 		power >>= SCHED_POWER_SHIFT;
 	}
 
-	sdg->sgp->power_orig = power;
+	sdg->sgc->capacity_orig = power;
 
 	if (sched_feat(ARCH_POWER))
 		power *= arch_scale_freq_power(sd, cpu);
@@ -5697,26 +5697,26 @@ static void update_cpu_power(struct sched_domain *sd, int cpu)
 		power = 1;
 
 	cpu_rq(cpu)->cpu_power = power;
-	sdg->sgp->power = power;
+	sdg->sgc->capacity = power;
 }
 
-void update_group_power(struct sched_domain *sd, int cpu)
+void update_group_capacity(struct sched_domain *sd, int cpu)
 {
 	struct sched_domain *child = sd->child;
 	struct sched_group *group, *sdg = sd->groups;
-	unsigned long power, power_orig;
+	unsigned long capacity, capacity_orig;
 	unsigned long interval;
 
 	interval = msecs_to_jiffies(sd->balance_interval);
 	interval = clamp(interval, 1UL, max_load_balance_interval);
-	sdg->sgp->next_update = jiffies + interval;
+	sdg->sgc->next_update = jiffies + interval;
 
 	if (!child) {
 		update_cpu_power(sd, cpu);
 		return;
 	}
 
-	power_orig = power = 0;
+	capacity_orig = capacity = 0;
 
 	if (child->flags & SD_OVERLAP) {
 		/*
@@ -5725,31 +5725,31 @@ void update_group_power(struct sched_domain *sd, int cpu)
 		 */
 
 		for_each_cpu(cpu, sched_group_cpus(sdg)) {
-			struct sched_group_power *sgp;
+			struct sched_group_capacity *sgc;
 			struct rq *rq = cpu_rq(cpu);
 
 			/*
-			 * build_sched_domains() -> init_sched_groups_power()
+			 * build_sched_domains() -> init_sched_groups_capacity()
 			 * gets here before we've attached the domains to the
 			 * runqueues.
 			 *
 			 * Use power_of(), which is set irrespective of domains
 			 * in update_cpu_power().
 			 *
-			 * This avoids power/power_orig from being 0 and
+			 * This avoids capacity/capacity_orig from being 0 and
 			 * causing divide-by-zero issues on boot.
 			 *
-			 * Runtime updates will correct power_orig.
+			 * Runtime updates will correct capacity_orig.
 			 */
 			if (unlikely(!rq->sd)) {
-				power_orig += power_of(cpu);
-				power += power_of(cpu);
+				capacity_orig += power_of(cpu);
+				capacity += power_of(cpu);
 				continue;
 			}
 
-			sgp = rq->sd->groups->sgp;
-			power_orig += sgp->power_orig;
-			power += sgp->power;
+			sgc = rq->sd->groups->sgc;
+			capacity_orig += sgc->capacity_orig;
+			capacity += sgc->capacity;
 		}
 	} else  {
 		/*
@@ -5759,14 +5759,14 @@ void update_group_power(struct sched_domain *sd, int cpu)
 
 		group = child->groups;
 		do {
-			power_orig += group->sgp->power_orig;
-			power += group->sgp->power;
+			capacity_orig += group->sgc->capacity_orig;
+			capacity += group->sgc->capacity;
 			group = group->next;
 		} while (group != child->groups);
 	}
 
-	sdg->sgp->power_orig = power_orig;
-	sdg->sgp->power = power;
+	sdg->sgc->capacity_orig = capacity_orig;
+	sdg->sgc->capacity = capacity;
 }
 
 /*
@@ -5786,9 +5786,9 @@ fix_small_capacity(struct sched_domain *sd, struct sched_group *group)
 		return 0;
 
 	/*
-	 * If ~90% of the cpu_power is still there, we're good.
+	 * If ~90% of the cpu_capacity is still there, we're good.
 	 */
-	if (group->sgp->power * 32 > group->sgp->power_orig * 29)
+	if (group->sgc->capacity * 32 > group->sgc->capacity_orig * 29)
 		return 1;
 
 	return 0;
@@ -5825,7 +5825,7 @@ fix_small_capacity(struct sched_domain *sd, struct sched_group *group)
 
 static inline int sg_imbalanced(struct sched_group *group)
 {
-	return group->sgp->imbalance;
+	return group->sgc->imbalance;
 }
 
 /*
@@ -5833,22 +5833,23 @@ static inline int sg_imbalanced(struct sched_group *group)
  *
  * Avoid the issue where N*frac(smt_power) >= 1 creates 'phantom' cores by
  * first dividing out the smt factor and computing the actual number of cores
- * and limit power unit capacity with that.
+ * and limit unit capacity with that.
  */
 static inline int sg_capacity_factor(struct lb_env *env, struct sched_group *group)
 {
 	unsigned int capacity_factor, smt, cpus;
-	unsigned int power, power_orig;
+	unsigned int capacity, capacity_orig;
 
-	power = group->sgp->power;
-	power_orig = group->sgp->power_orig;
+	capacity = group->sgc->capacity;
+	capacity_orig = group->sgc->capacity_orig;
 	cpus = group->group_weight;
 
-	/* smt := ceil(cpus / power), assumes: 1 < smt_power < 2 */
-	smt = DIV_ROUND_UP(SCHED_POWER_SCALE * cpus, power_orig);
+	/* smt := ceil(cpus / capacity), assumes: 1 < smt_capacity < 2 */
+	smt = DIV_ROUND_UP(SCHED_POWER_SCALE * cpus, capacity_orig);
 	capacity_factor = cpus / smt; /* cores */
 
-	capacity_factor = min_t(unsigned, capacity_factor, DIV_ROUND_CLOSEST(power, SCHED_POWER_SCALE));
+	capacity_factor = min_t(unsigned,
+		capacity_factor, DIV_ROUND_CLOSEST(capacity, SCHED_POWER_SCALE));
 	if (!capacity_factor)
 		capacity_factor = fix_small_capacity(env->sd, group);
 
@@ -5892,9 +5893,9 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 			sgs->idle_cpus++;
 	}
 
-	/* Adjust by relative CPU power of the group */
-	sgs->group_power = group->sgp->power;
-	sgs->avg_load = (sgs->group_load*SCHED_POWER_SCALE) / sgs->group_power;
+	/* Adjust by relative CPU capacity of the group */
+	sgs->group_capacity = group->sgc->capacity;
+	sgs->avg_load = (sgs->group_load*SCHED_POWER_SCALE) / sgs->group_capacity;
 
 	if (sgs->sum_nr_running)
 		sgs->load_per_task = sgs->sum_weighted_load / sgs->sum_nr_running;
@@ -6009,8 +6010,8 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
 			sgs = &sds->local_stat;
 
 			if (env->idle != CPU_NEWLY_IDLE ||
-			    time_after_eq(jiffies, sg->sgp->next_update))
-				update_group_power(env->sd, env->dst_cpu);
+			    time_after_eq(jiffies, sg->sgc->next_update))
+				update_group_capacity(env->sd, env->dst_cpu);
 		}
 
 		update_sg_lb_stats(env, sg, load_idx, local_group, sgs);
@@ -6040,7 +6041,7 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
 next_group:
 		/* Now, start updating sd_lb_stats */
 		sds->total_load += sgs->group_load;
-		sds->total_pwr += sgs->group_power;
+		sds->total_capacity += sgs->group_capacity;
 
 		sg = sg->next;
 	} while (sg != env->sd->groups);
@@ -6087,7 +6088,7 @@ static int check_asym_packing(struct lb_env *env, struct sd_lb_stats *sds)
 		return 0;
 
 	env->imbalance = DIV_ROUND_CLOSEST(
-		sds->busiest_stat.avg_load * sds->busiest_stat.group_power,
+		sds->busiest_stat.avg_load * sds->busiest_stat.group_capacity,
 		SCHED_POWER_SCALE);
 
 	return 1;
@@ -6103,7 +6104,7 @@ static int check_asym_packing(struct lb_env *env, struct sd_lb_stats *sds)
 static inline
 void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 {
-	unsigned long tmp, pwr_now = 0, pwr_move = 0;
+	unsigned long tmp, capa_now = 0, capa_move = 0;
 	unsigned int imbn = 2;
 	unsigned long scaled_busy_load_per_task;
 	struct sg_lb_stats *local, *busiest;
@@ -6118,7 +6119,7 @@ void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 
 	scaled_busy_load_per_task =
 		(busiest->load_per_task * SCHED_POWER_SCALE) /
-		busiest->group_power;
+		busiest->group_capacity;
 
 	if (busiest->avg_load + scaled_busy_load_per_task >=
 	    local->avg_load + (scaled_busy_load_per_task * imbn)) {
@@ -6132,34 +6133,34 @@ void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 	 * moving them.
 	 */
 
-	pwr_now += busiest->group_power *
+	capa_now += busiest->group_capacity *
 			min(busiest->load_per_task, busiest->avg_load);
-	pwr_now += local->group_power *
+	capa_now += local->group_capacity *
 			min(local->load_per_task, local->avg_load);
-	pwr_now /= SCHED_POWER_SCALE;
+	capa_now /= SCHED_POWER_SCALE;
 
 	/* Amount of load we'd subtract */
 	if (busiest->avg_load > scaled_busy_load_per_task) {
-		pwr_move += busiest->group_power *
+		capa_move += busiest->group_capacity *
 			    min(busiest->load_per_task,
 				busiest->avg_load - scaled_busy_load_per_task);
 	}
 
 	/* Amount of load we'd add */
-	if (busiest->avg_load * busiest->group_power <
+	if (busiest->avg_load * busiest->group_capacity <
 	    busiest->load_per_task * SCHED_POWER_SCALE) {
-		tmp = (busiest->avg_load * busiest->group_power) /
-		      local->group_power;
+		tmp = (busiest->avg_load * busiest->group_capacity) /
+		      local->group_capacity;
 	} else {
 		tmp = (busiest->load_per_task * SCHED_POWER_SCALE) /
-		      local->group_power;
+		      local->group_capacity;
 	}
-	pwr_move += local->group_power *
+	capa_move += local->group_capacity *
 		    min(local->load_per_task, local->avg_load + tmp);
-	pwr_move /= SCHED_POWER_SCALE;
+	capa_move /= SCHED_POWER_SCALE;
 
 	/* Move if we gain throughput */
-	if (pwr_move > pwr_now)
+	if (capa_move > capa_now)
 		env->imbalance = busiest->load_per_task;
 }
 
@@ -6207,7 +6208,7 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 			(busiest->sum_nr_running - busiest->group_capacity_factor);
 
 		load_above_capacity *= (SCHED_LOAD_SCALE * SCHED_POWER_SCALE);
-		load_above_capacity /= busiest->group_power;
+		load_above_capacity /= busiest->group_capacity;
 	}
 
 	/*
@@ -6222,8 +6223,8 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 
 	/* How much load to actually move to equalise the imbalance */
 	env->imbalance = min(
-		max_pull * busiest->group_power,
-		(sds->avg_load - local->avg_load) * local->group_power
+		max_pull * busiest->group_capacity,
+		(sds->avg_load - local->avg_load) * local->group_capacity
 	) / SCHED_POWER_SCALE;
 
 	/*
@@ -6278,7 +6279,7 @@ static struct sched_group *find_busiest_group(struct lb_env *env)
 	if (!sds.busiest || busiest->sum_nr_running == 0)
 		goto out_balanced;
 
-	sds.avg_load = (SCHED_POWER_SCALE * sds.total_load) / sds.total_pwr;
+	sds.avg_load = (SCHED_POWER_SCALE * sds.total_load) / sds.total_capacity;
 
 	/*
 	 * If the busiest group is imbalanced the below checks don't
@@ -6611,7 +6612,7 @@ more_balance:
 		 * We failed to reach balance because of affinity.
 		 */
 		if (sd_parent) {
-			int *group_imbalance = &sd_parent->groups->sgp->imbalance;
+			int *group_imbalance = &sd_parent->groups->sgc->imbalance;
 
 			if ((env.flags & LBF_SOME_PINNED) && env.imbalance > 0) {
 				*group_imbalance = 1;
@@ -6998,7 +6999,7 @@ static inline void set_cpu_sd_state_busy(void)
 		goto unlock;
 	sd->nohz_idle = 0;
 
-	atomic_inc(&sd->groups->sgp->nr_busy_cpus);
+	atomic_inc(&sd->groups->sgc->nr_busy_cpus);
 unlock:
 	rcu_read_unlock();
 }
@@ -7015,7 +7016,7 @@ void set_cpu_sd_state_idle(void)
 		goto unlock;
 	sd->nohz_idle = 1;
 
-	atomic_dec(&sd->groups->sgp->nr_busy_cpus);
+	atomic_dec(&sd->groups->sgc->nr_busy_cpus);
 unlock:
 	rcu_read_unlock();
 }
@@ -7219,7 +7220,7 @@ end:
  * of an idle cpu is the system.
  *   - This rq has more than one task.
  *   - At any scheduler domain level, this cpu's scheduler group has multiple
- *     busy cpu's exceeding the group's power.
+ *     busy cpu's exceeding the group's capacity.
  *   - For SD_ASYM_PACKING, if the lower numbered cpu's in the scheduler
  *     domain span are idle.
  */
@@ -7227,7 +7228,7 @@ static inline int nohz_kick_needed(struct rq *rq)
 {
 	unsigned long now = jiffies;
 	struct sched_domain *sd;
-	struct sched_group_power *sgp;
+	struct sched_group_capacity *sgc;
 	int nr_busy, cpu = rq->cpu;
 
 	if (unlikely(rq->idle_balance))
@@ -7257,8 +7258,8 @@ static inline int nohz_kick_needed(struct rq *rq)
 	sd = rcu_dereference(per_cpu(sd_busy, cpu));
 
 	if (sd) {
-		sgp = sd->groups->sgp;
-		nr_busy = atomic_read(&sgp->nr_busy_cpus);
+		sgc = sd->groups->sgc;
+		nr_busy = atomic_read(&sgc->nr_busy_cpus);
 
 		if (nr_busy > 1)
 			goto need_kick_unlock;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 600e229..a5b957d 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -728,15 +728,15 @@ DECLARE_PER_CPU(struct sched_domain *, sd_numa);
 DECLARE_PER_CPU(struct sched_domain *, sd_busy);
 DECLARE_PER_CPU(struct sched_domain *, sd_asym);
 
-struct sched_group_power {
+struct sched_group_capacity {
 	atomic_t ref;
 	/*
-	 * CPU power of this group, SCHED_LOAD_SCALE being max power for a
-	 * single CPU.
+	 * CPU capacity of this group, SCHED_LOAD_SCALE being max capacity
+	 * for a single CPU.
 	 */
-	unsigned int power, power_orig;
+	unsigned int capacity, capacity_orig;
 	unsigned long next_update;
-	int imbalance; /* XXX unrelated to power but shared group state */
+	int imbalance; /* XXX unrelated to capacity but shared group state */
 	/*
 	 * Number of busy cpus in this group.
 	 */
@@ -750,7 +750,7 @@ struct sched_group {
 	atomic_t ref;
 
 	unsigned int group_weight;
-	struct sched_group_power *sgp;
+	struct sched_group_capacity *sgc;
 
 	/*
 	 * The CPUs this group covers.
@@ -773,7 +773,7 @@ static inline struct cpumask *sched_group_cpus(struct sched_group *sg)
  */
 static inline struct cpumask *sched_group_mask(struct sched_group *sg)
 {
-	return to_cpumask(sg->sgp->cpumask);
+	return to_cpumask(sg->sgc->cpumask);
 }
 
 /**
@@ -1167,7 +1167,7 @@ extern const struct sched_class idle_sched_class;
 
 #ifdef CONFIG_SMP
 
-extern void update_group_power(struct sched_domain *sd, int cpu);
+extern void update_group_capacity(struct sched_domain *sd, int cpu);
 
 extern void trigger_load_balance(struct rq *rq);
 
