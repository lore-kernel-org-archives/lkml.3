Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbaCYJxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 05:53:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:32322 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751067AbaCYJxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 05:53:37 -0400
X-IronPort-AV: E=Sophos;i="4.97,727,1389715200"; 
   d="scan'208";a="9763953"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] workqueue: add __WQ_FREEZING and remove POOL_FREEZING
Date: Tue, 25 Mar 2014 17:56:04 +0800
Message-Id: <1395741364-19489-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <20130421012925.GA19097@mtj.dyndns.org>
References: <20130421012925.GA19097@mtj.dyndns.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/25 17:49:40,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/25 17:49:41,
	Serialize complete at 2014/03/25 17:49:41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

freezing is nothing related to pools, but POOL_FREEZING adds a connection,
and causes freeze_workqueues_begin() and thaw_workqueues() complicated.

Since freezing is workqueue instance attribute, so we introduce __WQ_FREEZING
to wq->flags instead and remove POOL_FREEZING.

we set __WQ_FREEZING only when freezable(to simplify pwq_adjust_max_active()),
make freeze_workqueues_begin() and thaw_workqueues() fast skip non-freezable wq.

Changed from previous patches(requested by tj):
	1) added the WARN_ON_ONCE() back
	2) merged the two patches as one

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/workqueue.h |    1 +
 kernel/workqueue.c        |   43 ++++++++++++-------------------------------
 2 files changed, 13 insertions(+), 31 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 704f4f6..a45202b 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -335,6 +335,7 @@ enum {
 	 */
 	WQ_POWER_EFFICIENT	= 1 << 7,
 
+	__WQ_FREEZING		= 1 << 15, /* internel: workqueue is freezing */
 	__WQ_DRAINING		= 1 << 16, /* internal: workqueue is draining */
 	__WQ_ORDERED		= 1 << 17, /* internal: workqueue is ordered */
 
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 193e977..0c74979 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -70,7 +70,6 @@ enum {
 	 */
 	POOL_MANAGE_WORKERS	= 1 << 0,	/* need to manage workers */
 	POOL_DISASSOCIATED	= 1 << 2,	/* cpu can't serve workers */
-	POOL_FREEZING		= 1 << 3,	/* freeze in progress */
 
 	/* worker flags */
 	WORKER_STARTED		= 1 << 0,	/* started */
@@ -3632,9 +3631,6 @@ static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
 	if (!pool || init_worker_pool(pool) < 0)
 		goto fail;
 
-	if (workqueue_freezing)
-		pool->flags |= POOL_FREEZING;
-
 	lockdep_set_subclass(&pool->lock, 1);	/* see put_pwq() */
 	copy_workqueue_attrs(pool->attrs, attrs);
 
@@ -3730,18 +3726,13 @@ static void pwq_unbound_release_workfn(struct work_struct *work)
 static void pwq_adjust_max_active(struct pool_workqueue *pwq)
 {
 	struct workqueue_struct *wq = pwq->wq;
-	bool freezable = wq->flags & WQ_FREEZABLE;
 
-	/* for @wq->saved_max_active */
+	/* for @wq->saved_max_active and @wq->flags */
 	lockdep_assert_held(&wq->mutex);
 
-	/* fast exit for non-freezable wqs */
-	if (!freezable && pwq->max_active == wq->saved_max_active)
-		return;
-
 	spin_lock_irq(&pwq->pool->lock);
 
-	if (!freezable || !(pwq->pool->flags & POOL_FREEZING)) {
+	if (!(wq->flags & __WQ_FREEZING)) {
 		pwq->max_active = wq->saved_max_active;
 
 		while (!list_empty(&pwq->delayed_works) &&
@@ -4250,6 +4241,8 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	mutex_lock(&wq_pool_mutex);
 
 	mutex_lock(&wq->mutex);
+	if ((wq->flags & WQ_FREEZABLE) && workqueue_freezing)
+		wq->flags |= __WQ_FREEZING;
 	for_each_pwq(pwq, wq)
 		pwq_adjust_max_active(pwq);
 	mutex_unlock(&wq->mutex);
@@ -4856,26 +4849,20 @@ EXPORT_SYMBOL_GPL(work_on_cpu);
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
+		if (!(wq->flags & WQ_FREEZABLE))
+			continue;
 		mutex_lock(&wq->mutex);
+		WARN_ON_ONCE(wq->flags & __WQ_FREEZING);
+		wq->flags |= __WQ_FREEZING;
 		for_each_pwq(pwq, wq)
 			pwq_adjust_max_active(pwq);
 		mutex_unlock(&wq->mutex);
@@ -4943,25 +4930,19 @@ void thaw_workqueues(void)
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
+		if (!(wq->flags & WQ_FREEZABLE))
+			continue;
 		mutex_lock(&wq->mutex);
+		WARN_ON_ONCE(!(wq->flags & __WQ_FREEZING));
+		wq->flags &= ~__WQ_FREEZING;
 		for_each_pwq(pwq, wq)
 			pwq_adjust_max_active(pwq);
 		mutex_unlock(&wq->mutex);
-- 
1.7.4.4

