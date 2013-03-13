Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934495Ab3CMX6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 19:58:50 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:54386 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934436Ab3CMX63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 19:58:29 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: laijs@cn.fujitsu.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/6] workqueue: implement and use pwq_adjust_max_active()
Date: Wed, 13 Mar 2013 16:58:14 -0700
Message-Id: <1363219098-16083-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1363219098-16083-1-git-send-email-tj@kernel.org>
References: <1363219098-16083-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename pwq_set_max_active() to pwq_adjust_max_active() and move
pool_workqueue->max_active synchronization and max_active
determination logic into it.

The new function should be called with workqueue_lock held for stable
workqueue->saved_max_active, determines the current max_active value
the target pool_workqueue should be using from @wq->saved_max_active
and the state of the associated pool, and applies it with proper
synchronization.

The current two users - workqueue_set_max_active() and
thaw_workqueues() - are updated accordingly.  In addition, the manual
freezing handling in __alloc_workqueue_key() and
freeze_workqueues_begin() are replaced with calls to
pwq_adjust_max_active().

This centralizes max_active handling so that it's less error-prone.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 83 +++++++++++++++++++++++++-----------------------------
 1 file changed, 38 insertions(+), 45 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index d519289..9e2ec4c 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3726,23 +3726,38 @@ static void pwq_unbound_release_workfn(struct work_struct *work)
 }
 
 /**
- * pwq_set_max_active - adjust max_active of a pwq
+ * pwq_adjust_max_active - update a pwq's max_active to the current setting
  * @pwq: target pool_workqueue
- * @max_active: new max_active value.
- *
- * Set @pwq->max_active to @max_active and activate delayed works if
- * increased.
  *
- * CONTEXT:
- * spin_lock_irq(pool->lock).
+ * If @pwq isn't freezing, set @pwq->max_active to the associated
+ * workqueue's saved_max_active and activate delayed work items
+ * accordingly.  If @pwq is freezing, clear @pwq->max_active to zero.
  */
-static void pwq_set_max_active(struct pool_workqueue *pwq, int max_active)
+static void pwq_adjust_max_active(struct pool_workqueue *pwq)
 {
-	pwq->max_active = max_active;
+	struct workqueue_struct *wq = pwq->wq;
+	bool freezable = wq->flags & WQ_FREEZABLE;
+
+	/* for @wq->saved_max_active */
+	lockdep_assert_held(&workqueue_lock);
+
+	/* fast exit for non-freezable wqs */
+	if (!freezable && pwq->max_active == wq->saved_max_active)
+		return;
+
+	spin_lock(&pwq->pool->lock);
+
+	if (!freezable || !(pwq->pool->flags & POOL_FREEZING)) {
+		pwq->max_active = wq->saved_max_active;
 
-	while (!list_empty(&pwq->delayed_works) &&
-	       pwq->nr_active < pwq->max_active)
-		pwq_activate_first_delayed(pwq);
+		while (!list_empty(&pwq->delayed_works) &&
+		       pwq->nr_active < pwq->max_active)
+			pwq_activate_first_delayed(pwq);
+	} else {
+		pwq->max_active = 0;
+	}
+
+	spin_unlock(&pwq->pool->lock);
 }
 
 static void init_and_link_pwq(struct pool_workqueue *pwq,
@@ -3932,15 +3947,14 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 		goto err_destroy;
 
 	/*
-	 * workqueue_lock protects global freeze state and workqueues
-	 * list.  Grab it, set max_active accordingly and add the new
-	 * workqueue to workqueues list.
+	 * workqueue_lock protects global freeze state and workqueues list.
+	 * Grab it, adjust max_active and add the new workqueue to
+	 * workqueues list.
 	 */
 	spin_lock_irq(&workqueue_lock);
 
-	if (workqueue_freezing && wq->flags & WQ_FREEZABLE)
-		for_each_pwq(pwq, wq)
-			pwq->max_active = 0;
+	for_each_pwq(pwq, wq)
+		pwq_adjust_max_active(pwq);
 
 	list_add(&wq->list, &workqueues);
 
@@ -4055,17 +4069,8 @@ void workqueue_set_max_active(struct workqueue_struct *wq, int max_active)
 
 	wq->saved_max_active = max_active;
 
-	for_each_pwq(pwq, wq) {
-		struct worker_pool *pool = pwq->pool;
-
-		spin_lock(&pool->lock);
-
-		if (!(wq->flags & WQ_FREEZABLE) ||
-		    !(pool->flags & POOL_FREEZING))
-			pwq_set_max_active(pwq, max_active);
-
-		spin_unlock(&pool->lock);
-	}
+	for_each_pwq(pwq, wq)
+		pwq_adjust_max_active(pwq);
 
 	spin_unlock_irq(&workqueue_lock);
 }
@@ -4358,14 +4363,8 @@ void freeze_workqueues_begin(void)
 
 	/* suppress further executions by setting max_active to zero */
 	list_for_each_entry(wq, &workqueues, list) {
-		if (!(wq->flags & WQ_FREEZABLE))
-			continue;
-
-		for_each_pwq(pwq, wq) {
-			spin_lock(&pwq->pool->lock);
-			pwq->max_active = 0;
-			spin_unlock(&pwq->pool->lock);
-		}
+		for_each_pwq(pwq, wq)
+			pwq_adjust_max_active(pwq);
 	}
 
 	spin_unlock_irq(&workqueue_lock);
@@ -4445,14 +4444,8 @@ void thaw_workqueues(void)
 
 	/* restore max_active and repopulate worklist */
 	list_for_each_entry(wq, &workqueues, list) {
-		if (!(wq->flags & WQ_FREEZABLE))
-			continue;
-
-		for_each_pwq(pwq, wq) {
-			spin_lock(&pwq->pool->lock);
-			pwq_set_max_active(pwq, wq->saved_max_active);
-			spin_unlock(&pwq->pool->lock);
-		}
+		for_each_pwq(pwq, wq)
+			pwq_adjust_max_active(pwq);
 	}
 
 	/* kick workers */
-- 
1.8.1.4

