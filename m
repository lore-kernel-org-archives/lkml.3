Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933934Ab3CZAHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 20:07:55 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:62231 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933870Ab3CZAHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 20:07:49 -0400
From: Tejun Heo <tj@kernel.org>
To: laijs@cn.fujitsu.com
Cc: linux-kernel@vger.kernel.org, js1304@gmail.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/6] workqueue: protect wq->pwqs and iteration with wq->mutex
Date: Mon, 25 Mar 2013 17:07:27 -0700
Message-Id: <1364256449-11401-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1364256449-11401-1-git-send-email-tj@kernel.org>
References: <1364256449-11401-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

We're expanding wq->mutex to cover all fields specific to each
workqueue with the end goal of replacing pwq_lock which will make
locking simpler and easier to understand.

init_and_link_pwq() and pwq_unbound_release_workfn() already grab
wq->mutex when adding or removing a pwq from wq->pwqs list.  This
patch makes it official that the list is wq->mutex protected for
writes and updates readers accoridingly.  Explicit IRQ toggles for
sched-RCU read-locking in flush_workqueue_prep_pwqs() and
drain_workqueues() are removed as the surrounding wq->mutex can
provide sufficient synchronization.

Also, assert_rcu_or_pwq_lock() is renamed to assert_rcu_or_wq_mutex()
and checks for wq->mutex too.

pwq_lock locking and assertion are not removed by this patch and a
couple of for_each_pwq() iterations are still protected by it.
They'll be removed by future patches.

tj: Rebased on top of the current dev branch.  Updated description.
    Folded in assert_rcu_or_wq_mutex() renaming from a later patch
    along with associated comment updates.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 42 ++++++++++++++++++------------------------
 1 file changed, 18 insertions(+), 24 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 3ac2c4d..9c32fd1 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -204,7 +204,7 @@ struct pool_workqueue {
 	 * Release of unbound pwq is punted to system_wq.  See put_pwq()
 	 * and pwq_unbound_release_workfn() for details.  pool_workqueue
 	 * itself is also sched-RCU protected so that the first pwq can be
-	 * determined without grabbing pwq_lock.
+	 * determined without grabbing wq->mutex.
 	 */
 	struct work_struct	unbound_release_work;
 	struct rcu_head		rcu;
@@ -298,10 +298,11 @@ static void copy_workqueue_attrs(struct workqueue_attrs *to,
 			   lockdep_is_held(&wq_pool_mutex),		\
 			   "sched RCU or wq_pool_mutex should be held")
 
-#define assert_rcu_or_pwq_lock()					\
+#define assert_rcu_or_wq_mutex(wq)					\
 	rcu_lockdep_assert(rcu_read_lock_sched_held() ||		\
+			   lockdep_is_held(&wq->mutex) ||		\
 			   lockdep_is_held(&pwq_lock),			\
-			   "sched RCU or pwq_lock should be held")
+			   "sched RCU or wq->mutex should be held")
 
 #ifdef CONFIG_LOCKDEP
 #define assert_manager_or_pool_lock(pool)				\
@@ -356,7 +357,7 @@ static void copy_workqueue_attrs(struct workqueue_attrs *to,
  * @pwq: iteration cursor
  * @wq: the target workqueue
  *
- * This must be called either with pwq_lock held or sched RCU read locked.
+ * This must be called either with wq->mutex held or sched RCU read locked.
  * If the pwq needs to be used beyond the locking in effect, the caller is
  * responsible for guaranteeing that the pwq stays online.
  *
@@ -365,7 +366,7 @@ static void copy_workqueue_attrs(struct workqueue_attrs *to,
  */
 #define for_each_pwq(pwq, wq)						\
 	list_for_each_entry_rcu((pwq), &(wq)->pwqs, pwqs_node)		\
-		if (({ assert_rcu_or_pwq_lock(); false; })) { }		\
+		if (({ assert_rcu_or_wq_mutex(wq); false; })) { }	\
 		else
 
 #ifdef CONFIG_DEBUG_OBJECTS_WORK
@@ -504,13 +505,13 @@ static int worker_pool_assign_id(struct worker_pool *pool)
  * first_pwq - return the first pool_workqueue of the specified workqueue
  * @wq: the target workqueue
  *
- * This must be called either with pwq_lock held or sched RCU read locked.
+ * This must be called either with wq->mutex held or sched RCU read locked.
  * If the pwq needs to be used beyond the locking in effect, the caller is
  * responsible for guaranteeing that the pwq stays online.
  */
 static struct pool_workqueue *first_pwq(struct workqueue_struct *wq)
 {
-	assert_rcu_or_pwq_lock();
+	assert_rcu_or_wq_mutex(wq);
 	return list_first_or_null_rcu(&wq->pwqs, struct pool_workqueue,
 				      pwqs_node);
 }
@@ -2477,12 +2478,10 @@ static bool flush_workqueue_prep_pwqs(struct workqueue_struct *wq,
 		atomic_set(&wq->nr_pwqs_to_flush, 1);
 	}
 
-	local_irq_disable();
-
 	for_each_pwq(pwq, wq) {
 		struct worker_pool *pool = pwq->pool;
 
-		spin_lock(&pool->lock);
+		spin_lock_irq(&pool->lock);
 
 		if (flush_color >= 0) {
 			WARN_ON_ONCE(pwq->flush_color != -1);
@@ -2499,11 +2498,9 @@ static bool flush_workqueue_prep_pwqs(struct workqueue_struct *wq,
 			pwq->work_color = work_color;
 		}
 
-		spin_unlock(&pool->lock);
+		spin_unlock_irq(&pool->lock);
 	}
 
-	local_irq_enable();
-
 	if (flush_color >= 0 && atomic_dec_and_test(&wq->nr_pwqs_to_flush))
 		complete(&wq->first_flusher->done);
 
@@ -2691,14 +2688,14 @@ void drain_workqueue(struct workqueue_struct *wq)
 reflush:
 	flush_workqueue(wq);
 
-	local_irq_disable();
+	mutex_lock(&wq->mutex);
 
 	for_each_pwq(pwq, wq) {
 		bool drained;
 
-		spin_lock(&pwq->pool->lock);
+		spin_lock_irq(&pwq->pool->lock);
 		drained = !pwq->nr_active && list_empty(&pwq->delayed_works);
-		spin_unlock(&pwq->pool->lock);
+		spin_unlock_irq(&pwq->pool->lock);
 
 		if (drained)
 			continue;
@@ -2708,13 +2705,10 @@ reflush:
 			pr_warn("workqueue %s: drain_workqueue() isn't complete after %u tries\n",
 				wq->name, flush_cnt);
 
-		local_irq_enable();
+		mutex_unlock(&wq->mutex);
 		goto reflush;
 	}
 
-	local_irq_enable();
-
-	mutex_lock(&wq->mutex);
 	if (!--wq->nr_drainers)
 		wq->flags &= ~__WQ_DRAINING;
 	mutex_unlock(&wq->mutex);
@@ -3843,13 +3837,13 @@ void destroy_workqueue(struct workqueue_struct *wq)
 	drain_workqueue(wq);
 
 	/* sanity checks */
-	spin_lock_irq(&pwq_lock);
+	mutex_lock(&wq->mutex);
 	for_each_pwq(pwq, wq) {
 		int i;
 
 		for (i = 0; i < WORK_NR_COLORS; i++) {
 			if (WARN_ON(pwq->nr_in_flight[i])) {
-				spin_unlock_irq(&pwq_lock);
+				mutex_unlock(&wq->mutex);
 				return;
 			}
 		}
@@ -3857,11 +3851,11 @@ void destroy_workqueue(struct workqueue_struct *wq)
 		if (WARN_ON(pwq->refcnt > 1) ||
 		    WARN_ON(pwq->nr_active) ||
 		    WARN_ON(!list_empty(&pwq->delayed_works))) {
-			spin_unlock_irq(&pwq_lock);
+			mutex_unlock(&wq->mutex);
 			return;
 		}
 	}
-	spin_unlock_irq(&pwq_lock);
+	mutex_unlock(&wq->mutex);
 
 	/*
 	 * wq list is used to freeze wq, remove from list after
-- 
1.8.1.4

