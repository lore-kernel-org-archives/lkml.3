Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbaCSH5B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 03:57:01 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:59141 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbaCSH47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 03:56:59 -0400
Date: Wed, 19 Mar 2014 00:56:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] blk-mq: add a exit_request method
Message-ID: <20140319075658.GB25529@infradead.org>
References: <20140317131827.793657833@bombadil.infradead.org>
 <20140317131941.477238509@bombadil.infradead.org>
 <CACVXFVNx=s1na1o7cPgjqL2rMcT73gVjmUOYyZdzE3KQ+MZH9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVNx=s1na1o7cPgjqL2rMcT73gVjmUOYyZdzE3KQ+MZH9Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 01:22:07PM +0800, Ming Lei wrote:
> exit_request definition is missed.

oops that accidentally went into another commit.

New version below:

---
From: Christoph Hellwig <hch@infradead.org>
Subject: blk-mq: add a exit_request method

This gives drivers an easy way to free any ressources allocated in
->init_request.

Signed-off-by: Christoph Hellwig <hch@lst.de>

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
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 4d34957..ff194f8 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -68,6 +68,7 @@ typedef int (init_hctx_fn)(struct blk_mq_hw_ctx *, void *, unsigned int);
 typedef void (exit_hctx_fn)(struct blk_mq_hw_ctx *, unsigned int);
 typedef int (init_request_fn)(void *, struct blk_mq_hw_ctx *,
 		struct request *, unsigned int);
+typedef void (exit_request_fn)(struct blk_mq_hw_ctx *, struct request *);
 
 struct blk_mq_ops {
 	/*
@@ -104,8 +105,10 @@ struct blk_mq_ops {
 	/*
 	 * Called for every command allocated by the block layer to allow
 	 * the driver to set up driver specific data.
+	 * Ditto for exit/teardown.
 	 */
 	init_request_fn		*init_request;
+	exit_request_fn		*exit_request;
 };
 
 enum {
