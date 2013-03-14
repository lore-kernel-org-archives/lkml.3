Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934468Ab3CNC6C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 22:58:02 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:38583 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964827Ab3CNC5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 22:57:43 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: laijs@cn.fujitsu.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/7] workqueue: separate out pool_workqueue locking into pwq_lock
Date: Wed, 13 Mar 2013 19:57:24 -0700
Message-Id: <1363229845-6831-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1363229845-6831-1-git-send-email-tj@kernel.org>
References: <1363229845-6831-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch continues locking cleanup from the previous patch.  It
breaks out pool_workqueue synchronization from workqueue_lock into a
new spinlock - pwq_lock.  The followings are protected by pwq_lock.

* workqueue->pwqs
* workqueue->saved_max_active

The conversion is straight-forward.  workqueue_lock usages which cover
the above two are converted to pwq_lock.  New locking label PW added
for things protected by pwq_lock and FR is updated to mean flush_mutex
+ pwq_lock + sched-RCU.

This patch shouldn't introduce any visible behavior changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 69 ++++++++++++++++++++++++++++--------------------------
 1 file changed, 36 insertions(+), 33 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index c3b59ff..63856df 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -123,9 +123,11 @@ enum {
  *
  * WR: wq_mutex protected for writes.  Sched-RCU protected for reads.
  *
+ * PW: pwq_lock protected.
+ *
  * W: workqueue_lock protected.
  *
- * FR: wq->flush_mutex and workqueue_lock protected for writes.  Sched-RCU
+ * FR: wq->flush_mutex and pwq_lock protected for writes.  Sched-RCU
  *     protected for reads.
  */
 
@@ -198,7 +200,7 @@ struct pool_workqueue {
 	 * Release of unbound pwq is punted to system_wq.  See put_pwq()
 	 * and pwq_unbound_release_workfn() for details.  pool_workqueue
 	 * itself is also sched-RCU protected so that the first pwq can be
-	 * determined without grabbing workqueue_lock.
+	 * determined without grabbing pwq_lock.
 	 */
 	struct work_struct	unbound_release_work;
 	struct rcu_head		rcu;
@@ -237,7 +239,7 @@ struct workqueue_struct {
 	struct worker		*rescuer;	/* I: rescue worker */
 
 	int			nr_drainers;	/* WQ: drain in progress */
-	int			saved_max_active; /* W: saved pwq max_active */
+	int			saved_max_active; /* PW: saved pwq max_active */
 
 #ifdef CONFIG_SYSFS
 	struct wq_device	*wq_dev;	/* I: for sysfs interface */
@@ -251,6 +253,7 @@ struct workqueue_struct {
 static struct kmem_cache *pwq_cache;
 
 static DEFINE_MUTEX(wq_mutex);		/* protects workqueues and pools */
+static DEFINE_SPINLOCK(pwq_lock);	/* protects pool_workqueues */
 static DEFINE_SPINLOCK(workqueue_lock);
 
 static LIST_HEAD(workqueues);		/* WQ: list of all workqueues */
@@ -291,10 +294,10 @@ static void copy_workqueue_attrs(struct workqueue_attrs *to,
 			   lockdep_is_held(&wq_mutex),			\
 			   "sched RCU or wq_mutex should be held")
 
-#define assert_rcu_or_wq_lock()						\
+#define assert_rcu_or_pwq_lock()					\
 	rcu_lockdep_assert(rcu_read_lock_sched_held() ||		\
-			   lockdep_is_held(&workqueue_lock),		\
-			   "sched RCU or workqueue lock should be held")
+			   lockdep_is_held(&pwq_lock),			\
+			   "sched RCU or pwq_lock should be held")
 
 #define for_each_cpu_worker_pool(pool, cpu)				\
 	for ((pool) = &per_cpu(cpu_worker_pools, cpu)[0];		\
@@ -326,16 +329,16 @@ static void copy_workqueue_attrs(struct workqueue_attrs *to,
  * @pwq: iteration cursor
  * @wq: the target workqueue
  *
- * This must be called either with workqueue_lock held or sched RCU read
- * locked.  If the pwq needs to be used beyond the locking in effect, the
- * caller is responsible for guaranteeing that the pwq stays online.
+ * This must be called either with pwq_lock held or sched RCU read locked.
+ * If the pwq needs to be used beyond the locking in effect, the caller is
+ * responsible for guaranteeing that the pwq stays online.
  *
  * The if/else clause exists only for the lockdep assertion and can be
  * ignored.
  */
 #define for_each_pwq(pwq, wq)						\
 	list_for_each_entry_rcu((pwq), &(wq)->pwqs, pwqs_node)		\
-		if (({ assert_rcu_or_wq_lock(); false; })) { }		\
+		if (({ assert_rcu_or_pwq_lock(); false; })) { }		\
 		else
 
 #ifdef CONFIG_DEBUG_OBJECTS_WORK
@@ -474,13 +477,13 @@ static int worker_pool_assign_id(struct worker_pool *pool)
  * first_pwq - return the first pool_workqueue of the specified workqueue
  * @wq: the target workqueue
  *
- * This must be called either with workqueue_lock held or sched RCU read
- * locked.  If the pwq needs to be used beyond the locking in effect, the
- * caller is responsible for guaranteeing that the pwq stays online.
+ * This must be called either with pwq_lock held or sched RCU read locked.
+ * If the pwq needs to be used beyond the locking in effect, the caller is
+ * responsible for guaranteeing that the pwq stays online.
  */
 static struct pool_workqueue *first_pwq(struct workqueue_struct *wq)
 {
-	assert_rcu_or_wq_lock();
+	assert_rcu_or_pwq_lock();
 	return list_first_or_null_rcu(&wq->pwqs, struct pool_workqueue,
 				      pwqs_node);
 }
@@ -3639,9 +3642,9 @@ static void pwq_unbound_release_workfn(struct work_struct *work)
 	 * and consistent with the linking path.
 	 */
 	mutex_lock(&wq->flush_mutex);
-	spin_lock_irq(&workqueue_lock);
+	spin_lock_irq(&pwq_lock);
 	list_del_rcu(&pwq->pwqs_node);
-	spin_unlock_irq(&workqueue_lock);
+	spin_unlock_irq(&pwq_lock);
 	mutex_unlock(&wq->flush_mutex);
 
 	put_unbound_pool(pool);
@@ -3669,7 +3672,7 @@ static void pwq_adjust_max_active(struct pool_workqueue *pwq)
 	bool freezable = wq->flags & WQ_FREEZABLE;
 
 	/* for @wq->saved_max_active */
-	lockdep_assert_held(&workqueue_lock);
+	lockdep_assert_held(&pwq_lock);
 
 	/* fast exit for non-freezable wqs */
 	if (!freezable && pwq->max_active == wq->saved_max_active)
@@ -3706,7 +3709,7 @@ static void init_and_link_pwq(struct pool_workqueue *pwq,
 	INIT_WORK(&pwq->unbound_release_work, pwq_unbound_release_workfn);
 
 	mutex_lock(&wq->flush_mutex);
-	spin_lock_irq(&workqueue_lock);
+	spin_lock_irq(&pwq_lock);
 
 	/*
 	 * Set the matching work_color.  This is synchronized with
@@ -3722,7 +3725,7 @@ static void init_and_link_pwq(struct pool_workqueue *pwq,
 	/* link in @pwq */
 	list_add_rcu(&pwq->pwqs_node, &wq->pwqs);
 
-	spin_unlock_irq(&workqueue_lock);
+	spin_unlock_irq(&pwq_lock);
 	mutex_unlock(&wq->flush_mutex);
 }
 
@@ -3886,10 +3889,10 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	 */
 	mutex_lock(&wq_mutex);
 
-	spin_lock_irq(&workqueue_lock);
+	spin_lock_irq(&pwq_lock);
 	for_each_pwq(pwq, wq)
 		pwq_adjust_max_active(pwq);
-	spin_unlock_irq(&workqueue_lock);
+	spin_unlock_irq(&pwq_lock);
 
 	list_add(&wq->list, &workqueues);
 
@@ -3920,13 +3923,13 @@ void destroy_workqueue(struct workqueue_struct *wq)
 	drain_workqueue(wq);
 
 	/* sanity checks */
-	spin_lock_irq(&workqueue_lock);
+	spin_lock_irq(&pwq_lock);
 	for_each_pwq(pwq, wq) {
 		int i;
 
 		for (i = 0; i < WORK_NR_COLORS; i++) {
 			if (WARN_ON(pwq->nr_in_flight[i])) {
-				spin_unlock_irq(&workqueue_lock);
+				spin_unlock_irq(&pwq_lock);
 				return;
 			}
 		}
@@ -3934,11 +3937,11 @@ void destroy_workqueue(struct workqueue_struct *wq)
 		if (WARN_ON(pwq->refcnt > 1) ||
 		    WARN_ON(pwq->nr_active) ||
 		    WARN_ON(!list_empty(&pwq->delayed_works))) {
-			spin_unlock_irq(&workqueue_lock);
+			spin_unlock_irq(&pwq_lock);
 			return;
 		}
 	}
-	spin_unlock_irq(&workqueue_lock);
+	spin_unlock_irq(&pwq_lock);
 
 	/*
 	 * wq list is used to freeze wq, remove from list after
@@ -4000,14 +4003,14 @@ void workqueue_set_max_active(struct workqueue_struct *wq, int max_active)
 
 	max_active = wq_clamp_max_active(max_active, wq->flags, wq->name);
 
-	spin_lock_irq(&workqueue_lock);
+	spin_lock_irq(&pwq_lock);
 
 	wq->saved_max_active = max_active;
 
 	for_each_pwq(pwq, wq)
 		pwq_adjust_max_active(pwq);
 
-	spin_unlock_irq(&workqueue_lock);
+	spin_unlock_irq(&pwq_lock);
 }
 EXPORT_SYMBOL_GPL(workqueue_set_max_active);
 
@@ -4266,7 +4269,7 @@ EXPORT_SYMBOL_GPL(work_on_cpu);
  * pool->worklist.
  *
  * CONTEXT:
- * Grabs and releases wq_mutex, workqueue_lock and pool->lock's.
+ * Grabs and releases wq_mutex, pwq_lock and pool->lock's.
  */
 void freeze_workqueues_begin(void)
 {
@@ -4289,12 +4292,12 @@ void freeze_workqueues_begin(void)
 	}
 
 	/* suppress further executions by setting max_active to zero */
-	spin_lock_irq(&workqueue_lock);
+	spin_lock_irq(&pwq_lock);
 	list_for_each_entry(wq, &workqueues, list) {
 		for_each_pwq(pwq, wq)
 			pwq_adjust_max_active(pwq);
 	}
-	spin_unlock_irq(&workqueue_lock);
+	spin_unlock_irq(&pwq_lock);
 
 	mutex_unlock(&wq_mutex);
 }
@@ -4352,7 +4355,7 @@ out_unlock:
  * frozen works are transferred to their respective pool worklists.
  *
  * CONTEXT:
- * Grabs and releases wq_mutex, workqueue_lock and pool->lock's.
+ * Grabs and releases wq_mutex, pwq_lock and pool->lock's.
  */
 void thaw_workqueues(void)
 {
@@ -4375,12 +4378,12 @@ void thaw_workqueues(void)
 	}
 
 	/* restore max_active and repopulate worklist */
-	spin_lock_irq(&workqueue_lock);
+	spin_lock_irq(&pwq_lock);
 	list_for_each_entry(wq, &workqueues, list) {
 		for_each_pwq(pwq, wq)
 			pwq_adjust_max_active(pwq);
 	}
-	spin_unlock_irq(&workqueue_lock);
+	spin_unlock_irq(&pwq_lock);
 
 	/* kick workers */
 	for_each_pool(pool, pi) {
-- 
1.8.1.4

