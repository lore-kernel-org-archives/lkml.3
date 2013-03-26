Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933909Ab3CZAHy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 20:07:54 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:49288 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932300Ab3CZAHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 20:07:51 -0400
From: Tejun Heo <tj@kernel.org>
To: laijs@cn.fujitsu.com
Cc: linux-kernel@vger.kernel.org, js1304@gmail.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/6] workqueue: protect wq->saved_max_active with wq->mutex
Date: Mon, 25 Mar 2013 17:07:28 -0700
Message-Id: <1364256449-11401-6-git-send-email-tj@kernel.org>
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

This patch makes wq->saved_max_active protected by wq->mutex instead
of pwq_lock.  As pwq_lock locking around pwq_adjust_mac_active() is no
longer necessary, this patch also replaces pwq_lock lockings of
for_each_pwq() around pwq_adjust_max_active() to wq->mutex.

tj: Rebased on top of the current dev branch.  Updated description.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 9c32fd1..af6087a 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -243,7 +243,7 @@ struct workqueue_struct {
 	struct worker		*rescuer;	/* I: rescue worker */
 
 	int			nr_drainers;	/* WQ: drain in progress */
-	int			saved_max_active; /* PW: saved pwq max_active */
+	int			saved_max_active; /* WQ: saved pwq max_active */
 
 #ifdef CONFIG_SYSFS
 	struct wq_device	*wq_dev;	/* I: for sysfs interface */
@@ -3579,13 +3579,13 @@ static void pwq_adjust_max_active(struct pool_workqueue *pwq)
 	bool freezable = wq->flags & WQ_FREEZABLE;
 
 	/* for @wq->saved_max_active */
-	lockdep_assert_held(&pwq_lock);
+	lockdep_assert_held(&wq->mutex);
 
 	/* fast exit for non-freezable wqs */
 	if (!freezable && pwq->max_active == wq->saved_max_active)
 		return;
 
-	spin_lock(&pwq->pool->lock);
+	spin_lock_irq(&pwq->pool->lock);
 
 	if (!freezable || !(pwq->pool->flags & POOL_FREEZING)) {
 		pwq->max_active = wq->saved_max_active;
@@ -3603,7 +3603,7 @@ static void pwq_adjust_max_active(struct pool_workqueue *pwq)
 		pwq->max_active = 0;
 	}
 
-	spin_unlock(&pwq->pool->lock);
+	spin_unlock_irq(&pwq->pool->lock);
 }
 
 static void init_and_link_pwq(struct pool_workqueue *pwq,
@@ -3622,7 +3622,6 @@ static void init_and_link_pwq(struct pool_workqueue *pwq,
 	INIT_WORK(&pwq->unbound_release_work, pwq_unbound_release_workfn);
 
 	mutex_lock(&wq->mutex);
-	spin_lock_irq(&pwq_lock);
 
 	/*
 	 * Set the matching work_color.  This is synchronized with
@@ -3636,9 +3635,10 @@ static void init_and_link_pwq(struct pool_workqueue *pwq,
 	pwq_adjust_max_active(pwq);
 
 	/* link in @pwq */
+	spin_lock_irq(&pwq_lock);
 	list_add_rcu(&pwq->pwqs_node, &wq->pwqs);
-
 	spin_unlock_irq(&pwq_lock);
+
 	mutex_unlock(&wq->mutex);
 }
 
@@ -3803,10 +3803,10 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	 */
 	mutex_lock(&wq_pool_mutex);
 
-	spin_lock_irq(&pwq_lock);
+	mutex_lock(&wq->mutex);
 	for_each_pwq(pwq, wq)
 		pwq_adjust_max_active(pwq);
-	spin_unlock_irq(&pwq_lock);
+	mutex_unlock(&wq->mutex);
 
 	list_add(&wq->list, &workqueues);
 
@@ -3917,14 +3917,14 @@ void workqueue_set_max_active(struct workqueue_struct *wq, int max_active)
 
 	max_active = wq_clamp_max_active(max_active, wq->flags, wq->name);
 
-	spin_lock_irq(&pwq_lock);
+	mutex_lock(&wq->mutex);
 
 	wq->saved_max_active = max_active;
 
 	for_each_pwq(pwq, wq)
 		pwq_adjust_max_active(pwq);
 
-	spin_unlock_irq(&pwq_lock);
+	mutex_unlock(&wq->mutex);
 }
 EXPORT_SYMBOL_GPL(workqueue_set_max_active);
 
@@ -4287,7 +4287,7 @@ EXPORT_SYMBOL_GPL(work_on_cpu);
  * pool->worklist.
  *
  * CONTEXT:
- * Grabs and releases wq_pool_mutex, pwq_lock and pool->lock's.
+ * Grabs and releases wq_pool_mutex, wq->mutex and pool->lock's.
  */
 void freeze_workqueues_begin(void)
 {
@@ -4309,13 +4309,12 @@ void freeze_workqueues_begin(void)
 		spin_unlock_irq(&pool->lock);
 	}
 
-	/* suppress further executions by setting max_active to zero */
-	spin_lock_irq(&pwq_lock);
 	list_for_each_entry(wq, &workqueues, list) {
+		mutex_lock(&wq->mutex);
 		for_each_pwq(pwq, wq)
 			pwq_adjust_max_active(pwq);
+		mutex_unlock(&wq->mutex);
 	}
-	spin_unlock_irq(&pwq_lock);
 
 	mutex_unlock(&wq_pool_mutex);
 }
@@ -4373,7 +4372,7 @@ out_unlock:
  * frozen works are transferred to their respective pool worklists.
  *
  * CONTEXT:
- * Grabs and releases wq_pool_mutex, pwq_lock and pool->lock's.
+ * Grabs and releases wq_pool_mutex, wq->mutex and pool->lock's.
  */
 void thaw_workqueues(void)
 {
@@ -4396,12 +4395,12 @@ void thaw_workqueues(void)
 	}
 
 	/* restore max_active and repopulate worklist */
-	spin_lock_irq(&pwq_lock);
 	list_for_each_entry(wq, &workqueues, list) {
+		mutex_lock(&wq->mutex);
 		for_each_pwq(pwq, wq)
 			pwq_adjust_max_active(pwq);
+		mutex_unlock(&wq->mutex);
 	}
-	spin_unlock_irq(&pwq_lock);
 
 	workqueue_freezing = false;
 out_unlock:
-- 
1.8.1.4

