Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586Ab3LWQTb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 11:19:31 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:43952 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab3LWQTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 11:19:19 -0500
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 1/4] block: blk-mq: support draining mq queue
Date: Tue, 24 Dec 2013 00:18:56 +0800
Message-Id: <1387815539-12257-2-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387815539-12257-1-git-send-email-tom.leiming@gmail.com>
References: <1387815539-12257-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk_mq_drain_queue() is introduced so that we can drain
mq queue during cleanup queue.

Also don't accept new requests any more if queue is marked
as dying.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 block/blk-core.c |   13 +++++++++----
 block/blk-mq.c   |   24 +++++++++++++++++++++---
 block/blk-mq.h   |    1 +
 3 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 5da8e90..eb13db0 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -38,6 +38,7 @@
 
 #include "blk.h"
 #include "blk-cgroup.h"
+#include "blk-mq.h"
 
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_remap);
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_rq_remap);
@@ -497,10 +498,14 @@ void blk_cleanup_queue(struct request_queue *q)
 	 * Drain all requests queued before DYING marking. Set DEAD flag to
 	 * prevent that q->request_fn() gets invoked after draining finished.
 	 */
-	spin_lock_irq(lock);
-	__blk_drain_queue(q, true);
-	queue_flag_set(QUEUE_FLAG_DEAD, q);
-	spin_unlock_irq(lock);
+	if (q->mq_ops) {
+		blk_mq_drain_queue(q);
+	} else {
+		spin_lock_irq(lock);
+		__blk_drain_queue(q, true);
+		queue_flag_set(QUEUE_FLAG_DEAD, q);
+		spin_unlock_irq(lock);
+	}
 
 	/* @q won't process any more request, flush async actions */
 	del_timer_sync(&q->backing_dev_info.laptop_mode_wb_timer);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 53dc9f7..fcfdf35 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -104,10 +104,13 @@ static int blk_mq_queue_enter(struct request_queue *q)
 
 	spin_lock_irq(q->queue_lock);
 	ret = wait_event_interruptible_lock_irq(q->mq_freeze_wq,
-		!blk_queue_bypass(q), *q->queue_lock);
+		!blk_queue_bypass(q) || blk_queue_dying(q),
+		*q->queue_lock);
 	/* inc usage with lock hold to avoid freeze_queue runs here */
-	if (!ret)
+	if (!ret && !blk_queue_dying(q))
 		__percpu_counter_add(&q->mq_usage_counter, 1, 1000000);
+	else if (blk_queue_dying(q))
+		ret = -ENODEV;
 	spin_unlock_irq(q->queue_lock);
 
 	return ret;
@@ -122,10 +125,14 @@ static void blk_mq_queue_exit(struct request_queue *q)
  * Guarantee no request is in use, so we can change any data structure of
  * the queue afterward.
  */
-static void blk_mq_freeze_queue(struct request_queue *q)
+static void __blk_mq_freeze_queue(struct request_queue *q,
+		bool force_drain)
 {
 	bool drain;
 
+	if (force_drain)
+		goto do_drain;
+
 	spin_lock_irq(q->queue_lock);
 	drain = !q->bypass_depth++;
 	queue_flag_set(QUEUE_FLAG_BYPASS, q);
@@ -134,6 +141,7 @@ static void blk_mq_freeze_queue(struct request_queue *q)
 	if (!drain)
 		return;
 
+ do_drain:
 	while (true) {
 		s64 count;
 
@@ -148,6 +156,16 @@ static void blk_mq_freeze_queue(struct request_queue *q)
 	}
 }
 
+static void blk_mq_freeze_queue(struct request_queue *q)
+{
+	__blk_mq_freeze_queue(q, false);
+}
+
+void blk_mq_drain_queue(struct request_queue *q)
+{
+	__blk_mq_freeze_queue(q, true);
+}
+
 static void blk_mq_unfreeze_queue(struct request_queue *q)
 {
 	bool wake = false;
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 5761eed..35ff4f7 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -27,6 +27,7 @@ void blk_mq_complete_request(struct request *rq, int error);
 void blk_mq_run_request(struct request *rq, bool run_queue, bool async);
 void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async);
 void blk_mq_init_flush(struct request_queue *q);
+void blk_mq_drain_queue(struct request_queue *q);
 
 /*
  * CPU hotplug helpers
-- 
1.7.9.5

