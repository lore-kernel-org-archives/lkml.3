Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab3HRCnw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 22:43:52 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33941 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754629Ab3HRCns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 22:43:48 -0400
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
Subject: [PATCH v2 08/14] crypto: omap-aes: PIO mode: Add IRQ handler and walk SGs
Date: Sat, 17 Aug 2013 21:42:29 -0500
Message-ID: <1376793755-30478-9-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376793755-30478-1-git-send-email-joelf@ti.com>
References: <1376793755-30478-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We add an IRQ handler that implements a state-machine for PIO-mode and data
structures for walking the scatter-gather list. The IRQ handler is called in
succession both when data is available to read or next data can be sent for
processing. This process continues till the entire in/out SG lists have been
walked. Once the SG-list has been completely walked, the IRQ handler schedules
the done_task tasklet.

Also add a useful macro that is used through out the IRQ code for a common
pattern of calculating how much an SG list has been walked.  This improves code
readability and avoids checkpatch errors.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 drivers/crypto/omap-aes.c |   90 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 90 insertions(+)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 9a964e8..889dc99 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -39,6 +39,8 @@
 #define DST_MAXBURST			4
 #define DMA_MIN				(DST_MAXBURST * sizeof(u32))
 
+#define _calc_walked(inout) (dd->inout##_walk.offset - dd->inout##_sg->offset)
+
 /* OMAP TRM gives bitfields as start:end, where start is the higher bit
    number. For example 7:0 */
 #define FLD_MASK(start, end)	(((1 << ((start) - (end) + 1)) - 1) << (end))
@@ -91,6 +93,8 @@
 #define FLAGS_FAST		BIT(5)
 #define FLAGS_BUSY		BIT(6)
 
+#define AES_BLOCK_WORDS		(AES_BLOCK_SIZE >> 2)
+
 struct omap_aes_ctx {
 	struct omap_aes_dev *dd;
 
@@ -156,6 +160,8 @@ struct omap_aes_dev {
 	size_t				total;
 	struct scatterlist		*in_sg;
 	struct scatterlist		*out_sg;
+	struct scatter_walk		in_walk;
+	struct scatter_walk		out_walk;
 	int			dma_in;
 	struct dma_chan		*dma_lch_in;
 	int			dma_out;
@@ -852,6 +858,90 @@ static const struct omap_aes_pdata omap_aes_pdata_omap4 = {
 	.minor_shift	= 0,
 };
 
+static irqreturn_t omap_aes_irq(int irq, void *dev_id)
+{
+	struct omap_aes_dev *dd = dev_id;
+	u32 status, i;
+	u32 *src, *dst;
+
+	status = omap_aes_read(dd, AES_REG_IRQ_STATUS(dd));
+	if (status & AES_REG_IRQ_DATA_IN) {
+		omap_aes_write(dd, AES_REG_IRQ_ENABLE(dd), 0x0);
+
+		BUG_ON(!dd->in_sg);
+
+		BUG_ON(_calc_walked(in) > dd->in_sg->length);
+
+		src = sg_virt(dd->in_sg) + _calc_walked(in);
+
+		for (i = 0; i < AES_BLOCK_WORDS; i++) {
+			omap_aes_write(dd, AES_REG_DATA_N(dd, i), *src);
+
+			scatterwalk_advance(&dd->in_walk, 4);
+			if (dd->in_sg->length == _calc_walked(in)) {
+				dd->in_sg = scatterwalk_sg_next(dd->in_sg);
+				if (dd->in_sg) {
+					scatterwalk_start(&dd->in_walk,
+							  dd->in_sg);
+					src = sg_virt(dd->in_sg) +
+					      _calc_walked(in);
+				}
+			} else {
+				src++;
+			}
+		}
+
+		/* Clear IRQ status */
+		status &= ~AES_REG_IRQ_DATA_IN;
+		omap_aes_write(dd, AES_REG_IRQ_STATUS(dd), status);
+
+		/* Enable DATA_OUT interrupt */
+		omap_aes_write(dd, AES_REG_IRQ_ENABLE(dd), 0x4);
+
+	} else if (status & AES_REG_IRQ_DATA_OUT) {
+		omap_aes_write(dd, AES_REG_IRQ_ENABLE(dd), 0x0);
+
+		BUG_ON(!dd->out_sg);
+
+		BUG_ON(_calc_walked(out) > dd->out_sg->length);
+
+		dst = sg_virt(dd->out_sg) + _calc_walked(out);
+
+		for (i = 0; i < AES_BLOCK_WORDS; i++) {
+			*dst = omap_aes_read(dd, AES_REG_DATA_N(dd, i));
+			scatterwalk_advance(&dd->out_walk, 4);
+			if (dd->out_sg->length == _calc_walked(out)) {
+				dd->out_sg = scatterwalk_sg_next(dd->out_sg);
+				if (dd->out_sg) {
+					scatterwalk_start(&dd->out_walk,
+							  dd->out_sg);
+					dst = sg_virt(dd->out_sg) +
+					      _calc_walked(out);
+				}
+			} else {
+				dst++;
+			}
+		}
+
+		dd->total -= AES_BLOCK_SIZE;
+
+		BUG_ON(dd->total < 0);
+
+		/* Clear IRQ status */
+		status &= ~AES_REG_IRQ_DATA_OUT;
+		omap_aes_write(dd, AES_REG_IRQ_STATUS(dd), status);
+
+		if (!dd->total)
+			/* All bytes read! */
+			tasklet_schedule(&dd->done_task);
+		else
+			/* Enable DATA_IN interrupt for next block */
+			omap_aes_write(dd, AES_REG_IRQ_ENABLE(dd), 0x2);
+	}
+
+	return IRQ_HANDLED;
+}
+
 static const struct of_device_id omap_aes_of_match[] = {
 	{
 		.compatible	= "ti,omap2-aes",
-- 
1.7.9.5

