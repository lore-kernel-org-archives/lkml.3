Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641Ab3HOLJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 07:09:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50109 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195Ab3HOLJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 07:09:24 -0400
Date: Thu, 15 Aug 2013 13:09:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Mike Galbraith <efault@gmx.de>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>, Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH v3 3/3] sched: clean-up struct sd_lb_stat
Message-ID: <20130815110905.GO24092@twins.programming.kicks-ass.net>
References: <1375778203-31343-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1375778203-31343-4-git-send-email-iamjoonsoo.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375778203-31343-4-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 05:36:43PM +0900, Joonsoo Kim wrote:
> There is no reason to maintain separate variables for this_group
> and busiest_group in sd_lb_stat, except saving some space.
> But this structure is always allocated in stack, so this saving
> isn't really benificial.
> 
> This patch unify these variables, so IMO, readability may be improved.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

So I like the idea I had to reformat some of the code and I think we can
do less memsets. See how the below reduces the sds memset by the two
sgs. If we never set busiest we'll never look at sds->busiest_stat so we
don't need to clear that. And if we make the sgs memset in
update_sd_lb_stats() unconditional we'll cover sds->this_stats while
reducing complexity.

Still need to stare at your patches in a little more detail.. its far
too easy to mess this up :/

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4567,10 +4567,12 @@ static inline void update_sg_lb_stats(st
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
@@ -4641,16 +4643,14 @@ static inline void update_sd_lb_stats(st
 	load_idx = get_sd_load_idx(env->sd, env->idle);
 
 	do {
+		struct sg_lb_stats *sgs = &tmp_sgs;
 		int local_group;
-		struct sg_lb_stats *sgs;
 
 		local_group = cpumask_test_cpu(env->dst_cpu, sched_group_cpus(sg));
 		if (local_group)
 			sgs = &sds->this_stat;
-		else {
-			sgs = &tmp_sgs;
-			memset(sgs, 0, sizeof(*sgs));
-		}
+
+		memset(sgs, 0, sizeof(*sgs));
 		update_sg_lb_stats(env, sg, load_idx, local_group, sgs);
 
 		/*
@@ -4746,13 +4746,14 @@ void fix_small_imbalance(struct lb_env *
 	if (!this->sum_nr_running)
 		this->load_per_task = cpu_avg_load_per_task(env->dst_cpu);
 	else if (busiest->load_per_task > this->load_per_task)
-			imbn = 1;
+		imbn = 1;
 
-	scaled_busy_load_per_task = (busiest->load_per_task *
-			SCHED_POWER_SCALE) / sds->busiest->sgp->power;
+	scaled_busy_load_per_task = 
+		(busiest->load_per_task * SCHED_POWER_SCALE) / 
+		sds->busiest->sgp->power;
 
 	if (busiest->avg_load - this->avg_load + scaled_busy_load_per_task >=
-		(scaled_busy_load_per_task * imbn)) {
+	    (scaled_busy_load_per_task * imbn)) {
 		env->imbalance = busiest->load_per_task;
 		return;
 	}
@@ -4772,19 +4773,21 @@ void fix_small_imbalance(struct lb_env *
 	/* Amount of load we'd subtract */
 	tmp = (busiest->load_per_task * SCHED_POWER_SCALE) /
 		sds->busiest->sgp->power;
-	if (busiest->avg_load > tmp)
+	if (busiest->avg_load > tmp) {
 		pwr_move += sds->busiest->sgp->power *
-			min(busiest->load_per_task,
+			    min(busiest->load_per_task,
 				busiest->avg_load - tmp);
+	}
 
 	/* Amount of load we'd add */
 	if (busiest->avg_load * sds->busiest->sgp->power <
-		busiest->load_per_task * SCHED_POWER_SCALE)
+	    busiest->load_per_task * SCHED_POWER_SCALE) {
 		tmp = (busiest->avg_load * sds->busiest->sgp->power) /
 			sds->this->sgp->power;
-	else
+	} else {
 		tmp = (busiest->load_per_task * SCHED_POWER_SCALE) /
 			sds->this->sgp->power;
+	}
 	pwr_move += sds->this->sgp->power *
 			min(this->load_per_task, this->avg_load + tmp);
 	pwr_move /= SCHED_POWER_SCALE;
@@ -4807,14 +4810,15 @@ static inline void calculate_imbalance(s
 
 	this = &sds->this_stat;
 	if (this->sum_nr_running) {
-		this->load_per_task = this->sum_weighted_load /
-						this->sum_nr_running;
+		this->load_per_task = 
+			this->sum_weighted_load / this->sum_nr_running;
 	}
 
 	busiest = &sds->busiest_stat;
 	/* busiest must have some tasks */
-	busiest->load_per_task = busiest->sum_weighted_load /
-						busiest->sum_nr_running;
+	busiest->load_per_task = 
+		busiest->sum_weighted_load / busiest->sum_nr_running;
+
 	if (busiest->group_imb) {
 		busiest->load_per_task =
 			min(busiest->load_per_task, sds->sd_avg_load);
@@ -4834,11 +4838,10 @@ static inline void calculate_imbalance(s
 		/*
 		 * Don't want to pull so many tasks that a group would go idle.
 		 */
-		load_above_capacity = (busiest->sum_nr_running -
-						busiest->group_capacity);
+		load_above_capacity = 
+			(busiest->sum_nr_running - busiest->group_capacity);
 
 		load_above_capacity *= (SCHED_LOAD_SCALE * SCHED_POWER_SCALE);
-
 		load_above_capacity /= sds->busiest->sgp->power;
 	}
 
@@ -4853,12 +4856,13 @@ static inline void calculate_imbalance(s
 	 * with unsigned longs.
 	 */
 	max_pull = min(busiest->avg_load - sds->sd_avg_load,
-						load_above_capacity);
+		       load_above_capacity);
 
 	/* How much load to actually move to equalise the imbalance */
-	env->imbalance = min(max_pull * sds->busiest->sgp->power,
-		(sds->sd_avg_load - this->avg_load) *
-			sds->this->sgp->power) / SCHED_POWER_SCALE;
+	env->imbalance = min(
+		max_pull * sds->busiest->sgp->power,
+		(sds->sd_avg_load - this->avg_load) * sds->this->sgp->power
+	) / SCHED_POWER_SCALE;
 
 	/*
 	 * if *imbalance is less than the average load per runnable task
@@ -4868,7 +4872,6 @@ static inline void calculate_imbalance(s
 	 */
 	if (env->imbalance < busiest->load_per_task)
 		return fix_small_imbalance(env, sds);
-
 }
 
 /******* find_busiest_group() helpers end here *********************/
@@ -4890,13 +4893,12 @@ static inline void calculate_imbalance(s
  *		   return the least loaded group whose CPUs can be
  *		   put to idle by rebalancing its tasks onto our group.
  */
-static struct sched_group *
-find_busiest_group(struct lb_env *env)
+static struct sched_group *find_busiest_group(struct lb_env *env)
 {
-	struct sd_lb_stats sds;
 	struct sg_lb_stats *this, *busiest;
+	struct sd_lb_stats sds;
 
-	memset(&sds, 0, sizeof(sds));
+	memset(&sds, 0, sizeof(sds) - 2*sizeof(struct sg_lb_stats));
 
 	/*
 	 * Compute the various statistics relavent for load balancing at
@@ -4925,8 +4927,8 @@ find_busiest_group(struct lb_env *env)
 		goto force_balance;
 
 	/* SD_BALANCE_NEWIDLE trumps SMP nice when underutilized */
-	if (env->idle == CPU_NEWLY_IDLE &&
-		this->group_has_capacity && !busiest->group_has_capacity)
+	if (env->idle == CPU_NEWLY_IDLE && this->group_has_capacity && 
+	    !busiest->group_has_capacity)
 		goto force_balance;
 
 	/*
@@ -4951,7 +4953,7 @@ find_busiest_group(struct lb_env *env)
 		 * wrt to idle cpu's, it is balanced.
 		 */
 		if ((this->idle_cpus <= busiest->idle_cpus + 1) &&
-			busiest->sum_nr_running <= busiest->group_weight)
+		    busiest->sum_nr_running <= busiest->group_weight)
 			goto out_balanced;
 	} else {
 		/*
