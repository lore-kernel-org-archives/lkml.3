Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775AbaG1SQw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 14:16:52 -0400
Received: from shelob.surriel.com ([74.92.59.67]:45843 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaG1SQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 14:16:49 -0400
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, vincent.guittot@linaro.org, mikey@neuling.org,
        mingo@kernel.org, jhladky@redhat.com, ktkhai@parallels.com,
        tim.c.chen@linux.intel.com, nicolas.pitre@linaro.org
Subject: [PATCH 2/2] sched: make update_sd_pick_busiest return true on a busier sd
Date: Mon, 28 Jul 2014 14:16:28 -0400
Message-Id: <1406571388-3227-3-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406571388-3227-1-git-send-email-riel@redhat.com>
References: <1406571388-3227-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

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

Cc: mikey@neuling.org
Cc: peterz@infradead.org
Acked-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Rik van Riel <riel@redhat.com>
---
 kernel/sched/fair.c | 34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a28bb3b..4f5e3c2 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5610,6 +5610,8 @@ static inline void init_sd_lb_stats(struct sd_lb_stats *sds)
 		.total_capacity = 0UL,
 		.busiest_stat = {
 			.avg_load = 0UL,
+			.sum_nr_running = 0,
+			.group_imb = 0,
 		},
 	};
 }
@@ -5949,6 +5951,23 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 		sgs->group_has_free_capacity = 1;
 }
 
+enum group_type {
+	group_other = 0,
+	group_imbalanced,
+	group_overloaded,
+};
+
+static enum group_type group_classify(struct sg_lb_stats *sgs)
+{
+	if (sgs->sum_nr_running > sgs->group_capacity_factor)
+		return group_overloaded;
+
+	if (sgs->group_imb)
+		return group_imbalanced;
+
+	return group_other;
+}
+
 /**
  * update_sd_pick_busiest - return 1 on busiest group
  * @env: The load balancing environment.
@@ -5967,13 +5986,17 @@ static bool update_sd_pick_busiest(struct lb_env *env,
 				   struct sched_group *sg,
 				   struct sg_lb_stats *sgs)
 {
-	if (sgs->avg_load <= sds->busiest_stat.avg_load)
+	if (group_classify(sgs) > group_classify(&sds->busiest_stat))
+		return true;
+
+	if (group_classify(sgs) < group_classify(&sds->busiest_stat))
 		return false;
 
-	if (sgs->sum_nr_running > sgs->group_capacity_factor)
-		return true;
+	if (sgs->avg_load <= sds->busiest_stat.avg_load)
+		return false;
 
-	if (sgs->group_imb)
+	/* This is the busiest node in its class. */
+	if (!(env->sd->flags & SD_ASYM_PACKING))
 		return true;
 
 	/*
@@ -5981,8 +6004,7 @@ static bool update_sd_pick_busiest(struct lb_env *env,
 	 * numbered CPUs in the group, therefore mark all groups
 	 * higher than ourself as busy.
 	 */
-	if ((env->sd->flags & SD_ASYM_PACKING) && sgs->sum_nr_running &&
-	    env->dst_cpu < group_first_cpu(sg)) {
+	if (sgs->sum_nr_running && env->dst_cpu < group_first_cpu(sg)) {
 		if (!sds->busiest)
 			return true;
 
-- 
1.9.3

