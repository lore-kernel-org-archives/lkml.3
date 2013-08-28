Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab3H1LPk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 07:15:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60722 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032Ab3H1LPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 07:15:37 -0400
Date: Wed, 28 Aug 2013 13:15:27 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>, Lei Wen <leiwen@marvell.com>,
        Joonsoo Kim <js1304@gmail.com>, Rik van Riel <riel@surriel.com>
Subject: [PATCH 13/10] sched, fair: Rework and comment the group_capacity code
Message-ID: <20130828111527.GN10002@twins.programming.kicks-ass.net>
References: <20130819160058.539049611@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130819160058.539049611@infradead.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Subject: sched, fair: Rework and comment the group_capacity code
From: Peter Zijlstra <peterz@infradead.org>
Date: Wed Aug 28 11:50:34 CEST 2013

Pull out the group_capacity computation so that we can more clearly
comment its issues.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/fair.c |   32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4551,6 +4551,27 @@ static inline int sg_imbalanced(struct s
 	return group->sgp->imbalance;
 }
 
+/*
+ * Compute the group capacity.
+ *
+ * For now the capacity is simply the number of power units in the group_power.
+ * A power unit represents a full core.
+ *
+ * This has an issue where N*frac(smt_power) >= 1, in that case we'll see extra
+ * 'cores' that aren't actually there.
+ */
+static inline int sg_capacity(struct lb_env *env, struct sched_group *group)
+{
+
+	unsigned int power = group->sgp->power;
+	unsigned int capacity = DIV_ROUND_CLOSEST(power, SCHED_POWER_SCALE);
+
+	if (!capacity)
+		capacity = fix_small_capacity(env->sd, group);
+
+	return capacity;
+}
+
 /**
  * update_sg_lb_stats - Update sched_group's statistics for load balancing.
  * @env: The load balancing environment.
@@ -4594,16 +4615,11 @@ static inline void update_sg_lb_stats(st
 	if (sgs->sum_nr_running)
 		sgs->load_per_task = sgs->sum_weighted_load / sgs->sum_nr_running;
 
-	sgs->group_imb = sg_imbalanced(group);
-
-	sgs->group_capacity =
-		DIV_ROUND_CLOSEST(sgs->group_power, SCHED_POWER_SCALE);
-
-	if (!sgs->group_capacity)
-		sgs->group_capacity = fix_small_capacity(env->sd, group);
-
 	sgs->group_weight = group->group_weight;
 
+	sgs->group_imb = sg_imbalanced(group);
+	sgs->group_capacity = sg_capacity(env, group);
+
 	if (sgs->group_capacity > sgs->sum_nr_running)
 		sgs->group_has_capacity = 1;
 }
