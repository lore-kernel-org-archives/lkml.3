Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbaIMDI1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 23:08:27 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:41875 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbaIMDIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 23:08:23 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v3 06/10] block: remove blk_init_flush() and its pair
Date: Sat, 13 Sep 2014 11:07:50 +0800
Message-Id: <1410577674-17019-7-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410577674-17019-1-git-send-email-ming.lei@canonical.com>
References: <1410577674-17019-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now mission of the two helpers is over, and just call
blk_alloc_flush_queue() and blk_free_flush_queue() directly.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 block/blk-core.c  |    5 +++--
 block/blk-flush.c |   19 ++-----------------
 block/blk-mq.c    |    3 ++-
 block/blk-sysfs.c |    2 +-
 block/blk.h       |    4 ++--
 5 files changed, 10 insertions(+), 23 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index d278a30..e55a8eb 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -703,7 +703,8 @@ blk_init_allocated_queue(struct request_queue *q, request_fn_proc *rfn,
 	if (!q)
 		return NULL;
 
-	if (blk_init_flush(q))
+	q->fq = blk_alloc_flush_queue(q);
+	if (!q->fq)
 		return NULL;
 
 	if (blk_init_rl(&q->root_rl, q, GFP_KERNEL))
@@ -739,7 +740,7 @@ blk_init_allocated_queue(struct request_queue *q, request_fn_proc *rfn,
 	return q;
 
 fail:
-	blk_exit_flush(q);
+	blk_free_flush_queue(q->fq);
 	return NULL;
 }
 EXPORT_SYMBOL(blk_init_allocated_queue);
diff --git a/block/blk-flush.c b/block/blk-flush.c
index db269d4..a464b18 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -481,8 +481,7 @@ int blkdev_issue_flush(struct block_device *bdev, gfp_t gfp_mask,
 }
 EXPORT_SYMBOL(blkdev_issue_flush);
 
-static struct blk_flush_queue *blk_alloc_flush_queue(
-		struct request_queue *q)
+struct blk_flush_queue *blk_alloc_flush_queue(struct request_queue *q)
 {
 	struct blk_flush_queue *fq;
 	int rq_sz = sizeof(struct request);
@@ -513,22 +512,8 @@ static struct blk_flush_queue *blk_alloc_flush_queue(
 	return NULL;
 }
 
-static void blk_free_flush_queue(struct blk_flush_queue *fq)
+void blk_free_flush_queue(struct blk_flush_queue *fq)
 {
 	kfree(fq->flush_rq);
 	kfree(fq);
 }
-
-int blk_init_flush(struct request_queue *q)
-{
-	q->fq = blk_alloc_flush_queue(q);
-	if (!q->fq)
-		return -ENOMEM;
-
-	return 0;
-}
-
-void blk_exit_flush(struct request_queue *q)
-{
-	blk_free_flush_queue(q->fq);
-}
diff --git a/block/blk-mq.c b/block/blk-mq.c
index a819af4..beea082 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1844,7 +1844,8 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *set)
 
 	blk_mq_add_queue_tag_set(set, q);
 
-	if (blk_init_flush(q))
+	q->fq = blk_alloc_flush_queue(q);
+	if (!q->fq)
 		goto err_hw_queues;
 
 	blk_mq_map_swqueue(q);
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 28d3a11..571cd34 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -517,7 +517,7 @@ static void blk_release_queue(struct kobject *kobj)
 	if (q->queue_tags)
 		__blk_queue_free_tags(q);
 
-	blk_exit_flush(q);
+	blk_free_flush_queue(q->fq);
 
 	if (q->mq_ops)
 		blk_mq_free_queue(q);
diff --git a/block/blk.h b/block/blk.h
index 2637349..d514e3c 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -39,8 +39,8 @@ static inline void __blk_get_queue(struct request_queue *q)
 	kobject_get(&q->kobj);
 }
 
-int blk_init_flush(struct request_queue *q);
-void blk_exit_flush(struct request_queue *q);
+struct blk_flush_queue *blk_alloc_flush_queue(struct request_queue *q);
+void blk_free_flush_queue(struct blk_flush_queue *fq);
 
 int blk_init_rl(struct request_list *rl, struct request_queue *q,
 		gfp_t gfp_mask);
-- 
1.7.9.5

