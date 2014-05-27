Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbaE0S62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 14:58:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:39268 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbaE0S5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 14:57:41 -0400
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@fb.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] blk-mq: remove blk_mq_wait_for_tags
Date: Tue, 27 May 2014 20:59:48 +0200
Message-Id: <1401217190-32453-4-git-send-email-hch@lst.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401217190-32453-1-git-send-email-hch@lst.de>
References: <1401217190-32453-1-git-send-email-hch@lst.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current logic for blocking tag allocation is rather confusing, as we
first allocated and then free again a tag in blk_mq_wait_for_tags, just
to attempt a non-blocking allocation and then repeat if someone else
managed to grab the tag before us.

Instead change blk_mq_alloc_request_pinned to simply do a blocking tag
allocation itself and use the request we get back from it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq-tag.c |    8 --------
 block/blk-mq-tag.h |    1 -
 block/blk-mq.c     |   13 ++++++-------
 3 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 05e2baf..0d0640d 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -7,14 +7,6 @@
 #include "blk-mq.h"
 #include "blk-mq-tag.h"
 
-void blk_mq_wait_for_tags(struct blk_mq_hw_ctx *hctx, bool reserved)
-{
-	int tag, zero = 0;
-
-	tag = blk_mq_get_tag(hctx, &zero, __GFP_WAIT, reserved);
-	blk_mq_put_tag(hctx, tag, &zero);
-}
-
 static bool bt_has_free_tags(struct blk_mq_bitmap_tags *bt)
 {
 	int i;
diff --git a/block/blk-mq-tag.h b/block/blk-mq-tag.h
index 2e5e687..c959de5 100644
--- a/block/blk-mq-tag.h
+++ b/block/blk-mq-tag.h
@@ -49,7 +49,6 @@ extern struct blk_mq_tags *blk_mq_init_tags(unsigned int nr_tags, unsigned int r
 extern void blk_mq_free_tags(struct blk_mq_tags *tags);
 
 extern unsigned int blk_mq_get_tag(struct blk_mq_hw_ctx *hctx, unsigned int *last_tag, gfp_t gfp, bool reserved);
-extern void blk_mq_wait_for_tags(struct blk_mq_hw_ctx *hctx, bool reserved);
 extern void blk_mq_put_tag(struct blk_mq_hw_ctx *hctx, unsigned int tag, unsigned int *last_tag);
 extern bool blk_mq_has_free_tags(struct blk_mq_tags *tags);
 extern ssize_t blk_mq_tag_sysfs_show(struct blk_mq_tags *tags, char *page);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 848b3b6..44ee79c 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -264,31 +264,30 @@ __blk_mq_alloc_request(struct request_queue *q, struct blk_mq_hw_ctx *hctx,
 	return NULL;
 }
 
-
 static struct request *blk_mq_alloc_request_pinned(struct request_queue *q,
 						   int rw, gfp_t gfp,
 						   bool reserved)
 {
+	bool gfp_mask = gfp & ~__GFP_WAIT;
 	struct request *rq;
 
 	do {
 		struct blk_mq_ctx *ctx = blk_mq_get_ctx(q);
 		struct blk_mq_hw_ctx *hctx = q->mq_ops->map_queue(q, ctx->cpu);
 
-		rq = __blk_mq_alloc_request(q, hctx, ctx, rw, gfp & ~__GFP_WAIT,
+		rq = __blk_mq_alloc_request(q, hctx, ctx, rw, gfp_mask,
 						reserved);
 		if (rq)
 			break;
 
-		if (gfp & __GFP_WAIT) {
-			__blk_mq_run_hw_queue(hctx);
-			blk_mq_put_ctx(ctx);
-		} else {
+		if (!(gfp & __GFP_WAIT)) {
 			blk_mq_put_ctx(ctx);
 			break;
 		}
 
-		blk_mq_wait_for_tags(hctx, reserved);
+		__blk_mq_run_hw_queue(hctx);
+		blk_mq_put_ctx(ctx);
+		gfp_mask = gfp;
 	} while (1);
 
 	return rq;
-- 
1.7.10.4

