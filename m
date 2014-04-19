Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbaDSKCF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 06:02:05 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:55330 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbaDSKAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 06:00:52 -0400
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v1 next 4/4] blk-mq: initialize req->q in allocation
Date: Sat, 19 Apr 2014 18:00:19 +0800
Message-Id: <1397901619-27226-5-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397901619-27226-1-git-send-email-tom.leiming@gmail.com>
References: <1397901619-27226-1-git-send-email-tom.leiming@gmail.com>
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
index 3a560a4..c26b3be 100644
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

