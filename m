Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbaLCLiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:38:21 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:49727 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaLCLiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:38:17 -0500
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: Ming Lei <ming.lei@canonical.com>
Subject: [PATCH] blk-mq: prevent unmapped hw queue from being scheduled
Date: Wed,  3 Dec 2014 19:38:04 +0800
Message-Id: <1417606684-20907-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When one hardware queue has no mapped software queues, it
shouldn't have been scheduled. Otherwise WARNING or OOPS
can triggered.

blk_mq_hw_queue_mapped() helper is introduce for fixing
the problem.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 block/blk-mq.c |    8 ++++++--
 block/blk-mq.h |    5 +++++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index c95abc6..c916ad0 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -599,7 +599,7 @@ static void blk_mq_rq_timer(unsigned long priv)
 		 * If not software queues are currently mapped to this
 		 * hardware queue, there's nothing to check
 		 */
-		if (!hctx->nr_ctx || !hctx->tags)
+		if (!blk_mq_hw_queue_mapped(hctx))
 			continue;
 
 		blk_mq_tag_busy_iter(hctx, blk_mq_check_expired, &data);
@@ -819,7 +819,8 @@ static int blk_mq_hctx_next_cpu(struct blk_mq_hw_ctx *hctx)
 
 void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async)
 {
-	if (unlikely(test_bit(BLK_MQ_S_STOPPED, &hctx->state)))
+	if (unlikely(test_bit(BLK_MQ_S_STOPPED, &hctx->state) ||
+	    !blk_mq_hw_queue_mapped(hctx)))
 		return;
 
 	if (!async) {
@@ -926,6 +927,9 @@ static void blk_mq_delay_work_fn(struct work_struct *work)
 
 void blk_mq_delay_queue(struct blk_mq_hw_ctx *hctx, unsigned long msecs)
 {
+	if (unlikely(!blk_mq_hw_queue_mapped(hctx)))
+		return;
+
 	kblockd_schedule_delayed_work_on(blk_mq_hctx_next_cpu(hctx),
 			&hctx->delay_work, msecs_to_jiffies(msecs));
 }
diff --git a/block/blk-mq.h b/block/blk-mq.h
index d567d52..206230e 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -115,4 +115,9 @@ static inline void blk_mq_set_alloc_data(struct blk_mq_alloc_data *data,
 	data->hctx = hctx;
 }
 
+static inline bool blk_mq_hw_queue_mapped(struct blk_mq_hw_ctx *hctx)
+{
+	return hctx->nr_ctx && hctx->tags;
+}
+
 #endif
-- 
1.7.9.5

