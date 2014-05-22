Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbaEVK5P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 06:57:15 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:3087 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752731AbaEVK5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 06:57:13 -0400
X-IronPort-AV: E=Sophos;i="4.98,886,1392134400"; 
   d="scan'208";a="30870289"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH] workqueue: remove the confusing POOL_FREEZING
Date: Thu, 22 May 2014 19:01:16 +0800
Message-ID: <1400756486-12089-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While freezing takes place globally, its execution is per-workqueue;
however, the current implementation makes use of the per-worker_pool
POOL_FREEZING flag.  While it's not broken, the flag makes the code
more confusing and complicates freeze_workqueues_begin() and
thaw_workqueues() by requiring them to walk through all pools.

So we remove the POOL_FREEZING and use workqueue_freezing instead.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   32 +++++++-------------------------
 1 files changed, 7 insertions(+), 25 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 98b38b5..a87de61 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -69,7 +69,6 @@ enum {
 	 * worker_attach_to_pool() is in progress.
 	 */
 	POOL_DISASSOCIATED	= 1 << 2,	/* cpu can't serve workers */
-	POOL_FREEZING		= 1 << 3,	/* freeze in progress */
 
 	/* worker flags */
 	WORKER_DIE		= 1 << 1,	/* die die die */
@@ -3532,9 +3531,6 @@ static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
 	if (!pool || init_worker_pool(pool) < 0)
 		goto fail;
 
-	if (workqueue_freezing)
-		pool->flags |= POOL_FREEZING;
-
 	lockdep_set_subclass(&pool->lock, 1);	/* see put_pwq() */
 	copy_workqueue_attrs(pool->attrs, attrs);
 
@@ -3641,7 +3637,12 @@ static void pwq_adjust_max_active(struct pool_workqueue *pwq)
 
 	spin_lock_irq(&pwq->pool->lock);
 
-	if (!freezable || !(pwq->pool->flags & POOL_FREEZING)) {
+	/*
+	 * pwq_adjust_max_active() is invoked at least once
+	 * after workqueue_freezing is changed, so it can fetch
+	 * the workqueue_freezing without wq_pool_mutex held.
+	 */
+	if (!freezable || !workqueue_freezing) {
 		pwq->max_active = wq->saved_max_active;
 
 		while (!list_empty(&pwq->delayed_works) &&
@@ -4750,24 +4751,14 @@ EXPORT_SYMBOL_GPL(work_on_cpu);
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
 		for_each_pwq(pwq, wq)
@@ -4837,21 +4828,13 @@ void thaw_workqueues(void)
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
+	workqueue_freezing = false;
 
 	/* restore max_active and repopulate worklist */
 	list_for_each_entry(wq, &workqueues, list) {
@@ -4861,7 +4844,6 @@ void thaw_workqueues(void)
 		mutex_unlock(&wq->mutex);
 	}
 
-	workqueue_freezing = false;
 out_unlock:
 	mutex_unlock(&wq_pool_mutex);
 }
-- 
1.7.4.4

