Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbaFRPVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:21:23 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:33225 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbaFRPVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:21:21 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, kmo@daterainc.com, nab@linux-iscsi.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/6] blk-mq: decouble blk-mq freezing from generic bypassing
Date: Wed, 18 Jun 2014 11:21:10 -0400
Message-Id: <1403104872-22236-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403104872-22236-1-git-send-email-tj@kernel.org>
References: <1403104872-22236-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk_mq freezing is entangled with generic bypassing which bypasses
blkcg and io scheduler and lets IO requests fall through the block
layer to the drivers in FIFO order.  This allows forward progress on
IOs with the advanced features disabled so that those features can be
configured or altered without worrying about stalling IO which may
lead to deadlock through memory allocation.

However, generic bypassing doesn't quite fit blk-mq.  blk-mq currently
doesn't make use of blkcg or ioscheds and it maps bypssing to
freezing, which blocks request processing and drains all the in-flight
ones.  This causes problems as bypassing assumes that request
processing is online.  blk-mq works around this by conditionally
allowing request processing for the problem case - during queue
initialization.

Another weirdity is that except for during queue cleanup, bypassing
started on the generic side prevents blk-mq from processing new
requests but doesn't drain the in-flight ones.  This shouldn't break
anything but again highlights that something isn't quite right here.

The root cause is conflating blk-mq freezing and generic bypassing
which are two different mechanisms.  The only intersecting purpose
that they serve is during queue cleanup.  Let's properly separate
blk-mq freezing from generic bypassing and simply use it where
necessary.

* request_queue->mq_freeze_depth is added and
  blk_mq_[un]freeze_queue() now operate on this counter instead of
  ->bypass_depth.  The replacement for QUEUE_FLAG_BYPASS isn't added
  but the counter is tested directly.  This will be further updated by
  later changes.

* blk_mq_drain_queue() is dropped and "__" prefix is dropped from
  blk_mq_freeze_queue().  Queue cleanup path now calls
  blk_mq_freeze_queue() directly.

* blk_queue_enter()'s fast path condition is simplified to simply
  check @q->mq_freeze_depth.  Previously, the condition was

	!blk_queue_dying(q) &&
	    (!blk_queue_bypass(q) || !blk_queue_init_done(q))

  mq_freeze_depth is incremented right after dying is set and
  blk_queue_init_done() exception isn't necessary as blk-mq doesn't
  start frozen, which only leaves the blk_queue_bypass() test which
  can be replaced by @q->mq_freeze_depth test.

This change simplifies the code and reduces confusion in the area.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 block/blk-core.c       |  2 +-
 block/blk-mq.c         | 22 ++++++----------------
 block/blk-mq.h         |  2 +-
 include/linux/blkdev.h |  1 +
 4 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 2375130..0251947 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -514,7 +514,7 @@ void blk_cleanup_queue(struct request_queue *q)
 	 * prevent that q->request_fn() gets invoked after draining finished.
 	 */
 	if (q->mq_ops) {
-		blk_mq_drain_queue(q);
+		blk_mq_freeze_queue(q);
 		spin_lock_irq(lock);
 	} else {
 		spin_lock_irq(lock);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index c0122a4..f49b2ab 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -84,15 +84,14 @@ static int blk_mq_queue_enter(struct request_queue *q)
 	smp_mb();
 
 	/* we have problems freezing the queue if it's initializing */
-	if (!blk_queue_dying(q) &&
-	    (!blk_queue_bypass(q) || !blk_queue_init_done(q)))
+	if (!q->mq_freeze_depth)
 		return 0;
 
 	__percpu_counter_add(&q->mq_usage_counter, -1, 1000000);
 
 	spin_lock_irq(q->queue_lock);
 	ret = wait_event_interruptible_lock_irq(q->mq_freeze_wq,
-		!blk_queue_bypass(q) || blk_queue_dying(q),
+		!q->mq_freeze_depth || blk_queue_dying(q),
 		*q->queue_lock);
 	/* inc usage with lock hold to avoid freeze_queue runs here */
 	if (!ret && !blk_queue_dying(q))
@@ -129,31 +128,22 @@ static void __blk_mq_drain_queue(struct request_queue *q)
  * Guarantee no request is in use, so we can change any data structure of
  * the queue afterward.
  */
-static void blk_mq_freeze_queue(struct request_queue *q)
+void blk_mq_freeze_queue(struct request_queue *q)
 {
 	spin_lock_irq(q->queue_lock);
-	q->bypass_depth++;
-	queue_flag_set(QUEUE_FLAG_BYPASS, q);
+	q->mq_freeze_depth++;
 	spin_unlock_irq(q->queue_lock);
 
 	__blk_mq_drain_queue(q);
 }
 
-void blk_mq_drain_queue(struct request_queue *q)
-{
-	__blk_mq_drain_queue(q);
-}
-
 static void blk_mq_unfreeze_queue(struct request_queue *q)
 {
 	bool wake = false;
 
 	spin_lock_irq(q->queue_lock);
-	if (!--q->bypass_depth) {
-		queue_flag_clear(QUEUE_FLAG_BYPASS, q);
-		wake = true;
-	}
-	WARN_ON_ONCE(q->bypass_depth < 0);
+	wake = !--q->mq_freeze_depth;
+	WARN_ON_ONCE(q->mq_freeze_depth < 0);
 	spin_unlock_irq(q->queue_lock);
 	if (wake)
 		wake_up_all(&q->mq_freeze_wq);
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 2646088..ca4964a 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -28,7 +28,7 @@ struct blk_mq_ctx {
 void __blk_mq_complete_request(struct request *rq);
 void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async);
 void blk_mq_init_flush(struct request_queue *q);
-void blk_mq_drain_queue(struct request_queue *q);
+void blk_mq_freeze_queue(struct request_queue *q);
 void blk_mq_free_queue(struct request_queue *q);
 void blk_mq_clone_flush_request(struct request *flush_rq,
 		struct request *orig_rq);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 31e1105..2efe26a 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -470,6 +470,7 @@ struct request_queue {
 	struct mutex		sysfs_lock;
 
 	int			bypass_depth;
+	int			mq_freeze_depth;
 
 #if defined(CONFIG_BLK_DEV_BSG)
 	bsg_job_fn		*bsg_job_fn;
-- 
1.9.3

