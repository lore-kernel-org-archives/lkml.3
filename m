Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314Ab3C1GpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 02:45:09 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:50819 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756280Ab3C1GpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 02:45:04 -0400
From: Tejun Heo <tj@kernel.org>
To: laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jack@suse.cz, fengguang.wu@intel.com, jmoyer@redhat.com,
        zab@redhat.com, linux-kernel@vger.kernel.org,
        herbert@gondor.hengli.com.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 12/14] workqueue: introduce put_pwq_unlocked()
Date: Wed, 27 Mar 2013 23:43:38 -0700
Message-Id: <1364453020-2829-13-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1364453020-2829-1-git-send-email-tj@kernel.org>
References: <1364453020-2829-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out lock pool, put_pwq(), unlock sequence into
put_pwq_unlocked().  The two existing places are converted and there
will be more with NUMA affinity support.

This is to prepare for NUMA affinity support for unbound workqueues
and doesn't introduce any functional difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 527dc418..e656931 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1057,6 +1057,25 @@ static void put_pwq(struct pool_workqueue *pwq)
 	schedule_work(&pwq->unbound_release_work);
 }
 
+/**
+ * put_pwq_unlocked - put_pwq() with surrounding pool lock/unlock
+ * @pwq: pool_workqueue to put (can be %NULL)
+ *
+ * put_pwq() with locking.  This function also allows %NULL @pwq.
+ */
+static void put_pwq_unlocked(struct pool_workqueue *pwq)
+{
+	if (pwq) {
+		/*
+		 * As both pwqs and pools are sched-RCU protected, the
+		 * following lock operations are safe.
+		 */
+		spin_lock_irq(&pwq->pool->lock);
+		put_pwq(pwq);
+		spin_unlock_irq(&pwq->pool->lock);
+	}
+}
+
 static void pwq_activate_delayed_work(struct work_struct *work)
 {
 	struct pool_workqueue *pwq = get_work_pwq(work);
@@ -3759,12 +3778,7 @@ int apply_workqueue_attrs(struct workqueue_struct *wq,
 
 	mutex_unlock(&wq->mutex);
 
-	if (last_pwq) {
-		spin_lock_irq(&last_pwq->pool->lock);
-		put_pwq(last_pwq);
-		spin_unlock_irq(&last_pwq->pool->lock);
-	}
-
+	put_pwq_unlocked(last_pwq);
 	return 0;
 
 enomem:
@@ -3975,16 +3989,12 @@ void destroy_workqueue(struct workqueue_struct *wq)
 	} else {
 		/*
 		 * We're the sole accessor of @wq at this point.  Directly
-		 * access the first pwq and put the base ref.  As both pwqs
-		 * and pools are sched-RCU protected, the lock operations
-		 * are safe.  @wq will be freed when the last pwq is
-		 * released.
+		 * access the first pwq and put the base ref.  @wq will be
+		 * freed when the last pwq is released.
 		 */
 		pwq = list_first_entry(&wq->pwqs, struct pool_workqueue,
 				       pwqs_node);
-		spin_lock_irq(&pwq->pool->lock);
-		put_pwq(pwq);
-		spin_unlock_irq(&pwq->pool->lock);
+		put_pwq_unlocked(pwq);
 	}
 }
 EXPORT_SYMBOL_GPL(destroy_workqueue);
-- 
1.8.1.4

