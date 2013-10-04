Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab3JDNu3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 09:50:29 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53082 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554Ab3JDNuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 09:50:22 -0400
Message-Id: <20131004135014.907030381@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Fri, 04 Oct 2013 06:49:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] [PATCH 4/5] block: make blk_get/put_request work for blk-mq drivers
References: <20131004134908.231874670@bombadil.infradead.org>
Content-Disposition: inline; filename=0004-block-make-blk_get-put_request-work-for-blk-mq-drive.patch
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consumers of the block layer shouldn't have to care if a driver uses
blk-mq or not, so make blk_get/put_request call the mq equivalents
underneath.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c                  |   31 ++++++++++++++++++++-----------
 block/blk-mq.c                    |    1 -
 drivers/block/mtip32xx/mtip32xx.c |    2 +-
 3 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 5620e58..6d7fd79 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1080,7 +1080,8 @@ retry:
 	goto retry;
 }
 
-struct request *blk_get_request(struct request_queue *q, int rw, gfp_t gfp_mask)
+static struct request *blk_old_get_request(struct request_queue *q, int rw,
+		gfp_t gfp_mask)
 {
 	struct request *rq;
 
@@ -1097,6 +1098,14 @@ struct request *blk_get_request(struct request_queue *q, int rw, gfp_t gfp_mask)
 
 	return rq;
 }
+
+struct request *blk_get_request(struct request_queue *q, int rw, gfp_t gfp_mask)
+{
+	if (q->mq_ops)
+		return blk_mq_alloc_request(q, rw, gfp_mask);
+	else
+		return blk_old_get_request(q, rw, gfp_mask);
+}
 EXPORT_SYMBOL(blk_get_request);
 
 /**
@@ -1133,12 +1142,7 @@ EXPORT_SYMBOL(blk_get_request);
 struct request *blk_make_request(struct request_queue *q, struct bio *bio,
 				 gfp_t gfp_mask)
 {
-	struct request *rq;
-
-	if (q->mq_ops)
-		rq = blk_mq_alloc_request(q, bio_data_dir(bio), gfp_mask);
-	else
-		rq = blk_get_request(q, bio_data_dir(bio), gfp_mask);
+	struct request *rq = blk_get_request(q, bio_data_dir(bio), gfp_mask);
 
 	if (unlikely(!rq))
 		return ERR_PTR(-ENOMEM);
@@ -1276,12 +1280,17 @@ EXPORT_SYMBOL_GPL(__blk_put_request);
 
 void blk_put_request(struct request *req)
 {
-	unsigned long flags;
 	struct request_queue *q = req->q;
 
-	spin_lock_irqsave(q->queue_lock, flags);
-	__blk_put_request(q, req);
-	spin_unlock_irqrestore(q->queue_lock, flags);
+	if (q->mq_ops)
+		blk_mq_free_request(req);
+	else {
+		unsigned long flags;
+
+		spin_lock_irqsave(q->queue_lock, flags);
+		__blk_put_request(q, req);
+		spin_unlock_irqrestore(q->queue_lock, flags);
+	}
 }
 EXPORT_SYMBOL(blk_put_request);
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 423089d..709747f 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -268,7 +268,6 @@ void blk_mq_free_request(struct request *rq)
 	hctx = q->mq_ops->map_queue(q, ctx->cpu);
 	__blk_mq_free_request(hctx, ctx, rq);
 }
-EXPORT_SYMBOL(blk_mq_free_request);
 
 void blk_mq_finish_request(struct request *rq, int error)
 {
diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 4427178..3c4c668 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -158,7 +158,7 @@ static struct mtip_cmd *mtip_get_int_command(struct driver_data *dd)
 
 static void mtip_put_int_command(struct driver_data *dd, struct mtip_cmd *cmd)
 {
-	blk_mq_free_request(blk_mq_rq_from_pdu(cmd));
+	blk_put_request(blk_mq_rq_from_pdu(cmd));
 }
 
 /*
-- 
1.7.10.4


