Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934070AbaGQPZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 11:25:40 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:2868 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932865AbaGQPZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 11:25:39 -0400
Date: Thu, 17 Jul 2014 11:25:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [ANNOUNCE] 3.10.47-rt50
Message-ID: <20140717112537.4c5c788b@gandalf.local.home>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.10.47-rt50 stable release.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  branch: v3.10-rt
  Head SHA1: e3da1bcd99e16a543662eec9292f66bd89d94fc1


Or to build 3.10.47-rt50 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.10.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.10.47.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.10/patch-3.10.47-rt50.patch.xz



You can also build from 3.10.47-rt49 by applying the incremental patch:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.10/incr/patch-3.10.47-rt49-rt50.patch.xz



Enjoy,

-- Steve


Changes from v3.10.47-rt49:

---

Steven Rostedt (1):
      sched: Do not clear PF_NO_SETAFFINITY flag in select_fallback_rq()

Steven Rostedt (Red Hat) (1):
      Linux 3.10.47-rt50

Thomas Gleixner (1):
      workqueue: Prevent deadlock/stall on RT

----
 kernel/sched/core.c | 13 +++++-------
 kernel/workqueue.c  | 61 +++++++++++++++++++++++++++++++++++++++++------------
 localversion-rt     |  2 +-
 3 files changed, 54 insertions(+), 22 deletions(-)
---------------------------
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a060a092e92b..f7aa4ca0cedb 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1289,12 +1289,6 @@ out:
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
 
@@ -3223,9 +3217,8 @@ need_resched:
 
 static inline void sched_submit_work(struct task_struct *tsk)
 {
-	if (!tsk->state || tsk_is_pi_blocked(tsk))
+	if (!tsk->state)
 		return;
-
 	/*
 	 * If a worker went to sleep, notify and ask workqueue whether
 	 * it wants to wake up a task to maintain concurrency.
@@ -3233,6 +3226,10 @@ static inline void sched_submit_work(struct task_struct *tsk)
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
index 318c86593597..8f080af2d863 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -125,6 +125,11 @@ enum {
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
@@ -395,6 +400,31 @@ static void copy_workqueue_attrs(struct workqueue_attrs *to,
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
@@ -785,10 +815,16 @@ static struct worker *first_worker(struct worker_pool *pool)
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
@@ -816,7 +852,7 @@ void wq_worker_running(struct task_struct *task)
  */
 void wq_worker_sleeping(struct task_struct *task)
 {
-	struct worker *next, *worker = kthread_data(task);
+	struct worker *worker = kthread_data(task);
 	struct worker_pool *pool;
 
 	/*
@@ -833,25 +869,18 @@ void wq_worker_sleeping(struct task_struct *task)
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
@@ -1553,7 +1582,9 @@ static void worker_enter_idle(struct worker *worker)
 	worker->last_active = jiffies;
 
 	/* idle_list is LIFO */
+	rt_lock_idle_list(pool);
 	list_add(&worker->entry, &pool->idle_list);
+	rt_unlock_idle_list(pool);
 
 	if (too_many_workers(pool) && !timer_pending(&pool->idle_timer))
 		mod_timer(&pool->idle_timer, jiffies + IDLE_WORKER_TIMEOUT);
@@ -1586,7 +1617,9 @@ static void worker_leave_idle(struct worker *worker)
 		return;
 	worker_clr_flags(worker, WORKER_IDLE);
 	pool->nr_idle--;
+	rt_lock_idle_list(pool);
 	list_del_init(&worker->entry);
+	rt_unlock_idle_list(pool);
 }
 
 /**
@@ -1829,7 +1862,9 @@ static void destroy_worker(struct worker *worker)
 	 */
 	get_task_struct(worker->task);
 
+	rt_lock_idle_list(pool);
 	list_del_init(&worker->entry);
+	rt_unlock_idle_list(pool);
 	worker->flags |= WORKER_DIE;
 
 	idr_remove(&pool->worker_idr, worker->id);
diff --git a/localversion-rt b/localversion-rt
index 4b7dca68a5b4..42c384668389 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt49
+-rt50
