Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068Ab3DDCGI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 22:06:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:9928 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932815Ab3DDCF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 22:05:57 -0400
X-IronPort-AV: E=Sophos;i="4.87,404,1363104000"; 
   d="scan'208";a="6998068"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 1/7] workqueue: add __WQ_FREEZING and remove POOL_FREEZING
Date: Thu, 4 Apr 2013 10:05:32 +0800
Message-Id: <1365041143-3088-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/04 10:04:54,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/04 10:04:54,
	Serialize complete at 2013/04/04 10:04:54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

freezing is nothing related to pools, but POOL_FREEZING adds a connection,
and causes freeze_workqueues_begin() and thaw_workqueues() complicated.

Since freezing is workqueue instance attribute, so we introduce __WQ_FREEZING
to wq->flags instead and remove POOL_FREEZING.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/workqueue.h |    1 +
 kernel/workqueue.c        |   33 +++++++--------------------------
 2 files changed, 8 insertions(+), 26 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 7179756..672b51e 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -300,6 +300,7 @@ enum {
 	WQ_CPU_INTENSIVE	= 1 << 5, /* cpu instensive workqueue */
 	WQ_SYSFS		= 1 << 6, /* visible in sysfs, see wq_sysfs_register() */
 
+	__WQ_FREEZING		= 1 << 15, /* internel: workqueue is freezing */
 	__WQ_DRAINING		= 1 << 16, /* internal: workqueue is draining */
 	__WQ_ORDERED		= 1 << 17, /* internal: workqueue is ordered */
 
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index dd2a4c4..e06a5b0 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -68,7 +68,6 @@ enum {
 	 */
 	POOL_MANAGE_WORKERS	= 1 << 0,	/* need to manage workers */
 	POOL_DISASSOCIATED	= 1 << 2,	/* cpu can't serve workers */
-	POOL_FREEZING		= 1 << 3,	/* freeze in progress */
 
 	/* worker flags */
 	WORKER_STARTED		= 1 << 0,	/* started */
@@ -3556,9 +3555,6 @@ static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
 	if (!pool || init_worker_pool(pool) < 0)
 		goto fail;
 
-	if (workqueue_freezing)
-		pool->flags |= POOL_FREEZING;
-
 	lockdep_set_subclass(&pool->lock, 1);	/* see put_pwq() */
 	copy_workqueue_attrs(pool->attrs, attrs);
 
@@ -3650,7 +3646,7 @@ static void pwq_adjust_max_active(struct pool_workqueue *pwq)
 	struct workqueue_struct *wq = pwq->wq;
 	bool freezable = wq->flags & WQ_FREEZABLE;
 
-	/* for @wq->saved_max_active */
+	/* for @wq->saved_max_active and @wq->flags */
 	lockdep_assert_held(&wq->mutex);
 
 	/* fast exit for non-freezable wqs */
@@ -3659,7 +3655,7 @@ static void pwq_adjust_max_active(struct pool_workqueue *pwq)
 
 	spin_lock_irq(&pwq->pool->lock);
 
-	if (!freezable || !(pwq->pool->flags & POOL_FREEZING)) {
+	if (!freezable || !(wq->flags & __WQ_FREEZING)) {
 		pwq->max_active = wq->saved_max_active;
 
 		while (!list_empty(&pwq->delayed_works) &&
@@ -4155,6 +4151,8 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	mutex_lock(&wq_pool_mutex);
 
 	mutex_lock(&wq->mutex);
+	if (workqueue_freezing)
+		wq->flags |= __WQ_FREEZING;
 	for_each_pwq(pwq, wq)
 		pwq_adjust_max_active(pwq);
 	mutex_unlock(&wq->mutex);
@@ -4670,26 +4668,18 @@ EXPORT_SYMBOL_GPL(work_on_cpu);
  */
 void freeze_workqueues_begin(void)
 {
-	struct worker_pool *pool;
 	struct workqueue_struct *wq;
 	struct pool_workqueue *pwq;
-	int pi;
 
 	mutex_lock(&wq_pool_mutex);
 
 	WARN_ON_ONCE(workqueue_freezing);
 	workqueue_freezing = true;
 
-	/* set FREEZING */
-	for_each_pool(pool, pi) {
-		spin_lock_irq(&pool->lock);
-		WARN_ON_ONCE(pool->flags & POOL_FREEZING);
-		pool->flags |= POOL_FREEZING;
-		spin_unlock_irq(&pool->lock);
-	}
-
 	list_for_each_entry(wq, &workqueues, list) {
 		mutex_lock(&wq->mutex);
+		WARN_ON_ONCE(wq->flags & __WQ_FREEZING);
+		wq->flags |= __WQ_FREEZING;
 		for_each_pwq(pwq, wq)
 			pwq_adjust_max_active(pwq);
 		mutex_unlock(&wq->mutex);
@@ -4757,25 +4747,16 @@ void thaw_workqueues(void)
 {
 	struct workqueue_struct *wq;
 	struct pool_workqueue *pwq;
-	struct worker_pool *pool;
-	int pi;
 
 	mutex_lock(&wq_pool_mutex);
 
 	if (!workqueue_freezing)
 		goto out_unlock;
 
-	/* clear FREEZING */
-	for_each_pool(pool, pi) {
-		spin_lock_irq(&pool->lock);
-		WARN_ON_ONCE(!(pool->flags & POOL_FREEZING));
-		pool->flags &= ~POOL_FREEZING;
-		spin_unlock_irq(&pool->lock);
-	}
-
 	/* restore max_active and repopulate worklist */
 	list_for_each_entry(wq, &workqueues, list) {
 		mutex_lock(&wq->mutex);
+		wq->flags &= ~__WQ_FREEZING;
 		for_each_pwq(pwq, wq)
 			pwq_adjust_max_active(pwq);
 		mutex_unlock(&wq->mutex);
-- 
1.7.7.6

