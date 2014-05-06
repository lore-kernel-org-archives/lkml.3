Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934738AbaEFKKc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 06:10:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:60062 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934643AbaEFKKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 06:10:30 -0400
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@fb.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] blk-mq: initialize struct request fields individually
Date: Tue,  6 May 2014 12:12:45 +0200
Message-Id: <1399371165-12883-1-git-send-email-hch@lst.de>
X-Mailer: git-send-email 1.7.10.4
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows us to avoid a non-atomic memset over ->atomic_flags as well
as killing lots of duplicate initializations.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c         |   47 +++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/blkdev.h |    7 ++++---
 2 files changed, 49 insertions(+), 5 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index ca51ee4..154f30f 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -82,9 +82,7 @@ static struct request *__blk_mq_alloc_request(struct blk_mq_hw_ctx *hctx,
 	tag = blk_mq_get_tag(hctx->tags, gfp, reserved);
 	if (tag != BLK_MQ_TAG_FAIL) {
 		rq = hctx->tags->rqs[tag];
-		blk_rq_init(hctx->queue, rq);
 		rq->tag = tag;
-
 		return rq;
 	}
 
@@ -187,10 +185,54 @@ static void blk_mq_rq_ctx_init(struct request_queue *q, struct blk_mq_ctx *ctx,
 	if (blk_queue_io_stat(q))
 		rw_flags |= REQ_IO_STAT;
 
+	INIT_LIST_HEAD(&rq->queuelist);
+	/* csd/requeue_work/fifo_time is initialized before use */
+	rq->q = q;
 	rq->mq_ctx = ctx;
 	rq->cmd_flags = rw_flags;
+	rq->cmd_type = 0;
+	/* do not touch atomic flags, it needs atomic ops against the timer */
+	rq->cpu = -1;
+	rq->__data_len = 0;
+	rq->__sector = (sector_t) -1;
+	rq->bio = NULL;
+	rq->biotail = NULL;
+	INIT_HLIST_NODE(&rq->hash);
+	RB_CLEAR_NODE(&rq->rb_node);
+	memset(&rq->flush, 0, max(sizeof(rq->flush), sizeof(rq->elv)));
+	rq->rq_disk = NULL;
+	rq->part = NULL;
 	rq->start_time = jiffies;
+#ifdef CONFIG_BLK_CGROUP
+	rq->rl = NULL;
 	set_start_time_ns(rq);
+	rq->io_start_time_ns = 0;
+#endif
+	rq->nr_phys_segments = 0;
+#if defined(CONFIG_BLK_DEV_INTEGRITY)
+	rq->nr_integrity_segments = 0;
+#endif
+	rq->ioprio = 0;
+	rq->special = NULL;
+	/* tag was already set */
+	rq->errors = 0;
+	memset(rq->__cmd, 0, sizeof(rq->__cmd));
+	rq->cmd = rq->__cmd;
+	rq->cmd_len = BLK_MAX_CDB;
+	
+	rq->extra_len = 0;
+	rq->sense_len = 0;
+	rq->resid_len = 0;
+	rq->sense = NULL;
+
+	rq->deadline = 0;
+	INIT_LIST_HEAD(&rq->timeout_list);
+	rq->timeout = 0;
+	rq->retries = 0;
+	rq->end_io = NULL;
+	rq->end_io_data = NULL;
+	rq->next_rq = NULL;
+
 	ctx->rq_dispatched[rw_is_sync(rw_flags)]++;
 }
 
@@ -258,6 +300,7 @@ static void __blk_mq_free_request(struct blk_mq_hw_ctx *hctx,
 	const int tag = rq->tag;
 	struct request_queue *q = rq->q;
 
+	clear_bit(REQ_ATOM_STARTED, &rq->atomic_flags);
 	blk_mq_put_tag(hctx->tags, tag);
 	blk_mq_queue_exit(q);
 }
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 74ee55f..f342bf6 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -90,9 +90,10 @@ enum rq_cmd_type_bits {
 #define BLK_MAX_CDB	16
 
 /*
- * try to put the fields that are referenced together in the same cacheline.
- * if you modify this structure, be sure to check block/blk-core.c:blk_rq_init()
- * as well!
+ * Try to put the fields that are referenced together in the same cacheline.
+ *
+ * If you modify this structure, make sure to update blk_rq_init() and
+ * especially blk_mq_rq_ctx_init() to take care of the added fields.
  */
 struct request {
 	struct list_head queuelist;
-- 
1.7.10.4

