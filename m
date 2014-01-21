Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417AbaAUL35 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 06:29:57 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51882 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265AbaAUL30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 06:29:26 -0500
Message-Id: <20140121112258.586781016@infradead.org>
User-Agent: quilt/0.60-1
Date: Tue, 21 Jan 2014 12:18:00 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, daniel.lezcano@linaro.org, pjt@google.com,
        bsegall@google.com, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 6/9] sched: Push put_prev_task() into pick_next_task()
References: <20140121111754.580142558@infradead.org>
Content-Disposition: inline; filename=peter_zijlstra-sched-optimize_cgroup_pick_next_task_fair_2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to avoid having to do put/set on a whole cgroup hierarchy
when we context switch, push the put into pick_next_task() so that
both operations are in the same function. Further changes then allow
us to possibly optimize away redundant work.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1328936700.2476.17.camel@laptop
---
 kernel/sched/core.c      |   21 ++++++++-------------
 kernel/sched/deadline.c  |    2 +-
 kernel/sched/fair.c      |    6 +++++-
 kernel/sched/idle_task.c |    6 +++++-
 kernel/sched/rt.c        |   27 ++++++++++++++++-----------
 kernel/sched/sched.h     |    8 +++++++-
 kernel/sched/stop_task.c |    5 ++++-
 7 files changed, 46 insertions(+), 29 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2554,18 +2554,11 @@ static inline void schedule_debug(struct
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
@@ -2575,13 +2568,13 @@ pick_next_task(struct rq *rq)
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
@@ -2682,8 +2675,10 @@ static void __sched __schedule(void)
 	if (unlikely(!rq->nr_running))
 		rq->idle_stamp = idle_balance(rq) ? 0 : rq_clock(rq);
 
-	put_prev_task(rq, prev);
-	next = pick_next_task(rq);
+	if (prev->on_rq || rq->skip_clock_update < 0)
+		update_rq_clock(rq);
+
+	next = pick_next_task(rq, prev);
 	clear_tsk_need_resched(prev);
 	clear_preempt_need_resched();
 	rq->skip_clock_update = 0;
@@ -4725,7 +4720,7 @@ static void migrate_tasks(unsigned int d
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
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4484,7 +4484,8 @@ static void check_preempt_wakeup(struct
 		set_last_buddy(se);
 }
 
-static struct task_struct *pick_next_task_fair(struct rq *rq)
+static struct task_struct *
+pick_next_task_fair(struct rq *rq, struct task_struct *prev)
 {
 	struct task_struct *p;
 	struct cfs_rq *cfs_rq = &rq->cfs;
@@ -4493,6 +4494,9 @@ static struct task_struct *pick_next_tas
 	if (!cfs_rq->nr_running)
 		return NULL;
 
+	if (prev)
+		prev->sched_class->put_prev_task(rq, prev);
+
 	do {
 		se = pick_next_entity(cfs_rq);
 		set_next_entity(cfs_rq, se);
--- a/kernel/sched/idle_task.c
+++ b/kernel/sched/idle_task.c
@@ -23,8 +23,12 @@ static void check_preempt_curr_idle(stru
 	resched_task(rq->idle);
 }
 
-static struct task_struct *pick_next_task_idle(struct rq *rq)
+static struct task_struct *
+pick_next_task_idle(struct rq *rq, struct task_struct *prev)
 {
+	if (prev)
+		prev->sched_class->put_prev_task(rq, prev);
+
 	schedstat_inc(rq, sched_goidle);
 #ifdef CONFIG_SMP
 	idle_enter_fair(rq);
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
@@ -1332,9 +1324,22 @@ static struct task_struct *_pick_next_ta
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
+	if (prev)
+		prev->sched_class->put_prev_task(rq, prev);
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
@@ -23,11 +23,14 @@ check_preempt_curr_stop(struct rq *rq, s
 	/* we're never preempted */
 }
 
-static struct task_struct *pick_next_task_stop(struct rq *rq)
+static struct task_struct *
+pick_next_task_stop(struct rq *rq, struct task_struct *prev)
 {
 	struct task_struct *stop = rq->stop;
 
 	if (stop && stop->on_rq) {
+		if (prev)
+			prev->sched_class->put_prev_task(rq, prev);
 		stop->se.exec_start = rq_clock_task(rq);
 		return stop;
 	}


