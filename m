Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933591AbaFIQRH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 12:17:07 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:47901 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932653AbaFIQRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 12:17:05 -0400
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] blk-mq: add timer in blk_mq_start_request
Date: Tue, 10 Jun 2014 00:16:41 +0800
Message-Id: <1402330601-12837-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This way will become consistent with non-mq case, also
avoid to update rq->deadline twice for mq.

The comment said: "We do this early, to ensure we are on
the right CPU.", but no percpu stuff is used in blk_add_timer(),
so it isn't necessary. Even when inserting from plug list, there
is no such guarantee at all.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 block/blk-mq.c |   17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index a6ee74e..bf6e13d 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -406,16 +406,7 @@ static void blk_mq_start_request(struct request *rq, bool last)
 	if (unlikely(blk_bidi_rq(rq)))
 		rq->next_rq->resid_len = blk_rq_bytes(rq->next_rq);
 
-	/*
-	 * Just mark start time and set the started bit. Due to memory
-	 * ordering, we know we'll see the correct deadline as long as
-	 * REQ_ATOMIC_STARTED is seen. Use the default queue timeout,
-	 * unless one has been set in the request.
-	 */
-	if (!rq->timeout)
-		rq->deadline = jiffies + q->rq_timeout;
-	else
-		rq->deadline = jiffies + rq->timeout;
+	blk_add_timer(rq);
 
 	/*
 	 * Mark us as started and clear complete. Complete might have been
@@ -967,11 +958,6 @@ static void __blk_mq_insert_request(struct blk_mq_hw_ctx *hctx,
 		list_add_tail(&rq->queuelist, &ctx->rq_list);
 
 	blk_mq_hctx_mark_pending(hctx, ctx);
-
-	/*
-	 * We do this early, to ensure we are on the right CPU.
-	 */
-	blk_add_timer(rq);
 }
 
 void blk_mq_insert_request(struct request *rq, bool at_head, bool run_queue,
@@ -1216,7 +1202,6 @@ static void blk_mq_make_request(struct request_queue *q, struct bio *bio)
 
 		blk_mq_bio_to_request(rq, bio);
 		blk_mq_start_request(rq, true);
-		blk_add_timer(rq);
 
 		/*
 		 * For OK queue, we are done. For error, kill it. Any other
-- 
1.7.9.5

