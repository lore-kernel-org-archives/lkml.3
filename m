Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761110AbaCUQwv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 12:52:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:43944 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760463AbaCUQwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 12:52:47 -0400
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@fb.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] blk-mq: add ->init_request and ->exit_request methods
Date: Fri, 21 Mar 2014 17:31:00 +0100
Message-Id: <1395419460-28229-4-git-send-email-hch@lst.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1395419460-28229-1-git-send-email-hch@lst.de>
References: <1395419460-28229-1-git-send-email-hch@lst.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Besides a simpler and cleared interface this also allows to initialize the
flush_rq properly.  The interface for that is still a bit messy as we don't
have a hw_ctx available for the flush request, but that's something that
should be fixable with a little work once the demand arises.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c             |  119 +++++++++++++++++---------------------------
 drivers/block/virtio_blk.c |   23 ++++-----
 include/linux/blk-mq.h     |   16 +++++-
 3 files changed, 72 insertions(+), 86 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 4274ee0..762095f 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -996,75 +996,20 @@ static void blk_mq_hctx_notify(void *data, unsigned long action,
 	blk_mq_put_ctx(ctx);
 }
 
-static int blk_mq_init_hw_commands(struct blk_mq_hw_ctx *hctx,
-				   int (*init)(void *, struct blk_mq_hw_ctx *,
-					struct request *, unsigned int),
-				   void *data)
+static void blk_mq_free_rq_map(struct blk_mq_hw_ctx *hctx)
 {
-	unsigned int i;
-	int ret = 0;
-
-	for (i = 0; i < hctx->queue_depth; i++) {
-		struct request *rq = hctx->rqs[i];
-
-		ret = init(data, hctx, rq, i);
-		if (ret)
-			break;
-	}
-
-	return ret;
-}
+	struct page *page;
 
-int blk_mq_init_commands(struct request_queue *q,
-			 int (*init)(void *, struct blk_mq_hw_ctx *,
-					struct request *, unsigned int),
-			 void *data)
-{
-	struct blk_mq_hw_ctx *hctx;
-	unsigned int i;
-	int ret = 0;
+	if (hctx->rqs && hctx->queue->mq_ops->exit_request) {
+		int i;
 
-	queue_for_each_hw_ctx(q, hctx, i) {
-		ret = blk_mq_init_hw_commands(hctx, init, data);
-		if (ret)
-			break;
+		for (i = 0; i < hctx->queue_depth; i++) {
+			if (!hctx->rqs[i])
+				continue;
+			hctx->queue->mq_ops->exit_request(hctx, hctx->rqs[i]);
+		}
 	}
 
-	return ret;
-}
-EXPORT_SYMBOL(blk_mq_init_commands);
-
-static void blk_mq_free_hw_commands(struct blk_mq_hw_ctx *hctx,
-				    void (*free)(void *, struct blk_mq_hw_ctx *,
-					struct request *, unsigned int),
-				    void *data)
-{
-	unsigned int i;
-
-	for (i = 0; i < hctx->queue_depth; i++) {
-		struct request *rq = hctx->rqs[i];
-
-		free(data, hctx, rq, i);
-	}
-}
-
-void blk_mq_free_commands(struct request_queue *q,
-			  void (*free)(void *, struct blk_mq_hw_ctx *,
-					struct request *, unsigned int),
-			  void *data)
-{
-	struct blk_mq_hw_ctx *hctx;
-	unsigned int i;
-
-	queue_for_each_hw_ctx(q, hctx, i)
-		blk_mq_free_hw_commands(hctx, free, data);
-}
-EXPORT_SYMBOL(blk_mq_free_commands);
-
-static void blk_mq_free_rq_map(struct blk_mq_hw_ctx *hctx)
-{
-	struct page *page;
-
 	while (!list_empty(&hctx->page_list)) {
 		page = list_first_entry(&hctx->page_list, struct page, lru);
 		list_del_init(&page->lru);
@@ -1088,10 +1033,12 @@ static size_t order_to_size(unsigned int order)
 }
 
 static int blk_mq_init_rq_map(struct blk_mq_hw_ctx *hctx,
-			      unsigned int reserved_tags, int node)
+		struct blk_mq_reg *reg, void *driver_data, int node)
 {
+	unsigned int reserved_tags = reg->reserved_tags;
 	unsigned int i, j, entries_per_page, max_order = 4;
 	size_t rq_size, left;
+	int error;
 
 	INIT_LIST_HEAD(&hctx->page_list);
 
@@ -1140,14 +1087,23 @@ static int blk_mq_init_rq_map(struct blk_mq_hw_ctx *hctx,
 		for (j = 0; j < to_do; j++) {
 			hctx->rqs[i] = p;
 			blk_mq_rq_init(hctx, hctx->rqs[i]);
+			if (reg->ops->init_request) {
+				error = reg->ops->init_request(driver_data,
+						hctx, hctx->rqs[i], i);
+				if (error)
+					goto err_rq_map;
+			}
+
 			p += rq_size;
 			i++;
 		}
 	}
 
-	if (i < (reserved_tags + BLK_MQ_TAG_MIN))
+	if (i < (reserved_tags + BLK_MQ_TAG_MIN)) {
+		error = -ENOMEM;
 		goto err_rq_map;
-	else if (i != hctx->queue_depth) {
+	}
+	if (i != hctx->queue_depth) {
 		hctx->queue_depth = i;
 		pr_warn("%s: queue depth set to %u because of low memory\n",
 					__func__, i);
@@ -1155,12 +1111,14 @@ static int blk_mq_init_rq_map(struct blk_mq_hw_ctx *hctx,
 
 	hctx->tags = blk_mq_init_tags(hctx->queue_depth, reserved_tags, node);
 	if (!hctx->tags) {
-err_rq_map:
-		blk_mq_free_rq_map(hctx);
-		return -ENOMEM;
+		error = -ENOMEM;
+		goto err_rq_map;
 	}
 
 	return 0;
+err_rq_map:
+	blk_mq_free_rq_map(hctx);
+	return error;
 }
 
 static int blk_mq_init_hw_queues(struct request_queue *q,
@@ -1193,7 +1151,7 @@ static int blk_mq_init_hw_queues(struct request_queue *q,
 						blk_mq_hctx_notify, hctx);
 		blk_mq_register_cpu_notifier(&hctx->cpu_notifier);
 
-		if (blk_mq_init_rq_map(hctx, reg->reserved_tags, node))
+		if (blk_mq_init_rq_map(hctx, reg, driver_data, node))
 			break;
 
 		/*
@@ -1372,8 +1330,19 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_reg *reg,
 	if (!q->flush_rq)
 		goto err_hw;
 
+	if (reg->ops->init_request) {
+		blk_rq_init(q, q->flush_rq);
+		if (reg->cmd_size)
+			q->flush_rq->special =
+				blk_mq_rq_to_pdu(q->flush_rq);
+
+		if (reg->ops->init_request(driver_data,
+				NULL, q->flush_rq, -1))
+			goto err_flush_rq;
+	}
+
 	if (blk_mq_init_hw_queues(q, reg, driver_data))
-		goto err_flush_rq;
+		goto err_flush_rq_init;
 
 	blk_mq_map_swqueue(q);
 
@@ -1383,6 +1352,9 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_reg *reg,
 
 	return q;
 
+err_flush_rq_init:
+	if (reg->ops->exit_request)
+		reg->ops->exit_request(NULL, q->flush_rq);
 err_flush_rq:
 	kfree(q->flush_rq);
 err_hw:
@@ -1428,6 +1400,9 @@ void blk_mq_free_queue(struct request_queue *q)
 	mutex_lock(&all_q_mutex);
 	list_del_init(&q->all_q_node);
 	mutex_unlock(&all_q_mutex);
+
+	if (q->mq_ops->exit_request)
+		q->mq_ops->exit_request(NULL, q->flush_rq);
 }
 
 /* Basically redo blk_mq_init_queue with queue frozen */
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 0eace43..a2e925b 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -474,11 +474,22 @@ static const struct device_attribute dev_attr_cache_type_rw =
 	__ATTR(cache_type, S_IRUGO|S_IWUSR,
 	       virtblk_cache_type_show, virtblk_cache_type_store);
 
+static int virtblk_init_request(void *data, struct blk_mq_hw_ctx *hctx,
+		struct request *rq, unsigned int nr)
+{
+	struct virtio_blk *vblk = data;
+	struct virtblk_req *vbr = rq->special;
+
+	sg_init_table(vbr->sg, vblk->sg_elems);
+	return 0;
+}
+
 static struct blk_mq_ops virtio_mq_ops = {
 	.queue_rq	= virtio_queue_rq,
 	.map_queue	= blk_mq_map_queue,
 	.alloc_hctx	= blk_mq_alloc_single_hw_queue,
 	.free_hctx	= blk_mq_free_single_hw_queue,
+	.init_request	= virtblk_init_request,
 	.complete	= virtblk_request_done,
 };
 
@@ -490,16 +501,6 @@ static struct blk_mq_reg virtio_mq_reg = {
 	.flags		= BLK_MQ_F_SHOULD_MERGE,
 };
 
-static int virtblk_init_vbr(void *data, struct blk_mq_hw_ctx *hctx,
-			     struct request *rq, unsigned int nr)
-{
-	struct virtio_blk *vblk = data;
-	struct virtblk_req *vbr = rq->special;
-
-	sg_init_table(vbr->sg, vblk->sg_elems);
-	return 0;
-}
-
 static int virtblk_probe(struct virtio_device *vdev)
 {
 	struct virtio_blk *vblk;
@@ -563,8 +564,6 @@ static int virtblk_probe(struct virtio_device *vdev)
 		goto out_put_disk;
 	}
 
-	blk_mq_init_commands(q, virtblk_init_vbr, vblk);
-
 	q->queuedata = vblk;
 
 	virtblk_name_format("vd", index, vblk->disk->disk_name, DISK_NAME_LEN);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 0120451..e8e81c5 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -66,6 +66,9 @@ typedef struct blk_mq_hw_ctx *(alloc_hctx_fn)(struct blk_mq_reg *,unsigned int);
 typedef void (free_hctx_fn)(struct blk_mq_hw_ctx *, unsigned int);
 typedef int (init_hctx_fn)(struct blk_mq_hw_ctx *, void *, unsigned int);
 typedef void (exit_hctx_fn)(struct blk_mq_hw_ctx *, unsigned int);
+typedef int (init_request_fn)(void *, struct blk_mq_hw_ctx *,
+		struct request *, unsigned int);
+typedef void (exit_request_fn)(struct blk_mq_hw_ctx *, struct request *);
 
 struct blk_mq_ops {
 	/*
@@ -98,6 +101,17 @@ struct blk_mq_ops {
 	 */
 	init_hctx_fn		*init_hctx;
 	exit_hctx_fn		*exit_hctx;
+
+	/*
+	 * Called for every command allocated by the block layer to allow
+	 * the driver to set up driver specific data.
+	 * Ditto for exit/teardown.
+	 *
+	 * Note that the hctx argument might be NULL for the flush request
+	 * for either call.
+	 */
+	init_request_fn		*init_request;
+	exit_request_fn		*exit_request;
 };
 
 enum {
@@ -117,8 +131,6 @@ enum {
 struct request_queue *blk_mq_init_queue(struct blk_mq_reg *, void *);
 int blk_mq_register_disk(struct gendisk *);
 void blk_mq_unregister_disk(struct gendisk *);
-int blk_mq_init_commands(struct request_queue *, int (*init)(void *data, struct blk_mq_hw_ctx *, struct request *, unsigned int), void *data);
-void blk_mq_free_commands(struct request_queue *, void (*free)(void *data, struct blk_mq_hw_ctx *, struct request *, unsigned int), void *data);
 
 void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule);
 
-- 
1.7.10.4

