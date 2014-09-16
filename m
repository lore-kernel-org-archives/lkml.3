Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638AbaIPVlx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 17:41:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:55285 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998AbaIPVlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 17:41:51 -0400
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Robert Elliott <elliott@hp.com>, Ming Lei <ming.lei@canonical.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH] blk-mq: avoid infite recursion with the FUA
Date: Tue, 16 Sep 2014 14:44:07 -0700
Message-Id: <1410903847-18519-1-git-send-email-hch@lst.de>
X-Mailer: git-send-email 1.9.1
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should not insert requests into the flush state machine from
blk_mq_insert_request.  All incoming flush requests come through
blk_{m,s}q_make_request and are handled there, while blk_execute_rq_nowait
should only be called for BLOCK_PC requests.  All other callers
deal with requests that already went through the flush statemchine
and shouldn't be reinserted into it.

Reported-by: Robert Elliott  <Elliott@hp.com>
Debugged-by: Ming Lei <ming.lei@canonical.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-exec.c |  1 +
 block/blk-mq.c   | 11 +++--------
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/block/blk-exec.c b/block/blk-exec.c
index f4d27b1..9924725 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -56,6 +56,7 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 	bool is_pm_resume;
 
 	WARN_ON(irqs_disabled());
+	WARN_ON(rq->cmd_type == REQ_TYPE_FS);
 
 	rq->rq_disk = bd_disk;
 	rq->end_io = done;
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 383ea0c..7373949 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -957,14 +957,9 @@ void blk_mq_insert_request(struct request *rq, bool at_head, bool run_queue,
 
 	hctx = q->mq_ops->map_queue(q, ctx->cpu);
 
-	if (rq->cmd_flags & (REQ_FLUSH | REQ_FUA) &&
-	    !(rq->cmd_flags & (REQ_FLUSH_SEQ))) {
-		blk_insert_flush(rq);
-	} else {
-		spin_lock(&ctx->lock);
-		__blk_mq_insert_request(hctx, rq, at_head);
-		spin_unlock(&ctx->lock);
-	}
+	spin_lock(&ctx->lock);
+	__blk_mq_insert_request(hctx, rq, at_head);
+	spin_unlock(&ctx->lock);
 
 	if (run_queue)
 		blk_mq_run_hw_queue(hctx, async);
-- 
1.9.1

