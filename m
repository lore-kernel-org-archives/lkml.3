Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbaGPVFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:05:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:59873 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbaGPVFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:05:10 -0400
Message-Id: <20140716205056.701901115@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:05:07 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>
Subject: [patch V2 53/64] drm: vmwgfx: Use nsec based interfaces
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=drm-vmwgfx-use-nsec-raw.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No point in converting timespecs back and forth.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Thomas Hellstrom <thellstrom@vmware.com>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h    |    4 +--
 drivers/gpu/drm/vmwgfx/vmwgfx_marker.c |   44 ++++++++++-----------------------
 2 files changed, 16 insertions(+), 32 deletions(-)

Index: tip/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
===================================================================
--- tip.orig/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
+++ tip/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
@@ -159,8 +159,8 @@ struct vmw_surface {
 
 struct vmw_marker_queue {
 	struct list_head head;
-	struct timespec lag;
-	struct timespec lag_time;
+	u64 lag;
+	u64 lag_time;
 	spinlock_t lock;
 };
 
Index: tip/drivers/gpu/drm/vmwgfx/vmwgfx_marker.c
===================================================================
--- tip.orig/drivers/gpu/drm/vmwgfx/vmwgfx_marker.c
+++ tip/drivers/gpu/drm/vmwgfx/vmwgfx_marker.c
@@ -31,14 +31,14 @@
 struct vmw_marker {
 	struct list_head head;
 	uint32_t seqno;
-	struct timespec submitted;
+	u64 submitted;
 };
 
 void vmw_marker_queue_init(struct vmw_marker_queue *queue)
 {
 	INIT_LIST_HEAD(&queue->head);
-	queue->lag = ns_to_timespec(0);
-	getrawmonotonic(&queue->lag_time);
+	queue->lag = 0;
+	queue->lag_time = ktime_get_raw_ns();
 	spin_lock_init(&queue->lock);
 }
 
@@ -62,7 +62,7 @@ int vmw_marker_push(struct vmw_marker_qu
 		return -ENOMEM;
 
 	marker->seqno = seqno;
-	getrawmonotonic(&marker->submitted);
+	marker->submitted = ktime_get_raw_ns();
 	spin_lock(&queue->lock);
 	list_add_tail(&marker->head, &queue->head);
 	spin_unlock(&queue->lock);
@@ -74,14 +74,14 @@ int vmw_marker_pull(struct vmw_marker_qu
 		   uint32_t signaled_seqno)
 {
 	struct vmw_marker *marker, *next;
-	struct timespec now;
 	bool updated = false;
+	u64 now;
 
 	spin_lock(&queue->lock);
-	getrawmonotonic(&now);
+	now = ktime_get_raw_ns();
 
 	if (list_empty(&queue->head)) {
-		queue->lag = ns_to_timespec(0);
+		queue->lag = 0;
 		queue->lag_time = now;
 		updated = true;
 		goto out_unlock;
@@ -91,7 +91,7 @@ int vmw_marker_pull(struct vmw_marker_qu
 		if (signaled_seqno - marker->seqno > (1 << 30))
 			continue;
 
-		queue->lag = timespec_sub(now, marker->submitted);
+		queue->lag = now - marker->submitted;
 		queue->lag_time = now;
 		updated = true;
 		list_del(&marker->head);
@@ -104,27 +104,13 @@ out_unlock:
 	return (updated) ? 0 : -EBUSY;
 }
 
-static struct timespec vmw_timespec_add(struct timespec t1,
-					struct timespec t2)
+static u64 vmw_fifo_lag(struct vmw_marker_queue *queue)
 {
-	t1.tv_sec += t2.tv_sec;
-	t1.tv_nsec += t2.tv_nsec;
-	if (t1.tv_nsec >= 1000000000L) {
-		t1.tv_sec += 1;
-		t1.tv_nsec -= 1000000000L;
-	}
-
-	return t1;
-}
-
-static struct timespec vmw_fifo_lag(struct vmw_marker_queue *queue)
-{
-	struct timespec now;
+	u64 now;
 
 	spin_lock(&queue->lock);
-	getrawmonotonic(&now);
-	queue->lag = vmw_timespec_add(queue->lag,
-				      timespec_sub(now, queue->lag_time));
+	now = ktime_get_raw_ns();
+	queue->lag += now - queue->lag_time;
 	queue->lag_time = now;
 	spin_unlock(&queue->lock);
 	return queue->lag;
@@ -134,11 +120,9 @@ static struct timespec vmw_fifo_lag(stru
 static bool vmw_lag_lt(struct vmw_marker_queue *queue,
 		       uint32_t us)
 {
-	struct timespec lag, cond;
+	u64 cond = (u64) us * NSEC_PER_USEC;
 
-	cond = ns_to_timespec((s64) us * 1000);
-	lag = vmw_fifo_lag(queue);
-	return (timespec_compare(&lag, &cond) < 1);
+	return vmw_fifo_lag(queue) <= cond;
 }
 
 int vmw_wait_lag(struct vmw_private *dev_priv,


