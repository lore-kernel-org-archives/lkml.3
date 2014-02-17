Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbaBQSOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 13:14:48 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:24745 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752036AbaBQSOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 13:14:45 -0500
X-IronPort-AV: E=Sophos;i="4.95,862,1384272000"; 
   d="scan'208";a="9545761"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] workqueue: async worker destruction
Date: Tue, 18 Feb 2014 00:24:02 +0800
Message-Id: <1392654243-2829-3-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1392654243-2829-1-git-send-email-laijs@cn.fujitsu.com>
References: <1392472948-2486-1-git-send-email-laijs@cn.fujitsu.com>
 <1392654243-2829-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/18 00:22:11,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/18 00:22:13,
	Serialize complete at 2014/02/18 00:22:13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset moves the worker-destruction(partial) to worker_thread(),
and worker to be die will perform self-destruction.

This async worker destruction give us a room to reduce the mananger's invocation,
and simply the idle-worker-timeout handler later.

put_unbound_pool() still need to sync the destructions to ensure every
worker access to valid pool when performing self-destruction.
so this patch adds a special sync code to put_unbound_pool().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   47 ++++++++++++++++++++++++++++++++++-------------
 1 files changed, 34 insertions(+), 13 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index fc05700..6634326 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1853,17 +1853,7 @@ static void destroy_worker(struct worker *worker)
 
 	list_del_init(&worker->entry);
 	worker->flags |= WORKER_DIE;
-
-	idr_remove(&pool->worker_idr, worker->id);
-
-	/* Enusre the @worker->task is valid across kthread_stop() */
-	get_task_struct(worker->task);
-	spin_unlock_irq(&pool->lock);
-
-	kthread_stop(worker->task);
-	put_task_struct(worker->task);
-
-	spin_lock_irq(&pool->lock);
+	wake_up_process(worker->task);
 }
 
 static void idle_worker_timeout(unsigned long __pool)
@@ -2295,9 +2285,16 @@ woke_up:
 	if (unlikely(worker->flags & WORKER_DIE)) {
 		spin_unlock_irq(&pool->lock);
 		WARN_ON_ONCE(!list_empty(&worker->entry));
+
+		/* perform worker self-destruction */
+		mutex_lock(&pool->manager_mutex);
+		spin_lock_irq(&pool->lock);
+		idr_remove(&pool->worker_idr, worker->id);
 		worker->task->flags &= ~PF_WQ_WORKER;
 		/* No one can access to @worker now, free it. */
 		kfree(worker);
+		spin_unlock_irq(&pool->lock);
+		mutex_unlock(&pool->manager_mutex);
 		return 0;
 	}
 
@@ -3553,6 +3550,7 @@ static void rcu_free_pool(struct rcu_head *rcu)
 static void put_unbound_pool(struct worker_pool *pool)
 {
 	struct worker *worker;
+	int wi;
 
 	lockdep_assert_held(&wq_pool_mutex);
 
@@ -3576,13 +3574,36 @@ static void put_unbound_pool(struct worker_pool *pool)
 	 */
 	mutex_lock(&pool->manager_arb);
 	mutex_lock(&pool->manager_mutex);
-	spin_lock_irq(&pool->lock);
 
+	spin_lock_irq(&pool->lock);
 	while ((worker = first_worker(pool)))
 		destroy_worker(worker);
 	WARN_ON(pool->nr_workers || pool->nr_idle);
-
 	spin_unlock_irq(&pool->lock);
+
+	/* sync all workers dead */
+	for_each_pool_worker(worker, wi, pool) {
+		/*
+		 * Although @worker->task was kicked to die, but we hold
+		 * ->manager_mutex, it can't die, so we get its reference
+		 * before drop ->manager_mutex. And we do sync until it die.
+		 */
+		get_task_struct(worker->task);
+
+		/*
+		 * First, for_each_pool_worker() travels based on ID(@wi),
+		 *   so it is safe even both ->manager_mutex and ->lock
+		 *   are dropped inside the loop.
+		 * Second, no worker can be added now, so the loop
+		 *   ensures to travel all undead workers and sync them dead.
+		 */
+		mutex_unlock(&pool->manager_mutex);
+
+		kthread_stop(worker->task);
+		put_task_struct(worker->task);
+		mutex_lock(&pool->manager_mutex);
+	}
+
 	mutex_unlock(&pool->manager_mutex);
 	mutex_unlock(&pool->manager_arb);
 
-- 
1.7.7.6

