Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbaELGyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 02:54:31 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:13798 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751058AbaELGxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 02:53:00 -0400
X-IronPort-AV: E=Sophos;i="4.97,1033,1389715200"; 
   d="scan'208";a="30389411"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 06/10 V2] workqueue: convert worker_idr to worker_ida
Date: Mon, 12 May 2014 14:56:18 +0800
Message-ID: <1399877792-13046-7-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1399877792-13046-1-git-send-email-laijs@cn.fujitsu.com>
References: <20140505150514.GI11231@htj.dyndns.org>
 <1399877792-13046-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to iterate workers via worker_idr, worker_idr is
used for allocating/freeing ID only, so we convert it to worker_ida.

By using ida_simple_get/remove(), worker_ida can be protected by itself,
so we don't need manager_mutex to protect it and remove the coupling,
and we can move the ID-removal out from worker_detach_from_pool().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   20 ++++++++------------
 1 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index b6cf4d9..9f7f4ef 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -161,10 +161,11 @@ struct worker_pool {
 	/* see manage_workers() for details on the two manager mutexes */
 	struct mutex		manager_arb;	/* manager arbitration */
 	struct mutex		manager_mutex;	/* manager exclusion */
-	struct idr		worker_idr;	/* M: worker IDs */
 	struct list_head	workers;	/* M: attached workers */
 	struct completion	*detach_completion; /* all workers detached */
 
+	struct ida		worker_ida;	/* worker IDs for task name */
+
 	struct workqueue_attrs	*attrs;		/* I: worker attributes */
 	struct hlist_node	hash_node;	/* PL: unbound_pool_hash node */
 	int			refcnt;		/* PL: refcnt for unbound pools */
@@ -1681,7 +1682,6 @@ static void worker_detach_from_pool(struct worker *worker,
 	struct completion *detach_completion = NULL;
 
 	mutex_lock(&pool->manager_mutex);
-	idr_remove(&pool->worker_idr, worker->id);
 	list_del(&worker->node);
 	if (list_empty(&pool->workers))
 		detach_completion = pool->detach_completion;
@@ -1712,11 +1712,8 @@ static struct worker *create_worker(struct worker_pool *pool)
 
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
 
@@ -1757,8 +1754,6 @@ static struct worker *create_worker(struct worker_pool *pool)
 	if (pool->flags & POOL_DISASSOCIATED)
 		worker->flags |= WORKER_UNBOUND;
 
-	/* successful, commit the pointer to idr */
-	idr_replace(&pool->worker_idr, worker, worker->id);
 	/* successful, attach the worker to the pool */
 	list_add_tail(&worker->node, &pool->workers);
 
@@ -1766,7 +1761,7 @@ static struct worker *create_worker(struct worker_pool *pool)
 
 fail:
 	if (id >= 0)
-		idr_remove(&pool->worker_idr, id);
+		ida_simple_remove(&pool->worker_ida, id);
 	kfree(worker);
 	return NULL;
 }
@@ -2233,6 +2228,7 @@ woke_up:
 		worker->task->flags &= ~PF_WQ_WORKER;
 
 		set_task_comm(worker->task, "kworker_dying");
+		ida_simple_remove(&pool->worker_ida, worker->id);
 		worker_detach_from_pool(worker, pool);
 		kfree(worker);
 		return 0;
@@ -3469,9 +3465,9 @@ static int init_worker_pool(struct worker_pool *pool)
 
 	mutex_init(&pool->manager_arb);
 	mutex_init(&pool->manager_mutex);
-	idr_init(&pool->worker_idr);
 	INIT_LIST_HEAD(&pool->workers);
 
+	ida_init(&pool->worker_ida);
 	INIT_HLIST_NODE(&pool->hash_node);
 	pool->refcnt = 1;
 
@@ -3486,7 +3482,7 @@ static void rcu_free_pool(struct rcu_head *rcu)
 {
 	struct worker_pool *pool = container_of(rcu, struct worker_pool, rcu);
 
-	idr_destroy(&pool->worker_idr);
+	ida_destroy(&pool->worker_ida);
 	free_workqueue_attrs(pool->attrs);
 	kfree(pool);
 }
-- 
1.7.4.4

