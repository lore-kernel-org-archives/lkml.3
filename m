Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbaBKQ1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:27:42 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:50768 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbaBKQ1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:27:40 -0500
Message-Id: <20140211162739.722024789@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Tue, 11 Feb 2014 08:27:14 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] blk-mq: pair blk_mq_start_request / blk_mq_requeue_request
References: <20140211162712.055066190@bombadil.infradead.org>
Content-Disposition: inline; filename=0002-blk-mq-pair-blk_mq_start_request-blk_mq_requeue_requ.patch
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure we have a proper pairing between starting and requeueing
requests.  Move the dma drain and REQ_END setup into blk_mq_start_request,
and make sure blk_mq_requeue_request properly undoes them, giving us
a pair of function to prepare and unprepare a request without leaving
side effects.

Together this ensures we always clean up properly after
BLK_MQ_RQ_QUEUE_BUSY returns from ->queue_rq.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c |   49 ++++++++++++++++++++++++++-----------------------
 1 file changed, 26 insertions(+), 23 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 0480710..1fa9dd1 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -377,7 +377,7 @@ void blk_mq_complete_request(struct request *rq)
 }
 EXPORT_SYMBOL(blk_mq_complete_request);
 
-static void blk_mq_start_request(struct request *rq)
+static void blk_mq_start_request(struct request *rq, bool last)
 {
 	struct request_queue *q = rq->q;
 
@@ -390,6 +390,25 @@ static void blk_mq_start_request(struct request *rq)
 	 */
 	rq->deadline = jiffies + q->rq_timeout;
 	set_bit(REQ_ATOM_STARTED, &rq->atomic_flags);
+
+	if (q->dma_drain_size && blk_rq_bytes(rq)) {
+		/*
+		 * Make sure space for the drain appears.  We know we can do
+		 * this because max_hw_segments has been adjusted to be one
+		 * fewer than the device can handle.
+		 */
+		rq->nr_phys_segments++;
+	}
+
+	/*
+	 * Flag the last request in the series so that drivers know when IO
+	 * should be kicked off, if they don't do it on a per-request basis.
+	 *
+	 * Note: the flag isn't the only condition drivers should do kick off.
+	 * If drive is busy, the last request might not have the bit set.
+	 */
+	if (last)
+		rq->cmd_flags |= REQ_END;
 }
 
 static void blk_mq_requeue_request(struct request *rq)
@@ -398,6 +417,11 @@ static void blk_mq_requeue_request(struct request *rq)
 
 	trace_block_rq_requeue(q, rq);
 	clear_bit(REQ_ATOM_STARTED, &rq->atomic_flags);
+
+	rq->cmd_flags &= ~REQ_END;
+
+	if (q->dma_drain_size && blk_rq_bytes(rq))
+		rq->nr_phys_segments--;
 }
 
 struct blk_mq_timeout_data {
@@ -565,29 +589,8 @@ static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
 
 		rq = list_first_entry(&rq_list, struct request, queuelist);
 		list_del_init(&rq->queuelist);
-		blk_mq_start_request(rq);
 
-		if (q->dma_drain_size && blk_rq_bytes(rq)) {
-			/*
-			 * make sure space for the drain appears we
-			 * know we can do this because max_hw_segments
-			 * has been adjusted to be one fewer than the
-			 * device can handle
-			 */
-			rq->nr_phys_segments++;
-		}
-
-		/*
-		 * Last request in the series. Flag it as such, this
-		 * enables drivers to know when IO should be kicked off,
-		 * if they don't do it on a per-request basis.
-		 *
-		 * Note: the flag isn't the only condition drivers
-		 * should do kick off. If drive is busy, the last
-		 * request might not have the bit set.
-		 */
-		if (list_empty(&rq_list))
-			rq->cmd_flags |= REQ_END;
+		blk_mq_start_request(rq, list_empty(&rq_list));
 
 		ret = q->mq_ops->queue_rq(hctx, rq);
 		switch (ret) {
-- 
1.7.10.4


