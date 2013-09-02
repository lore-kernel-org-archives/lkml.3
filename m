Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab3IBHlf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 03:41:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52415 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757313Ab3IBHld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 03:41:33 -0400
Date: Mon, 2 Sep 2013 00:40:58 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-739xxqkyvftrhnh9ncudutc7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        preeti@linux.vnet.ibm.com, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        preeti@linux.vnet.ibm.com, peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair: Make group power more consistent
Git-Commit-ID: 3ae11c90fd055ba1b1b03a014f851b395bdd26ff
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 02 Sep 2013 00:41:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3ae11c90fd055ba1b1b03a014f851b395bdd26ff
Gitweb:     http://git.kernel.org/tip/3ae11c90fd055ba1b1b03a014f851b395bdd26ff
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 15 Aug 2013 20:37:48 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 2 Sep 2013 08:27:37 +0200

sched/fair: Make group power more consistent

For easier access, less dereferences and more consistent value, store
the group power in update_sg_lb_stats() and use it thereafter. The
actual value in sched_group::sched_group_power::power can change
throughout the load-balance pass if we're unlucky.

Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-739xxqkyvftrhnh9ncudutc7@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 41 ++++++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 19 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5795219..ccf20e7 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4239,6 +4239,7 @@ struct sg_lb_stats {
 	unsigned long group_load; /* Total load over the CPUs of the group */
 	unsigned long sum_weighted_load; /* Weighted load of group's tasks */
 	unsigned long load_per_task;
+	unsigned long group_power;
 	unsigned int sum_nr_running; /* Nr tasks running in the group */
 	unsigned int group_capacity;
 	unsigned int idle_cpus;
@@ -4518,7 +4519,8 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 		update_group_power(env->sd, env->dst_cpu);
 
 	/* Adjust by relative CPU power of the group */
-	sgs->avg_load = (sgs->group_load*SCHED_POWER_SCALE) / group->sgp->power;
+	sgs->group_power = group->sgp->power;
+	sgs->avg_load = (sgs->group_load*SCHED_POWER_SCALE) / sgs->group_power;
 
 	/*
 	 * Consider the group unbalanced when the imbalance is larger
@@ -4537,7 +4539,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 		sgs->group_imb = 1;
 
 	sgs->group_capacity =
-		DIV_ROUND_CLOSEST(group->sgp->power, SCHED_POWER_SCALE);
+		DIV_ROUND_CLOSEST(sgs->group_power, SCHED_POWER_SCALE);
 
 	if (!sgs->group_capacity)
 		sgs->group_capacity = fix_small_capacity(env->sd, group);
@@ -4637,7 +4639,7 @@ static inline void update_sd_lb_stats(struct lb_env *env,
 
 		/* Now, start updating sd_lb_stats */
 		sds->total_load += sgs->group_load;
-		sds->total_pwr += sg->sgp->power;
+		sds->total_pwr += sgs->group_power;
 
 		if (!local_group && update_sd_pick_busiest(env, sds, sg, sgs)) {
 			sds->busiest = sg;
@@ -4685,8 +4687,9 @@ static int check_asym_packing(struct lb_env *env, struct sd_lb_stats *sds)
 	if (env->dst_cpu > busiest_cpu)
 		return 0;
 
-	env->imbalance = DIV_ROUND_CLOSEST(sds->busiest_stat.avg_load *
-				sds->busiest->sgp->power, SCHED_POWER_SCALE);
+	env->imbalance = DIV_ROUND_CLOSEST(
+		sds->busiest_stat.avg_load * sds->busiest_stat.group_power,
+		SCHED_POWER_SCALE);
 
 	return 1;
 }
@@ -4716,7 +4719,7 @@ void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 
 	scaled_busy_load_per_task =
 		(busiest->load_per_task * SCHED_POWER_SCALE) /
-		sds->busiest->sgp->power;
+		busiest->group_power;
 
 	if (busiest->avg_load - local->avg_load + scaled_busy_load_per_task >=
 	    (scaled_busy_load_per_task * imbn)) {
@@ -4730,32 +4733,32 @@ void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 	 * moving them.
 	 */
 
-	pwr_now += sds->busiest->sgp->power *
+	pwr_now += busiest->group_power *
 			min(busiest->load_per_task, busiest->avg_load);
-	pwr_now += sds->local->sgp->power *
+	pwr_now += local->group_power *
 			min(local->load_per_task, local->avg_load);
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
-			sds->local->sgp->power;
+		tmp = (busiest->avg_load * busiest->group_power) /
+		      local->group_power;
 	} else {
 		tmp = (busiest->load_per_task * SCHED_POWER_SCALE) /
-			sds->local->sgp->power;
+		      local->group_power;
 	}
-	pwr_move += sds->local->sgp->power *
-			min(local->load_per_task, local->avg_load + tmp);
+	pwr_move += local->group_power *
+		    min(local->load_per_task, local->avg_load + tmp);
 	pwr_move /= SCHED_POWER_SCALE;
 
 	/* Move if we gain throughput */
@@ -4800,7 +4803,7 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 			(busiest->sum_nr_running - busiest->group_capacity);
 
 		load_above_capacity *= (SCHED_LOAD_SCALE * SCHED_POWER_SCALE);
-		load_above_capacity /= sds->busiest->sgp->power;
+		load_above_capacity /= busiest->group_power;
 	}
 
 	/*
@@ -4818,8 +4821,8 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 
 	/* How much load to actually move to equalise the imbalance */
 	env->imbalance = min(
-		max_pull * sds->busiest->sgp->power,
-		(sds->avg_load - local->avg_load) * sds->local->sgp->power
+		max_pull * busiest->group_power,
+		(sds->avg_load - local->avg_load) * local->group_power
 	) / SCHED_POWER_SCALE;
 
 	/*
