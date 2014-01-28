Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457AbaA1Rdy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 12:33:54 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60572 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357AbaA1Rds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 12:33:48 -0500
Message-Id: <20140128171948.422404759@infradead.org>
User-Agent: quilt/0.60-1
Date: Tue, 28 Jan 2014 18:16:43 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, daniel.lezcano@linaro.org, pjt@google.com,
        bsegall@google.com, Steven Rostedt <rostedt@goodmis.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 9/9] sched: Push down pre_schedule() and idle_balance()
References: <20140128171634.974847076@infradead.org>
Content-Disposition: inline; filename=peter_zijlstra-sched-clean_up_idle_task_smp_logic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch both merged idle_balance() and pre_schedule() and pushes
both of them into pick_next_task().

Conceptually pre_schedule() and idle_balance() are rather similar,
both are used to pull more work onto the current CPU.

We cannot however first move idle_balance() into pre_schedule_fair()
since there is no guarantee the last runnable task is a fair task, and
thus we would miss newidle balances.

Similarly, the dl and rt pre_schedule calls must be ran before
idle_balance() since their respective tasks have higher priority and
it would not do to delay their execution searching for less important
tasks first.

However, by noticing that pick_next_tasks() already traverses the
sched_class hierarchy in the right order, we can get the right
behaviour and do away with both calls.

We must however change the special case optimization to also require
that prev is of sched_class_fair, otherwise we can miss doing a dl or
rt pull where we needed one.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/core.c      |   26 ++------------------------
 kernel/sched/deadline.c  |   15 +++++++--------
 kernel/sched/fair.c      |   24 ++++++++++++++++++++----
 kernel/sched/idle_task.c |   12 +++++-------
 kernel/sched/rt.c        |   16 ++++++++--------
 kernel/sched/sched.h     |    1 -
 6 files changed, 42 insertions(+), 52 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2146,13 +2146,6 @@ static void finish_task_switch(struct rq
 
 #ifdef CONFIG_SMP
 
-/* assumes rq->lock is held */
-static inline void pre_schedule(struct rq *rq, struct task_struct *prev)
-{
-	if (prev->sched_class->pre_schedule)
-		prev->sched_class->pre_schedule(rq, prev);
-}
-
 /* rq->lock is NOT held, but preemption is disabled */
 static inline void post_schedule(struct rq *rq)
 {
@@ -2170,10 +2163,6 @@ static inline void post_schedule(struct
 
 #else
 
-static inline void pre_schedule(struct rq *rq, struct task_struct *p)
-{
-}
-
 static inline void post_schedule(struct rq *rq)
 {
 }
@@ -2569,7 +2558,8 @@ pick_next_task(struct rq *rq, struct tas
 	 * Optimization: we know that if all tasks are in
 	 * the fair class we can call that function directly:
 	 */
-	if (likely(rq->nr_running == rq->cfs.h_nr_running)) {
+	if (likely(prev->sched_class == &fair_sched_class &&
+		   rq->nr_running == rq->cfs.h_nr_running)) {
 		p = fair_sched_class.pick_next_task(rq, prev);
 		if (likely(p))
 			return p;
@@ -2672,18 +2662,6 @@ static void __sched __schedule(void)
 		switch_count = &prev->nvcsw;
 	}
 
-	pre_schedule(rq, prev);
-
-	if (unlikely(!rq->nr_running)) {
-		/*
-		 * We must set idle_stamp _before_ calling idle_balance(), such
-		 * that we measure the duration of idle_balance() as idle time.
-		 */
-		rq->idle_stamp = rq_clock(rq);
-		if (idle_balance(rq))
-			rq->idle_stamp = 0;
-	}
-
 	if (prev->on_rq || rq->skip_clock_update < 0)
 		update_rq_clock(rq);
 
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -989,6 +989,8 @@ static struct sched_dl_entity *pick_next
 	return rb_entry(left, struct sched_dl_entity, rb_node);
 }
 
+static int pull_dl_task(struct rq *this_rq);
+
 struct task_struct *pick_next_task_dl(struct rq *rq, struct task_struct *prev)
 {
 	struct sched_dl_entity *dl_se;
@@ -997,6 +999,11 @@ struct task_struct *pick_next_task_dl(st
 
 	dl_rq = &rq->dl;
 
+#ifdef CONFIG_SMP
+	if (dl_task(prev))
+		pull_dl_task(rq);
+#endif
+
 	if (unlikely(!dl_rq->dl_nr_running))
 		return NULL;
 
@@ -1427,13 +1434,6 @@ static int pull_dl_task(struct rq *this_
 	return ret;
 }
 
-static void pre_schedule_dl(struct rq *rq, struct task_struct *prev)
-{
-	/* Try to pull other tasks here */
-	if (dl_task(prev))
-		pull_dl_task(rq);
-}
-
 static void post_schedule_dl(struct rq *rq)
 {
 	push_dl_tasks(rq);
@@ -1626,7 +1626,6 @@ const struct sched_class dl_sched_class
 	.set_cpus_allowed       = set_cpus_allowed_dl,
 	.rq_online              = rq_online_dl,
 	.rq_offline             = rq_offline_dl,
-	.pre_schedule		= pre_schedule_dl,
 	.post_schedule		= post_schedule_dl,
 	.task_woken		= task_woken_dl,
 #endif
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2581,7 +2581,8 @@ void idle_exit_fair(struct rq *this_rq)
 	update_rq_runnable_avg(this_rq, 0);
 }
 
-#else
+#else /* CONFIG_SMP */
+
 static inline void update_entity_load_avg(struct sched_entity *se,
 					  int update_cfs_rq) {}
 static inline void update_rq_runnable_avg(struct rq *rq, int runnable) {}
@@ -2593,7 +2594,7 @@ static inline void dequeue_entity_load_a
 					   int sleep) {}
 static inline void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq,
 					      int force_update) {}
-#endif
+#endif /* CONFIG_SMP */
 
 static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
@@ -4686,9 +4687,10 @@ pick_next_task_fair(struct rq *rq, struc
 	struct sched_entity *se;
 	struct task_struct *p;
 
+again:
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	if (!cfs_rq->nr_running)
-		return NULL;
+		goto idle;
 
 	if (prev->sched_class != &fair_sched_class)
 		goto simple;
@@ -4764,7 +4766,7 @@ pick_next_task_fair(struct rq *rq, struc
 #endif
 
 	if (!cfs_rq->nr_running)
-		return NULL;
+		goto idle;
 
 	prev->sched_class->put_prev_task(rq, prev);
 
@@ -4780,6 +4782,20 @@ pick_next_task_fair(struct rq *rq, struc
 		hrtick_start_fair(rq, p);
 
 	return p;
+
+idle:
+	idle_exit_fair(rq);
+	/*
+	 * We must set idle_stamp _before_ calling idle_balance(), such that we
+	 * measure the duration of idle_balance() as idle time.
+	 */
+	rq->idle_stamp = rq_clock(rq);
+	if (idle_balance(rq)) { /* drops rq->lock */
+		rq->idle_stamp = 0;
+		goto again;
+	}
+
+	return NULL;
 }
 
 /*
--- a/kernel/sched/idle_task.c
+++ b/kernel/sched/idle_task.c
@@ -13,13 +13,8 @@ select_task_rq_idle(struct task_struct *
 {
 	return task_cpu(p); /* IDLE tasks as never migrated */
 }
-
-static void pre_schedule_idle(struct rq *rq, struct task_struct *prev)
-{
-	idle_exit_fair(rq);
-	rq_last_tick_reset(rq);
-}
 #endif /* CONFIG_SMP */
+
 /*
  * Idle tasks are unconditionally rescheduled:
  */
@@ -55,6 +50,10 @@ dequeue_task_idle(struct rq *rq, struct
 
 static void put_prev_task_idle(struct rq *rq, struct task_struct *prev)
 {
+#ifdef CONFIG_SMP
+	idle_exit_fair(rq);
+	rq_last_tick_reset(rq);
+#endif
 }
 
 static void task_tick_idle(struct rq *rq, struct task_struct *curr, int queued)
@@ -98,7 +97,6 @@ const struct sched_class idle_sched_clas
 
 #ifdef CONFIG_SMP
 	.select_task_rq		= select_task_rq_idle,
-	.pre_schedule		= pre_schedule_idle,
 #endif
 
 	.set_curr_task          = set_curr_task_idle,
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1324,12 +1324,20 @@ static struct task_struct *_pick_next_ta
 	return p;
 }
 
+static int pull_rt_task(struct rq *this_rq);
+
 static struct task_struct *
 pick_next_task_rt(struct rq *rq, struct task_struct *prev)
 {
 	struct task_struct *p;
 	struct rt_rq *rt_rq = &rq->rt;
 
+#ifdef CONFIG_SMP
+	/* Try to pull RT tasks here if we lower this rq's prio */
+	if (rq->rt.highest_prio.curr > prev->prio)
+		pull_rt_task(rq);
+#endif
+
 	if (!rt_rq->rt_nr_running)
 		return NULL;
 
@@ -1720,13 +1728,6 @@ static int pull_rt_task(struct rq *this_
 	return ret;
 }
 
-static void pre_schedule_rt(struct rq *rq, struct task_struct *prev)
-{
-	/* Try to pull RT tasks here if we lower this rq's prio */
-	if (rq->rt.highest_prio.curr > prev->prio)
-		pull_rt_task(rq);
-}
-
 static void post_schedule_rt(struct rq *rq)
 {
 	push_rt_tasks(rq);
@@ -2003,7 +2004,6 @@ const struct sched_class rt_sched_class
 	.set_cpus_allowed       = set_cpus_allowed_rt,
 	.rq_online              = rq_online_rt,
 	.rq_offline             = rq_offline_rt,
-	.pre_schedule		= pre_schedule_rt,
 	.post_schedule		= post_schedule_rt,
 	.task_woken		= task_woken_rt,
 	.switched_from		= switched_from_rt,
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1136,7 +1136,6 @@ struct sched_class {
 	int  (*select_task_rq)(struct task_struct *p, int task_cpu, int sd_flag, int flags);
 	void (*migrate_task_rq)(struct task_struct *p, int next_cpu);
 
-	void (*pre_schedule) (struct rq *this_rq, struct task_struct *task);
 	void (*post_schedule) (struct rq *this_rq);
 	void (*task_waking) (struct task_struct *task);
 	void (*task_woken) (struct rq *this_rq, struct task_struct *task);


