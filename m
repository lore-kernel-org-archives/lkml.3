Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab3H1I4E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 04:56:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57457 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab3H1I4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 04:56:01 -0400
Date: Wed, 28 Aug 2013 10:55:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>, Lei Wen <leiwen@marvell.com>,
        Joonsoo Kim <js1304@gmail.com>, Rik van Riel <riel@surriel.com>
Subject: [RFC][PATCH 11/10] sched, fair: Reduce local_group logic
Message-ID: <20130828085542.GI10002@twins.programming.kicks-ass.net>
References: <20130819160058.539049611@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130819160058.539049611@infradead.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Subject: sched, fair: Reduce local_group logic
From: Peter Zijlstra <peterz@infradead.org>
Date: Wed Aug 28 10:32:32 CEST 2013

Try and reduce the local_group logic by pulling most of it into
update_sd_lb_stats.

We could completely get rid of the local_group variable, but that
results in two calls to update_sg_lb_stats() and that blows up the
object size by about 2k :/

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/fair.c |   29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4561,6 +4561,8 @@ static inline void update_sg_lb_stats(st
 	unsigned long load;
 	int i;
 
+	memset(sgs, 0, sizeof(*sgs));
+
 	for_each_cpu_and(i, sched_group_cpus(group), env->cpus) {
 		struct rq *rq = cpu_rq(i);
 
@@ -4579,10 +4581,6 @@ static inline void update_sg_lb_stats(st
 			sgs->idle_cpus++;
 	}
 
-	if (local_group && (env->idle != CPU_NEWLY_IDLE ||
-			time_after_eq(jiffies, group->sgp->next_update)))
-		update_group_power(env->sd, env->dst_cpu);
-
 	/* Adjust by relative CPU power of the group */
 	sgs->group_power = group->sgp->power;
 	sgs->avg_load = (sgs->group_load*SCHED_POWER_SCALE) / sgs->group_power;
@@ -4675,11 +4673,17 @@ static inline void update_sd_lb_stats(st
 		if (local_group) {
 			sds->local = sg;
 			sgs = &sds->local_stat;
+
+			if (env->idle != CPU_NEWLY_IDLE ||
+			    time_after_eq(jiffies, sg->sgp->next_update))
+				update_group_power(env->sd, env->dst_cpu);
 		}
 
-		memset(sgs, 0, sizeof(*sgs));
 		update_sg_lb_stats(env, sg, load_idx, local_group, sgs);
 
+		if (local_group)
+			goto next_group;
+
 		/*
 		 * In case the child domain prefers tasks go to siblings
 		 * first, lower the sg capacity to one so that we'll try
@@ -4690,19 +4694,20 @@ static inline void update_sd_lb_stats(st
 		 * heaviest group when it is already under-utilized (possible
 		 * with a large weight task outweighs the tasks on the system).
 		 */
-		if (prefer_sibling && !local_group &&
-				sds->local && sds->local_stat.group_has_capacity)
+		if (prefer_sibling && sds->local &&
+		    sds->local_stat.group_has_capacity)
 			sgs->group_capacity = min(sgs->group_capacity, 1U);
 
-		/* Now, start updating sd_lb_stats */
-		sds->total_load += sgs->group_load;
-		sds->total_pwr += sgs->group_power;
-
-		if (!local_group && update_sd_pick_busiest(env, sds, sg, sgs)) {
+		if (update_sd_pick_busiest(env, sds, sg, sgs)) {
 			sds->busiest = sg;
 			sds->busiest_stat = *sgs;
 		}
 
+next_group:
+		/* Now, start updating sd_lb_stats */
+		sds->total_load += sgs->group_load;
+		sds->total_pwr += sgs->group_power;
+
 		sg = sg->next;
 	} while (sg != env->sd->groups);
 }
