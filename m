Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940Ab3GXKEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 06:04:40 -0400
Received: from www.linutronix.de ([62.245.132.108]:51971 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab3GXKEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 06:04:12 -0400
Date: Wed, 24 Jul 2013 12:04:06 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sebastian Sewior <bigeasy@linutronix.de>
Subject: Re: [patch 4/4] sched: Distangle worker accounting from rq->lock
In-Reply-To: <1367542669.7373.10.camel@gandalf.local.home>
Message-ID: <alpine.DEB.2.02.1307241044510.4089@ionos.tec.linutronix.de>
References: <20110622174659.496793734@linutronix.de>  <20110622174919.135236139@linutronix.de>  <20130430133722.GA477@home.goodmis.org>  <20130430224710.GB9583@home.goodmis.org>  <20130503001206.GA19814@mtj.dyndns.org>
 <1367542669.7373.10.camel@gandalf.local.home>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

B1;3202;0cOn Thu, 2 May 2013, Steven Rostedt wrote:
> On Thu, 2013-05-02 at 17:12 -0700, Tejun Heo wrote:
> > On Tue, Apr 30, 2013 at 06:47:10PM -0400, Steven Rostedt wrote:
> > > On Tue, Apr 30, 2013 at 09:37:22AM -0400, Steven Rostedt wrote:
> > > > [ Blast from the past! ]
> > > > 
> > > > When merging in 3.4.42 into the 3.4-rt branch I hit a conflict with the
> > > > try_to_wake_up_local() call. It seems that the 3.4-rt patch has this
> > > > patch applied. Although, this is not applied to any of the other -rt patches.
> > > > 
> > > 
> > > I take that back. It's in 3.0-rt, 3.2-rt and 3.4-rt, but it's not in 3.6-rt
> > > nor in 3.8-rt.
> > 
> > So, it's all good?  Or is there something I need to look into?
> 
> It looks good to me. I don't know why it's not in 3.6-rt or 3.8-rt. Was
> there a reason that Thomas took it out? I don't know. Maybe it's not
> needed or he thought it went mainline?

I dropped it on purpose as I was sure, that it's safe.

But after you poked me yesterday I spent quite some time staring at
that code and found that I missed the following:

worker A is about to go idle and the pool->idle_list is empty

  calls worker_enter_idle()

  list_add(&worker->entry, &pool->idle_list);

      idle_list.prev = &worker->entry;

Preemption

Worker B runs and blocks.

  wq_worker_sleeping() sees  !list_empty(&pool->idle_list)

  because idle_list.prev points already to worker A	 

  Then first_worker returns idle_list.next which points to idle list
  so we return some random crap to wakeup.

So yes, I've donned a brown paperbag and we need to bring back that
change and think about making it more palatable for mainline.

Find an untested patch against 3.6-rt below.

Thanks,

	tglx
---
Index: linux-stable-rt/kernel/sched/core.c
===================================================================
--- linux-stable-rt.orig/kernel/sched/core.c
+++ linux-stable-rt/kernel/sched/core.c
@@ -1452,10 +1452,6 @@ static void ttwu_activate(struct rq *rq,
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
@@ -3627,19 +3587,6 @@ need_resched:
 		} else {
 			deactivate_task(rq, prev, DEQUEUE_SLEEP);
 			prev->on_rq = 0;
-
-			/*
-			 * If a worker went to sleep, notify and ask workqueue
-			 * whether it wants to wake up a task to maintain
-			 * concurrency.
-			 */
-			if (prev->flags & PF_WQ_WORKER) {
-				struct task_struct *to_wakeup;
-
-				to_wakeup = wq_worker_sleeping(prev, cpu);
-				if (to_wakeup)
-					try_to_wake_up_local(to_wakeup);
-			}
 		}
 		switch_count = &prev->nvcsw;
 	}
@@ -3683,6 +3630,14 @@ static inline void sched_submit_work(str
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
@@ -3691,12 +3646,19 @@ static inline void sched_submit_work(str
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
 
Index: linux-stable-rt/kernel/workqueue.c
===================================================================
--- linux-stable-rt.orig/kernel/workqueue.c
+++ linux-stable-rt/kernel/workqueue.c
@@ -152,6 +152,7 @@ struct worker {
 	/* for rebinding worker to CPU */
 	struct idle_rebind	*idle_rebind;	/* L: for idle worker */
 	struct work_struct	rebind_work;	/* L: for busy worker */
+	int			sleeping;	/* None */
 };
 
 struct worker_pool {
@@ -691,66 +692,55 @@ static void wake_up_worker(struct worker
 }
 
 /**
- * wq_worker_waking_up - a worker is waking up
- * @task: task waking up
- * @cpu: CPU @task is waking up to
+ * wq_worker_waking_up - a worker is running again
+ * @task: task returning from sleep
  *
- * This function is called during try_to_wake_up() when a worker is
- * being awoken.
- *
- * CONTEXT:
- * spin_lock_irq(rq->lock)
+ * This function is called when a worker returns from a blocking
+ * schedule.
  */
-void wq_worker_waking_up(struct task_struct *task, unsigned int cpu)
+void wq_worker_waking_up(struct task_struct *task)
 {
 	struct worker *worker = kthread_data(task);
 
+	if (!worker->sleeping)
+		return;
+
 	if (!(worker->flags & WORKER_NOT_RUNNING))
 		atomic_inc(get_pool_nr_running(worker->pool));
+	worker->sleeping = 0;
 }
 
 /**
  * wq_worker_sleeping - a worker is going to sleep
  * @task: task going to sleep
- * @cpu: CPU in question, must be the current CPU number
  *
  * This function is called during schedule() when a busy worker is
- * going to sleep.  Worker on the same cpu can be woken up by
- * returning pointer to its task.
- *
- * CONTEXT:
- * spin_lock_irq(rq->lock)
- *
- * RETURNS:
- * Worker task on @cpu to wake up, %NULL if none.
+ * going to sleep.
  */
-struct task_struct *wq_worker_sleeping(struct task_struct *task,
-				       unsigned int cpu)
+void wq_worker_sleeping(struct task_struct *task)
 {
-	struct worker *worker = kthread_data(task), *to_wakeup = NULL;
+	struct worker *worker = kthread_data(task);
 	struct worker_pool *pool = worker->pool;
-	atomic_t *nr_running = get_pool_nr_running(pool);
+	struct global_cwq *gcwq = pool->gcwq;
+	atomic_t *nr_running;
 
 	if (worker->flags & WORKER_NOT_RUNNING)
-		return NULL;
+		return;
 
-	/* this can only happen on the local cpu */
-	BUG_ON(cpu != raw_smp_processor_id());
+	if (WARN_ON_ONCE(worker->sleeping))
+		return;
 
+	worker->sleeping = 1;
+	spin_lock_irq(&gcwq->lock);
+	nr_running = get_pool_nr_running(pool);
 	/*
 	 * The counterpart of the following dec_and_test, implied mb,
 	 * worklist not empty test sequence is in insert_work().
 	 * Please read comment there.
-	 *
-	 * NOT_RUNNING is clear.  This means that we're bound to and
-	 * running on the local cpu w/ rq lock held and preemption
-	 * disabled, which in turn means that none else could be
-	 * manipulating idle_list, so dereferencing idle_list without gcwq
-	 * lock is safe.
 	 */
 	if (atomic_dec_and_test(nr_running) && !list_empty(&pool->worklist))
-		to_wakeup = first_worker(pool);
-	return to_wakeup ? to_wakeup->task : NULL;
+		wake_up_process(first_worker(pool)->task);
+	spin_unlock_irq(&gcwq->lock);
 }
 
 /**
Index: linux-stable-rt/kernel/workqueue_sched.h
===================================================================
--- linux-stable-rt.orig/kernel/workqueue_sched.h
+++ linux-stable-rt/kernel/workqueue_sched.h
@@ -4,6 +4,5 @@
  * Scheduler hooks for concurrency managed workqueue.  Only to be
  * included from sched.c and workqueue.c.
  */
-void wq_worker_waking_up(struct task_struct *task, unsigned int cpu);
-struct task_struct *wq_worker_sleeping(struct task_struct *task,
-				       unsigned int cpu);
+void wq_worker_running(struct task_struct *task);
+void wq_worker_sleeping(struct task_struct *task);
