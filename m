Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758445Ab3AQBrL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 20:47:11 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:48017 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758213Ab3AQBm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 20:42:57 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/17] workqueue: use std_ prefix for the standard per-cpu pools
Date: Wed, 16 Jan 2013 17:42:34 -0800
Message-Id: <1358386969-945-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1358386969-945-1-git-send-email-tj@kernel.org>
References: <1358386969-945-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are currently two worker pools per cpu (including the unbound
cpu) and they are the only pools in use.  New class of pools are
scheduled to be added and some pool related APIs will be added
inbetween.  Call the existing pools the standard pools and prefix them
with std_.  Do this early so that new APIs can use std_ prefix from
the beginning.

This patch doesn't introduce any functional difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 4275ae7..5e74cd2 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -80,7 +80,7 @@ enum {
 	WORKER_NOT_RUNNING	= WORKER_PREP | WORKER_UNBOUND |
 				  WORKER_CPU_INTENSIVE,
 
-	NR_WORKER_POOLS		= 2,		/* # worker pools per gcwq */
+	NR_STD_WORKER_POOLS	= 2,		/* # standard pools per cpu */
 
 	BUSY_WORKER_HASH_ORDER	= 6,		/* 64 pointers */
 
@@ -183,7 +183,7 @@ struct global_cwq {
 	DECLARE_HASHTABLE(busy_hash, BUSY_WORKER_HASH_ORDER);
 						/* L: hash of busy workers */
 
-	struct worker_pool	pools[NR_WORKER_POOLS];
+	struct worker_pool	pools[NR_STD_WORKER_POOLS];
 						/* normal and highpri pools */
 } ____cacheline_aligned_in_smp;
 
@@ -282,7 +282,7 @@ EXPORT_SYMBOL_GPL(system_freezable_wq);
 
 #define for_each_worker_pool(pool, gcwq)				\
 	for ((pool) = &(gcwq)->pools[0];				\
-	     (pool) < &(gcwq)->pools[NR_WORKER_POOLS]; (pool)++)
+	     (pool) < &(gcwq)->pools[NR_STD_WORKER_POOLS]; (pool)++)
 
 #define for_each_busy_worker(worker, i, pos, gcwq)			\
 	hash_for_each(gcwq->busy_hash, i, pos, worker, hentry)
@@ -463,7 +463,7 @@ static bool workqueue_freezing;		/* W: have wqs started freezing? */
  * try_to_wake_up().  Put it in a separate cacheline.
  */
 static DEFINE_PER_CPU(struct global_cwq, global_cwq);
-static DEFINE_PER_CPU_SHARED_ALIGNED(atomic_t, pool_nr_running[NR_WORKER_POOLS]);
+static DEFINE_PER_CPU_SHARED_ALIGNED(atomic_t, pool_nr_running[NR_STD_WORKER_POOLS]);
 
 /*
  * Global cpu workqueue and nr_running counter for unbound gcwq.  The
@@ -471,14 +471,14 @@ static DEFINE_PER_CPU_SHARED_ALIGNED(atomic_t, pool_nr_running[NR_WORKER_POOLS])
  * workers have WORKER_UNBOUND set.
  */
 static struct global_cwq unbound_global_cwq;
-static atomic_t unbound_pool_nr_running[NR_WORKER_POOLS] = {
-	[0 ... NR_WORKER_POOLS - 1]	= ATOMIC_INIT(0),	/* always 0 */
+static atomic_t unbound_pool_nr_running[NR_STD_WORKER_POOLS] = {
+	[0 ... NR_STD_WORKER_POOLS - 1]	= ATOMIC_INIT(0),	/* always 0 */
 };
 
 static int worker_thread(void *__worker);
 static unsigned int work_cpu(struct work_struct *work);
 
-static int worker_pool_pri(struct worker_pool *pool)
+static int std_worker_pool_pri(struct worker_pool *pool)
 {
 	return pool - pool->gcwq->pools;
 }
@@ -494,7 +494,7 @@ static struct global_cwq *get_gcwq(unsigned int cpu)
 static atomic_t *get_pool_nr_running(struct worker_pool *pool)
 {
 	int cpu = pool->gcwq->cpu;
-	int idx = worker_pool_pri(pool);
+	int idx = std_worker_pool_pri(pool);
 
 	if (cpu != WORK_CPU_UNBOUND)
 		return &per_cpu(pool_nr_running, cpu)[idx];
@@ -1707,7 +1707,7 @@ static void rebind_workers(struct global_cwq *gcwq)
 		 * wq doesn't really matter but let's keep @worker->pool
 		 * and @cwq->pool consistent for sanity.
 		 */
-		if (worker_pool_pri(worker->pool))
+		if (std_worker_pool_pri(worker->pool))
 			wq = system_highpri_wq;
 		else
 			wq = system_wq;
@@ -1750,7 +1750,7 @@ static struct worker *alloc_worker(void)
 static struct worker *create_worker(struct worker_pool *pool)
 {
 	struct global_cwq *gcwq = pool->gcwq;
-	const char *pri = worker_pool_pri(pool) ? "H" : "";
+	const char *pri = std_worker_pool_pri(pool) ? "H" : "";
 	struct worker *worker = NULL;
 	int id = -1;
 
@@ -1780,7 +1780,7 @@ static struct worker *create_worker(struct worker_pool *pool)
 	if (IS_ERR(worker->task))
 		goto fail;
 
-	if (worker_pool_pri(pool))
+	if (std_worker_pool_pri(pool))
 		set_user_nice(worker->task, HIGHPRI_NICE_LEVEL);
 
 	/*
-- 
1.8.0.2

