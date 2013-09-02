Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758231Ab3IBHlK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 03:41:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52386 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757600Ab3IBHlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 03:41:04 -0400
Date: Mon, 2 Sep 2013 00:40:30 -0700
From: tip-bot for Joonsoo Kim <tipbot@zytor.com>
Message-ID: <tip-56cf515b4b1567c4e8fa9926175b40c66b9ec472@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, pjt@google.com, iamjoonsoo.kim@lge.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        pjt@google.com, peterz@infradead.org, tglx@linutronix.de,
        iamjoonsoo.kim@lge.com
In-Reply-To: <1375778203-31343-4-git-send-email-iamjoonsoo.kim@lge.com>
References: <1375778203-31343-4-git-send-email-iamjoonsoo.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Clean-up struct sd_lb_stat
Git-Commit-ID: 56cf515b4b1567c4e8fa9926175b40c66b9ec472
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 02 Sep 2013 00:40:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  56cf515b4b1567c4e8fa9926175b40c66b9ec472
Gitweb:     http://git.kernel.org/tip/56cf515b4b1567c4e8fa9926175b40c66b9ec472
Author:     Joonsoo Kim <iamjoonsoo.kim@lge.com>
AuthorDate: Tue, 6 Aug 2013 17:36:43 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 2 Sep 2013 08:27:35 +0200

sched: Clean-up struct sd_lb_stat

There is no reason to maintain separate variables for this_group
and busiest_group in sd_lb_stat, except saving some space.
But this structure is always allocated in stack, so this saving
isn't really benificial [peterz: reducing stack space is good; in this
case readability increases enough that I think its still beneficial]

This patch unify these variables, so IMO, readability may be improved.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
[ Rename this to local -- avoids confusion between this_cpu and the C++ this pointer. ]
Reviewed-by: Paul  Turner <pjt@google.com>
[ Lots of style edits, a few fixes and a rename. ]
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1375778203-31343-4-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 229 ++++++++++++++++++++++++++--------------------------
 1 file changed, 114 insertions(+), 115 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9a6daf8..2da80a5 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4232,36 +4232,6 @@ static unsigned long task_h_load(struct task_struct *p)
 
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
@@ -4269,6 +4239,7 @@ struct sg_lb_stats {
 	unsigned long group_load; /* Total load over the CPUs of the group */
 	unsigned long sum_nr_running; /* Nr tasks running in the group */
 	unsigned long sum_weighted_load; /* Weighted load of group's tasks */
+	unsigned long load_per_task;
 	unsigned long group_capacity;
 	unsigned long idle_cpus;
 	unsigned long group_weight;
@@ -4276,6 +4247,21 @@ struct sg_lb_stats {
 	int group_has_capacity; /* Is there extra capacity in the group? */
 };
 
+/*
+ * sd_lb_stats - Structure to store the statistics of a sched_domain
+ *		 during load balancing.
+ */
+struct sd_lb_stats {
+	struct sched_group *busiest;	/* Busiest group in this sd */
+	struct sched_group *local;	/* Local group in this sd */
+	unsigned long total_load;	/* Total load of all groups in sd */
+	unsigned long total_pwr;	/* Total power of all groups in sd */
+	unsigned long avg_load;	/* Average load across all groups in sd */
+
+	struct sg_lb_stats local_stat;	/* Statistics of the local group */
+	struct sg_lb_stats busiest_stat;/* Statistics of the busiest group */
+};
+
 /**
  * get_sd_load_idx - Obtain the load index for a given sched domain.
  * @sd: The sched_domain whose load_idx is to be obtained.
@@ -4490,6 +4476,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 			load = target_load(i, load_idx);
 		} else {
 			load = source_load(i, load_idx);
+
 			if (load > max_cpu_load)
 				max_cpu_load = load;
 			if (min_cpu_load > load)
@@ -4531,10 +4518,12 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 	    (max_nr_running - min_nr_running) > 1)
 		sgs->group_imb = 1;
 
-	sgs->group_capacity = DIV_ROUND_CLOSEST(group->sgp->power,
-						SCHED_POWER_SCALE);
+	sgs->group_capacity =
+		DIV_ROUND_CLOSEST(group->sgp->power, SCHED_POWER_SCALE);
+
 	if (!sgs->group_capacity)
 		sgs->group_capacity = fix_small_capacity(env->sd, group);
+
 	sgs->group_weight = group->group_weight;
 
 	if (sgs->group_capacity > sgs->sum_nr_running)
@@ -4556,7 +4545,7 @@ static bool update_sd_pick_busiest(struct lb_env *env,
 				   struct sched_group *sg,
 				   struct sg_lb_stats *sgs)
 {
-	if (sgs->avg_load <= sds->max_load)
+	if (sgs->avg_load <= sds->busiest_stat.avg_load)
 		return false;
 
 	if (sgs->sum_nr_running > sgs->group_capacity)
@@ -4593,7 +4582,7 @@ static inline void update_sd_lb_stats(struct lb_env *env,
 {
 	struct sched_domain *child = env->sd->child;
 	struct sched_group *sg = env->sd->groups;
-	struct sg_lb_stats sgs;
+	struct sg_lb_stats tmp_sgs;
 	int load_idx, prefer_sibling = 0;
 
 	if (child && child->flags & SD_PREFER_SIBLING)
@@ -4602,14 +4591,17 @@ static inline void update_sd_lb_stats(struct lb_env *env,
 	load_idx = get_sd_load_idx(env->sd, env->idle);
 
 	do {
+		struct sg_lb_stats *sgs = &tmp_sgs;
 		int local_group;
 
 		local_group = cpumask_test_cpu(env->dst_cpu, sched_group_cpus(sg));
-		memset(&sgs, 0, sizeof(sgs));
-		update_sg_lb_stats(env, sg, load_idx, local_group, &sgs);
+		if (local_group) {
+			sds->local = sg;
+			sgs = &sds->local_stat;
+		}
 
-		sds->total_load += sgs.group_load;
-		sds->total_pwr += sg->sgp->power;
+		memset(sgs, 0, sizeof(*sgs));
+		update_sg_lb_stats(env, sg, load_idx, local_group, sgs);
 
 		/*
 		 * In case the child domain prefers tasks go to siblings
@@ -4621,26 +4613,17 @@ static inline void update_sd_lb_stats(struct lb_env *env,
 		 * heaviest group when it is already under-utilized (possible
 		 * with a large weight task outweighs the tasks on the system).
 		 */
-		if (prefer_sibling && !local_group && sds->this_has_capacity)
-			sgs.group_capacity = min(sgs.group_capacity, 1UL);
+		if (prefer_sibling && !local_group &&
+				sds->local && sds->local_stat.group_has_capacity)
+			sgs->group_capacity = min(sgs->group_capacity, 1UL);
 
-		if (local_group) {
-			sds->this_load = sgs.avg_load;
-			sds->this = sg;
-			sds->this_nr_running = sgs.sum_nr_running;
-			sds->this_load_per_task = sgs.sum_weighted_load;
-			sds->this_has_capacity = sgs.group_has_capacity;
-			sds->this_idle_cpus = sgs.idle_cpus;
-		} else if (update_sd_pick_busiest(env, sds, sg, &sgs)) {
-			sds->max_load = sgs.avg_load;
+		/* Now, start updating sd_lb_stats */
+		sds->total_load += sgs->group_load;
+		sds->total_pwr += sg->sgp->power;
+
+		if (!local_group && update_sd_pick_busiest(env, sds, sg, sgs)) {
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
@@ -4684,8 +4667,8 @@ static int check_asym_packing(struct lb_env *env, struct sd_lb_stats *sds)
 	if (env->dst_cpu > busiest_cpu)
 		return 0;
 
-	env->imbalance = DIV_ROUND_CLOSEST(
-		sds->max_load * sds->busiest->sgp->power, SCHED_POWER_SCALE);
+	env->imbalance = DIV_ROUND_CLOSEST(sds->busiest_stat.avg_load *
+				sds->busiest->sgp->power, SCHED_POWER_SCALE);
 
 	return 1;
 }
@@ -4703,24 +4686,23 @@ void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 	unsigned long tmp, pwr_now = 0, pwr_move = 0;
 	unsigned int imbn = 2;
 	unsigned long scaled_busy_load_per_task;
+	struct sg_lb_stats *local, *busiest;
 
-	if (sds->this_nr_running) {
-		sds->this_load_per_task /= sds->this_nr_running;
-		if (sds->busiest_load_per_task >
-				sds->this_load_per_task)
-			imbn = 1;
-	} else {
-		sds->this_load_per_task =
-			cpu_avg_load_per_task(env->dst_cpu);
-	}
+	local = &sds->local_stat;
+	busiest = &sds->busiest_stat;
 
-	scaled_busy_load_per_task = sds->busiest_load_per_task
-					 * SCHED_POWER_SCALE;
-	scaled_busy_load_per_task /= sds->busiest->sgp->power;
+	if (!local->sum_nr_running)
+		local->load_per_task = cpu_avg_load_per_task(env->dst_cpu);
+	else if (busiest->load_per_task > local->load_per_task)
+		imbn = 1;
 
-	if (sds->max_load - sds->this_load + scaled_busy_load_per_task >=
-			(scaled_busy_load_per_task * imbn)) {
-		env->imbalance = sds->busiest_load_per_task;
+	scaled_busy_load_per_task =
+		(busiest->load_per_task * SCHED_POWER_SCALE) /
+		sds->busiest->sgp->power;
+
+	if (busiest->avg_load - local->avg_load + scaled_busy_load_per_task >=
+	    (scaled_busy_load_per_task * imbn)) {
+		env->imbalance = busiest->load_per_task;
 		return;
 	}
 
@@ -4731,33 +4713,36 @@ void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 	 */
 
 	pwr_now += sds->busiest->sgp->power *
-			min(sds->busiest_load_per_task, sds->max_load);
-	pwr_now += sds->this->sgp->power *
-			min(sds->this_load_per_task, sds->this_load);
+			min(busiest->load_per_task, busiest->avg_load);
+	pwr_now += sds->local->sgp->power *
+			min(local->load_per_task, local->avg_load);
 	pwr_now /= SCHED_POWER_SCALE;
 
 	/* Amount of load we'd subtract */
-	tmp = (sds->busiest_load_per_task * SCHED_POWER_SCALE) /
+	tmp = (busiest->load_per_task * SCHED_POWER_SCALE) /
 		sds->busiest->sgp->power;
-	if (sds->max_load > tmp)
+	if (busiest->avg_load > tmp) {
 		pwr_move += sds->busiest->sgp->power *
-			min(sds->busiest_load_per_task, sds->max_load - tmp);
+			    min(busiest->load_per_task,
+				busiest->avg_load - tmp);
+	}
 
 	/* Amount of load we'd add */
-	if (sds->max_load * sds->busiest->sgp->power <
-		sds->busiest_load_per_task * SCHED_POWER_SCALE)
-		tmp = (sds->max_load * sds->busiest->sgp->power) /
-			sds->this->sgp->power;
-	else
-		tmp = (sds->busiest_load_per_task * SCHED_POWER_SCALE) /
-			sds->this->sgp->power;
-	pwr_move += sds->this->sgp->power *
-			min(sds->this_load_per_task, sds->this_load + tmp);
+	if (busiest->avg_load * sds->busiest->sgp->power <
+	    busiest->load_per_task * SCHED_POWER_SCALE) {
+		tmp = (busiest->avg_load * sds->busiest->sgp->power) /
+			sds->local->sgp->power;
+	} else {
+		tmp = (busiest->load_per_task * SCHED_POWER_SCALE) /
+			sds->local->sgp->power;
+	}
+	pwr_move += sds->local->sgp->power *
+			min(local->load_per_task, local->avg_load + tmp);
 	pwr_move /= SCHED_POWER_SCALE;
 
 	/* Move if we gain throughput */
 	if (pwr_move > pwr_now)
-		env->imbalance = sds->busiest_load_per_task;
+		env->imbalance = busiest->load_per_task;
 }
 
 /**
@@ -4769,11 +4754,22 @@ void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 {
 	unsigned long max_pull, load_above_capacity = ~0UL;
+	struct sg_lb_stats *local, *busiest;
+
+	local = &sds->local_stat;
+	if (local->sum_nr_running) {
+		local->load_per_task =
+			local->sum_weighted_load / local->sum_nr_running;
+	}
 
-	sds->busiest_load_per_task /= sds->busiest_nr_running;
-	if (sds->group_imb) {
-		sds->busiest_load_per_task =
-			min(sds->busiest_load_per_task, sds->avg_load);
+	busiest = &sds->busiest_stat;
+	/* busiest must have some tasks */
+	busiest->load_per_task =
+		busiest->sum_weighted_load / busiest->sum_nr_running;
+
+	if (busiest->group_imb) {
+		busiest->load_per_task =
+			min(busiest->load_per_task, sds->avg_load);
 	}
 
 	/*
@@ -4781,20 +4777,19 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 	 * max load less than avg load(as we skip the groups at or below
 	 * its cpu_power, while calculating max_load..)
 	 */
-	if (sds->max_load < sds->avg_load) {
+	if (busiest->avg_load < sds->avg_load) {
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
+		load_above_capacity =
+			(busiest->sum_nr_running - busiest->group_capacity);
 
 		load_above_capacity *= (SCHED_LOAD_SCALE * SCHED_POWER_SCALE);
-
 		load_above_capacity /= sds->busiest->sgp->power;
 	}
 
@@ -4808,12 +4803,14 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 	 * Be careful of negative numbers as they'll appear as very large values
 	 * with unsigned longs.
 	 */
-	max_pull = min(sds->max_load - sds->avg_load, load_above_capacity);
+	max_pull = min(busiest->avg_load - sds->avg_load,
+		       load_above_capacity);
 
 	/* How much load to actually move to equalise the imbalance */
-	env->imbalance = min(max_pull * sds->busiest->sgp->power,
-		(sds->avg_load - sds->this_load) * sds->this->sgp->power)
-			/ SCHED_POWER_SCALE;
+	env->imbalance = min(
+		max_pull * sds->busiest->sgp->power,
+		(sds->avg_load - local->avg_load) * sds->local->sgp->power
+	) / SCHED_POWER_SCALE;
 
 	/*
 	 * if *imbalance is less than the average load per runnable task
@@ -4821,9 +4818,8 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 	 * a think about bumping its value to force at least one task to be
 	 * moved
 	 */
-	if (env->imbalance < sds->busiest_load_per_task)
+	if (env->imbalance < busiest->load_per_task)
 		return fix_small_imbalance(env, sds);
-
 }
 
 /******* find_busiest_group() helpers end here *********************/
@@ -4845,9 +4841,9 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
  *		   return the least loaded group whose CPUs can be
  *		   put to idle by rebalancing its tasks onto our group.
  */
-static struct sched_group *
-find_busiest_group(struct lb_env *env)
+static struct sched_group *find_busiest_group(struct lb_env *env)
 {
+	struct sg_lb_stats *local, *busiest;
 	struct sd_lb_stats sds;
 
 	memset(&sds, 0, sizeof(sds));
@@ -4857,13 +4853,15 @@ find_busiest_group(struct lb_env *env)
 	 * this level.
 	 */
 	update_sd_lb_stats(env, &sds);
+	local = &sds.local_stat;
+	busiest = &sds.busiest_stat;
 
 	if ((env->idle == CPU_IDLE || env->idle == CPU_NEWLY_IDLE) &&
 	    check_asym_packing(env, &sds))
 		return sds.busiest;
 
 	/* There is no busy sibling group to pull tasks from */
-	if (!sds.busiest || sds.busiest_nr_running == 0)
+	if (!sds.busiest || busiest->sum_nr_running == 0)
 		goto out_balanced;
 
 	sds.avg_load = (SCHED_POWER_SCALE * sds.total_load) / sds.total_pwr;
@@ -4873,26 +4871,26 @@ find_busiest_group(struct lb_env *env)
 	 * work because they assumes all things are equal, which typically
 	 * isn't true due to cpus_allowed constraints and the like.
 	 */
-	if (sds.group_imb)
+	if (busiest->group_imb)
 		goto force_balance;
 
 	/* SD_BALANCE_NEWIDLE trumps SMP nice when underutilized */
-	if (env->idle == CPU_NEWLY_IDLE && sds.this_has_capacity &&
-			!sds.busiest_has_capacity)
+	if (env->idle == CPU_NEWLY_IDLE && local->group_has_capacity &&
+	    !busiest->group_has_capacity)
 		goto force_balance;
 
 	/*
 	 * If the local group is more busy than the selected busiest group
 	 * don't try and pull any tasks.
 	 */
-	if (sds.this_load >= sds.max_load)
+	if (local->avg_load >= busiest->avg_load)
 		goto out_balanced;
 
 	/*
 	 * Don't pull any tasks if this group is already above the domain
 	 * average load.
 	 */
-	if (sds.this_load >= sds.avg_load)
+	if (local->avg_load >= sds.avg_load)
 		goto out_balanced;
 
 	if (env->idle == CPU_IDLE) {
@@ -4902,15 +4900,16 @@ find_busiest_group(struct lb_env *env)
 		 * there is no imbalance between this and busiest group
 		 * wrt to idle cpu's, it is balanced.
 		 */
-		if ((sds.this_idle_cpus <= sds.busiest_idle_cpus + 1) &&
-		    sds.busiest_nr_running <= sds.busiest_group_weight)
+		if ((local->idle_cpus < busiest->idle_cpus) &&
+		    busiest->sum_nr_running <= busiest->group_weight)
 			goto out_balanced;
 	} else {
 		/*
 		 * In the CPU_NEWLY_IDLE, CPU_NOT_IDLE cases, use
 		 * imbalance_pct to be conservative.
 		 */
-		if (100 * sds.max_load <= env->sd->imbalance_pct * sds.this_load)
+		if (100 * busiest->avg_load <=
+				env->sd->imbalance_pct * local->avg_load)
 			goto out_balanced;
 	}
 
