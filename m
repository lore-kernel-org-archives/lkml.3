Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179AbaF0OY6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 10:24:58 -0400
Received: from www.linutronix.de ([62.245.132.108]:49809 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbaF0OY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 10:24:56 -0400
Date: Fri, 27 Jun 2014 16:24:52 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Austin Schuh <austin@peloton-tech.com>
cc: Richard Weinberger <richard.weinberger@gmail.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        rt-users <linux-rt-users@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Filesystem lockup with CONFIG_PREEMPT_RT
In-Reply-To: <CANGgnMa+qtgJ3wwg_h5Rynw5vEvZpQZ6PvaUfXNQ8+Y3Yu5U0g@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1406271249510.5170@nanos>
References: <CANGgnMbHckBQdKGN_N5Q6qEKc9n1CenxvMpeXog1NbSdL8UrTw@mail.gmail.com> <CANGgnMYDXerOUDOO9-RHMJKadKACA2KBGskZwoP-1ZwAhDEfVA@mail.gmail.com> <CAFLxGvxfBt7OvW=a2Kz08GLHSEiiOZsN-vB19CXnQiwqFxqMsA@mail.gmail.com> <CANGgnMYVoP-Z0Bv-VDEkJnvfa7Fi4-zY2F4A0PhMewGvwo3VVw@mail.gmail.com>
 <alpine.DEB.2.10.1406270027300.5170@nanos> <CANGgnMa+qtgJ3wwg_h5Rynw5vEvZpQZ6PvaUfXNQ8+Y3Yu5U0g@mail.gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2014, Austin Schuh wrote:
> If I'm reading the rt patch correctly, wq_worker_sleeping was moved
> out of __schedule to sched_submit_work.  It looks like that changes
> the conditions under which wq_worker_sleeping is called.  It used to
> be called whenever a task was going to sleep (I think).  It looks like
> it is called now if the task is going to sleep, and if the task isn't
> blocked on a PI mutex (I think).
> 
> If I try the following experiment
> 
>  static inline void sched_submit_work(struct task_struct *tsk)
>  {
> +   if (tsk->state && tsk->flags & PF_WQ_WORKER) {
> +     wq_worker_sleeping(tsk);
> +     return;
> +   }
> 
> and then remove the call later in the function, I am able to pass my test.
> 
> Unfortunately, I then get a recursive pool spinlock BUG_ON after a
> while (as I would expect), and it all blows up.

Well, that's why the check for !pi_blocked_on is there.
 
> I'm not sure where to go from there.  Any changes to the workpool to
> try to fix that will be hard, or could affect latency significantly.

Completely untested patch below.

Thanks,

	tglx

--------------------->
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 8749d20..621329a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2651,9 +2651,8 @@ need_resched:
 
 static inline void sched_submit_work(struct task_struct *tsk)
 {
-	if (!tsk->state || tsk_is_pi_blocked(tsk))
+	if (!tsk->state)
 		return;
-
 	/*
 	 * If a worker went to sleep, notify and ask workqueue whether
 	 * it wants to wake up a task to maintain concurrency.
@@ -2661,6 +2660,10 @@ static inline void sched_submit_work(struct task_struct *tsk)
 	if (tsk->flags & PF_WQ_WORKER)
 		wq_worker_sleeping(tsk);
 
+
+	if (tsk_is_pi_blocked(tsk))
+		return;
+
 	/*
 	 * If we are going to sleep and we have plugged IO queued,
 	 * make sure to submit it to avoid deadlocks.
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index be0ef50..0ca9d97 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -126,6 +126,8 @@ enum {
  *    cpu or grabbing pool->lock is enough for read access.  If
  *    POOL_DISASSOCIATED is set, it's identical to L.
  *
+ *    On RT we need the extra protection via rt_lock_idle_list()
+ *
  * MG: pool->manager_mutex and pool->lock protected.  Writes require both
  *     locks.  Reads can happen under either lock.
  *
@@ -409,6 +411,31 @@ static void copy_workqueue_attrs(struct workqueue_attrs *to,
 		if (({ assert_rcu_or_wq_mutex(wq); false; })) { }	\
 		else
 
+#ifdef CONFIG_PREEMPT_RT_BASE
+static inline void rt_lock_idle_list(struct worker_pool *pool)
+{
+	preempt_disable();
+}
+static inline void rt_unlock_idle_list(struct worker_pool *pool)
+{
+	preempt_enable();
+}
+static inline void sched_lock_idle_list(struct worker_pool *pool) { }
+static inline void sched_unlock_idle_list(struct worker_pool *pool) { }
+#else
+static inline void rt_lock_idle_list(struct worker_pool *pool) { }
+static inline void rt_unlock_idle_list(struct worker_pool *pool) { }
+static inline void sched_lock_idle_list(struct worker_pool *pool)
+{
+	spin_lock_irq(&pool->lock);
+}
+static inline void sched_unlock_idle_list(struct worker_pool *pool)
+{
+	spin_unlock_irq(&pool->lock);
+}
+#endif
+
+
 #ifdef CONFIG_DEBUG_OBJECTS_WORK
 
 static struct debug_obj_descr work_debug_descr;
@@ -801,10 +828,16 @@ static struct worker *first_worker(struct worker_pool *pool)
  */
 static void wake_up_worker(struct worker_pool *pool)
 {
-	struct worker *worker = first_worker(pool);
+	struct worker *worker;
+
+	rt_lock_idle_list(pool);
+
+	worker = first_worker(pool);
 
 	if (likely(worker))
 		wake_up_process(worker->task);
+
+	rt_unlock_idle_list(pool);
 }
 
 /**
@@ -832,7 +865,7 @@ void wq_worker_running(struct task_struct *task)
  */
 void wq_worker_sleeping(struct task_struct *task)
 {
-	struct worker *next, *worker = kthread_data(task);
+	struct worker *worker = kthread_data(task);
 	struct worker_pool *pool;
 
 	/*
@@ -849,25 +882,18 @@ void wq_worker_sleeping(struct task_struct *task)
 		return;
 
 	worker->sleeping = 1;
-	spin_lock_irq(&pool->lock);
+
 	/*
 	 * The counterpart of the following dec_and_test, implied mb,
 	 * worklist not empty test sequence is in insert_work().
 	 * Please read comment there.
-	 *
-	 * NOT_RUNNING is clear.  This means that we're bound to and
-	 * running on the local cpu w/ rq lock held and preemption
-	 * disabled, which in turn means that none else could be
-	 * manipulating idle_list, so dereferencing idle_list without pool
-	 * lock is safe.
 	 */
 	if (atomic_dec_and_test(&pool->nr_running) &&
 	    !list_empty(&pool->worklist)) {
-		next = first_worker(pool);
-		if (next)
-			wake_up_process(next->task);
+		sched_lock_idle_list(pool);
+		wake_up_worker(pool);
+		sched_unlock_idle_list(pool);
 	}
-	spin_unlock_irq(&pool->lock);
 }
 
 /**
@@ -1571,7 +1597,9 @@ static void worker_enter_idle(struct worker *worker)
 	worker->last_active = jiffies;
 
 	/* idle_list is LIFO */
+	rt_lock_idle_list(pool);
 	list_add(&worker->entry, &pool->idle_list);
+	rt_unlock_idle_list(pool);
 
 	if (too_many_workers(pool) && !timer_pending(&pool->idle_timer))
 		mod_timer(&pool->idle_timer, jiffies + IDLE_WORKER_TIMEOUT);
@@ -1604,7 +1632,9 @@ static void worker_leave_idle(struct worker *worker)
 		return;
 	worker_clr_flags(worker, WORKER_IDLE);
 	pool->nr_idle--;
+	rt_lock_idle_list(pool);
 	list_del_init(&worker->entry);
+	rt_unlock_idle_list(pool);
 }
 
 /**
@@ -1849,7 +1879,9 @@ static void destroy_worker(struct worker *worker)
 	 */
 	get_task_struct(worker->task);
 
+	rt_lock_idle_list(pool);
 	list_del_init(&worker->entry);
+	rt_unlock_idle_list(pool);
 	worker->flags |= WORKER_DIE;
 
 	idr_remove(&pool->worker_idr, worker->id);
