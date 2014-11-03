Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbaKCQ4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 11:56:07 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:49313 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbaKCQ4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 11:56:00 -0500
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        preeti@linux.vnet.ibm.com, Morten.Rasmussen@arm.com,
        kamalesh@linux.vnet.ibm.com, linux-arm-kernel@lists.infradead.org
Cc: riel@redhat.com, efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Paul Turner <pjt@google.com>, Ben Segall <bsegall@google.com>
Subject: [PATCH v9 01/10] sched: add utilization_avg_contrib
Date: Mon,  3 Nov 2014 17:54:38 +0100
Message-Id: <1415033687-23294-2-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415033687-23294-1-git-send-email-vincent.guittot@linaro.org>
References: <1415033687-23294-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new statistics which reflect the average time a task is running on the CPU
and the sum of these running time of the tasks on a runqueue. The latter is
named utilization_load_avg.

This patch is based on the usage metric that was proposed in the 1st
versions of the per-entity load tracking patchset by Paul Turner
<pjt@google.com> but that has be removed afterwards. This version differs from
the original one in the sense that it's not linked to task_group.

The rq's utilization_load_avg will be used to check if a rq is overloaded or
not instead of trying to compute how many tasks a group of CPUs can handle.

Rename runnable_avg_period into avg_period as it is now used with both
runnable_avg_sum and running_avg_sum

Add some descriptions of the variables to explain their differences

cc: Paul Turner <pjt@google.com>
cc: Ben Segall <bsegall@google.com>

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 include/linux/sched.h | 21 ++++++++++++---
 kernel/sched/debug.c  | 10 ++++---
 kernel/sched/fair.c   | 74 ++++++++++++++++++++++++++++++++++++++++-----------
 kernel/sched/sched.h  |  8 +++++-
 4 files changed, 89 insertions(+), 24 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 18f5262..b576b29 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1071,15 +1071,28 @@ struct load_weight {
 };
 
 struct sched_avg {
+	u64 last_runnable_update;
+	s64 decay_count;
+	/*
+	 * utilization_avg_contrib describes the amount of time that a
+	 * sched_entity is running on a CPU. It is based on running_avg_sum
+	 * and is scaled in the range [0..SCHED_LOAD_SCALE].
+	 * load_avg_contrib described the amount of time that a sched_entity
+	 * is runnable on a rq. It is based on both runnable_avg_sum and the
+	 * weight of the task.
+	 */
+	unsigned long load_avg_contrib, utilization_avg_contrib;
 	/*
 	 * These sums represent an infinite geometric series and so are bound
 	 * above by 1024/(1-y).  Thus we only need a u32 to store them for all
 	 * choices of y < 1-2^(-32)*1024.
+	 * running_avg_sum reflects the time that the sched_entity is
+	 * effectively running on the CPU.
+	 * runnable_avg_sum represents the amount of time a sched_entity is on
+	 * a runqueue which includes the running time that is monitored by
+	 * running_avg_sum.
 	 */
-	u32 runnable_avg_sum, runnable_avg_period;
-	u64 last_runnable_update;
-	s64 decay_count;
-	unsigned long load_avg_contrib;
+	u32 runnable_avg_sum, avg_period, running_avg_sum;
 };
 
 #ifdef CONFIG_SCHEDSTATS
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index ce33780..f384452 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -71,7 +71,7 @@ static void print_cfs_group_stats(struct seq_file *m, int cpu, struct task_group
 	if (!se) {
 		struct sched_avg *avg = &cpu_rq(cpu)->avg;
 		P(avg->runnable_avg_sum);
-		P(avg->runnable_avg_period);
+		P(avg->avg_period);
 		return;
 	}
 
@@ -94,7 +94,7 @@ static void print_cfs_group_stats(struct seq_file *m, int cpu, struct task_group
 	P(se->load.weight);
 #ifdef CONFIG_SMP
 	P(se->avg.runnable_avg_sum);
-	P(se->avg.runnable_avg_period);
+	P(se->avg.avg_period);
 	P(se->avg.load_avg_contrib);
 	P(se->avg.decay_count);
 #endif
@@ -214,6 +214,8 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 			cfs_rq->runnable_load_avg);
 	SEQ_printf(m, "  .%-30s: %ld\n", "blocked_load_avg",
 			cfs_rq->blocked_load_avg);
+	SEQ_printf(m, "  .%-30s: %ld\n", "utilization_load_avg",
+			cfs_rq->utilization_load_avg);
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	SEQ_printf(m, "  .%-30s: %ld\n", "tg_load_contrib",
 			cfs_rq->tg_load_contrib);
@@ -628,8 +630,10 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 	P(se.load.weight);
 #ifdef CONFIG_SMP
 	P(se.avg.runnable_avg_sum);
-	P(se.avg.runnable_avg_period);
+	P(se.avg.running_avg_sum);
+	P(se.avg.avg_period);
 	P(se.avg.load_avg_contrib);
+	P(se.avg.utilization_avg_contrib);
 	P(se.avg.decay_count);
 #endif
 	P(policy);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index bd61cff..3a91ae6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -670,6 +670,7 @@ static int select_idle_sibling(struct task_struct *p, int cpu);
 static unsigned long task_h_load(struct task_struct *p);
 
 static inline void __update_task_entity_contrib(struct sched_entity *se);
+static inline void __update_task_entity_utilization(struct sched_entity *se);
 
 /* Give new task start runnable values to heavy its load in infant time */
 void init_task_runnable_average(struct task_struct *p)
@@ -678,9 +679,10 @@ void init_task_runnable_average(struct task_struct *p)
 
 	p->se.avg.decay_count = 0;
 	slice = sched_slice(task_cfs_rq(p), &p->se) >> 10;
-	p->se.avg.runnable_avg_sum = slice;
-	p->se.avg.runnable_avg_period = slice;
+	p->se.avg.runnable_avg_sum = p->se.avg.running_avg_sum = slice;
+	p->se.avg.avg_period = slice;
 	__update_task_entity_contrib(&p->se);
+	__update_task_entity_utilization(&p->se);
 }
 #else
 void init_task_runnable_average(struct task_struct *p)
@@ -1548,7 +1550,7 @@ static u64 numa_get_avg_runtime(struct task_struct *p, u64 *period)
 		*period = now - p->last_task_numa_placement;
 	} else {
 		delta = p->se.avg.runnable_avg_sum;
-		*period = p->se.avg.runnable_avg_period;
+		*period = p->se.avg.avg_period;
 	}
 
 	p->last_sum_exec_runtime = runtime;
@@ -2294,7 +2296,8 @@ static u32 __compute_runnable_contrib(u64 n)
  */
 static __always_inline int __update_entity_runnable_avg(u64 now,
 							struct sched_avg *sa,
-							int runnable)
+							int runnable,
+							int running)
 {
 	u64 delta, periods;
 	u32 runnable_contrib;
@@ -2320,7 +2323,7 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
 	sa->last_runnable_update = now;
 
 	/* delta_w is the amount already accumulated against our next period */
-	delta_w = sa->runnable_avg_period % 1024;
+	delta_w = sa->avg_period % 1024;
 	if (delta + delta_w >= 1024) {
 		/* period roll-over */
 		decayed = 1;
@@ -2333,7 +2336,9 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
 		delta_w = 1024 - delta_w;
 		if (runnable)
 			sa->runnable_avg_sum += delta_w;
-		sa->runnable_avg_period += delta_w;
+		if (running)
+			sa->running_avg_sum += delta_w;
+		sa->avg_period += delta_w;
 
 		delta -= delta_w;
 
@@ -2343,20 +2348,26 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
 
 		sa->runnable_avg_sum = decay_load(sa->runnable_avg_sum,
 						  periods + 1);
-		sa->runnable_avg_period = decay_load(sa->runnable_avg_period,
+		sa->running_avg_sum = decay_load(sa->running_avg_sum,
+						  periods + 1);
+		sa->avg_period = decay_load(sa->avg_period,
 						     periods + 1);
 
 		/* Efficiently calculate \sum (1..n_period) 1024*y^i */
 		runnable_contrib = __compute_runnable_contrib(periods);
 		if (runnable)
 			sa->runnable_avg_sum += runnable_contrib;
-		sa->runnable_avg_period += runnable_contrib;
+		if (running)
+			sa->running_avg_sum += runnable_contrib;
+		sa->avg_period += runnable_contrib;
 	}
 
 	/* Remainder of delta accrued against u_0` */
 	if (runnable)
 		sa->runnable_avg_sum += delta;
-	sa->runnable_avg_period += delta;
+	if (running)
+		sa->running_avg_sum += delta;
+	sa->avg_period += delta;
 
 	return decayed;
 }
@@ -2372,6 +2383,8 @@ static inline u64 __synchronize_entity_decay(struct sched_entity *se)
 		return 0;
 
 	se->avg.load_avg_contrib = decay_load(se->avg.load_avg_contrib, decays);
+	se->avg.utilization_avg_contrib =
+		decay_load(se->avg.utilization_avg_contrib, decays);
 	se->avg.decay_count = 0;
 
 	return decays;
@@ -2408,7 +2421,7 @@ static inline void __update_tg_runnable_avg(struct sched_avg *sa,
 
 	/* The fraction of a cpu used by this cfs_rq */
 	contrib = div_u64((u64)sa->runnable_avg_sum << NICE_0_SHIFT,
-			  sa->runnable_avg_period + 1);
+			  sa->avg_period + 1);
 	contrib -= cfs_rq->tg_runnable_contrib;
 
 	if (abs(contrib) > cfs_rq->tg_runnable_contrib / 64) {
@@ -2461,7 +2474,8 @@ static inline void __update_group_entity_contrib(struct sched_entity *se)
 
 static inline void update_rq_runnable_avg(struct rq *rq, int runnable)
 {
-	__update_entity_runnable_avg(rq_clock_task(rq), &rq->avg, runnable);
+	__update_entity_runnable_avg(rq_clock_task(rq), &rq->avg, runnable,
+			runnable);
 	__update_tg_runnable_avg(&rq->avg, &rq->cfs);
 }
 #else /* CONFIG_FAIR_GROUP_SCHED */
@@ -2479,7 +2493,7 @@ static inline void __update_task_entity_contrib(struct sched_entity *se)
 
 	/* avoid overflowing a 32-bit type w/ SCHED_LOAD_SCALE */
 	contrib = se->avg.runnable_avg_sum * scale_load_down(se->load.weight);
-	contrib /= (se->avg.runnable_avg_period + 1);
+	contrib /= (se->avg.avg_period + 1);
 	se->avg.load_avg_contrib = scale_load(contrib);
 }
 
@@ -2498,6 +2512,27 @@ static long __update_entity_load_avg_contrib(struct sched_entity *se)
 	return se->avg.load_avg_contrib - old_contrib;
 }
 
+
+static inline void __update_task_entity_utilization(struct sched_entity *se)
+{
+	u32 contrib;
+
+	/* avoid overflowing a 32-bit type w/ SCHED_LOAD_SCALE */
+	contrib = se->avg.running_avg_sum * scale_load_down(SCHED_LOAD_SCALE);
+	contrib /= (se->avg.avg_period + 1);
+	se->avg.utilization_avg_contrib = scale_load(contrib);
+}
+
+static long __update_entity_utilization_avg_contrib(struct sched_entity *se)
+{
+	long old_contrib = se->avg.utilization_avg_contrib;
+
+	if (entity_is_task(se))
+		__update_task_entity_utilization(se);
+
+	return se->avg.utilization_avg_contrib - old_contrib;
+}
+
 static inline void subtract_blocked_load_contrib(struct cfs_rq *cfs_rq,
 						 long load_contrib)
 {
@@ -2514,7 +2549,7 @@ static inline void update_entity_load_avg(struct sched_entity *se,
 					  int update_cfs_rq)
 {
 	struct cfs_rq *cfs_rq = cfs_rq_of(se);
-	long contrib_delta;
+	long contrib_delta, utilization_delta;
 	u64 now;
 
 	/*
@@ -2526,18 +2561,22 @@ static inline void update_entity_load_avg(struct sched_entity *se,
 	else
 		now = cfs_rq_clock_task(group_cfs_rq(se));
 
-	if (!__update_entity_runnable_avg(now, &se->avg, se->on_rq))
+	if (!__update_entity_runnable_avg(now, &se->avg, se->on_rq,
+					cfs_rq->curr == se))
 		return;
 
 	contrib_delta = __update_entity_load_avg_contrib(se);
+	utilization_delta = __update_entity_utilization_avg_contrib(se);
 
 	if (!update_cfs_rq)
 		return;
 
-	if (se->on_rq)
+	if (se->on_rq) {
 		cfs_rq->runnable_load_avg += contrib_delta;
-	else
+		cfs_rq->utilization_load_avg += utilization_delta;
+	} else {
 		subtract_blocked_load_contrib(cfs_rq, -contrib_delta);
+	}
 }
 
 /*
@@ -2612,6 +2651,7 @@ static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
 	}
 
 	cfs_rq->runnable_load_avg += se->avg.load_avg_contrib;
+	cfs_rq->utilization_load_avg += se->avg.utilization_avg_contrib;
 	/* we force update consideration on load-balancer moves */
 	update_cfs_rq_blocked_load(cfs_rq, !wakeup);
 }
@@ -2630,6 +2670,7 @@ static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
 	update_cfs_rq_blocked_load(cfs_rq, !sleep);
 
 	cfs_rq->runnable_load_avg -= se->avg.load_avg_contrib;
+	cfs_rq->utilization_load_avg -= se->avg.utilization_avg_contrib;
 	if (sleep) {
 		cfs_rq->blocked_load_avg += se->avg.load_avg_contrib;
 		se->avg.decay_count = atomic64_read(&cfs_rq->decay_counter);
@@ -2967,6 +3008,7 @@ set_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		 */
 		update_stats_wait_end(cfs_rq, se);
 		__dequeue_entity(cfs_rq, se);
+		update_entity_load_avg(se, 1);
 	}
 
 	update_stats_curr_start(cfs_rq, se);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 6130251..c34bd11 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -343,8 +343,14 @@ struct cfs_rq {
 	 * Under CFS, load is tracked on a per-entity basis and aggregated up.
 	 * This allows for the description of both thread and group usage (in
 	 * the FAIR_GROUP_SCHED case).
+	 * runnable_load_avg is the sum of the load_avg_contrib of the
+	 * sched_entities on the rq.
+	 * blocked_load_avg is similar to runnable_load_avg except that its
+	 * the blocked sched_entities on the rq.
+	 * utilization_load_avg is the sum of the average running time of the
+	 * sched_entities on the rq.
 	 */
-	unsigned long runnable_load_avg, blocked_load_avg;
+	unsigned long runnable_load_avg, blocked_load_avg, utilization_load_avg;
 	atomic64_t decay_counter;
 	u64 last_decay;
 	atomic_long_t removed_load;
-- 
1.9.1

