Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbaE0OVE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 10:21:04 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:41389 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbaE0OVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 10:21:00 -0400
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 3/3] block: only allocate/free mq_usage_counter in blk-mq
Date: Tue, 27 May 2014 22:20:14 +0800
Message-Id: <1401200414-10823-4-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401200414-10823-1-git-send-email-tom.leiming@gmail.com>
References: <1401200414-10823-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The percpu counter is only used for blk-mq, so move
its allocation and free inside blk-mq, and don't
allocate it for legacy queue device.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 block/blk-core.c  |    7 +------
 block/blk-mq.c    |    5 +++++
 block/blk-sysfs.c |    2 --
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 5b6f768..29d5fba 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -576,12 +576,9 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 	if (!q)
 		return NULL;
 
-	if (percpu_counter_init(&q->mq_usage_counter, 0))
-		goto fail_q;
-
 	q->id = ida_simple_get(&blk_queue_ida, 0, 0, gfp_mask);
 	if (q->id < 0)
-		goto fail_c;
+		goto fail_q;
 
 	q->backing_dev_info.ra_pages =
 			(VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
@@ -639,8 +636,6 @@ fail_bdi:
 	bdi_destroy(&q->backing_dev_info);
 fail_id:
 	ida_simple_remove(&blk_queue_ida, q->id);
-fail_c:
-	percpu_counter_destroy(&q->mq_usage_counter);
 fail_q:
 	kmem_cache_free(blk_requestq_cachep, q);
 	return NULL;
diff --git a/block/blk-mq.c b/block/blk-mq.c
index e32c04c..d80cb89 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1777,6 +1777,9 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *set)
 	if (!q)
 		goto err_hctxs;
 
+	if (percpu_counter_init(&q->mq_usage_counter, 0))
+		goto err_map;
+
 	q->mq_map = blk_mq_make_queue_map(set);
 	if (!q->mq_map)
 		goto err_map;
@@ -1863,6 +1866,8 @@ void blk_mq_free_queue(struct request_queue *q)
 	blk_mq_exit_hw_queues(q, set, set->nr_hw_queues);
 	blk_mq_free_hw_queues(q, set);
 
+	percpu_counter_destroy(&q->mq_usage_counter);
+
 	free_percpu(q->queue_ctx);
 	kfree(q->queue_hw_ctx);
 	kfree(q->mq_map);
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 4d6811a..23321fb 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -517,8 +517,6 @@ static void blk_release_queue(struct kobject *kobj)
 	if (q->queue_tags)
 		__blk_queue_free_tags(q);
 
-	percpu_counter_destroy(&q->mq_usage_counter);
-
 	if (q->mq_ops)
 		blk_mq_free_queue(q);
 
-- 
1.7.9.5

