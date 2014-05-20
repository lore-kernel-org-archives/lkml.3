Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbaETJnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 05:43:00 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:32565 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751461AbaETJmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 05:42:43 -0400
X-IronPort-AV: E=Sophos;i="4.98,873,1392134400"; 
   d="scan'208";a="30762563"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH V3 03/10] workqueue: async worker destruction
Date: Tue, 20 May 2014 17:46:29 +0800
Message-ID: <1400579204-3647-4-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1400579204-3647-1-git-send-email-laijs@cn.fujitsu.com>
References: <1399877792-13046-1-git-send-email-laijs@cn.fujitsu.com>
 <1400579204-3647-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

worker destruction includes these parts of code:
	adjust pool's stats
	remove the worker from idle list
	detach the worker from the pool
	kthread_stop() to wait for the worker's task exit
	free the worker struct

We can find out that there is no essential work to do after
kthread_stop(). Which means destroy_worker() doesn't need
to wait for the worker's task exit. So we can remove kthread_stop()
and free the worker struct in the worker exiting path.

But put_unbound_pool() still needs to sync the all the workers'
destruction before to destroy the pool. Otherwise the workers
may access to the invalid pool when they are exiting.

So we also move the code of "detach the worker" to the exiting
path and let put_unbound_pool() to sync with this code via
detach_completion.

The code of "detach the worker" is wrapped in a new function
"worker_detach_from_pool()". Although worker_detach_from_pool() is only
called once (in worker_thread()) after this patch, but we need to
wrap it for these reasons:
  1) The code of "detach the worker" is not short enough to unfold them
     in worker_thread().
  2) the name of "worker_detach_from_pool()" is self-comment, and we add
     some comments above the function.
  3) it will be shared by rescuer in later patch which allows rescuer
     and normal thread use the same attach/detach frameworks.

And the worker id is freed when detaching which happens
before the worker is fully dead. But this id of the dying worker
may be re-used for a new worker. So the dying worker's task name
is changed to "worker/dying" to avoid two or several workers
having the same name.

Since "detach the worker" is moved out from destroy_worker(),
destroy_worker() doesn't require manager_mutex.
So the "lockdep_assert_held(&pool->manager_mutex)" in destroy_worker()
is removed, and destroy_worker() is not protected by manager_mutex
in put_unbound_pool().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   62 ++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 41 insertions(+), 21 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 862b7ba..98d04a4 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -163,6 +163,7 @@ struct worker_pool {
 	struct mutex		manager_arb;	/* manager arbitration */
 	struct mutex		manager_mutex;	/* manager exclusion */
 	struct idr		worker_idr;	/* M: worker IDs and iteration */
+	struct completion	*detach_completion; /* all workers detached */
 
 	struct workqueue_attrs	*attrs;		/* I: worker attributes */
 	struct hlist_node	hash_node;	/* PL: unbound_pool_hash node */
@@ -1688,6 +1689,30 @@ static struct worker *alloc_worker(void)
 }
 
 /**
+ * worker_detach_from_pool() - detach the worker from the pool
+ * @worker: worker which is attached to its pool
+ * @pool: attached pool
+ *
+ * Undo the attaching which had been done in create_worker().
+ * The caller worker shouldn't access to the pool after detached
+ * except it has other reference to the pool.
+ */
+static void worker_detach_from_pool(struct worker *worker,
+				    struct worker_pool *pool)
+{
+	struct completion *detach_completion = NULL;
+
+	mutex_lock(&pool->manager_mutex);
+	idr_remove(&pool->worker_idr, worker->id);
+	if (idr_is_empty(&pool->worker_idr))
+		detach_completion = pool->detach_completion;
+	mutex_unlock(&pool->manager_mutex);
+
+	if (detach_completion)
+		complete(detach_completion);
+}
+
+/**
  * create_worker - create a new workqueue worker
  * @pool: pool the new worker will belong to
  *
@@ -1815,13 +1840,12 @@ static int create_and_start_worker(struct worker_pool *pool)
  * be idle.
  *
  * CONTEXT:
- * spin_lock_irq(pool->lock) which is released and regrabbed.
+ * spin_lock_irq(pool->lock).
  */
 static void destroy_worker(struct worker *worker)
 {
 	struct worker_pool *pool = worker->pool;
 
-	lockdep_assert_held(&pool->manager_mutex);
 	lockdep_assert_held(&pool->lock);
 
 	/* sanity check frenzy */
@@ -1833,24 +1857,9 @@ static void destroy_worker(struct worker *worker)
 	pool->nr_workers--;
 	pool->nr_idle--;
 
-	/*
-	 * Once WORKER_DIE is set, the kworker may destroy itself at any
-	 * point.  Pin to ensure the task stays until we're done with it.
-	 */
-	get_task_struct(worker->task);
-
 	list_del_init(&worker->entry);
 	worker->flags |= WORKER_DIE;
-
-	idr_remove(&pool->worker_idr, worker->id);
-
-	spin_unlock_irq(&pool->lock);
-
-	kthread_stop(worker->task);
-	put_task_struct(worker->task);
-	kfree(worker);
-
-	spin_lock_irq(&pool->lock);
+	wake_up_process(worker->task);
 }
 
 static void idle_worker_timeout(unsigned long __pool)
@@ -2289,6 +2298,10 @@ woke_up:
 		spin_unlock_irq(&pool->lock);
 		WARN_ON_ONCE(!list_empty(&worker->entry));
 		worker->task->flags &= ~PF_WQ_WORKER;
+
+		set_task_comm(worker->task, "kworker/dying");
+		worker_detach_from_pool(worker, pool);
+		kfree(worker);
 		return 0;
 	}
 
@@ -3560,6 +3573,7 @@ static void rcu_free_pool(struct rcu_head *rcu)
  */
 static void put_unbound_pool(struct worker_pool *pool)
 {
+	DECLARE_COMPLETION_ONSTACK(detach_completion);
 	struct worker *worker;
 
 	lockdep_assert_held(&wq_pool_mutex);
@@ -3583,15 +3597,21 @@ static void put_unbound_pool(struct worker_pool *pool)
 	 * manager_mutex.
 	 */
 	mutex_lock(&pool->manager_arb);
-	mutex_lock(&pool->manager_mutex);
-	spin_lock_irq(&pool->lock);
 
+	spin_lock_irq(&pool->lock);
 	while ((worker = first_worker(pool)))
 		destroy_worker(worker);
 	WARN_ON(pool->nr_workers || pool->nr_idle);
-
 	spin_unlock_irq(&pool->lock);
+
+	mutex_lock(&pool->manager_mutex);
+	if (!idr_is_empty(&pool->worker_idr))
+		pool->detach_completion = &detach_completion;
 	mutex_unlock(&pool->manager_mutex);
+
+	if (pool->detach_completion)
+		wait_for_completion(pool->detach_completion);
+
 	mutex_unlock(&pool->manager_arb);
 
 	/* shut down the timers */
-- 
1.7.4.4

