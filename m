Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbaIYPYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 11:24:38 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:53018 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859AbaIYPYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:24:35 -0400
From: Ming Lei <ming.lei@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v5 07/10] block: remove blk_init_flush() and its pair
Date: Thu, 25 Sep 2014 23:23:44 +0800
Message-Id: <1411658627-19754-8-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411658627-19754-1-git-send-email-ming.lei@canonical.com>
References: <1411658627-19754-1-git-send-email-ming.lei@canonical.com>
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
index e2a3f0d4..10555fb 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -704,7 +704,8 @@ blk_init_allocated_queue(struct request_queue *q, request_fn_proc *rfn,
 	if (!q)
 		return NULL;
 
-	if (blk_init_flush(q))
+	q->fq = blk_alloc_flush_queue(q);
+	if (!q->fq)
 		return NULL;
 
 	if (blk_init_rl(&q->root_rl, q, GFP_KERNEL))
@@ -740,7 +741,7 @@ blk_init_allocated_queue(struct request_queue *q, request_fn_proc *rfn,
 	return q;
 
 fail:
-	blk_exit_flush(q);
+	blk_free_flush_queue(q->fq);
 	return NULL;
 }
 EXPORT_SYMBOL(blk_init_allocated_queue);
diff --git a/block/blk-flush.c b/block/blk-flush.c
index b01a86d..d66cbf2 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -479,8 +479,7 @@ int blkdev_issue_flush(struct block_device *bdev, gfp_t gfp_mask,
 }
 EXPORT_SYMBOL(blkdev_issue_flush);
 
-static struct blk_flush_queue *blk_alloc_flush_queue(
-		struct request_queue *q)
+struct blk_flush_queue *blk_alloc_flush_queue(struct request_queue *q)
 {
 	struct blk_flush_queue *fq;
 	int rq_sz = sizeof(struct request);
@@ -511,7 +510,7 @@ static struct blk_flush_queue *blk_alloc_flush_queue(
 	return NULL;
 }
 
-static void blk_free_flush_queue(struct blk_flush_queue *fq)
+void blk_free_flush_queue(struct blk_flush_queue *fq)
 {
 	/* bio based request queue hasn't flush queue */
 	if (!fq)
@@ -520,17 +519,3 @@ static void blk_free_flush_queue(struct blk_flush_queue *fq)
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
index 2b9ab09..64ed7ac 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1862,7 +1862,8 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *set)
 
 	blk_mq_add_queue_tag_set(set, q);
 
-	if (blk_init_flush(q))
+	q->fq = blk_alloc_flush_queue(q);
+	if (!q->fq)
 		goto err_hw_queues;
 
 	blk_mq_map_swqueue(q);
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 9490759..718cffc4c 100644
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
index 833c4ac..9eaa6e9 100644
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

