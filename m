Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933370AbaCQNbl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 09:31:41 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51775 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933136AbaCQNbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 09:31:32 -0400
Message-Id: <20140317133131.660186818@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 17 Mar 2014 06:27:35 -0700
From: Christoph Hellwig <hch@infradead.org>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mike Snitzer <msnitzer@redhat.com>, Jens Axboe <axboe@fb.com>
Subject: [PATCH 02/39] block: change flush sequence list addition back to front add
References: <20140317132733.789623766@bombadil.infradead.org>
Content-Disposition: inline; filename=0002-block-change-flush-sequence-list-addition-back-to-fr.patch
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 18741986 inadvertently changed the rq flush insertion
from a head to a tail insertion. Fix that back up.

Signed-off-by: Mike Snitzer <msnitzer@redhat.com>
Signed-off-by: Jens Axboe <axboe@fb.com>
---
 block/blk-flush.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index f598f79..43e6b47 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -140,14 +140,17 @@ static void mq_flush_run(struct work_struct *work)
 	blk_mq_insert_request(rq, false, true, false);
 }
 
-static bool blk_flush_queue_rq(struct request *rq)
+static bool blk_flush_queue_rq(struct request *rq, bool add_front)
 {
 	if (rq->q->mq_ops) {
 		INIT_WORK(&rq->mq_flush_work, mq_flush_run);
 		kblockd_schedule_work(rq->q, &rq->mq_flush_work);
 		return false;
 	} else {
-		list_add_tail(&rq->queuelist, &rq->q->queue_head);
+		if (add_front)
+			list_add(&rq->queuelist, &rq->q->queue_head);
+		else
+			list_add_tail(&rq->queuelist, &rq->q->queue_head);
 		return true;
 	}
 }
@@ -193,7 +196,7 @@ static bool blk_flush_complete_seq(struct request *rq, unsigned int seq,
 
 	case REQ_FSEQ_DATA:
 		list_move_tail(&rq->flush.list, &q->flush_data_in_flight);
-		queued = blk_flush_queue_rq(rq);
+		queued = blk_flush_queue_rq(rq, true);
 		break;
 
 	case REQ_FSEQ_DONE:
@@ -326,7 +329,7 @@ static bool blk_kick_flush(struct request_queue *q)
 	q->flush_rq->rq_disk = first_rq->rq_disk;
 	q->flush_rq->end_io = flush_end_io;
 
-	return blk_flush_queue_rq(q->flush_rq);
+	return blk_flush_queue_rq(q->flush_rq, false);
 }
 
 static void flush_data_end_io(struct request *rq, int error)
-- 
1.7.10.4


