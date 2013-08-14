Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933579Ab3HNXNy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 19:13:54 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36404 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933329Ab3HNXNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 19:13:48 -0400
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
Subject: [PATCH 06/10] crypto: omap-aes: Remove previously used intermediate buffers
Date: Wed, 14 Aug 2013 18:12:45 -0500
Message-ID: <1376521969-16807-7-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376521969-16807-1-git-send-email-joelf@ti.com>
References: <1376521969-16807-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intermdiate buffers were allocated, mapped and used for DMA.
These are no longer required as we use the SGs from crypto layer
directly in previous commits in the series. Also along with it,
remove the logic for copying SGs etc as they are no longer used,
and all the associated variables in omap_aes_device.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 drivers/crypto/omap-aes.c |   90 ---------------------------------------------
 1 file changed, 90 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index df2f867..71da52b 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -156,25 +156,13 @@ struct omap_aes_dev {
 	struct ablkcipher_request	*req;
 	size_t				total;
 	struct scatterlist		*in_sg;
-	struct scatterlist		in_sgl;
-	size_t				in_offset;
 	struct scatterlist		*out_sg;
-	struct scatterlist		out_sgl;
-	size_t				out_offset;
-
-	size_t			buflen;
-	void			*buf_in;
-	size_t			dma_size;
 	int			dma_in;
 	struct dma_chan		*dma_lch_in;
-	dma_addr_t		dma_addr_in;
-	void			*buf_out;
 	int			dma_out;
 	struct dma_chan		*dma_lch_out;
 	int			in_sg_len;
 	int			out_sg_len;
-	dma_addr_t		dma_addr_out;
-
 	const struct omap_aes_pdata	*pdata;
 };
 
@@ -362,33 +350,6 @@ static int omap_aes_dma_init(struct omap_aes_dev *dd)
 	dd->dma_lch_out = NULL;
 	dd->dma_lch_in = NULL;
 
-	dd->buf_in = (void *)__get_free_pages(GFP_KERNEL, OMAP_AES_CACHE_SIZE);
-	dd->buf_out = (void *)__get_free_pages(GFP_KERNEL, OMAP_AES_CACHE_SIZE);
-	dd->buflen = PAGE_SIZE << OMAP_AES_CACHE_SIZE;
-	dd->buflen &= ~(AES_BLOCK_SIZE - 1);
-
-	if (!dd->buf_in || !dd->buf_out) {
-		dev_err(dd->dev, "unable to alloc pages.\n");
-		goto err_alloc;
-	}
-
-	/* MAP here */
-	dd->dma_addr_in = dma_map_single(dd->dev, dd->buf_in, dd->buflen,
-					 DMA_TO_DEVICE);
-	if (dma_mapping_error(dd->dev, dd->dma_addr_in)) {
-		dev_err(dd->dev, "dma %d bytes error\n", dd->buflen);
-		err = -EINVAL;
-		goto err_map_in;
-	}
-
-	dd->dma_addr_out = dma_map_single(dd->dev, dd->buf_out, dd->buflen,
-					  DMA_FROM_DEVICE);
-	if (dma_mapping_error(dd->dev, dd->dma_addr_out)) {
-		dev_err(dd->dev, "dma %d bytes error\n", dd->buflen);
-		err = -EINVAL;
-		goto err_map_out;
-	}
-
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_SLAVE, mask);
 
@@ -415,14 +376,6 @@ static int omap_aes_dma_init(struct omap_aes_dev *dd)
 err_dma_out:
 	dma_release_channel(dd->dma_lch_in);
 err_dma_in:
-	dma_unmap_single(dd->dev, dd->dma_addr_out, dd->buflen,
-			 DMA_FROM_DEVICE);
-err_map_out:
-	dma_unmap_single(dd->dev, dd->dma_addr_in, dd->buflen, DMA_TO_DEVICE);
-err_map_in:
-	free_pages((unsigned long)dd->buf_out, OMAP_AES_CACHE_SIZE);
-	free_pages((unsigned long)dd->buf_in, OMAP_AES_CACHE_SIZE);
-err_alloc:
 	if (err)
 		pr_err("error: %d\n", err);
 	return err;
@@ -432,11 +385,6 @@ static void omap_aes_dma_cleanup(struct omap_aes_dev *dd)
 {
 	dma_release_channel(dd->dma_lch_out);
 	dma_release_channel(dd->dma_lch_in);
-	dma_unmap_single(dd->dev, dd->dma_addr_out, dd->buflen,
-			 DMA_FROM_DEVICE);
-	dma_unmap_single(dd->dev, dd->dma_addr_in, dd->buflen, DMA_TO_DEVICE);
-	free_pages((unsigned long)dd->buf_out, OMAP_AES_CACHE_SIZE);
-	free_pages((unsigned long)dd->buf_in, OMAP_AES_CACHE_SIZE);
 }
 
 static void sg_copy_buf(void *buf, struct scatterlist *sg,
@@ -453,42 +401,6 @@ static void sg_copy_buf(void *buf, struct scatterlist *sg,
 	scatterwalk_done(&walk, out, 0);
 }
 
-static int sg_copy(struct scatterlist **sg, size_t *offset, void *buf,
-		   size_t buflen, size_t total, int out)
-{
-	unsigned int count, off = 0;
-
-	while (buflen && total) {
-		count = min((*sg)->length - *offset, total);
-		count = min(count, buflen);
-
-		if (!count)
-			return off;
-
-		/*
-		 * buflen and total are AES_BLOCK_SIZE size aligned,
-		 * so count should be also aligned
-		 */
-
-		sg_copy_buf(buf + off, *sg, *offset, count, out);
-
-		off += count;
-		buflen -= count;
-		*offset += count;
-		total -= count;
-
-		if (*offset == (*sg)->length) {
-			*sg = sg_next(*sg);
-			if (*sg)
-				*offset = 0;
-			else
-				total = 0;
-		}
-	}
-
-	return off;
-}
-
 static int omap_aes_crypt_dma(struct crypto_tfm *tfm,
 		struct scatterlist *in_sg, struct scatterlist *out_sg,
 		int in_sg_len, int out_sg_len)
@@ -653,9 +565,7 @@ static int omap_aes_handle_queue(struct omap_aes_dev *dd,
 	/* assign new request to device */
 	dd->req = req;
 	dd->total = req->nbytes;
-	dd->in_offset = 0;
 	dd->in_sg = req->src;
-	dd->out_offset = 0;
 	dd->out_sg = req->dst;
 
 	dd->in_sg_len = scatterwalk_bytes_sglen(dd->in_sg, dd->total);
-- 
1.7.9.5

