Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932936AbaCQNUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 09:20:46 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51714 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756489AbaCQNTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 09:19:41 -0400
Message-Id: <20140317131941.477238509@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 17 Mar 2014 06:18:31 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] blk-mq: add a exit_request method
References: <20140317131827.793657833@bombadil.infradead.org>
Content-Disposition: inline; filename=0004-blk-mq-add-a-exit_request-method.patch
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This gives drivers an easy way to free any resources allocated in
->init_request.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index c2ce99b..c7e723e 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1000,6 +1000,16 @@ static void blk_mq_free_rq_map(struct blk_mq_hw_ctx *hctx)
 {
 	struct page *page;
 
+	if (hctx->rqs && hctx->queue->mq_ops->exit_request) {
+		int i;
+
+		for (i = 0; i < hctx->queue_depth; i++) {
+			if (!hctx->rqs[i])
+				continue;
+			hctx->queue->mq_ops->exit_request(hctx, hctx->rqs[i]);
+		}
+	}
+
 	while (!list_empty(&hctx->page_list)) {
 		page = list_first_entry(&hctx->page_list, struct page, lru);
 		list_del_init(&page->lru);
@@ -1332,7 +1342,7 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_reg *reg,
 	}
 
 	if (blk_mq_init_hw_queues(q, reg, driver_data))
-		goto err_flush_rq;
+		goto err_flush_rq_init;
 
 	blk_mq_map_swqueue(q);
 
@@ -1342,6 +1352,9 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_reg *reg,
 
 	return q;
 
+err_flush_rq_init:
+	if (reg->ops->exit_request)
+		reg->ops->exit_request(NULL, q->flush_rq);
 err_flush_rq:
 	kfree(q->flush_rq);
 err_hw:
@@ -1387,6 +1400,9 @@ void blk_mq_free_queue(struct request_queue *q)
 	mutex_lock(&all_q_mutex);
 	list_del_init(&q->all_q_node);
 	mutex_unlock(&all_q_mutex);
+
+	if (q->mq_ops->exit_request)
+		q->mq_ops->exit_request(NULL, q->flush_rq);
 }
 
 /* Basically redo blk_mq_init_queue with queue frozen */
-- 
1.7.10.4


