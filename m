Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab3C1Gos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 02:44:48 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:63209 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983Ab3C1Gor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 02:44:47 -0400
From: Tejun Heo <tj@kernel.org>
To: laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jack@suse.cz, fengguang.wu@intel.com, jmoyer@redhat.com,
        zab@redhat.com, linux-kernel@vger.kernel.org,
        herbert@gondor.hengli.com.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/14] workqueue: break init_and_link_pwq() into two functions and introduce alloc_unbound_pwq()
Date: Wed, 27 Mar 2013 23:43:35 -0700
Message-Id: <1364453020-2829-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1364453020-2829-1-git-send-email-tj@kernel.org>
References: <1364453020-2829-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Break init_and_link_pwq() into init_pwq() and link_pwq() and move
unbound-workqueue specific handling into apply_workqueue_attrs().
Also, factor out unbound pool and pool_workqueue allocation into
alloc_unbound_pwq().

This reorganization is to prepare for NUMA affinity and doesn't
introduce any functional changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 77 ++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 49 insertions(+), 28 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 5b53705..58c7663 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3626,13 +3626,10 @@ static void pwq_adjust_max_active(struct pool_workqueue *pwq)
 	spin_unlock_irq(&pwq->pool->lock);
 }
 
-static void init_and_link_pwq(struct pool_workqueue *pwq,
-			      struct workqueue_struct *wq,
-			      struct worker_pool *pool,
-			      struct pool_workqueue **p_last_pwq)
+/* initialize newly zalloced @pwq which is associated with @wq and @pool */
+static void init_pwq(struct pool_workqueue *pwq, struct workqueue_struct *wq,
+		     struct worker_pool *pool)
 {
-	int node;
-
 	BUG_ON((unsigned long)pwq & WORK_STRUCT_FLAG_MASK);
 
 	pwq->pool = pool;
@@ -3642,8 +3639,15 @@ static void init_and_link_pwq(struct pool_workqueue *pwq,
 	INIT_LIST_HEAD(&pwq->delayed_works);
 	INIT_LIST_HEAD(&pwq->mayday_node);
 	INIT_WORK(&pwq->unbound_release_work, pwq_unbound_release_workfn);
+}
 
-	mutex_lock(&wq->mutex);
+/* sync @pwq with the current state of its associated wq and link it */
+static void link_pwq(struct pool_workqueue *pwq,
+		     struct pool_workqueue **p_last_pwq)
+{
+	struct workqueue_struct *wq = pwq->wq;
+
+	lockdep_assert_held(&wq->mutex);
 
 	/*
 	 * Set the matching work_color.  This is synchronized with
@@ -3658,14 +3662,29 @@ static void init_and_link_pwq(struct pool_workqueue *pwq,
 
 	/* link in @pwq */
 	list_add_rcu(&pwq->pwqs_node, &wq->pwqs);
+}
 
-	if (wq->flags & WQ_UNBOUND) {
-		copy_workqueue_attrs(wq->unbound_attrs, pool->attrs);
-		for_each_node(node)
-			rcu_assign_pointer(wq->numa_pwq_tbl[node], pwq);
+/* obtain a pool matching @attr and create a pwq associating the pool and @wq */
+static struct pool_workqueue *alloc_unbound_pwq(struct workqueue_struct *wq,
+					const struct workqueue_attrs *attrs)
+{
+	struct worker_pool *pool;
+	struct pool_workqueue *pwq;
+
+	lockdep_assert_held(&wq_pool_mutex);
+
+	pool = get_unbound_pool(attrs);
+	if (!pool)
+		return NULL;
+
+	pwq = kmem_cache_zalloc(pwq_cache, GFP_KERNEL);
+	if (!pwq) {
+		put_unbound_pool(pool);
+		return NULL;
 	}
 
-	mutex_unlock(&wq->mutex);
+	init_pwq(pwq, wq, pool);
+	return pwq;
 }
 
 /**
@@ -3686,8 +3705,8 @@ int apply_workqueue_attrs(struct workqueue_struct *wq,
 			  const struct workqueue_attrs *attrs)
 {
 	struct workqueue_attrs *new_attrs;
-	struct pool_workqueue *pwq = NULL, *last_pwq;
-	struct worker_pool *pool;
+	struct pool_workqueue *pwq, *last_pwq;
+	int node;
 
 	/* only unbound workqueues can change attributes */
 	if (WARN_ON(!(wq->flags & WQ_UNBOUND)))
@@ -3706,22 +3725,21 @@ int apply_workqueue_attrs(struct workqueue_struct *wq,
 	cpumask_and(new_attrs->cpumask, new_attrs->cpumask, cpu_possible_mask);
 
 	mutex_lock(&wq_pool_mutex);
-
-	pwq = kmem_cache_zalloc(pwq_cache, GFP_KERNEL);
-	if (!pwq) {
-		mutex_unlock(&wq_pool_mutex);
+	pwq = alloc_unbound_pwq(wq, new_attrs);
+	mutex_unlock(&wq_pool_mutex);
+	if (!pwq)
 		goto enomem;
-	}
 
-	pool = get_unbound_pool(new_attrs);
-	if (!pool) {
-		mutex_unlock(&wq_pool_mutex);
-		goto enomem;
-	}
+	mutex_lock(&wq->mutex);
 
-	mutex_unlock(&wq_pool_mutex);
+	link_pwq(pwq, &last_pwq);
+
+	copy_workqueue_attrs(wq->unbound_attrs, new_attrs);
+	for_each_node(node)
+		rcu_assign_pointer(wq->numa_pwq_tbl[node], pwq);
+
+	mutex_unlock(&wq->mutex);
 
-	init_and_link_pwq(pwq, wq, pool, &last_pwq);
 	if (last_pwq) {
 		spin_lock_irq(&last_pwq->pool->lock);
 		put_pwq(last_pwq);
@@ -3731,7 +3749,6 @@ int apply_workqueue_attrs(struct workqueue_struct *wq,
 	return 0;
 
 enomem:
-	kmem_cache_free(pwq_cache, pwq);
 	free_workqueue_attrs(new_attrs);
 	return -ENOMEM;
 }
@@ -3752,7 +3769,11 @@ static int alloc_and_link_pwqs(struct workqueue_struct *wq)
 			struct worker_pool *cpu_pools =
 				per_cpu(cpu_worker_pools, cpu);
 
-			init_and_link_pwq(pwq, wq, &cpu_pools[highpri], NULL);
+			init_pwq(pwq, wq, &cpu_pools[highpri]);
+
+			mutex_lock(&wq->mutex);
+			link_pwq(pwq, NULL);
+			mutex_unlock(&wq->mutex);
 		}
 		return 0;
 	} else {
-- 
1.8.1.4

