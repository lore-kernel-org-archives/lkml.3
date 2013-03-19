Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933677Ab3CST3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 15:29:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:34778 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933323Ab3CST25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 15:28:57 -0400
X-IronPort-AV: E=Sophos;i="4.84,874,1355068800"; 
   d="scan'208";a="6904507"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 12/21] workqueue: use wq->mutex to protect saved_max_active
Date: Wed, 20 Mar 2013 03:28:12 +0800
Message-Id: <1363721306-2030-13-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
References: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/20 03:27:30,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/20 03:27:30,
	Serialize complete at 2013/03/20 03:27:30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

saved_max_active is instance's field, so we use wq->mutex to protect
saved_max_active and pwq_adjust_max_active().

The patch also convert for_each_pwq()(which are around pwq_adjust_max_active())
to be protected by wq->mutex.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   29 ++++++++++++++---------------
 1 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 41e7737..a3460e7 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -245,7 +245,7 @@ struct workqueue_struct {
 	struct worker		*rescuer;	/* I: rescue worker */
 
 	int			nr_drainers;	/* Q: drain in progress */
-	int			saved_max_active; /* PW: saved pwq max_active */
+	int			saved_max_active; /* Q: saved pwq max_active */
 
 #ifdef CONFIG_SYSFS
 	struct wq_device	*wq_dev;	/* I: for sysfs interface */
@@ -3581,13 +3581,13 @@ static void pwq_adjust_max_active(struct pool_workqueue *pwq)
 	bool freezable = wq->flags & WQ_FREEZABLE;
 
 	/* for @wq->saved_max_active */
-	lockdep_assert_held(&pwq_lock);
+	lockdep_assert_held(&wq->mutex);
 
 	/* fast exit for non-freezable wqs */
 	if (!freezable && pwq->max_active == wq->saved_max_active)
 		return;
 
-	spin_lock(&pwq->pool->lock);
+	spin_lock_irq(&pwq->pool->lock);
 
 	if (freezable && (pwq->pool->flags & POOL_FREEZING)) {
 		pwq->max_active = 0;
@@ -3607,7 +3607,7 @@ static void pwq_adjust_max_active(struct pool_workqueue *pwq)
 		wake_up_worker(pwq->pool);
 	}
 
-	spin_unlock(&pwq->pool->lock);
+	spin_unlock_irq(&pwq->pool->lock);
 }
 
 static void init_and_link_pwq(struct pool_workqueue *pwq,
@@ -3626,7 +3626,6 @@ static void init_and_link_pwq(struct pool_workqueue *pwq,
 	INIT_WORK(&pwq->unbound_release_work, pwq_unbound_release_workfn);
 
 	mutex_lock(&wq->mutex);
-	spin_lock_irq(&pwq_lock);
 
 	/*
 	 * Set the matching work_color.  This is synchronized with
@@ -3640,9 +3639,10 @@ static void init_and_link_pwq(struct pool_workqueue *pwq,
 	pwq_adjust_max_active(pwq);
 
 	/* link in @pwq */
+	spin_lock_irq(&pwq_lock);
 	list_add_rcu(&pwq->pwqs_node, &wq->pwqs);
-
 	spin_unlock_irq(&pwq_lock);
+
 	mutex_unlock(&wq->mutex);
 }
 
@@ -3806,10 +3806,10 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	 */
 	mutex_lock(&wqs_mutex);
 
-	spin_lock_irq(&pwq_lock);
+	mutex_lock(&wq->mutex);
 	for_each_pwq(pwq, wq)
 		pwq_adjust_max_active(pwq);
-	spin_unlock_irq(&pwq_lock);
+	mutex_unlock(&wq->mutex);
 
 	list_add(&wq->list, &workqueues);
 
@@ -3920,14 +3920,14 @@ void workqueue_set_max_active(struct workqueue_struct *wq, int max_active)
 
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
 
@@ -4314,13 +4314,12 @@ void freeze_workqueues_begin(void)
 	}
 	mutex_unlock(&pools_mutex);
 
-	/* suppress further executions by setting max_active to zero */
-	spin_lock_irq(&pwq_lock);
 	list_for_each_entry(wq, &workqueues, list) {
+		mutex_lock(&wq->mutex);
 		for_each_pwq(pwq, wq)
 			pwq_adjust_max_active(pwq);
+		mutex_unlock(&wq->mutex);
 	}
-	spin_unlock_irq(&pwq_lock);
 
 	mutex_unlock(&wqs_mutex);
 }
@@ -4404,12 +4403,12 @@ void thaw_workqueues(void)
 	mutex_unlock(&pools_mutex);
 
 	/* restore max_active and repopulate worklist */
-	spin_lock_irq(&pwq_lock);
 	list_for_each_entry(wq, &workqueues, list) {
+		mutex_lock(&wq->mutex);
 		for_each_pwq(pwq, wq)
 			pwq_adjust_max_active(pwq);
+		mutex_unlock(&wq->mutex);
 	}
-	spin_unlock_irq(&pwq_lock);
 out_unlock:
 	mutex_unlock(&wqs_mutex);
 }
-- 
1.7.7.6

