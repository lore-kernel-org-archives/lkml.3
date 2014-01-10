Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbaAJClc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 21:41:32 -0500
Received: from mga09.intel.com ([134.134.136.24]:25486 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752934AbaAJCkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 21:40:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,635,1384329600"; 
   d="scan'208";a="464478276"
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
To: linux-fsdevel@vger.kernel.org, linux-mm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH 5/6] virtio_blk: Add rw_page implementation
Date: Thu,  9 Jan 2014 21:39:50 -0500
Message-Id: <1389321591-25455-5-git-send-email-matthew.r.wilcox@intel.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389321591-25455-1-git-send-email-matthew.r.wilcox@intel.com>
References: <1389321591-25455-1-git-send-email-matthew.r.wilcox@intel.com>
In-Reply-To: <cover.1387748522.git.matthew.r.wilcox@intel.com>
References: <cover.1387748522.git.matthew.r.wilcox@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an implementation of the new rw_page interface.  It primarily
demonstrates a low-impact, low-reward method for adding support to a
driver.  I don't expect it to improve performance; in fact I expect it
to worsen performance slightly since there are still memory allocations
in the I/O path.

Please don't apply this patch.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
---
 drivers/block/virtio_blk.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 6a680d4..4c1c9ad 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -110,11 +110,22 @@ static int __virtblk_add_req(struct virtqueue *vq,
 	return virtqueue_add_sgs(vq, sgs, num_out, num_in, vbr, GFP_ATOMIC);
 }
 
+#define rw_to_dmad(rw)	(((rw) == WRITE) ? DMA_TO_DEVICE : DMA_FROM_DEVICE)
+
 static inline void virtblk_request_done(struct virtblk_req *vbr)
 {
 	struct request *req = vbr->req;
 	int error = virtblk_result(vbr);
 
+	if ((unsigned long)req & 1) {
+		struct virtio_blk *vblk = (void *)((unsigned long)req & ~1UL);
+		int rw = (vbr->out_hdr.type & VIRTIO_BLK_T_OUT) ? WRITE : READ;
+		struct page *page = sg_page(vbr->sg);
+		dma_unmap_sg(&vblk->vdev->dev, vbr->sg, 1, rw_to_dmad(rw));
+		page_endio(page, rw, error);
+		return;
+	}
+
 	if (req->cmd_type == REQ_TYPE_BLOCK_PC) {
 		req->resid_len = vbr->in_hdr.residual;
 		req->sense_len = vbr->in_hdr.sense_len;
@@ -239,6 +250,38 @@ static int virtblk_get_id(struct gendisk *disk, char *id_str)
 	return err;
 }
 
+static int virtblk_rw_page(struct block_device *bdev, sector_t sector,
+				struct page *page, int rw)
+{
+	unsigned long flags;
+	struct virtio_blk *vblk = bdev->bd_disk->private_data;
+	struct virtblk_req *vbr;
+	int err;
+
+	vbr = kmalloc(sizeof(*vbr) + sizeof(struct scatterlist), GFP_NOFS);
+	if (!vbr)
+		return -ENOMEM;
+
+	vbr->req = (void *)((unsigned long)vblk | 1);
+	vbr->out_hdr.type = (rw == WRITE) ? VIRTIO_BLK_T_OUT : VIRTIO_BLK_T_IN;
+	vbr->out_hdr.sector = sector;
+	vbr->out_hdr.ioprio = 0;
+
+	sg_init_table(vbr->sg, 1);
+	sg_set_page(vbr->sg, page, PAGE_CACHE_SIZE, 0);
+	sg_mark_end(vbr->sg);
+	if (dma_map_sg(&vblk->vdev->dev, vbr->sg, 1, rw_to_dmad(rw))) {
+		kfree(vbr);
+		return -ENOMEM;
+	}
+
+	spin_lock_irqsave(&vblk->vq_lock, flags);
+	err = __virtblk_add_req(vblk->vq, vbr, vbr->sg, 1);
+	virtqueue_kick(vblk->vq);
+	spin_unlock_irqrestore(&vblk->vq_lock, flags);
+	return err;
+}
+
 static int virtblk_ioctl(struct block_device *bdev, fmode_t mode,
 			     unsigned int cmd, unsigned long data)
 {
@@ -278,6 +321,7 @@ static int virtblk_getgeo(struct block_device *bd, struct hd_geometry *geo)
 }
 
 static const struct block_device_operations virtblk_fops = {
+	.rw_page = virtblk_rw_page,
 	.ioctl  = virtblk_ioctl,
 	.owner  = THIS_MODULE,
 	.getgeo = virtblk_getgeo,
-- 
1.8.5.2

