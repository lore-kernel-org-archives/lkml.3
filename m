Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbaG2P1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:27:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:38177 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789AbaG2P1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:27:45 -0400
Date: Tue, 29 Jul 2014 17:27:43 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, vincent.guittot@linaro.org,
        mikey@neuling.org, mingo@kernel.org, jhladky@redhat.com,
        ktkhai@parallels.com, tim.c.chen@linux.intel.com,
        nicolas.pitre@linaro.org
Subject: Re: [PATCH 2/2] sched: make update_sd_pick_busiest return true on a
 busier sd
Message-ID: <20140729152743.GI3935@laptop>
References: <1406571388-3227-1-git-send-email-riel@redhat.com>
 <1406571388-3227-3-git-send-email-riel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406571388-3227-3-git-send-email-riel@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Made that:

---
Subject: sched,fair: Make update_sd_pick_busiest return true on a busier sd
From: Rik van Riel <riel@redhat.com>
Date: Mon, 28 Jul 2014 14:16:28 -0400

Currently update_sd_pick_busiest only identifies the busiest sd
that is either overloaded, or has a group imbalance. When no
sd is imbalanced or overloaded, the load balancer fails to find
the busiest domain.

This breaks load balancing between domains that are not overloaded,
in the !SD_ASYM_PACKING case. This patch makes update_sd_pick_busiest
return true when the busiest sd yet is encountered.

Groups are ranked in the order overloaded > imbalanced > other,
with higher ranked groups getting priority even when their load
is lower. This is necessary due to the possibility of unequal
capacities and cpumasks between domains within a sched group.

Behaviour for SD_ASYM_PACKING does not seem to match the comment,
but I have no hardware to test that so I have left the behaviour
of that code unchanged.

Enum for group classification suggested by Peter Zijlstra.

Cc: ktkhai@parallels.com
Cc: tim.c.chen@linux.intel.com
Cc: nicolas.pitre@linaro.org
Cc: vincent.guittot@linaro.org
Cc: mingo@kernel.org
Cc: jhladky@redhat.com
Acked-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Rik van Riel <riel@redhat.com>
[peterz: replaced sg_lb_stats::group_imb with the new enum group_type
         in an attempt to avoid endless recalculation]
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1406571388-3227-3-git-send-email-riel@redhat.com
---
 kernel/sched/fair.c |   49 +++++++++++++++++++++++++++++++++++++------------
 1 file changed, 37 insertions(+), 12 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5559,6 +5559,13 @@ static unsigned long task_h_load(struct
 #endif
 
 /********** Helpers for find_busiest_group ************************/
+
+enum group_type {
+	group_other = 0,
+	group_imbalanced,
+	group_overloaded,
+};
+
 /*
  * sg_lb_stats - stats of a sched_group required for load_balancing
  */
@@ -5572,7 +5579,7 @@ struct sg_lb_stats {
 	unsigned int group_capacity_factor;
 	unsigned int idle_cpus;
 	unsigned int group_weight;
-	int group_imb; /* Is there an imbalance in the group ? */
+	enum group_type group_type;
 	int group_has_free_capacity;
 #ifdef CONFIG_NUMA_BALANCING
 	unsigned int nr_numa_running;
@@ -5610,6 +5617,8 @@ static inline void init_sd_lb_stats(stru
 		.total_capacity = 0UL,
 		.busiest_stat = {
 			.avg_load = 0UL,
+			.sum_nr_running = 0,
+			.group_type = group_other,
 		},
 	};
 }
@@ -5891,6 +5900,18 @@ static inline int sg_capacity_factor(str
 	return capacity_factor;
 }
 
+static enum group_type
+group_classify(struct sched_group *group, struct sg_lb_stats *sgs)
+{
+	if (sgs->sum_nr_running > sgs->group_capacity_factor)
+		return group_overloaded;
+
+	if (sg_imbalanced(group))
+		return group_imbalanced;
+
+	return group_other;
+}
+
 /**
  * update_sg_lb_stats - Update sched_group's statistics for load balancing.
  * @env: The load balancing environment.
@@ -5942,9 +5963,8 @@ static inline void update_sg_lb_stats(st
 		sgs->load_per_task = sgs->sum_weighted_load / sgs->sum_nr_running;
 
 	sgs->group_weight = group->group_weight;
-
-	sgs->group_imb = sg_imbalanced(group);
 	sgs->group_capacity_factor = sg_capacity_factor(env, group);
+	sgs->group_type = group_classify(group, sgs);
 
 	if (sgs->group_capacity_factor > sgs->sum_nr_running)
 		sgs->group_has_free_capacity = 1;
@@ -5968,13 +5988,19 @@ static bool update_sd_pick_busiest(struc
 				   struct sched_group *sg,
 				   struct sg_lb_stats *sgs)
 {
-	if (sgs->avg_load <= sds->busiest_stat.avg_load)
-		return false;
+	struct sg_lb_stats *busiest = &sds->busiest_stat;
 
-	if (sgs->sum_nr_running > sgs->group_capacity_factor)
+	if (sgs->group_type > busiest->group_type)
 		return true;
 
-	if (sgs->group_imb)
+	if (sgs->group_type < busiest->group_type)
+		return false;
+
+	if (sgs->avg_load <= busiest->avg_load)
+		return false;
+
+	/* This is the busiest node in its class. */
+	if (!(env->sd->flags & SD_ASYM_PACKING))
 		return true;
 
 	/*
@@ -5982,8 +6008,7 @@ static bool update_sd_pick_busiest(struc
 	 * numbered CPUs in the group, therefore mark all groups
 	 * higher than ourself as busy.
 	 */
-	if ((env->sd->flags & SD_ASYM_PACKING) && sgs->sum_nr_running &&
-	    env->dst_cpu < group_first_cpu(sg)) {
+	if (sgs->sum_nr_running && env->dst_cpu < group_first_cpu(sg)) {
 		if (!sds->busiest)
 			return true;
 
@@ -6228,7 +6253,7 @@ static inline void calculate_imbalance(s
 	local = &sds->local_stat;
 	busiest = &sds->busiest_stat;
 
-	if (busiest->group_imb) {
+	if (busiest->group_type == group_imbalanced) {
 		/*
 		 * In the group_imb case we cannot rely on group-wide averages
 		 * to ensure cpu-load equilibrium, look at wider averages. XXX
@@ -6248,7 +6273,7 @@ static inline void calculate_imbalance(s
 		return fix_small_imbalance(env, sds);
 	}
 
-	if (busiest->sum_nr_running > busiest->group_capacity_factor) {
+	if (busiest->group_type == group_overloaded) {
 		/*
 		 * Don't want to pull so many tasks that a group would go idle.
 		 * Except of course for the group_imb case, since then we might
@@ -6337,7 +6362,7 @@ static struct sched_group *find_busiest_
 	 * work because they assume all things are equal, which typically
 	 * isn't true due to cpus_allowed constraints and the like.
 	 */
-	if (busiest->group_imb)
+	if (busiest->group_type == group_imbalanced)
 		goto force_balance;
 
 	/* SD_BALANCE_NEWIDLE trumps SMP nice when underutilized */
