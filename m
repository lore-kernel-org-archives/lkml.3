Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964818Ab3CNC5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 22:57:38 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:32924 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934357Ab3CNC5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 22:57:36 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: laijs@cn.fujitsu.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/7] workqueue: factor out initial worker creation into create_and_start_worker()
Date: Wed, 13 Mar 2013 19:57:20 -0700
Message-Id: <1363229845-6831-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1363229845-6831-1-git-send-email-tj@kernel.org>
References: <1363229845-6831-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_unbound_pool(), workqueue_cpu_up_callback() and init_workqueues()
have similar code pieces to create and start the initial worker factor
those out into create_and_start_worker().

This patch doesn't introduce any functional changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 47 +++++++++++++++++++++++------------------------
 1 file changed, 23 insertions(+), 24 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index bc25bdf..cac7106 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1793,6 +1793,26 @@ static void start_worker(struct worker *worker)
 }
 
 /**
+ * create_and_start_worker - create and start a worker for a pool
+ * @pool: the target pool
+ *
+ * Create and start a new worker for @pool.
+ */
+static int create_and_start_worker(struct worker_pool *pool)
+{
+	struct worker *worker;
+
+	worker = create_worker(pool);
+	if (worker) {
+		spin_lock_irq(&pool->lock);
+		start_worker(worker);
+		spin_unlock_irq(&pool->lock);
+	}
+
+	return worker ? 0 : -ENOMEM;
+}
+
+/**
  * destroy_worker - destroy a workqueue worker
  * @worker: worker to be destroyed
  *
@@ -3542,7 +3562,6 @@ static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
 	static DEFINE_MUTEX(create_mutex);
 	u32 hash = wqattrs_hash(attrs);
 	struct worker_pool *pool;
-	struct worker *worker;
 
 	mutex_lock(&create_mutex);
 
@@ -3568,14 +3587,9 @@ static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
 		goto fail;
 
 	/* create and start the initial worker */
-	worker = create_worker(pool);
-	if (!worker)
+	if (create_and_start_worker(pool) < 0)
 		goto fail;
 
-	spin_lock_irq(&pool->lock);
-	start_worker(worker);
-	spin_unlock_irq(&pool->lock);
-
 	/* install */
 	spin_lock_irq(&workqueue_lock);
 	hash_add(unbound_pool_hash, &pool->hash_node, hash);
@@ -4148,18 +4162,10 @@ static int __cpuinit workqueue_cpu_up_callback(struct notifier_block *nfb,
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_UP_PREPARE:
 		for_each_cpu_worker_pool(pool, cpu) {
-			struct worker *worker;
-
 			if (pool->nr_workers)
 				continue;
-
-			worker = create_worker(pool);
-			if (!worker)
+			if (create_and_start_worker(pool) < 0)
 				return NOTIFY_BAD;
-
-			spin_lock_irq(&pool->lock);
-			start_worker(worker);
-			spin_unlock_irq(&pool->lock);
 		}
 		break;
 
@@ -4409,15 +4415,8 @@ static int __init init_workqueues(void)
 		struct worker_pool *pool;
 
 		for_each_cpu_worker_pool(pool, cpu) {
-			struct worker *worker;
-
 			pool->flags &= ~POOL_DISASSOCIATED;
-
-			worker = create_worker(pool);
-			BUG_ON(!worker);
-			spin_lock_irq(&pool->lock);
-			start_worker(worker);
-			spin_unlock_irq(&pool->lock);
+			BUG_ON(create_and_start_worker(pool) < 0);
 		}
 	}
 
-- 
1.8.1.4

