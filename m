Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbaAMPzQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:55:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60779 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbaAMPzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:55:05 -0500
Date: Mon, 13 Jan 2014 07:54:27 -0800
From: tip-bot for Dario Faggioli <tipbot@zytor.com>
Message-ID: <tip-2d3d891d3344159d5b452a645e355bbe29591e8b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, raistlin@linux.it, tglx@linutronix.de,
        juri.lelli@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, raistlin@linux.it,
        juri.lelli@gmail.com
In-Reply-To: <1383831828-15501-11-git-send-email-juri.lelli@gmail.com>
References: <1383831828-15501-11-git-send-email-juri.lelli@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/deadline:
  Add SCHED_DEADLINE inheritance logic
Git-Commit-ID: 2d3d891d3344159d5b452a645e355bbe29591e8b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 13 Jan 2014 07:54:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2d3d891d3344159d5b452a645e355bbe29591e8b
Gitweb:     http://git.kernel.org/tip/2d3d891d3344159d5b452a645e355bbe29591e8b
Author:     Dario Faggioli <raistlin@linux.it>
AuthorDate: Thu, 7 Nov 2013 14:43:44 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 13 Jan 2014 13:42:56 +0100

sched/deadline: Add SCHED_DEADLINE inheritance logic

Some method to deal with rt-mutexes and make sched_dl interact with
the current PI-coded is needed, raising all but trivial issues, that
needs (according to us) to be solved with some restructuring of
the pi-code (i.e., going toward a proxy execution-ish implementation).

This is under development, in the meanwhile, as a temporary solution,
what this commits does is:

 - ensure a pi-lock owner with waiters is never throttled down. Instead,
   when it runs out of runtime, it immediately gets replenished and it's
   deadline is postponed;

 - the scheduling parameters (relative deadline and default runtime)
   used for that replenishments --during the whole period it holds the
   pi-lock-- are the ones of the waiting task with earliest deadline.

Acting this way, we provide some kind of boosting to the lock-owner,
still by using the existing (actually, slightly modified by the previous
commit) pi-architecture.

We would stress the fact that this is only a surely needed, all but
clean solution to the problem. In the end it's only a way to re-start
discussion within the community. So, as always, comments, ideas, rants,
etc.. are welcome! :-)

Signed-off-by: Dario Faggioli <raistlin@linux.it>
Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
[ Added !RT_MUTEXES build fix. ]
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1383831828-15501-11-git-send-email-juri.lelli@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h             |  8 +++-
 include/linux/sched/rt.h          |  5 +++
 kernel/fork.c                     |  1 +
 kernel/locking/rtmutex.c          | 31 +++++++++----
 kernel/locking/rtmutex_common.h   |  1 +
 kernel/sched/core.c               | 36 +++++++++++++---
 kernel/sched/deadline.c           | 91 +++++++++++++++++++++++----------------
 kernel/sched/sched.h              | 14 ++++++
 kernel/trace/trace_sched_wakeup.c |  1 +
 9 files changed, 134 insertions(+), 54 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 9ea1501..13c53a9 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1124,8 +1124,12 @@ struct sched_dl_entity {
 	 * @dl_new tells if a new instance arrived. If so we must
 	 * start executing it with full runtime and reset its absolute
 	 * deadline;
+	 *
+	 * @dl_boosted tells if we are boosted due to DI. If so we are
+	 * outside bandwidth enforcement mechanism (but only until we
+	 * exit the critical section).
 	 */
-	int dl_throttled, dl_new;
+	int dl_throttled, dl_new, dl_boosted;
 
 	/*
 	 * Bandwidth enforcement timer. Each -deadline task has its
@@ -1359,6 +1363,8 @@ struct task_struct {
 	struct rb_node *pi_waiters_leftmost;
 	/* Deadlock detection and priority inheritance handling */
 	struct rt_mutex_waiter *pi_blocked_on;
+	/* Top pi_waiters task */
+	struct task_struct *pi_top_task;
 #endif
 
 #ifdef CONFIG_DEBUG_MUTEXES
diff --git a/include/linux/sched/rt.h b/include/linux/sched/rt.h
index 440434d..34e4ebe 100644
--- a/include/linux/sched/rt.h
+++ b/include/linux/sched/rt.h
@@ -35,6 +35,7 @@ static inline int rt_task(struct task_struct *p)
 #ifdef CONFIG_RT_MUTEXES
 extern int rt_mutex_getprio(struct task_struct *p);
 extern void rt_mutex_setprio(struct task_struct *p, int prio);
+extern struct task_struct *rt_mutex_get_top_task(struct task_struct *task);
 extern void rt_mutex_adjust_pi(struct task_struct *p);
 static inline bool tsk_is_pi_blocked(struct task_struct *tsk)
 {
@@ -45,6 +46,10 @@ static inline int rt_mutex_getprio(struct task_struct *p)
 {
 	return p->normal_prio;
 }
+static inline struct task_struct *rt_mutex_get_top_task(struct task_struct *task)
+{
+	return NULL;
+}
 # define rt_mutex_adjust_pi(p)		do { } while (0)
 static inline bool tsk_is_pi_blocked(struct task_struct *tsk)
 {
diff --git a/kernel/fork.c b/kernel/fork.c
index 7049ae5..01b450a 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1090,6 +1090,7 @@ static void rt_mutex_init_task(struct task_struct *p)
 	p->pi_waiters = RB_ROOT;
 	p->pi_waiters_leftmost = NULL;
 	p->pi_blocked_on = NULL;
+	p->pi_top_task = NULL;
 #endif
 }
 
diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index 3bf0aa6..2e960a2 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -96,13 +96,16 @@ static inline int
 rt_mutex_waiter_less(struct rt_mutex_waiter *left,
 		     struct rt_mutex_waiter *right)
 {
-	if (left->task->prio < right->task->prio)
+	if (left->prio < right->prio)
 		return 1;
 
 	/*
-	 * If both tasks are dl_task(), we check their deadlines.
+	 * If both waiters have dl_prio(), we check the deadlines of the
+	 * associated tasks.
+	 * If left waiter has a dl_prio(), and we didn't return 1 above,
+	 * then right waiter has a dl_prio() too.
 	 */
-	if (dl_prio(left->task->prio) && dl_prio(right->task->prio))
+	if (dl_prio(left->prio))
 		return (left->task->dl.deadline < right->task->dl.deadline);
 
 	return 0;
@@ -197,10 +200,18 @@ int rt_mutex_getprio(struct task_struct *task)
 	if (likely(!task_has_pi_waiters(task)))
 		return task->normal_prio;
 
-	return min(task_top_pi_waiter(task)->task->prio,
+	return min(task_top_pi_waiter(task)->prio,
 		   task->normal_prio);
 }
 
+struct task_struct *rt_mutex_get_top_task(struct task_struct *task)
+{
+	if (likely(!task_has_pi_waiters(task)))
+		return NULL;
+
+	return task_top_pi_waiter(task)->task;
+}
+
 /*
  * Adjust the priority of a task, after its pi_waiters got modified.
  *
@@ -210,7 +221,7 @@ static void __rt_mutex_adjust_prio(struct task_struct *task)
 {
 	int prio = rt_mutex_getprio(task);
 
-	if (task->prio != prio)
+	if (task->prio != prio || dl_prio(prio))
 		rt_mutex_setprio(task, prio);
 }
 
@@ -328,7 +339,7 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 	 * When deadlock detection is off then we check, if further
 	 * priority adjustment is necessary.
 	 */
-	if (!detect_deadlock && waiter->task->prio == task->prio)
+	if (!detect_deadlock && waiter->prio == task->prio)
 		goto out_unlock_pi;
 
 	lock = waiter->lock;
@@ -350,7 +361,7 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 
 	/* Requeue the waiter */
 	rt_mutex_dequeue(lock, waiter);
-	waiter->task->prio = task->prio;
+	waiter->prio = task->prio;
 	rt_mutex_enqueue(lock, waiter);
 
 	/* Release the task */
@@ -448,7 +459,7 @@ static int try_to_take_rt_mutex(struct rt_mutex *lock, struct task_struct *task,
 	 * 3) it is top waiter
 	 */
 	if (rt_mutex_has_waiters(lock)) {
-		if (task->prio >= rt_mutex_top_waiter(lock)->task->prio) {
+		if (task->prio >= rt_mutex_top_waiter(lock)->prio) {
 			if (!waiter || waiter != rt_mutex_top_waiter(lock))
 				return 0;
 		}
@@ -508,6 +519,7 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 	__rt_mutex_adjust_prio(task);
 	waiter->task = task;
 	waiter->lock = lock;
+	waiter->prio = task->prio;
 
 	/* Get the top priority waiter on the lock */
 	if (rt_mutex_has_waiters(lock))
@@ -653,7 +665,8 @@ void rt_mutex_adjust_pi(struct task_struct *task)
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
 
 	waiter = task->pi_blocked_on;
-	if (!waiter || waiter->task->prio == task->prio) {
+	if (!waiter || (waiter->prio == task->prio &&
+			!dl_prio(task->prio))) {
 		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
 		return;
 	}
diff --git a/kernel/locking/rtmutex_common.h b/kernel/locking/rtmutex_common.h
index b65442f..7431a9c 100644
--- a/kernel/locking/rtmutex_common.h
+++ b/kernel/locking/rtmutex_common.h
@@ -54,6 +54,7 @@ struct rt_mutex_waiter {
 	struct pid		*deadlock_task_pid;
 	struct rt_mutex		*deadlock_lock;
 #endif
+	int prio;
 };
 
 /*
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index aebcc70..599ee3b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -947,7 +947,7 @@ static inline void check_class_changed(struct rq *rq, struct task_struct *p,
 		if (prev_class->switched_from)
 			prev_class->switched_from(rq, p);
 		p->sched_class->switched_to(rq, p);
-	} else if (oldprio != p->prio)
+	} else if (oldprio != p->prio || dl_task(p))
 		p->sched_class->prio_changed(rq, p, oldprio);
 }
 
@@ -2781,7 +2781,7 @@ EXPORT_SYMBOL(sleep_on_timeout);
  */
 void rt_mutex_setprio(struct task_struct *p, int prio)
 {
-	int oldprio, on_rq, running;
+	int oldprio, on_rq, running, enqueue_flag = 0;
 	struct rq *rq;
 	const struct sched_class *prev_class;
 
@@ -2808,6 +2808,7 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 	}
 
 	trace_sched_pi_setprio(p, prio);
+	p->pi_top_task = rt_mutex_get_top_task(p);
 	oldprio = p->prio;
 	prev_class = p->sched_class;
 	on_rq = p->on_rq;
@@ -2817,19 +2818,42 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 	if (running)
 		p->sched_class->put_prev_task(rq, p);
 
-	if (dl_prio(prio))
+	/*
+	 * Boosting condition are:
+	 * 1. -rt task is running and holds mutex A
+	 *      --> -dl task blocks on mutex A
+	 *
+	 * 2. -dl task is running and holds mutex A
+	 *      --> -dl task blocks on mutex A and could preempt the
+	 *          running task
+	 */
+	if (dl_prio(prio)) {
+		if (!dl_prio(p->normal_prio) || (p->pi_top_task &&
+			dl_entity_preempt(&p->pi_top_task->dl, &p->dl))) {
+			p->dl.dl_boosted = 1;
+			p->dl.dl_throttled = 0;
+			enqueue_flag = ENQUEUE_REPLENISH;
+		} else
+			p->dl.dl_boosted = 0;
 		p->sched_class = &dl_sched_class;
-	else if (rt_prio(prio))
+	} else if (rt_prio(prio)) {
+		if (dl_prio(oldprio))
+			p->dl.dl_boosted = 0;
+		if (oldprio < prio)
+			enqueue_flag = ENQUEUE_HEAD;
 		p->sched_class = &rt_sched_class;
-	else
+	} else {
+		if (dl_prio(oldprio))
+			p->dl.dl_boosted = 0;
 		p->sched_class = &fair_sched_class;
+	}
 
 	p->prio = prio;
 
 	if (running)
 		p->sched_class->set_curr_task(rq);
 	if (on_rq)
-		enqueue_task(rq, p, oldprio < prio ? ENQUEUE_HEAD : 0);
+		enqueue_task(rq, p, enqueue_flag);
 
 	check_class_changed(rq, p, prev_class, oldprio);
 out_unlock:
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 3958bc5..7f6de43 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -16,20 +16,6 @@
  */
 #include "sched.h"
 
-static inline int dl_time_before(u64 a, u64 b)
-{
-	return (s64)(a - b) < 0;
-}
-
-/*
- * Tells if entity @a should preempt entity @b.
- */
-static inline
-int dl_entity_preempt(struct sched_dl_entity *a, struct sched_dl_entity *b)
-{
-	return dl_time_before(a->deadline, b->deadline);
-}
-
 static inline struct task_struct *dl_task_of(struct sched_dl_entity *dl_se)
 {
 	return container_of(dl_se, struct task_struct, dl);
@@ -242,7 +228,8 @@ static void check_preempt_curr_dl(struct rq *rq, struct task_struct *p,
  * one, and to (try to!) reconcile itself with its own scheduling
  * parameters.
  */
-static inline void setup_new_dl_entity(struct sched_dl_entity *dl_se)
+static inline void setup_new_dl_entity(struct sched_dl_entity *dl_se,
+				       struct sched_dl_entity *pi_se)
 {
 	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
 	struct rq *rq = rq_of_dl_rq(dl_rq);
@@ -254,8 +241,8 @@ static inline void setup_new_dl_entity(struct sched_dl_entity *dl_se)
 	 * future; in fact, we must consider execution overheads (time
 	 * spent on hardirq context, etc.).
 	 */
-	dl_se->deadline = rq_clock(rq) + dl_se->dl_deadline;
-	dl_se->runtime = dl_se->dl_runtime;
+	dl_se->deadline = rq_clock(rq) + pi_se->dl_deadline;
+	dl_se->runtime = pi_se->dl_runtime;
 	dl_se->dl_new = 0;
 }
 
@@ -277,11 +264,23 @@ static inline void setup_new_dl_entity(struct sched_dl_entity *dl_se)
  * could happen are, typically, a entity voluntarily trying to overcome its
  * runtime, or it just underestimated it during sched_setscheduler_ex().
  */
-static void replenish_dl_entity(struct sched_dl_entity *dl_se)
+static void replenish_dl_entity(struct sched_dl_entity *dl_se,
+				struct sched_dl_entity *pi_se)
 {
 	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
 	struct rq *rq = rq_of_dl_rq(dl_rq);
 
+	BUG_ON(pi_se->dl_runtime <= 0);
+
+	/*
+	 * This could be the case for a !-dl task that is boosted.
+	 * Just go with full inherited parameters.
+	 */
+	if (dl_se->dl_deadline == 0) {
+		dl_se->deadline = rq_clock(rq) + pi_se->dl_deadline;
+		dl_se->runtime = pi_se->dl_runtime;
+	}
+
 	/*
 	 * We keep moving the deadline away until we get some
 	 * available runtime for the entity. This ensures correct
@@ -289,8 +288,8 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se)
 	 * arbitrary large.
 	 */
 	while (dl_se->runtime <= 0) {
-		dl_se->deadline += dl_se->dl_period;
-		dl_se->runtime += dl_se->dl_runtime;
+		dl_se->deadline += pi_se->dl_period;
+		dl_se->runtime += pi_se->dl_runtime;
 	}
 
 	/*
@@ -309,8 +308,8 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se)
 			lag_once = true;
 			printk_sched("sched: DL replenish lagged to much\n");
 		}
-		dl_se->deadline = rq_clock(rq) + dl_se->dl_deadline;
-		dl_se->runtime = dl_se->dl_runtime;
+		dl_se->deadline = rq_clock(rq) + pi_se->dl_deadline;
+		dl_se->runtime = pi_se->dl_runtime;
 	}
 }
 
@@ -337,7 +336,8 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se)
  * task with deadline equal to period this is the same of using
  * dl_deadline instead of dl_period in the equation above.
  */
-static bool dl_entity_overflow(struct sched_dl_entity *dl_se, u64 t)
+static bool dl_entity_overflow(struct sched_dl_entity *dl_se,
+			       struct sched_dl_entity *pi_se, u64 t)
 {
 	u64 left, right;
 
@@ -359,8 +359,8 @@ static bool dl_entity_overflow(struct sched_dl_entity *dl_se, u64 t)
 	 * of anything below microseconds resolution is actually fiction
 	 * (but still we want to give the user that illusion >;).
 	 */
-	left = (dl_se->dl_period >> 10) * (dl_se->runtime >> 10);
-	right = ((dl_se->deadline - t) >> 10) * (dl_se->dl_runtime >> 10);
+	left = (pi_se->dl_period >> 10) * (dl_se->runtime >> 10);
+	right = ((dl_se->deadline - t) >> 10) * (pi_se->dl_runtime >> 10);
 
 	return dl_time_before(right, left);
 }
@@ -374,7 +374,8 @@ static bool dl_entity_overflow(struct sched_dl_entity *dl_se, u64 t)
  *  - using the remaining runtime with the current deadline would make
  *    the entity exceed its bandwidth.
  */
-static void update_dl_entity(struct sched_dl_entity *dl_se)
+static void update_dl_entity(struct sched_dl_entity *dl_se,
+			     struct sched_dl_entity *pi_se)
 {
 	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
 	struct rq *rq = rq_of_dl_rq(dl_rq);
@@ -384,14 +385,14 @@ static void update_dl_entity(struct sched_dl_entity *dl_se)
 	 * the actual scheduling parameters have to be "renewed".
 	 */
 	if (dl_se->dl_new) {
-		setup_new_dl_entity(dl_se);
+		setup_new_dl_entity(dl_se, pi_se);
 		return;
 	}
 
 	if (dl_time_before(dl_se->deadline, rq_clock(rq)) ||
-	    dl_entity_overflow(dl_se, rq_clock(rq))) {
-		dl_se->deadline = rq_clock(rq) + dl_se->dl_deadline;
-		dl_se->runtime = dl_se->dl_runtime;
+	    dl_entity_overflow(dl_se, pi_se, rq_clock(rq))) {
+		dl_se->deadline = rq_clock(rq) + pi_se->dl_deadline;
+		dl_se->runtime = pi_se->dl_runtime;
 	}
 }
 
@@ -405,7 +406,7 @@ static void update_dl_entity(struct sched_dl_entity *dl_se)
  * actually started or not (i.e., the replenishment instant is in
  * the future or in the past).
  */
-static int start_dl_timer(struct sched_dl_entity *dl_se)
+static int start_dl_timer(struct sched_dl_entity *dl_se, bool boosted)
 {
 	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
 	struct rq *rq = rq_of_dl_rq(dl_rq);
@@ -414,6 +415,8 @@ static int start_dl_timer(struct sched_dl_entity *dl_se)
 	unsigned long range;
 	s64 delta;
 
+	if (boosted)
+		return 0;
 	/*
 	 * We want the timer to fire at the deadline, but considering
 	 * that it is actually coming from rq->clock and not from
@@ -573,7 +576,7 @@ static void update_curr_dl(struct rq *rq)
 	dl_se->runtime -= delta_exec;
 	if (dl_runtime_exceeded(rq, dl_se)) {
 		__dequeue_task_dl(rq, curr, 0);
-		if (likely(start_dl_timer(dl_se)))
+		if (likely(start_dl_timer(dl_se, curr->dl.dl_boosted)))
 			dl_se->dl_throttled = 1;
 		else
 			enqueue_task_dl(rq, curr, ENQUEUE_REPLENISH);
@@ -728,7 +731,8 @@ static void __dequeue_dl_entity(struct sched_dl_entity *dl_se)
 }
 
 static void
-enqueue_dl_entity(struct sched_dl_entity *dl_se, int flags)
+enqueue_dl_entity(struct sched_dl_entity *dl_se,
+		  struct sched_dl_entity *pi_se, int flags)
 {
 	BUG_ON(on_dl_rq(dl_se));
 
@@ -738,9 +742,9 @@ enqueue_dl_entity(struct sched_dl_entity *dl_se, int flags)
 	 * we want a replenishment of its runtime.
 	 */
 	if (!dl_se->dl_new && flags & ENQUEUE_REPLENISH)
-		replenish_dl_entity(dl_se);
+		replenish_dl_entity(dl_se, pi_se);
 	else
-		update_dl_entity(dl_se);
+		update_dl_entity(dl_se, pi_se);
 
 	__enqueue_dl_entity(dl_se);
 }
@@ -752,6 +756,18 @@ static void dequeue_dl_entity(struct sched_dl_entity *dl_se)
 
 static void enqueue_task_dl(struct rq *rq, struct task_struct *p, int flags)
 {
+	struct task_struct *pi_task = rt_mutex_get_top_task(p);
+	struct sched_dl_entity *pi_se = &p->dl;
+
+	/*
+	 * Use the scheduling parameters of the top pi-waiter
+	 * task if we have one and its (relative) deadline is
+	 * smaller than our one... OTW we keep our runtime and
+	 * deadline.
+	 */
+	if (pi_task && p->dl.dl_boosted && dl_prio(pi_task->normal_prio))
+		pi_se = &pi_task->dl;
+
 	/*
 	 * If p is throttled, we do nothing. In fact, if it exhausted
 	 * its budget it needs a replenishment and, since it now is on
@@ -761,7 +777,7 @@ static void enqueue_task_dl(struct rq *rq, struct task_struct *p, int flags)
 	if (p->dl.dl_throttled)
 		return;
 
-	enqueue_dl_entity(&p->dl, flags);
+	enqueue_dl_entity(&p->dl, pi_se, flags);
 
 	if (!task_current(rq, p) && p->nr_cpus_allowed > 1)
 		enqueue_pushable_dl_task(rq, p);
@@ -985,8 +1001,7 @@ static void task_dead_dl(struct task_struct *p)
 {
 	struct hrtimer *timer = &p->dl.dl_timer;
 
-	if (hrtimer_active(timer))
-		hrtimer_try_to_cancel(timer);
+	hrtimer_cancel(timer);
 }
 
 static void set_curr_task_dl(struct rq *rq)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 93ea627..52453a2 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -107,6 +107,20 @@ static inline int task_has_dl_policy(struct task_struct *p)
 	return dl_policy(p->policy);
 }
 
+static inline int dl_time_before(u64 a, u64 b)
+{
+	return (s64)(a - b) < 0;
+}
+
+/*
+ * Tells if entity @a should preempt entity @b.
+ */
+static inline
+int dl_entity_preempt(struct sched_dl_entity *a, struct sched_dl_entity *b)
+{
+	return dl_time_before(a->deadline, b->deadline);
+}
+
 /*
  * This is the priority-queue data structure of the RT scheduling class:
  */
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 090c4d9..6e32635 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -16,6 +16,7 @@
 #include <linux/uaccess.h>
 #include <linux/ftrace.h>
 #include <linux/sched/rt.h>
+#include <linux/sched/deadline.h>
 #include <trace/events/sched.h>
 #include "trace.h"
 
