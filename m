Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab3DNQsj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 12:48:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:15897 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752117Ab3DNQsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 12:48:38 -0400
X-IronPort-AV: E=Sophos;i="4.87,471,1363104000"; 
   d="scan'208";a="7051551"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 8/8] workqueue: rename ->nr_running to ->nr_cm_workers
Date: Mon, 15 Apr 2013 00:41:56 +0800
Message-Id: <1365957716-7631-9-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1365957716-7631-1-git-send-email-laijs@cn.fujitsu.com>
References: <1365957716-7631-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/15 00:41:47,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/15 00:41:47,
	Serialize complete at 2013/04/15 00:41:47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nr_running is not a good name, the reviewers may think they are non-sleeping
busy workers. nr_running is actually a counter for concurrency managed
workers. renaming it to nr_cm_workers would be better.

s/nr_running/nr_cm_workers/
s/NOT_RUNNING/NOT_CM/
manually tune a little(indent and the comment for nr_cm_workers)

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   69 +++++++++++++++++++++++++--------------------------
 1 files changed, 34 insertions(+), 35 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 25e2e5a..25e028c 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -80,7 +80,7 @@ enum {
 	WORKER_UNBOUND		= 1 << 7,	/* worker is unbound */
 	WORKER_REBOUND		= 1 << 8,	/* worker was rebound */
 
-	WORKER_NOT_RUNNING	= WORKER_PREP | WORKER_QUIT_CM |
+	WORKER_NOT_CM		= WORKER_PREP | WORKER_QUIT_CM |
 				  WORKER_CPU_INTENSIVE |
 				  WORKER_UNBOUND | WORKER_REBOUND,
 
@@ -150,7 +150,7 @@ struct worker_pool {
 	int			node;		/* I: the associated node ID */
 	int			id;		/* I: pool ID */
 	unsigned int		flags;		/* X: flags */
-	int			nr_running;	/* LI: count for running */
+	int			nr_cm_workers;	/* LI: count for cm workers */
 
 	struct list_head	worklist;	/* L: list of pending works */
 	int			nr_workers;	/* L: total number of workers */
@@ -694,14 +694,14 @@ static bool work_is_canceling(struct work_struct *work)
 
 static bool __need_more_worker(struct worker_pool *pool)
 {
-	return !pool->nr_running;
+	return !pool->nr_cm_workers;
 }
 
 /*
  * Need to wake up a worker?  Called from anything but currently
  * running workers.
  *
- * Note that, because unbound workers never contribute to nr_running, this
+ * Note that, because unbound workers never contribute to nr_cm_workers, this
  * function will always return %true for unbound pools as long as the
  * worklist isn't empty.
  */
@@ -719,7 +719,7 @@ static bool may_start_working(struct worker_pool *pool)
 /* Do I need to keep working?  Called from currently running workers. */
 static bool keep_working(struct worker_pool *pool)
 {
-	return !list_empty(&pool->worklist) && pool->nr_running <= 1;
+	return !list_empty(&pool->worklist) && pool->nr_cm_workers <= 1;
 }
 
 /* Do we need a new worker?  Called from manager. */
@@ -804,9 +804,9 @@ struct task_struct *wq_worker_sleeping(struct task_struct *task)
 	/*
 	 * Rescuers, which may not have all the fields set up like normal
 	 * workers, also reach here, let's not access anything before
-	 * checking NOT_RUNNING.
+	 * checking NOT_CM.
 	 */
-	if (worker->flags & WORKER_NOT_RUNNING)
+	if (worker->flags & WORKER_NOT_CM)
 		return NULL;
 
 	pool = worker->pool;
@@ -816,17 +816,17 @@ struct task_struct *wq_worker_sleeping(struct task_struct *task)
 		return NULL;
 
 	/*
-	 * NOT_RUNNING is clear.  This means that we're bound to and
+	 * NOT_CM is clear.  This means that we're bound to and
 	 * running on the local cpu w/ rq lock held and preemption/irq
 	 * disabled, which in turn means that none else could be
 	 * manipulating idle_list, so dereferencing idle_list without pool
 	 * lock is safe. And which in turn also means that we can
-	 * manipulating worker->flags and pool->nr_running.
+	 * manipulating worker->flags and pool->nr_cm_workers.
 	 */
 	worker->flags |= WORKER_QUIT_CM;
-	if (--pool->nr_running == 0) {
+	if (--pool->nr_cm_workers == 0) {
 		/*
-		 * This smp_mb() forces a mb between decreasing nr_running
+		 * This smp_mb() forces a mb between decreasing nr_cm_workers
 		 * and reading worklist. It paires with the smp_mb() in
 		 * insert_work(). Please read comment there.
 		 */
@@ -838,13 +838,13 @@ struct task_struct *wq_worker_sleeping(struct task_struct *task)
 }
 
 /**
- * worker_set_flags - set worker flags and adjust nr_running accordingly
+ * worker_set_flags - set worker flags and adjust nr_cm_workers accordingly
  * @worker: self
  * @flags: flags to set
  * @wakeup: wakeup an idle worker if necessary
  *
- * Set @flags in @worker->flags and adjust nr_running accordingly.  If
- * nr_running becomes zero and @wakeup is %true, an idle worker is
+ * Set @flags in @worker->flags and adjust nr_cm_workers accordingly.  If
+ * nr_cm_workers becomes zero and @wakeup is %true, an idle worker is
  * woken up.
  *
  * CONTEXT:
@@ -858,14 +858,13 @@ static inline void worker_set_flags(struct worker *worker, unsigned int flags,
 	WARN_ON_ONCE(worker->task != current);
 
 	/*
-	 * If transitioning into NOT_RUNNING, adjust nr_running and
+	 * If transitioning into NOT_CM, adjust nr_cm_workers and
 	 * wake up an idle worker as necessary if requested by
 	 * @wakeup.
 	 */
-	if ((flags & WORKER_NOT_RUNNING) &&
-	    !(worker->flags & WORKER_NOT_RUNNING)) {
-		pool->nr_running--;
-		if (wakeup && !pool->nr_running &&
+	if ((flags & WORKER_NOT_CM) && !(worker->flags & WORKER_NOT_CM)) {
+		pool->nr_cm_workers--;
+		if (wakeup && !pool->nr_cm_workers &&
 		    !list_empty(&pool->worklist))
 			wake_up_worker(pool);
 	}
@@ -874,11 +873,11 @@ static inline void worker_set_flags(struct worker *worker, unsigned int flags,
 }
 
 /**
- * worker_clr_flags - clear worker flags and adjust nr_running accordingly
+ * worker_clr_flags - clear worker flags and adjust nr_cm_workers accordingly
  * @worker: self
  * @flags: flags to clear
  *
- * Clear @flags in @worker->flags and adjust nr_running accordingly.
+ * Clear @flags in @worker->flags and adjust nr_cm_workers accordingly.
  *
  * CONTEXT:
  * spin_lock_irq(pool->lock)
@@ -893,13 +892,13 @@ static inline void worker_clr_flags(struct worker *worker, unsigned int flags)
 	worker->flags &= ~flags;
 
 	/*
-	 * If transitioning out of NOT_RUNNING, increment nr_running.  Note
-	 * that the nested NOT_RUNNING is not a noop.  NOT_RUNNING is mask
+	 * If transitioning out of NOT_CM, increment nr_cm_workers.  Note
+	 * that the nested NOT_CM is not a noop.  NOT_CM is mask
 	 * of multiple flags, not a single flag.
 	 */
-	if ((flags & WORKER_NOT_RUNNING) && (oflags & WORKER_NOT_RUNNING))
-		if (!(worker->flags & WORKER_NOT_RUNNING))
-			pool->nr_running++;
+	if ((flags & WORKER_NOT_CM) && (oflags & WORKER_NOT_CM))
+		if (!(worker->flags & WORKER_NOT_CM))
+			pool->nr_cm_workers++;
 }
 
 /**
@@ -1237,7 +1236,7 @@ static void insert_work(struct pool_workqueue *pwq, struct work_struct *work,
 
 	/*
 	 * Ensure either wq_worker_sleeping() sees the above
-	 * list_add_tail() or we see zero nr_running to avoid workers lying
+	 * list_add_tail() or we see zero nr_cm_workers to avoid workers lying
 	 * around lazily while there are works to be processed.
 	 */
 	smp_mb();
@@ -1537,8 +1536,8 @@ static void worker_enter_idle(struct worker *worker)
 	if (too_many_workers(pool) && !timer_pending(&pool->idle_timer))
 		mod_timer(&pool->idle_timer, jiffies + IDLE_WORKER_TIMEOUT);
 
-	/* Sanity check nr_running. */
-	WARN_ON_ONCE(pool->nr_workers == pool->nr_idle && pool->nr_running);
+	/* Sanity check nr_cm_workers. */
+	WARN_ON_ONCE(pool->nr_workers == pool->nr_idle && pool->nr_cm_workers);
 }
 
 /**
@@ -2342,7 +2341,7 @@ repeat:
 	spin_unlock_irq(&wq_mayday_lock);
 
 	/* rescuers should never participate in concurrency management */
-	WARN_ON_ONCE(!(rescuer->flags & WORKER_NOT_RUNNING));
+	WARN_ON_ONCE(!(rescuer->flags & WORKER_NOT_CM));
 	schedule();
 	goto repeat;
 }
@@ -4352,13 +4351,13 @@ static void wq_unbind_fn(struct work_struct *work)
 		pool->flags |= POOL_DISASSOCIATED;
 
 		/*
-		 * Zap nr_running. After this, nr_running stays zero
+		 * Zap nr_cm_workers. After this, nr_cm_workers stays zero
 		 * and need_more_worker() and keep_working() are always true
 		 * as long as the worklist is not empty.  This pool now
 		 * behaves as an unbound (in terms of concurrency management)
 		 * pool which are served by workers tied to the pool.
 		 */
-		pool->nr_running = 0;
+		pool->nr_cm_workers = 0;
 
 		/*
 		 * With concurrency management just turned off, a busy
@@ -4413,8 +4412,8 @@ static void rebind_workers(struct worker_pool *pool)
 
 		/*
 		 * We want to clear UNBOUND but can't directly call
-		 * worker_clr_flags() or adjust nr_running.  Atomically
-		 * replace UNBOUND with another NOT_RUNNING flag REBOUND.
+		 * worker_clr_flags() or adjust nr_cm_workers.  Atomically
+		 * replace UNBOUND with another NOT_CM flag REBOUND.
 		 * @worker will clear REBOUND using worker_clr_flags() when
 		 * it initiates the next execution cycle thus restoring
 		 * concurrency management.  Note that when or whether
@@ -4423,7 +4422,7 @@ static void rebind_workers(struct worker_pool *pool)
 		 * Current CPU may not the cpu of this rebinding pool,
 		 * ACCESS_ONCE() is necessary because @worker->flags may be
 		 * tested without holding any lock in
-		 * wq_worker_sleeping().  Without it, NOT_RUNNING test may
+		 * wq_worker_sleeping().  Without it, NOT_CM test may
 		 * fail incorrectly leading to premature concurrency
 		 * management operations.
 		 */
-- 
1.7.7.6

