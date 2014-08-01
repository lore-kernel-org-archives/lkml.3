Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679AbaHAIee (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 04:34:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:19785 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753807AbaHAIeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 04:34:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,778,1400050800"; 
   d="scan'208";a="570378453"
From: Yuyang Du <yuyang.du@intel.com>
To: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org
Cc: pjt@google.com, bsegall@google.com, arjan.van.de.ven@intel.com,
        len.brown@intel.com, rafael.j.wysocki@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, fengguang.wu@intel.com, umgwanakikbuti@gmail.com,
        Yuyang Du <yuyang.du@intel.com>
Subject: [PATCH 2/3 v5] sched: Rewrite per entity runnable load average tracking
Date: Fri,  1 Aug 2014 08:31:01 +0800
Message-Id: <1406853062-25390-3-git-send-email-yuyang.du@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406853062-25390-1-git-send-email-yuyang.du@intel.com>
References: <1406853062-25390-1-git-send-email-yuyang.du@intel.com>
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
   average as a whole and is used as such.

2. Track task entity load average for carrying it between CPUs in migration, group
   cfs_rq and its own entity load averages are tracked for update_cfs_shares and
   task_h_load calc. task_group's load_avg is aggregated from its per CPU cfs_rq's
   load_avg, which is aggregated from its sched_entities (both task and group entity).
   Group entity's weight is proportional to its own cfs_rq's load_avg / task_group's
   load_avg.

3. All task, cfs_rq/group_entity, and task_group have simple, consistent, up-to-date,
   and synchronized load_avg.

This rewrite in principle is equivalent to the previous in functionality, but
significantly reduces code coplexity and hence increases efficiency and clarity.
In addition, the new load_avg is much more smooth/continuous (no abrupt jumping ups
and downs) and decayed/updated more quickly and synchronously to reflect the load
dynamic. As a result, we have less load tracking overhead and better performance.

Signed-off-by: Yuyang Du <yuyang.du@intel.com>
---
 include/linux/sched.h |   21 +-
 kernel/sched/debug.c  |   22 +-
 kernel/sched/fair.c   |  559 ++++++++++++++++---------------------------------
 kernel/sched/proc.c   |    2 +-
 kernel/sched/sched.h  |   20 +-
 5 files changed, 204 insertions(+), 420 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0376b05..b6617a1 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1067,16 +1067,21 @@ struct load_weight {
 	u32 inv_weight;
 };
 
+/*
+ * The load_avg represents an infinite geometric series. The 64 bit
+ * load_sum can:
+ * 1) for cfs_rq, afford 4353082796 (=2^64/47742/88761) entities with
+ * the highest weight (=88761) always runnable, we should not overflow
+ * 2) for entity, support any load.weight always runnable
+ */
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
+	u64 last_update_time;
+	u64 load_sum;
+	unsigned long load_avg;
+	u32 period_contrib;
 };
 
 #ifdef CONFIG_SCHEDSTATS
@@ -1142,7 +1147,7 @@ struct sched_entity {
 #endif
 
 #ifdef CONFIG_SMP
-	/* Per-entity load-tracking */
+	/* Per entity load average tracking */
 	struct sched_avg	avg;
 #endif
 };
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index da0b7d5..2830342 100644
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
+	SEQ_printf(m, "  .%-30s: %lu\n", "load_avg",
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
index 1a2d04f..fa4af54 100644
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
 
@@ -665,20 +660,32 @@ static u64 sched_vslice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 }
 
 #ifdef CONFIG_SMP
-static unsigned long task_h_load(struct task_struct *p);
 
-static inline void __update_task_entity_contrib(struct sched_entity *se);
+/*
+ * We choose a half-life close to 1 scheduling period.
+ * Note: The tables below are dependent on this value.
+ */
+#define LOAD_AVG_PERIOD 32
+#define LOAD_AVG_MAX 47742 /* maximum possible load avg */
+#define LOAD_AVG_MAX_N 345 /* number of full periods to produce LOAD_MAX_AVG */
+
+static unsigned long task_h_load(struct task_struct *p);
 
 /* Give new task start runnable values to heavy its load in infant time */
 void init_task_runnable_average(struct task_struct *p)
 {
-	u32 slice;
+	struct sched_avg *sa = &p->se.avg;
 
-	p->se.avg.decay_count = 0;
-	slice = sched_slice(task_cfs_rq(p), &p->se) >> 10;
-	p->se.avg.runnable_avg_sum = slice;
-	p->se.avg.runnable_avg_period = slice;
-	__update_task_entity_contrib(&p->se);
+	sa->last_update_time = 0;
+	/*
+	 * sched_avg's period_contrib should be strictly less then 1024, so
+	 * we give it 1023 to make sure it is almost a period (1024us), and
+	 * will definitely be update (after enqueue).
+	 */
+	sa->period_contrib = 1023;
+	sa->load_avg = p->se.load.weight;
+	sa->load_sum = p->se.load.weight * LOAD_AVG_MAX;
+	/* when this task enqueue'ed, it will contribute to its cfs_rq's load_avg */
 }
 #else
 void init_task_runnable_average(struct task_struct *p)
@@ -1504,8 +1511,8 @@ static u64 numa_get_avg_runtime(struct task_struct *p, u64 *period)
 		delta = runtime - p->last_sum_exec_runtime;
 		*period = now - p->last_task_numa_placement;
 	} else {
-		delta = p->se.avg.runnable_avg_sum;
-		*period = p->se.avg.runnable_avg_period;
+		delta = p->se.avg.load_avg / p->se.load.weight;
+		*period = LOAD_AVG_MAX;
 	}
 
 	p->last_sum_exec_runtime = runtime;
@@ -2068,18 +2075,7 @@ account_entity_dequeue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 # ifdef CONFIG_SMP
 static inline long calc_tg_weight(struct task_group *tg, struct cfs_rq *cfs_rq)
 {
-	long tg_weight;
-
-	/*
-	 * Use this CPU's actual weight instead of the last load_contribution
-	 * to gain a more accurate current total weight. See
-	 * update_cfs_rq_load_contribution().
-	 */
-	tg_weight = atomic_long_read(&tg->load_avg);
-	tg_weight -= cfs_rq->tg_load_contrib;
-	tg_weight += cfs_rq->load.weight;
-
-	return tg_weight;
+	return atomic_long_read(&tg->load_avg);
 }
 
 static long calc_cfs_shares(struct cfs_rq *cfs_rq, struct task_group *tg)
@@ -2087,7 +2083,7 @@ static long calc_cfs_shares(struct cfs_rq *cfs_rq, struct task_group *tg)
 	long tg_weight, load, shares;
 
 	tg_weight = calc_tg_weight(tg, cfs_rq);
-	load = cfs_rq->load.weight;
+	load = cfs_rq->avg.load_avg;
 
 	shares = (tg->shares * load);
 	if (tg_weight)
@@ -2149,14 +2145,6 @@ static inline void update_cfs_shares(struct cfs_rq *cfs_rq)
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
 #ifdef CONFIG_SMP
-/*
- * We choose a half-life close to 1 scheduling period.
- * Note: The tables below are dependent on this value.
- */
-#define LOAD_AVG_PERIOD 32
-#define LOAD_AVG_MAX 47742 /* maximum possible load avg */
-#define LOAD_AVG_MAX_N 345 /* number of full periods to produce LOAD_MAX_AVG */
-
 /* Precomputed fixed inverse multiplies for multiplication by y^n */
 static const u32 runnable_avg_yN_inv[] = {
 	0xffffffff, 0xfa83b2da, 0xf5257d14, 0xefe4b99a, 0xeac0c6e6, 0xe5b906e6,
@@ -2181,7 +2169,7 @@ static const u32 runnable_avg_yN_sum[] = {
  * Approximate:
  *   val * y^n,    where y^32 ~= 0.5 (~1 scheduling period)
  */
-static __always_inline u64 decay_load(u64 val, u64 n)
+static __always_inline u64 decay_load32(u64 val, u64 n)
 {
 	unsigned int local_n;
 
@@ -2210,6 +2198,14 @@ static __always_inline u64 decay_load(u64 val, u64 n)
 	return val >> 32;
 }
 
+static __always_inline u64 decay_load(u64 val, u64 n)
+{
+	if (likely(val <= UINT_MAX))
+		return decay_load32(val, n);
+
+	return mul_u64_u32_shr(val, decay_load32(1 << 15, n), 15);
+}
+
 /*
  * For updates fully spanning n periods, the contribution to runnable
  * average will be: \Sum 1024*y^n
@@ -2234,7 +2230,7 @@ static u32 __compute_runnable_contrib(u64 n)
 		n -= LOAD_AVG_PERIOD;
 	} while (n > LOAD_AVG_PERIOD);
 
-	contrib = decay_load(contrib, n);
+	contrib = decay_load32(contrib, n);
 	return contrib + runnable_avg_yN_sum[n];
 }
 
@@ -2266,21 +2262,20 @@ static u32 __compute_runnable_contrib(u64 n)
  *   load_avg = u_0` + y*(u_0 + u_1*y + u_2*y^2 + ... )
  *            = u_0 + u_1*y + u_2*y^2 + ... [re-labeling u_i --> u_{i+1}]
  */
-static __always_inline int __update_entity_runnable_avg(u64 now,
-							struct sched_avg *sa,
-							int runnable)
+static __always_inline int
+__update_load_avg(u64 now, struct sched_avg *sa, unsigned long w)
 {
 	u64 delta, periods;
-	u32 runnable_contrib;
+	u32 contrib;
 	int delta_w, decayed = 0;
 
-	delta = now - sa->last_runnable_update;
+	delta = now - sa->last_update_time;
 	/*
 	 * This should only happen when time goes backwards, which it
 	 * unfortunately does during sched clock init when we swap over to TSC.
 	 */
 	if ((s64)delta < 0) {
-		sa->last_runnable_update = now;
+		sa->last_update_time = now;
 		return 0;
 	}
 
@@ -2291,23 +2286,24 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
 	delta >>= 10;
 	if (!delta)
 		return 0;
-	sa->last_runnable_update = now;
+	sa->last_update_time = now;
 
 	/* delta_w is the amount already accumulated against our next period */
-	delta_w = sa->runnable_avg_period % 1024;
+	delta_w = sa->period_contrib;
 	if (delta + delta_w >= 1024) {
-		/* period roll-over */
 		decayed = 1;
 
+		/* how much left for next period will start over, we don't know yet */
+		sa->period_contrib = 0;
+
 		/*
 		 * Now that we know we're crossing a period boundary, figure
 		 * out how much from delta we need to complete the current
 		 * period and accrue it.
 		 */
 		delta_w = 1024 - delta_w;
-		if (runnable)
-			sa->runnable_avg_sum += delta_w;
-		sa->runnable_avg_period += delta_w;
+		if (w)
+			sa->load_sum += w * delta_w;
 
 		delta -= delta_w;
 
@@ -2315,290 +2311,137 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
 		periods = delta / 1024;
 		delta %= 1024;
 
-		sa->runnable_avg_sum = decay_load(sa->runnable_avg_sum,
-						  periods + 1);
-		sa->runnable_avg_period = decay_load(sa->runnable_avg_period,
-						     periods + 1);
+		sa->load_sum = decay_load(sa->load_sum, periods + 1);
 
 		/* Efficiently calculate \sum (1..n_period) 1024*y^i */
-		runnable_contrib = __compute_runnable_contrib(periods);
-		if (runnable)
-			sa->runnable_avg_sum += runnable_contrib;
-		sa->runnable_avg_period += runnable_contrib;
+		contrib = __compute_runnable_contrib(periods);
+		if (w)
+			sa->load_sum += w * contrib;
 	}
 
 	/* Remainder of delta accrued against u_0` */
-	if (runnable)
-		sa->runnable_avg_sum += delta;
-	sa->runnable_avg_period += delta;
+	if (w)
+		sa->load_sum += w * delta;
 
-	return decayed;
-}
+	sa->period_contrib += delta;
 
-/* Synchronize an entity's decay with its parenting cfs_rq.*/
-static inline u64 __synchronize_entity_decay(struct sched_entity *se)
-{
-	struct cfs_rq *cfs_rq = cfs_rq_of(se);
-	u64 decays = atomic64_read(&cfs_rq->decay_counter);
+	if (decayed)
+		sa->load_avg = div_u64(sa->load_sum, LOAD_AVG_MAX);
 
-	decays -= se->avg.decay_count;
-	if (!decays)
-		return 0;
-
-	se->avg.load_avg_contrib = decay_load(se->avg.load_avg_contrib, decays);
-	se->avg.decay_count = 0;
-
-	return decays;
+	return decayed;
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
 /*
- * Aggregate cfs_rq runnable averages into an equivalent task_group
- * representation for computing load contributions.
+ * Updating tg's load_avg is necessary before update_cfs_share (which is done)
+ * and effective_load (which is not done because it is too costly).
  */
-static inline void __update_tg_runnable_avg(struct sched_avg *sa,
-						  struct cfs_rq *cfs_rq)
+static inline void update_tg_load_avg(struct cfs_rq *cfs_rq)
 {
-	struct task_group *tg = cfs_rq->tg;
-	long contrib;
-
-	/* The fraction of a cpu used by this cfs_rq */
-	contrib = div_u64((u64)sa->runnable_avg_sum << NICE_0_SHIFT,
-			  sa->runnable_avg_period + 1);
-	contrib -= cfs_rq->tg_runnable_contrib;
+	long delta = cfs_rq->avg.load_avg - cfs_rq->tg_load_avg_contrib;
 
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
+	if (abs(delta) > cfs_rq->tg_load_avg_contrib / 64) {
+		atomic_long_add(delta, &cfs_rq->tg->load_avg);
+		cfs_rq->tg_load_avg_contrib = cfs_rq->avg.load_avg;
 	}
 }
 
 #else /* CONFIG_FAIR_GROUP_SCHED */
-static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
-						 int force_update) {}
-static inline void __update_tg_runnable_avg(struct sched_avg *sa,
-						  struct cfs_rq *cfs_rq) {}
-static inline void __update_group_entity_contrib(struct sched_entity *se) {}
+static inline void update_tg_load_avg(struct cfs_rq *cfs_rq) {}
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
+static inline u64 cfs_rq_clock_task(struct cfs_rq *cfs_rq);
 
-/* Compute the current contribution to load_avg by se, return any delta */
-static long __update_entity_load_avg_contrib(struct sched_entity *se)
+/* Group cfs_rq's load_avg is used for task_h_load and update_cfs_share */
+static inline int update_cfs_rq_load_avg(u64 now, struct cfs_rq *cfs_rq)
 {
-	long old_contrib = se->avg.load_avg_contrib;
+	int decayed;
 
-	if (entity_is_task(se)) {
-		__update_task_entity_contrib(se);
-	} else {
-		__update_tg_runnable_avg(&se->avg, group_cfs_rq(se));
-		__update_group_entity_contrib(se);
+	if (atomic_long_read(&cfs_rq->removed_load_avg)) {
+		long r = atomic_long_xchg(&cfs_rq->removed_load_avg, 0);
+		cfs_rq->avg.load_avg = max_t(long, cfs_rq->avg.load_avg - r, 0);
+		cfs_rq->avg.load_sum =
+			max_t(s64, cfs_rq->avg.load_sum - r * LOAD_AVG_MAX, 0);
 	}
 
-	return se->avg.load_avg_contrib - old_contrib;
-}
+	decayed = __update_load_avg(now, &cfs_rq->avg, cfs_rq->load.weight);
 
-static inline void subtract_blocked_load_contrib(struct cfs_rq *cfs_rq,
-						 long load_contrib)
-{
-	if (likely(load_contrib < cfs_rq->blocked_load_avg))
-		cfs_rq->blocked_load_avg -= load_contrib;
-	else
-		cfs_rq->blocked_load_avg = 0;
-}
+#ifndef CONFIG_64BIT
+	smp_wmb();
+	cfs_rq->load_last_update_time_copy = cfs_rq->avg.last_update_time;
+#endif
 
-static inline u64 cfs_rq_clock_task(struct cfs_rq *cfs_rq);
+	return decayed;
+}
 
-/* Update a sched_entity's runnable average */
-static inline void update_entity_load_avg(struct sched_entity *se,
-					  int update_cfs_rq)
+/* Update task and its cfs_rq load average */
+static inline void update_load_avg(struct sched_entity *se, int update_tg)
 {
 	struct cfs_rq *cfs_rq = cfs_rq_of(se);
-	long contrib_delta;
-	u64 now;
+	u64 now = cfs_rq_clock_task(cfs_rq);
 
 	/*
-	 * For a group entity we need to use their owned cfs_rq_clock_task() in
-	 * case they are the parent of a throttled hierarchy.
+	 * Track task load average for carrying it to new CPU after migrated,
+	 * and group sched_entity for task_h_load calc in migration
 	 */
-	if (entity_is_task(se))
-		now = cfs_rq_clock_task(cfs_rq);
-	else
-		now = cfs_rq_clock_task(group_cfs_rq(se));
+	__update_load_avg(now, &se->avg, se->on_rq * se->load.weight);
 
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
+	if (update_cfs_rq_load_avg(now, cfs_rq) && update_tg)
+		update_tg_load_avg(cfs_rq);
 }
 
-/*
- * Decay the load contributed by all blocked children and account this so that
- * their contribution may appropriately discounted when they wake up.
- */
-static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq, int force_update)
+/* Add the load generated by se into cfs_rq's load average */
+static inline void
+enqueue_entity_load_avg(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	u64 now = cfs_rq_clock_task(cfs_rq) >> 20;
-	u64 decays;
+	struct sched_avg *sa = &se->avg;
+	u64 now = cfs_rq_clock_task(cfs_rq);
+	int migrated = 0, decayed;
 
-	decays = now - cfs_rq->last_decay;
-	if (!decays && !force_update)
-		return;
+	if (sa->last_update_time == 0) {
+		sa->last_update_time = now;
 
-	if (atomic_long_read(&cfs_rq->removed_load)) {
-		unsigned long removed_load;
-		removed_load = atomic_long_xchg(&cfs_rq->removed_load, 0);
-		subtract_blocked_load_contrib(cfs_rq, removed_load);
+		if (entity_is_task(se))
+			migrated = 1;
 	}
-
-	if (decays) {
-		cfs_rq->blocked_load_avg = decay_load(cfs_rq->blocked_load_avg,
-						      decays);
-		atomic64_add(decays, &cfs_rq->decay_counter);
-		cfs_rq->last_decay = now;
+	else {
+		__update_load_avg(now, sa, se->on_rq * se->load.weight);
 	}
 
-	__update_cfs_rq_tg_load_contrib(cfs_rq, force_update);
-}
-
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
-		}
-		wakeup = 0;
-	} else {
-		__synchronize_entity_decay(se);
-	}
+	decayed = update_cfs_rq_load_avg(now, cfs_rq);
 
-	/* migrated tasks did not contribute to our blocked load */
-	if (wakeup) {
-		subtract_blocked_load_contrib(cfs_rq, se->avg.load_avg_contrib);
-		update_entity_load_avg(se, 0);
+	if (migrated) {
+		cfs_rq->avg.load_avg += sa->load_avg;
+		cfs_rq->avg.load_sum += sa->load_sum;
 	}
 
-	cfs_rq->runnable_load_avg += se->avg.load_avg_contrib;
-	/* we force update consideration on load-balancer moves */
-	update_cfs_rq_blocked_load(cfs_rq, !wakeup);
+	if (decayed || migrated)
+		update_tg_load_avg(cfs_rq);
 }
 
 /*
- * Remove se's load from this cfs_rq child load-average, if the entity is
- * transitioning to a blocked state we track its projected decay using
- * blocked_load_avg.
+ * Task first catches up with cfs_rq, and then subtract
+ * itself from the cfs_rq (task must be off the queue now).
  */
-static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
-						  struct sched_entity *se,
-						  int sleep)
+void remove_entity_load_avg(struct sched_entity *se)
 {
-	update_entity_load_avg(se, 1);
-	/* we force update consideration on load-balancer moves */
-	update_cfs_rq_blocked_load(cfs_rq, !sleep);
+	struct cfs_rq *cfs_rq = cfs_rq_of(se);
+	u64 last_update_time;
+
+#ifndef CONFIG_64BIT
+	u64 last_update_time_copy;
+
+	do {
+		last_update_time_copy = cfs_rq->load_last_update_time_copy;
+		smp_rmb();
+		last_update_time = cfs_rq->avg.last_update_time;
+	} while (last_update_time != last_update_time_copy);
+#else
+	last_update_time = cfs_rq->avg.last_update_time;
+#endif
 
-	cfs_rq->runnable_load_avg -= se->avg.load_avg_contrib;
-	if (sleep) {
-		cfs_rq->blocked_load_avg += se->avg.load_avg_contrib;
-		se->avg.decay_count = atomic64_read(&cfs_rq->decay_counter);
-	} /* migrations, e.g. sleep=0 leave decay_count == 0 */
+	__update_load_avg(last_update_time, &se->avg, 0);
+	atomic_long_add(se->avg.load_avg, &cfs_rq->removed_load_avg);
 }
 
 /*
@@ -2623,16 +2466,10 @@ static int idle_balance(struct rq *this_rq);
 
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
+static inline void
+enqueue_entity_load_avg(struct cfs_rq *cfs_rq, struct sched_entity *se) {}
+static inline void remove_entity_load_avg(struct sched_entity *se) {}
 
 static inline int idle_balance(struct rq *rq)
 {
@@ -2764,7 +2601,7 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	 * Update run-time statistics of the 'current'.
 	 */
 	update_curr(cfs_rq);
-	enqueue_entity_load_avg(cfs_rq, se, flags & ENQUEUE_WAKEUP);
+	enqueue_entity_load_avg(cfs_rq, se);
 	account_entity_enqueue(cfs_rq, se);
 	update_cfs_shares(cfs_rq);
 
@@ -2839,7 +2676,8 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	 * Update run-time statistics of the 'current'.
 	 */
 	update_curr(cfs_rq);
-	dequeue_entity_load_avg(cfs_rq, se, flags & DEQUEUE_SLEEP);
+
+	update_load_avg(se, 1);
 
 	update_stats_dequeue(cfs_rq, se);
 	if (flags & DEQUEUE_SLEEP) {
@@ -3028,7 +2866,7 @@ static void put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *prev)
 		/* Put 'current' back into the tree. */
 		__enqueue_entity(cfs_rq, prev);
 		/* in !on_rq case, update occurred at dequeue */
-		update_entity_load_avg(prev, 1);
+		update_load_avg(prev, 0);
 	}
 	cfs_rq->curr = NULL;
 }
@@ -3044,8 +2882,7 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
 	/*
 	 * Ensure that runnable average is periodically updated.
 	 */
-	update_entity_load_avg(curr, 1);
-	update_cfs_rq_blocked_load(cfs_rq, 1);
+	update_load_avg(curr, 1);
 	update_cfs_shares(cfs_rq);
 
 #ifdef CONFIG_SCHED_HRTICK
@@ -3923,8 +3760,8 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		if (cfs_rq_throttled(cfs_rq))
 			break;
 
+		update_load_avg(se, 1);
 		update_cfs_shares(cfs_rq);
-		update_entity_load_avg(se, 1);
 	}
 
 	if (!se)
@@ -3983,8 +3820,8 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		if (cfs_rq_throttled(cfs_rq))
 			break;
 
+		update_load_avg(se, 1);
 		update_cfs_shares(cfs_rq);
-		update_entity_load_avg(se, 1);
 	}
 
 	if (!se)
@@ -3997,7 +3834,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 /* Used instead of source_load when we know the type == 0 */
 static unsigned long weighted_cpuload(const int cpu)
 {
-	return cpu_rq(cpu)->cfs.runnable_load_avg;
+	return cpu_rq(cpu)->cfs.avg.load_avg;
 }
 
 /*
@@ -4042,7 +3879,7 @@ static unsigned long cpu_avg_load_per_task(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long nr_running = ACCESS_ONCE(rq->nr_running);
-	unsigned long load_avg = rq->cfs.runnable_load_avg;
+	unsigned long load_avg = rq->cfs.avg.load_avg;
 
 	if (nr_running)
 		return load_avg / nr_running;
@@ -4161,7 +3998,7 @@ static long effective_load(struct task_group *tg, int cpu, long wl, long wg)
 		/*
 		 * w = rw_i + @wl
 		 */
-		w = se->my_q->load.weight + wl;
+		w = se->my_q->avg.load_avg + wl;
 
 		/*
 		 * wl = S * s'_i; see (2)
@@ -4182,7 +4019,7 @@ static long effective_load(struct task_group *tg, int cpu, long wl, long wg)
 		/*
 		 * wl = dw_i = S * (s'_i - s_i); see (3)
 		 */
-		wl -= se->load.weight;
+		wl -= se->avg.load_avg;
 
 		/*
 		 * Recursively apply this logic to all parent groups to compute
@@ -4256,14 +4093,14 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
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
@@ -4546,26 +4383,22 @@ unlock:
  * previous cpu.  However, the caller only guarantees p->pi_lock is held; no
  * other assumptions, including the state of rq->lock, should be made.
  */
-static void
-migrate_task_rq_fair(struct task_struct *p, int next_cpu)
+static void migrate_task_rq_fair(struct task_struct *p, int next_cpu)
 {
-	struct sched_entity *se = &p->se;
-	struct cfs_rq *cfs_rq = cfs_rq_of(se);
-
 	/*
-	 * Load tracking: accumulate removed load so that it can be processed
-	 * when we next update owning cfs_rq under rq->lock.  Tasks contribute
-	 * to blocked load iff they have a positive decay-count.  It can never
-	 * be negative here since on-rq tasks have decay-count == 0.
+	 * We are supposed to update the task to "current" time, then its up to date
+	 * and ready to go to new CPU/cfs_rq. But we have difficulty in getting
+	 * what current time is, so simply throw away the out-of-date time. This
+	 * will result in the wakee task is less decayed, but giving the wakee more
+	 * load sounds not bad.
 	 */
-	if (se->avg.decay_count) {
-		se->avg.decay_count = -__synchronize_entity_decay(se);
-		atomic_long_add(se->avg.load_avg_contrib,
-						&cfs_rq->removed_load);
-	}
+	remove_entity_load_avg(&p->se);
+
+	/* Tell new CPU we are migrated */
+	p->se.avg.last_update_time = 0;
 
 	/* We have migrated, no longer consider this task hot */
-	se->exec_start = 0;
+	p->se.exec_start = 0;
 }
 #endif /* CONFIG_SMP */
 
@@ -5399,36 +5232,6 @@ next:
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
@@ -5437,17 +5240,17 @@ static void update_blocked_averages(int cpu)
 
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
@@ -5477,14 +5280,14 @@ static void update_cfs_rq_h_load(struct cfs_rq *cfs_rq)
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
@@ -5496,8 +5299,8 @@ static unsigned long task_h_load(struct task_struct *p)
 	struct cfs_rq *cfs_rq = task_cfs_rq(p);
 
 	update_cfs_rq_h_load(cfs_rq);
-	return div64_ul(p->se.avg.load_avg_contrib * cfs_rq->h_load,
-			cfs_rq->runnable_load_avg + 1);
+	return div64_ul(p->se.avg.load_avg * cfs_rq->h_load,
+			cfs_rq->avg.load_avg + 1);
 }
 #else
 static inline void update_blocked_averages(int cpu)
@@ -5506,7 +5309,7 @@ static inline void update_blocked_averages(int cpu)
 
 static unsigned long task_h_load(struct task_struct *p)
 {
-	return p->se.avg.load_avg_contrib;
+	return p->se.avg.load_avg;
 }
 #endif
 
@@ -7436,15 +7239,14 @@ static void switched_from_fair(struct rq *rq, struct task_struct *p)
 	}
 
 #ifdef CONFIG_SMP
-	/*
-	* Remove our load from contribution when we leave sched_fair
-	* and ensure we don't carry in an old decay_count if we
-	* switch back.
-	*/
-	if (se->avg.decay_count) {
-		__synchronize_entity_decay(se);
-		subtract_blocked_load_contrib(cfs_rq, se->avg.load_avg_contrib);
-	}
+	/* Catch up with the cfs_rq and remove our load when we leave */
+	__update_load_avg(cfs_rq->avg.last_update_time, &se->avg,
+		se->on_rq * se->load.weight);
+
+	cfs_rq->avg.load_avg =
+		max_t(long, cfs_rq->avg.load_avg - se->avg.load_avg, 0);
+	cfs_rq->avg.load_sum =
+		max_t(s64, cfs_rq->avg.load_sum - se->avg.load_sum, 0);
 #endif
 }
 
@@ -7501,8 +7303,7 @@ void init_cfs_rq(struct cfs_rq *cfs_rq)
 	cfs_rq->min_vruntime_copy = cfs_rq->min_vruntime;
 #endif
 #ifdef CONFIG_SMP
-	atomic64_set(&cfs_rq->decay_counter, 1);
-	atomic_long_set(&cfs_rq->removed_load, 0);
+	atomic_long_set(&cfs_rq->removed_load_avg, 0);
 #endif
 }
 
@@ -7547,14 +7348,12 @@ static void task_move_group_fair(struct task_struct *p, int on_rq)
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
+		/* Virtually synchronize task with its new cfs_rq */
+		p->se.avg.last_update_time = cfs_rq->avg.last_update_time;
+		cfs_rq->avg.load_avg += p->se.avg.load_avg;
+		cfs_rq->avg.load_sum += p->se.avg.load_sum;
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
index a147571..7c8c2a9 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -210,7 +210,6 @@ struct task_group {
 
 #ifdef	CONFIG_SMP
 	atomic_long_t load_avg;
-	atomic_t runnable_avg;
 #endif
 #endif
 
@@ -331,21 +330,16 @@ struct cfs_rq {
 
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
+	struct sched_avg avg;
+	unsigned long tg_load_avg_contrib;
+	atomic_long_t removed_load_avg;
+#ifndef CONFIG_64BIT
+	u64 load_last_update_time_copy;
+#endif
 
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

