Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503Ab3LKQWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 11:22:40 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:59142 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab3LKQWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 11:22:36 -0500
From: Rajiv Shanmugam Madeswaran <smrajiv15@gmail.com>
To: Matthew Wilcox <willy@linux.intel.com>, linux-nvme@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Rajiv Shanmugam Madeswaran <smrajiv15@gmail.com>
Subject: [PATCH 1/1] block: nvme-core: Scatter gather list support in the NVMe Block Driver
Date: Wed, 11 Dec 2013 21:51:48 +0530
Message-Id: <1386778908-3370-1-git-send-email-smrajiv15@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Present nvme block driver supports PRP mode of data transfer for Admin
and I/O commands. As per NVMe specification 1.1a I/O commands can also
be transferred through SGL.
This patch contains the code for supporting SGL ( Scatter Gather Lists ).
Based on the controller support , mode of data transfer is decided
during inititalization.

Note: If both SGL and PRP are supported by controller, SGL mode of
transfer is carried out for I/O commands.

Signed-off-by: Rajiv Shanmugam Madeswaran <smrajiv15@gmail.com>
---
 drivers/block/nvme-core.c |  278 ++++++++++++++++++++++++++++++++++++++------
 include/linux/nvme.h      |   13 ++-
 include/uapi/linux/nvme.h |   34 +++++-
 3 files changed, 280 insertions(+), 45 deletions(-)

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index 26d03fa..02f03c9 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -59,6 +59,14 @@ static DEFINE_SPINLOCK(dev_list_lock);
 static LIST_HEAD(dev_list);
 static struct task_struct *nvme_thread;
 
+static struct nvme_iod*
+	(*iodfp) (unsigned nseg, unsigned nbytes, gfp_t gfp);
+
+static int (*setup_xfer) (struct nvme_dev *dev, struct nvme_common_command *cmd,
+				struct nvme_iod *iod, int total_len, gfp_t gfp);
+
+static void (*free_iod) (struct nvme_dev *dev, struct nvme_iod *iod);
+
 /*
  * An NVM Express queue.  Each device has at least two (one for admin
  * commands and one for I/O commands).
@@ -299,6 +307,33 @@ nvme_alloc_iod(unsigned nseg, unsigned nbytes, gfp_t gfp)
 	return iod;
 }
 
+/* calculates the number of pages needed for framing the
+ * SGL segments. for ex: 4k page can accomodate 256 SGL descriptors
+ */
+static int nvme_npages_sgl(unsigned num_seg)
+{
+	return DIV_ROUND_UP(num_seg * 16, PAGE_SIZE);
+}
+
+static struct nvme_iod *
+nvme_alloc_iod_sgl(unsigned nseg, unsigned nbytes, gfp_t gfp)
+{
+
+	struct nvme_iod *iod = kmalloc(sizeof(struct nvme_iod) +
+				sizeof(__le64 *) * nvme_npages_sgl(nseg) +
+				sizeof(struct scatterlist) * nseg, gfp);
+
+	if (iod) {
+		iod->offset = offsetof(struct nvme_iod, sg[nseg]);
+		iod->npages = -1;
+		iod->length = nbytes;
+		iod->nents = 0;
+		iod->start_time = jiffies;
+	}
+
+	return iod;
+}
+
 void nvme_free_iod(struct nvme_dev *dev, struct nvme_iod *iod)
 {
 	const int last_prp = PAGE_SIZE / 8 - 1;
@@ -307,16 +342,37 @@ void nvme_free_iod(struct nvme_dev *dev, struct nvme_iod *iod)
 	dma_addr_t prp_dma = iod->first_dma;
 
 	if (iod->npages == 0)
-		dma_pool_free(dev->prp_small_pool, list[0], prp_dma);
+		dma_pool_free(dev->small_pool, list[0], prp_dma);
 	for (i = 0; i < iod->npages; i++) {
 		__le64 *prp_list = list[i];
 		dma_addr_t next_prp_dma = le64_to_cpu(prp_list[last_prp]);
-		dma_pool_free(dev->prp_page_pool, prp_list, prp_dma);
+		dma_pool_free(dev->page_pool, prp_list, prp_dma);
 		prp_dma = next_prp_dma;
 	}
 	kfree(iod);
 }
 
+void nvme_free_iod_sgl(struct nvme_dev *dev, struct nvme_iod *iod)
+{
+	int i;
+	int last_entry;
+	__le64 **list = iod_list(iod);
+	dma_addr_t sgl_dma, next_sgl_dma;
+	sgl_dma = iod->first_dma;
+
+	if (iod->npages == 0)
+		dma_pool_free(dev->small_pool, list[0], sgl_dma);
+
+	last_entry = PAGE_SIZE / 16 - 1;
+	for (i = 0; i < iod->npages; i++) {
+		struct sgl_desc *sg_list = (struct sgl_desc *)list[i];
+		next_sgl_dma = le64_to_cpu((sg_list[last_entry]).addr);
+		dma_pool_free(dev->page_pool, sg_list, sgl_dma);
+		sgl_dma = next_sgl_dma;
+	}
+	kfree(iod);
+}
+
 static void nvme_start_io_acct(struct bio *bio)
 {
 	struct gendisk *disk = bio->bi_bdev->bd_disk;
@@ -353,7 +409,7 @@ static void bio_completion(struct nvme_dev *dev, void *ctx,
 			bio_data_dir(bio) ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
 		nvme_end_io_acct(bio, iod->start_time);
 	}
-	nvme_free_iod(dev, iod);
+	free_iod(dev, iod);
 	if (status)
 		bio_endio(bio, -EIO);
 	else
@@ -375,7 +431,7 @@ int nvme_setup_prps(struct nvme_dev *dev, struct nvme_common_command *cmd,
 	dma_addr_t prp_dma;
 	int nprps, i;
 
-	cmd->prp1 = cpu_to_le64(dma_addr);
+	cmd->buffer.prp.prp1 = cpu_to_le64(dma_addr);
 	length -= (PAGE_SIZE - offset);
 	if (length <= 0)
 		return total_len;
@@ -390,28 +446,28 @@ int nvme_setup_prps(struct nvme_dev *dev, struct nvme_common_command *cmd,
 	}
 
 	if (length <= PAGE_SIZE) {
-		cmd->prp2 = cpu_to_le64(dma_addr);
+		cmd->buffer.prp.prp2 = cpu_to_le64(dma_addr);
 		return total_len;
 	}
 
 	nprps = DIV_ROUND_UP(length, PAGE_SIZE);
 	if (nprps <= (256 / 8)) {
-		pool = dev->prp_small_pool;
+		pool = dev->small_pool;
 		iod->npages = 0;
 	} else {
-		pool = dev->prp_page_pool;
+		pool = dev->page_pool;
 		iod->npages = 1;
 	}
 
 	prp_list = dma_pool_alloc(pool, gfp, &prp_dma);
 	if (!prp_list) {
-		cmd->prp2 = cpu_to_le64(dma_addr);
+		cmd->buffer.prp.prp2 = cpu_to_le64(dma_addr);
 		iod->npages = -1;
 		return (total_len - length) + PAGE_SIZE;
 	}
 	list[0] = prp_list;
 	iod->first_dma = prp_dma;
-	cmd->prp2 = cpu_to_le64(prp_dma);
+	cmd->buffer.prp.prp2 = cpu_to_le64(prp_dma);
 	i = 0;
 	for (;;) {
 		if (i == PAGE_SIZE / 8) {
@@ -441,6 +497,118 @@ int nvme_setup_prps(struct nvme_dev *dev, struct nvme_common_command *cmd,
 	return total_len;
 }
 
+/* frames NVMe specfic SGL's for data transfer */
+int nvme_setup_sgls(struct nvme_dev *dev, struct nvme_common_command *cmd,
+			struct nvme_iod *iod, int total_len, gfp_t gfp)
+{
+	struct dma_pool *pool;
+	struct sgl_desc *sg_list;
+	dma_addr_t sgl_dma;
+	int i;
+	int length = total_len;
+	struct scatterlist *sg = iod->sg;
+	__le64 **list = iod_list(iod);
+	int num_entries = iod->nents;
+	int entry = (PAGE_SIZE / 16) - 1;
+	struct sgl_desc *sg_seg;
+
+	cmd->flags = 1 << 7; /* setting the transfer type as SGL */
+
+	if (total_len == sg_dma_len(sg)) {
+		cmd->buffer.sgl.addr = cpu_to_le64(sg_dma_address(sg));
+		cmd->buffer.sgl.sg_id = SGL_DATA_DESC;
+		cmd->buffer.sgl.length = cpu_to_le32(sg_dma_len(sg));
+		return total_len;
+	}
+
+	if (num_entries <= (256 / 16)) {
+		pool = dev->small_pool;
+		iod->npages = 0;
+	} else {
+		pool = dev->page_pool;
+		iod->npages = 1;
+	}
+
+	sg_list = (struct sgl_desc *)dma_pool_alloc(pool, gfp, &sgl_dma);
+
+	if (!sg_list) {
+		cmd->buffer.sgl.addr = cpu_to_le64(sg_dma_address(sg));
+		cmd->buffer.sgl.sg_id = SGL_DATA_DESC;
+		cmd->buffer.sgl.length = cpu_to_le32(sg_dma_len(sg));
+		length -= sg_dma_len(sg);
+		return total_len - length;
+	}
+
+	list[0] = (__le64 *)sg_list;
+	iod->first_dma = sgl_dma;
+
+	if (num_entries <= (PAGE_SIZE / 16)) {
+		cmd->buffer.sgl.addr = cpu_to_le64(sgl_dma);
+		cmd->buffer.sgl.length = cpu_to_le32(num_entries * 16);
+		cmd->buffer.sgl.sg_id = SGL_LAST_SEG_DESC;
+		for (i = 0; i < num_entries; i++) {
+			sg_list[i].addr = cpu_to_le64(sg_dma_address(sg));
+			sg_list[i].length = cpu_to_le32(sg_dma_len(sg));
+			sg_list[i].sg_id = SGL_DATA_DESC;
+			length -= sg_dma_len(sg);
+			sg = sg_next(sg);
+		}
+
+		BUG_ON(length > 0);
+		return total_len;
+	} else {
+		cmd->buffer.sgl.addr = cpu_to_le64(sgl_dma);
+		cmd->buffer.sgl.length = cpu_to_le32(PAGE_SIZE);
+		cmd->buffer.sgl.sg_id = SGL_SEG_DESC;
+		i = 0;
+		for (;;) {
+			if (i == PAGE_SIZE / 16) {
+				struct sgl_desc *old_sg_desc = sg_list;
+				sg_list = dma_pool_alloc(pool, gfp, &sgl_dma);
+				if (!sg_list) {
+					if (iod->npages == 1) {
+						cmd->buffer.sgl.sg_id =
+							SGL_LAST_SEG_DESC;
+					} else {
+						int page = iod->npages - 2;
+						sg_seg = (struct sgl_desc *)
+								list[page];
+						sg_seg[entry].sg_id =
+							SGL_LAST_SEG_DESC;
+					}
+					return total_len - length;
+				}
+				list[iod->npages++] = (__le64 *)sg_list;
+				sg_list[0] = old_sg_desc[i - 1];
+				old_sg_desc[i - 1].addr = cpu_to_le64(sgl_dma);
+
+				if (num_entries < (PAGE_SIZE / 16)) {
+					old_sg_desc[i - 1].length =
+						cpu_to_le32(num_entries * 16);
+					old_sg_desc[i - 1].sg_id =
+							SGL_LAST_SEG_DESC;
+				} else {
+					old_sg_desc[i - 1].length =
+							cpu_to_le32(PAGE_SIZE);
+					old_sg_desc[i - 1].sg_id = SGL_SEG_DESC;
+				}
+				i = 1;
+			}
+
+			sg_list[i].addr = cpu_to_le64(sg_dma_address(sg));
+			sg_list[i].length = cpu_to_le32(sg_dma_len(sg));
+			sg_list[i++].sg_id = SGL_DATA_DESC;
+			length -= sg_dma_len(sg);
+			sg = sg_next(sg);
+			num_entries--;
+			if (length <= 0)
+				break;
+		}
+		BUG_ON(num_entries > 0);
+		return total_len;
+	}
+}
+
 struct nvme_bio_pair {
 	struct bio b1, b2, *parent;
 	struct bio_vec *bv1, *bv2;
@@ -599,7 +767,7 @@ static int nvme_submit_discard(struct nvme_queue *nvmeq, struct nvme_ns *ns,
 	struct nvme_dsm_range *range;
 	struct nvme_command *cmnd = &nvmeq->sq_cmds[nvmeq->sq_tail];
 
-	range = dma_pool_alloc(nvmeq->dev->prp_small_pool, GFP_ATOMIC,
+	range = dma_pool_alloc(nvmeq->dev->small_pool, GFP_ATOMIC,
 							&iod->first_dma);
 	if (!range)
 		return -ENOMEM;
@@ -674,7 +842,7 @@ static int nvme_submit_bio_queue(struct nvme_queue *nvmeq, struct nvme_ns *ns,
 	}
 
 	result = -ENOMEM;
-	iod = nvme_alloc_iod(psegs, bio->bi_size, GFP_ATOMIC);
+	iod = iodfp(psegs, bio->bi_size, GFP_ATOMIC);
 	if (!iod)
 		goto nomem;
 	iod->private = bio;
@@ -721,7 +889,7 @@ static int nvme_submit_bio_queue(struct nvme_queue *nvmeq, struct nvme_ns *ns,
 
 	cmnd->rw.command_id = cmdid;
 	cmnd->rw.nsid = cpu_to_le32(ns->ns_id);
-	length = nvme_setup_prps(nvmeq->dev, &cmnd->common, iod, length,
+	length = setup_xfer(nvmeq->dev, &cmnd->common, iod, length,
 								GFP_ATOMIC);
 	cmnd->rw.slba = cpu_to_le64(nvme_block_nr(ns, bio->bi_sector));
 	cmnd->rw.length = cpu_to_le16((length >> ns->lba_shift) - 1);
@@ -738,7 +906,7 @@ static int nvme_submit_bio_queue(struct nvme_queue *nvmeq, struct nvme_ns *ns,
  free_cmdid:
 	free_cmdid(nvmeq, cmdid, NULL);
  free_iod:
-	nvme_free_iod(nvmeq->dev, iod);
+	free_iod(nvmeq->dev, iod);
  nomem:
 	return result;
 }
@@ -1298,7 +1466,7 @@ static int nvme_configure_admin_queue(struct nvme_dev *dev)
 }
 
 struct nvme_iod *nvme_map_user_pages(struct nvme_dev *dev, int write,
-				unsigned long addr, unsigned length)
+			unsigned long addr, unsigned length, unsigned type)
 {
 	int i, err, count, nents, offset;
 	struct scatterlist *sg;
@@ -1323,7 +1491,11 @@ struct nvme_iod *nvme_map_user_pages(struct nvme_dev *dev, int write,
 		goto put_pages;
 	}
 
-	iod = nvme_alloc_iod(count, length, GFP_KERNEL);
+	if (type)
+		iod = nvme_alloc_iod_sgl(count, length, GFP_KERNEL);
+	else
+		iod = nvme_alloc_iod(count, length, GFP_KERNEL);
+
 	sg = iod->sg;
 	sg_init_table(sg, count);
 	for (i = 0; i < count; i++) {
@@ -1373,7 +1545,7 @@ static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 	struct nvme_user_io io;
 	struct nvme_command c;
 	unsigned length, meta_len;
-	int status, i;
+	int status, i, type = PRP;
 	struct nvme_iod *iod, *meta_iod = NULL;
 	dma_addr_t meta_dma_addr;
 	void *meta, *uninitialized_var(meta_mem);
@@ -1383,6 +1555,12 @@ static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 	length = (io.nblocks + 1) << ns->lba_shift;
 	meta_len = (io.nblocks + 1) * ns->ms;
 
+	if (NVME_CHECK_DATA_XFER(io.flags)) {
+		if (!NVME_CTRL_SUPP_SGL(dev->sgls))
+			return -EINVAL;
+		type = SGL;
+	}
+
 	if (meta_len && ((io.metadata & 3) || !io.metadata))
 		return -EINVAL;
 
@@ -1390,7 +1568,8 @@ static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 	case nvme_cmd_write:
 	case nvme_cmd_read:
 	case nvme_cmd_compare:
-		iod = nvme_map_user_pages(dev, io.opcode & 1, io.addr, length);
+		iod = nvme_map_user_pages(dev, io.opcode & 1, io.addr,
+								length, type);
 		break;
 	default:
 		return -EINVAL;
@@ -1413,7 +1592,7 @@ static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 
 	if (meta_len) {
 		meta_iod = nvme_map_user_pages(dev, io.opcode & 1, io.metadata,
-								meta_len);
+								meta_len, type);
 		if (IS_ERR(meta_iod)) {
 			status = PTR_ERR(meta_iod);
 			meta_iod = NULL;
@@ -1443,7 +1622,12 @@ static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 		c.rw.metadata = cpu_to_le64(meta_dma_addr);
 	}
 
-	length = nvme_setup_prps(dev, &c.common, iod, length, GFP_KERNEL);
+	if (type)
+		length = nvme_setup_sgls(dev, &c.common, iod, length,
+								GFP_KERNEL);
+	else
+		length = nvme_setup_prps(dev, &c.common, iod, length,
+								GFP_KERNEL);
 
 	nvmeq = get_nvmeq(dev);
 	/*
@@ -1480,13 +1664,19 @@ static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 
  unmap:
 	nvme_unmap_user_pages(dev, io.opcode & 1, iod);
-	nvme_free_iod(dev, iod);
 
-	if (meta_iod) {
+	if (meta_iod)
 		nvme_unmap_user_pages(dev, io.opcode & 1, meta_iod);
-		nvme_free_iod(dev, meta_iod);
-	}
 
+	if (type) {
+		nvme_free_iod_sgl(dev, iod);
+		if (meta_iod)
+			nvme_free_iod_sgl(dev, meta_iod);
+	} else {
+		nvme_free_iod(dev, iod);
+		if (meta_iod)
+			nvme_free_iod(dev, meta_iod);
+	}
 	return status;
 }
 
@@ -1520,7 +1710,7 @@ static int nvme_user_admin_cmd(struct nvme_dev *dev,
 	length = cmd.data_len;
 	if (cmd.data_len) {
 		iod = nvme_map_user_pages(dev, cmd.opcode & 1, cmd.addr,
-								length);
+								length, PRP);
 		if (IS_ERR(iod))
 			return PTR_ERR(iod);
 		length = nvme_setup_prps(dev, &c.common, iod, length,
@@ -1899,6 +2089,18 @@ static int nvme_dev_add(struct nvme_dev *dev)
 	ctrl = mem;
 	nn = le32_to_cpup(&ctrl->nn);
 	dev->oncs = le16_to_cpup(&ctrl->oncs);
+	dev->sgls = le32_to_cpup(&ctrl->sgls);
+
+	if (NVME_CTRL_SUPP_SGL(dev->sgls)) {
+		iodfp = nvme_alloc_iod_sgl;
+		setup_xfer = nvme_setup_sgls;
+		free_iod = nvme_free_iod_sgl;
+	} else {
+		iodfp = nvme_alloc_iod;
+		setup_xfer = nvme_setup_prps;
+		free_iod = nvme_free_iod;
+	}
+
 	memcpy(dev->serial, ctrl->sn, sizeof(ctrl->sn));
 	memcpy(dev->model, ctrl->mn, sizeof(ctrl->mn));
 	memcpy(dev->firmware_rev, ctrl->fr, sizeof(ctrl->fr));
@@ -2014,28 +2216,28 @@ static void nvme_dev_remove(struct nvme_dev *dev)
 	}
 }
 
-static int nvme_setup_prp_pools(struct nvme_dev *dev)
+static int nvme_setup_dma_pools(struct nvme_dev *dev)
 {
 	struct device *dmadev = &dev->pci_dev->dev;
-	dev->prp_page_pool = dma_pool_create("prp list page", dmadev,
-						PAGE_SIZE, PAGE_SIZE, 0);
-	if (!dev->prp_page_pool)
+	dev->page_pool = dma_pool_create("nvme page pool", dmadev,
+					PAGE_SIZE, PAGE_SIZE, 0);
+	if (!dev->page_pool)
 		return -ENOMEM;
 
 	/* Optimisation for I/Os between 4k and 128k */
-	dev->prp_small_pool = dma_pool_create("prp list 256", dmadev,
-						256, 256, 0);
-	if (!dev->prp_small_pool) {
-		dma_pool_destroy(dev->prp_page_pool);
+	dev->small_pool = dma_pool_create("nvme small pool(256)", dmadev,
+								256, 256, 0);
+	if (!dev->small_pool) {
+		dma_pool_destroy(dev->page_pool);
 		return -ENOMEM;
 	}
 	return 0;
 }
 
-static void nvme_release_prp_pools(struct nvme_dev *dev)
+static void nvme_release_dma_pools(struct nvme_dev *dev)
 {
-	dma_pool_destroy(dev->prp_page_pool);
-	dma_pool_destroy(dev->prp_small_pool);
+	dma_pool_destroy(dev->page_pool);
+	dma_pool_destroy(dev->small_pool);
 }
 
 static DEFINE_IDA(nvme_instance_ida);
@@ -2074,7 +2276,7 @@ static void nvme_free_dev(struct kref *kref)
 	nvme_dev_shutdown(dev);
 	nvme_free_queues(dev);
 	nvme_release_instance(dev);
-	nvme_release_prp_pools(dev);
+	nvme_release_dma_pools(dev);
 	kfree(dev->queues);
 	kfree(dev->entry);
 	kfree(dev);
@@ -2170,7 +2372,7 @@ static int nvme_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (result)
 		goto free;
 
-	result = nvme_setup_prp_pools(dev);
+	result = nvme_setup_dma_pools(dev);
 	if (result)
 		goto release;
 
@@ -2204,7 +2406,7 @@ static int nvme_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	nvme_dev_shutdown(dev);
  release_pools:
 	nvme_free_queues(dev);
-	nvme_release_prp_pools(dev);
+	nvme_release_dma_pools(dev);
  release:
 	nvme_release_instance(dev);
  free:
diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index 26ebcf4..6032b7c 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -68,6 +68,8 @@ enum {
 
 #define NVME_IO_TIMEOUT	(5 * HZ)
 
+#define NVME_CTRL_SUPP_SGL(sgls)	(sgls & 1)
+
 /*
  * Represents an NVM Express device.  Each nvme_dev is a PCI function.
  */
@@ -76,8 +78,8 @@ struct nvme_dev {
 	struct nvme_queue **queues;
 	u32 __iomem *dbs;
 	struct pci_dev *pci_dev;
-	struct dma_pool *prp_page_pool;
-	struct dma_pool *prp_small_pool;
+	struct dma_pool *page_pool;
+	struct dma_pool *small_pool;
 	int instance;
 	int queue_count;
 	int db_stride;
@@ -94,6 +96,7 @@ struct nvme_dev {
 	u32 max_hw_sectors;
 	u32 stripe_size;
 	u16 oncs;
+	u32 sgls;
 };
 
 /*
@@ -141,11 +144,13 @@ static inline u64 nvme_block_nr(struct nvme_ns *ns, sector_t sector)
  * @iod: The memory to free
  */
 void nvme_free_iod(struct nvme_dev *dev, struct nvme_iod *iod);
-
+void nvme_free_iod_sgl(struct nvme_dev *dev, struct nvme_iod *iod);
 int nvme_setup_prps(struct nvme_dev *dev, struct nvme_common_command *cmd,
 			struct nvme_iod *iod, int total_len, gfp_t gfp);
+int nvme_setup_sgls(struct nvme_dev *dev, struct nvme_common_command *cmd,
+			struct nvme_iod *iod, int total_len, gfp_t gfp);
 struct nvme_iod *nvme_map_user_pages(struct nvme_dev *dev, int write,
-				unsigned long addr, unsigned length);
+		unsigned long addr, unsigned length, unsigned type);
 void nvme_unmap_user_pages(struct nvme_dev *dev, int write,
 			struct nvme_iod *iod);
 struct nvme_queue *get_nvmeq(struct nvme_dev *dev);
diff --git a/include/uapi/linux/nvme.h b/include/uapi/linux/nvme.h
index 989c04e..1570a5c 100644
--- a/include/uapi/linux/nvme.h
+++ b/include/uapi/linux/nvme.h
@@ -68,7 +68,9 @@ struct nvme_id_ctrl {
 	__u8			vwc;
 	__le16			awun;
 	__le16			awupf;
-	__u8			rsvd530[1518];
+	__u8			rsvd530[6];
+	__le32			sgls;
+	__u8			rsvd540[1508];
 	struct nvme_id_power_state	psd[32];
 	__u8			vs[1024];
 };
@@ -168,6 +170,31 @@ enum nvme_opcode {
 	nvme_cmd_dsm		= 0x09,
 };
 
+#define PRP	0
+#define SGL	1
+
+#define SGL_DATA_DESC		0x00
+#define SGL_SEG_DESC		0x02
+#define SGL_LAST_SEG_DESC	0x03
+
+struct sgl_desc {
+	__le64 addr;
+	__le32  length;
+	__u8    rsvd[3];
+	__u8    zero:4;
+	__u8    sg_id:4;
+};
+
+struct prp_list {
+	__le64  prp1;
+	__le64  prp2;
+};
+
+union data_buffer {
+	struct sgl_desc sgl;
+	struct prp_list prp;
+};
+
 struct nvme_common_command {
 	__u8			opcode;
 	__u8			flags;
@@ -175,8 +202,7 @@ struct nvme_common_command {
 	__le32			nsid;
 	__le32			cdw2[2];
 	__le64			metadata;
-	__le64			prp1;
-	__le64			prp2;
+	union data_buffer	buffer;
 	__le32			cdw10[6];
 };
 
@@ -474,4 +500,6 @@ struct nvme_admin_cmd {
 #define NVME_IOCTL_ADMIN_CMD	_IOWR('N', 0x41, struct nvme_admin_cmd)
 #define NVME_IOCTL_SUBMIT_IO	_IOW('N', 0x42, struct nvme_user_io)
 
+#define NVME_CHECK_DATA_XFER(flags)	((flags >> 7) & 1)
+
 #endif /* _UAPI_LINUX_NVME_H */
-- 
1.7.1

