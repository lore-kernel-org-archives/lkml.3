Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbaHTJrp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 05:47:45 -0400
Received: from relay.parallels.com ([195.214.232.42]:59163 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbaHTJrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 05:47:42 -0400
Message-ID: <1408528052.23412.87.camel@tkhai>
Subject: [PATCH v5 1/5] sched: Wrapper for checking task_struct::on_rq
From: Kirill Tkhai <ktkhai@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>,
        Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        "Mike Galbraith" <umgwanakikbuti@gmail.com>,
        Kirill Tkhai <tkhai@yandex.ru>,
        "Tim Chen" <tim.c.chen@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Nicolas Pitre" <nicolas.pitre@linaro.org>
Date: Wed, 20 Aug 2014 13:47:32 +0400
In-Reply-To: <20140820092458.27076.30955.stgit@tkhai>
References: <20140820092458.27076.30955.stgit@tkhai>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Implement task_on_rq_queued() and use it everywhere instead of on_rq check.
No functional changes.

The only exception is we do not use the wrapper in check_for_tasks(),
because it requires to export task_on_rq_queued() in global header files.
Next patch in series would return it back, so we do not twist it from
here to there.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
---
 kernel/sched/core.c      |   82 +++++++++++++++++++++++-----------------------
 kernel/sched/deadline.c  |   15 ++++----
 kernel/sched/fair.c      |   22 ++++++------
 kernel/sched/rt.c        |   16 ++++-----
 kernel/sched/sched.h     |    7 ++++
 kernel/sched/stop_task.c |    2 +
 6 files changed, 76 insertions(+), 68 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 900bae8..1276ba2 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1027,7 +1027,7 @@ void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags)
 	 * A queue event has occurred, and we're going to schedule.  In
 	 * this case, we can save a useless back to back clock update.
 	 */
-	if (rq->curr->on_rq && test_tsk_need_resched(rq->curr))
+	if (task_on_rq_queued(rq->curr) && test_tsk_need_resched(rq->curr))
 		rq->skip_clock_update = 1;
 }
 
@@ -1072,7 +1072,7 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 
 static void __migrate_swap_task(struct task_struct *p, int cpu)
 {
-	if (p->on_rq) {
+	if (task_on_rq_queued(p)) {
 		struct rq *src_rq, *dst_rq;
 
 		src_rq = task_rq(p);
@@ -1198,7 +1198,7 @@ static int migration_cpu_stop(void *data);
 unsigned long wait_task_inactive(struct task_struct *p, long match_state)
 {
 	unsigned long flags;
-	int running, on_rq;
+	int running, queued;
 	unsigned long ncsw;
 	struct rq *rq;
 
@@ -1236,7 +1236,7 @@ unsigned long wait_task_inactive(struct task_struct *p, long match_state)
 		rq = task_rq_lock(p, &flags);
 		trace_sched_wait_task(p);
 		running = task_running(rq, p);
-		on_rq = p->on_rq;
+		queued = task_on_rq_queued(p);
 		ncsw = 0;
 		if (!match_state || p->state == match_state)
 			ncsw = p->nvcsw | LONG_MIN; /* sets MSB */
@@ -1268,7 +1268,7 @@ unsigned long wait_task_inactive(struct task_struct *p, long match_state)
 		 * running right now), it's preempted, and we should
 		 * yield - it could be a while.
 		 */
-		if (unlikely(on_rq)) {
+		if (unlikely(queued)) {
 			ktime_t to = ktime_set(0, NSEC_PER_SEC/HZ);
 
 			set_current_state(TASK_UNINTERRUPTIBLE);
@@ -1462,7 +1462,7 @@ ttwu_stat(struct task_struct *p, int cpu, int wake_flags)
 static void ttwu_activate(struct rq *rq, struct task_struct *p, int en_flags)
 {
 	activate_task(rq, p, en_flags);
-	p->on_rq = 1;
+	p->on_rq = TASK_ON_RQ_QUEUED;
 
 	/* if a worker is waking up, notify workqueue */
 	if (p->flags & PF_WQ_WORKER)
@@ -1521,7 +1521,7 @@ static int ttwu_remote(struct task_struct *p, int wake_flags)
 	int ret = 0;
 
 	rq = __task_rq_lock(p);
-	if (p->on_rq) {
+	if (task_on_rq_queued(p)) {
 		/* check_preempt_curr() may use rq clock */
 		update_rq_clock(rq);
 		ttwu_do_wakeup(rq, p, wake_flags);
@@ -1662,7 +1662,7 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 	success = 1; /* we're going to change ->state */
 	cpu = task_cpu(p);
 
-	if (p->on_rq && ttwu_remote(p, wake_flags))
+	if (task_on_rq_queued(p) && ttwu_remote(p, wake_flags))
 		goto stat;
 
 #ifdef CONFIG_SMP
@@ -1726,7 +1726,7 @@ static void try_to_wake_up_local(struct task_struct *p)
 	if (!(p->state & TASK_NORMAL))
 		goto out;
 
-	if (!p->on_rq)
+	if (!task_on_rq_queued(p))
 		ttwu_activate(rq, p, ENQUEUE_WAKEUP);
 
 	ttwu_do_wakeup(rq, p, 0);
@@ -2079,7 +2079,7 @@ void wake_up_new_task(struct task_struct *p)
 	init_task_runnable_average(p);
 	rq = __task_rq_lock(p);
 	activate_task(rq, p, 0);
-	p->on_rq = 1;
+	p->on_rq = TASK_ON_RQ_QUEUED;
 	trace_sched_wakeup_new(p, true);
 	check_preempt_curr(rq, p, WF_FORK);
 #ifdef CONFIG_SMP
@@ -2428,7 +2428,7 @@ static u64 do_task_delta_exec(struct task_struct *p, struct rq *rq)
 	 * project cycles that may never be accounted to this
 	 * thread, breaking clock_gettime().
 	 */
-	if (task_current(rq, p) && p->on_rq) {
+	if (task_current(rq, p) && task_on_rq_queued(p)) {
 		update_rq_clock(rq);
 		ns = rq_clock_task(rq) - p->se.exec_start;
 		if ((s64)ns < 0)
@@ -2474,7 +2474,7 @@ unsigned long long task_sched_runtime(struct task_struct *p)
 	 * If we see ->on_cpu without ->on_rq, the task is leaving, and has
 	 * been accounted, so we're correct here as well.
 	 */
-	if (!p->on_cpu || !p->on_rq)
+	if (!p->on_cpu || !task_on_rq_queued(p))
 		return p->se.sum_exec_runtime;
 #endif
 
@@ -2778,7 +2778,7 @@ static void __sched __schedule(void)
 		switch_count = &prev->nvcsw;
 	}
 
-	if (prev->on_rq || rq->skip_clock_update < 0)
+	if (task_on_rq_queued(prev) || rq->skip_clock_update < 0)
 		update_rq_clock(rq);
 
 	next = pick_next_task(rq, prev);
@@ -2943,7 +2943,7 @@ EXPORT_SYMBOL(default_wake_function);
  */
 void rt_mutex_setprio(struct task_struct *p, int prio)
 {
-	int oldprio, on_rq, running, enqueue_flag = 0;
+	int oldprio, queued, running, enqueue_flag = 0;
 	struct rq *rq;
 	const struct sched_class *prev_class;
 
@@ -2972,9 +2972,9 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 	trace_sched_pi_setprio(p, prio);
 	oldprio = p->prio;
 	prev_class = p->sched_class;
-	on_rq = p->on_rq;
+	queued = task_on_rq_queued(p);
 	running = task_current(rq, p);
-	if (on_rq)
+	if (queued)
 		dequeue_task(rq, p, 0);
 	if (running)
 		p->sched_class->put_prev_task(rq, p);
@@ -3014,7 +3014,7 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 
 	if (running)
 		p->sched_class->set_curr_task(rq);
-	if (on_rq)
+	if (queued)
 		enqueue_task(rq, p, enqueue_flag);
 
 	check_class_changed(rq, p, prev_class, oldprio);
@@ -3025,7 +3025,7 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 
 void set_user_nice(struct task_struct *p, long nice)
 {
-	int old_prio, delta, on_rq;
+	int old_prio, delta, queued;
 	unsigned long flags;
 	struct rq *rq;
 
@@ -3046,8 +3046,8 @@ void set_user_nice(struct task_struct *p, long nice)
 		p->static_prio = NICE_TO_PRIO(nice);
 		goto out_unlock;
 	}
-	on_rq = p->on_rq;
-	if (on_rq)
+	queued = task_on_rq_queued(p);
+	if (queued)
 		dequeue_task(rq, p, 0);
 
 	p->static_prio = NICE_TO_PRIO(nice);
@@ -3056,7 +3056,7 @@ void set_user_nice(struct task_struct *p, long nice)
 	p->prio = effective_prio(p);
 	delta = p->prio - old_prio;
 
-	if (on_rq) {
+	if (queued) {
 		enqueue_task(rq, p, 0);
 		/*
 		 * If the task increased its priority or is running and
@@ -3328,7 +3328,7 @@ static int __sched_setscheduler(struct task_struct *p,
 {
 	int newprio = dl_policy(attr->sched_policy) ? MAX_DL_PRIO - 1 :
 		      MAX_RT_PRIO - 1 - attr->sched_priority;
-	int retval, oldprio, oldpolicy = -1, on_rq, running;
+	int retval, oldprio, oldpolicy = -1, queued, running;
 	int policy = attr->sched_policy;
 	unsigned long flags;
 	const struct sched_class *prev_class;
@@ -3525,9 +3525,9 @@ static int __sched_setscheduler(struct task_struct *p,
 		return 0;
 	}
 
-	on_rq = p->on_rq;
+	queued = task_on_rq_queued(p);
 	running = task_current(rq, p);
-	if (on_rq)
+	if (queued)
 		dequeue_task(rq, p, 0);
 	if (running)
 		p->sched_class->put_prev_task(rq, p);
@@ -3537,7 +3537,7 @@ static int __sched_setscheduler(struct task_struct *p,
 
 	if (running)
 		p->sched_class->set_curr_task(rq);
-	if (on_rq) {
+	if (queued) {
 		/*
 		 * We enqueue to tail when the priority of a task is
 		 * increased (user space view).
@@ -4552,7 +4552,7 @@ void init_idle(struct task_struct *idle, int cpu)
 	rcu_read_unlock();
 
 	rq->curr = rq->idle = idle;
-	idle->on_rq = 1;
+	idle->on_rq = TASK_ON_RQ_QUEUED;
 #if defined(CONFIG_SMP)
 	idle->on_cpu = 1;
 #endif
@@ -4629,7 +4629,7 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
 		goto out;
 
 	dest_cpu = cpumask_any_and(cpu_active_mask, new_mask);
-	if (p->on_rq) {
+	if (task_on_rq_queued(p)) {
 		struct migration_arg arg = { p, dest_cpu };
 		/* Need help from migration thread: drop lock and wait. */
 		task_rq_unlock(rq, p, &flags);
@@ -4679,7 +4679,7 @@ static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
 	 * If we're not on a rq, the next wake-up will ensure we're
 	 * placed properly.
 	 */
-	if (p->on_rq) {
+	if (task_on_rq_queued(p)) {
 		dequeue_task(rq_src, p, 0);
 		set_task_cpu(p, dest_cpu);
 		enqueue_task(rq_dest, p, 0);
@@ -4720,13 +4720,13 @@ void sched_setnuma(struct task_struct *p, int nid)
 {
 	struct rq *rq;
 	unsigned long flags;
-	bool on_rq, running;
+	bool queued, running;
 
 	rq = task_rq_lock(p, &flags);
-	on_rq = p->on_rq;
+	queued = task_on_rq_queued(p);
 	running = task_current(rq, p);
 
-	if (on_rq)
+	if (queued)
 		dequeue_task(rq, p, 0);
 	if (running)
 		p->sched_class->put_prev_task(rq, p);
@@ -4735,7 +4735,7 @@ void sched_setnuma(struct task_struct *p, int nid)
 
 	if (running)
 		p->sched_class->set_curr_task(rq);
-	if (on_rq)
+	if (queued)
 		enqueue_task(rq, p, 0);
 	task_rq_unlock(rq, p, &flags);
 }
@@ -7100,13 +7100,13 @@ static void normalize_task(struct rq *rq, struct task_struct *p)
 		.sched_policy = SCHED_NORMAL,
 	};
 	int old_prio = p->prio;
-	int on_rq;
+	int queued;
 
-	on_rq = p->on_rq;
-	if (on_rq)
+	queued = task_on_rq_queued(p);
+	if (queued)
 		dequeue_task(rq, p, 0);
 	__setscheduler(rq, p, &attr);
-	if (on_rq) {
+	if (queued) {
 		enqueue_task(rq, p, 0);
 		resched_curr(rq);
 	}
@@ -7293,16 +7293,16 @@ void sched_offline_group(struct task_group *tg)
 void sched_move_task(struct task_struct *tsk)
 {
 	struct task_group *tg;
-	int on_rq, running;
+	int queued, running;
 	unsigned long flags;
 	struct rq *rq;
 
 	rq = task_rq_lock(tsk, &flags);
 
 	running = task_current(rq, tsk);
-	on_rq = tsk->on_rq;
+	queued = task_on_rq_queued(tsk);
 
-	if (on_rq)
+	if (queued)
 		dequeue_task(rq, tsk, 0);
 	if (unlikely(running))
 		tsk->sched_class->put_prev_task(rq, tsk);
@@ -7315,14 +7315,14 @@ void sched_move_task(struct task_struct *tsk)
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	if (tsk->sched_class->task_move_group)
-		tsk->sched_class->task_move_group(tsk, on_rq);
+		tsk->sched_class->task_move_group(tsk, queued);
 	else
 #endif
 		set_task_rq(tsk, task_cpu(tsk));
 
 	if (unlikely(running))
 		tsk->sched_class->set_curr_task(rq);
-	if (on_rq)
+	if (queued)
 		enqueue_task(rq, tsk, 0);
 
 	task_rq_unlock(rq, tsk, &flags);
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 255ce13..d21a8e0 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -530,7 +530,7 @@ static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
 	update_rq_clock(rq);
 	dl_se->dl_throttled = 0;
 	dl_se->dl_yielded = 0;
-	if (p->on_rq) {
+	if (task_on_rq_queued(p)) {
 		enqueue_task_dl(rq, p, ENQUEUE_REPLENISH);
 		if (task_has_dl_policy(rq->curr))
 			check_preempt_curr_dl(rq, p, 0);
@@ -1030,7 +1030,7 @@ struct task_struct *pick_next_task_dl(struct rq *rq, struct task_struct *prev)
 		 * means a stop task can slip in, in which case we need to
 		 * re-start task selection.
 		 */
-		if (rq->stop && rq->stop->on_rq)
+		if (rq->stop && task_on_rq_queued(rq->stop))
 			return RETRY_TASK;
 	}
 
@@ -1257,7 +1257,8 @@ static struct rq *find_lock_later_rq(struct task_struct *task, struct rq *rq)
 			if (unlikely(task_rq(task) != rq ||
 				     !cpumask_test_cpu(later_rq->cpu,
 				                       &task->cpus_allowed) ||
-				     task_running(rq, task) || !task->on_rq)) {
+				     task_running(rq, task) ||
+				     !task_on_rq_queued(task))) {
 				double_unlock_balance(rq, later_rq);
 				later_rq = NULL;
 				break;
@@ -1296,7 +1297,7 @@ static struct task_struct *pick_next_pushable_dl_task(struct rq *rq)
 	BUG_ON(task_current(rq, p));
 	BUG_ON(p->nr_cpus_allowed <= 1);
 
-	BUG_ON(!p->on_rq);
+	BUG_ON(!task_on_rq_queued(p));
 	BUG_ON(!dl_task(p));
 
 	return p;
@@ -1443,7 +1444,7 @@ static int pull_dl_task(struct rq *this_rq)
 		     dl_time_before(p->dl.deadline,
 				    this_rq->dl.earliest_dl.curr))) {
 			WARN_ON(p == src_rq->curr);
-			WARN_ON(!p->on_rq);
+			WARN_ON(!task_on_rq_queued(p));
 
 			/*
 			 * Then we pull iff p has actually an earlier
@@ -1596,7 +1597,7 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
 	if (unlikely(p->dl.dl_throttled))
 		return;
 
-	if (p->on_rq && rq->curr != p) {
+	if (task_on_rq_queued(p) && rq->curr != p) {
 #ifdef CONFIG_SMP
 		if (rq->dl.overloaded && push_dl_task(rq) && rq != task_rq(p))
 			/* Only reschedule if pushing failed */
@@ -1614,7 +1615,7 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
 static void prio_changed_dl(struct rq *rq, struct task_struct *p,
 			    int oldprio)
 {
-	if (p->on_rq || rq->curr == p) {
+	if (task_on_rq_queued(p) || rq->curr == p) {
 #ifdef CONFIG_SMP
 		/*
 		 * This might be too much, but unfortunately
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index bc37bb9..9e6ca0d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7494,7 +7494,7 @@ static void task_fork_fair(struct task_struct *p)
 static void
 prio_changed_fair(struct rq *rq, struct task_struct *p, int oldprio)
 {
-	if (!p->on_rq)
+	if (!task_on_rq_queued(p))
 		return;
 
 	/*
@@ -7519,11 +7519,11 @@ static void switched_from_fair(struct rq *rq, struct task_struct *p)
 	 * switched back to the fair class the enqueue_entity(.flags=0) will
 	 * do the right thing.
 	 *
-	 * If it's on_rq, then the dequeue_entity(.flags=0) will already
-	 * have normalized the vruntime, if it's !on_rq, then only when
+	 * If it's queued, then the dequeue_entity(.flags=0) will already
+	 * have normalized the vruntime, if it's !queued, then only when
 	 * the task is sleeping will it still have non-normalized vruntime.
 	 */
-	if (!p->on_rq && p->state != TASK_RUNNING) {
+	if (!task_on_rq_queued(p) && p->state != TASK_RUNNING) {
 		/*
 		 * Fix up our vruntime so that the current sleep doesn't
 		 * cause 'unlimited' sleep bonus.
@@ -7558,7 +7558,7 @@ static void switched_to_fair(struct rq *rq, struct task_struct *p)
 	 */
 	se->depth = se->parent ? se->parent->depth + 1 : 0;
 #endif
-	if (!p->on_rq)
+	if (!task_on_rq_queued(p))
 		return;
 
 	/*
@@ -7604,7 +7604,7 @@ void init_cfs_rq(struct cfs_rq *cfs_rq)
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-static void task_move_group_fair(struct task_struct *p, int on_rq)
+static void task_move_group_fair(struct task_struct *p, int queued)
 {
 	struct sched_entity *se = &p->se;
 	struct cfs_rq *cfs_rq;
@@ -7623,7 +7623,7 @@ static void task_move_group_fair(struct task_struct *p, int on_rq)
 	 * fair sleeper stuff for the first placement, but who cares.
 	 */
 	/*
-	 * When !on_rq, vruntime of the task has usually NOT been normalized.
+	 * When !queued, vruntime of the task has usually NOT been normalized.
 	 * But there are some cases where it has already been normalized:
 	 *
 	 * - Moving a forked child which is waiting for being woken up by
@@ -7634,14 +7634,14 @@ static void task_move_group_fair(struct task_struct *p, int on_rq)
 	 * To prevent boost or penalty in the new cfs_rq caused by delta
 	 * min_vruntime between the two cfs_rqs, we skip vruntime adjustment.
 	 */
-	if (!on_rq && (!se->sum_exec_runtime || p->state == TASK_WAKING))
-		on_rq = 1;
+	if (!queued && (!se->sum_exec_runtime || p->state == TASK_WAKING))
+		queued = 1;
 
-	if (!on_rq)
+	if (!queued)
 		se->vruntime -= cfs_rq_of(se)->min_vruntime;
 	set_task_rq(p, task_cpu(p));
 	se->depth = se->parent ? se->parent->depth + 1 : 0;
-	if (!on_rq) {
+	if (!queued) {
 		cfs_rq = cfs_rq_of(se);
 		se->vruntime += cfs_rq->min_vruntime;
 #ifdef CONFIG_SMP
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 5f6edca..4feac8f 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1448,7 +1448,7 @@ pick_next_task_rt(struct rq *rq, struct task_struct *prev)
 		 * means a dl or stop task can slip in, in which case we need
 		 * to re-start task selection.
 		 */
-		if (unlikely((rq->stop && rq->stop->on_rq) ||
+		if (unlikely((rq->stop && task_on_rq_queued(rq->stop)) ||
 			     rq->dl.dl_nr_running))
 			return RETRY_TASK;
 	}
@@ -1624,7 +1624,7 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task, struct rq *rq)
 				     !cpumask_test_cpu(lowest_rq->cpu,
 						       tsk_cpus_allowed(task)) ||
 				     task_running(rq, task) ||
-				     !task->on_rq)) {
+				     !task_on_rq_queued(task))) {
 
 				double_unlock_balance(rq, lowest_rq);
 				lowest_rq = NULL;
@@ -1658,7 +1658,7 @@ static struct task_struct *pick_next_pushable_task(struct rq *rq)
 	BUG_ON(task_current(rq, p));
 	BUG_ON(p->nr_cpus_allowed <= 1);
 
-	BUG_ON(!p->on_rq);
+	BUG_ON(!task_on_rq_queued(p));
 	BUG_ON(!rt_task(p));
 
 	return p;
@@ -1809,7 +1809,7 @@ static int pull_rt_task(struct rq *this_rq)
 		 */
 		if (p && (p->prio < this_rq->rt.highest_prio.curr)) {
 			WARN_ON(p == src_rq->curr);
-			WARN_ON(!p->on_rq);
+			WARN_ON(!task_on_rq_queued(p));
 
 			/*
 			 * There's a chance that p is higher in priority
@@ -1870,7 +1870,7 @@ static void set_cpus_allowed_rt(struct task_struct *p,
 
 	BUG_ON(!rt_task(p));
 
-	if (!p->on_rq)
+	if (!task_on_rq_queued(p))
 		return;
 
 	weight = cpumask_weight(new_mask);
@@ -1936,7 +1936,7 @@ static void switched_from_rt(struct rq *rq, struct task_struct *p)
 	 * we may need to handle the pulling of RT tasks
 	 * now.
 	 */
-	if (!p->on_rq || rq->rt.rt_nr_running)
+	if (!task_on_rq_queued(p) || rq->rt.rt_nr_running)
 		return;
 
 	if (pull_rt_task(rq))
@@ -1970,7 +1970,7 @@ static void switched_to_rt(struct rq *rq, struct task_struct *p)
 	 * If that current running task is also an RT task
 	 * then see if we can move to another run queue.
 	 */
-	if (p->on_rq && rq->curr != p) {
+	if (task_on_rq_queued(p) && rq->curr != p) {
 #ifdef CONFIG_SMP
 		if (p->nr_cpus_allowed > 1 && rq->rt.overloaded &&
 		    /* Don't resched if we changed runqueues */
@@ -1989,7 +1989,7 @@ static void switched_to_rt(struct rq *rq, struct task_struct *p)
 static void
 prio_changed_rt(struct rq *rq, struct task_struct *p, int oldprio)
 {
-	if (!p->on_rq)
+	if (!task_on_rq_queued(p))
 		return;
 
 	if (rq->curr == p) {
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 4c2b87f..26566d0 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -15,6 +15,9 @@
 
 struct rq;
 
+/* task_struct::on_rq states: */
+#define TASK_ON_RQ_QUEUED	1
+
 extern __read_mostly int scheduler_running;
 
 extern unsigned long calc_load_update;
@@ -942,6 +945,10 @@ static inline int task_running(struct rq *rq, struct task_struct *p)
 #endif
 }
 
+static inline int task_on_rq_queued(struct task_struct *p)
+{
+	return p->on_rq == TASK_ON_RQ_QUEUED;
+}
 
 #ifndef prepare_arch_switch
 # define prepare_arch_switch(next)	do { } while (0)
diff --git a/kernel/sched/stop_task.c b/kernel/sched/stop_task.c
index bfe0eda..67426e5 100644
--- a/kernel/sched/stop_task.c
+++ b/kernel/sched/stop_task.c
@@ -28,7 +28,7 @@ pick_next_task_stop(struct rq *rq, struct task_struct *prev)
 {
 	struct task_struct *stop = rq->stop;
 
-	if (!stop || !stop->on_rq)
+	if (!stop || !task_on_rq_queued(stop))
 		return NULL;
 
 	put_prev_task(rq, prev);



