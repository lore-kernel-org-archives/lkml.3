Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067Ab3C1GoN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 02:44:13 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:56231 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829Ab3C1GoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 02:44:08 -0400
From: Tejun Heo <tj@kernel.org>
To: laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jack@suse.cz, fengguang.wu@intel.com, jmoyer@redhat.com,
        zab@redhat.com, linux-kernel@vger.kernel.org,
        herbert@gondor.hengli.com.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/14] workqueue: move pwq_pool_locking outside of get/put_unbound_pool()
Date: Wed, 27 Mar 2013 23:43:27 -0700
Message-Id: <1364453020-2829-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1364453020-2829-1-git-send-email-tj@kernel.org>
References: <1364453020-2829-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The scheduled NUMA affinity support for unbound workqueues would need
to walk workqueues list and pool related operations on each workqueue.

Move wq_pool_mutex locking out of get/put_unbound_pool() to their
callers so that pool operations can be performed while walking the
workqueues list, which is also protected by wq_pool_mutex.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index abe1f0d..26771f4e 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3395,31 +3395,28 @@ static void rcu_free_pool(struct rcu_head *rcu)
  * safe manner.  get_unbound_pool() calls this function on its failure path
  * and this function should be able to release pools which went through,
  * successfully or not, init_worker_pool().
+ *
+ * Should be called with wq_pool_mutex held.
  */
 static void put_unbound_pool(struct worker_pool *pool)
 {
 	struct worker *worker;
 
-	mutex_lock(&wq_pool_mutex);
-	if (--pool->refcnt) {
-		mutex_unlock(&wq_pool_mutex);
+	lockdep_assert_held(&wq_pool_mutex);
+
+	if (--pool->refcnt)
 		return;
-	}
 
 	/* sanity checks */
 	if (WARN_ON(!(pool->flags & POOL_DISASSOCIATED)) ||
-	    WARN_ON(!list_empty(&pool->worklist))) {
-		mutex_unlock(&wq_pool_mutex);
+	    WARN_ON(!list_empty(&pool->worklist)))
 		return;
-	}
 
 	/* release id and unhash */
 	if (pool->id >= 0)
 		idr_remove(&worker_pool_idr, pool->id);
 	hash_del(&pool->hash_node);
 
-	mutex_unlock(&wq_pool_mutex);
-
 	/*
 	 * Become the manager and destroy all workers.  Grabbing
 	 * manager_arb prevents @pool's workers from blocking on
@@ -3453,13 +3450,15 @@ static void put_unbound_pool(struct worker_pool *pool)
  * reference count and return it.  If there already is a matching
  * worker_pool, it will be used; otherwise, this function attempts to
  * create a new one.  On failure, returns NULL.
+ *
+ * Should be called with wq_pool_mutex held.
  */
 static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
 {
 	u32 hash = wqattrs_hash(attrs);
 	struct worker_pool *pool;
 
-	mutex_lock(&wq_pool_mutex);
+	lockdep_assert_held(&wq_pool_mutex);
 
 	/* do we already have a matching pool? */
 	hash_for_each_possible(unbound_pool_hash, pool, hash_node, hash) {
@@ -3490,10 +3489,8 @@ static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
 	/* install */
 	hash_add(unbound_pool_hash, &pool->hash_node, hash);
 out_unlock:
-	mutex_unlock(&wq_pool_mutex);
 	return pool;
 fail:
-	mutex_unlock(&wq_pool_mutex);
 	if (pool)
 		put_unbound_pool(pool);
 	return NULL;
@@ -3530,7 +3527,10 @@ static void pwq_unbound_release_workfn(struct work_struct *work)
 	is_last = list_empty(&wq->pwqs);
 	mutex_unlock(&wq->mutex);
 
+	mutex_lock(&wq_pool_mutex);
 	put_unbound_pool(pool);
+	mutex_unlock(&wq_pool_mutex);
+
 	call_rcu_sched(&pwq->rcu, rcu_free_pwq);
 
 	/*
@@ -3653,13 +3653,21 @@ int apply_workqueue_attrs(struct workqueue_struct *wq,
 	copy_workqueue_attrs(new_attrs, attrs);
 	cpumask_and(new_attrs->cpumask, new_attrs->cpumask, cpu_possible_mask);
 
+	mutex_lock(&wq_pool_mutex);
+
 	pwq = kmem_cache_zalloc(pwq_cache, GFP_KERNEL);
-	if (!pwq)
+	if (!pwq) {
+		mutex_unlock(&wq_pool_mutex);
 		goto enomem;
+	}
 
 	pool = get_unbound_pool(new_attrs);
-	if (!pool)
+	if (!pool) {
+		mutex_unlock(&wq_pool_mutex);
 		goto enomem;
+	}
+
+	mutex_unlock(&wq_pool_mutex);
 
 	init_and_link_pwq(pwq, wq, pool, &last_pwq);
 	if (last_pwq) {
-- 
1.8.1.4

