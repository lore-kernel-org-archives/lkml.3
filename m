Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab3CBD1I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:27:08 -0500
Received: from mail-da0-f54.google.com ([209.85.210.54]:41249 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab3CBDZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:25:13 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jmoyer@redhat.com, zab@redhat.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 26/31] workqueue: implement apply_workqueue_attrs()
Date: Fri,  1 Mar 2013 19:24:17 -0800
Message-Id: <1362194662-2344-27-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362194662-2344-1-git-send-email-tj@kernel.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement apply_workqueue_attrs() which applies workqueue_attrs to the
specified unbound workqueue by creating a new pwq (pool_workqueue)
linked to worker_pool with the specified attributes.

A new pwq is linked at the head of wq->pwqs instead of tail and
__queue_work() verifies that the first unbound pwq has positive refcnt
before choosing it for the actual queueing.  This is to cover the case
where creation of a new pwq races with queueing.  As base ref on a pwq
won't be dropped without making another pwq the first one,
__queue_work() is guaranteed to make progress and not add work item to
a dead pwq.

init_and_link_pwq() is updated to return the last first pwq the new
pwq replaced, which is put by apply_workqueue_attrs().

Note that apply_workqueue_attrs() is almost identical to unbound pwq
part of alloc_and_link_pwqs().  The only difference is that there is
no previous first pwq.  apply_workqueue_attrs() is implemented to
handle such cases and replaces unbound pwq handling in
alloc_and_link_pwqs().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |  2 ++
 kernel/workqueue.c        | 91 ++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 73 insertions(+), 20 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 0341403..c8c3bf4 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -409,6 +409,8 @@ extern void destroy_workqueue(struct workqueue_struct *wq);
 
 struct workqueue_attrs *alloc_workqueue_attrs(gfp_t gfp_mask);
 void free_workqueue_attrs(struct workqueue_attrs *attrs);
+int apply_workqueue_attrs(struct workqueue_struct *wq,
+			  const struct workqueue_attrs *attrs);
 
 extern bool queue_work_on(int cpu, struct workqueue_struct *wq,
 			struct work_struct *work);
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 4c67967..36fcf9c 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1225,7 +1225,7 @@ static void __queue_work(int cpu, struct workqueue_struct *wq,
 	if (unlikely(wq->flags & WQ_DRAINING) &&
 	    WARN_ON_ONCE(!is_chained_work(wq)))
 		return;
-
+retry:
 	/* pwq which will be used unless @work is executing elsewhere */
 	if (!(wq->flags & WQ_UNBOUND)) {
 		if (cpu == WORK_CPU_UNBOUND)
@@ -1259,6 +1259,25 @@ static void __queue_work(int cpu, struct workqueue_struct *wq,
 		spin_lock(&pwq->pool->lock);
 	}
 
+	/*
+	 * pwq is determined and locked.  For unbound pools, we could have
+	 * raced with pwq release and it could already be dead.  If its
+	 * refcnt is zero, repeat pwq selection.  Note that pwqs never die
+	 * without another pwq replacing it as the first pwq or while a
+	 * work item is executing on it, so the retying is guaranteed to
+	 * make forward-progress.
+	 */
+	if (unlikely(!pwq->refcnt)) {
+		if (wq->flags & WQ_UNBOUND) {
+			spin_unlock(&pwq->pool->lock);
+			cpu_relax();
+			goto retry;
+		}
+		/* oops */
+		WARN_ONCE(true, "workqueue: per-cpu pwq for %s on cpu%d has 0 refcnt",
+			  wq->name, cpu);
+	}
+
 	/* pwq determined, queue */
 	trace_workqueue_queue_work(req_cpu, pwq, work);
 
@@ -3418,7 +3437,8 @@ static void pwq_unbound_release_workfn(struct work_struct *work)
 
 static void init_and_link_pwq(struct pool_workqueue *pwq,
 			      struct workqueue_struct *wq,
-			      struct worker_pool *pool)
+			      struct worker_pool *pool,
+			      struct pool_workqueue **p_last_pwq)
 {
 	BUG_ON((unsigned long)pwq & WORK_STRUCT_FLAG_MASK);
 
@@ -3438,13 +3458,58 @@ static void init_and_link_pwq(struct pool_workqueue *pwq,
 	mutex_lock(&wq->flush_mutex);
 	spin_lock_irq(&workqueue_lock);
 
+	if (p_last_pwq)
+		*p_last_pwq = first_pwq(wq);
 	pwq->work_color = wq->work_color;
-	list_add_tail_rcu(&pwq->pwqs_node, &wq->pwqs);
+	list_add_rcu(&pwq->pwqs_node, &wq->pwqs);
 
 	spin_unlock_irq(&workqueue_lock);
 	mutex_unlock(&wq->flush_mutex);
 }
 
+/**
+ * apply_workqueue_attrs - apply new workqueue_attrs to an unbound workqueue
+ * @wq: the target workqueue
+ * @attrs: the workqueue_attrs to apply, allocated with alloc_workqueue_attrs()
+ *
+ * Apply @attrs to an unbound workqueue @wq.  If @attrs doesn't match the
+ * current attributes, a new pwq is created and made the first pwq which
+ * will serve all new work items.  Older pwqs are released as in-flight
+ * work items finish.  Note that a work item which repeatedly requeues
+ * itself back-to-back will stay on its current pwq.
+ *
+ * Performs GFP_KERNEL allocations.  Returns 0 on success and -errno on
+ * failure.
+ */
+int apply_workqueue_attrs(struct workqueue_struct *wq,
+			  const struct workqueue_attrs *attrs)
+{
+	struct pool_workqueue *pwq, *last_pwq;
+	struct worker_pool *pool;
+
+	if (WARN_ON(!(wq->flags & WQ_UNBOUND)))
+		return -EINVAL;
+
+	pwq = kmem_cache_zalloc(pwq_cache, GFP_KERNEL);
+	if (!pwq)
+		return -ENOMEM;
+
+	pool = get_unbound_pool(attrs);
+	if (!pool) {
+		kmem_cache_free(pwq_cache, pwq);
+		return -ENOMEM;
+	}
+
+	init_and_link_pwq(pwq, wq, pool, &last_pwq);
+	if (last_pwq) {
+		spin_lock_irq(&last_pwq->pool->lock);
+		put_pwq(last_pwq);
+		spin_unlock_irq(&last_pwq->pool->lock);
+	}
+
+	return 0;
+}
+
 static int alloc_and_link_pwqs(struct workqueue_struct *wq)
 {
 	bool highpri = wq->flags & WQ_HIGHPRI;
@@ -3461,26 +3526,12 @@ static int alloc_and_link_pwqs(struct workqueue_struct *wq)
 			struct worker_pool *cpu_pools =
 				per_cpu(cpu_worker_pools, cpu);
 
-			init_and_link_pwq(pwq, wq, &cpu_pools[highpri]);
+			init_and_link_pwq(pwq, wq, &cpu_pools[highpri], NULL);
 		}
+		return 0;
 	} else {
-		struct pool_workqueue *pwq;
-		struct worker_pool *pool;
-
-		pwq = kmem_cache_zalloc(pwq_cache, GFP_KERNEL);
-		if (!pwq)
-			return -ENOMEM;
-
-		pool = get_unbound_pool(unbound_std_wq_attrs[highpri]);
-		if (!pool) {
-			kmem_cache_free(pwq_cache, pwq);
-			return -ENOMEM;
-		}
-
-		init_and_link_pwq(pwq, wq, pool);
+		return apply_workqueue_attrs(wq, unbound_std_wq_attrs[highpri]);
 	}
-
-	return 0;
 }
 
 static int wq_clamp_max_active(int max_active, unsigned int flags,
-- 
1.8.1.2

