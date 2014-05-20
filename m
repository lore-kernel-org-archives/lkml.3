Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbaETJnH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 05:43:07 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:39921 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752930AbaETJnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 05:43:04 -0400
X-IronPort-AV: E=Sophos;i="4.98,873,1392134400"; 
   d="scan'208";a="30762586"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH V3 06/10] workqueue: convert worker_idr to worker_ida
Date: Tue, 20 May 2014 17:46:32 +0800
Message-ID: <1400579204-3647-7-git-send-email-laijs@cn.fujitsu.com>
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

We don't need to iterate workers via worker_idr, worker_idr is
used for allocating/freeing ID only, so we convert it to worker_ida.

By using ida_simple_get/remove(), worker_ida can be protected by itself,
so we don't need manager_mutex to protect it and the ID-removal code
is allowed to be moved out from worker_detach_from_pool().

And in later patch, worker_detach_from_pool() will be used in rescuers
which doesn't have IDs, so we directly move the ID-removal code out
from worker_detach_from_pool().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   20 ++++++++------------
 1 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index fd2f265..637c244 100644
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
@@ -1696,7 +1697,6 @@ static void worker_detach_from_pool(struct worker *worker,
 	struct completion *detach_completion = NULL;
 
 	mutex_lock(&pool->manager_mutex);
-	idr_remove(&pool->worker_idr, worker->id);
 	list_del(&worker->node);
 	if (list_empty(&pool->workers))
 		detach_completion = pool->detach_completion;
@@ -1727,11 +1727,8 @@ static struct worker *create_worker(struct worker_pool *pool)
 
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
 
@@ -1772,8 +1769,6 @@ static struct worker *create_worker(struct worker_pool *pool)
 	if (pool->flags & POOL_DISASSOCIATED)
 		worker->flags |= WORKER_UNBOUND;
 
-	/* successful, commit the pointer to idr */
-	idr_replace(&pool->worker_idr, worker, worker->id);
 	/* successful, attach the worker to the pool */
 	list_add_tail(&worker->node, &pool->workers);
 
@@ -1781,7 +1776,7 @@ static struct worker *create_worker(struct worker_pool *pool)
 
 fail:
 	if (id >= 0)
-		idr_remove(&pool->worker_idr, id);
+		ida_simple_remove(&pool->worker_ida, id);
 	kfree(worker);
 	return NULL;
 }
@@ -2250,6 +2245,7 @@ woke_up:
 		worker->task->flags &= ~PF_WQ_WORKER;
 
 		set_task_comm(worker->task, "kworker/dying");
+		ida_simple_remove(&pool->worker_ida, worker->id);
 		worker_detach_from_pool(worker, pool);
 		kfree(worker);
 		return 0;
@@ -3486,9 +3482,9 @@ static int init_worker_pool(struct worker_pool *pool)
 
 	mutex_init(&pool->manager_arb);
 	mutex_init(&pool->manager_mutex);
-	idr_init(&pool->worker_idr);
 	INIT_LIST_HEAD(&pool->workers);
 
+	ida_init(&pool->worker_ida);
 	INIT_HLIST_NODE(&pool->hash_node);
 	pool->refcnt = 1;
 
@@ -3503,7 +3499,7 @@ static void rcu_free_pool(struct rcu_head *rcu)
 {
 	struct worker_pool *pool = container_of(rcu, struct worker_pool, rcu);
 
-	idr_destroy(&pool->worker_idr);
+	ida_destroy(&pool->worker_ida);
 	free_workqueue_attrs(pool->attrs);
 	kfree(pool);
 }
-- 
1.7.4.4

