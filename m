Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933509Ab3HNXPz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 19:15:55 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39236 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933495Ab3HNXNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 19:13:43 -0400
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
Subject: [PATCH 09/10] crypto: omap-aes: PIO mode: platform data for OMAP4 and trigger it
Date: Wed, 14 Aug 2013 18:12:48 -0500
Message-ID: <1376521969-16807-10-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376521969-16807-1-git-send-email-joelf@ti.com>
References: <1376521969-16807-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We initialize the scatter gather walk lists needed for PIO mode
and avoid all DMA paths such as mapping/unmapping buffers by
checking for the pio_only flag.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 drivers/crypto/omap-aes.c |   43 ++++++++++++++++++++++++++++++-------------
 1 file changed, 30 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 891455b..54f2729 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -175,6 +175,7 @@ struct omap_aes_dev {
 	struct dma_chan		*dma_lch_out;
 	int			in_sg_len;
 	int			out_sg_len;
+	int			pio_only;
 	const struct omap_aes_pdata	*pdata;
 };
 
@@ -423,6 +424,16 @@ static int omap_aes_crypt_dma(struct crypto_tfm *tfm,
 	struct dma_slave_config cfg;
 	int ret;
 
+	if (dd->pio_only) {
+		scatterwalk_start(&dd->in_walk, dd->in_sg);
+		scatterwalk_start(&dd->out_walk, dd->out_sg);
+
+		/* Enable DATAIN interrupt and let it take
+		   care of the rest */
+		omap_aes_write(dd, AES_REG_IRQ_ENABLE(dd), 0x2);
+		return 0;
+	}
+
 	dma_sync_sg_for_device(dd->dev, dd->in_sg, in_sg_len, DMA_TO_DEVICE);
 
 	memset(&cfg, 0, sizeof(cfg));
@@ -492,21 +503,25 @@ static int omap_aes_crypt_dma_start(struct omap_aes_dev *dd)
 
 	pr_debug("total: %d\n", dd->total);
 
-	err = dma_map_sg(dd->dev, dd->in_sg, dd->in_sg_len, DMA_TO_DEVICE);
-	if (!err) {
-		dev_err(dd->dev, "dma_map_sg() error\n");
-		return -EINVAL;
-	}
+	if (!dd->pio_only) {
+		err = dma_map_sg(dd->dev, dd->in_sg, dd->in_sg_len,
+				 DMA_TO_DEVICE);
+		if (!err) {
+			dev_err(dd->dev, "dma_map_sg() error\n");
+			return -EINVAL;
+		}
 
-	err = dma_map_sg(dd->dev, dd->out_sg, dd->out_sg_len, DMA_FROM_DEVICE);
-	if (!err) {
-		dev_err(dd->dev, "dma_map_sg() error\n");
-		return -EINVAL;
+		err = dma_map_sg(dd->dev, dd->out_sg, dd->out_sg_len,
+				 DMA_FROM_DEVICE);
+		if (!err) {
+			dev_err(dd->dev, "dma_map_sg() error\n");
+			return -EINVAL;
+		}
 	}
 
 	err = omap_aes_crypt_dma(tfm, dd->in_sg, dd->out_sg, dd->in_sg_len,
 				 dd->out_sg_len);
-	if (err) {
+	if (err && !dd->pio_only) {
 		dma_unmap_sg(dd->dev, dd->in_sg, dd->in_sg_len, DMA_TO_DEVICE);
 		dma_unmap_sg(dd->dev, dd->out_sg, dd->out_sg_len,
 			     DMA_FROM_DEVICE);
@@ -610,9 +625,11 @@ static void omap_aes_done_task(unsigned long data)
 
 	pr_debug("enter done_task\n");
 
-	dma_sync_sg_for_cpu(dd->dev, dd->in_sg, dd->in_sg_len, DMA_FROM_DEVICE);
-
-	omap_aes_crypt_dma_stop(dd);
+	if (!dd->pio_only) {
+		dma_sync_sg_for_device(dd->dev, dd->out_sg, dd->out_sg_len,
+				       DMA_FROM_DEVICE);
+		omap_aes_crypt_dma_stop(dd);
+	}
 	omap_aes_finish_req(dd, 0);
 	omap_aes_handle_queue(dd, NULL);
 
-- 
1.7.9.5

