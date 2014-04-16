Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbaDPHmx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 03:42:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:56264 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802AbaDPHmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 03:42:51 -0400
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 2/8] blk-mq: bidi support
Date: Wed, 16 Apr 2014 09:44:53 +0200
Message-Id: <1397634299-7466-3-git-send-email-hch@lst.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1397634299-7466-1-git-send-email-hch@lst.de>
References: <1397634299-7466-1-git-send-email-hch@lst.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add two unlinkely branches to make sure the resid is initialized correctly
for bidi request pairs, and the second request gets properly freed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c |    9 +++++++--
 block/bsg.c    |    2 +-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index e921085..afdab13 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -298,10 +298,13 @@ inline void __blk_mq_end_io(struct request *rq, int error)
 {
 	blk_account_io_done(rq);
 
-	if (rq->end_io)
+	if (rq->end_io) {
 		rq->end_io(rq, error);
-	else
+	} else {
+		if (unlikely(blk_bidi_rq(rq)))
+			blk_mq_free_request(rq->next_rq);
 		blk_mq_free_request(rq);
+	}
 }
 EXPORT_SYMBOL(__blk_mq_end_io);
 
@@ -366,6 +369,8 @@ static void blk_mq_start_request(struct request *rq, bool last)
 	trace_block_rq_issue(q, rq);
 
 	rq->resid_len = blk_rq_bytes(rq);
+	if (unlikely(blk_bidi_rq(rq)))
+		rq->next_rq->resid_len = blk_rq_bytes(rq->next_rq);
 
 	/*
 	 * Just mark start time and set the started bit. Due to memory
diff --git a/block/bsg.c b/block/bsg.c
index 420a5a9..2956086 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -1008,7 +1008,7 @@ int bsg_register_queue(struct request_queue *q, struct device *parent,
 	/*
 	 * we need a proper transport to send commands, not a stacked device
 	 */
-	if (!q->request_fn)
+	if (!q->request_fn && !q->mq_ops)
 		return 0;
 
 	bcd = &q->bsg_dev;
-- 
1.7.10.4

