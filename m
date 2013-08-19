Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488Ab3HSQPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 12:15:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36055 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab3HSQN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 12:13:27 -0400
Message-Id: <20130819160425.601149076@infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 19 Aug 2013 18:01:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>, Lei Wen <leiwen@marvell.com>,
        Joonsoo Kim <js1304@gmail.com>, Rik van Riel <riel@surriel.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 08/10] sched, fair: Rework and comment the group_imb code
References: <20130819160058.539049611@infradead.org>
Content-Disposition: inline; filename=peterz-group_imb-frubbery.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik reported some weirdness due to the group_imb code. As a start to
looking at it, clean it up a little and add a few explanatory
comments.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/fair.c |  123 +++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 89 insertions(+), 34 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4491,6 +4491,81 @@ fix_small_capacity(struct sched_domain *
 	return 0;
 }
 
+/*
+ * Group imbalance indicates (and tries to solve) the problem where balancing
+ * groups is inadequate due to tsk_cpus_allowed() constraints.
+ *
+ * Imagine a situation of two groups of 4 cpus each and 4 tasks each with a
+ * cpumask covering 1 cpu of the first group and 3 cpus of the second group.
+ * Something like:
+ *
+ * 	{ 0 1 2 3 } { 4 5 6 7 }
+ * 	        *     * * *
+ *
+ * If we were to balance group-wise we'd place two tasks in the first group and
+ * two tasks in the second group. Clearly this is undesired as it will overload
+ * cpu 3 and leave one of the cpus in the second group unused.
+ *
+ * The current solution to this issue is detecting the skew in the first group
+ * by noticing it has a cpu that is overloaded while the remaining cpus are
+ * idle -- or rather, there's a distinct imbalance in the cpus; see
+ * sg_imbalanced().
+ *
+ * When this is so detected; this group becomes a candidate for busiest; see
+ * update_sd_pick_busiest(). And calculcate_imbalance() and
+ * find_busiest_group() avoid some of the usual balance conditional to allow it
+ * to create an effective group imbalance.
+ *
+ * This is a somewhat tricky proposition since the next run might not find the
+ * group imbalance and decide the groups need to be balanced again. A most
+ * subtle and fragile situation.
+ */
+
+struct sg_imb_stats {
+	unsigned long max_nr_running, min_nr_running;
+	unsigned long max_cpu_load, min_cpu_load;
+};
+
+static inline void init_sg_imb_stats(struct sg_imb_stats *sgi)
+{
+	sgi->max_cpu_load = sgi->max_nr_running = 0UL;
+	sgi->min_cpu_load = sgi->min_nr_running = ~0UL;
+}
+
+static inline void
+update_sg_imb_stats(struct sg_imb_stats *sgi,
+		    unsigned long load, unsigned long nr_running)
+{
+	if (load > sgi->max_cpu_load)
+		sgi->max_cpu_load = load;
+	if (sgi->min_cpu_load > load)
+		sgi->min_cpu_load = load;
+
+	if (nr_running > sgi->max_nr_running)
+		sgi->max_nr_running = nr_running;
+	if (sgi->min_nr_running > nr_running)
+		sgi->min_nr_running = nr_running;
+}
+
+static inline int
+sg_imbalanced(struct sg_lb_stats *sgs, struct sg_imb_stats *sgi)
+{
+	/*
+	 * Consider the group unbalanced when the imbalance is larger
+	 * than the average weight of a task.
+	 *
+	 * APZ: with cgroup the avg task weight can vary wildly and
+	 *      might not be a suitable number - should we keep a
+	 *      normalized nr_running number somewhere that negates
+	 *      the hierarchy?
+	 */
+	if ((sgi->max_cpu_load - sgi->min_cpu_load) >= sgs->load_per_task &&
+	    (sgi->max_nr_running - sgi->min_nr_running) > 1)
+		return 1;
+
+	return 0;
+}
+
 /**
  * update_sg_lb_stats - Update sched_group's statistics for load balancing.
  * @env: The load balancing environment.
@@ -4503,15 +4578,12 @@ static inline void update_sg_lb_stats(st
 			struct sched_group *group, int load_idx,
 			int local_group, struct sg_lb_stats *sgs)
 {
-	unsigned long nr_running, max_nr_running, min_nr_running;
-	unsigned long load, max_cpu_load, min_cpu_load;
+	struct sg_imb_stats sgi;
+	unsigned long nr_running;
+	unsigned long load;
 	int i;
 
-	/* Tally up the load of all CPUs in the group */
-	max_cpu_load = 0;
-	min_cpu_load = ~0UL;
-	max_nr_running = 0;
-	min_nr_running = ~0UL;
+	init_sg_imb_stats(&sgi);
 
 	for_each_cpu_and(i, sched_group_cpus(group), env->cpus) {
 		struct rq *rq = cpu_rq(i);
@@ -4523,16 +4595,7 @@ static inline void update_sg_lb_stats(st
 			load = target_load(i, load_idx);
 		} else {
 			load = source_load(i, load_idx);
-
-			if (load > max_cpu_load)
-				max_cpu_load = load;
-			if (min_cpu_load > load)
-				min_cpu_load = load;
-
-			if (nr_running > max_nr_running)
-				max_nr_running = nr_running;
-			if (min_nr_running > nr_running)
-				min_nr_running = nr_running;
+			update_sg_imb_stats(&sgi, load, nr_running);
 		}
 
 		sgs->group_load += load;
@@ -4550,21 +4613,10 @@ static inline void update_sg_lb_stats(st
 	sgs->group_power = group->sgp->power;
 	sgs->avg_load = (sgs->group_load*SCHED_POWER_SCALE) / sgs->group_power;
 
-	/*
-	 * Consider the group unbalanced when the imbalance is larger
-	 * than the average weight of a task.
-	 *
-	 * APZ: with cgroup the avg task weight can vary wildly and
-	 *      might not be a suitable number - should we keep a
-	 *      normalized nr_running number somewhere that negates
-	 *      the hierarchy?
-	 */
 	if (sgs->sum_nr_running)
 		sgs->load_per_task = sgs->sum_weighted_load / sgs->sum_nr_running;
 
-	if ((max_cpu_load - min_cpu_load) >= sgs->load_per_task &&
-	    (max_nr_running - min_nr_running) > 1)
-		sgs->group_imb = 1;
+	sgs->group_imb = sg_imbalanced(sgs, &sgi);
 
 	sgs->group_capacity =
 		DIV_ROUND_CLOSEST(sgs->group_power, SCHED_POWER_SCALE);
@@ -4812,6 +4864,10 @@ static inline void calculate_imbalance(s
 	busiest = &sds->busiest_stat;
 
 	if (busiest->group_imb) {
+		/*
+		 * In the group_imb case we cannot rely on group-wide averages
+		 * to ensure cpu-load equilibrium, look at wider averages. XXX
+		 */
 		busiest->load_per_task =
 			min(busiest->load_per_task, sds->avg_load);
 	}
@@ -4829,6 +4885,8 @@ static inline void calculate_imbalance(s
 	if (!busiest->group_imb) {
 		/*
 		 * Don't want to pull so many tasks that a group would go idle.
+		 * Except of course for the group_imb case, since then we might
+		 * have to drop below capacity to reach cpu-load equilibrium.
 		 */
 		load_above_capacity =
 			(busiest->sum_nr_running - busiest->group_capacity);
@@ -4844,11 +4902,8 @@ static inline void calculate_imbalance(s
 	 * we also don't want to reduce the group load below the group capacity
 	 * (so that we can implement power-savings policies etc). Thus we look
 	 * for the minimum possible imbalance.
-	 * Be careful of negative numbers as they'll appear as very large values
-	 * with unsigned longs.
 	 */
-	max_pull = min(busiest->avg_load - sds->avg_load,
-		       load_above_capacity);
+	max_pull = min(busiest->avg_load - sds->avg_load, load_above_capacity);
 
 	/* How much load to actually move to equalise the imbalance */
 	env->imbalance = min(
@@ -4912,7 +4967,7 @@ static struct sched_group *find_busiest_
 
 	/*
 	 * If the busiest group is imbalanced the below checks don't
-	 * work because they assumes all things are equal, which typically
+	 * work because they assume all things are equal, which typically
 	 * isn't true due to cpus_allowed constraints and the like.
 	 */
 	if (busiest->group_imb)


