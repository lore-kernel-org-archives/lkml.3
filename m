Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbaIKPjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 11:39:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:56847 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943AbaIKPjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 11:39:13 -0400
Date: Thu, 11 Sep 2014 17:39:10 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, preeti@linux.vnet.ibm.com,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        riel@redhat.com, Morten.Rasmussen@arm.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org, dietmar.eggemann@arm.com
Subject: Re: [PATCH v5 11/12] sched: replace capacity_factor by utilization
Message-ID: <20140911153910.GZ3190@worktop.ger.corp.intel.com>
References: <1409051215-16788-1-git-send-email-vincent.guittot@linaro.org>
 <1409051215-16788-12-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409051215-16788-12-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 01:06:54PM +0200, Vincent Guittot wrote:
> The scheduler tries to compute how many tasks a group of CPUs can handle by
> assuming that a task's load is SCHED_LOAD_SCALE and a CPU capacity is
> SCHED_CAPACITY_SCALE.
> We can now have a better idea of the capacity of a group of CPUs and of the
> utilization of this group thanks to the rework of group_capacity_orig and the
> group_utilization. We can now deduct how many capacity is still available.
> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---

A few minor changes I did while going through it.

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5669,7 +5669,7 @@ struct sg_lb_stats {
 	unsigned int idle_cpus;
 	unsigned int group_weight;
 	enum group_type group_type;
-	int group_out_of_capacity;
+	int group_no_capacity;
 #ifdef CONFIG_NUMA_BALANCING
 	unsigned int nr_numa_running;
 	unsigned int nr_preferred_running;
@@ -5931,37 +5931,37 @@ static inline int sg_imbalanced(struct s
 	return group->sgc->imbalance;
 }
 
-static inline int group_has_free_capacity(struct sg_lb_stats *sgs,
-			struct lb_env *env)
+static inline bool
+group_has_capacity(struct lb_env *env, struct sg_lb_stats *sgs)
 {
 	if ((sgs->group_capacity_orig * 100) >
 			(sgs->group_utilization * env->sd->imbalance_pct))
-		return 1;
+		return true;
 
 	if (sgs->sum_nr_running < sgs->group_weight)
-		return 1;
+		return true;
 
-	return 0;
+	return false;
 }
 
-static inline int group_is_overloaded(struct sg_lb_stats *sgs,
-			struct lb_env *env)
+static inline bool
+group_is_overloaded(struct lb_env *env, struct sg_lb_stats *sgs)
 {
 	if (sgs->sum_nr_running <= sgs->group_weight)
-		return 0;
+		return false;
 
 	if ((sgs->group_capacity_orig * 100) <
 			(sgs->group_utilization * env->sd->imbalance_pct))
-		return 1;
+		return true;
 
-	return 0;
+	return false;
 }
 
-static enum group_type
-group_classify(struct sched_group *group, struct sg_lb_stats *sgs,
-			struct lb_env *env)
+static enum group_type group_classify(struct lb_env *env,
+				      struct sched_group *group,
+				      struct sg_lb_stats *sgs)
 {
-	if (group_is_overloaded(sgs, env))
+	if (group_is_overloaded(env, sgs))
 		return group_overloaded;
 
 	if (sg_imbalanced(group))
@@ -6024,9 +6024,8 @@ static inline void update_sg_lb_stats(st
 
 	sgs->group_weight = group->group_weight;
 
-	sgs->group_type = group_classify(group, sgs, env);
-
-	sgs->group_out_of_capacity = group_is_overloaded(sgs, env);
+	sgs->group_type = group_classify(env, group, sgs);
+	sgs->group_no_capacity = group_is_overloaded(env, sgs);
 }
 
 /**
@@ -6157,9 +6156,9 @@ static inline void update_sd_lb_stats(st
 		 * with a large weight task outweighs the tasks on the system).
 		 */
 		if (prefer_sibling && sds->local &&
-		    group_has_free_capacity(&sds->local_stat, env)) {
+		    group_has_capacity(env, &sds->local_stat)) {
 			if (sgs->sum_nr_running > 1)
-				sgs->group_out_of_capacity = 1;
+				sgs->group_no_capacity = 1;
 			sgs->group_capacity = min(sgs->group_capacity,
 						SCHED_CAPACITY_SCALE);
 		}
@@ -6430,9 +6429,8 @@ static struct sched_group *find_busiest_
 		goto force_balance;
 
 	/* SD_BALANCE_NEWIDLE trumps SMP nice when underutilized */
-	if (env->idle == CPU_NEWLY_IDLE &&
-			group_has_free_capacity(local, env) &&
-			busiest->group_out_of_capacity)
+	if (env->idle == CPU_NEWLY_IDLE && group_has_capacity(env, local) &&
+	    busiest->group_no_capacity)
 		goto force_balance;
 
 	/*
