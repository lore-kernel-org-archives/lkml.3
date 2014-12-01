Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167AbaLAABG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 19:01:06 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:38327 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbaLAABE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 19:01:04 -0500
From: Shaohua Li <shli@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: axboe@fb.com
Subject: [PATCH] blk-mq: move the kdump check to blk_mq_alloc_tag_set
Date: Sun, 30 Nov 2014 16:00:58 -0800
Message-Id: <8bbd9edbdc0c1e8550af9607d3765a44145be5bd.1417391479.git.shli@kernel.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We call blk_mq_alloc_tag_set() first then blk_mq_init_queue(). The requests are
allocated in the former function. So the kdump check should be moved to there
to really save memory.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 block/blk-mq.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 1d016fc..d5b4643 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1784,16 +1784,6 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *set)
 	if (!ctx)
 		return ERR_PTR(-ENOMEM);
 
-	/*
-	 * If a crashdump is active, then we are potentially in a very
-	 * memory constrained environment. Limit us to 1 queue and
-	 * 64 tags to prevent using too much memory.
-	 */
-	if (is_kdump_kernel()) {
-		set->nr_hw_queues = 1;
-		set->queue_depth = min(64U, set->queue_depth);
-	}
-
 	hctxs = kmalloc_node(set->nr_hw_queues * sizeof(*hctxs), GFP_KERNEL,
 			set->numa_node);
 
@@ -2065,6 +2055,16 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
 		set->queue_depth = BLK_MQ_MAX_DEPTH;
 	}
 
+	/*
+	 * If a crashdump is active, then we are potentially in a very
+	 * memory constrained environment. Limit us to 1 queue and
+	 * 64 tags to prevent using too much memory.
+	 */
+	if (is_kdump_kernel()) {
+		set->nr_hw_queues = 1;
+		set->queue_depth = min(64U, set->queue_depth);
+	}
+
 	set->tags = kmalloc_node(set->nr_hw_queues *
 				 sizeof(struct blk_mq_tags *),
 				 GFP_KERNEL, set->numa_node);
-- 
1.8.3.2

