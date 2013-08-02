Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab3HBOEm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 10:04:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752454Ab3HBOEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 10:04:41 -0400
Date: Fri, 2 Aug 2013 16:06:15 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Mike Christie <michaelc@cs.wisc.edu>, Shaohua Li <shli@fusionio.com>
Subject: [PATCH 3/3] blk-mq: Do not allocate more cache entries than used
Message-ID: <fd2a18f55f67c39592dd7fda131395cc280f0025.1375451955.git.agordeev@redhat.com>
References: <cover.1375451955.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1375451955.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 block/blk-mq-tag.c |   29 ++++++++++++++++-------------
 1 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index fe4acb1..e74e18e 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -411,13 +411,14 @@ static void blk_mq_tag_notify(void *data, unsigned long action,
 	}
 }
 
-struct blk_mq_tags *blk_mq_init_tags(unsigned int nr_tags,
+struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
 				     unsigned int reserved_tags, int node)
 {
+	unsigned int nr_tags, nr_cache;
 	struct blk_mq_tags *tags;
 	size_t map_size;
 
-	if (nr_tags > BLK_MQ_TAG_MAX) {
+	if (total_tags > BLK_MQ_TAG_MAX) {
 		pr_err("blk-mq: tag depth too large\n");
 		return NULL;
 	}
@@ -426,7 +427,15 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int nr_tags,
 	if (!tags)
 		return NULL;
 
-	map_size = sizeof(struct blk_mq_tag_map) + nr_tags * sizeof(int);
+	nr_tags = total_tags - reserved_tags;
+	nr_cache = nr_tags / num_possible_cpus();
+
+	if (nr_cache < BLK_MQ_TAG_CACHE_MIN)
+		nr_cache = BLK_MQ_TAG_CACHE_MIN;
+	else if (nr_cache > BLK_MQ_TAG_CACHE_MAX)
+		nr_cache = BLK_MQ_TAG_CACHE_MAX;
+
+	map_size = sizeof(struct blk_mq_tag_map) + nr_cache * sizeof(int);
 	tags->free_maps = __alloc_percpu(map_size, sizeof(void *));
 	if (!tags->free_maps)
 		goto err_free_maps;
@@ -444,15 +453,10 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int nr_tags,
 
 	spin_lock_init(&tags->lock);
 	INIT_LIST_HEAD(&tags->wait);
-	tags->nr_tags = nr_tags;
+	tags->nr_tags = total_tags;
 	tags->reserved_tags = reserved_tags;
-	tags->max_cache = nr_tags / num_possible_cpus();
-	if (tags->max_cache < BLK_MQ_TAG_CACHE_MIN)
-		tags->max_cache = BLK_MQ_TAG_CACHE_MIN;
-	else if (tags->max_cache > BLK_MQ_TAG_CACHE_MAX)
-		tags->max_cache = BLK_MQ_TAG_CACHE_MAX;
-
-	tags->batch_move = tags->max_cache / 2;
+	tags->max_cache = nr_cache;
+	tags->batch_move = nr_cache / 2;
 
 	/*
 	 * Reserved tags are first
@@ -470,10 +474,9 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int nr_tags,
 	 * Rest of the tags start at the queue list
 	 */
 	tags->nr_free = 0;
-	while (nr_tags - tags->nr_reserved) {
+	while (nr_tags--) {
 		tags->freelist[tags->nr_free] = tags->nr_free +
 							tags->nr_reserved;
-		nr_tags--;
 		tags->nr_free++;
 	}
 
-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
