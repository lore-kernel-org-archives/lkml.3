Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab3CBD27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:28:59 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:55038 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab3CBDZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:25:05 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jmoyer@redhat.com, zab@redhat.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 21/31] workqueue: drop WQ_RESCUER and test workqueue->rescuer for NULL instead
Date: Fri,  1 Mar 2013 19:24:12 -0800
Message-Id: <1362194662-2344-22-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362194662-2344-1-git-send-email-tj@kernel.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WQ_RESCUER is superflous.  WQ_MEM_RECLAIM indicates that the user
wants a rescuer and testing wq->rescuer for NULL can answer whether a
given workqueue has a rescuer or not.  Drop WQ_RESCUER and test
wq->rescuer directly.

This will help simplifying __alloc_workqueue_key() failure path by
allowing it to use destroy_workqueue() on a partially constructed
workqueue, which in turn will help implementing dynamic management of
pool_workqueues.

While at it, clear wq->rescuer after freeing it in
destroy_workqueue().  This is a precaution as scheduled changes will
make destruction more complex.

This patch doesn't introduce any functional changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |  1 -
 kernel/workqueue.c        | 22 ++++++++++------------
 2 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 2683e8e..0341403 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -294,7 +294,6 @@ enum {
 	WQ_CPU_INTENSIVE	= 1 << 5, /* cpu instensive workqueue */
 
 	WQ_DRAINING		= 1 << 6, /* internal: workqueue is draining */
-	WQ_RESCUER		= 1 << 7, /* internal: workqueue has rescuer */
 
 	WQ_MAX_ACTIVE		= 512,	  /* I like 512, better ideas? */
 	WQ_MAX_UNBOUND_PER_CPU	= 4,	  /* 4 * #cpus for unbound wq */
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 1695bd6..bcc02bb 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1825,7 +1825,7 @@ static void send_mayday(struct work_struct *work)
 
 	lockdep_assert_held(&workqueue_lock);
 
-	if (!(wq->flags & WQ_RESCUER))
+	if (!wq->rescuer)
 		return;
 
 	/* mayday mayday mayday */
@@ -2283,7 +2283,7 @@ sleep:
  * @__rescuer: self
  *
  * Workqueue rescuer thread function.  There's one rescuer for each
- * workqueue which has WQ_RESCUER set.
+ * workqueue which has WQ_MEM_RECLAIM set.
  *
  * Regular work processing on a pool may block trying to create a new
  * worker which uses GFP_KERNEL allocation which has slight chance of
@@ -2767,7 +2767,7 @@ static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr)
 	 * flusher is not running on the same workqueue by verifying write
 	 * access.
 	 */
-	if (pwq->wq->saved_max_active == 1 || pwq->wq->flags & WQ_RESCUER)
+	if (pwq->wq->saved_max_active == 1 || pwq->wq->rescuer)
 		lock_map_acquire(&pwq->wq->lockdep_map);
 	else
 		lock_map_acquire_read(&pwq->wq->lockdep_map);
@@ -3405,13 +3405,6 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	va_end(args);
 	va_end(args1);
 
-	/*
-	 * Workqueues which may be used during memory reclaim should
-	 * have a rescuer to guarantee forward progress.
-	 */
-	if (flags & WQ_MEM_RECLAIM)
-		flags |= WQ_RESCUER;
-
 	max_active = max_active ?: WQ_DFL_ACTIVE;
 	max_active = wq_clamp_max_active(max_active, flags, wq->name);
 
@@ -3442,7 +3435,11 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	}
 	local_irq_enable();
 
-	if (flags & WQ_RESCUER) {
+	/*
+	 * Workqueues which may be used during memory reclaim should
+	 * have a rescuer to guarantee forward progress.
+	 */
+	if (flags & WQ_MEM_RECLAIM) {
 		struct worker *rescuer;
 
 		wq->rescuer = rescuer = alloc_worker();
@@ -3526,9 +3523,10 @@ void destroy_workqueue(struct workqueue_struct *wq)
 
 	spin_unlock_irq(&workqueue_lock);
 
-	if (wq->flags & WQ_RESCUER) {
+	if (wq->rescuer) {
 		kthread_stop(wq->rescuer->task);
 		kfree(wq->rescuer);
+		wq->rescuer = NULL;
 	}
 
 	/*
-- 
1.8.1.2

