Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbaBKMQz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 07:16:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46493 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbaBKMQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 07:16:53 -0500
Date: Tue, 11 Feb 2014 04:16:24 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-606dba2e289446600a0b68422ed2019af5355c12@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1328936700.2476.17.camel@laptop>
References: <1328936700.2476.17.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Push put_prev_task() into pick_next_task(
 )
Git-Commit-ID: 606dba2e289446600a0b68422ed2019af5355c12
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 11 Feb 2014 04:16:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  606dba2e289446600a0b68422ed2019af5355c12
Gitweb:     http://git.kernel.org/tip/606dba2e289446600a0b68422ed2019af5355c12
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Sat, 11 Feb 2012 06:05:00 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 10 Feb 2014 16:17:13 +0100

sched: Push put_prev_task() into pick_next_task()

In order to avoid having to do put/set on a whole cgroup hierarchy
when we context switch, push the put into pick_next_task() so that
both operations are in the same function. Further changes then allow
us to possibly optimize away redundant work.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1328936700.2476.17.camel@laptop
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c      | 21 ++++++++-------------
 kernel/sched/deadline.c  |  5 ++++-
 kernel/sched/fair.c      |  6 +++++-
 kernel/sched/idle_task.c |  6 +++++-
 kernel/sched/rt.c        | 27 ++++++++++++++++-----------
 kernel/sched/sched.h     |  8 +++++++-
 kernel/sched/stop_task.c | 16 ++++++++++------
 7 files changed, 55 insertions(+), 34 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 417cf65..dedb5f0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2579,18 +2579,11 @@ static inline void schedule_debug(struct task_struct *prev)
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
@@ -2600,13 +2593,13 @@ pick_next_task(struct rq *rq)
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
@@ -2714,8 +2707,10 @@ need_resched:
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
@@ -4748,7 +4743,7 @@ static void migrate_tasks(unsigned int dead_cpu)
 		if (rq->nr_running == 1)
 			break;
 
-		next = pick_next_task(rq);
+		next = pick_next_task(rq, NULL);
 		BUG_ON(!next);
 		next->sched_class->put_prev_task(rq, next);
 
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index b5700bc..50797d5 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -990,7 +990,7 @@ static struct sched_dl_entity *pick_next_dl_entity(struct rq *rq,
 	return rb_entry(left, struct sched_dl_entity, rb_node);
 }
 
-struct task_struct *pick_next_task_dl(struct rq *rq)
+struct task_struct *pick_next_task_dl(struct rq *rq, struct task_struct *prev)
 {
 	struct sched_dl_entity *dl_se;
 	struct task_struct *p;
@@ -1001,6 +1001,9 @@ struct task_struct *pick_next_task_dl(struct rq *rq)
 	if (unlikely(!dl_rq->dl_nr_running))
 		return NULL;
 
+	if (prev)
+		prev->sched_class->put_prev_task(rq, prev);
+
 	dl_se = pick_next_dl_entity(rq, dl_rq);
 	BUG_ON(!dl_se);
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 748a7ac..c4bb0ac 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4655,7 +4655,8 @@ preempt:
 		set_last_buddy(se);
 }
 
-static struct task_struct *pick_next_task_fair(struct rq *rq)
+static struct task_struct *
+pick_next_task_fair(struct rq *rq, struct task_struct *prev)
 {
 	struct task_struct *p;
 	struct cfs_rq *cfs_rq = &rq->cfs;
@@ -4664,6 +4665,9 @@ static struct task_struct *pick_next_task_fair(struct rq *rq)
 	if (!cfs_rq->nr_running)
 		return NULL;
 
+	if (prev)
+		prev->sched_class->put_prev_task(rq, prev);
+
 	do {
 		se = pick_next_entity(cfs_rq);
 		set_next_entity(cfs_rq, se);
diff --git a/kernel/sched/idle_task.c b/kernel/sched/idle_task.c
index 516c3d9..e5c922a 100644
--- a/kernel/sched/idle_task.c
+++ b/kernel/sched/idle_task.c
@@ -33,8 +33,12 @@ static void check_preempt_curr_idle(struct rq *rq, struct task_struct *p, int fl
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
 	/* Trigger the post schedule to do an idle_enter for CFS */
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index a2740b7..a15ca1c 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1310,15 +1310,7 @@ static struct task_struct *_pick_next_task_rt(struct rq *rq)
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
@@ -1332,9 +1324,22 @@ static struct task_struct *_pick_next_task_rt(struct rq *rq)
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
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index bb89991..c534cf4 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1105,7 +1105,13 @@ struct sched_class {
 
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
diff --git a/kernel/sched/stop_task.c b/kernel/sched/stop_task.c
index fdb6bb0..a4147c9 100644
--- a/kernel/sched/stop_task.c
+++ b/kernel/sched/stop_task.c
@@ -23,16 +23,20 @@ check_preempt_curr_stop(struct rq *rq, struct task_struct *p, int flags)
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
+	if (prev)
+		prev->sched_class->put_prev_task(rq, prev);
+
+	stop->se.exec_start = rq_clock_task(rq);
+
+	return stop;
 }
 
 static void
