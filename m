Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbaGGOer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 10:34:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:48309 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbaGGOep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 10:34:45 -0400
Date: Mon, 7 Jul 2014 16:34:38 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sebastian Sewior <bigeasy@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Carsten Emde <cbe@osadl.org>
Subject: [ANNOUNCE] 3.14.10-rt7
In-Reply-To: <alpine.DEB.2.10.1407071027170.22031@nanos>
Message-ID: <alpine.DEB.2.10.1407071633460.22031@nanos>
References: <alpine.DEB.2.10.1407071027170.22031@nanos>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This time with proper Subject line :)

Dear RT Folks,

I'm pleased to announce the 3.14.10-rt7 release. 3.14.10-rt6 is a not
announced update to 3.14.10 without any RT changes aside of resolving
the patch conflicts.

Changes since 3.14.10-rt6:

   * Do not clear PF_NO_SETAFFINITY flag in select_fallback_rq() -
     from Steven

   * Prevent workqueue deadlock/stall observed with XFS


A few words on the status and the future of RT:
-----------------------------------------------

The situation since last years RTLWS (https://lwn.net/Articles/572740/)
has not improved at all, it's worse than before. 

While shortly after RTLWS quite some people promised to whip up proper
funding, nothing has materialized and my personal situation is worse
than before.

I'm really tired of all the politics involved, the blantant lies and
the marketing bullshit which I have to bear. I learned a few month ago
that a certain kernel vendor invented most of RT anyway and is the
expert in this field, so the customers dont have to worry about my
statements.

Just for the record: The initial preempt-RT technology was brought to
you mostly by Ingo Molnar, Steven Rostedt, Paul Mckenney, Peter
Zijlstra and myself with lots of input from Doug Niehaus, who
researched full in kernel preemption already in the 1990s. The
technology rewrite around 3.0-rt was done by me with help from Peter
and Steven, and that's what preempt-RT today is based on.

Sure, people can believe whatever marketing bullshit they want, but
that doesn't make the truth go away. And the truth is, that those who
claim expertise are just a lying bunch of leeches.

What really set me off was the recent blunt question, when I'm going
to quit. What does this mean? Is someone out there just waiting that I
step down as preempt-RT maintainer, so some corporate entity can step
up as the saviour of the Linux RT world? So instead of merily leeching
someone seeks active control over the project. Nice try.

To make it entirely clear: I'm not going to step down, I'm just going
to spend less time on the project adjusted to the very limited funding
I have, simply because I need to work on stuff which pays the bills.

The consequences are obvious:

  - No new features, I'm rather pondering to drop stuff for 3.16-rt
    which is not absolutely required for basic operation just to make
    my life easier.

  - No massive effort to bring preempt-RT upstream

After my last talk about the state of preempt-RT at LinuxCon Japan,
Linus told me: "That was far more depressing than I feared".

The mainline kernel has seen a lot of benefit from the preempt-RT
efforts in the past 10 years and there is a lot more stuff which needs
to be done upstream in order to get preempt-RT fully integrated, which
certainly would improve the general state of the Linux kernel again.

Nothing for the faint hearted, but I have a pretty clear plan about
what needs to be done. Though that's going to be a plan for a long
time and probably obsolete at the point where I have enough spare time
to tackle it - about 15 years from now, when I'm going to retire.

At this point I want to thank all those who funded this effort so
far (RedHat and a few others) and OSADL for their testing efforts.

Enough ranting, give it a good testing,

      Thomas

---
The delta patch against 3.14.10-rt6 is appended below and can be found
here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.14/incr/patch-3.14.10-rt6-rt7.patch.xz

The RT patch against 3.14.10 can be found here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.14/patch-3.14.10-rt7.patch.xz

The split quilt queue is available at:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.14/patches-3.14.10-rt7.tar.xz


Index: linux-stable/kernel/sched/core.c
===================================================================
--- linux-stable.orig/kernel/sched/core.c
+++ linux-stable/kernel/sched/core.c
@@ -1376,12 +1376,6 @@ out:
 		}
 	}
 
-	/*
-	 * Clear PF_NO_SETAFFINITY, otherwise we wreckage
-	 * migrate_disable/enable. See optimization for
-	 * PF_NO_SETAFFINITY tasks there.
-	 */
-	p->flags &= ~PF_NO_SETAFFINITY;
 	return dest_cpu;
 }
 
@@ -2917,9 +2911,8 @@ need_resched:
 
 static inline void sched_submit_work(struct task_struct *tsk)
 {
-	if (!tsk->state || tsk_is_pi_blocked(tsk))
+	if (!tsk->state)
 		return;
-
 	/*
 	 * If a worker went to sleep, notify and ask workqueue whether
 	 * it wants to wake up a task to maintain concurrency.
@@ -2927,6 +2920,10 @@ static inline void sched_submit_work(str
 	if (tsk->flags & PF_WQ_WORKER)
 		wq_worker_sleeping(tsk);
 
+
+	if (tsk_is_pi_blocked(tsk))
+		return;
+
 	/*
 	 * If we are going to sleep and we have plugged IO queued,
 	 * make sure to submit it to avoid deadlocks.
Index: linux-stable/kernel/workqueue.c
===================================================================
--- linux-stable.orig/kernel/workqueue.c
+++ linux-stable/kernel/workqueue.c
@@ -126,6 +126,11 @@ enum {
  *    cpu or grabbing pool->lock is enough for read access.  If
  *    POOL_DISASSOCIATED is set, it's identical to L.
  *
+ *    On RT we need the extra protection via rt_lock_idle_list() for
+ *    the list manipulations against read access from
+ *    wq_worker_sleeping(). All other places are nicely serialized via
+ *    pool->lock.
+ *
  * MG: pool->manager_mutex and pool->lock protected.  Writes require both
  *     locks.  Reads can happen under either lock.
  *
@@ -409,6 +414,31 @@ static void copy_workqueue_attrs(struct
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
@@ -808,10 +838,16 @@ static struct worker *first_worker(struc
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
@@ -839,7 +875,7 @@ void wq_worker_running(struct task_struc
  */
 void wq_worker_sleeping(struct task_struct *task)
 {
-	struct worker *next, *worker = kthread_data(task);
+	struct worker *worker = kthread_data(task);
 	struct worker_pool *pool;
 
 	/*
@@ -856,25 +892,18 @@ void wq_worker_sleeping(struct task_stru
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
@@ -1578,7 +1607,9 @@ static void worker_enter_idle(struct wor
 	worker->last_active = jiffies;
 
 	/* idle_list is LIFO */
+	rt_lock_idle_list(pool);
 	list_add(&worker->entry, &pool->idle_list);
+	rt_unlock_idle_list(pool);
 
 	if (too_many_workers(pool) && !timer_pending(&pool->idle_timer))
 		mod_timer(&pool->idle_timer, jiffies + IDLE_WORKER_TIMEOUT);
@@ -1611,7 +1642,9 @@ static void worker_leave_idle(struct wor
 		return;
 	worker_clr_flags(worker, WORKER_IDLE);
 	pool->nr_idle--;
+	rt_lock_idle_list(pool);
 	list_del_init(&worker->entry);
+	rt_unlock_idle_list(pool);
 }
 
 /**
@@ -1857,7 +1890,9 @@ static void destroy_worker(struct worker
 	 */
 	get_task_struct(worker->task);
 
+	rt_lock_idle_list(pool);
 	list_del_init(&worker->entry);
+	rt_unlock_idle_list(pool);
 	worker->flags |= WORKER_DIE;
 
 	idr_remove(&pool->worker_idr, worker->id);
Index: linux-stable/localversion-rt
===================================================================
--- linux-stable.orig/localversion-rt
+++ linux-stable/localversion-rt
@@ -1 +1 @@
--rt6
+-rt7

