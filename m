Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933697Ab3CST3D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 15:29:03 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:43749 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933660Ab3CST27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 15:28:59 -0400
X-IronPort-AV: E=Sophos;i="4.84,874,1355068800"; 
   d="scan'208";a="6904509"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 14/21] workqueue: add wq->freezing and remove POOL_FREEZING
Date: Wed, 20 Mar 2013 03:28:14 +0800
Message-Id: <1363721306-2030-15-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
References: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/20 03:27:33,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/20 03:27:33,
	Serialize complete at 2013/03/20 03:27:33
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

freezing is nothing related to pools, but POOL_FREEZING adds a connection.
it causes:
	workqueue_freezing is protected by both wqs_mutex and pools_mutex.
	freeze_workqueues_begin() and thaw_workqueues() are very complicated.

Since freezing is workqueue instance attribute, so we introduce wq->freezing
instead and remove POOL_FREEZING. all the problem are solved.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   49 +++++++++++++++----------------------------------
 1 files changed, 15 insertions(+), 34 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index e45f038..db08b63 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -66,7 +66,6 @@ enum {
 	 */
 	POOL_MANAGE_WORKERS	= 1 << 0,	/* need to manage workers */
 	POOL_DISASSOCIATED	= 1 << 2,	/* cpu can't serve workers */
-	POOL_FREEZING		= 1 << 3,	/* freeze in progress */
 
 	/* worker flags */
 	WORKER_STARTED		= 1 << 0,	/* started */
@@ -243,6 +242,7 @@ struct workqueue_struct {
 
 	int			nr_drainers;	/* Q: drain in progress */
 	int			saved_max_active; /* Q: saved pwq max_active */
+	bool			freezing;	/* Q&QS: the wq is freezing */
 
 #ifdef CONFIG_SYSFS
 	struct wq_device	*wq_dev;	/* I: for sysfs interface */
@@ -260,7 +260,7 @@ static DEFINE_MUTEX(pools_mutex);	/* protects pools */
 static DEFINE_SPINLOCK(wq_mayday_lock);	/* protects wq->maydays list */
 
 static LIST_HEAD(workqueues);		/* QS: list of all workqueues */
-static bool workqueue_freezing;		/* QS&PS: have wqs started freezing? */
+static bool workqueue_freezing;		/* QS: have wqs started freezing? */
 
 /* the per-cpu worker pools */
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct worker_pool [NR_STD_WORKER_POOLS],
@@ -3495,9 +3495,6 @@ static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
 	if (!pool || init_worker_pool(pool) < 0)
 		goto fail;
 
-	if (workqueue_freezing)
-		pool->flags |= POOL_FREEZING;
-
 	lockdep_set_subclass(&pool->lock, 1);	/* see put_pwq() */
 	copy_workqueue_attrs(pool->attrs, attrs);
 
@@ -3573,18 +3570,17 @@ static void pwq_adjust_max_active(struct pool_workqueue *pwq)
 	struct workqueue_struct *wq = pwq->wq;
 	bool freezable = wq->flags & WQ_FREEZABLE;
 
-	/* for @wq->saved_max_active */
+	/* for @wq->saved_max_active and @wq->freezing */
 	lockdep_assert_held(&wq->mutex);
 
 	/* fast exit for non-freezable wqs */
 	if (!freezable && pwq->max_active == wq->saved_max_active)
 		return;
 
-	spin_lock_irq(&pwq->pool->lock);
-
-	if (freezable && (pwq->pool->flags & POOL_FREEZING)) {
+	if (freezable && wq->freezing) {
 		pwq->max_active = 0;
 	} else {
+		spin_lock_irq(&pwq->pool->lock);
 		pwq->max_active = wq->saved_max_active;
 
 		while (!list_empty(&pwq->delayed_works) &&
@@ -3598,9 +3594,8 @@ static void pwq_adjust_max_active(struct pool_workqueue *pwq)
 		 * But this function is slowpath, wake up worker unconditionally
 		 */
 		wake_up_worker(pwq->pool);
+		spin_unlock_irq(&pwq->pool->lock);
 	}
-
-	spin_unlock_irq(&pwq->pool->lock);
 }
 
 static void init_and_link_pwq(struct pool_workqueue *pwq,
@@ -3798,6 +3793,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	mutex_lock(&wqs_mutex);
 
 	mutex_lock(&wq->mutex);
+	wq->freezing = workqueue_freezing;
 	for_each_pwq(pwq, wq)
 		pwq_adjust_max_active(pwq);
 	mutex_unlock(&wq->mutex);
@@ -4285,28 +4281,20 @@ EXPORT_SYMBOL_GPL(work_on_cpu);
  */
 void freeze_workqueues_begin(void)
 {
-	struct worker_pool *pool;
 	struct workqueue_struct *wq;
 	struct pool_workqueue *pwq;
-	int pi;
 
 	mutex_lock(&wqs_mutex);
 
 	/* set FREEZING */
-	mutex_lock(&pools_mutex);
 	WARN_ON_ONCE(workqueue_freezing);
 	workqueue_freezing = true;
 
-	for_each_pool(pool, pi) {
-		spin_lock_irq(&pool->lock);
-		WARN_ON_ONCE(pool->flags & POOL_FREEZING);
-		pool->flags |= POOL_FREEZING;
-		spin_unlock_irq(&pool->lock);
-	}
-	mutex_unlock(&pools_mutex);
-
 	list_for_each_entry(wq, &workqueues, list) {
 		mutex_lock(&wq->mutex);
+		/* set FREEZING */
+		WARN_ON_ONCE(wq->freezing);
+		wq->freezing = true;
 		for_each_pwq(pwq, wq)
 			pwq_adjust_max_active(pwq);
 		mutex_unlock(&wq->mutex);
@@ -4374,28 +4362,21 @@ void thaw_workqueues(void)
 {
 	struct workqueue_struct *wq;
 	struct pool_workqueue *pwq;
-	struct worker_pool *pool;
-	int pi;
 
 	mutex_lock(&wqs_mutex);
 
 	if (!workqueue_freezing)
 		goto out_unlock;
 
-	/* clear FREEZING */
-	mutex_lock(&pools_mutex);
 	workqueue_freezing = false;
-	for_each_pool(pool, pi) {
-		spin_lock_irq(&pool->lock);
-		WARN_ON_ONCE(!(pool->flags & POOL_FREEZING));
-		pool->flags &= ~POOL_FREEZING;
-		spin_unlock_irq(&pool->lock);
-	}
-	mutex_unlock(&pools_mutex);
 
-	/* restore max_active and repopulate worklist */
 	list_for_each_entry(wq, &workqueues, list) {
 		mutex_lock(&wq->mutex);
+		/* clear FREEZING */
+		WARN_ON_ONCE(!wq->freezing);
+		wq->freezing = false;
+
+		/* restore max_active and repopulate worklist */
 		for_each_pwq(pwq, wq)
 			pwq_adjust_max_active(pwq);
 		mutex_unlock(&wq->mutex);
-- 
1.7.7.6

