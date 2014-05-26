Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbaEZWVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 18:21:05 -0400
Received: from relais.videotron.ca ([24.201.245.36]:61825 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbaEZWTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 18:19:48 -0400
Content-transfer-encoding: 7BIT
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: [PATCH v2 3/6] sched/fair.c: disambiguate existing/remaining
 "capacity" usage
Date: Mon, 26 May 2014 18:19:36 -0400
Message-id: <1401142779-6633-4-git-send-email-nicolas.pitre@linaro.org>
X-Mailer: git-send-email 1.8.4.108.g55ea5f6
In-reply-to: <1401142779-6633-1-git-send-email-nicolas.pitre@linaro.org>
References: <1401142779-6633-1-git-send-email-nicolas.pitre@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have "power" (which should actually become "capacity") and "capacity"
which is a scaled down "capacity factor" in terms of unitary tasks.
Let's use "capacity_factor" to make room for proper usage of "capacity"
later.

Signed-off-by: Nicolas Pitre <nico@linaro.org>
---
 kernel/sched/fair.c | 42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8f9ac4826c..87a39559cc 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5532,7 +5532,7 @@ struct sg_lb_stats {
 	unsigned long load_per_task;
 	unsigned long group_power;
 	unsigned int sum_nr_running; /* Nr tasks running in the group */
-	unsigned int group_capacity;
+	unsigned int group_capacity_factor;
 	unsigned int idle_cpus;
 	unsigned int group_weight;
 	int group_imb; /* Is there an imbalance in the group ? */
@@ -5827,15 +5827,15 @@ static inline int sg_imbalanced(struct sched_group *group)
 }
 
 /*
- * Compute the group capacity.
+ * Compute the group capacity factor.
  *
  * Avoid the issue where N*frac(smt_power) >= 1 creates 'phantom' cores by
  * first dividing out the smt factor and computing the actual number of cores
  * and limit power unit capacity with that.
  */
-static inline int sg_capacity(struct lb_env *env, struct sched_group *group)
+static inline int sg_capacity_factor(struct lb_env *env, struct sched_group *group)
 {
-	unsigned int capacity, smt, cpus;
+	unsigned int capacity_factor, smt, cpus;
 	unsigned int power, power_orig;
 
 	power = group->sgp->power;
@@ -5844,13 +5844,13 @@ static inline int sg_capacity(struct lb_env *env, struct sched_group *group)
 
 	/* smt := ceil(cpus / power), assumes: 1 < smt_power < 2 */
 	smt = DIV_ROUND_UP(SCHED_POWER_SCALE * cpus, power_orig);
-	capacity = cpus / smt; /* cores */
+	capacity_factor = cpus / smt; /* cores */
 
-	capacity = min_t(unsigned, capacity, DIV_ROUND_CLOSEST(power, SCHED_POWER_SCALE));
-	if (!capacity)
-		capacity = fix_small_capacity(env->sd, group);
+	capacity_factor = min_t(unsigned, capacity_factor, DIV_ROUND_CLOSEST(power, SCHED_POWER_SCALE));
+	if (!capacity_factor)
+		capacity_factor = fix_small_capacity(env->sd, group);
 
-	return capacity;
+	return capacity_factor;
 }
 
 /**
@@ -5900,9 +5900,9 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 	sgs->group_weight = group->group_weight;
 
 	sgs->group_imb = sg_imbalanced(group);
-	sgs->group_capacity = sg_capacity(env, group);
+	sgs->group_capacity_factor = sg_capacity_factor(env, group);
 
-	if (sgs->group_capacity > sgs->sum_nr_running)
+	if (sgs->group_capacity_factor > sgs->sum_nr_running)
 		sgs->group_has_free_capacity = 1;
 }
 
@@ -5927,7 +5927,7 @@ static bool update_sd_pick_busiest(struct lb_env *env,
 	if (sgs->avg_load <= sds->busiest_stat.avg_load)
 		return false;
 
-	if (sgs->sum_nr_running > sgs->group_capacity)
+	if (sgs->sum_nr_running > sgs->group_capacity_factor)
 		return true;
 
 	if (sgs->group_imb)
@@ -6018,17 +6018,17 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
 
 		/*
 		 * In case the child domain prefers tasks go to siblings
-		 * first, lower the sg capacity to one so that we'll try
+		 * first, lower the sg capacity factor to one so that we'll try
 		 * and move all the excess tasks away. We lower the capacity
 		 * of a group only if the local group has the capacity to fit
-		 * these excess tasks, i.e. nr_running < group_capacity. The
+		 * these excess tasks, i.e. nr_running < group_capacity_factor. The
 		 * extra check prevents the case where you always pull from the
 		 * heaviest group when it is already under-utilized (possible
 		 * with a large weight task outweighs the tasks on the system).
 		 */
 		if (prefer_sibling && sds->local &&
 		    sds->local_stat.group_has_free_capacity)
-			sgs->group_capacity = min(sgs->group_capacity, 1U);
+			sgs->group_capacity_factor = min(sgs->group_capacity_factor, 1U);
 
 		if (update_sd_pick_busiest(env, sds, sg, sgs)) {
 			sds->busiest = sg;
@@ -6202,7 +6202,7 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 		 * have to drop below capacity to reach cpu-load equilibrium.
 		 */
 		load_above_capacity =
-			(busiest->sum_nr_running - busiest->group_capacity);
+			(busiest->sum_nr_running - busiest->group_capacity_factor);
 
 		load_above_capacity *= (SCHED_LOAD_SCALE * SCHED_POWER_SCALE);
 		load_above_capacity /= busiest->group_power;
@@ -6346,7 +6346,7 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 	int i;
 
 	for_each_cpu_and(i, sched_group_cpus(group), env->cpus) {
-		unsigned long power, capacity, wl;
+		unsigned long power, capacity_factor, wl;
 		enum fbq_type rt;
 
 		rq = cpu_rq(i);
@@ -6375,9 +6375,9 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 			continue;
 
 		power = power_of(i);
-		capacity = DIV_ROUND_CLOSEST(power, SCHED_POWER_SCALE);
-		if (!capacity)
-			capacity = fix_small_capacity(env->sd, group);
+		capacity_factor = DIV_ROUND_CLOSEST(power, SCHED_POWER_SCALE);
+		if (!capacity_factor)
+			capacity_factor = fix_small_capacity(env->sd, group);
 
 		wl = weighted_cpuload(i);
 
@@ -6385,7 +6385,7 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 		 * When comparing with imbalance, use weighted_cpuload()
 		 * which is not scaled with the cpu power.
 		 */
-		if (capacity && rq->nr_running == 1 && wl > env->imbalance)
+		if (capacity_factor && rq->nr_running == 1 && wl > env->imbalance)
 			continue;
 
 		/*
-- 
1.8.4.108.g55ea5f6

