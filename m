Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab3JYNHv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 09:07:51 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56579 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341Ab3JYNHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 09:07:42 -0400
Message-Id: <20131025130735.440114225@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Fri, 25 Oct 2013 06:05:00 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>, Rusty Russell <rusty@rustcorp.com.au>,
        Asias He <asias@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] blk-mq: add blk_mq_stop_hw_queues
References: <20131025130459.730903511@bombadil.infradead.org>
Content-Disposition: inline; filename=0001-blk-mq-add-blk_mq_stop_hw_queues.patch
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a helper to iterate over all hw queues and stop them.  This is useful
for driver that implement PM suspend functionality.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c         |   12 ++++++++++++
 include/linux/blk-mq.h |    1 +
 2 files changed, 13 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index f21ec96..04050a3 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -679,6 +679,18 @@ void blk_mq_start_hw_queue(struct blk_mq_hw_ctx *hctx)
 }
 EXPORT_SYMBOL(blk_mq_start_hw_queue);
 
+void blk_mq_stop_hw_queues(struct request_queue *q)
+{
+	struct blk_mq_hw_ctx *hctx;
+	int i;
+
+	queue_for_each_hw_ctx(q, hctx, i) {
+		cancel_delayed_work(&hctx->delayed_work);
+		set_bit(BLK_MQ_S_STOPPED, &hctx->state);
+	}
+}
+EXPORT_SYMBOL(blk_mq_stop_hw_queues);
+
 void blk_mq_start_stopped_hw_queues(struct request_queue *q)
 {
 	struct blk_mq_hw_ctx *hctx;
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 746042ff..3368b97 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -136,6 +136,7 @@ void blk_mq_end_io(struct request *rq, int error);
 
 void blk_mq_stop_hw_queue(struct blk_mq_hw_ctx *hctx);
 void blk_mq_start_hw_queue(struct blk_mq_hw_ctx *hctx);
+void blk_mq_stop_hw_queues(struct request_queue *q);
 void blk_mq_start_stopped_hw_queues(struct request_queue *q);
 
 /*
-- 
1.7.10.4


