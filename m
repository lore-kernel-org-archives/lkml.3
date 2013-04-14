Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab3DNQnD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 12:43:03 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:32114 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752311Ab3DNQm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 12:42:59 -0400
X-IronPort-AV: E=Sophos;i="4.87,471,1363104000"; 
   d="scan'208";a="7051548"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 5/8] workqueue: remove disabled wq_worker_waking_up()
Date: Mon, 15 Apr 2013 00:41:53 +0800
Message-Id: <1365957716-7631-6-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1365957716-7631-1-git-send-email-laijs@cn.fujitsu.com>
References: <1365957716-7631-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/15 00:41:31,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/15 00:41:31,
	Serialize complete at 2013/04/15 00:41:31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a worker is sleeping, its flags has WORKER_QUIT_CM, which means
worker->flags & WORKER_NOT_RUNNING is always non-zero, and which means
wq_worker_waking_up() is disabled.

so we removed wq_worker_waking_up(). (the access to worker->flags
in wq_worker_waking_up() is not protected by "LI". after this, it is alwasy
protected by "LI")

The patch also do these changes after removal:
1) because wq_worker_waking_up() is removed, we don't need schedule()
   before zapping nr_running in wq_unbind_fn(), and don't need to
   release/regain pool->lock.
2) the sanity check in worker_enter_idle() is changed to also check for
   unbound/disassociated pools. (because the above change and nr_running
   is expected always reliable in worker_enter_idle() now.)

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/sched/core.c         |    4 ---
 kernel/workqueue.c          |   58 +++++++-----------------------------------
 kernel/workqueue_internal.h |    3 +-
 3 files changed, 11 insertions(+), 54 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ffc06ad..18f95884 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1276,10 +1276,6 @@ static void ttwu_activate(struct rq *rq, struct task_struct *p, int en_flags)
 {
 	activate_task(rq, p, en_flags);
 	p->on_rq = 1;
-
-	/* if a worker is waking up, notify workqueue */
-	if (p->flags & PF_WQ_WORKER)
-		wq_worker_waking_up(p, cpu_of(rq));
 }
 
 /*
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 668e9b7..9f1ebdf 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -790,27 +790,6 @@ static void wake_up_worker(struct worker_pool *pool)
 }
 
 /**
- * wq_worker_waking_up - a worker is waking up
- * @task: task waking up
- * @cpu: CPU @task is waking up to
- *
- * This function is called during try_to_wake_up() when a worker is
- * being awoken.
- *
- * CONTEXT:
- * spin_lock_irq(rq->lock)
- */
-void wq_worker_waking_up(struct task_struct *task, int cpu)
-{
-	struct worker *worker = kthread_data(task);
-
-	if (!(worker->flags & WORKER_NOT_RUNNING)) {
-		WARN_ON_ONCE(worker->pool->cpu != cpu);
-		atomic_inc(&worker->pool->nr_running);
-	}
-}
-
-/**
  * wq_worker_sleeping - a worker is going to sleep
  * @task: task going to sleep
  *
@@ -1564,14 +1543,8 @@ static void worker_enter_idle(struct worker *worker)
 	if (too_many_workers(pool) && !timer_pending(&pool->idle_timer))
 		mod_timer(&pool->idle_timer, jiffies + IDLE_WORKER_TIMEOUT);
 
-	/*
-	 * Sanity check nr_running.  Because wq_unbind_fn() releases
-	 * pool->lock between setting %WORKER_UNBOUND and zapping
-	 * nr_running, the warning may trigger spuriously.  Check iff
-	 * unbind is not in progress.
-	 */
-	WARN_ON_ONCE(!(pool->flags & POOL_DISASSOCIATED) &&
-		     pool->nr_workers == pool->nr_idle &&
+	/* Sanity check nr_running. */
+	WARN_ON_ONCE(pool->nr_workers == pool->nr_idle &&
 		     atomic_read(&pool->nr_running));
 }
 
@@ -4385,24 +4358,12 @@ static void wq_unbind_fn(struct work_struct *work)
 
 		pool->flags |= POOL_DISASSOCIATED;
 
-		spin_unlock_irq(&pool->lock);
-		mutex_unlock(&pool->manager_mutex);
-
 		/*
-		 * Call schedule() so that we cross rq->lock and thus can
-		 * guarantee sched callbacks see the %WORKER_UNBOUND flag.
-		 * This is necessary as scheduler callbacks may be invoked
-		 * from other cpus.
-		 */
-		schedule();
-
-		/*
-		 * Sched callbacks are disabled now.  Zap nr_running.
-		 * After this, nr_running stays zero and need_more_worker()
-		 * and keep_working() are always true as long as the
-		 * worklist is not empty.  This pool now behaves as an
-		 * unbound (in terms of concurrency management) pool which
-		 * are served by workers tied to the pool.
+		 * Zap nr_running. After this, nr_running stays zero
+		 * and need_more_worker() and keep_working() are always true
+		 * as long as the worklist is not empty.  This pool now
+		 * behaves as an unbound (in terms of concurrency management)
+		 * pool which are served by workers tied to the pool.
 		 */
 		atomic_set(&pool->nr_running, 0);
 
@@ -4411,9 +4372,9 @@ static void wq_unbind_fn(struct work_struct *work)
 		 * worker blocking could lead to lengthy stalls.  Kick off
 		 * unbound chain execution of currently pending work items.
 		 */
-		spin_lock_irq(&pool->lock);
 		wake_up_worker(pool);
 		spin_unlock_irq(&pool->lock);
+		mutex_unlock(&pool->manager_mutex);
 	}
 }
 
@@ -4466,9 +4427,10 @@ static void rebind_workers(struct worker_pool *pool)
 		 * concurrency management.  Note that when or whether
 		 * @worker clears REBOUND doesn't affect correctness.
 		 *
+		 * Current CPU may not the cpu of this rebinding pool,
 		 * ACCESS_ONCE() is necessary because @worker->flags may be
 		 * tested without holding any lock in
-		 * wq_worker_waking_up().  Without it, NOT_RUNNING test may
+		 * wq_worker_sleeping().  Without it, NOT_RUNNING test may
 		 * fail incorrectly leading to premature concurrency
 		 * management operations.
 		 */
diff --git a/kernel/workqueue_internal.h b/kernel/workqueue_internal.h
index 1713ae7..e9fd05f 100644
--- a/kernel/workqueue_internal.h
+++ b/kernel/workqueue_internal.h
@@ -54,9 +54,8 @@ static inline struct worker *current_wq_worker(void)
 
 /*
  * Scheduler hooks for concurrency managed workqueue.  Only to be used from
- * sched.c and workqueue.c.
+ * kernel/sched/core.c and kernel/workqueue.c.
  */
-void wq_worker_waking_up(struct task_struct *task, int cpu);
 struct task_struct *wq_worker_sleeping(struct task_struct *task);
 
 #endif /* _KERNEL_WORKQUEUE_INTERNAL_H */
-- 
1.7.7.6

