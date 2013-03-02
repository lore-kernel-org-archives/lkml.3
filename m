Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385Ab3CBDYx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:24:53 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:54780 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab3CBDYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:24:33 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jmoyer@redhat.com, zab@redhat.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/31] workqueue: make workqueue_lock irq-safe
Date: Fri,  1 Mar 2013 19:23:53 -0800
Message-Id: <1362194662-2344-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362194662-2344-1-git-send-email-tj@kernel.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

workqueue_lock will be used to synchronize areas which require
irq-safety and there isn't much benefit in keeping it not irq-safe.
Make it irq-safe.

This patch doesn't introduce any visible behavior changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index a533e77..61f78ef 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2717,10 +2717,10 @@ void drain_workqueue(struct workqueue_struct *wq)
 	 * hotter than drain_workqueue() and already looks at @wq->flags.
 	 * Use WQ_DRAINING so that queue doesn't have to check nr_drainers.
 	 */
-	spin_lock(&workqueue_lock);
+	spin_lock_irq(&workqueue_lock);
 	if (!wq->nr_drainers++)
 		wq->flags |= WQ_DRAINING;
-	spin_unlock(&workqueue_lock);
+	spin_unlock_irq(&workqueue_lock);
 reflush:
 	flush_workqueue(wq);
 
@@ -2742,10 +2742,10 @@ reflush:
 		goto reflush;
 	}
 
-	spin_lock(&workqueue_lock);
+	spin_lock_irq(&workqueue_lock);
 	if (!--wq->nr_drainers)
 		wq->flags &= ~WQ_DRAINING;
-	spin_unlock(&workqueue_lock);
+	spin_unlock_irq(&workqueue_lock);
 }
 EXPORT_SYMBOL_GPL(drain_workqueue);
 
@@ -3235,7 +3235,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	 * list.  Grab it, set max_active accordingly and add the new
 	 * workqueue to workqueues list.
 	 */
-	spin_lock(&workqueue_lock);
+	spin_lock_irq(&workqueue_lock);
 
 	if (workqueue_freezing && wq->flags & WQ_FREEZABLE)
 		for_each_pwq_cpu(cpu, wq)
@@ -3243,7 +3243,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 
 	list_add(&wq->list, &workqueues);
 
-	spin_unlock(&workqueue_lock);
+	spin_unlock_irq(&workqueue_lock);
 
 	return wq;
 err:
@@ -3287,9 +3287,9 @@ void destroy_workqueue(struct workqueue_struct *wq)
 	 * wq list is used to freeze wq, remove from list after
 	 * flushing is complete in case freeze races us.
 	 */
-	spin_lock(&workqueue_lock);
+	spin_lock_irq(&workqueue_lock);
 	list_del(&wq->list);
-	spin_unlock(&workqueue_lock);
+	spin_unlock_irq(&workqueue_lock);
 
 	if (wq->flags & WQ_RESCUER) {
 		kthread_stop(wq->rescuer->task);
@@ -3338,7 +3338,7 @@ void workqueue_set_max_active(struct workqueue_struct *wq, int max_active)
 
 	max_active = wq_clamp_max_active(max_active, wq->flags, wq->name);
 
-	spin_lock(&workqueue_lock);
+	spin_lock_irq(&workqueue_lock);
 
 	wq->saved_max_active = max_active;
 
@@ -3346,16 +3346,16 @@ void workqueue_set_max_active(struct workqueue_struct *wq, int max_active)
 		struct pool_workqueue *pwq = get_pwq(cpu, wq);
 		struct worker_pool *pool = pwq->pool;
 
-		spin_lock_irq(&pool->lock);
+		spin_lock(&pool->lock);
 
 		if (!(wq->flags & WQ_FREEZABLE) ||
 		    !(pool->flags & POOL_FREEZING))
 			pwq_set_max_active(pwq, max_active);
 
-		spin_unlock_irq(&pool->lock);
+		spin_unlock(&pool->lock);
 	}
 
-	spin_unlock(&workqueue_lock);
+	spin_unlock_irq(&workqueue_lock);
 }
 EXPORT_SYMBOL_GPL(workqueue_set_max_active);
 
@@ -3602,7 +3602,7 @@ void freeze_workqueues_begin(void)
 {
 	unsigned int cpu;
 
-	spin_lock(&workqueue_lock);
+	spin_lock_irq(&workqueue_lock);
 
 	WARN_ON_ONCE(workqueue_freezing);
 	workqueue_freezing = true;
@@ -3612,7 +3612,7 @@ void freeze_workqueues_begin(void)
 		struct workqueue_struct *wq;
 
 		for_each_std_worker_pool(pool, cpu) {
-			spin_lock_irq(&pool->lock);
+			spin_lock(&pool->lock);
 
 			WARN_ON_ONCE(pool->flags & POOL_FREEZING);
 			pool->flags |= POOL_FREEZING;
@@ -3625,11 +3625,11 @@ void freeze_workqueues_begin(void)
 					pwq->max_active = 0;
 			}
 
-			spin_unlock_irq(&pool->lock);
+			spin_unlock(&pool->lock);
 		}
 	}
 
-	spin_unlock(&workqueue_lock);
+	spin_unlock_irq(&workqueue_lock);
 }
 
 /**
@@ -3650,7 +3650,7 @@ bool freeze_workqueues_busy(void)
 	unsigned int cpu;
 	bool busy = false;
 
-	spin_lock(&workqueue_lock);
+	spin_lock_irq(&workqueue_lock);
 
 	WARN_ON_ONCE(!workqueue_freezing);
 
@@ -3674,7 +3674,7 @@ bool freeze_workqueues_busy(void)
 		}
 	}
 out_unlock:
-	spin_unlock(&workqueue_lock);
+	spin_unlock_irq(&workqueue_lock);
 	return busy;
 }
 
@@ -3691,7 +3691,7 @@ void thaw_workqueues(void)
 {
 	unsigned int cpu;
 
-	spin_lock(&workqueue_lock);
+	spin_lock_irq(&workqueue_lock);
 
 	if (!workqueue_freezing)
 		goto out_unlock;
@@ -3701,7 +3701,7 @@ void thaw_workqueues(void)
 		struct workqueue_struct *wq;
 
 		for_each_std_worker_pool(pool, cpu) {
-			spin_lock_irq(&pool->lock);
+			spin_lock(&pool->lock);
 
 			WARN_ON_ONCE(!(pool->flags & POOL_FREEZING));
 			pool->flags &= ~POOL_FREEZING;
@@ -3719,13 +3719,13 @@ void thaw_workqueues(void)
 
 			wake_up_worker(pool);
 
-			spin_unlock_irq(&pool->lock);
+			spin_unlock(&pool->lock);
 		}
 	}
 
 	workqueue_freezing = false;
 out_unlock:
-	spin_unlock(&workqueue_lock);
+	spin_unlock_irq(&workqueue_lock);
 }
 #endif /* CONFIG_FREEZER */
 
-- 
1.8.1.2

