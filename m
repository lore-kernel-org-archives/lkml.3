Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437AbaC1LiD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 07:38:03 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:57868 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751224AbaC1LiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 07:38:01 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh1155h)
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: <broonie@kernel.org>, <Li.Xiubo@freescale.com>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alsa-devel@alsa-project.org>, <timur@tabi.org>
Subject: [PATCH] ASoC: fsl_sai: Improve fsl_sai_isr()
Date: Fri, 28 Mar 2014 19:39:25 +0800
Message-ID: <1396006765-4527-1-git-send-email-Guangyu.Chen@freescale.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch improves fsl_sai_isr() in these ways:
1, Add comment for mask fetching code.
2, Return IRQ_NONE if the IRQ is not for the device.
3, Use regmap_write() instead of regmap_update_bits().

Signed-off-by: Nicolin Chen <Guangyu.Chen@freescale.com>
---
 sound/soc/fsl/fsl_sai.c | 64 ++++++++++++++++++++++++++++++++++---------------
 1 file changed, 45 insertions(+), 19 deletions(-)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index 0bc98bb..f088545 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -30,62 +30,88 @@ static irqreturn_t fsl_sai_isr(int irq, void *devid)
 {
 	struct fsl_sai *sai = (struct fsl_sai *)devid;
 	struct device *dev = &sai->pdev->dev;
-	u32 xcsr, mask;
+	u32 flags, xcsr, mask;
+	bool irq_none = true;
 
-	/* Only handle those what we enabled */
+	/*
+	 * Both IRQ status bits and IRQ mask bits are in the xCSR but
+	 * different shifts. And we here create a mask only for those
+	 * IRQs that we activated.
+	 */
 	mask = (FSL_SAI_FLAGS >> FSL_SAI_CSR_xIE_SHIFT) << FSL_SAI_CSR_xF_SHIFT;
 
 	/* Tx IRQ */
 	regmap_read(sai->regmap, FSL_SAI_TCSR, &xcsr);
-	xcsr &= mask;
+	flags = xcsr & mask;
 
-	if (xcsr & FSL_SAI_CSR_WSF)
+	if (flags)
+		irq_none = false;
+	else
+		goto irq_rx;
+
+	if (flags & FSL_SAI_CSR_WSF)
 		dev_dbg(dev, "isr: Start of Tx word detected\n");
 
-	if (xcsr & FSL_SAI_CSR_SEF)
+	if (flags & FSL_SAI_CSR_SEF)
 		dev_warn(dev, "isr: Tx Frame sync error detected\n");
 
-	if (xcsr & FSL_SAI_CSR_FEF) {
+	if (flags & FSL_SAI_CSR_FEF) {
 		dev_warn(dev, "isr: Transmit underrun detected\n");
 		/* FIFO reset for safety */
 		xcsr |= FSL_SAI_CSR_FR;
 	}
 
-	if (xcsr & FSL_SAI_CSR_FWF)
+	if (flags & FSL_SAI_CSR_FWF)
 		dev_dbg(dev, "isr: Enabled transmit FIFO is empty\n");
 
-	if (xcsr & FSL_SAI_CSR_FRF)
+	if (flags & FSL_SAI_CSR_FRF)
 		dev_dbg(dev, "isr: Transmit FIFO watermark has been reached\n");
 
-	regmap_update_bits(sai->regmap, FSL_SAI_TCSR,
-			   FSL_SAI_CSR_xF_W_MASK | FSL_SAI_CSR_FR, xcsr);
+	flags &= FSL_SAI_CSR_xF_W_MASK;
+	xcsr &= ~FSL_SAI_CSR_xF_MASK;
+
+	if (flags)
+		regmap_write(sai->regmap, FSL_SAI_TCSR, flags | xcsr);
 
+irq_rx:
 	/* Rx IRQ */
 	regmap_read(sai->regmap, FSL_SAI_RCSR, &xcsr);
-	xcsr &= mask;
+	flags = xcsr & mask;
 
-	if (xcsr & FSL_SAI_CSR_WSF)
+	if (flags)
+		irq_none = false;
+	else
+		goto out;
+
+	if (flags & FSL_SAI_CSR_WSF)
 		dev_dbg(dev, "isr: Start of Rx word detected\n");
 
-	if (xcsr & FSL_SAI_CSR_SEF)
+	if (flags & FSL_SAI_CSR_SEF)
 		dev_warn(dev, "isr: Rx Frame sync error detected\n");
 
-	if (xcsr & FSL_SAI_CSR_FEF) {
+	if (flags & FSL_SAI_CSR_FEF) {
 		dev_warn(dev, "isr: Receive overflow detected\n");
 		/* FIFO reset for safety */
 		xcsr |= FSL_SAI_CSR_FR;
 	}
 
-	if (xcsr & FSL_SAI_CSR_FWF)
+	if (flags & FSL_SAI_CSR_FWF)
 		dev_dbg(dev, "isr: Enabled receive FIFO is full\n");
 
-	if (xcsr & FSL_SAI_CSR_FRF)
+	if (flags & FSL_SAI_CSR_FRF)
 		dev_dbg(dev, "isr: Receive FIFO watermark has been reached\n");
 
-	regmap_update_bits(sai->regmap, FSL_SAI_RCSR,
-			   FSL_SAI_CSR_xF_W_MASK | FSL_SAI_CSR_FR, xcsr);
+	flags &= FSL_SAI_CSR_xF_W_MASK;
+	xcsr &= ~FSL_SAI_CSR_xF_MASK;
 
-	return IRQ_HANDLED;
+	if (flags)
+		regmap_write(sai->regmap, FSL_SAI_TCSR, flags | xcsr);
+
+out:
+	if (irq_none)
+		return IRQ_NONE;
+	else
+		return IRQ_HANDLED;
 }
 
 static int fsl_sai_set_dai_sysclk_tr(struct snd_soc_dai *cpu_dai,
-- 
1.8.4


