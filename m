Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933865Ab3CZAHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 20:07:48 -0400
Received: from mail-vb0-f44.google.com ([209.85.212.44]:50362 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228Ab3CZAHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 20:07:45 -0400
From: Tejun Heo <tj@kernel.org>
To: laijs@cn.fujitsu.com
Cc: linux-kernel@vger.kernel.org, js1304@gmail.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/6] workqueue: rename wq->flush_mutex to wq->mutex
Date: Mon, 25 Mar 2013 17:07:25 -0700
Message-Id: <1364256449-11401-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1364256449-11401-1-git-send-email-tj@kernel.org>
References: <1364256449-11401-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

Currently pwq->flush_mutex protects many fields of a workqueue
including, especially, the pwqs list.  We're going to expand this
mutex to protect most of a workqueue and eventually replace pwq_lock,
which will make locking simpler and easier to understand.

Drop the "flush_" prefix in preparation.

This patch is pure rename.

tj: Rebased on top of the current dev branch.  Updated description.
    Use WQ: and WR: instead of Q: and QR: for synchronization labels.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 52 ++++++++++++++++++++++++++--------------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 064157e..d448eda 100644
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
@@ -129,8 +127,10 @@ enum {
  *
  * PW: pwq_lock protected.
  *
- * FR: wq->flush_mutex and pwq_lock protected for writes.  Sched-RCU
- *     protected for reads.
+ * WQ: wq->mutex protected.
+ *
+ * WR: wq->mutex and pwq_lock protected for writes.  Sched-RCU protected
+ *     for reads.
  *
  * MD: wq_mayday_lock protected.
  */
@@ -197,7 +197,7 @@ struct pool_workqueue {
 	int			nr_active;	/* L: nr of active works */
 	int			max_active;	/* L: max active works */
 	struct list_head	delayed_works;	/* L: delayed works */
-	struct list_head	pwqs_node;	/* FR: node on wq->pwqs */
+	struct list_head	pwqs_node;	/* WR: node on wq->pwqs */
 	struct list_head	mayday_node;	/* MD: node on wq->maydays */
 
 	/*
@@ -214,8 +214,8 @@ struct pool_workqueue {
  * Structure used to wait for workqueue flush.
  */
 struct wq_flusher {
-	struct list_head	list;		/* F: list of flushers */
-	int			flush_color;	/* F: flush color waiting for */
+	struct list_head	list;		/* WQ: list of flushers */
+	int			flush_color;	/* WQ: flush color waiting for */
 	struct completion	done;		/* flush completion */
 };
 
@@ -228,16 +228,16 @@ struct wq_device;
 struct workqueue_struct {
 	unsigned int		flags;		/* PL: WQ_* flags */
 	struct pool_workqueue __percpu *cpu_pwqs; /* I: per-cpu pwq's */
-	struct list_head	pwqs;		/* FR: all pwqs of this wq */
+	struct list_head	pwqs;		/* WR: all pwqs of this wq */
 	struct list_head	list;		/* PL: list of all workqueues */
 
-	struct mutex		flush_mutex;	/* protects wq flushing */
-	int			work_color;	/* F: current work color */
-	int			flush_color;	/* F: current flush color */
+	struct mutex		mutex;		/* protects this wq */
+	int			work_color;	/* WQ: current work color */
+	int			flush_color;	/* WQ: current flush color */
 	atomic_t		nr_pwqs_to_flush; /* flush in progress */
-	struct wq_flusher	*first_flusher;	/* F: first flusher */
-	struct list_head	flusher_queue;	/* F: flush waiters */
-	struct list_head	flusher_overflow; /* F: flush overflow list */
+	struct wq_flusher	*first_flusher;	/* WQ: first flusher */
+	struct list_head	flusher_queue;	/* WQ: flush waiters */
+	struct list_head	flusher_overflow; /* WQ: flush overflow list */
 
 	struct list_head	maydays;	/* MD: pwqs requesting rescue */
 	struct worker		*rescuer;	/* I: rescue worker */
@@ -2460,7 +2460,7 @@ static void insert_wq_barrier(struct pool_workqueue *pwq,
  * advanced to @work_color.
  *
  * CONTEXT:
- * mutex_lock(wq->flush_mutex).
+ * mutex_lock(wq->mutex).
  *
  * RETURNS:
  * %true if @flush_color >= 0 and there's something to flush.  %false
@@ -2529,7 +2529,7 @@ void flush_workqueue(struct workqueue_struct *wq)
 	lock_map_acquire(&wq->lockdep_map);
 	lock_map_release(&wq->lockdep_map);
 
-	mutex_lock(&wq->flush_mutex);
+	mutex_lock(&wq->mutex);
 
 	/*
 	 * Start-to-wait phase
@@ -2574,7 +2574,7 @@ void flush_workqueue(struct workqueue_struct *wq)
 		list_add_tail(&this_flusher.list, &wq->flusher_overflow);
 	}
 
-	mutex_unlock(&wq->flush_mutex);
+	mutex_unlock(&wq->mutex);
 
 	wait_for_completion(&this_flusher.done);
 
@@ -2587,7 +2587,7 @@ void flush_workqueue(struct workqueue_struct *wq)
 	if (wq->first_flusher != &this_flusher)
 		return;
 
-	mutex_lock(&wq->flush_mutex);
+	mutex_lock(&wq->mutex);
 
 	/* we might have raced, check again with mutex held */
 	if (wq->first_flusher != &this_flusher)
@@ -2659,7 +2659,7 @@ void flush_workqueue(struct workqueue_struct *wq)
 	}
 
 out_unlock:
-	mutex_unlock(&wq->flush_mutex);
+	mutex_unlock(&wq->mutex);
 }
 EXPORT_SYMBOL_GPL(flush_workqueue);
 
@@ -3550,15 +3550,15 @@ static void pwq_unbound_release_workfn(struct work_struct *work)
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
@@ -3627,12 +3627,12 @@ static void init_and_link_pwq(struct pool_workqueue *pwq,
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
@@ -3645,7 +3645,7 @@ static void init_and_link_pwq(struct pool_workqueue *pwq,
 	list_add_rcu(&pwq->pwqs_node, &wq->pwqs);
 
 	spin_unlock_irq(&pwq_lock);
-	mutex_unlock(&wq->flush_mutex);
+	mutex_unlock(&wq->mutex);
 }
 
 /**
@@ -3762,7 +3762,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	/* init wq */
 	wq->flags = flags;
 	wq->saved_max_active = max_active;
-	mutex_init(&wq->flush_mutex);
+	mutex_init(&wq->mutex);
 	atomic_set(&wq->nr_pwqs_to_flush, 0);
 	INIT_LIST_HEAD(&wq->pwqs);
 	INIT_LIST_HEAD(&wq->flusher_queue);
-- 
1.8.1.4

