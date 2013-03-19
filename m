Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933738Ab3CSTcO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 15:32:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:7894 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933490Ab3CST2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 15:28:55 -0400
X-IronPort-AV: E=Sophos;i="4.84,874,1355068800"; 
   d="scan'208";a="6904506"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 11/21] workqueue: also allowed wq->mutex protect for_each_pwq()
Date: Wed, 20 Mar 2013 03:28:11 +0800
Message-Id: <1363721306-2030-12-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
References: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/20 03:27:29,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/20 03:27:29,
	Serialize complete at 2013/03/20 03:27:29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) pwqs of a wq are modified with wq->mutex held, so we can use wq->mutex
   for read access like for_each_pwq().
2) pwqs of a wq are instance's attribute, reviewers expects wq->mutex
   protected it.
3) This patch is the most important step remove pwq_lock. only wq->mutex
   is enough, don't need two locks.
4) after it, flush_workqueue_prep_pwqs() and drain_workqueue() don't
   disable irq so such long time, disabling irq for long time adds latency
   to hardirq and hurts RT peoples.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   34 ++++++++++++++--------------------
 1 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 469269e..41e7737 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -301,8 +301,9 @@ static void copy_workqueue_attrs(struct workqueue_attrs *to,
 			   lockdep_is_held(&pools_mutex),		\
 			   "sched RCU or pools_mutex should be held")
 
-#define assert_rcu_or_pwq_lock()					\
+#define assert_rcu_or_pwq_lock(wq)					\
 	rcu_lockdep_assert(rcu_read_lock_sched_held() ||		\
+			   lockdep_is_held(&wq->mutex) ||		\
 			   lockdep_is_held(&pwq_lock),			\
 			   "sched RCU or pwq_lock should be held")
 
@@ -367,7 +368,7 @@ static void copy_workqueue_attrs(struct workqueue_attrs *to,
  */
 #define for_each_pwq(pwq, wq)						\
 	list_for_each_entry_rcu((pwq), &(wq)->pwqs, pwqs_node)		\
-		if (({ assert_rcu_or_pwq_lock(); false; })) { }		\
+		if (({ assert_rcu_or_pwq_lock(wq); false; })) { }		\
 		else
 
 #ifdef CONFIG_DEBUG_OBJECTS_WORK
@@ -512,7 +513,7 @@ static int worker_pool_assign_id(struct worker_pool *pool)
  */
 static struct pool_workqueue *first_pwq(struct workqueue_struct *wq)
 {
-	assert_rcu_or_pwq_lock();
+	assert_rcu_or_pwq_lock(wq);
 	return list_first_or_null_rcu(&wq->pwqs, struct pool_workqueue,
 				      pwqs_node);
 }
@@ -2479,12 +2480,10 @@ static bool flush_workqueue_prep_pwqs(struct workqueue_struct *wq,
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
@@ -2501,11 +2500,9 @@ static bool flush_workqueue_prep_pwqs(struct workqueue_struct *wq,
 			pwq->work_color = work_color;
 		}
 
-		spin_unlock(&pool->lock);
+		spin_unlock_irq(&pool->lock);
 	}
 
-	local_irq_enable();
-
 	if (flush_color >= 0 && atomic_dec_and_test(&wq->nr_pwqs_to_flush))
 		complete(&wq->first_flusher->done);
 
@@ -2693,14 +2690,14 @@ void drain_workqueue(struct workqueue_struct *wq)
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
@@ -2710,13 +2707,10 @@ reflush:
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
@@ -3846,13 +3840,13 @@ void destroy_workqueue(struct workqueue_struct *wq)
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
@@ -3860,11 +3854,11 @@ void destroy_workqueue(struct workqueue_struct *wq)
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
1.7.7.6

