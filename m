Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab3CBDaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:30:09 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:54197 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab3CBDY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:24:59 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jmoyer@redhat.com, zab@redhat.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 18/31] workqueue: remove unbound_std_worker_pools[] and related helpers
Date: Fri,  1 Mar 2013 19:24:09 -0800
Message-Id: <1362194662-2344-19-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362194662-2344-1-git-send-email-tj@kernel.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Workqueue no longer makes use of unbound_std_worker_pools[].  All
unbound worker_pools are created dynamically and there's nothing
special about the standard ones.  With unbound_std_worker_pools[]
unused, workqueue no longer has places where it needs to treat the
per-cpu pools-cpu and unbound pools together.

Remove unbound_std_worker_pools[] and the helpers wrapping it to
present unified per-cpu and unbound standard worker_pools.

* for_each_std_worker_pool() now only walks through per-cpu pools.

* for_each[_online]_wq_cpu() which don't have any users left are
  removed.

* std_worker_pools() and std_worker_pool_pri() are unused and removed.

* get_std_worker_pool() is removed.  Its only user -
  alloc_and_link_pwqs() - only used it for per-cpu pools anyway.  Open
  code per_cpu access in alloc_and_link_pwqs() instead.

This patch doesn't introduce any functional changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 66 +++++-------------------------------------------------
 1 file changed, 6 insertions(+), 60 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index fb91b67..f7f627c 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -253,48 +253,13 @@ EXPORT_SYMBOL_GPL(system_freezable_wq);
 			   "sched RCU or workqueue lock should be held")
 
 #define for_each_std_worker_pool(pool, cpu)				\
-	for ((pool) = &std_worker_pools(cpu)[0];			\
-	     (pool) < &std_worker_pools(cpu)[NR_STD_WORKER_POOLS]; (pool)++)
+	for ((pool) = &per_cpu(cpu_std_worker_pools, cpu)[0];		\
+	     (pool) < &per_cpu(cpu_std_worker_pools, cpu)[NR_STD_WORKER_POOLS]; \
+	     (pool)++)
 
 #define for_each_busy_worker(worker, i, pos, pool)			\
 	hash_for_each(pool->busy_hash, i, pos, worker, hentry)
 
-static inline int __next_wq_cpu(int cpu, const struct cpumask *mask,
-				unsigned int sw)
-{
-	if (cpu < nr_cpu_ids) {
-		if (sw & 1) {
-			cpu = cpumask_next(cpu, mask);
-			if (cpu < nr_cpu_ids)
-				return cpu;
-		}
-		if (sw & 2)
-			return WORK_CPU_UNBOUND;
-	}
-	return WORK_CPU_END;
-}
-
-/*
- * CPU iterators
- *
- * An extra cpu number is defined using an invalid cpu number
- * (WORK_CPU_UNBOUND) to host workqueues which are not bound to any
- * specific CPU.  The following iterators are similar to for_each_*_cpu()
- * iterators but also considers the unbound CPU.
- *
- * for_each_wq_cpu()		: possible CPUs + WORK_CPU_UNBOUND
- * for_each_online_wq_cpu()	: online CPUs + WORK_CPU_UNBOUND
- */
-#define for_each_wq_cpu(cpu)						\
-	for ((cpu) = __next_wq_cpu(-1, cpu_possible_mask, 3);		\
-	     (cpu) < WORK_CPU_END;					\
-	     (cpu) = __next_wq_cpu((cpu), cpu_possible_mask, 3))
-
-#define for_each_online_wq_cpu(cpu)					\
-	for ((cpu) = __next_wq_cpu(-1, cpu_online_mask, 3);		\
-	     (cpu) < WORK_CPU_END;					\
-	     (cpu) = __next_wq_cpu((cpu), cpu_online_mask, 3))
-
 /**
  * for_each_pool - iterate through all worker_pools in the system
  * @pool: iteration cursor
@@ -452,7 +417,6 @@ static bool workqueue_freezing;		/* W: have wqs started freezing? */
  */
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct worker_pool [NR_STD_WORKER_POOLS],
 				     cpu_std_worker_pools);
-static struct worker_pool unbound_std_worker_pools[NR_STD_WORKER_POOLS];
 
 /*
  * idr of all pools.  Modifications are protected by workqueue_lock.  Read
@@ -462,19 +426,6 @@ static DEFINE_IDR(worker_pool_idr);
 
 static int worker_thread(void *__worker);
 
-static struct worker_pool *std_worker_pools(int cpu)
-{
-	if (cpu != WORK_CPU_UNBOUND)
-		return per_cpu(cpu_std_worker_pools, cpu);
-	else
-		return unbound_std_worker_pools;
-}
-
-static int std_worker_pool_pri(struct worker_pool *pool)
-{
-	return pool - std_worker_pools(pool->cpu);
-}
-
 /* allocate ID and assign it to @pool */
 static int worker_pool_assign_id(struct worker_pool *pool)
 {
@@ -492,13 +443,6 @@ static int worker_pool_assign_id(struct worker_pool *pool)
 	return ret;
 }
 
-static struct worker_pool *get_std_worker_pool(int cpu, bool highpri)
-{
-	struct worker_pool *pools = std_worker_pools(cpu);
-
-	return &pools[highpri];
-}
-
 /**
  * first_pwq - return the first pool_workqueue of the specified workqueue
  * @wq: the target workqueue
@@ -3390,8 +3334,10 @@ static int alloc_and_link_pwqs(struct workqueue_struct *wq)
 		for_each_possible_cpu(cpu) {
 			struct pool_workqueue *pwq =
 				per_cpu_ptr(wq->cpu_pwqs, cpu);
+			struct worker_pool *cpu_pools =
+				per_cpu(cpu_std_worker_pools, cpu);
 
-			pwq->pool = get_std_worker_pool(cpu, highpri);
+			pwq->pool = &cpu_pools[highpri];
 			list_add_tail_rcu(&pwq->pwqs_node, &wq->pwqs);
 		}
 	} else {
-- 
1.8.1.2

