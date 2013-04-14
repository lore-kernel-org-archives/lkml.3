Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023Ab3DNQnT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 12:43:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:7826 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753159Ab3DNQnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 12:43:16 -0400
X-IronPort-AV: E=Sophos;i="4.87,471,1363104000"; 
   d="scan'208";a="7051549"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 6/8] workqueue: make nr_running non-atomic
Date: Mon, 15 Apr 2013 00:41:54 +0800
Message-Id: <1365957716-7631-7-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1365957716-7631-1-git-send-email-laijs@cn.fujitsu.com>
References: <1365957716-7631-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/15 00:41:32,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/15 00:41:32,
	Serialize complete at 2013/04/15 00:41:32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, nr_running is accessed only with local IRQ-disabled and only from local
cpu if the pool is assocated.(execpt read-access in insert_work()).

so we convert it to non-atomic to reduce the overhead of atomic.
It is protected by "LI"

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   49 +++++++++++++++++++++----------------------------
 1 files changed, 21 insertions(+), 28 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 9f1ebdf..25e2e5a 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -150,6 +150,7 @@ struct worker_pool {
 	int			node;		/* I: the associated node ID */
 	int			id;		/* I: pool ID */
 	unsigned int		flags;		/* X: flags */
+	int			nr_running;	/* LI: count for running */
 
 	struct list_head	worklist;	/* L: list of pending works */
 	int			nr_workers;	/* L: total number of workers */
@@ -175,13 +176,6 @@ struct worker_pool {
 	int			refcnt;		/* PL: refcnt for unbound pools */
 
 	/*
-	 * The current concurrency level.  As it's likely to be accessed
-	 * from other CPUs during try_to_wake_up(), put it in a separate
-	 * cacheline.
-	 */
-	atomic_t		nr_running ____cacheline_aligned_in_smp;
-
-	/*
 	 * Destruction of pool is sched-RCU protected to allow dereferences
 	 * from get_work_pool().
 	 */
@@ -700,7 +694,7 @@ static bool work_is_canceling(struct work_struct *work)
 
 static bool __need_more_worker(struct worker_pool *pool)
 {
-	return !atomic_read(&pool->nr_running);
+	return !pool->nr_running;
 }
 
 /*
@@ -725,8 +719,7 @@ static bool may_start_working(struct worker_pool *pool)
 /* Do I need to keep working?  Called from currently running workers. */
 static bool keep_working(struct worker_pool *pool)
 {
-	return !list_empty(&pool->worklist) &&
-		atomic_read(&pool->nr_running) <= 1;
+	return !list_empty(&pool->worklist) && pool->nr_running <= 1;
 }
 
 /* Do we need a new worker?  Called from manager. */
@@ -823,21 +816,24 @@ struct task_struct *wq_worker_sleeping(struct task_struct *task)
 		return NULL;
 
 	/*
-	 * The counterpart of the following dec_and_test, implied mb,
-	 * worklist not empty test sequence is in insert_work().
-	 * Please read comment there.
-	 *
 	 * NOT_RUNNING is clear.  This means that we're bound to and
 	 * running on the local cpu w/ rq lock held and preemption/irq
 	 * disabled, which in turn means that none else could be
 	 * manipulating idle_list, so dereferencing idle_list without pool
 	 * lock is safe. And which in turn also means that we can
-	 * manipulating worker->flags.
+	 * manipulating worker->flags and pool->nr_running.
 	 */
 	worker->flags |= WORKER_QUIT_CM;
-	if (atomic_dec_and_test(&pool->nr_running) &&
-	    !list_empty(&pool->worklist))
-		to_wakeup = first_worker(pool);
+	if (--pool->nr_running == 0) {
+		/*
+		 * This smp_mb() forces a mb between decreasing nr_running
+		 * and reading worklist. It paires with the smp_mb() in
+		 * insert_work(). Please read comment there.
+		 */
+		smp_mb();
+		if (!list_empty(&pool->worklist))
+			to_wakeup = first_worker(pool);
+	}
 	return to_wakeup ? to_wakeup->task : NULL;
 }
 
@@ -868,12 +864,10 @@ static inline void worker_set_flags(struct worker *worker, unsigned int flags,
 	 */
 	if ((flags & WORKER_NOT_RUNNING) &&
 	    !(worker->flags & WORKER_NOT_RUNNING)) {
-		if (wakeup) {
-			if (atomic_dec_and_test(&pool->nr_running) &&
-			    !list_empty(&pool->worklist))
-				wake_up_worker(pool);
-		} else
-			atomic_dec(&pool->nr_running);
+		pool->nr_running--;
+		if (wakeup && !pool->nr_running &&
+		    !list_empty(&pool->worklist))
+			wake_up_worker(pool);
 	}
 
 	worker->flags |= flags;
@@ -905,7 +899,7 @@ static inline void worker_clr_flags(struct worker *worker, unsigned int flags)
 	 */
 	if ((flags & WORKER_NOT_RUNNING) && (oflags & WORKER_NOT_RUNNING))
 		if (!(worker->flags & WORKER_NOT_RUNNING))
-			atomic_inc(&pool->nr_running);
+			pool->nr_running++;
 }
 
 /**
@@ -1544,8 +1538,7 @@ static void worker_enter_idle(struct worker *worker)
 		mod_timer(&pool->idle_timer, jiffies + IDLE_WORKER_TIMEOUT);
 
 	/* Sanity check nr_running. */
-	WARN_ON_ONCE(pool->nr_workers == pool->nr_idle &&
-		     atomic_read(&pool->nr_running));
+	WARN_ON_ONCE(pool->nr_workers == pool->nr_idle && pool->nr_running);
 }
 
 /**
@@ -4365,7 +4358,7 @@ static void wq_unbind_fn(struct work_struct *work)
 		 * behaves as an unbound (in terms of concurrency management)
 		 * pool which are served by workers tied to the pool.
 		 */
-		atomic_set(&pool->nr_running, 0);
+		pool->nr_running = 0;
 
 		/*
 		 * With concurrency management just turned off, a busy
-- 
1.7.7.6

