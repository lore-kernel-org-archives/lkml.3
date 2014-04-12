Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbaDLKnE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 06:43:04 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:41984 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756086AbaDLKmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 06:42:38 -0400
X-IronPort-AV: E=Sophos;i="4.97,847,1389715200"; 
   d="scan'208";a="29176931"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/6] workqueue: make destroy_worker() atomically
Date: Sat, 12 Apr 2014 18:45:32 +0800
Message-ID: <1397299543-12012-4-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1397299543-12012-1-git-send-email-laijs@cn.fujitsu.com>
References: <1397299543-12012-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

destroy_worker() doesn't need to wait for worker's task exit.
There is no essential things to do after kthread_stop().
So we remove kthread_stop().

put_unbound_pool() needs to wait for workers' tasks exit.
we add a new completion to handle it.

The purpose of this patch is not making the slowpath destroy_worker()
faster, but:
1) allow destroy_worker() to be called in timeout handler in future patch.
2) reduce possible latency for create_worker()/cpu-hotplug.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   32 +++++++++++++++++---------------
 1 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 743917d..6c38aed 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -170,6 +170,10 @@ struct worker_pool {
 	/*
 	 * A worker is bound to the pool, it means:
 	 * 1) the worker's cpumask is bound to the pool.
+	 * 2) the worker gets a reference to the pool. The worker shouldn't
+	 *    access to the pool after the worker is unbound from the pool,
+	 *    except that the worker has another kinds of reference to
+	 *    the pool.
 	 *
 	 * bind_mutex is held in rescuer before processing works,
 	 * so bind_mutex shouldn't have any directly nor indirecty dependency
@@ -177,6 +181,7 @@ struct worker_pool {
 	 */
 	struct mutex		bind_mutex;	/* workers binding */
 	struct list_head	bind_list;	/* B: bound workers*/
+	struct completion	workers_leave;	/* all workers exit */
 
 	struct workqueue_attrs	*attrs;		/* I: worker attributes */
 	struct hlist_node	hash_node;	/* PL: unbound_pool_hash node */
@@ -1668,9 +1673,15 @@ static void bind_worker(struct worker *worker, struct worker_pool *pool)
 
 static void unbind_worker(struct worker *worker, struct worker_pool *pool)
 {
+	bool is_last;
+
 	mutex_lock(&pool->bind_mutex);
 	list_del(&worker->bind_entry);
+	is_last = list_empty(&worker->bind_entry);
 	mutex_unlock(&pool->bind_mutex);
+
+	if (is_last)
+		complete(&pool->workers_leave);
 }
 
 /**
@@ -1828,24 +1839,10 @@ static void destroy_worker(struct worker *worker)
 	if (worker->flags & WORKER_IDLE)
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
 	idr_remove(&pool->worker_idr, worker->id);
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
@@ -2293,6 +2290,7 @@ woke_up:
 		worker->task->flags &= ~PF_WQ_WORKER;
 
 		unbind_worker(worker, pool);
+		kfree(worker);
 		return 0;
 	}
 
@@ -3529,6 +3527,7 @@ static int init_worker_pool(struct worker_pool *pool)
 
 	mutex_init(&pool->bind_mutex);
 	INIT_LIST_HEAD(&pool->bind_list);
+	init_completion(&pool->workers_leave);
 
 	INIT_HLIST_NODE(&pool->hash_node);
 	pool->refcnt = 1;
@@ -3588,6 +3587,7 @@ static void put_unbound_pool(struct worker_pool *pool)
 	mutex_lock(&pool->manager_mutex);
 	spin_lock_irq(&pool->lock);
 
+	WARN_ON(pool->nr_workers != pool->nr_idle);
 	while ((worker = first_worker(pool)))
 		destroy_worker(worker);
 	WARN_ON(pool->nr_workers || pool->nr_idle);
@@ -3596,6 +3596,8 @@ static void put_unbound_pool(struct worker_pool *pool)
 	mutex_unlock(&pool->manager_mutex);
 	mutex_unlock(&pool->manager_arb);
 
+	wait_for_completion(&pool->workers_leave);
+
 	/* shut down the timers */
 	del_timer_sync(&pool->idle_timer);
 	del_timer_sync(&pool->mayday_timer);
-- 
1.7.4.4

