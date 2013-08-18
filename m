Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab3HRCrp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 22:47:45 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33938 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229Ab3HRCnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 22:43:35 -0400
From: Joel Fernandes <joelf@ti.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Greer <mgreer@animalcreek.com>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rajendra Nayak <rnayak@ti.com>, Lokesh Vutla <lokeshvutla@ti.com>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Joel Fernandes <joelf@ti.com>
Subject: [PATCH v2 11/14] crypto: omap-aes: Add support for cases of unaligned lengths
Date: Sat, 17 Aug 2013 21:42:32 -0500
Message-ID: <1376793755-30478-12-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376793755-30478-1-git-send-email-joelf@ti.com>
References: <1376793755-30478-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For cases where offset/length of on any page of the input SG is not aligned by
AES_BLOCK_SIZE, we copy all the pages from the input SG list into a contiguous
buffer and prepare a single element SG list for this buffer with length as the
total bytes to crypt.

This is requried for cases such as when an SG list of 16 bytes total size
contains 16 pages each containing 1 byte. DMA using the direct buffers of such
instances is not possible.

For this purpose, we first detect if the unaligned case and accordingly
allocate enough number of pages to satisfy the request and prepare SG lists.
We then copy data into the buffer, and copy data out of it on completion.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 drivers/crypto/omap-aes.c |   86 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 83 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index d214dbf..cbeaaf4 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -157,9 +157,23 @@ struct omap_aes_dev {
 	struct tasklet_struct	queue_task;
 
 	struct ablkcipher_request	*req;
+
+	/*
+	 * total is used by PIO mode for book keeping so introduce
+	 * variable total_save as need it to calc page_order
+	 */
 	size_t				total;
+	size_t				total_save;
+
 	struct scatterlist		*in_sg;
 	struct scatterlist		*out_sg;
+
+	/* Buffers for copying for unaligned cases */
+	struct scatterlist		in_sgl;
+	struct scatterlist		out_sgl;
+	struct scatterlist		*orig_out;
+	int				sgs_copied;
+
 	struct scatter_walk		in_walk;
 	struct scatter_walk		out_walk;
 	int			dma_in;
@@ -543,12 +557,51 @@ static int omap_aes_crypt_dma_stop(struct omap_aes_dev *dd)
 	dmaengine_terminate_all(dd->dma_lch_in);
 	dmaengine_terminate_all(dd->dma_lch_out);
 
-	dma_unmap_sg(dd->dev, dd->in_sg, dd->in_sg_len, DMA_TO_DEVICE);
-	dma_unmap_sg(dd->dev, dd->out_sg, dd->out_sg_len, DMA_FROM_DEVICE);
-
 	return err;
 }
 
+int omap_aes_check_aligned(struct scatterlist *sg)
+{
+	while (sg) {
+		if (!IS_ALIGNED(sg->offset, 4))
+			return -1;
+		if (!IS_ALIGNED(sg->length, AES_BLOCK_SIZE))
+			return -1;
+		sg = sg_next(sg);
+	}
+	return 0;
+}
+
+int omap_aes_copy_sgs(struct omap_aes_dev *dd)
+{
+	void *buf_in, *buf_out;
+	int pages;
+
+	pages = get_order(dd->total);
+
+	buf_in = (void *)__get_free_pages(GFP_ATOMIC, pages);
+	buf_out = (void *)__get_free_pages(GFP_ATOMIC, pages);
+
+	if (!buf_in || !buf_out) {
+		pr_err("Couldn't allocated pages for unaligned cases.\n");
+		return -1;
+	}
+
+	dd->orig_out = dd->out_sg;
+
+	sg_copy_buf(buf_in, dd->in_sg, 0, dd->total, 0);
+
+	sg_init_table(&dd->in_sgl, 1);
+	sg_set_buf(&dd->in_sgl, buf_in, dd->total);
+	dd->in_sg = &dd->in_sgl;
+
+	sg_init_table(&dd->out_sgl, 1);
+	sg_set_buf(&dd->out_sgl, buf_out, dd->total);
+	dd->out_sg = &dd->out_sgl;
+
+	return 0;
+}
+
 static int omap_aes_handle_queue(struct omap_aes_dev *dd,
 			       struct ablkcipher_request *req)
 {
@@ -582,9 +635,19 @@ static int omap_aes_handle_queue(struct omap_aes_dev *dd,
 	/* assign new request to device */
 	dd->req = req;
 	dd->total = req->nbytes;
+	dd->total_save = req->nbytes;
 	dd->in_sg = req->src;
 	dd->out_sg = req->dst;
 
+	if (omap_aes_check_aligned(dd->in_sg) ||
+	    omap_aes_check_aligned(dd->out_sg)) {
+		if (omap_aes_copy_sgs(dd))
+			pr_err("Failed to copy SGs for unaligned cases\n");
+		dd->sgs_copied = 1;
+	} else {
+		dd->sgs_copied = 0;
+	}
+
 	dd->in_sg_len = scatterwalk_bytes_sglen(dd->in_sg, dd->total);
 	dd->out_sg_len = scatterwalk_bytes_sglen(dd->out_sg, dd->total);
 	BUG_ON(dd->in_sg_len < 0 || dd->out_sg_len < 0);
@@ -612,14 +675,31 @@ static int omap_aes_handle_queue(struct omap_aes_dev *dd,
 static void omap_aes_done_task(unsigned long data)
 {
 	struct omap_aes_dev *dd = (struct omap_aes_dev *)data;
+	void *buf_in, *buf_out;
+	int pages;
 
 	pr_debug("enter done_task\n");
 
 	if (!dd->pio_only) {
 		dma_sync_sg_for_device(dd->dev, dd->out_sg, dd->out_sg_len,
 				       DMA_FROM_DEVICE);
+		dma_unmap_sg(dd->dev, dd->in_sg, dd->in_sg_len, DMA_TO_DEVICE);
+		dma_unmap_sg(dd->dev, dd->out_sg, dd->out_sg_len,
+			     DMA_FROM_DEVICE);
 		omap_aes_crypt_dma_stop(dd);
 	}
+
+	if (dd->sgs_copied) {
+		buf_in = sg_virt(&dd->in_sgl);
+		buf_out = sg_virt(&dd->out_sgl);
+
+		sg_copy_buf(buf_out, dd->orig_out, 0, dd->total_save, 1);
+
+		pages = get_order(dd->total_save);
+		free_pages((unsigned long)buf_in, pages);
+		free_pages((unsigned long)buf_out, pages);
+	}
+
 	omap_aes_finish_req(dd, 0);
 	omap_aes_handle_queue(dd, NULL);
 
-- 
1.7.9.5

