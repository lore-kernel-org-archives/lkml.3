Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107Ab3C3RLu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 13:11:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:32289 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756888Ab3C3RLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 13:11:42 -0400
X-IronPort-AV: E=Sophos;i="4.87,379,1363104000"; 
   d="scan'208";a="6974907"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 1/2 tj/for-3.10] workqueue: add wq->freezing and remove POOL_FREEZING
Date: Sun, 31 Mar 2013 00:29:14 +0800
Message-Id: <1364660955-5217-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/31 00:28:42,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/31 00:28:44,
	Serialize complete at 2013/03/31 00:28:44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

freezing is nothing related to pools, but POOL_FREEZING adds a connection,
and causes freeze_workqueues_begin() and thaw_workqueues() complicated.

Since freezing is workqueue instance attribute, so we introduce wq->freezing
instead and remove POOL_FREEZING.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   33 +++++++--------------------------
 1 files changed, 7 insertions(+), 26 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 04a8b98..6b7e5a4 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -66,7 +66,6 @@ enum {
 	 */
 	POOL_MANAGE_WORKERS	= 1 << 0,	/* need to manage workers */
 	POOL_DISASSOCIATED	= 1 << 2,	/* cpu can't serve workers */
-	POOL_FREEZING		= 1 << 3,	/* freeze in progress */
 
 	/* worker flags */
 	WORKER_STARTED		= 1 << 0,	/* started */
@@ -241,6 +240,7 @@ struct workqueue_struct {
 
 	int			nr_drainers;	/* WQ: drain in progress */
 	int			saved_max_active; /* WQ: saved pwq max_active */
+	bool			freezing;	/* WQ: the wq is freezing */
 
 #ifdef CONFIG_SYSFS
 	struct wq_device	*wq_dev;	/* I: for sysfs interface */
@@ -3493,9 +3493,6 @@ static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
 	if (!pool || init_worker_pool(pool) < 0)
 		goto fail;
 
-	if (workqueue_freezing)
-		pool->flags |= POOL_FREEZING;
-
 	lockdep_set_subclass(&pool->lock, 1);	/* see put_pwq() */
 	copy_workqueue_attrs(pool->attrs, attrs);
 
@@ -3571,7 +3568,7 @@ static void pwq_adjust_max_active(struct pool_workqueue *pwq)
 	struct workqueue_struct *wq = pwq->wq;
 	bool freezable = wq->flags & WQ_FREEZABLE;
 
-	/* for @wq->saved_max_active */
+	/* for @wq->saved_max_active and @wq->freezing */
 	lockdep_assert_held(&wq->mutex);
 
 	/* fast exit for non-freezable wqs */
@@ -3580,7 +3577,7 @@ static void pwq_adjust_max_active(struct pool_workqueue *pwq)
 
 	spin_lock_irq(&pwq->pool->lock);
 
-	if (!freezable || !(pwq->pool->flags & POOL_FREEZING)) {
+	if (!freezable || !wq->freezing) {
 		pwq->max_active = wq->saved_max_active;
 
 		while (!list_empty(&pwq->delayed_works) &&
@@ -3795,6 +3792,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	mutex_lock(&wq_pool_mutex);
 
 	mutex_lock(&wq->mutex);
+	wq->freezing = workqueue_freezing;
 	for_each_pwq(pwq, wq)
 		pwq_adjust_max_active(pwq);
 	mutex_unlock(&wq->mutex);
@@ -4282,26 +4280,18 @@ EXPORT_SYMBOL_GPL(work_on_cpu);
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
+		WARN_ON_ONCE(wq->freezing);
+		wq->freezing = true;
 		for_each_pwq(pwq, wq)
 			pwq_adjust_max_active(pwq);
 		mutex_unlock(&wq->mutex);
@@ -4369,25 +4359,16 @@ void thaw_workqueues(void)
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
+		wq->freezing = false;
 		for_each_pwq(pwq, wq)
 			pwq_adjust_max_active(pwq);
 		mutex_unlock(&wq->mutex);
-- 
1.7.7.6

