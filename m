Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab3HBOEN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 10:04:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753155Ab3HBOEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 10:04:12 -0400
Date: Fri, 2 Aug 2013 16:05:49 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Mike Christie <michaelc@cs.wisc.edu>, Shaohua Li <shli@fusionio.com>
Subject: [PATCH 2/3] blk-mq: Check queue depth is valid
Message-ID: <2e35d6e384cf368e01d7c174095bfea44f2f0215.1375451955.git.agordeev@redhat.com>
References: <cover.1375451955.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1375451955.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure that depth of a queue is enough to hold at least
reserved tags plus a minimal amount of normal tags. The
minimal amount is chosen to be consistent with minimal
length of tags cache.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 block/blk-mq-tag.c |    8 ++++----
 block/blk-mq-tag.h |    6 ++++++
 block/blk-mq.c     |   12 +++++++-----
 3 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 6718007..fe4acb1 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -447,10 +447,10 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int nr_tags,
 	tags->nr_tags = nr_tags;
 	tags->reserved_tags = reserved_tags;
 	tags->max_cache = nr_tags / num_possible_cpus();
-	if (tags->max_cache < 4)
-		tags->max_cache = 4;
-	else if (tags->max_cache > 64)
-		tags->max_cache = 64;
+	if (tags->max_cache < BLK_MQ_TAG_CACHE_MIN)
+		tags->max_cache = BLK_MQ_TAG_CACHE_MIN;
+	else if (tags->max_cache > BLK_MQ_TAG_CACHE_MAX)
+		tags->max_cache = BLK_MQ_TAG_CACHE_MAX;
 
 	tags->batch_move = tags->max_cache / 2;
 
diff --git a/block/blk-mq-tag.h b/block/blk-mq-tag.h
index ce4d5b2..716ea79 100644
--- a/block/blk-mq-tag.h
+++ b/block/blk-mq-tag.h
@@ -14,7 +14,13 @@ extern bool blk_mq_has_free_tags(struct blk_mq_tags *tags);
 extern ssize_t blk_mq_tag_sysfs_show(struct blk_mq_tags *tags, char *page);
 
 enum {
+	BLK_MQ_TAG_CACHE_MIN	= 4,
+	BLK_MQ_TAG_CACHE_MAX	= 64,
+};
+
+enum {
 	BLK_MQ_TAG_FAIL		= -1U,
+	BLK_MQ_TAG_MIN		= BLK_MQ_TAG_CACHE_MIN,
 	BLK_MQ_TAG_MAX		= BLK_MQ_TAG_FAIL - 1,
 };
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 6fc1df3..a8b4c79 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1151,8 +1151,8 @@ static int blk_mq_init_rq_map(struct blk_mq_hw_ctx *hctx,
 		}
 	}
 
-	if (!i)
-		return -ENOMEM;
+	if (i < (reserved_tags + BLK_MQ_TAG_MIN))
+		goto err_rq_map;
 	else if (i != hctx->queue_depth) {
 		hctx->queue_depth = i;
 		pr_warn("%s: queue depth set to %u because of low memory\n",
@@ -1161,6 +1161,7 @@ static int blk_mq_init_rq_map(struct blk_mq_hw_ctx *hctx,
 
 	hctx->tags = blk_mq_init_tags(hctx->queue_depth, reserved_tags, node);
 	if (!hctx->tags) {
+err_rq_map:
 		blk_mq_free_rq_map(hctx);
 		return -ENOMEM;
 	}
@@ -1305,9 +1306,10 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_reg *reg,
 	struct request_queue *q;
 	int i;
 
-	if (!reg->nr_hw_queues || !reg->ops->queue_rq ||
-	    !reg->ops->map_queue || !reg->ops->alloc_hctx ||
-	    !reg->ops->free_hctx)
+	if (!reg->nr_hw_queues ||
+	    !reg->ops->queue_rq || !reg->ops->map_queue ||
+	    !reg->ops->alloc_hctx || !reg->ops->free_hctx ||
+	    (reg->queue_depth < (reg->reserved_tags + BLK_MQ_TAG_MIN)))
 		return ERR_PTR(-EINVAL);
 
 	if (!reg->queue_depth)
-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
