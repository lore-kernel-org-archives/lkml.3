Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab3AWSKE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 13:10:04 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:52269 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756111Ab3AWSKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 13:10:02 -0500
Date: Wed, 23 Jan 2013 10:09:57 -0800
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH v2 15/17] workqueue: remove global_cwq
Message-ID: <20130123180957.GF2373@mtj.dyndns.org>
References: <1358386969-945-1-git-send-email-tj@kernel.org>
 <1358386969-945-16-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358386969-945-16-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

global_cwq is now nothing but a container for per-cpu standard
worker_pools.  Declare the worker pools directly as
cpu/unbound_std_worker_pools[] and remove global_cwq.

* ____cacheline_aligned_in_smp moved from global_cwq to worker_pool.
  This probably would have made sense even before this change as we
  want each pool to be aligned.

* get_gcwq() is replaced with std_worker_pools() which returns the
  pointer to the standard pool array for a given CPU.

* __alloc_workqueue_key() updated to use get_std_worker_pool() instead
  of open-coding pool determination.

This is part of an effort to remove global_cwq and make worker_pool
the top level abstraction, which in turn will help implementing worker
pools with user-specified attributes.

v2: Joonsoo pointed out that it'd better to align struct worker_pool
    rather than the array so that every pool is aligned.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Joonsoo Kim <js1304@gmail.com>
---
Rebased on top of the current wq/for-3.9 and Joonsoo's comments
applied.

Thanks.

 kernel/workqueue.c          |   46 ++++++++++++++++----------------------------
 kernel/workqueue_internal.h |    1 
 2 files changed, 17 insertions(+), 30 deletions(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -144,16 +144,6 @@ struct worker_pool {
 
 	struct mutex		assoc_mutex;	/* protect POOL_DISASSOCIATED */
 	struct ida		worker_ida;	/* L: for worker IDs */
-};
-
-/*
- * Global per-cpu workqueue.  There's one and only one for each cpu
- * and all works are queued and processed here regardless of their
- * target workqueues.
- */
-struct global_cwq {
-	struct worker_pool	pools[NR_STD_WORKER_POOLS];
-						/* normal and highpri pools */
 } ____cacheline_aligned_in_smp;
 
 /*
@@ -250,8 +240,8 @@ EXPORT_SYMBOL_GPL(system_freezable_wq);
 #include <trace/events/workqueue.h>
 
 #define for_each_std_worker_pool(pool, cpu)				\
-	for ((pool) = &get_gcwq((cpu))->pools[0];			\
-	     (pool) < &get_gcwq((cpu))->pools[NR_STD_WORKER_POOLS]; (pool)++)
+	for ((pool) = &std_worker_pools(cpu)[0];			\
+	     (pool) < &std_worker_pools(cpu)[NR_STD_WORKER_POOLS]; (pool)++)
 
 #define for_each_busy_worker(worker, i, pos, pool)			\
 	hash_for_each(pool->busy_hash, i, pos, worker, hentry)
@@ -427,19 +417,19 @@ static LIST_HEAD(workqueues);
 static bool workqueue_freezing;		/* W: have wqs started freezing? */
 
 /*
- * The almighty global cpu workqueues.  nr_running is the only field
- * which is expected to be used frequently by other cpus via
- * try_to_wake_up().  Put it in a separate cacheline.
+ * The CPU standard worker pools.  nr_running is the only field which is
+ * expected to be used frequently by other cpus via try_to_wake_up().  Put
+ * it in a separate cacheline.
  */
-static DEFINE_PER_CPU(struct global_cwq, global_cwq);
+static DEFINE_PER_CPU(struct worker_pool [NR_STD_WORKER_POOLS],
+		      cpu_std_worker_pools);
 static DEFINE_PER_CPU_SHARED_ALIGNED(atomic_t, pool_nr_running[NR_STD_WORKER_POOLS]);
 
 /*
- * Global cpu workqueue and nr_running counter for unbound gcwq.  The pools
- * for online CPUs have POOL_DISASSOCIATED set, and all their workers have
- * WORKER_UNBOUND set.
+ * Standard worker pools and nr_running counter for unbound CPU.  The pools
+ * have POOL_DISASSOCIATED set, and all workers have WORKER_UNBOUND set.
  */
-static struct global_cwq unbound_global_cwq;
+static struct worker_pool unbound_std_worker_pools[NR_STD_WORKER_POOLS];
 static atomic_t unbound_pool_nr_running[NR_STD_WORKER_POOLS] = {
 	[0 ... NR_STD_WORKER_POOLS - 1]	= ATOMIC_INIT(0),	/* always 0 */
 };
@@ -450,17 +440,17 @@ static DEFINE_IDR(worker_pool_idr);
 
 static int worker_thread(void *__worker);
 
-static struct global_cwq *get_gcwq(unsigned int cpu)
+static struct worker_pool *std_worker_pools(int cpu)
 {
 	if (cpu != WORK_CPU_UNBOUND)
-		return &per_cpu(global_cwq, cpu);
+		return per_cpu(cpu_std_worker_pools, cpu);
 	else
-		return &unbound_global_cwq;
+		return unbound_std_worker_pools;
 }
 
 static int std_worker_pool_pri(struct worker_pool *pool)
 {
-	return pool - get_gcwq(pool->cpu)->pools;
+	return pool - std_worker_pools(pool->cpu);
 }
 
 /* allocate ID and assign it to @pool */
@@ -487,9 +477,9 @@ static struct worker_pool *worker_pool_b
 
 static struct worker_pool *get_std_worker_pool(int cpu, bool highpri)
 {
-	struct global_cwq *gcwq = get_gcwq(cpu);
+	struct worker_pool *pools = std_worker_pools(cpu);
 
-	return &gcwq->pools[highpri];
+	return &pools[highpri];
 }
 
 static atomic_t *get_pool_nr_running(struct worker_pool *pool)
@@ -3269,11 +3259,9 @@ struct workqueue_struct *__alloc_workque
 
 	for_each_cwq_cpu(cpu, wq) {
 		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
-		struct global_cwq *gcwq = get_gcwq(cpu);
-		int pool_idx = (bool)(flags & WQ_HIGHPRI);
 
 		BUG_ON((unsigned long)cwq & WORK_STRUCT_FLAG_MASK);
-		cwq->pool = &gcwq->pools[pool_idx];
+		cwq->pool = get_std_worker_pool(cpu, flags & WQ_HIGHPRI);
 		cwq->wq = wq;
 		cwq->flush_color = -1;
 		cwq->max_active = max_active;
--- a/kernel/workqueue_internal.h
+++ b/kernel/workqueue_internal.h
@@ -10,7 +10,6 @@
 #include <linux/workqueue.h>
 #include <linux/kthread.h>
 
-struct global_cwq;
 struct worker_pool;
 
 /*
