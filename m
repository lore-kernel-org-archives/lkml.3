Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933345AbaCQNlG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 09:41:06 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51808 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933253AbaCQNbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 09:31:35 -0400
Message-Id: <20140317133134.969559353@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 17 Mar 2014 06:27:57 -0700
From: Christoph Hellwig <hch@infradead.org>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 24/39] blk-mq: add blk_mq_requeue_request
References: <20140317132733.789623766@bombadil.infradead.org>
Content-Disposition: inline; filename=0024-blk-mq-add-blk_mq_requeue_request.patch
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows to requeue a request that has been accepted by ->queue_rq
earlier.  This is needed by the SCSI layer in various error conditions.

The existing internal blk_mq_requeue_request is renamed to
__blk_mq_requeue_request as it is a lower level building block for this
funtionality.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c         |   18 ++++++++++++++++--
 include/linux/blk-mq.h |    2 ++
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index c7e723e..9e13761 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -380,7 +380,7 @@ static void blk_mq_start_request(struct request *rq, bool last)
 		rq->cmd_flags |= REQ_END;
 }
 
-static void blk_mq_requeue_request(struct request *rq)
+static void __blk_mq_requeue_request(struct request *rq)
 {
 	struct request_queue *q = rq->q;
 
@@ -393,6 +393,20 @@ static void blk_mq_requeue_request(struct request *rq)
 		rq->nr_phys_segments--;
 }
 
+/* XXX: misnamed, only unpreps but leaves the actual requeue to the caller. */
+void blk_mq_requeue_request(struct request *rq)
+{
+	struct request_queue *q = rq->q;
+
+	__blk_mq_requeue_request(rq);
+	blk_clear_rq_complete(rq);
+
+	trace_block_rq_requeue(q, rq);
+
+	BUG_ON(blk_queued_rq(rq));
+}
+EXPORT_SYMBOL(blk_mq_requeue_request);
+
 struct blk_mq_timeout_data {
 	struct blk_mq_hw_ctx *hctx;
 	unsigned long *next;
@@ -573,7 +587,7 @@ static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
 			 * time
 			 */
 			list_add(&rq->queuelist, &rq_list);
-			blk_mq_requeue_request(rq);
+			__blk_mq_requeue_request(rq);
 			break;
 		default:
 			pr_err("blk-mq: bad return on queue: %d\n", ret);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index cac10e1..6325a24 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -148,6 +148,8 @@ static inline void blk_mq_end_io(struct request *rq, int error)
 	BUG_ON(!done);
 }
 
+void blk_mq_requeue_request(struct request *rq);
+
 void blk_mq_complete_request(struct request *rq);
 
 void blk_mq_stop_hw_queue(struct blk_mq_hw_ctx *hctx);
-- 
1.7.10.4


