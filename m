Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbaKWOY0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 09:24:26 -0500
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:54148 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751849AbaKWOYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 09:24:23 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: "Ira W. Snyder" <iws@ovro.caltech.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/3] carma-fpga-program: drop videobuf dependency
Date: Sun, 23 Nov 2014 15:23:50 +0100
Message-Id: <1416752630-47360-4-git-send-email-hverkuil@xs4all.nl>
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
 drivers/misc/carma/Kconfig              |  3 +-
 drivers/misc/carma/carma-fpga-program.c | 97 +++++++++++++++++++++++++++------
 2 files changed, 81 insertions(+), 19 deletions(-)

diff --git a/drivers/misc/carma/Kconfig b/drivers/misc/carma/Kconfig
index c6047fb..295882b 100644
--- a/drivers/misc/carma/Kconfig
+++ b/drivers/misc/carma/Kconfig
@@ -8,8 +8,7 @@ config CARMA_FPGA
 
 config CARMA_FPGA_PROGRAM
 	tristate "CARMA DATA-FPGA Programmer"
-	depends on FSL_SOC && PPC_83xx && MEDIA_SUPPORT && HAS_DMA && FSL_DMA
-	select VIDEOBUF_DMA_SG
+	depends on FSL_SOC && PPC_83xx && HAS_DMA && FSL_DMA
 	default n
 	help
 	  Say Y here to include support for programming the data processing
diff --git a/drivers/misc/carma/carma-fpga-program.c b/drivers/misc/carma/carma-fpga-program.c
index eb8942b..a7496e3 100644
--- a/drivers/misc/carma/carma-fpga-program.c
+++ b/drivers/misc/carma/carma-fpga-program.c
@@ -19,6 +19,7 @@
 #include <linux/fsldma.h>
 #include <linux/interrupt.h>
 #include <linux/highmem.h>
+#include <linux/vmalloc.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
@@ -30,8 +31,6 @@
 #include <linux/fs.h>
 #include <linux/io.h>
 
-#include <media/videobuf-dma-sg.h>
-
 /* MPC8349EMDS specific get_immrbase() */
 #include <sysdev/fsl_soc.h>
 
@@ -67,14 +66,79 @@ struct fpga_dev {
 	/* FPGA Bitfile */
 	struct mutex lock;
 
-	struct videobuf_dmabuf vb;
-	bool vb_allocated;
+	void *vaddr;
+	struct scatterlist *sglist;
+	int sglen;
+	int nr_pages;
+	bool buf_allocated;
 
 	/* max size and written bytes */
 	size_t fw_size;
 	size_t bytes;
 };
 
+static int fpga_dma_init(struct fpga_dev *priv, int nr_pages)
+{
+	struct page *pg;
+	int i;
+
+	priv->vaddr = vmalloc_32(nr_pages << PAGE_SHIFT);
+	if (NULL == priv->vaddr) {
+		pr_debug("vmalloc_32(%d pages) failed\n", nr_pages);
+		return -ENOMEM;
+	}
+
+	pr_debug("vmalloc is at addr 0x%08lx, size=%d\n",
+				(unsigned long)priv->vaddr,
+				nr_pages << PAGE_SHIFT);
+
+	memset(priv->vaddr, 0, nr_pages << PAGE_SHIFT);
+	priv->nr_pages = nr_pages;
+
+	priv->sglist = vzalloc(priv->nr_pages * sizeof(*priv->sglist));
+	if (NULL == priv->sglist)
+		goto vzalloc_err;
+
+	sg_init_table(priv->sglist, priv->nr_pages);
+	for (i = 0; i < priv->nr_pages; i++) {
+		pg = vmalloc_to_page(priv->vaddr + i * PAGE_SIZE);
+		if (NULL == pg)
+			goto vmalloc_to_page_err;
+		sg_set_page(&priv->sglist[i], pg, PAGE_SIZE, 0);
+	}
+	return 0;
+
+vmalloc_to_page_err:
+	vfree(priv->sglist);
+	priv->sglist = NULL;
+vzalloc_err:
+	vfree(priv->vaddr);
+	priv->vaddr = NULL;
+	return -ENOMEM;
+}
+
+static int fpga_dma_map(struct fpga_dev *priv)
+{
+	priv->sglen = dma_map_sg(priv->dev, priv->sglist,
+			priv->nr_pages, DMA_TO_DEVICE);
+
+	if (0 == priv->sglen) {
+		pr_warn("%s: dma_map_sg failed\n", __func__);
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+static int fpga_dma_unmap(struct fpga_dev *priv)
+{
+	if (!priv->sglen)
+		return 0;
+
+	dma_unmap_sg(priv->dev, priv->sglist, priv->sglen, DMA_TO_DEVICE);
+	priv->sglen = 0;
+	return 0;
+}
+
 /*
  * FPGA Bitfile Helpers
  */
@@ -87,8 +151,9 @@ struct fpga_dev {
  */
 static void fpga_drop_firmware_data(struct fpga_dev *priv)
 {
-	videobuf_dma_free(&priv->vb);
-	priv->vb_allocated = false;
+	vfree(priv->sglist);
+	vfree(priv->vaddr);
+	priv->buf_allocated = false;
 	priv->bytes = 0;
 }
 
@@ -427,7 +492,7 @@ static noinline int fpga_program_cpu(struct fpga_dev *priv)
 	dev_dbg(priv->dev, "enabled the controller\n");
 
 	/* Write each chunk of the FPGA bitfile to FPGA programmer */
-	ret = fpga_program_block(priv, priv->vb.vaddr, priv->bytes);
+	ret = fpga_program_block(priv, priv->vaddr, priv->bytes);
 	if (ret)
 		goto out_disable_controller;
 
@@ -463,7 +528,6 @@ out_disable_controller:
  */
 static noinline int fpga_program_dma(struct fpga_dev *priv)
 {
-	struct videobuf_dmabuf *vb = &priv->vb;
 	struct dma_chan *chan = priv->chan;
 	struct dma_async_tx_descriptor *tx;
 	size_t num_pages, len, avail = 0;
@@ -505,7 +569,7 @@ static noinline int fpga_program_dma(struct fpga_dev *priv)
 	}
 
 	/* Map the buffer for DMA */
-	ret = videobuf_dma_map(priv->dev, &priv->vb);
+	ret = fpga_dma_map(priv);
 	if (ret) {
 		dev_err(priv->dev, "Unable to map buffer for DMA\n");
 		goto out_free_table;
@@ -534,7 +598,7 @@ static noinline int fpga_program_dma(struct fpga_dev *priv)
 	/* setup and submit the DMA transaction */
 
 	tx = dmaengine_prep_dma_sg(chan, table.sgl, num_pages,
-			vb->sglist, vb->sglen, 0);
+			priv->sglist, priv->sglen, 0);
 	if (!tx) {
 		dev_err(priv->dev, "Unable to prep DMA transaction\n");
 		ret = -ENOMEM;
@@ -572,7 +636,7 @@ static noinline int fpga_program_dma(struct fpga_dev *priv)
 out_disable_controller:
 	fpga_programmer_disable(priv);
 out_dma_unmap:
-	videobuf_dma_unmap(priv->dev, vb);
+	fpga_dma_unmap(priv);
 out_free_table:
 	sg_free_table(&table);
 out_return:
@@ -702,12 +766,12 @@ static int fpga_open(struct inode *inode, struct file *filp)
 		priv->bytes = 0;
 
 	/* Check if we have already allocated a buffer */
-	if (priv->vb_allocated)
+	if (priv->buf_allocated)
 		return 0;
 
 	/* Allocate a buffer to hold enough data for the bitfile */
 	nr_pages = DIV_ROUND_UP(priv->fw_size, PAGE_SIZE);
-	ret = videobuf_dma_init_kernel(&priv->vb, DMA_TO_DEVICE, nr_pages);
+	ret = fpga_dma_init(priv, nr_pages);
 	if (ret) {
 		dev_err(priv->dev, "unable to allocate data buffer\n");
 		mutex_unlock(&priv->lock);
@@ -715,7 +779,7 @@ static int fpga_open(struct inode *inode, struct file *filp)
 		return ret;
 	}
 
-	priv->vb_allocated = true;
+	priv->buf_allocated = true;
 	return 0;
 }
 
@@ -738,7 +802,7 @@ static ssize_t fpga_write(struct file *filp, const char __user *buf,
 		return -ENOSPC;
 
 	count = min_t(size_t, priv->fw_size - priv->bytes, count);
-	if (copy_from_user(priv->vb.vaddr + priv->bytes, buf, count))
+	if (copy_from_user(priv->vaddr + priv->bytes, buf, count))
 		return -EFAULT;
 
 	priv->bytes += count;
@@ -750,7 +814,7 @@ static ssize_t fpga_read(struct file *filp, char __user *buf, size_t count,
 {
 	struct fpga_dev *priv = filp->private_data;
 	return simple_read_from_buffer(buf, count, f_pos,
-				       priv->vb.vaddr, priv->bytes);
+				       priv->vaddr, priv->bytes);
 }
 
 static loff_t fpga_llseek(struct file *filp, loff_t offset, int origin)
@@ -952,7 +1016,6 @@ static int fpga_of_probe(struct platform_device *op)
 	priv->dev = &op->dev;
 	mutex_init(&priv->lock);
 	init_completion(&priv->completion);
-	videobuf_dma_init(&priv->vb);
 
 	dev_set_drvdata(priv->dev, priv);
 	dma_cap_zero(mask);
-- 
2.1.3

