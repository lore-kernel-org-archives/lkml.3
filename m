Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbaE0S6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 14:58:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:39269 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbaE0S5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 14:57:42 -0400
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@fb.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] blk-mq: do not use blk_mq_alloc_request_pinned in blk_mq_map_request
Date: Tue, 27 May 2014 20:59:49 +0200
Message-Id: <1401217190-32453-5-git-send-email-hch@lst.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401217190-32453-1-git-send-email-hch@lst.de>
References: <1401217190-32453-1-git-send-email-hch@lst.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already do a non-blocking allocation in blk_mq_map_request, no need
to repeat it.  Just call __blk_mq_alloc_request to wait directly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 44ee79c..7489d19 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1115,12 +1115,14 @@ static struct request *blk_mq_map_request(struct request_queue *q,
 	trace_block_getrq(q, bio, rw);
 	rq = __blk_mq_alloc_request(q, hctx, ctx, rw, GFP_ATOMIC, false);
 	if (unlikely(!rq)) {
+		__blk_mq_run_hw_queue(hctx);
 		blk_mq_put_ctx(ctx);
 		trace_block_sleeprq(q, bio, rw);
-		rq = blk_mq_alloc_request_pinned(q, rw, __GFP_WAIT|GFP_ATOMIC,
-							false);
-		ctx = rq->mq_ctx;
+
+		ctx = blk_mq_get_ctx(q);
 		hctx = q->mq_ops->map_queue(q, ctx->cpu);
+		rq = __blk_mq_alloc_request(q, hctx, ctx, rw,
+					    __GFP_WAIT|GFP_ATOMIC, false);
 	}
 
 	hctx->queued++;
-- 
1.7.10.4

