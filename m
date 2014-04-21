Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbaDUL42 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 07:56:28 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:60774 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751907AbaDUL4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 07:56:06 -0400
X-IronPort-AV: E=Sophos;i="4.97,896,1389715200"; 
   d="scan'208";a="29519609"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, <linux-kernel@vger.kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 1/2 V3] workqueue: substitute POOL_FREEZING with __WQ_FREEZING
Date: Mon, 21 Apr 2014 19:59:20 +0800
Message-ID: <1398081561-12618-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only workqueues have freezable or freezing attribution/state, not worker pools.
But POOL_FREEZING adds a suspicious state and makes reviewers confused.

And it causes freeze_workqueues_begin() and thaw_workqueues() much complicated,
they need to travel all the pools besides wqs.

Since freezable is workqueue instance's attribution, and freezing
is workqueue instance's state, so we introduce __WQ_FREEZING
to wq->flags instead and remove POOL_FREEZING.

It is different from POOL_FREEZING, POOL_FREEZING is simply set
all over the world(all pools), while __WQ_FREEZING is only set for freezable wq.
freeze_workqueues_begin()/thaw_workqueues() skip to handle non-freezable wqs
and don't touch the non-freezable wqs' flags.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/workqueue.h |    1 +
 kernel/workqueue.c        |   38 ++++++++++++--------------------------
 2 files changed, 13 insertions(+), 26 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 1b22c42..6bf353e 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -322,6 +322,7 @@ enum {
 
 	__WQ_DRAINING		= 1 << 16, /* internal: workqueue is draining */
 	__WQ_ORDERED		= 1 << 17, /* internal: workqueue is ordered */
+	__WQ_FREEZING		= 1 << 18, /* internel: workqueue is freezing */
 
 	WQ_MAX_ACTIVE		= 512,	  /* I like 512, better ideas? */
 	WQ_MAX_UNBOUND_PER_CPU	= 4,	  /* 4 * #cpus for unbound wq */
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index c3f076f..beca98b 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -70,7 +70,6 @@ enum {
 	 */
 	POOL_MANAGE_WORKERS	= 1 << 0,	/* need to manage workers */
 	POOL_DISASSOCIATED	= 1 << 2,	/* cpu can't serve workers */
-	POOL_FREEZING		= 1 << 3,	/* freeze in progress */
 
 	/* worker flags */
 	WORKER_STARTED		= 1 << 0,	/* started */
@@ -3662,9 +3661,6 @@ static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
 	if (!pool || init_worker_pool(pool) < 0)
 		goto fail;
 
-	if (workqueue_freezing)
-		pool->flags |= POOL_FREEZING;
-
 	lockdep_set_subclass(&pool->lock, 1);	/* see put_pwq() */
 	copy_workqueue_attrs(pool->attrs, attrs);
 
@@ -3762,7 +3758,7 @@ static void pwq_adjust_max_active(struct pool_workqueue *pwq)
 	struct workqueue_struct *wq = pwq->wq;
 	bool freezable = wq->flags & WQ_FREEZABLE;
 
-	/* for @wq->saved_max_active */
+	/* for @wq->saved_max_active and @wq->flags */
 	lockdep_assert_held(&wq->mutex);
 
 	/* fast exit for non-freezable wqs */
@@ -3771,7 +3767,7 @@ static void pwq_adjust_max_active(struct pool_workqueue *pwq)
 
 	spin_lock_irq(&pwq->pool->lock);
 
-	if (!freezable || !(pwq->pool->flags & POOL_FREEZING)) {
+	if (!freezable || !(wq->flags & __WQ_FREEZING)) {
 		pwq->max_active = wq->saved_max_active;
 
 		while (!list_empty(&pwq->delayed_works) &&
@@ -4277,6 +4273,8 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	mutex_lock(&wq_pool_mutex);
 
 	mutex_lock(&wq->mutex);
+	if ((wq->flags & WQ_FREEZABLE) && workqueue_freezing)
+		wq->flags |= __WQ_FREEZING;
 	for_each_pwq(pwq, wq)
 		pwq_adjust_max_active(pwq);
 	mutex_unlock(&wq->mutex);
@@ -4883,26 +4881,20 @@ EXPORT_SYMBOL_GPL(work_on_cpu);
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
@@ -4970,25 +4962,19 @@ void thaw_workqueues(void)
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

