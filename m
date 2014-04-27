Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbaD0EHY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 00:07:24 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:49199 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752976AbaD0EFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 00:05:54 -0400
X-IronPort-AV: E=Sophos;i="4.97,936,1389715200"; 
   d="scan'208";a="29778317"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 06/10] workqueue: convert worker_idr to worker_ida
Date: Sun, 27 Apr 2014 12:09:01 +0800
Message-ID: <1398571754-12443-7-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1398571754-12443-1-git-send-email-laijs@cn.fujitsu.com>
References: <1398571754-12443-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to travell workers via worker_idr, worker_idr is
used for allocating/freeing ID only, so we convert it to
worker_ida.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 0eae42c..7a181ce 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -161,10 +161,11 @@ struct worker_pool {
 	/* see manage_workers() for details on the two manager mutexes */
 	struct mutex		manager_arb;	/* manager arbitration */
 	struct mutex		manager_mutex;	/* manager exclusion */
-	struct idr		worker_idr;	/* M: worker IDs */
 	struct list_head	bind_list;	/* M: pool-bound workers */
 	wait_queue_head_t	workers_unbound;/* all workers pool-unbound */
 
+	struct ida		worker_ida;	/* worker IDs for task name */
+
 	struct workqueue_attrs	*attrs;		/* I: worker attributes */
 	struct hlist_node	hash_node;	/* PL: unbound_pool_hash node */
 	int			refcnt;		/* PL: refcnt for unbound pools */
@@ -1677,7 +1678,6 @@ static void worker_unbind_pool(struct worker *worker)
 	struct worker_pool *pool = worker->pool;
 
 	mutex_lock(&pool->manager_mutex);
-	idr_remove(&pool->worker_idr, worker->id);
 	list_del(&worker->bind_entry);
 	if (list_empty(&pool->bind_list))
 		wake_up(&pool->workers_unbound);
@@ -1705,11 +1705,8 @@ static struct worker *create_worker(struct worker_pool *pool)
 
 	lockdep_assert_held(&pool->manager_mutex);
 
-	/*
-	 * ID is needed to determine kthread name.  Allocate ID first
-	 * without installing the pointer.
-	 */
-	id = idr_alloc(&pool->worker_idr, NULL, 0, 0, GFP_KERNEL);
+	/* ID is needed to determine kthread name. */
+	id = ida_simple_get(&pool->worker_ida, 0, 0, GFP_KERNEL);
 	if (id < 0)
 		goto fail;
 
@@ -1750,15 +1747,14 @@ static struct worker *create_worker(struct worker_pool *pool)
 	if (pool->flags & POOL_DISASSOCIATED)
 		worker->flags |= WORKER_UNBOUND;
 
-	/* successful, commit the pointer to idr */
-	idr_replace(&pool->worker_idr, worker, worker->id);
+	/* successful, bind the worker to the pool */
 	list_add_tail(&worker->bind_entry, &pool->bind_list);
 
 	return worker;
 
 fail:
 	if (id >= 0)
-		idr_remove(&pool->worker_idr, id);
+		ida_simple_remove(&pool->worker_ida, id);
 	kfree(worker);
 	return NULL;
 }
@@ -2224,6 +2220,9 @@ woke_up:
 		spin_unlock_irq(&pool->lock);
 		WARN_ON_ONCE(!list_empty(&worker->entry));
 		worker->task->flags &= ~PF_WQ_WORKER;
+
+		set_task_comm(worker->task, "kworker_die");
+		ida_simple_remove(&pool->worker_ida, worker->id);
 		worker_unbind_pool(worker);
 		kfree(worker);
 		return 0;
@@ -3460,10 +3459,10 @@ static int init_worker_pool(struct worker_pool *pool)
 
 	mutex_init(&pool->manager_arb);
 	mutex_init(&pool->manager_mutex);
-	idr_init(&pool->worker_idr);
 	INIT_LIST_HEAD(&pool->bind_list);
 	init_waitqueue_head(&pool->workers_unbound);
 
+	ida_init(&pool->worker_ida);
 	INIT_HLIST_NODE(&pool->hash_node);
 	pool->refcnt = 1;
 
@@ -3478,7 +3477,7 @@ static void rcu_free_pool(struct rcu_head *rcu)
 {
 	struct worker_pool *pool = container_of(rcu, struct worker_pool, rcu);
 
-	idr_destroy(&pool->worker_idr);
+	ida_destroy(&pool->worker_ida);
 	free_workqueue_attrs(pool->attrs);
 	kfree(pool);
 }
-- 
1.7.4.4

