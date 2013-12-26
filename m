Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab3LZNcI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 08:32:08 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61414 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab3LZNcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 08:32:04 -0500
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v1 2/5] block: blk-mq: support draining mq queue
Date: Thu, 26 Dec 2013 21:31:35 +0800
Message-Id: <1388064698-27344-3-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1388064698-27344-1-git-send-email-tom.leiming@gmail.com>
References: <1388064698-27344-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk_mq_drain_queue() is introduced so that we can drain
mq queue inside blk_cleanup_queue().

Also don't accept new requests any more if queue is marked
as dying.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 block/blk-core.c |   10 ++++++++--
 block/blk-exec.c |    4 ++++
 block/blk-mq.c   |   43 +++++++++++++++++++++++++++----------------
 block/blk-mq.h   |    1 +
 4 files changed, 40 insertions(+), 18 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 5da8e90..accb7fc 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -38,6 +38,7 @@
 
 #include "blk.h"
 #include "blk-cgroup.h"
+#include "blk-mq.h"
 
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_remap);
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_rq_remap);
@@ -497,8 +498,13 @@ void blk_cleanup_queue(struct request_queue *q)
 	 * Drain all requests queued before DYING marking. Set DEAD flag to
 	 * prevent that q->request_fn() gets invoked after draining finished.
 	 */
-	spin_lock_irq(lock);
-	__blk_drain_queue(q, true);
+	if (q->mq_ops) {
+		blk_mq_drain_queue(q);
+		spin_lock_irq(lock);
+	} else {
+		spin_lock_irq(lock);
+		__blk_drain_queue(q, true);
+	}
 	queue_flag_set(QUEUE_FLAG_DEAD, q);
 	spin_unlock_irq(lock);
 
diff --git a/block/blk-exec.c b/block/blk-exec.c
index c3edf9d..bbfc072 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -60,6 +60,10 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 	rq->rq_disk = bd_disk;
 	rq->end_io = done;
 
+	/*
+	 * don't check dying flag for MQ because the request won't
+	 * be resued after dying flag is set
+	 */
 	if (q->mq_ops) {
 		blk_mq_insert_request(q, rq, true);
 		return;
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 35ae189..38b7bde 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -105,10 +105,13 @@ static int blk_mq_queue_enter(struct request_queue *q)
 
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
@@ -119,6 +122,22 @@ static void blk_mq_queue_exit(struct request_queue *q)
 	__percpu_counter_add(&q->mq_usage_counter, -1, 1000000);
 }
 
+static void __blk_mq_drain_queue(struct request_queue *q)
+{
+	while (true) {
+		s64 count;
+
+		spin_lock_irq(q->queue_lock);
+		count = percpu_counter_sum(&q->mq_usage_counter);
+		spin_unlock_irq(q->queue_lock);
+
+		if (count == 0)
+			break;
+		blk_mq_run_queues(q, false);
+		msleep(10);
+	}
+}
+
 /*
  * Guarantee no request is in use, so we can change any data structure of
  * the queue afterward.
@@ -132,21 +151,13 @@ static void blk_mq_freeze_queue(struct request_queue *q)
 	queue_flag_set(QUEUE_FLAG_BYPASS, q);
 	spin_unlock_irq(q->queue_lock);
 
-	if (!drain)
-		return;
-
-	while (true) {
-		s64 count;
-
-		spin_lock_irq(q->queue_lock);
-		count = percpu_counter_sum(&q->mq_usage_counter);
-		spin_unlock_irq(q->queue_lock);
+	if (drain)
+		__blk_mq_drain_queue(q);
+}
 
-		if (count == 0)
-			break;
-		blk_mq_run_queues(q, false);
-		msleep(10);
-	}
+void blk_mq_drain_queue(struct request_queue *q)
+{
+	__blk_mq_drain_queue(q);
 }
 
 static void blk_mq_unfreeze_queue(struct request_queue *q)
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

