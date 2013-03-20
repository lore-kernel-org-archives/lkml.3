Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934021Ab3CTAAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 20:00:53 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:40351 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757211Ab3CTAAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 20:00:46 -0400
From: Tejun Heo <tj@kernel.org>
To: laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jack@suse.cz, fengguang.wu@intel.com, jmoyer@redhat.com,
        zab@redhat.com, linux-kernel@vger.kernel.org,
        herbert@gondor.hengli.com.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/10] workqueue: determine NUMA node of workers accourding to the allowed cpumask
Date: Tue, 19 Mar 2013 17:00:22 -0700
Message-Id: <1363737629-16745-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1363737629-16745-1-git-send-email-tj@kernel.org>
References: <1363737629-16745-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When worker tasks are created using kthread_create_on_node(),
currently only per-cpu ones have the matching NUMA node specified.
All unbound workers are always created with NUMA_NO_NODE.

Now that an unbound worker pool may have an arbitrary cpumask
associated with it, this isn't optimal.  Add pool->node which is
determined by the pool's cpumask.  If the pool's cpumask is contained
inside a NUMA node proper, the pool is associated with that node, and
all workers of the pool are created on that node.

This currently only makes difference for unbound worker pools with
cpumask contained inside single NUMA node, but this will serve as
foundation for making all unbound pools NUMA-affine.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index c1a931c..2768ed2 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -141,6 +141,7 @@ enum {
 struct worker_pool {
 	spinlock_t		lock;		/* the pool lock */
 	int			cpu;		/* I: the associated cpu */
+	int			node;		/* I: the associated node ID */
 	int			id;		/* I: pool ID */
 	unsigned int		flags;		/* X: flags */
 
@@ -1649,7 +1650,6 @@ static struct worker *alloc_worker(void)
 static struct worker *create_worker(struct worker_pool *pool)
 {
 	struct worker *worker = NULL;
-	int node = pool->cpu >= 0 ? cpu_to_node(pool->cpu) : NUMA_NO_NODE;
 	int id = -1;
 	char id_buf[16];
 
@@ -1682,7 +1682,7 @@ static struct worker *create_worker(struct worker_pool *pool)
 	else
 		snprintf(id_buf, sizeof(id_buf), "u%d:%d", pool->id, id);
 
-	worker->task = kthread_create_on_node(worker_thread, worker, node,
+	worker->task = kthread_create_on_node(worker_thread, worker, pool->node,
 					      "kworker/%s", id_buf);
 	if (IS_ERR(worker->task))
 		goto fail;
@@ -3390,6 +3390,7 @@ static int init_worker_pool(struct worker_pool *pool)
 	spin_lock_init(&pool->lock);
 	pool->id = -1;
 	pool->cpu = -1;
+	pool->node = NUMA_NO_NODE;
 	pool->flags |= POOL_DISASSOCIATED;
 	INIT_LIST_HEAD(&pool->worklist);
 	INIT_LIST_HEAD(&pool->idle_list);
@@ -3496,6 +3497,7 @@ static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
 {
 	u32 hash = wqattrs_hash(attrs);
 	struct worker_pool *pool;
+	int node;
 
 	mutex_lock(&wq_mutex);
 
@@ -3515,6 +3517,17 @@ static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
 	lockdep_set_subclass(&pool->lock, 1);	/* see put_pwq() */
 	copy_workqueue_attrs(pool->attrs, attrs);
 
+	/* if cpumask is contained inside a NUMA node, we belong to that node */
+	if (wq_numa_possible_cpumask) {
+		for_each_node(node) {
+			if (cpumask_subset(pool->attrs->cpumask,
+					   wq_numa_possible_cpumask[node])) {
+				pool->node = node;
+				break;
+			}
+		}
+	}
+
 	if (worker_pool_assign_id(pool) < 0)
 		goto fail;
 
@@ -4473,6 +4486,7 @@ static int __init init_workqueues(void)
 			pool->cpu = cpu;
 			cpumask_copy(pool->attrs->cpumask, cpumask_of(cpu));
 			pool->attrs->nice = std_nice[i++];
+			pool->node = cpu_to_node(cpu);
 
 			/* alloc pool ID */
 			mutex_lock(&wq_mutex);
-- 
1.8.1.4

