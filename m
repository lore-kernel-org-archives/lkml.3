Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760AbaGJQAX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 12:00:23 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:60630 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753425AbaGJQAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 12:00:21 -0400
X-IronPort-AV: E=Sophos;i="5.00,869,1396972800"; 
   d="scan'208";a="33107681"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 3/3] workqueue: unfold start_worker() into create_worker()
Date: Fri, 11 Jul 2014 00:01:05 +0800
Message-ID: <1405008074-11031-4-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1405008074-11031-1-git-send-email-laijs@cn.fujitsu.com>
References: <1405008074-11031-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simply unfold the code of start_worker() into create_worker() and
remove the original start_worker() and create_and_start_worker().

maybe_create_worker() also becomes decently shorter.

The only trade-off is the introduced overhead that the pool->lock
is released and regrabbed after the newly worker is started.
The overhead is acceptible since the manager is slow path.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   68 ++++++++++------------------------------------------
 1 files changed, 13 insertions(+), 55 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 4fdd6d0..c820057 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1553,7 +1553,7 @@ static void worker_enter_idle(struct worker *worker)
 			 (worker->hentry.next || worker->hentry.pprev)))
 		return;
 
-	/* can't use worker_set_flags(), also called from start_worker() */
+	/* can't use worker_set_flags(), also called from create_worker() */
 	worker->flags |= WORKER_IDLE;
 	pool->nr_idle++;
 	worker->last_active = jiffies;
@@ -1674,8 +1674,7 @@ static void worker_detach_from_pool(struct worker *worker,
  * create_worker - create a new workqueue worker
  * @pool: pool the new worker will belong to
  *
- * Create a new worker which is attached to @pool.  The new worker must be
- * started by start_worker().
+ * Create and start a new worker which is attached to @pool.
  *
  * CONTEXT:
  * Might sleep.  Does GFP_KERNEL allocations.
@@ -1720,6 +1719,13 @@ static struct worker *create_worker(struct worker_pool *pool)
 	/* successful, attach the worker to the pool */
 	worker_attach_to_pool(worker, pool);
 
+	/* start the newly created worker */
+	spin_lock_irq(&pool->lock);
+	worker->pool->nr_workers++;
+	worker_enter_idle(worker);
+	wake_up_process(worker->task);
+	spin_unlock_irq(&pool->lock);
+
 	return worker;
 
 fail:
@@ -1730,44 +1736,6 @@ fail:
 }
 
 /**
- * start_worker - start a newly created worker
- * @worker: worker to start
- *
- * Make the pool aware of @worker and start it.
- *
- * CONTEXT:
- * spin_lock_irq(pool->lock).
- */
-static void start_worker(struct worker *worker)
-{
-	worker->pool->nr_workers++;
-	worker_enter_idle(worker);
-	wake_up_process(worker->task);
-}
-
-/**
- * create_and_start_worker - create and start a worker for a pool
- * @pool: the target pool
- *
- * Grab the managership of @pool and create and start a new worker for it.
- *
- * Return: 0 on success. A negative error code otherwise.
- */
-static int create_and_start_worker(struct worker_pool *pool)
-{
-	struct worker *worker;
-
-	worker = create_worker(pool);
-	if (worker) {
-		spin_lock_irq(&pool->lock);
-		start_worker(worker);
-		spin_unlock_irq(&pool->lock);
-	}
-
-	return worker ? 0 : -ENOMEM;
-}
-
-/**
  * destroy_worker - destroy a workqueue worker
  * @worker: worker to be destroyed
  *
@@ -1895,22 +1863,12 @@ static void maybe_create_worker(struct worker_pool *pool)
 __releases(&pool->lock)
 __acquires(&pool->lock)
 {
-	struct worker *worker;
-
 	spin_unlock_irq(&pool->lock);
 
 	/* if we don't make progress in MAYDAY_INITIAL_TIMEOUT, call for help */
 	mod_timer(&pool->mayday_timer, jiffies + MAYDAY_INITIAL_TIMEOUT);
 
-	worker = create_worker(pool);
-	if (worker) {
-		del_timer_sync(&pool->mayday_timer);
-		spin_lock_irq(&pool->lock);
-		start_worker(worker);
-		return;
-	}
-
-	if (need_to_create_worker(pool))
+	if (!create_worker(pool) && need_to_create_worker(pool))
 		schedule_timeout_interruptible(CREATE_COOLDOWN);
 
 	del_timer_sync(&pool->mayday_timer);
@@ -3524,7 +3482,7 @@ static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
 		goto fail;
 
 	/* create and start the initial worker */
-	if (create_and_start_worker(pool) < 0)
+	if (!create_worker(pool))
 		goto fail;
 
 	/* install */
@@ -4598,7 +4556,7 @@ static int workqueue_cpu_up_callback(struct notifier_block *nfb,
 		for_each_cpu_worker_pool(pool, cpu) {
 			if (pool->nr_workers)
 				continue;
-			if (create_and_start_worker(pool) < 0)
+			if (!create_worker(pool))
 				return NOTIFY_BAD;
 		}
 		break;
@@ -4898,7 +4856,7 @@ static int __init init_workqueues(void)
 
 		for_each_cpu_worker_pool(pool, cpu) {
 			pool->flags &= ~POOL_DISASSOCIATED;
-			BUG_ON(create_and_start_worker(pool) < 0);
+			BUG_ON(!create_worker(pool));
 		}
 	}
 
-- 
1.7.4.4

