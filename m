Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105Ab3CBD2M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:28:12 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:57643 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab3CBDZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:25:08 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jmoyer@redhat.com, zab@redhat.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 23/31] workqueue: implement get/put_pwq()
Date: Fri,  1 Mar 2013 19:24:14 -0800
Message-Id: <1362194662-2344-24-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362194662-2344-1-git-send-email-tj@kernel.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pool_workqueue->refcnt along with get/put_pwq().  Both per-cpu and
unbound pwqs have refcnts and any work item inserted on a pwq
increments the refcnt which is dropped when the work item finishes.

For per-cpu pwqs the base ref is never dropped and destroy_workqueue()
frees the pwqs as before.  For unbound ones, destroy_workqueue()
simply drops the base ref on the first pwq.  When the refcnt reaches
zero, pwq_unbound_release_workfn() is scheduled on system_wq, which
unlinks the pwq, puts the associated pool and frees the pwq and wq as
necessary.  This needs to be done from a work item as put_pwq() needs
to be protected by pool->lock but release can't happen with the lock
held - e.g. put_unbound_pool() involves blocking operations.

Unbound pool->locks are marked with lockdep subclas 1 as put_pwq()
will schedule the release work item on system_wq while holding the
unbound pool's lock and triggers recursive locking warning spuriously.

This will be used to implement dynamic creation and destruction of
unbound pwqs.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 137 ++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 114 insertions(+), 23 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index d0604ee..e092cd5 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -179,6 +179,7 @@ struct pool_workqueue {
 	struct workqueue_struct *wq;		/* I: the owning workqueue */
 	int			work_color;	/* L: current color */
 	int			flush_color;	/* L: flushing color */
+	int			refcnt;		/* L: reference count */
 	int			nr_in_flight[WORK_NR_COLORS];
 						/* L: nr of in_flight works */
 	int			nr_active;	/* L: nr of active works */
@@ -186,6 +187,15 @@ struct pool_workqueue {
 	struct list_head	delayed_works;	/* L: delayed works */
 	struct list_head	pwqs_node;	/* R: node on wq->pwqs */
 	struct list_head	mayday_node;	/* W: node on wq->maydays */
+
+	/*
+	 * Release of unbound pwq is punted to system_wq.  See put_pwq()
+	 * and pwq_unbound_release_workfn() for details.  pool_workqueue
+	 * itself is also sched-RCU protected so that the first pwq can be
+	 * determined without grabbing workqueue_lock.
+	 */
+	struct work_struct	unbound_release_work;
+	struct rcu_head		rcu;
 } __aligned(1 << WORK_STRUCT_FLAG_BITS);
 
 /*
@@ -936,6 +946,45 @@ static void move_linked_works(struct work_struct *work, struct list_head *head,
 		*nextp = n;
 }
 
+/**
+ * get_pwq - get an extra reference on the specified pool_workqueue
+ * @pwq: pool_workqueue to get
+ *
+ * Obtain an extra reference on @pwq.  The caller should guarantee that
+ * @pwq has positive refcnt and be holding the matching pool->lock.
+ */
+static void get_pwq(struct pool_workqueue *pwq)
+{
+	lockdep_assert_held(&pwq->pool->lock);
+	WARN_ON_ONCE(pwq->refcnt <= 0);
+	pwq->refcnt++;
+}
+
+/**
+ * put_pwq - put a pool_workqueue reference
+ * @pwq: pool_workqueue to put
+ *
+ * Drop a reference of @pwq.  If its refcnt reaches zero, schedule its
+ * destruction.  The caller should be holding the matching pool->lock.
+ */
+static void put_pwq(struct pool_workqueue *pwq)
+{
+	lockdep_assert_held(&pwq->pool->lock);
+	if (likely(--pwq->refcnt))
+		return;
+	if (WARN_ON_ONCE(!(pwq->wq->flags & WQ_UNBOUND)))
+		return;
+	/*
+	 * @pwq can't be released under pool->lock, bounce to
+	 * pwq_unbound_release_workfn().  This never recurses on the same
+	 * pool->lock as this path is taken only for unbound workqueues and
+	 * the release work item is scheduled on a per-cpu workqueue.  To
+	 * avoid lockdep warning, unbound pool->locks are given lockdep
+	 * subclass of 1 in get_unbound_pool().
+	 */
+	schedule_work(&pwq->unbound_release_work);
+}
+
 static void pwq_activate_delayed_work(struct work_struct *work)
 {
 	struct pool_workqueue *pwq = get_work_pwq(work);
@@ -967,9 +1016,9 @@ static void pwq_activate_first_delayed(struct pool_workqueue *pwq)
  */
 static void pwq_dec_nr_in_flight(struct pool_workqueue *pwq, int color)
 {
-	/* ignore uncolored works */
+	/* uncolored work items don't participate in flushing or nr_active */
 	if (color == WORK_NO_COLOR)
-		return;
+		goto out_put;
 
 	pwq->nr_in_flight[color]--;
 
@@ -982,11 +1031,11 @@ static void pwq_dec_nr_in_flight(struct pool_workqueue *pwq, int color)
 
 	/* is flush in progress and are we at the flushing tip? */
 	if (likely(pwq->flush_color != color))
-		return;
+		goto out_put;
 
 	/* are there still in-flight works? */
 	if (pwq->nr_in_flight[color])
-		return;
+		goto out_put;
 
 	/* this pwq is done, clear flush_color */
 	pwq->flush_color = -1;
@@ -997,6 +1046,8 @@ static void pwq_dec_nr_in_flight(struct pool_workqueue *pwq, int color)
 	 */
 	if (atomic_dec_and_test(&pwq->wq->nr_pwqs_to_flush))
 		complete(&pwq->wq->first_flusher->done);
+out_put:
+	put_pwq(pwq);
 }
 
 /**
@@ -1119,6 +1170,7 @@ static void insert_work(struct pool_workqueue *pwq, struct work_struct *work,
 	/* we own @work, set data and link */
 	set_work_pwq(work, pwq, extra_flags);
 	list_add_tail(&work->entry, head);
+	get_pwq(pwq);
 
 	/*
 	 * Ensure either worker_sched_deactivated() sees the above
@@ -3294,6 +3346,7 @@ static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
 	if (!pool || init_worker_pool(pool) < 0)
 		goto fail;
 
+	lockdep_set_subclass(&pool->lock, 1);	/* see put_pwq() */
 	copy_workqueue_attrs(pool->attrs, attrs);
 
 	if (worker_pool_assign_id(pool) < 0)
@@ -3322,7 +3375,41 @@ fail:
 	return NULL;
 }
 
-/* initialize @pwq which interfaces with @pool for @wq and link it in */
+static void rcu_free_pwq(struct rcu_head *rcu)
+{
+	kmem_cache_free(pwq_cache,
+			container_of(rcu, struct pool_workqueue, rcu));
+}
+
+/*
+ * Scheduled on system_wq by put_pwq() when an unbound pwq hits zero refcnt
+ * and needs to be destroyed.
+ */
+static void pwq_unbound_release_workfn(struct work_struct *work)
+{
+	struct pool_workqueue *pwq = container_of(work, struct pool_workqueue,
+						  unbound_release_work);
+	struct workqueue_struct *wq = pwq->wq;
+	struct worker_pool *pool = pwq->pool;
+
+	if (WARN_ON_ONCE(!(wq->flags & WQ_UNBOUND)))
+		return;
+
+	spin_lock_irq(&workqueue_lock);
+	list_del_rcu(&pwq->pwqs_node);
+	spin_unlock_irq(&workqueue_lock);
+
+	put_unbound_pool(pool);
+	call_rcu_sched(&pwq->rcu, rcu_free_pwq);
+
+	/*
+	 * If we're the last pwq going away, @wq is already dead and no one
+	 * is gonna access it anymore.  Free it.
+	 */
+	if (list_empty(&wq->pwqs))
+		kfree(wq);
+}
+
 static void init_and_link_pwq(struct pool_workqueue *pwq,
 			      struct workqueue_struct *wq,
 			      struct worker_pool *pool)
@@ -3332,9 +3419,11 @@ static void init_and_link_pwq(struct pool_workqueue *pwq,
 	pwq->pool = pool;
 	pwq->wq = wq;
 	pwq->flush_color = -1;
+	pwq->refcnt = 1;
 	pwq->max_active = wq->saved_max_active;
 	INIT_LIST_HEAD(&pwq->delayed_works);
 	INIT_LIST_HEAD(&pwq->mayday_node);
+	INIT_WORK(&pwq->unbound_release_work, pwq_unbound_release_workfn);
 
 	list_add_tail_rcu(&pwq->pwqs_node, &wq->pwqs);
 }
@@ -3377,15 +3466,6 @@ static int alloc_and_link_pwqs(struct workqueue_struct *wq)
 	return 0;
 }
 
-static void free_pwqs(struct workqueue_struct *wq)
-{
-	if (!(wq->flags & WQ_UNBOUND))
-		free_percpu(wq->cpu_pwqs);
-	else if (!list_empty(&wq->pwqs))
-		kmem_cache_free(pwq_cache, list_first_entry(&wq->pwqs,
-					struct pool_workqueue, pwqs_node));
-}
-
 static int wq_clamp_max_active(int max_active, unsigned int flags,
 			       const char *name)
 {
@@ -3517,7 +3597,8 @@ void destroy_workqueue(struct workqueue_struct *wq)
 			}
 		}
 
-		if (WARN_ON(pwq->nr_active) ||
+		if (WARN_ON(pwq->refcnt > 1) ||
+		    WARN_ON(pwq->nr_active) ||
 		    WARN_ON(!list_empty(&pwq->delayed_works))) {
 			spin_unlock_irq(&workqueue_lock);
 			return;
@@ -3538,17 +3619,27 @@ void destroy_workqueue(struct workqueue_struct *wq)
 		wq->rescuer = NULL;
 	}
 
-	/*
-	 * We're the sole accessor of @wq at this point.  Directly access
-	 * the first pwq and put its pool.
-	 */
-	if (wq->flags & WQ_UNBOUND) {
+	if (!(wq->flags & WQ_UNBOUND)) {
+		/*
+		 * The base ref is never dropped on per-cpu pwqs.  Directly
+		 * free the pwqs and wq.
+		 */
+		free_percpu(wq->cpu_pwqs);
+		kfree(wq);
+	} else {
+		/*
+		 * We're the sole accessor of @wq at this point.  Directly
+		 * access the first pwq and put the base ref.  As both pwqs
+		 * and pools are sched-RCU protected, the lock operations
+		 * are safe.  @wq will be freed when the last pwq is
+		 * released.
+		 */
 		pwq = list_first_entry(&wq->pwqs, struct pool_workqueue,
 				       pwqs_node);
-		put_unbound_pool(pwq->pool);
+		spin_lock_irq(&pwq->pool->lock);
+		put_pwq(pwq);
+		spin_unlock_irq(&pwq->pool->lock);
 	}
-	free_pwqs(wq);
-	kfree(wq);
 }
 EXPORT_SYMBOL_GPL(destroy_workqueue);
 
-- 
1.8.1.2

