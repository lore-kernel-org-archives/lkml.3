Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab3JYOmw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 10:42:52 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:61462 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab3JYOmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 10:42:50 -0400
From: Matias Bjorling <m@bjorling.me>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, Matias Bjorling <m@bjorling.me>
Subject: [PATCH 2/2] blk-mq: add maps_tags fn and add usage
Date: Fri, 25 Oct 2013 16:42:37 +0200
Message-Id: <1382712157-28564-3-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382712157-28564-1-git-send-email-m@bjorling.me>
References: <1382712157-28564-1-git-send-email-m@bjorling.me>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the tags mapping allows shared mapping, update blk-mq to allow
the driver to control initialization of the tags structure.

Signed-off-by: Matias Bjorling <m@bjorling.me>
---
 block/blk-mq.c         | 11 +++++++----
 include/linux/blk-mq.h | 12 ++++++++++++
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index f21ec96..9e25555 100644
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
@@ -1158,7 +1158,10 @@ static int blk_mq_init_rq_map(struct blk_mq_hw_ctx *hctx,
 					__func__, i);
 	}
 
-	hctx->tags = blk_mq_init_tags(hctx->queue_depth, reserved_tags, node);
+	if (reg->ops->map_tags)
+		hctx->tags = reg->ops->map_tags(hctx, reg, node);
+	else
+		hctx->tags = blk_mq_init_tags(hctx->queue_depth, reg->reserved_tags, node);
 	if (!hctx->tags) {
 err_rq_map:
 		blk_mq_free_rq_map(hctx);
@@ -1198,7 +1201,7 @@ static int blk_mq_init_hw_queues(struct request_queue *q,
 						blk_mq_hctx_notify, hctx);
 		blk_mq_register_cpu_notifier(&hctx->cpu_notifier);
 
-		if (blk_mq_init_rq_map(hctx, reg->reserved_tags, node))
+		if (blk_mq_init_rq_map(hctx, reg, node))
 			break;
 
 		/*
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 746042ff..eb6df6a 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -66,6 +66,8 @@ typedef struct blk_mq_hw_ctx *(alloc_hctx_fn)(struct blk_mq_reg *,unsigned int);
 typedef void (free_hctx_fn)(struct blk_mq_hw_ctx *, unsigned int);
 typedef int (init_hctx_fn)(struct blk_mq_hw_ctx *, void *, unsigned int);
 typedef void (exit_hctx_fn)(struct blk_mq_hw_ctx *, unsigned int);
+typedef struct blk_mq_tags *(map_tags_fn)(struct blk_mq_hw_ctx *,
+					  struct blk_mq_reg *, unsigned int node);
 
 struct blk_mq_ops {
 	/*
@@ -96,6 +98,12 @@ struct blk_mq_ops {
 	 */
 	init_hctx_fn		*init_hctx;
 	exit_hctx_fn		*exit_hctx;
+
+	/*
+	 * If a tags structure is to be shared between multiple request queues,
+	 * allow the driver to initialize or reuse a tags structure.
+	 */
+	map_tags_fn		*map_tags;
 };
 
 enum {
@@ -138,6 +146,10 @@ void blk_mq_stop_hw_queue(struct blk_mq_hw_ctx *hctx);
 void blk_mq_start_hw_queue(struct blk_mq_hw_ctx *hctx);
 void blk_mq_start_stopped_hw_queues(struct request_queue *q);
 
+struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
+				     unsigned int reserved_tags, int node);
+void blk_mq_init_tags_shared(struct blk_mq_tags *tags);
+
 /*
  * Driver command data is immediately after the request. So subtract request
  * size to get back to the original request.
-- 
1.8.3.2

