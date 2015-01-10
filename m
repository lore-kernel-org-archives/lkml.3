Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbbAJOaR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 09:30:17 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:14386 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbbAJO37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 09:29:59 -0500
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>, hch@infradead.org, axboe@fb.com,
        tom.leiming@gmail.com
Subject: [PATCH 2/2] UBI: Block: Add blk-mq support
Date: Sat, 10 Jan 2015 15:29:48 +0100
Message-Id: <1420900188-15781-2-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1420900188-15781-1-git-send-email-richard@nod.at>
References: <1420900188-15781-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the driver to blk-mq.
Beside of moving to the modern block interface this change boosts
also the performance of the driver.

nand: device found, Manufacturer ID: 0x2c, Chip ID: 0xda
nand: Micron NAND 256MiB 3,3V 8-bit
nand: 256MiB, SLC, page size: 2048, OOB size: 64

root@debian-armhf:~# dd if=/dev/ubiblock0_0 of=/dev/zero bs=1M
243+1 records in
243+1 records out
255080448 bytes (255 MB) copied, 4.39295 s, 58.1 MB/s

vs.

root@debian-armhf:~# dd if=/dev/ubiblock0_0 of=/dev/zero bs=1M
243+1 records in
243+1 records out
255080448 bytes (255 MB) copied, 2.87676 s, 88.7 MB/s

Cc: hch@infradead.org
Cc: axboe@fb.com
Cc: tom.leiming@gmail.com
Signed-off-by: Richard Weinberger <richard@nod.at>
Tested-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
---
 drivers/mtd/ubi/block.c | 213 +++++++++++++++++++++++-------------------------
 1 file changed, 104 insertions(+), 109 deletions(-)

diff --git a/drivers/mtd/ubi/block.c b/drivers/mtd/ubi/block.c
index 6b6bce2..bc088ab 100644
--- a/drivers/mtd/ubi/block.c
+++ b/drivers/mtd/ubi/block.c
@@ -42,11 +42,12 @@
 #include <linux/list.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
-#include <linux/vmalloc.h>
 #include <linux/mtd/ubi.h>
 #include <linux/workqueue.h>
 #include <linux/blkdev.h>
+#include <linux/blk-mq.h>
 #include <linux/hdreg.h>
+#include <linux/scatterlist.h>
 #include <asm/div64.h>
 
 #include "ubi-media.h"
@@ -67,6 +68,13 @@ struct ubiblock_param {
 	char name[UBIBLOCK_PARAM_LEN+1];
 };
 
+struct ubiblock_pdu {
+	struct request *req;
+	struct ubiblock *dev;
+	struct work_struct work;
+	struct ubi_sgl usgl;
+};
+
 /* Numbers of elements set in the @ubiblock_param array */
 static int ubiblock_devs __initdata;
 
@@ -84,11 +92,10 @@ struct ubiblock {
 	struct request_queue *rq;
 
 	struct workqueue_struct *wq;
-	struct work_struct work;
 
 	struct mutex dev_mutex;
-	spinlock_t queue_lock;
 	struct list_head list;
+	struct blk_mq_tag_set tag_set;
 };
 
 /* Linked list of all ubiblock instances */
@@ -181,31 +188,17 @@ static struct ubiblock *find_dev_nolock(int ubi_num, int vol_id)
 	return NULL;
 }
 
-static int ubiblock_read_to_buf(struct ubiblock *dev, char *buffer,
-				int leb, int offset, int len)
-{
-	int ret;
-
-	ret = ubi_read(dev->desc, leb, buffer, offset, len);
-	if (ret) {
-		dev_err(disk_to_dev(dev->gd), "%d while reading from LEB %d (offset %d, length %d)",
-			ret, leb, offset, len);
-		return ret;
-	}
-	return 0;
-}
-
-static int ubiblock_read(struct ubiblock *dev, char *buffer,
-			 sector_t sec, int len)
+static int ubiblock_read(struct ubiblock_pdu *pdu)
 {
-	int ret, leb, offset;
-	int bytes_left = len;
-	int to_read = len;
-	u64 pos = sec << 9;
+	int ret, leb, offset, bytes_left;
+	int to_read = blk_rq_bytes(pdu->req);
+	struct ubiblock *dev = pdu->dev;
+	u64 pos = blk_rq_pos(pdu->req) << 9;
 
 	/* Get LEB:offset address to read from */
 	offset = do_div(pos, dev->leb_size);
 	leb = pos;
+	bytes_left = to_read;
 
 	while (bytes_left) {
 		/*
@@ -215,11 +208,10 @@ static int ubiblock_read(struct ubiblock *dev, char *buffer,
 		if (offset + to_read > dev->leb_size)
 			to_read = dev->leb_size - offset;
 
-		ret = ubiblock_read_to_buf(dev, buffer, leb, offset, to_read);
-		if (ret)
+		ret = ubi_read_sg(dev->desc, leb, &pdu->usgl, offset, to_read);
+		if (ret < 0)
 			return ret;
 
-		buffer += to_read;
 		bytes_left -= to_read;
 		to_read = bytes_left;
 		leb += 1;
@@ -228,79 +220,6 @@ static int ubiblock_read(struct ubiblock *dev, char *buffer,
 	return 0;
 }
 
-static int do_ubiblock_request(struct ubiblock *dev, struct request *req)
-{
-	int len, ret;
-	sector_t sec;
-
-	if (req->cmd_type != REQ_TYPE_FS)
-		return -EIO;
-
-	if (blk_rq_pos(req) + blk_rq_cur_sectors(req) >
-	    get_capacity(req->rq_disk))
-		return -EIO;
-
-	if (rq_data_dir(req) != READ)
-		return -ENOSYS; /* Write not implemented */
-
-	sec = blk_rq_pos(req);
-	len = blk_rq_cur_bytes(req);
-
-	/*
-	 * Let's prevent the device from being removed while we're doing I/O
-	 * work. Notice that this means we serialize all the I/O operations,
-	 * but it's probably of no impact given the NAND core serializes
-	 * flash access anyway.
-	 */
-	mutex_lock(&dev->dev_mutex);
-	ret = ubiblock_read(dev, bio_data(req->bio), sec, len);
-	mutex_unlock(&dev->dev_mutex);
-
-	return ret;
-}
-
-static void ubiblock_do_work(struct work_struct *work)
-{
-	struct ubiblock *dev =
-		container_of(work, struct ubiblock, work);
-	struct request_queue *rq = dev->rq;
-	struct request *req;
-	int res;
-
-	spin_lock_irq(rq->queue_lock);
-
-	req = blk_fetch_request(rq);
-	while (req) {
-
-		spin_unlock_irq(rq->queue_lock);
-		res = do_ubiblock_request(dev, req);
-		spin_lock_irq(rq->queue_lock);
-
-		/*
-		 * If we're done with this request,
-		 * we need to fetch a new one
-		 */
-		if (!__blk_end_request_cur(req, res))
-			req = blk_fetch_request(rq);
-	}
-
-	spin_unlock_irq(rq->queue_lock);
-}
-
-static void ubiblock_request(struct request_queue *rq)
-{
-	struct ubiblock *dev;
-	struct request *req;
-
-	dev = rq->queuedata;
-
-	if (!dev)
-		while ((req = blk_fetch_request(rq)) != NULL)
-			__blk_end_request_all(req, -ENODEV);
-	else
-		queue_work(dev->wq, &dev->work);
-}
-
 static int ubiblock_open(struct block_device *bdev, fmode_t mode)
 {
 	struct ubiblock *dev = bdev->bd_disk->private_data;
@@ -374,6 +293,67 @@ static const struct block_device_operations ubiblock_ops = {
 	.getgeo	= ubiblock_getgeo,
 };
 
+static void ubiblock_do_work(struct work_struct *work)
+{
+	int ret;
+	struct ubiblock_pdu *pdu = container_of(work, struct ubiblock_pdu, work);
+
+	ret = ubiblock_read(pdu);
+	blk_mq_end_request(pdu->req, ret ?: 0);
+}
+
+static int ubiblock_queue_rq(struct blk_mq_hw_ctx *hctx,
+			     const struct blk_mq_queue_data *bd)
+{
+	int ret;
+	struct request *req = bd->rq;
+	struct ubiblock *dev = hctx->queue->queuedata;
+	struct ubiblock_pdu *pdu = blk_mq_rq_to_pdu(req);
+
+	if (req->cmd_type != REQ_TYPE_FS)
+		return BLK_MQ_RQ_QUEUE_ERROR;
+
+	if (blk_rq_pos(req) + blk_rq_cur_sectors(req) >
+	    get_capacity(req->rq_disk))
+		return BLK_MQ_RQ_QUEUE_ERROR;
+
+	if (rq_data_dir(req) != READ)
+		return BLK_MQ_RQ_QUEUE_ERROR; /* Write not implemented */
+
+	pdu->usgl.list_pos = 0;
+	pdu->usgl.page_pos = 0;
+
+	blk_mq_start_request(req);
+	ret = blk_rq_map_sg(hctx->queue, req, pdu->usgl.sg);
+
+	queue_work(dev->wq, &pdu->work);
+
+	return BLK_MQ_RQ_QUEUE_OK;
+}
+
+static int ubiblock_init_request(void *data, struct request *req,
+				 unsigned int hctx_idx,
+				 unsigned int request_idx,
+				 unsigned int numa_node)
+{
+	struct ubiblock *dev = data;
+	struct ubiblock_pdu *pdu = blk_mq_rq_to_pdu(req);
+
+	pdu->dev = dev;
+	pdu->req = req;
+
+	sg_init_table(pdu->usgl.sg, UBI_MAX_SG_COUNT);
+	INIT_WORK(&pdu->work, ubiblock_do_work);
+
+	return 0;
+}
+
+static struct blk_mq_ops ubiblock_mq_ops = {
+	.queue_rq       = ubiblock_queue_rq,
+	.init_request	= ubiblock_init_request,
+	.map_queue      = blk_mq_map_queue,
+};
+
 int ubiblock_create(struct ubi_volume_info *vi)
 {
 	struct ubiblock *dev;
@@ -417,13 +397,27 @@ int ubiblock_create(struct ubi_volume_info *vi)
 	set_capacity(gd, disk_capacity);
 	dev->gd = gd;
 
-	spin_lock_init(&dev->queue_lock);
-	dev->rq = blk_init_queue(ubiblock_request, &dev->queue_lock);
+	dev->tag_set.ops = &ubiblock_mq_ops;
+	dev->tag_set.queue_depth = 64;
+	dev->tag_set.numa_node = NUMA_NO_NODE;
+	dev->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
+	dev->tag_set.cmd_size = sizeof(struct ubiblock_pdu);
+	dev->tag_set.driver_data = dev;
+	dev->tag_set.nr_hw_queues = 1;
+
+	ret = blk_mq_alloc_tag_set(&dev->tag_set);
+	if (ret) {
+		dev_err(disk_to_dev(dev->gd), "blk_mq_alloc_tag_set failed");
+		goto out_put_disk;
+	}
+
+	dev->rq = blk_mq_init_queue(&dev->tag_set);
 	if (!dev->rq) {
-		dev_err(disk_to_dev(gd), "blk_init_queue failed");
+		dev_err(disk_to_dev(gd), "blk_mq_init_queue failed");
 		ret = -ENODEV;
-		goto out_put_disk;
+		goto out_free_tags;
 	}
+	blk_queue_max_segments(dev->rq, UBI_MAX_SG_COUNT);
 
 	dev->rq->queuedata = dev;
 	dev->gd->queue = dev->rq;
@@ -437,7 +431,6 @@ int ubiblock_create(struct ubi_volume_info *vi)
 		ret = -ENOMEM;
 		goto out_free_queue;
 	}
-	INIT_WORK(&dev->work, ubiblock_do_work);
 
 	mutex_lock(&devices_mutex);
 	list_add_tail(&dev->list, &ubiblock_devices);
@@ -451,6 +444,8 @@ int ubiblock_create(struct ubi_volume_info *vi)
 
 out_free_queue:
 	blk_cleanup_queue(dev->rq);
+out_free_tags:
+	blk_mq_free_tag_set(&dev->tag_set);
 out_put_disk:
 	put_disk(dev->gd);
 out_free_dev:
@@ -461,8 +456,13 @@ out_free_dev:
 
 static void ubiblock_cleanup(struct ubiblock *dev)
 {
+	/* Stop new requests to arrive */
 	del_gendisk(dev->gd);
+	/* Flush pending work */
+	destroy_workqueue(dev->wq);
+	/* Finally destroy the blk queue */
 	blk_cleanup_queue(dev->rq);
+	blk_mq_free_tag_set(&dev->tag_set);
 	dev_info(disk_to_dev(dev->gd), "released");
 	put_disk(dev->gd);
 }
@@ -490,9 +490,6 @@ int ubiblock_remove(struct ubi_volume_info *vi)
 	list_del(&dev->list);
 	mutex_unlock(&devices_mutex);
 
-	/* Flush pending work and stop this workqueue */
-	destroy_workqueue(dev->wq);
-
 	ubiblock_cleanup(dev);
 	mutex_unlock(&dev->dev_mutex);
 	kfree(dev);
@@ -620,8 +617,6 @@ static void ubiblock_remove_all(void)
 	struct ubiblock *dev;
 
 	list_for_each_entry_safe(dev, next, &ubiblock_devices, list) {
-		/* Flush pending work and stop workqueue */
-		destroy_workqueue(dev->wq);
 		/* The module is being forcefully removed */
 		WARN_ON(dev->desc);
 		/* Remove from device list */
-- 
1.8.4.5

