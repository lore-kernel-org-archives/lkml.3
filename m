Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbaIYPYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 11:24:14 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:55621 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558AbaIYPYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:24:12 -0400
From: Ming Lei <ming.lei@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v5 02/10] blk-mq: allocate flush_rq in blk_mq_init_flush()
Date: Thu, 25 Sep 2014 23:23:39 +0800
Message-Id: <1411658627-19754-3-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411658627-19754-1-git-send-email-ming.lei@canonical.com>
References: <1411658627-19754-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is reasonable to allocate flush req in blk_mq_init_flush().

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 block/blk-flush.c |   11 ++++++++++-
 block/blk-mq.c    |   16 ++++++----------
 block/blk-mq.h    |    2 +-
 3 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index c8e2576..55028a7 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -472,7 +472,16 @@ int blkdev_issue_flush(struct block_device *bdev, gfp_t gfp_mask,
 }
 EXPORT_SYMBOL(blkdev_issue_flush);
 
-void blk_mq_init_flush(struct request_queue *q)
+int blk_mq_init_flush(struct request_queue *q)
 {
+	struct blk_mq_tag_set *set = q->tag_set;
+
 	spin_lock_init(&q->mq_flush_lock);
+
+	q->flush_rq = kzalloc(round_up(sizeof(struct request) +
+				set->cmd_size, cache_line_size()),
+				GFP_KERNEL);
+	if (!q->flush_rq)
+		return -ENOMEM;
+	return 0;
 }
diff --git a/block/blk-mq.c b/block/blk-mq.c
index d8c7f90..80c2cd2 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1849,17 +1849,10 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *set)
 	if (set->ops->complete)
 		blk_queue_softirq_done(q, set->ops->complete);
 
-	blk_mq_init_flush(q);
 	blk_mq_init_cpu_queues(q, set->nr_hw_queues);
 
-	q->flush_rq = kzalloc(round_up(sizeof(struct request) +
-				set->cmd_size, cache_line_size()),
-				GFP_KERNEL);
-	if (!q->flush_rq)
-		goto err_hw;
-
 	if (blk_mq_init_hw_queues(q, set))
-		goto err_flush_rq;
+		goto err_hw;
 
 	mutex_lock(&all_q_mutex);
 	list_add_tail(&q->all_q_node, &all_q_list);
@@ -1867,12 +1860,15 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *set)
 
 	blk_mq_add_queue_tag_set(set, q);
 
+	if (blk_mq_init_flush(q))
+		goto err_hw_queues;
+
 	blk_mq_map_swqueue(q);
 
 	return q;
 
-err_flush_rq:
-	kfree(q->flush_rq);
+err_hw_queues:
+	blk_mq_exit_hw_queues(q, set, set->nr_hw_queues);
 err_hw:
 	blk_cleanup_queue(q);
 err_hctxs:
diff --git a/block/blk-mq.h b/block/blk-mq.h
index a3c613a..ecac69c 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -27,7 +27,7 @@ struct blk_mq_ctx {
 
 void __blk_mq_complete_request(struct request *rq);
 void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async);
-void blk_mq_init_flush(struct request_queue *q);
+int blk_mq_init_flush(struct request_queue *q);
 void blk_mq_freeze_queue(struct request_queue *q);
 void blk_mq_free_queue(struct request_queue *q);
 void blk_mq_clone_flush_request(struct request *flush_rq,
-- 
1.7.9.5

