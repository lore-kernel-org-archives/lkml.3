Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbaIONLa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 09:11:30 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:58142 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbaIONL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 09:11:28 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v4 02/10] block: introduce blk_init_flush and its pair
Date: Mon, 15 Sep 2014 21:11:06 +0800
Message-Id: <1410786675-7761-3-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410786675-7761-1-git-send-email-ming.lei@canonical.com>
References: <1410786675-7761-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two temporary functions are introduced for holding flush
initialization and de-initialization, so that we can
introduce 'flush queue' easier in the following patch. And
once 'flush queue' and its allocation/free functions are ready,
they will be removed for sake of code readability.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 block/blk-core.c  |    5 ++---
 block/blk-flush.c |   19 ++++++++++++++++++-
 block/blk-mq.c    |    2 +-
 block/blk-mq.h    |    1 -
 block/blk-sysfs.c |    4 ++--
 block/blk.h       |    3 +++
 6 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 6946a42..0a9d172 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -705,8 +705,7 @@ blk_init_allocated_queue(struct request_queue *q, request_fn_proc *rfn,
 	if (!q)
 		return NULL;
 
-	q->flush_rq = kzalloc(sizeof(struct request), GFP_KERNEL);
-	if (!q->flush_rq)
+	if (blk_init_flush(q))
 		return NULL;
 
 	if (blk_init_rl(&q->root_rl, q, GFP_KERNEL))
@@ -742,7 +741,7 @@ blk_init_allocated_queue(struct request_queue *q, request_fn_proc *rfn,
 	return q;
 
 fail:
-	kfree(q->flush_rq);
+	blk_exit_flush(q);
 	return NULL;
 }
 EXPORT_SYMBOL(blk_init_allocated_queue);
diff --git a/block/blk-flush.c b/block/blk-flush.c
index 75ca6cd0..6932ee8 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -474,7 +474,7 @@ int blkdev_issue_flush(struct block_device *bdev, gfp_t gfp_mask,
 }
 EXPORT_SYMBOL(blkdev_issue_flush);
 
-int blk_mq_init_flush(struct request_queue *q)
+static int blk_mq_init_flush(struct request_queue *q)
 {
 	struct blk_mq_tag_set *set = q->tag_set;
 
@@ -487,3 +487,20 @@ int blk_mq_init_flush(struct request_queue *q)
 		return -ENOMEM;
 	return 0;
 }
+
+int blk_init_flush(struct request_queue *q)
+{
+	if (q->mq_ops)
+		return blk_mq_init_flush(q);
+
+	q->flush_rq = kzalloc(sizeof(struct request), GFP_KERNEL);
+	if (!q->flush_rq)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void blk_exit_flush(struct request_queue *q)
+{
+	kfree(q->flush_rq);
+}
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 3b79ee7..467b1d8 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1842,7 +1842,7 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *set)
 
 	blk_mq_add_queue_tag_set(set, q);
 
-	if (blk_mq_init_flush(q))
+	if (blk_init_flush(q))
 		goto err_hw_queues;
 
 	blk_mq_map_swqueue(q);
diff --git a/block/blk-mq.h b/block/blk-mq.h
index b0bd9bc..a39cfa9 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -27,7 +27,6 @@ struct blk_mq_ctx {
 
 void __blk_mq_complete_request(struct request *rq);
 void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async);
-int blk_mq_init_flush(struct request_queue *q);
 void blk_mq_freeze_queue(struct request_queue *q);
 void blk_mq_free_queue(struct request_queue *q);
 void blk_mq_clone_flush_request(struct request *flush_rq,
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 4db5abf..28d3a11 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -517,11 +517,11 @@ static void blk_release_queue(struct kobject *kobj)
 	if (q->queue_tags)
 		__blk_queue_free_tags(q);
 
+	blk_exit_flush(q);
+
 	if (q->mq_ops)
 		blk_mq_free_queue(q);
 
-	kfree(q->flush_rq);
-
 	blk_trace_shutdown(q);
 
 	bdi_destroy(&q->backing_dev_info);
diff --git a/block/blk.h b/block/blk.h
index 6748c4f..261f734 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -22,6 +22,9 @@ static inline void __blk_get_queue(struct request_queue *q)
 	kobject_get(&q->kobj);
 }
 
+int blk_init_flush(struct request_queue *q);
+void blk_exit_flush(struct request_queue *q);
+
 int blk_init_rl(struct request_list *rl, struct request_queue *q,
 		gfp_t gfp_mask);
 void blk_exit_rl(struct request_list *rl);
-- 
1.7.9.5

