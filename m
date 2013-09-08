Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701Ab3IHQAf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 12:00:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18000 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072Ab3IHP4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 11:56:47 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=3BVz8WfCV-EA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=WFY1YYRfjMsA:10 a=JfrnYn6hAAAA:8 a=VwQbUJbxAAAA:8 a=cH6R9-kdAAAA:8 a=8jJl7FeZAAAA:8 a=XnvMRT4kBTPYh1WHGdgA:9 a=xmeP8RLjVa8A:10 a=Zh68SRI7RUMA:10 a=3Rfx1nUSh_UA:10 a=LI9Vle30uBYA:10 a=PY_IxGvJMWRZVH72:21 a=I_yKParwczpl2qXO:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130908151447.716628304@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sun, 08 Sep 2013 11:14:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        <stable-rt@vger.kernel.org>
Subject: [PATCH RT 11/19] sched: Distangle worker accounting from rqlock
References: <20130908151355.362583092@goodmis.org>
Content-Disposition: inline; filename=0011-sched-Distangle-worker-accounting-from-rqlock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

The worker accounting for cpu bound workers is plugged into the core
scheduler code and the wakeup code. This is not a hard requirement and
can be avoided by keeping track of the state in the workqueue code
itself.

Keep track of the sleeping state in the worker itself and call the
notifier before entering the core scheduler. There might be false
positives when the task is woken between that call and actually
scheduling, but that's not really different from scheduling and being
woken immediately after switching away. There is also no harm from
updating nr_running when the task returns from scheduling instead of
accounting it in the wakeup code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: stable-rt@vger.kernel.org
Link: http://lkml.kernel.org/r/20110622174919.135236139@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/core.c      |   70 ++++++++++------------------------------------
 kernel/workqueue.c       |   59 +++++++++++++++++++-------------------
 kernel/workqueue_sched.h |    5 ++--
 3 files changed, 45 insertions(+), 89 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 781e6c4..1493f43 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1452,10 +1452,6 @@ static void ttwu_activate(struct rq *rq, struct task_struct *p, int en_flags)
 {
 	activate_task(rq, p, en_flags);
 	p->on_rq = 1;
-
-	/* if a worker is waking up, notify workqueue */
-	if (p->flags & PF_WQ_WORKER)
-		wq_worker_waking_up(p, cpu_of(rq));
 }
 
 /*
@@ -1714,42 +1710,6 @@ out:
 }
 
 /**
- * try_to_wake_up_local - try to wake up a local task with rq lock held
- * @p: the thread to be awakened
- *
- * Put @p on the run-queue if it's not already there. The caller must
- * ensure that this_rq() is locked, @p is bound to this_rq() and not
- * the current task.
- */
-static void try_to_wake_up_local(struct task_struct *p)
-{
-	struct rq *rq = task_rq(p);
-
-	if (WARN_ON_ONCE(rq != this_rq()) ||
-	    WARN_ON_ONCE(p == current))
-		return;
-
-	lockdep_assert_held(&rq->lock);
-
-	if (!raw_spin_trylock(&p->pi_lock)) {
-		raw_spin_unlock(&rq->lock);
-		raw_spin_lock(&p->pi_lock);
-		raw_spin_lock(&rq->lock);
-	}
-
-	if (!(p->state & TASK_NORMAL))
-		goto out;
-
-	if (!p->on_rq)
-		ttwu_activate(rq, p, ENQUEUE_WAKEUP);
-
-	ttwu_do_wakeup(rq, p, 0);
-	ttwu_stat(p, smp_processor_id(), 0);
-out:
-	raw_spin_unlock(&p->pi_lock);
-}
-
-/**
  * wake_up_process - Wake up a specific process
  * @p: The process to be woken up.
  *
@@ -3627,21 +3587,6 @@ need_resched:
 		} else {
 			deactivate_task(rq, prev, DEQUEUE_SLEEP);
 			prev->on_rq = 0;
-
-			/*
-			 * If a worker went to sleep, notify and ask workqueue
-			 * whether it wants to wake up a task to maintain
-			 * concurrency.
-			 * Only call wake up if prev isn't blocked on a sleeping
-			 * spin lock.
-			 */
-			if (prev->flags & PF_WQ_WORKER && !prev->saved_state) {
-				struct task_struct *to_wakeup;
-
-				to_wakeup = wq_worker_sleeping(prev, cpu);
-				if (to_wakeup)
-					try_to_wake_up_local(to_wakeup);
-			}
 		}
 		switch_count = &prev->nvcsw;
 	}
@@ -3685,6 +3630,14 @@ static inline void sched_submit_work(struct task_struct *tsk)
 {
 	if (!tsk->state || tsk_is_pi_blocked(tsk))
 		return;
+
+	/*
+	 * If a worker went to sleep, notify and ask workqueue whether
+	 * it wants to wake up a task to maintain concurrency.
+	 */
+	if (tsk->flags & PF_WQ_WORKER)
+		wq_worker_sleeping(tsk);
+
 	/*
 	 * If we are going to sleep and we have plugged IO queued,
 	 * make sure to submit it to avoid deadlocks.
@@ -3693,12 +3646,19 @@ static inline void sched_submit_work(struct task_struct *tsk)
 		blk_schedule_flush_plug(tsk);
 }
 
+static inline void sched_update_worker(struct task_struct *tsk)
+{
+	if (tsk->flags & PF_WQ_WORKER)
+		wq_worker_running(tsk);
+}
+
 asmlinkage void __sched schedule(void)
 {
 	struct task_struct *tsk = current;
 
 	sched_submit_work(tsk);
 	__schedule();
+	sched_update_worker(tsk);
 }
 EXPORT_SYMBOL(schedule);
 
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index b973d66..6308d9b 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -148,6 +148,7 @@ struct worker {
 	unsigned long		last_active;	/* L: last active timestamp */
 	unsigned int		flags;		/* X: flags */
 	int			id;		/* I: worker id */
+	int			sleeping;	/* None */
 
 	/* for rebinding worker to CPU */
 	struct idle_rebind	*idle_rebind;	/* L: for idle worker */
@@ -691,52 +692,45 @@ static void wake_up_worker(struct worker_pool *pool)
 }
 
 /**
- * wq_worker_waking_up - a worker is waking up
- * @task: task waking up
- * @cpu: CPU @task is waking up to
+ * wq_worker_running - a worker is running again
+ * @task: task returning from sleep
  *
- * This function is called during try_to_wake_up() when a worker is
- * being awoken.
- *
- * CONTEXT:
- * spin_lock_irq(rq->lock)
+ * This function is called when a worker returns from schedule()
  */
-void wq_worker_waking_up(struct task_struct *task, unsigned int cpu)
+void wq_worker_running(struct task_struct *task)
 {
 	struct worker *worker = kthread_data(task);
 
+	if (!worker->sleeping)
+		return;
 	if (!(worker->flags & WORKER_NOT_RUNNING))
 		atomic_inc(get_pool_nr_running(worker->pool));
+	worker->sleeping = 0;
 }
 
 /**
  * wq_worker_sleeping - a worker is going to sleep
  * @task: task going to sleep
- * @cpu: CPU in question, must be the current CPU number
- *
- * This function is called during schedule() when a busy worker is
- * going to sleep.  Worker on the same cpu can be woken up by
- * returning pointer to its task.
- *
- * CONTEXT:
- * spin_lock_irq(rq->lock)
- *
- * RETURNS:
- * Worker task on @cpu to wake up, %NULL if none.
+ * This function is called from schedule() when a busy worker is
+ * going to sleep.
  */
-struct task_struct *wq_worker_sleeping(struct task_struct *task,
-				       unsigned int cpu)
+void wq_worker_sleeping(struct task_struct *task)
 {
-	struct worker *worker = kthread_data(task), *to_wakeup = NULL;
-	struct worker_pool *pool = worker->pool;
-	atomic_t *nr_running = get_pool_nr_running(pool);
+	struct worker *next, *worker = kthread_data(task);
+	struct worker_pool *pool;
+	atomic_t *nr_running;
 
 	if (worker->flags & WORKER_NOT_RUNNING)
-		return NULL;
+		return;
+
+	if (WARN_ON_ONCE(worker->sleeping))
+		return;
 
-	/* this can only happen on the local cpu */
-	BUG_ON(cpu != raw_smp_processor_id());
+	pool = worker->pool;
+	nr_running = get_pool_nr_running(pool);
 
+	worker->sleeping = 1;
+	spin_lock_irq(&pool->gcwq->lock);
 	/*
 	 * The counterpart of the following dec_and_test, implied mb,
 	 * worklist not empty test sequence is in insert_work().
@@ -748,9 +742,12 @@ struct task_struct *wq_worker_sleeping(struct task_struct *task,
 	 * manipulating idle_list, so dereferencing idle_list without gcwq
 	 * lock is safe.
 	 */
-	if (atomic_dec_and_test(nr_running) && !list_empty(&pool->worklist))
-		to_wakeup = first_worker(pool);
-	return to_wakeup ? to_wakeup->task : NULL;
+	if (atomic_dec_and_test(nr_running) && !list_empty(&pool->worklist)) {
+		next = first_worker(pool);
+		if (next)
+			wake_up_process(next->task);
+	}
+	spin_unlock_irq(&pool->gcwq->lock);
 }
 
 /**
diff --git a/kernel/workqueue_sched.h b/kernel/workqueue_sched.h
index 2d10fc9..3bf73e2 100644
--- a/kernel/workqueue_sched.h
+++ b/kernel/workqueue_sched.h
@@ -4,6 +4,5 @@
  * Scheduler hooks for concurrency managed workqueue.  Only to be
  * included from sched.c and workqueue.c.
  */
-void wq_worker_waking_up(struct task_struct *task, unsigned int cpu);
-struct task_struct *wq_worker_sleeping(struct task_struct *task,
-				       unsigned int cpu);
+void wq_worker_running(struct task_struct *task);
+void wq_worker_sleeping(struct task_struct *task);
-- 
1.7.10.4


