Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbaKWOYS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 09:24:18 -0500
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:54148 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751849AbaKWOYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 09:24:15 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: "Ira W. Snyder" <iws@ovro.caltech.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/3] carma-fpga: drop videobuf dependency
Date: Sun, 23 Nov 2014 15:23:49 +0100
Message-Id: <1416752630-47360-3-git-send-email-hverkuil@xs4all.nl>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1416752630-47360-1-git-send-email-hverkuil@xs4all.nl>
References: <1416752630-47360-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans Verkuil <hans.verkuil@cisco.com>

This driver abuses videobuf helper functions. This is a bad idea
because:

1) this driver is completely unrelated to media drivers
2) the videobuf API is deprecated and will be removed eventually

This patch replaces the videobuf functions with the normal DMA kernel
API.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/misc/carma/Kconfig      |  3 +-
 drivers/misc/carma/carma-fpga.c | 98 ++++++++++++++++++++++++++++++++++-------
 2 files changed, 82 insertions(+), 19 deletions(-)

diff --git a/drivers/misc/carma/Kconfig b/drivers/misc/carma/Kconfig
index c90370e..c6047fb 100644
--- a/drivers/misc/carma/Kconfig
+++ b/drivers/misc/carma/Kconfig
@@ -1,7 +1,6 @@
 config CARMA_FPGA
 	tristate "CARMA DATA-FPGA Access Driver"
-	depends on FSL_SOC && PPC_83xx && MEDIA_SUPPORT && HAS_DMA && FSL_DMA
-	select VIDEOBUF_DMA_SG
+	depends on FSL_SOC && PPC_83xx && HAS_DMA && FSL_DMA
 	default n
 	help
 	  Say Y here to include support for communicating with the data
diff --git a/drivers/misc/carma/carma-fpga.c b/drivers/misc/carma/carma-fpga.c
index 55e913b..5b12149 100644
--- a/drivers/misc/carma/carma-fpga.c
+++ b/drivers/misc/carma/carma-fpga.c
@@ -98,6 +98,7 @@
 #include <linux/seq_file.h>
 #include <linux/highmem.h>
 #include <linux/debugfs.h>
+#include <linux/vmalloc.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/poll.h>
@@ -105,8 +106,6 @@
 #include <linux/kref.h>
 #include <linux/io.h>
 
-#include <media/videobuf-dma-sg.h>
-
 /* system controller registers */
 #define SYS_IRQ_SOURCE_CTL	0x24
 #define SYS_IRQ_OUTPUT_EN	0x28
@@ -142,7 +141,10 @@ struct fpga_info {
 
 struct data_buf {
 	struct list_head entry;
-	struct videobuf_dmabuf vb;
+	void *vaddr;
+	struct scatterlist *sglist;
+	int sglen;
+	int nr_pages;
 	size_t size;
 };
 
@@ -207,6 +209,68 @@ static void fpga_device_release(struct kref *ref)
  * Data Buffer Allocation Helpers
  */
 
+static int carma_dma_init(struct data_buf *buf, int nr_pages)
+{
+	struct page *pg;
+	int i;
+
+	buf->vaddr = vmalloc_32(nr_pages << PAGE_SHIFT);
+	if (NULL == buf->vaddr) {
+		pr_debug("vmalloc_32(%d pages) failed\n", nr_pages);
+		return -ENOMEM;
+	}
+
+	pr_debug("vmalloc is at addr 0x%08lx, size=%d\n",
+				(unsigned long)buf->vaddr,
+				nr_pages << PAGE_SHIFT);
+
+	memset(buf->vaddr, 0, nr_pages << PAGE_SHIFT);
+	buf->nr_pages = nr_pages;
+
+	buf->sglist = vzalloc(buf->nr_pages * sizeof(*buf->sglist));
+	if (NULL == buf->sglist)
+		goto vzalloc_err;
+
+	sg_init_table(buf->sglist, buf->nr_pages);
+	for (i = 0; i < buf->nr_pages; i++) {
+		pg = vmalloc_to_page(buf->vaddr + i * PAGE_SIZE);
+		if (NULL == pg)
+			goto vmalloc_to_page_err;
+		sg_set_page(&buf->sglist[i], pg, PAGE_SIZE, 0);
+	}
+	return 0;
+
+vmalloc_to_page_err:
+	vfree(buf->sglist);
+	buf->sglist = NULL;
+vzalloc_err:
+	vfree(buf->vaddr);
+	buf->vaddr = NULL;
+	return -ENOMEM;
+}
+
+static int carma_dma_map(struct device *dev, struct data_buf *buf)
+{
+	buf->sglen = dma_map_sg(dev, buf->sglist,
+			buf->nr_pages, DMA_FROM_DEVICE);
+
+	if (0 == buf->sglen) {
+		pr_warn("%s: dma_map_sg failed\n", __func__);
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+static int carma_dma_unmap(struct device *dev, struct data_buf *buf)
+{
+	if (!buf->sglen)
+		return 0;
+
+	dma_unmap_sg(dev, buf->sglist, buf->sglen, DMA_FROM_DEVICE);
+	buf->sglen = 0;
+	return 0;
+}
+
 /**
  * data_free_buffer() - free a single data buffer and all allocated memory
  * @buf: the buffer to free
@@ -221,7 +285,8 @@ static void data_free_buffer(struct data_buf *buf)
 		return;
 
 	/* free all memory */
-	videobuf_dma_free(&buf->vb);
+	vfree(buf->sglist);
+	vfree(buf->vaddr);
 	kfree(buf);
 }
 
@@ -230,7 +295,7 @@ static void data_free_buffer(struct data_buf *buf)
  * @bytes: the number of bytes required
  *
  * This allocates all space needed for a data buffer. It must be mapped before
- * use in a DMA transaction using videobuf_dma_map().
+ * use in a DMA transaction using carma_dma_map().
  *
  * Returns NULL on failure
  */
@@ -252,9 +317,8 @@ static struct data_buf *data_alloc_buffer(const size_t bytes)
 	INIT_LIST_HEAD(&buf->entry);
 	buf->size = bytes;
 
-	/* allocate the videobuf */
-	videobuf_dma_init(&buf->vb);
-	ret = videobuf_dma_init_kernel(&buf->vb, DMA_FROM_DEVICE, nr_pages);
+	/* allocate the buffer */
+	ret = carma_dma_init(buf, nr_pages);
 	if (ret)
 		goto out_free_buf;
 
@@ -285,13 +349,13 @@ static void data_free_buffers(struct fpga_device *priv)
 
 	list_for_each_entry_safe(buf, tmp, &priv->free, entry) {
 		list_del_init(&buf->entry);
-		videobuf_dma_unmap(priv->dev, &buf->vb);
+		carma_dma_unmap(priv->dev, buf);
 		data_free_buffer(buf);
 	}
 
 	list_for_each_entry_safe(buf, tmp, &priv->used, entry) {
 		list_del_init(&buf->entry);
-		videobuf_dma_unmap(priv->dev, &buf->vb);
+		carma_dma_unmap(priv->dev, buf);
 		data_free_buffer(buf);
 	}
 
@@ -330,7 +394,7 @@ static int data_alloc_buffers(struct fpga_device *priv)
 			break;
 
 		/* map it for DMA */
-		ret = videobuf_dma_map(priv->dev, &buf->vb);
+		ret = carma_dma_map(priv->dev, buf);
 		if (ret) {
 			data_free_buffer(buf);
 			break;
@@ -634,8 +698,8 @@ static int data_submit_dma(struct fpga_device *priv, struct data_buf *buf)
 	dma_addr_t dst, src;
 	unsigned long dma_flags = 0;
 
-	dst_sg = buf->vb.sglist;
-	dst_nents = buf->vb.sglen;
+	dst_sg = buf->sglist;
+	dst_nents = buf->sglen;
 
 	src_sg = priv->corl_table.sgl;
 	src_nents = priv->corl_nents;
@@ -1134,7 +1198,7 @@ static ssize_t data_read(struct file *filp, char __user *ubuf, size_t count,
 	spin_unlock_irq(&priv->lock);
 
 	/* Buffers are always mapped: unmap it */
-	videobuf_dma_unmap(priv->dev, &dbuf->vb);
+	carma_dma_unmap(priv->dev, dbuf);
 
 	/* save the buffer for later */
 	reader->buf = dbuf;
@@ -1143,7 +1207,7 @@ static ssize_t data_read(struct file *filp, char __user *ubuf, size_t count,
 have_buffer:
 	/* Get the number of bytes available */
 	avail = dbuf->size - reader->buf_start;
-	data = dbuf->vb.vaddr + reader->buf_start;
+	data = dbuf->vaddr + reader->buf_start;
 
 	/* Get the number of bytes we can transfer */
 	count = min(count, avail);
@@ -1171,7 +1235,7 @@ have_buffer:
 	 * If it fails, we pretend that the read never happed and return
 	 * -EFAULT to userspace. The read will be retried.
 	 */
-	ret = videobuf_dma_map(priv->dev, &dbuf->vb);
+	ret = carma_dma_map(priv->dev, dbuf);
 	if (ret) {
 		dev_err(priv->dev, "unable to remap buffer for DMA\n");
 		return -EFAULT;
@@ -1203,7 +1267,7 @@ out_unlock:
 	spin_unlock_irq(&priv->lock);
 
 	if (drop_buffer) {
-		videobuf_dma_unmap(priv->dev, &dbuf->vb);
+		carma_dma_unmap(priv->dev, dbuf);
 		data_free_buffer(dbuf);
 	}
 
-- 
2.1.3

