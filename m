Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933611Ab3CST2z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 15:28:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:22685 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933323Ab3CST2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 15:28:51 -0400
X-IronPort-AV: E=Sophos;i="4.84,874,1355068800"; 
   d="scan'208";a="6904503"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 08/21] workqueue: rename wq->flush_mutex to wq->mutex
Date: Wed, 20 Mar 2013 03:28:08 +0800
Message-Id: <1363721306-2030-9-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
References: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/20 03:27:24,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/20 03:27:24,
	Serialize complete at 2013/03/20 03:27:24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently wq->flush_mutex protects most workqueue instance's fields,
especially include all pwqs of this wq, it makes it like a mutex of
a workqueue instance.

So we rename wq->flush_mutex to wq->mutex to make it acts as instance's mutex.

We plan to covert wq->nr_drainers and wq->saved_max_active to be protected by it.
We plan to covert all pwqs of this wq to be protected _only_ by it or RCU.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   50 +++++++++++++++++++++++++-------------------------
 1 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 5252107..4ae6ba7 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -118,8 +118,6 @@ enum {
  *    cpu or grabbing pool->lock is enough for read access.  If
  *    POOL_DISASSOCIATED is set, it's identical to L.
  *
- * F: wq->flush_mutex protected.
- *
  * MG: pool->manager_mutex and pool->lock protected.  Writes require both
  *     locks.  Reads can happen under either lock.
  *
@@ -131,7 +129,9 @@ enum {
  *
  * PW: pwq_lock protected.
  *
- * FR: wq->flush_mutex and pwq_lock protected for writes.  Sched-RCU
+ * Q: wq->mutex protected.
+ *
+ * QR: wq->mutex and pwq_lock protected for writes.  Sched-RCU
  *     protected for reads.
  *
  * MD: wq_mayday_lock protected.
@@ -199,7 +199,7 @@ struct pool_workqueue {
 	int			nr_active;	/* L: nr of active works */
 	int			max_active;	/* L: max active works */
 	struct list_head	delayed_works;	/* L: delayed works */
-	struct list_head	pwqs_node;	/* FR: node on wq->pwqs */
+	struct list_head	pwqs_node;	/* QR: node on wq->pwqs */
 	struct list_head	mayday_node;	/* MD: node on wq->maydays */
 
 	/*
@@ -216,8 +216,8 @@ struct pool_workqueue {
  * Structure used to wait for workqueue flush.
  */
 struct wq_flusher {
-	struct list_head	list;		/* F: list of flushers */
-	int			flush_color;	/* F: flush color waiting for */
+	struct list_head	list;		/* Q: list of flushers */
+	int			flush_color;	/* Q: flush color waiting for */
 	struct completion	done;		/* flush completion */
 };
 
@@ -230,16 +230,16 @@ struct wq_device;
 struct workqueue_struct {
 	unsigned int		flags;		/* QS: WQ_* flags */
 	struct pool_workqueue __percpu *cpu_pwqs; /* I: per-cpu pwq's */
-	struct list_head	pwqs;		/* FR: all pwqs of this wq */
+	struct list_head	pwqs;		/* QR: all pwqs of this wq */
 	struct list_head	list;		/* QS: list of all workqueues */
 
-	struct mutex		flush_mutex;	/* protects wq flushing */
-	int			work_color;	/* F: current work color */
-	int			flush_color;	/* F: current flush color */
+	struct mutex		mutex;		/* protects wq */
+	int			work_color;	/* Q: current work color */
+	int			flush_color;	/* Q: current flush color */
 	atomic_t		nr_pwqs_to_flush; /* flush in progress */
-	struct wq_flusher	*first_flusher;	/* F: first flusher */
-	struct list_head	flusher_queue;	/* F: flush waiters */
-	struct list_head	flusher_overflow; /* F: flush overflow list */
+	struct wq_flusher	*first_flusher;	/* Q: first flusher */
+	struct list_head	flusher_queue;	/* Q: flush waiters */
+	struct list_head	flusher_overflow; /* Q: flush overflow list */
 
 	struct list_head	maydays;	/* MD: pwqs requesting rescue */
 	struct worker		*rescuer;	/* I: rescue worker */
@@ -2462,7 +2462,7 @@ static void insert_wq_barrier(struct pool_workqueue *pwq,
  * advanced to @work_color.
  *
  * CONTEXT:
- * mutex_lock(wq->flush_mutex).
+ * mutex_lock(wq->mutex).
  *
  * RETURNS:
  * %true if @flush_color >= 0 and there's something to flush.  %false
@@ -2531,7 +2531,7 @@ void flush_workqueue(struct workqueue_struct *wq)
 	lock_map_acquire(&wq->lockdep_map);
 	lock_map_release(&wq->lockdep_map);
 
-	mutex_lock(&wq->flush_mutex);
+	mutex_lock(&wq->mutex);
 
 	/*
 	 * Start-to-wait phase
@@ -2576,7 +2576,7 @@ void flush_workqueue(struct workqueue_struct *wq)
 		list_add_tail(&this_flusher.list, &wq->flusher_overflow);
 	}
 
-	mutex_unlock(&wq->flush_mutex);
+	mutex_unlock(&wq->mutex);
 
 	wait_for_completion(&this_flusher.done);
 
@@ -2589,7 +2589,7 @@ void flush_workqueue(struct workqueue_struct *wq)
 	if (wq->first_flusher != &this_flusher)
 		return;
 
-	mutex_lock(&wq->flush_mutex);
+	mutex_lock(&wq->mutex);
 
 	/* we might have raced, check again with mutex held */
 	if (wq->first_flusher != &this_flusher)
@@ -2661,7 +2661,7 @@ void flush_workqueue(struct workqueue_struct *wq)
 	}
 
 out_unlock:
-	mutex_unlock(&wq->flush_mutex);
+	mutex_unlock(&wq->mutex);
 }
 EXPORT_SYMBOL_GPL(flush_workqueue);
 
@@ -3552,15 +3552,15 @@ static void pwq_unbound_release_workfn(struct work_struct *work)
 		return;
 
 	/*
-	 * Unlink @pwq.  Synchronization against flush_mutex isn't strictly
+	 * Unlink @pwq.  Synchronization against wq->mutex isn't strictly
 	 * necessary on release but do it anyway.  It's easier to verify
 	 * and consistent with the linking path.
 	 */
-	mutex_lock(&wq->flush_mutex);
+	mutex_lock(&wq->mutex);
 	spin_lock_irq(&pwq_lock);
 	list_del_rcu(&pwq->pwqs_node);
 	spin_unlock_irq(&pwq_lock);
-	mutex_unlock(&wq->flush_mutex);
+	mutex_unlock(&wq->mutex);
 
 	put_unbound_pool(pool);
 	call_rcu_sched(&pwq->rcu, rcu_free_pwq);
@@ -3631,12 +3631,12 @@ static void init_and_link_pwq(struct pool_workqueue *pwq,
 	INIT_LIST_HEAD(&pwq->mayday_node);
 	INIT_WORK(&pwq->unbound_release_work, pwq_unbound_release_workfn);
 
-	mutex_lock(&wq->flush_mutex);
+	mutex_lock(&wq->mutex);
 	spin_lock_irq(&pwq_lock);
 
 	/*
 	 * Set the matching work_color.  This is synchronized with
-	 * flush_mutex to avoid confusing flush_workqueue().
+	 * wq->mutex to avoid confusing flush_workqueue().
 	 */
 	if (p_last_pwq)
 		*p_last_pwq = first_pwq(wq);
@@ -3649,7 +3649,7 @@ static void init_and_link_pwq(struct pool_workqueue *pwq,
 	list_add_rcu(&pwq->pwqs_node, &wq->pwqs);
 
 	spin_unlock_irq(&pwq_lock);
-	mutex_unlock(&wq->flush_mutex);
+	mutex_unlock(&wq->mutex);
 }
 
 /**
@@ -3766,7 +3766,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	/* init wq */
 	wq->flags = flags;
 	wq->saved_max_active = max_active;
-	mutex_init(&wq->flush_mutex);
+	mutex_init(&wq->mutex);
 	atomic_set(&wq->nr_pwqs_to_flush, 0);
 	INIT_LIST_HEAD(&wq->pwqs);
 	INIT_LIST_HEAD(&wq->flusher_queue);
-- 
1.7.7.6

