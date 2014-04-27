Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbaD0EFz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 00:05:55 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:23482 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752973AbaD0EFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 00:05:53 -0400
X-IronPort-AV: E=Sophos;i="4.97,936,1389715200"; 
   d="scan'208";a="29778315"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Jan Kara <jack@suse.cz>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 05/10] workqueue: separate iteration role from worker_idr
Date: Sun, 27 Apr 2014 12:09:00 +0800
Message-ID: <1398571754-12443-6-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1398571754-12443-1-git-send-email-laijs@cn.fujitsu.com>
References: <1398571754-12443-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

worker_idr has the iteration and worker ID duties. These two duties
are not necessary tied together. We can separate them and use a list
for iteration.

After separation, we can add the rescuer workers to the list for iteration
in future. worker_idr can't add rescuer workers due to rescuer workers
can't allocate id from worker_idr.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c          |   38 ++++++++++++--------------------------
 kernel/workqueue_internal.h |    1 +
 2 files changed, 13 insertions(+), 26 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f3a6086..0eae42c 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -161,7 +161,8 @@ struct worker_pool {
 	/* see manage_workers() for details on the two manager mutexes */
 	struct mutex		manager_arb;	/* manager arbitration */
 	struct mutex		manager_mutex;	/* manager exclusion */
-	struct idr		worker_idr;	/* M: worker IDs and iteration */
+	struct idr		worker_idr;	/* M: worker IDs */
+	struct list_head	bind_list;	/* M: pool-bound workers */
 	wait_queue_head_t	workers_unbound;/* all workers pool-unbound */
 
 	struct workqueue_attrs	*attrs;		/* I: worker attributes */
@@ -361,22 +362,6 @@ static void copy_workqueue_attrs(struct workqueue_attrs *to,
 		else
 
 /**
- * for_each_pool_worker - iterate through all workers of a worker_pool
- * @worker: iteration cursor
- * @wi: integer used for iteration
- * @pool: worker_pool to iterate workers of
- *
- * This must be called with either @pool->manager_mutex.
- *
- * The if/else clause exists only for the lockdep assertion and can be
- * ignored.
- */
-#define for_each_pool_worker(worker, wi, pool)				\
-	idr_for_each_entry(&(pool)->worker_idr, (worker), (wi))		\
-		if (({ lockdep_assert_held(&pool->manager_mutex); false; })) { } \
-		else
-
-/**
  * for_each_pwq - iterate through all pool_workqueues of the specified workqueue
  * @pwq: iteration cursor
  * @wq: the target workqueue
@@ -1674,6 +1659,7 @@ static struct worker *alloc_worker(void)
 	if (worker) {
 		INIT_LIST_HEAD(&worker->entry);
 		INIT_LIST_HEAD(&worker->scheduled);
+		INIT_LIST_HEAD(&worker->bind_entry);
 		/* on creation a worker is in !idle && prep state */
 		worker->flags = WORKER_PREP;
 	}
@@ -1692,7 +1678,8 @@ static void worker_unbind_pool(struct worker *worker)
 
 	mutex_lock(&pool->manager_mutex);
 	idr_remove(&pool->worker_idr, worker->id);
-	if (idr_is_empty(&pool->worker_idr))
+	list_del(&worker->bind_entry);
+	if (list_empty(&pool->bind_list))
 		wake_up(&pool->workers_unbound);
 	mutex_unlock(&pool->manager_mutex);
 }
@@ -1765,6 +1752,7 @@ static struct worker *create_worker(struct worker_pool *pool)
 
 	/* successful, commit the pointer to idr */
 	idr_replace(&pool->worker_idr, worker, worker->id);
+	list_add_tail(&worker->bind_entry, &pool->bind_list);
 
 	return worker;
 
@@ -3473,6 +3461,7 @@ static int init_worker_pool(struct worker_pool *pool)
 	mutex_init(&pool->manager_arb);
 	mutex_init(&pool->manager_mutex);
 	idr_init(&pool->worker_idr);
+	INIT_LIST_HEAD(&pool->bind_list);
 	init_waitqueue_head(&pool->workers_unbound);
 
 	INIT_HLIST_NODE(&pool->hash_node);
@@ -3541,7 +3530,7 @@ static void put_unbound_pool(struct worker_pool *pool)
 	spin_unlock_irq(&pool->lock);
 
 	wait_event_cmd(pool->workers_unbound,
-		       idr_is_empty(&pool->worker_idr),
+		       list_empty(&pool->bind_list),
 		       mutex_unlock(&pool->manager_mutex),
 		       mutex_lock(&pool->manager_mutex));
 
@@ -4524,7 +4513,6 @@ static void wq_unbind_fn(struct work_struct *work)
 	int cpu = smp_processor_id();
 	struct worker_pool *pool;
 	struct worker *worker;
-	int wi;
 
 	for_each_cpu_worker_pool(pool, cpu) {
 		WARN_ON_ONCE(cpu != smp_processor_id());
@@ -4539,7 +4527,7 @@ static void wq_unbind_fn(struct work_struct *work)
 		 * before the last CPU down must be on the cpu.  After
 		 * this, they may become diasporas.
 		 */
-		for_each_pool_worker(worker, wi, pool)
+		list_for_each_entry(worker, &pool->bind_list, bind_entry)
 			worker->flags |= WORKER_UNBOUND;
 
 		pool->flags |= POOL_DISASSOCIATED;
@@ -4585,7 +4573,6 @@ static void wq_unbind_fn(struct work_struct *work)
 static void rebind_workers(struct worker_pool *pool)
 {
 	struct worker *worker;
-	int wi;
 
 	lockdep_assert_held(&pool->manager_mutex);
 
@@ -4596,13 +4583,13 @@ static void rebind_workers(struct worker_pool *pool)
 	 * of all workers first and then clear UNBOUND.  As we're called
 	 * from CPU_ONLINE, the following shouldn't fail.
 	 */
-	for_each_pool_worker(worker, wi, pool)
+	list_for_each_entry(worker, &pool->bind_list, bind_entry)
 		WARN_ON_ONCE(set_cpus_allowed_ptr(worker->task,
 						  pool->attrs->cpumask) < 0);
 
 	spin_lock_irq(&pool->lock);
 
-	for_each_pool_worker(worker, wi, pool) {
+	list_for_each_entry(worker, &pool->bind_list, bind_entry) {
 		unsigned int worker_flags = worker->flags;
 
 		/*
@@ -4654,7 +4641,6 @@ static void restore_unbound_workers_cpumask(struct worker_pool *pool, int cpu)
 {
 	static cpumask_t cpumask;
 	struct worker *worker;
-	int wi;
 
 	lockdep_assert_held(&pool->manager_mutex);
 
@@ -4668,7 +4654,7 @@ static void restore_unbound_workers_cpumask(struct worker_pool *pool, int cpu)
 		return;
 
 	/* as we're called from CPU_ONLINE, the following shouldn't fail */
-	for_each_pool_worker(worker, wi, pool)
+	list_for_each_entry(worker, &pool->bind_list, bind_entry)
 		WARN_ON_ONCE(set_cpus_allowed_ptr(worker->task,
 						  pool->attrs->cpumask) < 0);
 }
diff --git a/kernel/workqueue_internal.h b/kernel/workqueue_internal.h
index 7e2204d..7bff111 100644
--- a/kernel/workqueue_internal.h
+++ b/kernel/workqueue_internal.h
@@ -37,6 +37,7 @@ struct worker {
 	struct task_struct	*task;		/* I: worker task */
 	struct worker_pool	*pool;		/* I: the associated pool */
 						/* L: for rescuers */
+	struct list_head	bind_entry;	/* M: bound with the pool */
 
 	unsigned long		last_active;	/* L: last active timestamp */
 	unsigned int		flags;		/* X: flags */
-- 
1.7.4.4

