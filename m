Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbaA1RfI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 12:35:08 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60578 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377AbaA1Rdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 12:33:49 -0500
Message-Id: <20140128171948.149077289@infradead.org>
User-Agent: quilt/0.60-1
Date: Tue, 28 Jan 2014 18:16:39 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, daniel.lezcano@linaro.org, pjt@google.com,
        bsegall@google.com, Steven Rostedt <rostedt@goodmis.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 5/9] sched: Push put_prev_task() into pick_next_task()
References: <20140128171634.974847076@infradead.org>
Content-Disposition: inline; filename=peter_zijlstra-sched-optimize_cgroup_pick_next_task_fair_2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to avoid having to do put/set on a whole cgroup hierarchy
when we context switch, push the put into pick_next_task() so that
both operations are in the same function. Further changes then allow
us to possibly optimize away redundant work.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/core.c      |   21 ++++++++-------------
 kernel/sched/deadline.c  |    4 +++-
 kernel/sched/fair.c      |    5 ++++-
 kernel/sched/idle_task.c |    5 ++++-
 kernel/sched/rt.c        |   26 +++++++++++++++-----------
 kernel/sched/sched.h     |    8 +++++++-
 kernel/sched/stop_task.c |   14 ++++++++------
 7 files changed, 49 insertions(+), 34 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2556,18 +2556,11 @@ static inline void schedule_debug(struct
 	schedstat_inc(this_rq(), sched_count);
 }
 
-static void put_prev_task(struct rq *rq, struct task_struct *prev)
-{
-	if (prev->on_rq || rq->skip_clock_update < 0)
-		update_rq_clock(rq);
-	prev->sched_class->put_prev_task(rq, prev);
-}
-
 /*
  * Pick up the highest-prio task:
  */
 static inline struct task_struct *
-pick_next_task(struct rq *rq)
+pick_next_task(struct rq *rq, struct task_struct *prev)
 {
 	const struct sched_class *class;
 	struct task_struct *p;
@@ -2577,13 +2570,13 @@ pick_next_task(struct rq *rq)
 	 * the fair class we can call that function directly:
 	 */
 	if (likely(rq->nr_running == rq->cfs.h_nr_running)) {
-		p = fair_sched_class.pick_next_task(rq);
+		p = fair_sched_class.pick_next_task(rq, prev);
 		if (likely(p))
 			return p;
 	}
 
 	for_each_class(class) {
-		p = class->pick_next_task(rq);
+		p = class->pick_next_task(rq, prev);
 		if (p)
 			return p;
 	}
@@ -2691,8 +2684,10 @@ static void __sched __schedule(void)
 			rq->idle_stamp = 0;
 	}
 
-	put_prev_task(rq, prev);
-	next = pick_next_task(rq);
+	if (prev->on_rq || rq->skip_clock_update < 0)
+		update_rq_clock(rq);
+
+	next = pick_next_task(rq, prev);
 	clear_tsk_need_resched(prev);
 	clear_preempt_need_resched();
 	rq->skip_clock_update = 0;
@@ -4734,7 +4729,7 @@ static void migrate_tasks(unsigned int d
 		if (rq->nr_running == 1)
 			break;
 
-		next = pick_next_task(rq);
+		next = pick_next_task(rq, NULL);
 		BUG_ON(!next);
 		next->sched_class->put_prev_task(rq, next);
 
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -989,7 +989,7 @@ static struct sched_dl_entity *pick_next
 	return rb_entry(left, struct sched_dl_entity, rb_node);
 }
 
-struct task_struct *pick_next_task_dl(struct rq *rq)
+struct task_struct *pick_next_task_dl(struct rq *rq, struct task_struct *prev)
 {
 	struct sched_dl_entity *dl_se;
 	struct task_struct *p;
@@ -1000,6 +1000,8 @@ struct task_struct *pick_next_task_dl(st
 	if (unlikely(!dl_rq->dl_nr_running))
 		return NULL;
 
+	prev->sched_class->put_prev_task(rq, prev);
+
 	dl_se = pick_next_dl_entity(rq, dl_rq);
 	BUG_ON(!dl_se);
 
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4659,7 +4659,8 @@ static void check_preempt_wakeup(struct
 		set_last_buddy(se);
 }
 
-static struct task_struct *pick_next_task_fair(struct rq *rq)
+static struct task_struct *
+pick_next_task_fair(struct rq *rq, struct task_struct *prev)
 {
 	struct task_struct *p;
 	struct cfs_rq *cfs_rq = &rq->cfs;
@@ -4668,6 +4669,8 @@ static struct task_struct *pick_next_tas
 	if (!cfs_rq->nr_running)
 		return NULL;
 
+	prev->sched_class->put_prev_task(rq, prev);
+
 	do {
 		se = pick_next_entity(cfs_rq);
 		set_next_entity(cfs_rq, se);
--- a/kernel/sched/idle_task.c
+++ b/kernel/sched/idle_task.c
@@ -33,8 +33,11 @@ static void check_preempt_curr_idle(stru
 	resched_task(rq->idle);
 }
 
-static struct task_struct *pick_next_task_idle(struct rq *rq)
+static struct task_struct *
+pick_next_task_idle(struct rq *rq, struct task_struct *prev)
 {
+	prev->sched_class->put_prev_task(rq, prev);
+
 	schedstat_inc(rq, sched_goidle);
 #ifdef CONFIG_SMP
 	/* Trigger the post schedule to do an idle_enter for CFS */
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1310,15 +1310,7 @@ static struct task_struct *_pick_next_ta
 {
 	struct sched_rt_entity *rt_se;
 	struct task_struct *p;
-	struct rt_rq *rt_rq;
-
-	rt_rq = &rq->rt;
-
-	if (!rt_rq->rt_nr_running)
-		return NULL;
-
-	if (rt_rq_throttled(rt_rq))
-		return NULL;
+	struct rt_rq *rt_rq  = &rq->rt;
 
 	do {
 		rt_se = pick_next_rt_entity(rq, rt_rq);
@@ -1332,9 +1324,21 @@ static struct task_struct *_pick_next_ta
 	return p;
 }
 
-static struct task_struct *pick_next_task_rt(struct rq *rq)
+static struct task_struct *
+pick_next_task_rt(struct rq *rq, struct task_struct *prev)
 {
-	struct task_struct *p = _pick_next_task_rt(rq);
+	struct task_struct *p;
+	struct rt_rq *rt_rq = &rq->rt;
+
+	if (!rt_rq->rt_nr_running)
+		return NULL;
+
+	if (rt_rq_throttled(rt_rq))
+		return NULL;
+
+	prev->sched_class->put_prev_task(rq, prev);
+
+	p = _pick_next_task_rt(rq);
 
 	/* The running task is never eligible for pushing */
 	if (p)
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1123,7 +1123,13 @@ struct sched_class {
 
 	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p, int flags);
 
-	struct task_struct * (*pick_next_task) (struct rq *rq);
+	/*
+	 * It is the responsibility of the pick_next_task() method that will
+	 * return the next task to call put_prev_task() on the @prev task or
+	 * something equivalent.
+	 */
+	struct task_struct * (*pick_next_task) (struct rq *rq,
+						struct task_struct *prev);
 	void (*put_prev_task) (struct rq *rq, struct task_struct *p);
 
 #ifdef CONFIG_SMP
--- a/kernel/sched/stop_task.c
+++ b/kernel/sched/stop_task.c
@@ -23,16 +23,18 @@ check_preempt_curr_stop(struct rq *rq, s
 	/* we're never preempted */
 }
 
-static struct task_struct *pick_next_task_stop(struct rq *rq)
+static struct task_struct *
+pick_next_task_stop(struct rq *rq, struct task_struct *prev)
 {
 	struct task_struct *stop = rq->stop;
 
-	if (stop && stop->on_rq) {
-		stop->se.exec_start = rq_clock_task(rq);
-		return stop;
-	}
+	if (!stop || !stop->on_rq)
+		return NULL;
 
-	return NULL;
+	prev->sched_class->put_prev_task(rq, prev);
+	stop->se.exec_start = rq_clock_task(rq);
+
+	return stop;
 }
 
 static void


