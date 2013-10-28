Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab3J1KAf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 06:00:35 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:43754 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755383Ab3J1KAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 06:00:21 -0400
From: Matias Bjorling <m@bjorling.me>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, Matias Bjorling <m@bjorling.me>
Subject: [PATCH 2/2] blk-mq: add maps_tags fn and add usage
Date: Mon, 28 Oct 2013 11:00:09 +0100
Message-Id: <1382954409-30789-3-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382954409-30789-1-git-send-email-m@bjorling.me>
References: <1382954409-30789-1-git-send-email-m@bjorling.me>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the tags mapping allows shared mapping, update blk-mq to allow
the driver to control initialization of the tags structure.

Signed-off-by: Matias Bjorling <m@bjorling.me>
---
 block/blk-mq.c         | 19 +++++++++++--------
 include/linux/blk-mq.h |  6 ++++++
 2 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index f21ec96..ed94478 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1093,7 +1093,7 @@ static size_t order_to_size(unsigned int order)
 }
 
 static int blk_mq_init_rq_map(struct blk_mq_hw_ctx *hctx,
-			      unsigned int reserved_tags, int node)
+			      struct blk_mq_reg *reg, int node)
 {
 	unsigned int i, j, entries_per_page, max_order = 4;
 	size_t rq_size, left;
@@ -1150,7 +1150,7 @@ static int blk_mq_init_rq_map(struct blk_mq_hw_ctx *hctx,
 		}
 	}
 
-	if (i < (reserved_tags + BLK_MQ_TAG_MIN))
+	if (i < (reg->reserved_tags + BLK_MQ_TAG_MIN))
 		goto err_rq_map;
 	else if (i != hctx->queue_depth) {
 		hctx->queue_depth = i;
@@ -1158,14 +1158,17 @@ static int blk_mq_init_rq_map(struct blk_mq_hw_ctx *hctx,
 					__func__, i);
 	}
 
-	hctx->tags = blk_mq_init_tags(hctx->queue_depth, reserved_tags, node);
-	if (!hctx->tags) {
+	if (reg->flags & ~(BLK_MQ_F_DRV_INIT_TAGS)) {
+		hctx->tags = blk_mq_init_tags(hctx->queue_depth,
+						reg->reserved_tags, node);
+		if (!hctx->tags)
+			goto err_rq_map;
+	}
+
+	return 0;
 err_rq_map:
 		blk_mq_free_rq_map(hctx);
 		return -ENOMEM;
-	}
-
-	return 0;
 }
 
 static int blk_mq_init_hw_queues(struct request_queue *q,
@@ -1198,7 +1201,7 @@ static int blk_mq_init_hw_queues(struct request_queue *q,
 						blk_mq_hctx_notify, hctx);
 		blk_mq_register_cpu_notifier(&hctx->cpu_notifier);
 
-		if (blk_mq_init_rq_map(hctx, reg->reserved_tags, node))
+		if (blk_mq_init_rq_map(hctx, reg, node))
 			break;
 
 		/*
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 746042ff..0b25075 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -107,6 +107,8 @@ enum {
 	BLK_MQ_F_SHOULD_SORT	= 1 << 1,
 	BLK_MQ_F_SHOULD_IPI	= 1 << 2,
 
+	BLK_MQ_F_DRV_INIT_TAGS	= 1 << 3,
+
 	BLK_MQ_S_STOPPED	= 1 << 0,
 
 	BLK_MQ_MAX_DEPTH	= 2048,
@@ -138,6 +140,10 @@ void blk_mq_stop_hw_queue(struct blk_mq_hw_ctx *hctx);
 void blk_mq_start_hw_queue(struct blk_mq_hw_ctx *hctx);
 void blk_mq_start_stopped_hw_queues(struct request_queue *q);
 
+struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
+				     unsigned int reserved_tags, int node);
+void blk_mq_get_tags(struct blk_mq_tags *tags);
+
 /*
  * Driver command data is immediately after the request. So subtract request
  * size to get back to the original request.
-- 
1.8.3.2

