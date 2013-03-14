Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964913Ab3CNC5t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 22:57:49 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:63121 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964869Ab3CNC5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 22:57:44 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: laijs@cn.fujitsu.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 7/7] workqueue: rename workqueue_lock to wq_mayday_lock
Date: Wed, 13 Mar 2013 19:57:25 -0700
Message-Id: <1363229845-6831-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1363229845-6831-1-git-send-email-tj@kernel.org>
References: <1363229845-6831-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the recent locking updates, the only thing protected by
workqueue_lock is workqueue->maydays list.  Rename workqueue_lock to
wq_mayday_lock.

This patch is pure rename.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 63856df..969be0b 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -125,10 +125,10 @@ enum {
  *
  * PW: pwq_lock protected.
  *
- * W: workqueue_lock protected.
- *
  * FR: wq->flush_mutex and pwq_lock protected for writes.  Sched-RCU
  *     protected for reads.
+ *
+ * MD: wq_mayday_lock protected.
  */
 
 /* struct worker is defined in workqueue_internal.h */
@@ -194,7 +194,7 @@ struct pool_workqueue {
 	int			max_active;	/* L: max active works */
 	struct list_head	delayed_works;	/* L: delayed works */
 	struct list_head	pwqs_node;	/* FR: node on wq->pwqs */
-	struct list_head	mayday_node;	/* W: node on wq->maydays */
+	struct list_head	mayday_node;	/* MD: node on wq->maydays */
 
 	/*
 	 * Release of unbound pwq is punted to system_wq.  See put_pwq()
@@ -235,7 +235,7 @@ struct workqueue_struct {
 	struct list_head	flusher_queue;	/* F: flush waiters */
 	struct list_head	flusher_overflow; /* F: flush overflow list */
 
-	struct list_head	maydays;	/* W: pwqs requesting rescue */
+	struct list_head	maydays;	/* MD: pwqs requesting rescue */
 	struct worker		*rescuer;	/* I: rescue worker */
 
 	int			nr_drainers;	/* WQ: drain in progress */
@@ -254,7 +254,7 @@ static struct kmem_cache *pwq_cache;
 
 static DEFINE_MUTEX(wq_mutex);		/* protects workqueues and pools */
 static DEFINE_SPINLOCK(pwq_lock);	/* protects pool_workqueues */
-static DEFINE_SPINLOCK(workqueue_lock);
+static DEFINE_SPINLOCK(wq_mayday_lock);	/* protects wq->maydays list */
 
 static LIST_HEAD(workqueues);		/* WQ: list of all workqueues */
 static bool workqueue_freezing;		/* WQ: have wqs started freezing? */
@@ -1894,7 +1894,7 @@ static void send_mayday(struct work_struct *work)
 	struct pool_workqueue *pwq = get_work_pwq(work);
 	struct workqueue_struct *wq = pwq->wq;
 
-	lockdep_assert_held(&workqueue_lock);
+	lockdep_assert_held(&wq_mayday_lock);
 
 	if (!wq->rescuer)
 		return;
@@ -1911,7 +1911,7 @@ static void pool_mayday_timeout(unsigned long __pool)
 	struct worker_pool *pool = (void *)__pool;
 	struct work_struct *work;
 
-	spin_lock_irq(&workqueue_lock);		/* for wq->maydays */
+	spin_lock_irq(&wq_mayday_lock);		/* for wq->maydays */
 	spin_lock(&pool->lock);
 
 	if (need_to_create_worker(pool)) {
@@ -1926,7 +1926,7 @@ static void pool_mayday_timeout(unsigned long __pool)
 	}
 
 	spin_unlock(&pool->lock);
-	spin_unlock_irq(&workqueue_lock);
+	spin_unlock_irq(&wq_mayday_lock);
 
 	mod_timer(&pool->mayday_timer, jiffies + MAYDAY_INTERVAL);
 }
@@ -2404,7 +2404,7 @@ repeat:
 	}
 
 	/* see whether any pwq is asking for help */
-	spin_lock_irq(&workqueue_lock);
+	spin_lock_irq(&wq_mayday_lock);
 
 	while (!list_empty(&wq->maydays)) {
 		struct pool_workqueue *pwq = list_first_entry(&wq->maydays,
@@ -2415,7 +2415,7 @@ repeat:
 		__set_current_state(TASK_RUNNING);
 		list_del_init(&pwq->mayday_node);
 
-		spin_unlock_irq(&workqueue_lock);
+		spin_unlock_irq(&wq_mayday_lock);
 
 		/* migrate to the target cpu if possible */
 		worker_maybe_bind_and_lock(pool);
@@ -2442,10 +2442,10 @@ repeat:
 
 		rescuer->pool = NULL;
 		spin_unlock(&pool->lock);
-		spin_lock(&workqueue_lock);
+		spin_lock(&wq_mayday_lock);
 	}
 
-	spin_unlock_irq(&workqueue_lock);
+	spin_unlock_irq(&wq_mayday_lock);
 
 	/* rescuers should never participate in concurrency management */
 	WARN_ON_ONCE(!(rescuer->flags & WORKER_NOT_RUNNING));
-- 
1.8.1.4

