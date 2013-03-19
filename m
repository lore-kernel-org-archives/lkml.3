Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933671Ab3CSTdF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 15:33:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49242 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932983Ab3CST2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 15:28:49 -0400
X-IronPort-AV: E=Sophos;i="4.84,874,1355068800"; 
   d="scan'208";a="6904502"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 07/21] workqueue: rename wq_mutex to wqs_mutex
Date: Wed, 20 Mar 2013 03:28:07 +0800
Message-Id: <1363721306-2030-8-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
References: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/20 03:27:22,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/20 03:27:22,
	Serialize complete at 2013/03/20 03:27:22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just simple rename. because it protects workqueueS, add "s" to it,
like pools_mutex.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   50 +++++++++++++++++++++++++-------------------------
 1 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index cc5eb61..5252107 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -123,7 +123,7 @@ enum {
  * MG: pool->manager_mutex and pool->lock protected.  Writes require both
  *     locks.  Reads can happen under either lock.
  *
- * WQ: wq_mutex protected.
+ * QS: wqs_mutex protected.
  *
  * PS: pools_mutex protected.
  *
@@ -228,10 +228,10 @@ struct wq_device;
  * the appropriate worker_pool through its pool_workqueues.
  */
 struct workqueue_struct {
-	unsigned int		flags;		/* WQ: WQ_* flags */
+	unsigned int		flags;		/* QS: WQ_* flags */
 	struct pool_workqueue __percpu *cpu_pwqs; /* I: per-cpu pwq's */
 	struct list_head	pwqs;		/* FR: all pwqs of this wq */
-	struct list_head	list;		/* WQ: list of all workqueues */
+	struct list_head	list;		/* QS: list of all workqueues */
 
 	struct mutex		flush_mutex;	/* protects wq flushing */
 	int			work_color;	/* F: current work color */
@@ -244,7 +244,7 @@ struct workqueue_struct {
 	struct list_head	maydays;	/* MD: pwqs requesting rescue */
 	struct worker		*rescuer;	/* I: rescue worker */
 
-	int			nr_drainers;	/* WQ: drain in progress */
+	int			nr_drainers;	/* QS: drain in progress */
 	int			saved_max_active; /* PW: saved pwq max_active */
 
 #ifdef CONFIG_SYSFS
@@ -258,13 +258,13 @@ struct workqueue_struct {
 
 static struct kmem_cache *pwq_cache;
 
-static DEFINE_MUTEX(wq_mutex);		/* protects workqueues */
+static DEFINE_MUTEX(wqs_mutex);		/* protects workqueues */
 static DEFINE_MUTEX(pools_mutex);	/* protects pools */
 static DEFINE_SPINLOCK(pwq_lock);	/* protects pool_workqueues */
 static DEFINE_SPINLOCK(wq_mayday_lock);	/* protects wq->maydays list */
 
-static LIST_HEAD(workqueues);		/* WQ: list of all workqueues */
-static bool workqueue_freezing;		/* WQ&PS: have wqs started freezing? */
+static LIST_HEAD(workqueues);		/* QS: list of all workqueues */
+static bool workqueue_freezing;		/* QS&PS: have wqs started freezing? */
 
 /* the per-cpu worker pools */
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct worker_pool [NR_STD_WORKER_POOLS],
@@ -2686,10 +2686,10 @@ void drain_workqueue(struct workqueue_struct *wq)
 	 * hotter than drain_workqueue() and already looks at @wq->flags.
 	 * Use __WQ_DRAINING so that queue doesn't have to check nr_drainers.
 	 */
-	mutex_lock(&wq_mutex);
+	mutex_lock(&wqs_mutex);
 	if (!wq->nr_drainers++)
 		wq->flags |= __WQ_DRAINING;
-	mutex_unlock(&wq_mutex);
+	mutex_unlock(&wqs_mutex);
 reflush:
 	flush_workqueue(wq);
 
@@ -2716,10 +2716,10 @@ reflush:
 
 	local_irq_enable();
 
-	mutex_lock(&wq_mutex);
+	mutex_lock(&wqs_mutex);
 	if (!--wq->nr_drainers)
 		wq->flags &= ~__WQ_DRAINING;
-	mutex_unlock(&wq_mutex);
+	mutex_unlock(&wqs_mutex);
 }
 EXPORT_SYMBOL_GPL(drain_workqueue);
 
@@ -3807,10 +3807,10 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 		goto err_destroy;
 
 	/*
-	 * wq_mutex protects global freeze state and workqueues list.  Grab
+	 * wqs_mutex protects global freeze state and workqueues list.  Grab
 	 * it, adjust max_active and add the new @wq to workqueues list.
 	 */
-	mutex_lock(&wq_mutex);
+	mutex_lock(&wqs_mutex);
 
 	spin_lock_irq(&pwq_lock);
 	for_each_pwq(pwq, wq)
@@ -3819,7 +3819,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 
 	list_add(&wq->list, &workqueues);
 
-	mutex_unlock(&wq_mutex);
+	mutex_unlock(&wqs_mutex);
 
 	return wq;
 
@@ -3870,9 +3870,9 @@ void destroy_workqueue(struct workqueue_struct *wq)
 	 * wq list is used to freeze wq, remove from list after
 	 * flushing is complete in case freeze races us.
 	 */
-	mutex_lock(&wq_mutex);
+	mutex_lock(&wqs_mutex);
 	list_del_init(&wq->list);
-	mutex_unlock(&wq_mutex);
+	mutex_unlock(&wqs_mutex);
 
 	workqueue_sysfs_unregister(wq);
 
@@ -4296,7 +4296,7 @@ EXPORT_SYMBOL_GPL(work_on_cpu);
  * pool->worklist.
  *
  * CONTEXT:
- * Grabs and releases wq_mutex, pwq_lock and pool->lock's.
+ * Grabs and releases wqs_mutex, pwq_lock and pool->lock's.
  */
 void freeze_workqueues_begin(void)
 {
@@ -4305,7 +4305,7 @@ void freeze_workqueues_begin(void)
 	struct pool_workqueue *pwq;
 	int pi;
 
-	mutex_lock(&wq_mutex);
+	mutex_lock(&wqs_mutex);
 
 	/* set FREEZING */
 	mutex_lock(&pools_mutex);
@@ -4328,7 +4328,7 @@ void freeze_workqueues_begin(void)
 	}
 	spin_unlock_irq(&pwq_lock);
 
-	mutex_unlock(&wq_mutex);
+	mutex_unlock(&wqs_mutex);
 }
 
 /**
@@ -4338,7 +4338,7 @@ void freeze_workqueues_begin(void)
  * between freeze_workqueues_begin() and thaw_workqueues().
  *
  * CONTEXT:
- * Grabs and releases wq_mutex.
+ * Grabs and releases wqs_mutex.
  *
  * RETURNS:
  * %true if some freezable workqueues are still busy.  %false if freezing
@@ -4350,7 +4350,7 @@ bool freeze_workqueues_busy(void)
 	struct workqueue_struct *wq;
 	struct pool_workqueue *pwq;
 
-	mutex_lock(&wq_mutex);
+	mutex_lock(&wqs_mutex);
 
 	WARN_ON_ONCE(!workqueue_freezing);
 
@@ -4373,7 +4373,7 @@ bool freeze_workqueues_busy(void)
 		preempt_enable();
 	}
 out_unlock:
-	mutex_unlock(&wq_mutex);
+	mutex_unlock(&wqs_mutex);
 	return busy;
 }
 
@@ -4384,7 +4384,7 @@ out_unlock:
  * frozen works are transferred to their respective pool worklists.
  *
  * CONTEXT:
- * Grabs and releases wq_mutex, pwq_lock and pool->lock's.
+ * Grabs and releases wqs_mutex, pwq_lock and pool->lock's.
  */
 void thaw_workqueues(void)
 {
@@ -4393,7 +4393,7 @@ void thaw_workqueues(void)
 	struct worker_pool *pool;
 	int pi;
 
-	mutex_lock(&wq_mutex);
+	mutex_lock(&wqs_mutex);
 
 	if (!workqueue_freezing)
 		goto out_unlock;
@@ -4417,7 +4417,7 @@ void thaw_workqueues(void)
 	}
 	spin_unlock_irq(&pwq_lock);
 out_unlock:
-	mutex_unlock(&wq_mutex);
+	mutex_unlock(&wqs_mutex);
 }
 #endif /* CONFIG_FREEZER */
 
-- 
1.7.7.6

