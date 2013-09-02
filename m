Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127Ab3IBHlw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 03:41:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52429 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082Ab3IBHlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 03:41:50 -0400
Date: Mon, 2 Sep 2013 00:41:17 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-caeeqttnla4wrrmhp5uf89gp@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair:
  Rework and comment the group_imb code
Git-Commit-ID: 30ce5dabc92b5a349a7d9e9cf499494d230e0691
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 02 Sep 2013 00:41:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  30ce5dabc92b5a349a7d9e9cf499494d230e0691
Gitweb:     http://git.kernel.org/tip/30ce5dabc92b5a349a7d9e9cf499494d230e0691
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 15 Aug 2013 20:29:29 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 2 Sep 2013 08:27:38 +0200

sched/fair: Rework and comment the group_imb code

Rik reported some weirdness due to the group_imb code. As a start to
looking at it, clean it up a little and add a few explanatory
comments.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-caeeqttnla4wrrmhp5uf89gp@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 123 +++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 89 insertions(+), 34 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index bedd30b..dffb270 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4463,6 +4463,81 @@ fix_small_capacity(struct sched_domain *sd, struct sched_group *group)
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
@@ -4475,15 +4550,12 @@ static inline void update_sg_lb_stats(struct lb_env *env,
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
@@ -4495,16 +4567,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
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
@@ -4522,21 +4585,10 @@ static inline void update_sg_lb_stats(struct lb_env *env,
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
@@ -4781,6 +4833,10 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 	busiest = &sds->busiest_stat;
 
 	if (busiest->group_imb) {
+		/*
+		 * In the group_imb case we cannot rely on group-wide averages
+		 * to ensure cpu-load equilibrium, look at wider averages. XXX
+		 */
 		busiest->load_per_task =
 			min(busiest->load_per_task, sds->avg_load);
 	}
@@ -4798,6 +4854,8 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 	if (!busiest->group_imb) {
 		/*
 		 * Don't want to pull so many tasks that a group would go idle.
+		 * Except of course for the group_imb case, since then we might
+		 * have to drop below capacity to reach cpu-load equilibrium.
 		 */
 		load_above_capacity =
 			(busiest->sum_nr_running - busiest->group_capacity);
@@ -4813,11 +4871,8 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
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
@@ -4881,7 +4936,7 @@ static struct sched_group *find_busiest_group(struct lb_env *env)
 
 	/*
 	 * If the busiest group is imbalanced the below checks don't
-	 * work because they assumes all things are equal, which typically
+	 * work because they assume all things are equal, which typically
 	 * isn't true due to cpus_allowed constraints and the like.
 	 */
 	if (busiest->group_imb)
