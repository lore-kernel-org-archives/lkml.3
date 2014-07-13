Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbaGNHTI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 03:19:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:45430 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300AbaGNHSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 03:18:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,656,1400050800"; 
   d="scan'208";a="569384990"
From: Yuyang Du <yuyang.du@intel.com>
To: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org
Cc: pjt@google.com, bsegall@google.com, arjan.van.de.ven@intel.com,
        len.brown@intel.com, rafael.j.wysocki@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, fengguang.wu@intel.com,
        Yuyang Du <yuyang.du@intel.com>
Subject: [PATCH 2/2 v2] sched: Rewrite per entity runnable load average tracking
Date: Mon, 14 Jul 2014 07:15:52 +0800
Message-Id: <1405293352-9305-3-git-send-email-yuyang.du@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405293352-9305-1-git-send-email-yuyang.du@intel.com>
References: <1405293352-9305-1-git-send-email-yuyang.du@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idea of per entity runnable load average (let runnable time contribute to load
weight) was proposed by Paul Turner, and it is still followed by this rewrite. This
rewrite is done due to the following ends:

1. cfs_rq's load average (namely runnable_load_avg and blocked_load_avg) is updated
   at the granularity of one entity at one time, which results in the cfs_rq load
   average is partially updated or asynchronous across its entities: at any time,
   only one entity is up to date and contributes to the cfs_rq, all other entities
   are effectively lagging behind.

2. cfs_rq load average is different between top rq->cfs_rq and other task_group's
   per CPU cfs_rqs in whether or not blocked_load_average contributes to the load.

3. How task_group's load is calculated is complex.

This rewrite tackles these by:

1. Combine runnable and blocked load averages for cfs_rq. And track cfs_rq's load
   average as a whole.

2. Track task entity load average for carrying it between CPUs in migration, cfs_rq
   and its own entity load averages are tracked together.

3. All task, cfs_rq/group_entity, and task_group have a consistent and synchronized
   load_avg.

This rewrite in principle is equivalent to the previous in functionality, but
significantly reduces code coplexity and hence increases efficiency and clarity.

In addition, the new load_avg is much more smooth/continuous (no abrupt jumping ups
and downs) and decayed/updated more quickly and synchronously to reflect the load
dynamic.

Signed-off-by: Yuyang Du <yuyang.du@intel.com>
---
 include/linux/sched.h |   13 +-
 kernel/sched/debug.c  |   24 +-
 kernel/sched/fair.c   |  620 ++++++++++++++++++++-----------------------------
 kernel/sched/proc.c   |    2 +-
 kernel/sched/sched.h  |   32 +--
 5 files changed, 283 insertions(+), 408 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 306f4f0..7abdd13 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1069,14 +1069,11 @@ struct load_weight {
 
 struct sched_avg {
 	/*
-	 * These sums represent an infinite geometric series and so are bound
-	 * above by 1024/(1-y).  Thus we only need a u32 to store them for all
-	 * choices of y < 1-2^(-32)*1024.
+	 * The load_avg represents an infinite geometric series.
 	 */
-	u32 runnable_avg_sum, runnable_avg_period;
-	u64 last_runnable_update;
-	s64 decay_count;
-	unsigned long load_avg_contrib;
+	u32 load_avg;
+	u32 period_contrib;
+	u64 last_update_time;
 };
 
 #ifdef CONFIG_SCHEDSTATS
@@ -1142,7 +1139,7 @@ struct sched_entity {
 #endif
 
 #ifdef CONFIG_SMP
-	/* Per-entity load-tracking */
+	/* Per task load tracking */
 	struct sched_avg	avg;
 #endif
 };
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 4b864c7..8e2fada 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -85,10 +85,7 @@ static void print_cfs_group_stats(struct seq_file *m, int cpu, struct task_group
 #endif
 	P(se->load.weight);
 #ifdef CONFIG_SMP
-	P(se->avg.runnable_avg_sum);
-	P(se->avg.runnable_avg_period);
-	P(se->avg.load_avg_contrib);
-	P(se->avg.decay_count);
+	P(se->my_q->avg.load_avg);
 #endif
 #undef PN
 #undef P
@@ -205,19 +202,11 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 	SEQ_printf(m, "  .%-30s: %d\n", "nr_running", cfs_rq->nr_running);
 	SEQ_printf(m, "  .%-30s: %ld\n", "load", cfs_rq->load.weight);
 #ifdef CONFIG_SMP
-	SEQ_printf(m, "  .%-30s: %ld\n", "runnable_load_avg",
-			cfs_rq->runnable_load_avg);
-	SEQ_printf(m, "  .%-30s: %ld\n", "blocked_load_avg",
-			cfs_rq->blocked_load_avg);
+	SEQ_printf(m, "  .%-30s: %llu\n", "load_avg",
+			cfs_rq->avg.load_avg);
 #ifdef CONFIG_FAIR_GROUP_SCHED
-	SEQ_printf(m, "  .%-30s: %ld\n", "tg_load_contrib",
-			cfs_rq->tg_load_contrib);
-	SEQ_printf(m, "  .%-30s: %d\n", "tg_runnable_contrib",
-			cfs_rq->tg_runnable_contrib);
 	SEQ_printf(m, "  .%-30s: %ld\n", "tg_load_avg",
-			atomic_long_read(&cfs_rq->tg->load_avg));
-	SEQ_printf(m, "  .%-30s: %d\n", "tg->runnable_avg",
-			atomic_read(&cfs_rq->tg->runnable_avg));
+			atomic64_read(&cfs_rq->tg->load_avg));
 #endif
 #endif
 #ifdef CONFIG_CFS_BANDWIDTH
@@ -624,10 +613,7 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 
 	P(se.load.weight);
 #ifdef CONFIG_SMP
-	P(se.avg.runnable_avg_sum);
-	P(se.avg.runnable_avg_period);
-	P(se.avg.load_avg_contrib);
-	P(se.avg.decay_count);
+	P(se.avg.load_avg);
 #endif
 	P(policy);
 	P(prio);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 1a2d04f..2642bc1 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -282,9 +282,6 @@ static inline struct cfs_rq *group_cfs_rq(struct sched_entity *grp)
 	return grp->my_q;
 }
 
-static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq,
-				       int force_update);
-
 static inline void list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq)
 {
 	if (!cfs_rq->on_list) {
@@ -304,8 +301,6 @@ static inline void list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq)
 		}
 
 		cfs_rq->on_list = 1;
-		/* We should have no load, but we need to update last_decay. */
-		update_cfs_rq_blocked_load(cfs_rq, 0);
 	}
 }
 
@@ -667,18 +662,17 @@ static u64 sched_vslice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 #ifdef CONFIG_SMP
 static unsigned long task_h_load(struct task_struct *p);
 
-static inline void __update_task_entity_contrib(struct sched_entity *se);
-
 /* Give new task start runnable values to heavy its load in infant time */
 void init_task_runnable_average(struct task_struct *p)
 {
 	u32 slice;
+	struct sched_avg *sa = &p->se.avg;
 
-	p->se.avg.decay_count = 0;
+	sa->last_update_time = 0;
+	sa->period_contrib = 0;
 	slice = sched_slice(task_cfs_rq(p), &p->se) >> 10;
-	p->se.avg.runnable_avg_sum = slice;
-	p->se.avg.runnable_avg_period = slice;
-	__update_task_entity_contrib(&p->se);
+	sa->load_avg = slice * p->se.load.weight;
+	/* when this task enqueue'ed, it will contribute to its cfs_rq's load_avg */
 }
 #else
 void init_task_runnable_average(struct task_struct *p)
@@ -1504,8 +1498,17 @@ static u64 numa_get_avg_runtime(struct task_struct *p, u64 *period)
 		delta = runtime - p->last_sum_exec_runtime;
 		*period = now - p->last_task_numa_placement;
 	} else {
-		delta = p->se.avg.runnable_avg_sum;
-		*period = p->se.avg.runnable_avg_period;
+		/*
+		 * XXX previous runnable_avg_sum and runnable_avg_period are
+		 * only used here. May find a way to better suit NUMA here.
+		 */
+
+		delta = p->se.avg.load_avg / p->se.load.weight;
+#ifndef LOAD_AVG_MAX
+#define LOAD_AVG_MAX 47742
+		*period = LOAD_AVG_MAX;
+#undef LOAD_AVG_MAX
+#endif
 	}
 
 	p->last_sum_exec_runtime = runtime;
@@ -2071,13 +2074,9 @@ static inline long calc_tg_weight(struct task_group *tg, struct cfs_rq *cfs_rq)
 	long tg_weight;
 
 	/*
-	 * Use this CPU's actual weight instead of the last load_contribution
-	 * to gain a more accurate current total weight. See
-	 * update_cfs_rq_load_contribution().
+	 * Use this CPU's load average instead of actual weight
 	 */
-	tg_weight = atomic_long_read(&tg->load_avg);
-	tg_weight -= cfs_rq->tg_load_contrib;
-	tg_weight += cfs_rq->load.weight;
+	tg_weight = atomic64_read(&tg->load_avg);
 
 	return tg_weight;
 }
@@ -2087,7 +2086,7 @@ static long calc_cfs_shares(struct cfs_rq *cfs_rq, struct task_group *tg)
 	long tg_weight, load, shares;
 
 	tg_weight = calc_tg_weight(tg, cfs_rq);
-	load = cfs_rq->load.weight;
+	load = cfs_rq->avg.load_avg;
 
 	shares = (tg->shares * load);
 	if (tg_weight)
@@ -2210,6 +2209,28 @@ static __always_inline u64 decay_load(u64 val, u64 n)
 	return val >> 32;
 }
 
+static __always_inline u64 decay_load64(u64 val, u64 n)
+{
+	if (likely(val <= UINT_MAX))
+		val = decay_load(val, n);
+	else {
+		/*
+		 * LOAD_AVG_MAX can last ~500ms (=log_2(LOAD_AVG_MAX)*32ms).
+		 * Since we have so big runnable load_avg, it is impossible
+		 * load_avg has not been updated for such a long time. So
+		 * LOAD_AVG_MAX is enough here.
+		 */
+		u32 factor = decay_load(LOAD_AVG_MAX, n);
+
+		factor <<= 10;
+		factor /= LOAD_AVG_MAX;
+		val *= factor;
+		val >>= 10;
+	}
+
+	return val;
+}
+
 /*
  * For updates fully spanning n periods, the contribution to runnable
  * average will be: \Sum 1024*y^n
@@ -2238,6 +2259,31 @@ static u32 __compute_runnable_contrib(u64 n)
 	return contrib + runnable_avg_yN_sum[n];
 }
 
+static __always_inline u64 __get_delta_time(u64 now, u64 *last_update_time)
+{
+	u64 delta = now - *last_update_time;
+
+	/*
+	 * This should only happen when time goes backwards, which it
+	 * unfortunately does during sched clock init when we swap over to TSC.
+	 */
+	if ((s64)delta < 0) {
+		*last_update_time = now;
+		return 0;
+	}
+
+	/*
+	 * Use 1024ns as the unit of measurement since it's a reasonable
+	 * approximation of 1us and fast to compute.
+	 */
+	delta >>= 10;
+	if (!delta)
+		return 0;
+	*last_update_time = now;
+
+	return delta;
+}
+
 /*
  * We can represent the historical contribution to runnable average as the
  * coefficients of a geometric series.  To do this we sub-divide our runnable
@@ -2266,38 +2312,21 @@ static u32 __compute_runnable_contrib(u64 n)
  *   load_avg = u_0` + y*(u_0 + u_1*y + u_2*y^2 + ... )
  *            = u_0 + u_1*y + u_2*y^2 + ... [re-labeling u_i --> u_{i+1}]
  */
-static __always_inline int __update_entity_runnable_avg(u64 now,
-							struct sched_avg *sa,
-							int runnable)
+static __always_inline void
+__update_load_avg(u64 now, struct sched_avg *sa, unsigned long w)
 {
 	u64 delta, periods;
-	u32 runnable_contrib;
-	int delta_w, decayed = 0;
+	u32 contrib, delta_w;
 
-	delta = now - sa->last_runnable_update;
-	/*
-	 * This should only happen when time goes backwards, which it
-	 * unfortunately does during sched clock init when we swap over to TSC.
-	 */
-	if ((s64)delta < 0) {
-		sa->last_runnable_update = now;
-		return 0;
-	}
-
-	/*
-	 * Use 1024ns as the unit of measurement since it's a reasonable
-	 * approximation of 1us and fast to compute.
-	 */
-	delta >>= 10;
+	delta = __get_delta_time(now, &sa->last_update_time);
 	if (!delta)
-		return 0;
-	sa->last_runnable_update = now;
+		return;
 
 	/* delta_w is the amount already accumulated against our next period */
-	delta_w = sa->runnable_avg_period % 1024;
+	delta_w = sa->period_contrib;
 	if (delta + delta_w >= 1024) {
-		/* period roll-over */
-		decayed = 1;
+		/* how much left for next period will start over, we don't know yet */
+		sa->period_contrib = 0;
 
 		/*
 		 * Now that we know we're crossing a period boundary, figure
@@ -2305,9 +2334,8 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
 		 * period and accrue it.
 		 */
 		delta_w = 1024 - delta_w;
-		if (runnable)
-			sa->runnable_avg_sum += delta_w;
-		sa->runnable_avg_period += delta_w;
+		if (w)
+			sa->load_avg += w * delta_w;
 
 		delta -= delta_w;
 
@@ -2315,290 +2343,191 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
 		periods = delta / 1024;
 		delta %= 1024;
 
-		sa->runnable_avg_sum = decay_load(sa->runnable_avg_sum,
-						  periods + 1);
-		sa->runnable_avg_period = decay_load(sa->runnable_avg_period,
-						     periods + 1);
+		sa->load_avg = decay_load(sa->load_avg, periods + 1);
 
 		/* Efficiently calculate \sum (1..n_period) 1024*y^i */
-		runnable_contrib = __compute_runnable_contrib(periods);
-		if (runnable)
-			sa->runnable_avg_sum += runnable_contrib;
-		sa->runnable_avg_period += runnable_contrib;
+		contrib = __compute_runnable_contrib(periods);
+		if (w)
+			sa->load_avg += w * contrib;
 	}
 
 	/* Remainder of delta accrued against u_0` */
-	if (runnable)
-		sa->runnable_avg_sum += delta;
-	sa->runnable_avg_period += delta;
+	if (w)
+		sa->load_avg += w * delta;
+
+	sa->period_contrib += delta;
 
-	return decayed;
+	return;
 }
 
-/* Synchronize an entity's decay with its parenting cfs_rq.*/
-static inline u64 __synchronize_entity_decay(struct sched_entity *se)
+/*
+ * Strictly, this se should use its parent cfs_rq's clock_task, but
+ * here we use its own cfs_rq's for performance matter. But on load_avg
+ * update, what we really care about is "the difference between two regular
+ * clock reads", not absolute time, so the variation should be neglectable.
+ */
+static __always_inline void __update_cfs_rq_load_avg(u64 now, struct cfs_rq *cfs_rq)
 {
-	struct cfs_rq *cfs_rq = cfs_rq_of(se);
-	u64 decays = atomic64_read(&cfs_rq->decay_counter);
+	struct sched_avg_cfs_rq *sa_c = &cfs_rq->avg;
+	unsigned long w_c = cfs_rq->load.weight;
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	struct sched_entity *se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
+	unsigned long w_e = 0;
+#endif
 
-	decays -= se->avg.decay_count;
-	if (!decays)
-		return 0;
+	u64 delta, periods;
+	u32 contrib, delta_w;
 
-	se->avg.load_avg_contrib = decay_load(se->avg.load_avg_contrib, decays);
-	se->avg.decay_count = 0;
+	delta = __get_delta_time(now, &sa_c->last_update_time);
+	if (!delta)
+		return;
 
-	return decays;
-}
+	/* delta_w is the amount already accumulated against our next period */
+	delta_w = sa_c->period_contrib;
+	if (delta + delta_w >= 1024) {
+		/* how much left for next period will start over, we don't know yet */
+		sa_c->period_contrib = 0;
 
-#ifdef CONFIG_FAIR_GROUP_SCHED
-static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
-						 int force_update)
-{
-	struct task_group *tg = cfs_rq->tg;
-	long tg_contrib;
+		/*
+		 * Now that we know we're crossing a period boundary, figure
+		 * out how much from delta we need to complete the current
+		 * period and accrue it.
+		 */
+		delta_w = 1024 - delta_w;
+		if (w_c)
+			sa_c->load_avg += w_c * delta_w;
 
-	tg_contrib = cfs_rq->runnable_load_avg + cfs_rq->blocked_load_avg;
-	tg_contrib -= cfs_rq->tg_load_contrib;
+		delta -= delta_w;
 
-	if (force_update || abs(tg_contrib) > cfs_rq->tg_load_contrib / 8) {
-		atomic_long_add(tg_contrib, &tg->load_avg);
-		cfs_rq->tg_load_contrib += tg_contrib;
-	}
-}
+		/* Figure out how many additional periods this update spans */
+		periods = delta / 1024;
+		delta %= 1024;
 
-/*
- * Aggregate cfs_rq runnable averages into an equivalent task_group
- * representation for computing load contributions.
- */
-static inline void __update_tg_runnable_avg(struct sched_avg *sa,
-						  struct cfs_rq *cfs_rq)
-{
-	struct task_group *tg = cfs_rq->tg;
-	long contrib;
+		sa_c->load_avg = decay_load64(sa_c->load_avg, periods + 1);
 
-	/* The fraction of a cpu used by this cfs_rq */
-	contrib = div_u64((u64)sa->runnable_avg_sum << NICE_0_SHIFT,
-			  sa->runnable_avg_period + 1);
-	contrib -= cfs_rq->tg_runnable_contrib;
+		/* Efficiently calculate \sum (1..n_period) 1024*y^i */
+		contrib = __compute_runnable_contrib(periods);
+		if (w_c)
+			sa_c->load_avg += w_c * contrib;
 
-	if (abs(contrib) > cfs_rq->tg_runnable_contrib / 64) {
-		atomic_add(contrib, &tg->runnable_avg);
-		cfs_rq->tg_runnable_contrib += contrib;
-	}
-}
 
-static inline void __update_group_entity_contrib(struct sched_entity *se)
-{
-	struct cfs_rq *cfs_rq = group_cfs_rq(se);
-	struct task_group *tg = cfs_rq->tg;
-	int runnable_avg;
+#ifdef CONFIG_FAIR_GROUP_SCHED
+		if (se) {
+			struct sched_avg *sa_e = &se->avg;
+			w_e = se->on_rq * se->load.weight;
 
-	u64 contrib;
+			if (w_e)
+				sa_e->load_avg += w_e * delta_w;
 
-	contrib = cfs_rq->tg_load_contrib * tg->shares;
-	se->avg.load_avg_contrib = div_u64(contrib,
-				     atomic_long_read(&tg->load_avg) + 1);
+			sa_e->load_avg = decay_load(sa_e->load_avg, periods + 1);
 
-	/*
-	 * For group entities we need to compute a correction term in the case
-	 * that they are consuming <1 cpu so that we would contribute the same
-	 * load as a task of equal weight.
-	 *
-	 * Explicitly co-ordinating this measurement would be expensive, but
-	 * fortunately the sum of each cpus contribution forms a usable
-	 * lower-bound on the true value.
-	 *
-	 * Consider the aggregate of 2 contributions.  Either they are disjoint
-	 * (and the sum represents true value) or they are disjoint and we are
-	 * understating by the aggregate of their overlap.
-	 *
-	 * Extending this to N cpus, for a given overlap, the maximum amount we
-	 * understand is then n_i(n_i+1)/2 * w_i where n_i is the number of
-	 * cpus that overlap for this interval and w_i is the interval width.
-	 *
-	 * On a small machine; the first term is well-bounded which bounds the
-	 * total error since w_i is a subset of the period.  Whereas on a
-	 * larger machine, while this first term can be larger, if w_i is the
-	 * of consequential size guaranteed to see n_i*w_i quickly converge to
-	 * our upper bound of 1-cpu.
-	 */
-	runnable_avg = atomic_read(&tg->runnable_avg);
-	if (runnable_avg < NICE_0_LOAD) {
-		se->avg.load_avg_contrib *= runnable_avg;
-		se->avg.load_avg_contrib >>= NICE_0_SHIFT;
+			if (w_e)
+				sa_e->load_avg += w_e * contrib;
+		}
+#endif
 	}
-}
 
-#else /* CONFIG_FAIR_GROUP_SCHED */
-static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
-						 int force_update) {}
-static inline void __update_tg_runnable_avg(struct sched_avg *sa,
-						  struct cfs_rq *cfs_rq) {}
-static inline void __update_group_entity_contrib(struct sched_entity *se) {}
-#endif /* CONFIG_FAIR_GROUP_SCHED */
+	/* Remainder of delta accrued against u_0` */
+	if (w_c)
+		sa_c->load_avg += w_c * delta;
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	if (w_e)
+		se->avg.load_avg += w_e * delta;
+#endif
 
-static inline void __update_task_entity_contrib(struct sched_entity *se)
-{
-	u32 contrib;
+	sa_c->period_contrib += delta;
 
-	/* avoid overflowing a 32-bit type w/ SCHED_LOAD_SCALE */
-	contrib = se->avg.runnable_avg_sum * scale_load_down(se->load.weight);
-	contrib /= (se->avg.runnable_avg_period + 1);
-	se->avg.load_avg_contrib = scale_load(contrib);
+	return;
 }
 
-/* Compute the current contribution to load_avg by se, return any delta */
-static long __update_entity_load_avg_contrib(struct sched_entity *se)
+#ifdef CONFIG_FAIR_GROUP_SCHED
+/*
+ * Updating tg's load_avg is only necessary before it is used in
+ * update_cfs_share (which is done) and effective_load (which is
+ * not done because it is too costly).
+ */
+static inline void update_tg_load_avg(struct cfs_rq *cfs_rq)
 {
-	long old_contrib = se->avg.load_avg_contrib;
+	s64 delta = cfs_rq->avg.load_avg - cfs_rq->tg_load_avg_contrib;
 
-	if (entity_is_task(se)) {
-		__update_task_entity_contrib(se);
-	} else {
-		__update_tg_runnable_avg(&se->avg, group_cfs_rq(se));
-		__update_group_entity_contrib(se);
+	if (delta) {
+		atomic64_add(delta, &cfs_rq->tg->load_avg);
+		cfs_rq->tg_load_avg_contrib = cfs_rq->avg.load_avg;
 	}
-
-	return se->avg.load_avg_contrib - old_contrib;
 }
 
-static inline void subtract_blocked_load_contrib(struct cfs_rq *cfs_rq,
-						 long load_contrib)
-{
-	if (likely(load_contrib < cfs_rq->blocked_load_avg))
-		cfs_rq->blocked_load_avg -= load_contrib;
-	else
-		cfs_rq->blocked_load_avg = 0;
-}
+#else /* CONFIG_FAIR_GROUP_SCHED */
+static inline void update_tg_load_avg(struct cfs_rq *cfs_rq) {}
+#endif /* CONFIG_FAIR_GROUP_SCHED */
 
 static inline u64 cfs_rq_clock_task(struct cfs_rq *cfs_rq);
 
-/* Update a sched_entity's runnable average */
-static inline void update_entity_load_avg(struct sched_entity *se,
-					  int update_cfs_rq)
+static inline void subtract_cfs_rq_load_avg(struct cfs_rq *cfs_rq, long removed)
 {
-	struct cfs_rq *cfs_rq = cfs_rq_of(se);
-	long contrib_delta;
-	u64 now;
-
-	/*
-	 * For a group entity we need to use their owned cfs_rq_clock_task() in
-	 * case they are the parent of a throttled hierarchy.
-	 */
-	if (entity_is_task(se))
-		now = cfs_rq_clock_task(cfs_rq);
+	if (likely(removed < cfs_rq->avg.load_avg))
+		cfs_rq->avg.load_avg -= removed;
 	else
-		now = cfs_rq_clock_task(group_cfs_rq(se));
-
-	if (!__update_entity_runnable_avg(now, &se->avg, se->on_rq))
-		return;
-
-	contrib_delta = __update_entity_load_avg_contrib(se);
-
-	if (!update_cfs_rq)
-		return;
-
-	if (se->on_rq)
-		cfs_rq->runnable_load_avg += contrib_delta;
-	else
-		subtract_blocked_load_contrib(cfs_rq, -contrib_delta);
+		cfs_rq->avg.load_avg = 0;
 }
 
 /*
- * Decay the load contributed by all blocked children and account this so that
- * their contribution may appropriately discounted when they wake up.
+ * Update load_avg of the cfs_rq along with its own se. They should get
+ * synchronized: group se's load_avg is used for task_h_load calc, and
+ * group cfs_rq's load_avg is used for task_h_load (and update_cfs_share
+ * calc).
  */
-static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq, int force_update)
+static inline void update_cfs_rq_load_avg(u64 now, struct cfs_rq *cfs_rq)
 {
-	u64 now = cfs_rq_clock_task(cfs_rq) >> 20;
-	u64 decays;
-
-	decays = now - cfs_rq->last_decay;
-	if (!decays && !force_update)
-		return;
-
-	if (atomic_long_read(&cfs_rq->removed_load)) {
-		unsigned long removed_load;
-		removed_load = atomic_long_xchg(&cfs_rq->removed_load, 0);
-		subtract_blocked_load_contrib(cfs_rq, removed_load);
+	if (atomic_long_read(&cfs_rq->removed_load_avg)) {
+		long removed;
+		removed = atomic_long_xchg(&cfs_rq->removed_load_avg, 0);
+		subtract_cfs_rq_load_avg(cfs_rq, removed);
 	}
 
-	if (decays) {
-		cfs_rq->blocked_load_avg = decay_load(cfs_rq->blocked_load_avg,
-						      decays);
-		atomic64_add(decays, &cfs_rq->decay_counter);
-		cfs_rq->last_decay = now;
-	}
-
-	__update_cfs_rq_tg_load_contrib(cfs_rq, force_update);
+	__update_cfs_rq_load_avg(now, cfs_rq);
 }
 
-/* Add the load generated by se into cfs_rq's child load-average */
-static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
-						  struct sched_entity *se,
-						  int wakeup)
+/* Update task and its cfs_rq load average */
+static inline void update_load_avg(struct sched_entity *se, int update_tg)
 {
+	struct cfs_rq *cfs_rq = cfs_rq_of(se);
+	u64 now = cfs_rq_clock_task(cfs_rq);
+
 	/*
-	 * We track migrations using entity decay_count <= 0, on a wake-up
-	 * migration we use a negative decay count to track the remote decays
-	 * accumulated while sleeping.
-	 *
-	 * Newly forked tasks are enqueued with se->avg.decay_count == 0, they
-	 * are seen by enqueue_entity_load_avg() as a migration with an already
-	 * constructed load_avg_contrib.
+	 * Track task load average for carrying it to new CPU after migrated
 	 */
-	if (unlikely(se->avg.decay_count <= 0)) {
-		se->avg.last_runnable_update = rq_clock_task(rq_of(cfs_rq));
-		if (se->avg.decay_count) {
-			/*
-			 * In a wake-up migration we have to approximate the
-			 * time sleeping.  This is because we can't synchronize
-			 * clock_task between the two cpus, and it is not
-			 * guaranteed to be read-safe.  Instead, we can
-			 * approximate this using our carried decays, which are
-			 * explicitly atomically readable.
-			 */
-			se->avg.last_runnable_update -= (-se->avg.decay_count)
-							<< 20;
-			update_entity_load_avg(se, 0);
-			/* Indicate that we're now synchronized and on-rq */
-			se->avg.decay_count = 0;
-		}
-		wakeup = 0;
-	} else {
-		__synchronize_entity_decay(se);
-	}
+	if (entity_is_task(se))
+		__update_load_avg(now, &se->avg, se->on_rq * se->load.weight);
 
-	/* migrated tasks did not contribute to our blocked load */
-	if (wakeup) {
-		subtract_blocked_load_contrib(cfs_rq, se->avg.load_avg_contrib);
-		update_entity_load_avg(se, 0);
-	}
+	update_cfs_rq_load_avg(now, cfs_rq);
 
-	cfs_rq->runnable_load_avg += se->avg.load_avg_contrib;
-	/* we force update consideration on load-balancer moves */
-	update_cfs_rq_blocked_load(cfs_rq, !wakeup);
+	if (update_tg)
+		update_tg_load_avg(cfs_rq);
 }
 
-/*
- * Remove se's load from this cfs_rq child load-average, if the entity is
- * transitioning to a blocked state we track its projected decay using
- * blocked_load_avg.
- */
-static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
-						  struct sched_entity *se,
-						  int sleep)
+/* Add the load generated by se into cfs_rq's load average */
+static inline void enqueue_entity_load_avg(struct sched_entity *se)
 {
-	update_entity_load_avg(se, 1);
-	/* we force update consideration on load-balancer moves */
-	update_cfs_rq_blocked_load(cfs_rq, !sleep);
+	struct sched_avg *sa = &se->avg;
+	struct cfs_rq *cfs_rq = cfs_rq_of(se);
+	u64 now = cfs_rq_clock_task(cfs_rq);
+	int migrated = 0;
 
-	cfs_rq->runnable_load_avg -= se->avg.load_avg_contrib;
-	if (sleep) {
-		cfs_rq->blocked_load_avg += se->avg.load_avg_contrib;
-		se->avg.decay_count = atomic64_read(&cfs_rq->decay_counter);
-	} /* migrations, e.g. sleep=0 leave decay_count == 0 */
+	if (entity_is_task(se)) {
+		if (sa->last_update_time == 0) {
+			sa->last_update_time = now;
+			migrated = 1;
+		}
+		else
+			__update_load_avg(now, sa, se->on_rq * se->load.weight);
+	}
+
+	update_cfs_rq_load_avg(now, cfs_rq);
+
+	if (migrated)
+		cfs_rq->avg.load_avg += sa->load_avg;
+
+	update_tg_load_avg(cfs_rq);
 }
 
 /*
@@ -2623,16 +2552,8 @@ static int idle_balance(struct rq *this_rq);
 
 #else /* CONFIG_SMP */
 
-static inline void update_entity_load_avg(struct sched_entity *se,
-					  int update_cfs_rq) {}
-static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
-					   struct sched_entity *se,
-					   int wakeup) {}
-static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
-					   struct sched_entity *se,
-					   int sleep) {}
-static inline void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq,
-					      int force_update) {}
+static inline void update_load_avg(struct sched_entity *se, int update_tg) {}
+static inline void enqueue_entity_load_avg(struct sched_entity *se) {}
 
 static inline int idle_balance(struct rq *rq)
 {
@@ -2764,7 +2685,7 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	 * Update run-time statistics of the 'current'.
 	 */
 	update_curr(cfs_rq);
-	enqueue_entity_load_avg(cfs_rq, se, flags & ENQUEUE_WAKEUP);
+	enqueue_entity_load_avg(se);
 	account_entity_enqueue(cfs_rq, se);
 	update_cfs_shares(cfs_rq);
 
@@ -2839,7 +2760,8 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	 * Update run-time statistics of the 'current'.
 	 */
 	update_curr(cfs_rq);
-	dequeue_entity_load_avg(cfs_rq, se, flags & DEQUEUE_SLEEP);
+
+	update_load_avg(se, 1);
 
 	update_stats_dequeue(cfs_rq, se);
 	if (flags & DEQUEUE_SLEEP) {
@@ -3028,7 +2950,7 @@ static void put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *prev)
 		/* Put 'current' back into the tree. */
 		__enqueue_entity(cfs_rq, prev);
 		/* in !on_rq case, update occurred at dequeue */
-		update_entity_load_avg(prev, 1);
+		update_load_avg(prev, 0);
 	}
 	cfs_rq->curr = NULL;
 }
@@ -3044,8 +2966,7 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
 	/*
 	 * Ensure that runnable average is periodically updated.
 	 */
-	update_entity_load_avg(curr, 1);
-	update_cfs_rq_blocked_load(cfs_rq, 1);
+	update_load_avg(curr, 1);
 	update_cfs_shares(cfs_rq);
 
 #ifdef CONFIG_SCHED_HRTICK
@@ -3923,8 +3844,8 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		if (cfs_rq_throttled(cfs_rq))
 			break;
 
+		update_load_avg(se, 1);
 		update_cfs_shares(cfs_rq);
-		update_entity_load_avg(se, 1);
 	}
 
 	if (!se)
@@ -3983,8 +3904,8 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		if (cfs_rq_throttled(cfs_rq))
 			break;
 
+		update_load_avg(se, 1);
 		update_cfs_shares(cfs_rq);
-		update_entity_load_avg(se, 1);
 	}
 
 	if (!se)
@@ -3997,7 +3918,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 /* Used instead of source_load when we know the type == 0 */
 static unsigned long weighted_cpuload(const int cpu)
 {
-	return cpu_rq(cpu)->cfs.runnable_load_avg;
+	return cpu_rq(cpu)->cfs.avg.load_avg;
 }
 
 /*
@@ -4042,7 +3963,7 @@ static unsigned long cpu_avg_load_per_task(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long nr_running = ACCESS_ONCE(rq->nr_running);
-	unsigned long load_avg = rq->cfs.runnable_load_avg;
+	unsigned long load_avg = rq->cfs.avg.load_avg;
 
 	if (nr_running)
 		return load_avg / nr_running;
@@ -4161,7 +4082,7 @@ static long effective_load(struct task_group *tg, int cpu, long wl, long wg)
 		/*
 		 * w = rw_i + @wl
 		 */
-		w = se->my_q->load.weight + wl;
+		w = se->my_q->avg.load_avg + wl;
 
 		/*
 		 * wl = S * s'_i; see (2)
@@ -4182,7 +4103,7 @@ static long effective_load(struct task_group *tg, int cpu, long wl, long wg)
 		/*
 		 * wl = dw_i = S * (s'_i - s_i); see (3)
 		 */
-		wl -= se->load.weight;
+		wl -= se->avg.load_avg;
 
 		/*
 		 * Recursively apply this logic to all parent groups to compute
@@ -4256,14 +4177,14 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 	 */
 	if (sync) {
 		tg = task_group(current);
-		weight = current->se.load.weight;
+		weight = current->se.avg.load_avg;
 
 		this_load += effective_load(tg, this_cpu, -weight, -weight);
 		load += effective_load(tg, prev_cpu, 0, -weight);
 	}
 
 	tg = task_group(p);
-	weight = p->se.load.weight;
+	weight = p->se.avg.load_avg;
 
 	/*
 	 * In low-load situations, where prev_cpu is idle and this_cpu is idle
@@ -4553,16 +4474,20 @@ migrate_task_rq_fair(struct task_struct *p, int next_cpu)
 	struct cfs_rq *cfs_rq = cfs_rq_of(se);
 
 	/*
-	 * Load tracking: accumulate removed load so that it can be processed
-	 * when we next update owning cfs_rq under rq->lock.  Tasks contribute
-	 * to blocked load iff they have a positive decay-count.  It can never
-	 * be negative here since on-rq tasks have decay-count == 0.
+	 * Task on old CPU catches up with its old cfs_rq, and subtract itself from
+	 * the cfs_rq (task must be off the queue now).
 	 */
-	if (se->avg.decay_count) {
-		se->avg.decay_count = -__synchronize_entity_decay(se);
-		atomic_long_add(se->avg.load_avg_contrib,
-						&cfs_rq->removed_load);
-	}
+	__update_load_avg(cfs_rq->avg.last_update_time, &se->avg, 0);
+	atomic_long_add(se->avg.load_avg, &cfs_rq->removed_load_avg);
+
+	/*
+	 * We are supposed to update the task to "current" time, then its up to date
+	 * and ready to go to new CPU/cfs_rq. But we have difficulty in getting
+	 * what current time is, so simply throw away the out-of-date time. This
+	 * will result in the wakee task is less decayed, but giving the wakee more
+	 * load sounds not bad.
+	 */
+	se->avg.last_update_time = 0;
 
 	/* We have migrated, no longer consider this task hot */
 	se->exec_start = 0;
@@ -5399,36 +5324,6 @@ next:
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-/*
- * update tg->load_weight by folding this cpu's load_avg
- */
-static void __update_blocked_averages_cpu(struct task_group *tg, int cpu)
-{
-	struct sched_entity *se = tg->se[cpu];
-	struct cfs_rq *cfs_rq = tg->cfs_rq[cpu];
-
-	/* throttled entities do not contribute to load */
-	if (throttled_hierarchy(cfs_rq))
-		return;
-
-	update_cfs_rq_blocked_load(cfs_rq, 1);
-
-	if (se) {
-		update_entity_load_avg(se, 1);
-		/*
-		 * We pivot on our runnable average having decayed to zero for
-		 * list removal.  This generally implies that all our children
-		 * have also been removed (modulo rounding error or bandwidth
-		 * control); however, such cases are rare and we can fix these
-		 * at enqueue.
-		 *
-		 * TODO: fix up out-of-order children on enqueue.
-		 */
-		if (!se->avg.runnable_avg_sum && !cfs_rq->nr_running)
-			list_del_leaf_cfs_rq(cfs_rq);
-	}
-}
-
 static void update_blocked_averages(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
@@ -5437,17 +5332,17 @@ static void update_blocked_averages(int cpu)
 
 	raw_spin_lock_irqsave(&rq->lock, flags);
 	update_rq_clock(rq);
+
 	/*
 	 * Iterates the task_group tree in a bottom up fashion, see
 	 * list_add_leaf_cfs_rq() for details.
 	 */
 	for_each_leaf_cfs_rq(rq, cfs_rq) {
-		/*
-		 * Note: We may want to consider periodically releasing
-		 * rq->lock about these updates so that creating many task
-		 * groups does not result in continually extending hold time.
-		 */
-		__update_blocked_averages_cpu(cfs_rq->tg, rq->cpu);
+		/* throttled entities do not contribute to load */
+		if (throttled_hierarchy(cfs_rq))
+			continue;
+
+		update_cfs_rq_load_avg(cfs_rq_clock_task(cfs_rq), cfs_rq);
 	}
 
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
@@ -5477,14 +5372,14 @@ static void update_cfs_rq_h_load(struct cfs_rq *cfs_rq)
 	}
 
 	if (!se) {
-		cfs_rq->h_load = cfs_rq->runnable_load_avg;
+		cfs_rq->h_load = cfs_rq->avg.load_avg;
 		cfs_rq->last_h_load_update = now;
 	}
 
 	while ((se = cfs_rq->h_load_next) != NULL) {
 		load = cfs_rq->h_load;
-		load = div64_ul(load * se->avg.load_avg_contrib,
-				cfs_rq->runnable_load_avg + 1);
+		load = div64_ul(load * se->avg.load_avg,
+				cfs_rq->avg.load_avg + 1);
 		cfs_rq = group_cfs_rq(se);
 		cfs_rq->h_load = load;
 		cfs_rq->last_h_load_update = now;
@@ -5496,8 +5391,8 @@ static unsigned long task_h_load(struct task_struct *p)
 	struct cfs_rq *cfs_rq = task_cfs_rq(p);
 
 	update_cfs_rq_h_load(cfs_rq);
-	return div64_ul(p->se.avg.load_avg_contrib * cfs_rq->h_load,
-			cfs_rq->runnable_load_avg + 1);
+	return div64_ul(p->se.avg.load_avg * cfs_rq->h_load,
+			cfs_rq->avg.load_avg + 1);
 }
 #else
 static inline void update_blocked_averages(int cpu)
@@ -5506,7 +5401,7 @@ static inline void update_blocked_averages(int cpu)
 
 static unsigned long task_h_load(struct task_struct *p)
 {
-	return p->se.avg.load_avg_contrib;
+	return p->se.avg.load_avg;
 }
 #endif
 
@@ -7437,14 +7332,11 @@ static void switched_from_fair(struct rq *rq, struct task_struct *p)
 
 #ifdef CONFIG_SMP
 	/*
-	* Remove our load from contribution when we leave sched_fair
-	* and ensure we don't carry in an old decay_count if we
-	* switch back.
+	* Remove our load from contribution when we leave cfs_rq.
 	*/
-	if (se->avg.decay_count) {
-		__synchronize_entity_decay(se);
-		subtract_blocked_load_contrib(cfs_rq, se->avg.load_avg_contrib);
-	}
+	__update_load_avg(cfs_rq->avg.last_update_time, &se->avg,
+		se->on_rq * se->load.weight);
+	subtract_cfs_rq_load_avg(cfs_rq, se->avg.load_avg);
 #endif
 }
 
@@ -7501,8 +7393,7 @@ void init_cfs_rq(struct cfs_rq *cfs_rq)
 	cfs_rq->min_vruntime_copy = cfs_rq->min_vruntime;
 #endif
 #ifdef CONFIG_SMP
-	atomic64_set(&cfs_rq->decay_counter, 1);
-	atomic_long_set(&cfs_rq->removed_load, 0);
+    atomic_long_set(&cfs_rq->removed_load_avg, 0);
 #endif
 }
 
@@ -7547,14 +7438,11 @@ static void task_move_group_fair(struct task_struct *p, int on_rq)
 	if (!on_rq) {
 		cfs_rq = cfs_rq_of(se);
 		se->vruntime += cfs_rq->min_vruntime;
+
 #ifdef CONFIG_SMP
-		/*
-		 * migrate_task_rq_fair() will have removed our previous
-		 * contribution, but we must synchronize for ongoing future
-		 * decay.
-		 */
-		se->avg.decay_count = atomic64_read(&cfs_rq->decay_counter);
-		cfs_rq->blocked_load_avg += se->avg.load_avg_contrib;
+		/* synchronize task with its new cfs_rq */
+		__update_load_avg(cfs_rq->avg.last_update_time, &p->se.avg, 0);
+		cfs_rq->avg.load_avg += p->se.avg.load_avg;
 #endif
 	}
 }
diff --git a/kernel/sched/proc.c b/kernel/sched/proc.c
index 16f5a30..8f547fe 100644
--- a/kernel/sched/proc.c
+++ b/kernel/sched/proc.c
@@ -504,7 +504,7 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
 #ifdef CONFIG_SMP
 static inline unsigned long get_rq_runnable_load(struct rq *rq)
 {
-	return rq->cfs.runnable_load_avg;
+	return rq->cfs.avg.load_avg;
 }
 #else
 static inline unsigned long get_rq_runnable_load(struct rq *rq)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index a147571..7cf0c75 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -209,8 +209,7 @@ struct task_group {
 	unsigned long shares;
 
 #ifdef	CONFIG_SMP
-	atomic_long_t load_avg;
-	atomic_t runnable_avg;
+	atomic64_t load_avg;
 #endif
 #endif
 
@@ -305,6 +304,19 @@ struct cfs_bandwidth { };
 
 #endif	/* CONFIG_CGROUP_SCHED */
 
+#ifdef CONFIG_SMP
+struct sched_avg_cfs_rq {
+	/*
+	 * The load_avg represents an infinite geometric series. The 64 bit
+	 * load_avg can afford 4353082796 (=2^64/47742/88761) entities with
+	 * the highest weight (=88761) always runnable, we should not overflow
+	 */
+	u64 load_avg;
+	u32 period_contrib;
+	u64 last_update_time;
+};
+#endif
+
 /* CFS-related fields in a runqueue */
 struct cfs_rq {
 	struct load_weight load;
@@ -331,21 +343,13 @@ struct cfs_rq {
 
 #ifdef CONFIG_SMP
 	/*
-	 * CFS Load tracking
-	 * Under CFS, load is tracked on a per-entity basis and aggregated up.
-	 * This allows for the description of both thread and group usage (in
-	 * the FAIR_GROUP_SCHED case).
+	 * CFS load tracking
 	 */
-	unsigned long runnable_load_avg, blocked_load_avg;
-	atomic64_t decay_counter;
-	u64 last_decay;
-	atomic_long_t removed_load;
+	struct sched_avg_cfs_rq avg;
+	u64 tg_load_avg_contrib;
+	atomic_long_t removed_load_avg;
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-	/* Required to track per-cpu representation of a task_group */
-	u32 tg_runnable_contrib;
-	unsigned long tg_load_contrib;
-
 	/*
 	 *   h_load = weight * f(tg)
 	 *
-- 
1.7.9.5

