Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbaDQPug (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:50:36 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48089 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221AbaDQPuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 11:50:13 -0400
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH next 4/4] blk-mq: initialize req->q in allocation
Date: Thu, 17 Apr 2014 23:49:38 +0800
Message-Id: <1397749778-14485-5-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397749778-14485-1-git-send-email-tom.leiming@gmail.com>
References: <1397749778-14485-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch basically reverts the patch of(blk-mq:
initialize request on allocation) in Jens's tree(already
in -next), and only initialize req->q in allocation
for two reasons:

	- presumed cache hotness on completion
	- blk_rq_tagged(rq) depends on reset of req->mq_ctx

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 block/blk-mq.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 1eff3d9..b7a51ed 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -82,7 +82,6 @@ static struct request *__blk_mq_alloc_request(struct blk_mq_hw_ctx *hctx,
 	tag = blk_mq_get_tag(hctx->tags, gfp, reserved);
 	if (tag != BLK_MQ_TAG_FAIL) {
 		rq = hctx->tags->rqs[tag];
-		blk_rq_init(hctx->queue, rq);
 		rq->tag = tag;
 
 		return rq;
@@ -187,6 +186,7 @@ static void blk_mq_rq_ctx_init(struct request_queue *q, struct blk_mq_ctx *ctx,
 	if (blk_queue_io_stat(q))
 		rw_flags |= REQ_IO_STAT;
 
+	rq->q = q;
 	rq->mq_ctx = ctx;
 	rq->cmd_flags = rw_flags;
 	rq->start_time = jiffies;
@@ -258,6 +258,7 @@ static void __blk_mq_free_request(struct blk_mq_hw_ctx *hctx,
 	const int tag = rq->tag;
 	struct request_queue *q = rq->q;
 
+	blk_rq_init(hctx->queue, rq);
 	blk_mq_put_tag(hctx->tags, tag);
 	blk_mq_queue_exit(q);
 }
@@ -1194,6 +1195,7 @@ static struct blk_mq_tags *blk_mq_init_rq_map(struct blk_mq_tag_set *set,
 		left -= to_do * rq_size;
 		for (j = 0; j < to_do; j++) {
 			tags->rqs[i] = p;
+			blk_rq_init(NULL, tags->rqs[i]);
 			if (set->ops->init_request) {
 				if (set->ops->init_request(set->driver_data,
 						tags->rqs[i], hctx_idx, i,
-- 
1.7.9.5

