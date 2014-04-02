Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453AbaDBO4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 10:56:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:51053 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932361AbaDBOzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 10:55:07 -0400
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@fb.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 4/5] blk-mq: make ->flush_rq fully transparent to drivers
Date: Wed,  2 Apr 2014 16:57:13 +0200
Message-Id: <1396450634-32021-5-git-send-email-hch@lst.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1396450634-32021-1-git-send-email-hch@lst.de>
References: <1396450634-32021-1-git-send-email-hch@lst.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers shouldn't have to care about the block layer setting aside a
request to implement the flush state machine.  We already override the
mq context and tag to make it more transparent, but so far haven't deal
with the driver private data in the request.  Make sure to override this
as well, and while we're at it add a proper helper sitting in blk-mq.c
that implements the full impersonation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-flush.c |   12 ++----------
 block/blk-mq.c    |   20 ++++++++++++++++++++
 block/blk-mq.h    |    2 ++
 3 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index 9a0c427..b218f61 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -307,16 +307,8 @@ static bool blk_kick_flush(struct request_queue *q)
 	q->flush_pending_idx ^= 1;
 
 	blk_rq_init(q, q->flush_rq);
-	if (q->mq_ops) {
-		/*
-		 * Reuse the tag value from the fist waiting request,
-		 * with blk-mq the tag is generated during request
-		 * allocation and drivers can rely on it being inside
-		 * the range they asked for.
-		 */
-		q->flush_rq->mq_ctx = first_rq->mq_ctx;
-		q->flush_rq->tag = first_rq->tag;
-	}
+	if (q->mq_ops)
+		blk_mq_clone_flush_request(q->flush_rq, first_rq);
 
 	q->flush_rq->cmd_type = REQ_TYPE_FS;
 	q->flush_rq->cmd_flags = WRITE_FLUSH | REQ_FLUSH_SEQ;
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 871acd6..289b7e5 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -272,6 +272,26 @@ void blk_mq_free_request(struct request *rq)
 	__blk_mq_free_request(hctx, ctx, rq);
 }
 
+/*
+ * Clone all relevant state from a request that has been put on hold in
+ * the flush state machine into the preallocated flush request that hangs
+ * off the request queue.
+ *
+ * For a driver the flush request should be invisible, that's why we are
+ * impersonating the original request here.
+ */
+void blk_mq_clone_flush_request(struct request *flush_rq,
+		struct request *orig_rq)
+{
+	struct blk_mq_hw_ctx *hctx =
+		orig_rq->q->mq_ops->map_queue(orig_rq->q, orig_rq->mq_ctx->cpu);
+
+	flush_rq->mq_ctx = orig_rq->mq_ctx;
+	flush_rq->tag = orig_rq->tag;
+	memcpy(blk_mq_rq_to_pdu(flush_rq), blk_mq_rq_to_pdu(orig_rq),
+		hctx->cmd_size);
+}
+
 bool blk_mq_end_io_partial(struct request *rq, int error, unsigned int nr_bytes)
 {
 	if (blk_update_request(rq, error, nr_bytes))
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 238379a..7964dad 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -27,6 +27,8 @@ void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async);
 void blk_mq_init_flush(struct request_queue *q);
 void blk_mq_drain_queue(struct request_queue *q);
 void blk_mq_free_queue(struct request_queue *q);
+void blk_mq_clone_flush_request(struct request *flush_rq,
+		struct request *orig_rq);
 
 /*
  * CPU hotplug helpers
-- 
1.7.10.4

