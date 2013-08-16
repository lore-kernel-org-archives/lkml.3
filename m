Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab3HPKWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 06:22:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44347 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089Ab3HPKW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 06:22:27 -0400
Message-Id: <20130816101545.290832815@infradead.org>
User-Agent: quilt/0.60-1
Date: Fri, 16 Aug 2013 12:12:26 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>, Joonsoo Kim <js1304@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 5/6] sched, fair: Make group power more consitent
References: <20130816101221.028189677@chello.nl>
Content-Disposition: inline; filename=peterz-more-bfg-cleanups-2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For easier access, less dereferences and more consisent value, store
the group power in update_sg_lb_stats() and use it thereafter. The
actual value in sched_group::sched_group_power::power can change
throughout the load-balance pass if we're unlucky.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/fair.c |   41 ++++++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 19 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4288,6 +4288,7 @@ struct sg_lb_stats {
 	unsigned long group_capacity;
 	unsigned long idle_cpus;
 	unsigned long group_weight;
+	unsigned long group_power;
 	int group_imb; /* Is there an imbalance in the group ? */
 	int group_has_capacity; /* Is there extra capacity in the group? */
 };
@@ -4546,7 +4547,8 @@ static inline void update_sg_lb_stats(st
 		update_group_power(env->sd, env->dst_cpu);
 
 	/* Adjust by relative CPU power of the group */
-	sgs->avg_load = (sgs->group_load*SCHED_POWER_SCALE) / group->sgp->power;
+	sgs->group_power = group->sgp->power;
+	sgs->avg_load = (sgs->group_load*SCHED_POWER_SCALE) / sgs->group_power;
 
 	/*
 	 * Consider the group unbalanced when the imbalance is larger
@@ -4565,7 +4567,7 @@ static inline void update_sg_lb_stats(st
 		sgs->group_imb = 1;
 
 	sgs->group_capacity =
-		DIV_ROUND_CLOSEST(group->sgp->power, SCHED_POWER_SCALE);
+		DIV_ROUND_CLOSEST(sgs->group_power, SCHED_POWER_SCALE);
 
 	if (!sgs->group_capacity)
 		sgs->group_capacity = fix_small_capacity(env->sd, group);
@@ -4668,7 +4670,7 @@ static inline void update_sd_lb_stats(st
 
 		/* Now, start updating sd_lb_stats */
 		sds->total_load += sgs->group_load;
-		sds->total_pwr += sg->sgp->power;
+		sds->total_pwr += sgs->group_power;
 
 		if (!local_group && update_sd_pick_busiest(env, sds, sg, sgs)) {
 			sds->busiest = sg;
@@ -4716,8 +4718,9 @@ static int check_asym_packing(struct lb_
 	if (env->dst_cpu > busiest_cpu)
 		return 0;
 
-	env->imbalance = DIV_ROUND_CLOSEST(sds->busiest_stat.avg_load *
-				sds->busiest->sgp->power, SCHED_POWER_SCALE);
+	env->imbalance = DIV_ROUND_CLOSEST(
+		sds->busiest_stat.avg_load * sds->busiest_stat.group_power,
+		SCHED_POWER_SCALE);
 
 	return 1;
 }
@@ -4747,7 +4750,7 @@ void fix_small_imbalance(struct lb_env *
 
 	scaled_busy_load_per_task =
 		(busiest->load_per_task * SCHED_POWER_SCALE) /
-		sds->busiest->sgp->power;
+		busiest->group_power;
 
 	if (busiest->avg_load - this->avg_load + scaled_busy_load_per_task >=
 	    (scaled_busy_load_per_task * imbn)) {
@@ -4761,32 +4764,32 @@ void fix_small_imbalance(struct lb_env *
 	 * moving them.
 	 */
 
-	pwr_now += sds->busiest->sgp->power *
+	pwr_now += busiest->group_power *
 			min(busiest->load_per_task, busiest->avg_load);
-	pwr_now += sds->this->sgp->power *
+	pwr_now += this->group_power *
 			min(this->load_per_task, this->avg_load);
 	pwr_now /= SCHED_POWER_SCALE;
 
 	/* Amount of load we'd subtract */
 	tmp = (busiest->load_per_task * SCHED_POWER_SCALE) /
-		sds->busiest->sgp->power;
+		busiest->group_power;
 	if (busiest->avg_load > tmp) {
-		pwr_move += sds->busiest->sgp->power *
+		pwr_move += busiest->group_power *
 			    min(busiest->load_per_task,
 				busiest->avg_load - tmp);
 	}
 
 	/* Amount of load we'd add */
-	if (busiest->avg_load * sds->busiest->sgp->power <
+	if (busiest->avg_load * busiest->group_power <
 	    busiest->load_per_task * SCHED_POWER_SCALE) {
-		tmp = (busiest->avg_load * sds->busiest->sgp->power) /
-			sds->this->sgp->power;
+		tmp = (busiest->avg_load * busiest->group_power) /
+		      this->group_power;
 	} else {
 		tmp = (busiest->load_per_task * SCHED_POWER_SCALE) /
-			sds->this->sgp->power;
+		      this->group_power;
 	}
-	pwr_move += sds->this->sgp->power *
-			min(this->load_per_task, this->avg_load + tmp);
+	pwr_move += this->group_power *
+		    min(this->load_per_task, this->avg_load + tmp);
 	pwr_move /= SCHED_POWER_SCALE;
 
 	/* Move if we gain throughput */
@@ -4831,7 +4834,7 @@ static inline void calculate_imbalance(s
 			(busiest->sum_nr_running - busiest->group_capacity);
 
 		load_above_capacity *= (SCHED_LOAD_SCALE * SCHED_POWER_SCALE);
-		load_above_capacity /= sds->busiest->sgp->power;
+		load_above_capacity /= busiest->group_power;
 	}
 
 	/*
@@ -4849,8 +4852,8 @@ static inline void calculate_imbalance(s
 
 	/* How much load to actually move to equalise the imbalance */
 	env->imbalance = min(
-		max_pull * sds->busiest->sgp->power,
-		(sds->avg_load - this->avg_load) * sds->this->sgp->power
+		max_pull * busiest->group_power,
+		(sds->avg_load - this->avg_load) * this->group_power
 	) / SCHED_POWER_SCALE;
 
 	/*


