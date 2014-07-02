Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137AbaGBKeP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 06:34:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:62413 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751472AbaGBKeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 06:34:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,587,1400050800"; 
   d="scan'208";a="567182198"
From: Yuyang Du <yuyang.du@intel.com>
To: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org,
        rafael.j.wysocki@intel.com
Cc: arjan.van.de.ven@intel.com, len.brown@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, pjt@google.com, fengguang.wu@intel.com,
        yuyang.du@intel.com
Subject: [PATCH 2/2] sched: Rewrite per entity runnable load average tracking
Date: Wed,  2 Jul 2014 10:30:56 +0800
Message-Id: <1404268256-3019-2-git-send-email-yuyang.du@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404268256-3019-1-git-send-email-yuyang.du@intel.com>
References: <1404268256-3019-1-git-send-email-yuyang.du@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idea of per entity runnable load average (aggregated to cfs_rq and task_group load)
was proposed by Paul Turner, and it is still followed by this rewrite. But this rewrite
is made due to the following ends:

(1). cfs_rq's load average (namely runnable_load_avg and blocked_load_avg) is updated
incrementally by one entity at one time, which means the cfs_rq load average is only
partially updated or asynchronous accross its entities (the entity in question is up
to date and contributes to the cfs_rq, but all other entities are effectively lagging
behind).

(2). cfs_rq load average is different between top rq->cfs_rq and task_group's per CPU
cfs_rqs in whether or not blocked_load_average contributes to the load.

(3). How task_group's load is tracked is very confusing and complex.

Therefore, this rewrite tackles these by:

(1). Combine runnable and blocked load averages for cfs_rq. And track cfs_rq's load average
as a whole (contributed by all runnabled and blocked entities on this cfs_rq).

(2). Only track task load average. Do not track task_group's per CPU entity average, but
track that entity's own cfs_rq's aggregated average.

This rewrite resutls in significantly reduced codes and expected consistency and clarity.
Also, if draw the lines of previous cfs_rq runnable_load_avg and blocked_load_avg and the
new rewritten load_avg, then compare those lines, you can see the new load_avg is much
more continuous (no abrupt jumping ups and downs) and decayed/updated more quickly and
synchronously.

Signed-off-by: Yuyang Du <yuyang.du@intel.com>
---
 include/linux/sched.h |   13 +-
 kernel/sched/debug.c  |   22 +--
 kernel/sched/fair.c   |  475 +++++++++++--------------------------------------
 kernel/sched/proc.c   |    2 +-
 kernel/sched/sched.h  |   17 +-
 5 files changed, 115 insertions(+), 414 deletions(-)

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
index 4b864c7..547a01b 100644
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
+	SEQ_printf(m, "  .%-30s: %u\n", "load_avg",
+			cfs_rq->avg.load_avg);
 #ifdef CONFIG_FAIR_GROUP_SCHED
-	SEQ_printf(m, "  .%-30s: %ld\n", "tg_load_contrib",
-			cfs_rq->tg_load_contrib);
-	SEQ_printf(m, "  .%-30s: %d\n", "tg_runnable_contrib",
-			cfs_rq->tg_runnable_contrib);
 	SEQ_printf(m, "  .%-30s: %ld\n", "tg_load_avg",
 			atomic_long_read(&cfs_rq->tg->load_avg));
-	SEQ_printf(m, "  .%-30s: %d\n", "tg->runnable_avg",
-			atomic_read(&cfs_rq->tg->runnable_avg));
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
index 1a2d04f..9b442cd 100644
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
 
@@ -667,18 +662,19 @@ static u64 sched_vslice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 #ifdef CONFIG_SMP
 static unsigned long task_h_load(struct task_struct *p);
 
-static inline void __update_task_entity_contrib(struct sched_entity *se);
+static void __update_load_avg(u64 now, struct sched_avg *sa, unsigned long w);
 
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
@@ -1504,8 +1500,13 @@ static u64 numa_get_avg_runtime(struct task_struct *p, u64 *period)
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
+		delta = p->se.avg.load_avg / p->se.avg.load.weight;
+		*period = LOAD_AVG_MAX;
 	}
 
 	p->last_sum_exec_runtime = runtime;
@@ -2071,13 +2072,9 @@ static inline long calc_tg_weight(struct task_group *tg, struct cfs_rq *cfs_rq)
 	long tg_weight;
 
 	/*
-	 * Use this CPU's actual weight instead of the last load_contribution
-	 * to gain a more accurate current total weight. See
-	 * update_cfs_rq_load_contribution().
+	 * Use this CPU's load average instead of actual weight
 	 */
 	tg_weight = atomic_long_read(&tg->load_avg);
-	tg_weight -= cfs_rq->tg_load_contrib;
-	tg_weight += cfs_rq->load.weight;
 
 	return tg_weight;
 }
@@ -2087,7 +2084,7 @@ static long calc_cfs_shares(struct cfs_rq *cfs_rq, struct task_group *tg)
 	long tg_weight, load, shares;
 
 	tg_weight = calc_tg_weight(tg, cfs_rq);
-	load = cfs_rq->load.weight;
+	load = cfs_rq->avg.load_avg;
 
 	shares = (tg->shares * load);
 	if (tg_weight)
@@ -2266,22 +2263,21 @@ static u32 __compute_runnable_contrib(u64 n)
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
+	u32 contrib;
+	int delta_w;
 
-	delta = now - sa->last_runnable_update;
+	delta = now - sa->last_update_time;
 	/*
 	 * This should only happen when time goes backwards, which it
 	 * unfortunately does during sched clock init when we swap over to TSC.
 	 */
 	if ((s64)delta < 0) {
-		sa->last_runnable_update = now;
-		return 0;
+		sa->last_update_time = now;
+		return;
 	}
 
 	/*
@@ -2290,14 +2286,14 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
 	 */
 	delta >>= 10;
 	if (!delta)
-		return 0;
-	sa->last_runnable_update = now;
+		return;
+	sa->last_update_time = now;
 
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
@@ -2305,9 +2301,8 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
 		 * period and accrue it.
 		 */
 		delta_w = 1024 - delta_w;
-		if (runnable)
-			sa->runnable_avg_sum += delta_w;
-		sa->runnable_avg_period += delta_w;
+		if (w)
+			sa->load_avg += w * delta_w;
 
 		delta -= delta_w;
 
@@ -2315,290 +2310,77 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
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
-
-	return decayed;
-}
-
-/* Synchronize an entity's decay with its parenting cfs_rq.*/
-static inline u64 __synchronize_entity_decay(struct sched_entity *se)
-{
-	struct cfs_rq *cfs_rq = cfs_rq_of(se);
-	u64 decays = atomic64_read(&cfs_rq->decay_counter);
-
-	decays -= se->avg.decay_count;
-	if (!decays)
-		return 0;
+	if (w)
+		sa->load_avg += w * delta;
 
-	se->avg.load_avg_contrib = decay_load(se->avg.load_avg_contrib, decays);
-	se->avg.decay_count = 0;
+	sa->period_contrib += delta;
 
-	return decays;
+	return;
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
-						 int force_update)
-{
-	struct task_group *tg = cfs_rq->tg;
-	long tg_contrib;
-
-	tg_contrib = cfs_rq->runnable_load_avg + cfs_rq->blocked_load_avg;
-	tg_contrib -= cfs_rq->tg_load_contrib;
-
-	if (force_update || abs(tg_contrib) > cfs_rq->tg_load_contrib / 8) {
-		atomic_long_add(tg_contrib, &tg->load_avg);
-		cfs_rq->tg_load_contrib += tg_contrib;
-	}
-}
-
-/*
- * Aggregate cfs_rq runnable averages into an equivalent task_group
- * representation for computing load contributions.
- */
-static inline void __update_tg_runnable_avg(struct sched_avg *sa,
-						  struct cfs_rq *cfs_rq)
+static inline void synchronize_tg_load_avg(struct cfs_rq *cfs_rq, u32 old)
 {
-	struct task_group *tg = cfs_rq->tg;
-	long contrib;
-
-	/* The fraction of a cpu used by this cfs_rq */
-	contrib = div_u64((u64)sa->runnable_avg_sum << NICE_0_SHIFT,
-			  sa->runnable_avg_period + 1);
-	contrib -= cfs_rq->tg_runnable_contrib;
+	s32 delta = cfs_rq->avg.load_avg - old;
 
-	if (abs(contrib) > cfs_rq->tg_runnable_contrib / 64) {
-		atomic_add(contrib, &tg->runnable_avg);
-		cfs_rq->tg_runnable_contrib += contrib;
-	}
-}
-
-static inline void __update_group_entity_contrib(struct sched_entity *se)
-{
-	struct cfs_rq *cfs_rq = group_cfs_rq(se);
-	struct task_group *tg = cfs_rq->tg;
-	int runnable_avg;
-
-	u64 contrib;
-
-	contrib = cfs_rq->tg_load_contrib * tg->shares;
-	se->avg.load_avg_contrib = div_u64(contrib,
-				     atomic_long_read(&tg->load_avg) + 1);
-
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
-	}
+	if (delta)
+		atomic_long_add(delta, &cfs_rq->tg->load_avg);
 }
 
 #else /* CONFIG_FAIR_GROUP_SCHED */
-static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
-						 int force_update) {}
-static inline void __update_tg_runnable_avg(struct sched_avg *sa,
-						  struct cfs_rq *cfs_rq) {}
-static inline void __update_group_entity_contrib(struct sched_entity *se) {}
+static inline void synchronize_tg_load_avg(struct cfs_rq *cfs_rq, u32 old) {}
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
-static inline void __update_task_entity_contrib(struct sched_entity *se)
-{
-	u32 contrib;
-
-	/* avoid overflowing a 32-bit type w/ SCHED_LOAD_SCALE */
-	contrib = se->avg.runnable_avg_sum * scale_load_down(se->load.weight);
-	contrib /= (se->avg.runnable_avg_period + 1);
-	se->avg.load_avg_contrib = scale_load(contrib);
-}
-
-/* Compute the current contribution to load_avg by se, return any delta */
-static long __update_entity_load_avg_contrib(struct sched_entity *se)
-{
-	long old_contrib = se->avg.load_avg_contrib;
-
-	if (entity_is_task(se)) {
-		__update_task_entity_contrib(se);
-	} else {
-		__update_tg_runnable_avg(&se->avg, group_cfs_rq(se));
-		__update_group_entity_contrib(se);
-	}
-
-	return se->avg.load_avg_contrib - old_contrib;
-}
-
-static inline void subtract_blocked_load_contrib(struct cfs_rq *cfs_rq,
-						 long load_contrib)
-{
-	if (likely(load_contrib < cfs_rq->blocked_load_avg))
-		cfs_rq->blocked_load_avg -= load_contrib;
-	else
-		cfs_rq->blocked_load_avg = 0;
-}
-
 static inline u64 cfs_rq_clock_task(struct cfs_rq *cfs_rq);
 
-/* Update a sched_entity's runnable average */
-static inline void update_entity_load_avg(struct sched_entity *se,
-					  int update_cfs_rq)
+/* Update task/cfs_rq load average */
+static inline void update_load_avg(struct sched_entity *se)
 {
 	struct cfs_rq *cfs_rq = cfs_rq_of(se);
-	long contrib_delta;
-	u64 now;
+	u64 now = cfs_rq_clock_task(cfs_rq);
+	u32 old_load_avg = cfs_rq->avg.load_avg;
 
-	/*
-	 * For a group entity we need to use their owned cfs_rq_clock_task() in
-	 * case they are the parent of a throttled hierarchy.
-	 */
 	if (entity_is_task(se))
-		now = cfs_rq_clock_task(cfs_rq);
-	else
-		now = cfs_rq_clock_task(group_cfs_rq(se));
-
-	if (!__update_entity_runnable_avg(now, &se->avg, se->on_rq))
-		return;
-
-	contrib_delta = __update_entity_load_avg_contrib(se);
+		__update_load_avg(now, &se->avg, se->on_rq * se->load.weight);
 
-	if (!update_cfs_rq)
-		return;
+	__update_load_avg(now, &cfs_rq->avg, cfs_rq->load.weight);
 
-	if (se->on_rq)
-		cfs_rq->runnable_load_avg += contrib_delta;
-	else
-		subtract_blocked_load_contrib(cfs_rq, -contrib_delta);
+	synchronize_tg_load_avg(cfs_rq, old_load_avg);
 }
 
-/*
- * Decay the load contributed by all blocked children and account this so that
- * their contribution may appropriately discounted when they wake up.
- */
-static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq, int force_update)
+/* Add the load generated by se into cfs_rq's load average */
+static inline void enqueue_entity_load_avg(struct sched_entity *se)
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
-	}
-
-	if (decays) {
-		cfs_rq->blocked_load_avg = decay_load(cfs_rq->blocked_load_avg,
-						      decays);
-		atomic64_add(decays, &cfs_rq->decay_counter);
-		cfs_rq->last_decay = now;
-	}
-
-	__update_cfs_rq_tg_load_contrib(cfs_rq, force_update);
-}
+	struct sched_avg *sa = &se->avg;
+	struct cfs_rq *cfs_rq = cfs_rq_of(se);
+	u64 now = cfs_rq_clock_task(cfs_rq);
+	u32 old_load_avg = cfs_rq->avg.load_avg;
+	int migrated = 0;
 
-/* Add the load generated by se into cfs_rq's child load-average */
-static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
-						  struct sched_entity *se,
-						  int wakeup)
-{
-	/*
-	 * We track migrations using entity decay_count <= 0, on a wake-up
-	 * migration we use a negative decay count to track the remote decays
-	 * accumulated while sleeping.
-	 *
-	 * Newly forked tasks are enqueued with se->avg.decay_count == 0, they
-	 * are seen by enqueue_entity_load_avg() as a migration with an already
-	 * constructed load_avg_contrib.
-	 */
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
+	if (entity_is_task(se)) {
+		if (sa->last_update_time == 0) {
+			sa->last_update_time = now;
+			migrated = 1;
 		}
-		wakeup = 0;
-	} else {
-		__synchronize_entity_decay(se);
-	}
-
-	/* migrated tasks did not contribute to our blocked load */
-	if (wakeup) {
-		subtract_blocked_load_contrib(cfs_rq, se->avg.load_avg_contrib);
-		update_entity_load_avg(se, 0);
+		else
+			__update_load_avg(now, sa, se->on_rq * se->load.weight);
 	}
 
-	cfs_rq->runnable_load_avg += se->avg.load_avg_contrib;
-	/* we force update consideration on load-balancer moves */
-	update_cfs_rq_blocked_load(cfs_rq, !wakeup);
-}
+	__update_load_avg(now, &cfs_rq->avg, cfs_rq->load.weight);
 
-/*
- * Remove se's load from this cfs_rq child load-average, if the entity is
- * transitioning to a blocked state we track its projected decay using
- * blocked_load_avg.
- */
-static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
-						  struct sched_entity *se,
-						  int sleep)
-{
-	update_entity_load_avg(se, 1);
-	/* we force update consideration on load-balancer moves */
-	update_cfs_rq_blocked_load(cfs_rq, !sleep);
+	if (migrated)
+		cfs_rq->avg.load_avg += sa->load_avg;
 
-	cfs_rq->runnable_load_avg -= se->avg.load_avg_contrib;
-	if (sleep) {
-		cfs_rq->blocked_load_avg += se->avg.load_avg_contrib;
-		se->avg.decay_count = atomic64_read(&cfs_rq->decay_counter);
-	} /* migrations, e.g. sleep=0 leave decay_count == 0 */
+	synchronize_tg_load_avg(cfs_rq, old_load_avg);
 }
 
 /*
@@ -2623,16 +2405,8 @@ static int idle_balance(struct rq *this_rq);
 
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
+static inline void update_load_avg(struct sched_entity *se) {}
+static inline void enqueue_entity_load_avg(struct sched_entity *se) {}
 
 static inline int idle_balance(struct rq *rq)
 {
@@ -2764,7 +2538,7 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	 * Update run-time statistics of the 'current'.
 	 */
 	update_curr(cfs_rq);
-	enqueue_entity_load_avg(cfs_rq, se, flags & ENQUEUE_WAKEUP);
+	enqueue_entity_load_avg(se);
 	account_entity_enqueue(cfs_rq, se);
 	update_cfs_shares(cfs_rq);
 
@@ -2839,7 +2613,8 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	 * Update run-time statistics of the 'current'.
 	 */
 	update_curr(cfs_rq);
-	dequeue_entity_load_avg(cfs_rq, se, flags & DEQUEUE_SLEEP);
+
+	update_load_avg(se);
 
 	update_stats_dequeue(cfs_rq, se);
 	if (flags & DEQUEUE_SLEEP) {
@@ -3028,7 +2803,7 @@ static void put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *prev)
 		/* Put 'current' back into the tree. */
 		__enqueue_entity(cfs_rq, prev);
 		/* in !on_rq case, update occurred at dequeue */
-		update_entity_load_avg(prev, 1);
+		update_load_avg(prev);
 	}
 	cfs_rq->curr = NULL;
 }
@@ -3044,8 +2819,7 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
 	/*
 	 * Ensure that runnable average is periodically updated.
 	 */
-	update_entity_load_avg(curr, 1);
-	update_cfs_rq_blocked_load(cfs_rq, 1);
+	update_load_avg(curr);
 	update_cfs_shares(cfs_rq);
 
 #ifdef CONFIG_SCHED_HRTICK
@@ -3924,7 +3698,7 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 			break;
 
 		update_cfs_shares(cfs_rq);
-		update_entity_load_avg(se, 1);
+		update_load_avg(se);
 	}
 
 	if (!se)
@@ -3984,7 +3758,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 			break;
 
 		update_cfs_shares(cfs_rq);
-		update_entity_load_avg(se, 1);
+		update_load_avg(se);
 	}
 
 	if (!se)
@@ -3997,7 +3771,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 /* Used instead of source_load when we know the type == 0 */
 static unsigned long weighted_cpuload(const int cpu)
 {
-	return cpu_rq(cpu)->cfs.runnable_load_avg;
+	return cpu_rq(cpu)->cfs.avg.load_avg;
 }
 
 /*
@@ -4042,7 +3816,7 @@ static unsigned long cpu_avg_load_per_task(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long nr_running = ACCESS_ONCE(rq->nr_running);
-	unsigned long load_avg = rq->cfs.runnable_load_avg;
+	unsigned long load_avg = rq->cfs.avg.load_avg;
 
 	if (nr_running)
 		return load_avg / nr_running;
@@ -4552,17 +4326,9 @@ migrate_task_rq_fair(struct task_struct *p, int next_cpu)
 	struct sched_entity *se = &p->se;
 	struct cfs_rq *cfs_rq = cfs_rq_of(se);
 
-	/*
-	 * Load tracking: accumulate removed load so that it can be processed
-	 * when we next update owning cfs_rq under rq->lock.  Tasks contribute
-	 * to blocked load iff they have a positive decay-count.  It can never
-	 * be negative here since on-rq tasks have decay-count == 0.
-	 */
-	if (se->avg.decay_count) {
-		se->avg.decay_count = -__synchronize_entity_decay(se);
-		atomic_long_add(se->avg.load_avg_contrib,
-						&cfs_rq->removed_load);
-	}
+	/* Update task on old CPU, then ready to go (entity must be off the queue) */
+	__update_load_avg(cfs_rq_clock_task(cfs_rq), &se->avg, 0);
+	se->avg.last_update_time = 0;
 
 	/* We have migrated, no longer consider this task hot */
 	se->exec_start = 0;
@@ -5399,36 +5165,6 @@ next:
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
@@ -5442,12 +5178,12 @@ static void update_blocked_averages(int cpu)
 	 * list_add_leaf_cfs_rq() for details.
 	 */
 	for_each_leaf_cfs_rq(rq, cfs_rq) {
-		/*
-		 * Note: We may want to consider periodically releasing
-		 * rq->lock about these updates so that creating many task
-		 * groups does not result in continually extending hold time.
-		 */
-		__update_blocked_averages_cpu(cfs_rq->tg, rq->cpu);
+		u32 old_load_avg = cfs_rq->avg.load_avg;
+
+		__update_load_avg(cfs_rq_clock_task(cfs_rq),
+			&cfs_rq->avg, cfs_rq->load.weight);
+
+		synchronize_tg_load_avg(cfs_rq, old_load_avg);
 	}
 
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
@@ -5477,14 +5213,14 @@ static void update_cfs_rq_h_load(struct cfs_rq *cfs_rq)
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
@@ -5496,8 +5232,8 @@ static unsigned long task_h_load(struct task_struct *p)
 	struct cfs_rq *cfs_rq = task_cfs_rq(p);
 
 	update_cfs_rq_h_load(cfs_rq);
-	return div64_ul(p->se.avg.load_avg_contrib * cfs_rq->h_load,
-			cfs_rq->runnable_load_avg + 1);
+	return div64_ul(p->se.avg.load_avg * cfs_rq->h_load,
+			cfs_rq->avg.load_avg + 1);
 }
 #else
 static inline void update_blocked_averages(int cpu)
@@ -5506,7 +5242,7 @@ static inline void update_blocked_averages(int cpu)
 
 static unsigned long task_h_load(struct task_struct *p)
 {
-	return p->se.avg.load_avg_contrib;
+	return p->se.avg.load_avg;
 }
 #endif
 
@@ -7437,14 +7173,11 @@ static void switched_from_fair(struct rq *rq, struct task_struct *p)
 
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
+	cfs_rq->avg.load_avg -= se->avg.load_avg;
+	synchronize_tg_load_avg(cfs_rq, -se->avg.load_avg);
+
 #endif
 }
 
@@ -7500,10 +7233,6 @@ void init_cfs_rq(struct cfs_rq *cfs_rq)
 #ifndef CONFIG_64BIT
 	cfs_rq->min_vruntime_copy = cfs_rq->min_vruntime;
 #endif
-#ifdef CONFIG_SMP
-	atomic64_set(&cfs_rq->decay_counter, 1);
-	atomic_long_set(&cfs_rq->removed_load, 0);
-#endif
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
@@ -7548,13 +7277,11 @@ static void task_move_group_fair(struct task_struct *p, int on_rq)
 		cfs_rq = cfs_rq_of(se);
 		se->vruntime += cfs_rq->min_vruntime;
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
+
+		cfs_rq->avg.load_avg += p->se.avg.load_avg;
+		synchronize_tg_load_avg(cfs_rq, p->se.avg.load_avg);
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
index a147571..d68f069 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -210,7 +210,6 @@ struct task_group {
 
 #ifdef	CONFIG_SMP
 	atomic_long_t load_avg;
-	atomic_t runnable_avg;
 #endif
 #endif
 
@@ -331,21 +330,13 @@ struct cfs_rq {
 
 #ifdef CONFIG_SMP
 	/*
-	 * CFS Load tracking
-	 * Under CFS, load is tracked on a per-entity basis and aggregated up.
-	 * This allows for the description of both thread and group usage (in
-	 * the FAIR_GROUP_SCHED case).
+	 * CFS load tracking
+	 * XXX as load.weight could be large, the avg.load_avg may overflow
+	 * its u32
 	 */
-	unsigned long runnable_load_avg, blocked_load_avg;
-	atomic64_t decay_counter;
-	u64 last_decay;
-	atomic_long_t removed_load;
+	struct sched_avg	avg;
 
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

