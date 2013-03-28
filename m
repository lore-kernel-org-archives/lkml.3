Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354Ab3C1H7M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 03:59:12 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:53645 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224Ab3C1H7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 03:59:05 -0400
X-AuditID: 9c930197-b7c9dae000006959-b4-5153f8459a01
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 3/5] sched: clean-up struct sd_lb_stat
Date: Thu, 28 Mar 2013 16:58:54 +0900
Message-Id: <1364457537-15114-4-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364457537-15114-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1364457537-15114-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no reason to maintain separate variables for this_group
and busiest_group in sd_lb_stat, except saving some space.
But this structure is always allocated in stack, so this saving
isn't really benificial.

This patch unify these variables, so IMO, readability may be improved.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 95ec757..204a9a9 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4175,36 +4175,6 @@ static unsigned long task_h_load(struct task_struct *p)
 
 /********** Helpers for find_busiest_group ************************/
 /*
- * sd_lb_stats - Structure to store the statistics of a sched_domain
- * 		during load balancing.
- */
-struct sd_lb_stats {
-	struct sched_group *busiest; /* Busiest group in this sd */
-	struct sched_group *this;  /* Local group in this sd */
-	unsigned long total_load;  /* Total load of all groups in sd */
-	unsigned long total_pwr;   /*	Total power of all groups in sd */
-	unsigned long avg_load;	   /* Average load across all groups in sd */
-
-	/** Statistics of this group */
-	unsigned long this_load;
-	unsigned long this_load_per_task;
-	unsigned long this_nr_running;
-	unsigned long this_has_capacity;
-	unsigned int  this_idle_cpus;
-
-	/* Statistics of the busiest group */
-	unsigned int  busiest_idle_cpus;
-	unsigned long max_load;
-	unsigned long busiest_load_per_task;
-	unsigned long busiest_nr_running;
-	unsigned long busiest_group_capacity;
-	unsigned long busiest_has_capacity;
-	unsigned int  busiest_group_weight;
-
-	int group_imb; /* Is there imbalance in this sd */
-};
-
-/*
  * sg_lb_stats - stats of a sched_group required for load_balancing
  */
 struct sg_lb_stats {
@@ -4219,6 +4189,24 @@ struct sg_lb_stats {
 	int group_has_capacity; /* Is there extra capacity in the group? */
 };
 
+/*
+ * sd_lb_stats - Structure to store the statistics of a sched_domain
+ *		during load balancing.
+ */
+struct sd_lb_stats {
+	struct sched_group *busiest; /* Busiest group in this sd */
+	struct sched_group *this;  /* Local group in this sd */
+	unsigned long total_load;  /* Total load of all groups in sd */
+	unsigned long total_pwr;   /*	Total power of all groups in sd */
+	unsigned long sd_avg_load; /* Average load across all groups in sd */
+
+	/* Statistics of this group */
+	struct sg_lb_stats this_stat;
+
+	/* Statistics of the busiest group */
+	struct sg_lb_stats busiest_stat;
+};
+
 /**
  * get_sd_load_idx - Obtain the load index for a given sched domain.
  * @sd: The sched_domain whose load_idx is to be obtained.
@@ -4499,7 +4487,7 @@ static bool update_sd_pick_busiest(struct lb_env *env,
 				   struct sched_group *sg,
 				   struct sg_lb_stats *sgs)
 {
-	if (sgs->avg_load <= sds->max_load)
+	if (sgs->avg_load <= sds->busiest_stat.avg_load)
 		return false;
 
 	if (sgs->sum_nr_running > sgs->group_capacity)
@@ -4536,7 +4524,7 @@ static inline void update_sd_lb_stats(struct lb_env *env,
 {
 	struct sched_domain *child = env->sd->child;
 	struct sched_group *sg = env->sd->groups;
-	struct sg_lb_stats sgs;
+	struct sg_lb_stats tmp_sgs;
 	int load_idx, prefer_sibling = 0;
 
 	if (child && child->flags & SD_PREFER_SIBLING)
@@ -4546,13 +4534,16 @@ static inline void update_sd_lb_stats(struct lb_env *env,
 
 	do {
 		int local_group;
+		struct sg_lb_stats *sgs;
 
 		local_group = cpumask_test_cpu(env->dst_cpu, sched_group_cpus(sg));
-		memset(&sgs, 0, sizeof(sgs));
-		update_sg_lb_stats(env, sg, load_idx, local_group, &sgs);
-
-		sds->total_load += sgs.group_load;
-		sds->total_pwr += sg->sgp->power;
+		if (local_group)
+			sgs = &sds->this_stat;
+		else {
+			sgs = &tmp_sgs;
+			memset(sgs, 0, sizeof(*sgs));
+		}
+		update_sg_lb_stats(env, sg, load_idx, local_group, sgs);
 
 		/*
 		 * In case the child domain prefers tasks go to siblings
@@ -4564,26 +4555,19 @@ static inline void update_sd_lb_stats(struct lb_env *env,
 		 * heaviest group when it is already under-utilized (possible
 		 * with a large weight task outweighs the tasks on the system).
 		 */
-		if (prefer_sibling && !local_group && sds->this_has_capacity)
-			sgs.group_capacity = min(sgs.group_capacity, 1UL);
+		if (prefer_sibling && !local_group &&
+				sds->this && sds->this_stat.group_has_capacity)
+			sgs->group_capacity = min(sgs->group_capacity, 1UL);
 
-		if (local_group) {
-			sds->this_load = sgs.avg_load;
+		/* Now, start updating sd_lb_stats */
+		sds->total_load += sgs->group_load;
+		sds->total_pwr += sg->sgp->power;
+
+		if (local_group)
 			sds->this = sg;
-			sds->this_nr_running = sgs.sum_nr_running;
-			sds->this_load_per_task = sgs.sum_weighted_load;
-			sds->this_has_capacity = sgs.group_has_capacity;
-			sds->this_idle_cpus = sgs.idle_cpus;
-		} else if (update_sd_pick_busiest(env, sds, sg, &sgs)) {
-			sds->max_load = sgs.avg_load;
+		else if (update_sd_pick_busiest(env, sds, sg, sgs)) {
 			sds->busiest = sg;
-			sds->busiest_nr_running = sgs.sum_nr_running;
-			sds->busiest_idle_cpus = sgs.idle_cpus;
-			sds->busiest_group_capacity = sgs.group_capacity;
-			sds->busiest_load_per_task = sgs.sum_weighted_load;
-			sds->busiest_has_capacity = sgs.group_has_capacity;
-			sds->busiest_group_weight = sgs.group_weight;
-			sds->group_imb = sgs.group_imb;
+			sds->busiest_stat = *sgs;
 		}
 
 		sg = sg->next;
@@ -4627,8 +4611,8 @@ static int check_asym_packing(struct lb_env *env, struct sd_lb_stats *sds)
 	if (env->dst_cpu > busiest_cpu)
 		return 0;
 
-	env->imbalance = DIV_ROUND_CLOSEST(
-		sds->max_load * sds->busiest->sgp->power, SCHED_POWER_SCALE);
+	env->imbalance = DIV_ROUND_CLOSEST(sds->busiest_stat.avg_load *
+				sds->busiest->sgp->power, SCHED_POWER_SCALE);
 
 	return 1;
 }
@@ -4646,24 +4630,22 @@ void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 	unsigned long tmp, pwr_now = 0, pwr_move = 0;
 	unsigned int imbn = 2;
 	unsigned long scaled_busy_load_per_task;
+	struct sg_lb_stats *this, *busiest;
 
-	if (sds->this_nr_running) {
-		sds->this_load_per_task /= sds->this_nr_running;
-		if (sds->busiest_load_per_task >
-				sds->this_load_per_task)
+	this = &sds->this_stat;
+	busiest = &sds->busiest_stat;
+
+	if (!this->sum_nr_running)
+		this->sum_weighted_load = cpu_avg_load_per_task(env->dst_cpu);
+	else if (busiest->sum_weighted_load > this->sum_weighted_load)
 			imbn = 1;
-	} else {
-		sds->this_load_per_task =
-			cpu_avg_load_per_task(env->dst_cpu);
-	}
 
-	scaled_busy_load_per_task = sds->busiest_load_per_task
-					 * SCHED_POWER_SCALE;
-	scaled_busy_load_per_task /= sds->busiest->sgp->power;
+	scaled_busy_load_per_task = (busiest->sum_weighted_load *
+			SCHED_POWER_SCALE) / sds->busiest->sgp->power;
 
-	if (sds->max_load - sds->this_load + scaled_busy_load_per_task >=
-			(scaled_busy_load_per_task * imbn)) {
-		env->imbalance = sds->busiest_load_per_task;
+	if (busiest->avg_load - this->avg_load + scaled_busy_load_per_task >=
+		(scaled_busy_load_per_task * imbn)) {
+		env->imbalance = busiest->sum_weighted_load;
 		return;
 	}
 
@@ -4674,33 +4656,34 @@ void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 	 */
 
 	pwr_now += sds->busiest->sgp->power *
-			min(sds->busiest_load_per_task, sds->max_load);
+			min(busiest->sum_weighted_load, busiest->avg_load);
 	pwr_now += sds->this->sgp->power *
-			min(sds->this_load_per_task, sds->this_load);
+			min(this->sum_weighted_load, this->avg_load);
 	pwr_now /= SCHED_POWER_SCALE;
 
 	/* Amount of load we'd subtract */
-	tmp = (sds->busiest_load_per_task * SCHED_POWER_SCALE) /
+	tmp = (busiest->sum_weighted_load * SCHED_POWER_SCALE) /
 		sds->busiest->sgp->power;
-	if (sds->max_load > tmp)
+	if (busiest->avg_load > tmp)
 		pwr_move += sds->busiest->sgp->power *
-			min(sds->busiest_load_per_task, sds->max_load - tmp);
+			min(busiest->sum_weighted_load,
+				busiest->avg_load - tmp);
 
 	/* Amount of load we'd add */
-	if (sds->max_load * sds->busiest->sgp->power <
-		sds->busiest_load_per_task * SCHED_POWER_SCALE)
-		tmp = (sds->max_load * sds->busiest->sgp->power) /
+	if (busiest->avg_load * sds->busiest->sgp->power <
+		busiest->sum_weighted_load * SCHED_POWER_SCALE)
+		tmp = (busiest->avg_load * sds->busiest->sgp->power) /
 			sds->this->sgp->power;
 	else
-		tmp = (sds->busiest_load_per_task * SCHED_POWER_SCALE) /
+		tmp = (busiest->sum_weighted_load * SCHED_POWER_SCALE) /
 			sds->this->sgp->power;
 	pwr_move += sds->this->sgp->power *
-			min(sds->this_load_per_task, sds->this_load + tmp);
+			min(this->sum_weighted_load, this->avg_load + tmp);
 	pwr_move /= SCHED_POWER_SCALE;
 
 	/* Move if we gain throughput */
 	if (pwr_move > pwr_now)
-		env->imbalance = sds->busiest_load_per_task;
+		env->imbalance = busiest->sum_weighted_load;
 }
 
 /**
@@ -4712,11 +4695,20 @@ void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 {
 	unsigned long max_pull, load_above_capacity = ~0UL;
+	struct sg_lb_stats *this, *busiest;
+
+	/* After below code, we use sum_weighted_load of
+	 * this_stat and busiest_stat as load_per_task */
+	this = &sds->this_stat;
+	if (this->sum_nr_running)
+		this->sum_weighted_load /= this->sum_nr_running;
 
-	sds->busiest_load_per_task /= sds->busiest_nr_running;
-	if (sds->group_imb) {
-		sds->busiest_load_per_task =
-			min(sds->busiest_load_per_task, sds->avg_load);
+	busiest = &sds->busiest_stat;
+	/* busiest must have some tasks */
+	busiest->sum_weighted_load /= busiest->sum_nr_running;
+	if (busiest->group_imb) {
+		busiest->sum_weighted_load =
+			min(busiest->sum_weighted_load, sds->sd_avg_load);
 	}
 
 	/*
@@ -4724,17 +4716,17 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 	 * max load less than avg load(as we skip the groups at or below
 	 * its cpu_power, while calculating max_load..)
 	 */
-	if (sds->max_load < sds->avg_load) {
+	if (busiest->avg_load < this->avg_load) {
 		env->imbalance = 0;
 		return fix_small_imbalance(env, sds);
 	}
 
-	if (!sds->group_imb) {
+	if (!busiest->group_imb) {
 		/*
 		 * Don't want to pull so many tasks that a group would go idle.
 		 */
-		load_above_capacity = (sds->busiest_nr_running -
-						sds->busiest_group_capacity);
+		load_above_capacity = (busiest->sum_nr_running -
+						busiest->group_capacity);
 
 		load_above_capacity *= (SCHED_LOAD_SCALE * SCHED_POWER_SCALE);
 
@@ -4751,12 +4743,13 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 	 * Be careful of negative numbers as they'll appear as very large values
 	 * with unsigned longs.
 	 */
-	max_pull = min(sds->max_load - sds->avg_load, load_above_capacity);
+	max_pull = min(busiest->avg_load - sds->sd_avg_load,
+						load_above_capacity);
 
 	/* How much load to actually move to equalise the imbalance */
 	env->imbalance = min(max_pull * sds->busiest->sgp->power,
-		(sds->avg_load - sds->this_load) * sds->this->sgp->power)
-			/ SCHED_POWER_SCALE;
+		(sds->sd_avg_load - this->avg_load) *
+			sds->this->sgp->power) / SCHED_POWER_SCALE;
 
 	/*
 	 * if *imbalance is less than the average load per runnable task
@@ -4764,7 +4757,7 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 	 * a think about bumping its value to force at least one task to be
 	 * moved
 	 */
-	if (env->imbalance < sds->busiest_load_per_task)
+	if (env->imbalance < busiest->sum_weighted_load)
 		return fix_small_imbalance(env, sds);
 
 }
@@ -4792,6 +4785,7 @@ static struct sched_group *
 find_busiest_group(struct lb_env *env)
 {
 	struct sd_lb_stats sds;
+	struct sg_lb_stats *this, *busiest;
 
 	memset(&sds, 0, sizeof(sds));
 
@@ -4800,42 +4794,44 @@ find_busiest_group(struct lb_env *env)
 	 * this level.
 	 */
 	update_sd_lb_stats(env, &sds);
+	this = &sds.this_stat;
+	busiest = &sds.busiest_stat;
 
 	if ((env->idle == CPU_IDLE || env->idle == CPU_NEWLY_IDLE) &&
 	    check_asym_packing(env, &sds))
 		return sds.busiest;
 
 	/* There is no busy sibling group to pull tasks from */
-	if (!sds.busiest || sds.busiest_nr_running == 0)
+	if (!sds.busiest || busiest->sum_nr_running == 0)
 		goto out_balanced;
 
-	sds.avg_load = (SCHED_POWER_SCALE * sds.total_load) / sds.total_pwr;
+	sds.sd_avg_load = (SCHED_POWER_SCALE * sds.total_load) / sds.total_pwr;
 
 	/*
 	 * If the busiest group is imbalanced the below checks don't
 	 * work because they assumes all things are equal, which typically
 	 * isn't true due to cpus_allowed constraints and the like.
 	 */
-	if (sds.group_imb)
+	if (busiest->group_imb)
 		goto force_balance;
 
 	/* SD_BALANCE_NEWIDLE trumps SMP nice when underutilized */
-	if (env->idle == CPU_NEWLY_IDLE && sds.this_has_capacity &&
-			!sds.busiest_has_capacity)
+	if (env->idle == CPU_NEWLY_IDLE &&
+		this->group_has_capacity && !busiest->group_has_capacity)
 		goto force_balance;
 
 	/*
 	 * If the local group is more busy than the selected busiest group
 	 * don't try and pull any tasks.
 	 */
-	if (sds.this_load >= sds.max_load)
+	if (this->avg_load >= busiest->avg_load)
 		goto out_balanced;
 
 	/*
 	 * Don't pull any tasks if this group is already above the domain
 	 * average load.
 	 */
-	if (sds.this_load >= sds.avg_load)
+	if (this->avg_load >= sds.sd_avg_load)
 		goto out_balanced;
 
 	if (env->idle == CPU_IDLE) {
@@ -4845,15 +4841,16 @@ find_busiest_group(struct lb_env *env)
 		 * there is no imbalance between this and busiest group
 		 * wrt to idle cpu's, it is balanced.
 		 */
-		if ((sds.this_idle_cpus <= sds.busiest_idle_cpus + 1) &&
-		    sds.busiest_nr_running <= sds.busiest_group_weight)
+		if ((this->idle_cpus <= busiest->idle_cpus + 1) &&
+			busiest->sum_nr_running <= busiest->group_weight)
 			goto out_balanced;
 	} else {
 		/*
 		 * In the CPU_NEWLY_IDLE, CPU_NOT_IDLE cases, use
 		 * imbalance_pct to be conservative.
 		 */
-		if (100 * sds.max_load <= env->sd->imbalance_pct * sds.this_load)
+		if (100 * busiest->avg_load <=
+				env->sd->imbalance_pct * this->avg_load)
 			goto out_balanced;
 	}
 
-- 
1.7.9.5

