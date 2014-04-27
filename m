Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbaD0EFd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 00:05:33 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:38512 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752684AbaD0EFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 00:05:31 -0400
X-IronPort-AV: E=Sophos;i="4.97,936,1389715200"; 
   d="scan'208";a="29778304"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 03/10] workqueue: async worker destruction
Date: Sun, 27 Apr 2014 12:08:58 +0800
Message-ID: <1398571754-12443-4-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1398571754-12443-1-git-send-email-laijs@cn.fujitsu.com>
References: <1398571754-12443-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

worker destruction includes these parts of code:
	adjust pool's stats
	remove the worker from idle list
	unbind the worker from the pool
	kthread_stop() to wait for the worker's task exit
	free the worker struct

We can find out that there is no essential thing to do after
kthread_stop(). Which means destroy_worker() doesn't need
to wait for the worker's task exit. So we can remove kthread_stop()
and free the worker struct in the worker exiting path.

But put_unbound_pool() still needs to sync the all the workers'
destruction before to destroy the pool. Otherwise the workers
may access to the invalid pool when they are exiting.

So we also move the code of "unbind the worker" to the exiting
path and let put_unbound_pool() to sync with this code via
a wait_queue_head_t workers_unbound.

The code of "unbind the worker" is wrapped in a function "worker_unbind_pool()"

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   44 ++++++++++++++++++++++++++++----------------
 1 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 7690d0c..7ca564d 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -163,6 +163,7 @@ struct worker_pool {
 	struct mutex		manager_arb;	/* manager arbitration */
 	struct mutex		manager_mutex;	/* manager exclusion */
 	struct idr		worker_idr;	/* M: worker IDs and iteration */
+	wait_queue_head_t	workers_unbound;/* all workers pool-unbound */
 
 	struct workqueue_attrs	*attrs;		/* I: worker attributes */
 	struct hlist_node	hash_node;	/* PL: unbound_pool_hash node */
@@ -1688,6 +1689,23 @@ static struct worker *alloc_worker(void)
 }
 
 /**
+ * worker_unbind_pool() - unbind the worker from the pool
+ * @worker: worker which is bound to its pool
+ *
+ * Undo the pool-binding which had been done in create_worker()
+ */
+static void worker_unbind_pool(struct worker *worker)
+{
+	struct worker_pool *pool = worker->pool;
+
+	mutex_lock(&pool->manager_mutex);
+	idr_remove(&pool->worker_idr, worker->id);
+	if (idr_is_empty(&pool->worker_idr))
+		wake_up(&pool->workers_unbound);
+	mutex_unlock(&pool->manager_mutex);
+}
+
+/**
  * create_worker - create a new workqueue worker
  * @pool: pool the new worker will belong to
  *
@@ -1834,24 +1852,9 @@ static void destroy_worker(struct worker *worker)
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
@@ -2290,6 +2293,8 @@ woke_up:
 		spin_unlock_irq(&pool->lock);
 		WARN_ON_ONCE(!list_empty(&worker->entry));
 		worker->task->flags &= ~PF_WQ_WORKER;
+		worker_unbind_pool(worker);
+		kfree(worker);
 		return 0;
 	}
 
@@ -3528,6 +3533,7 @@ static int init_worker_pool(struct worker_pool *pool)
 	mutex_init(&pool->manager_arb);
 	mutex_init(&pool->manager_mutex);
 	idr_init(&pool->worker_idr);
+	init_waitqueue_head(&pool->workers_unbound);
 
 	INIT_HLIST_NODE(&pool->hash_node);
 	pool->refcnt = 1;
@@ -3593,6 +3599,12 @@ static void put_unbound_pool(struct worker_pool *pool)
 	WARN_ON(pool->nr_workers || pool->nr_idle);
 
 	spin_unlock_irq(&pool->lock);
+
+	wait_event_cmd(pool->workers_unbound,
+		       idr_is_empty(&pool->worker_idr),
+		       mutex_unlock(&pool->manager_mutex),
+		       mutex_lock(&pool->manager_mutex));
+
 	mutex_unlock(&pool->manager_mutex);
 	mutex_unlock(&pool->manager_arb);
 
-- 
1.7.4.4

