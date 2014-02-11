Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbaBKQ1a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:27:30 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:50754 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbaBKQ1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:27:05 -0500
Message-Id: <20140211162704.842299822@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Tue, 11 Feb 2014 08:26:30 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] blk-mq: handle dma_drain_size
References: <20140211162627.319192015@bombadil.infradead.org>
Content-Disposition: inline; filename=0003-blk-mq-handle-dma_drain_size.patch
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make blk-mq handle the dma_drain_size field the same way as the old request
path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 40fc4dd..35800e1 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -561,6 +561,16 @@ static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
 		list_del_init(&rq->queuelist);
 		blk_mq_start_request(rq);
 
+		if (q->dma_drain_size && blk_rq_bytes(rq)) {
+			/*
+			 * make sure space for the drain appears we
+			 * know we can do this because max_hw_segments
+			 * has been adjusted to be one fewer than the
+			 * device can handle
+			 */
+			rq->nr_phys_segments++;
+		}
+
 		/*
 		 * Last request in the series. Flag it as such, this
 		 * enables drivers to know when IO should be kicked off,
-- 
1.7.10.4


