Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbaG1SQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 14:16:56 -0400
Received: from shelob.surriel.com ([74.92.59.67]:45844 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaG1SQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 14:16:49 -0400
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, vincent.guittot@linaro.org, mikey@neuling.org,
        mingo@kernel.org, jhladky@redhat.com, ktkhai@parallels.com,
        tim.c.chen@linux.intel.com, nicolas.pitre@linaro.org
Subject: [PATCH 1/2] sched: fix and clean up calculate_imbalance
Date: Mon, 28 Jul 2014 14:16:27 -0400
Message-Id: <1406571388-3227-2-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406571388-3227-1-git-send-email-riel@redhat.com>
References: <1406571388-3227-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

There are several ways in which update_sd_pick_busiest can end up
picking an sd as "busiest" that has a below-average per-cpu load.

All of those could use the same correction that was previously only
applied when the selected group has a group imbalance.

Additionally, the load balancing code will balance out the load between
domains that are below their maximum capacity. This results in the
load_above_capacity calculation underflowing, creating a giant unsigned
number, which is then removed by the min() check below.

In situations where all the domains are overloaded, or where only the
busiest domain is overloaded, that code is also superfluous, since
the normal env->imbalance calculation will figure out how much to move.
Remove the load_above_capacity calculation.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 kernel/sched/fair.c | 33 ++++++++-------------------------
 1 file changed, 8 insertions(+), 25 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 45943b2..a28bb3b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6221,16 +6221,16 @@ void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
  */
 static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 {
-	unsigned long max_pull, load_above_capacity = ~0UL;
 	struct sg_lb_stats *local, *busiest;
 
 	local = &sds->local_stat;
 	busiest = &sds->busiest_stat;
 
-	if (busiest->group_imb) {
+	if (busiest->avg_load <= sds->avg_load) {
 		/*
-		 * In the group_imb case we cannot rely on group-wide averages
-		 * to ensure cpu-load equilibrium, look at wider averages. XXX
+		 * Busiest got picked because it is overloaded or imbalanced,
+		 * but does not have an above-average load. Look at wider
+		 * averages.
 		 */
 		busiest->load_per_task =
 			min(busiest->load_per_task, sds->avg_load);
@@ -6247,32 +6247,15 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 		return fix_small_imbalance(env, sds);
 	}
 
-	if (!busiest->group_imb) {
-		/*
-		 * Don't want to pull so many tasks that a group would go idle.
-		 * Except of course for the group_imb case, since then we might
-		 * have to drop below capacity to reach cpu-load equilibrium.
-		 */
-		load_above_capacity =
-			(busiest->sum_nr_running - busiest->group_capacity_factor);
-
-		load_above_capacity *= (SCHED_LOAD_SCALE * SCHED_CAPACITY_SCALE);
-		load_above_capacity /= busiest->group_capacity;
-	}
-
 	/*
 	 * We're trying to get all the cpus to the average_load, so we don't
 	 * want to push ourselves above the average load, nor do we wish to
-	 * reduce the max loaded cpu below the average load. At the same time,
-	 * we also don't want to reduce the group load below the group capacity
-	 * (so that we can implement power-savings policies etc). Thus we look
-	 * for the minimum possible imbalance.
+	 * reduce the max loaded cpu below the average load.
+	 * The per-cpu avg_load values and the group capacity determine
+	 * how much load to move to equalise the imbalance.
 	 */
-	max_pull = min(busiest->avg_load - sds->avg_load, load_above_capacity);
-
-	/* How much load to actually move to equalise the imbalance */
 	env->imbalance = min(
-		max_pull * busiest->group_capacity,
+		(busiest->avg_load - sds->avg_load) * busiest->group_capacity,
 		(sds->avg_load - local->avg_load) * local->group_capacity
 	) / SCHED_CAPACITY_SCALE;
 
-- 
1.9.3

