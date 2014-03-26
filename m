Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbaCZLsk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 07:48:40 -0400
Received: from [213.199.154.207] ([213.199.154.207]:8094 "EHLO
	am1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752018AbaCZLsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 07:48:39 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh1155h)
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: <broonie@kernel.org>, <Li.Xiubo@freescale.com>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alsa-devel@alsa-project.org>
Subject: [PATCH] ASoC: fsl_sai: Add isr to deal with error flag
Date: Wed, 26 Mar 2014 19:48:37 +0800
Message-ID: <1395834517-16426-1-git-send-email-Guangyu.Chen@freescale.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's quite cricial to clear error flags because SAI might hang if getting
FIFO underrun during playback (I haven't confirmed the same issue on Rx
overflow though).

So this patch enables those irq and adds isr() to clear the flags so as to
keep playback entirely safe.

Signed-off-by: Nicolin Chen <Guangyu.Chen@freescale.com>
---
 sound/soc/fsl/fsl_sai.c | 69 ++++++++++++++++++++++++++++++++++++++++++++++---
 sound/soc/fsl/fsl_sai.h |  9 +++++++
 2 files changed, 75 insertions(+), 3 deletions(-)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index c4a4231..5f91aff 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -23,6 +23,55 @@
 
 #include "fsl_sai.h"
 
+#define FSL_SAI_FLAGS (FSL_SAI_CSR_SEIE |\
+		       FSL_SAI_CSR_FEIE |\
+		       FSL_SAI_CSR_FWIE)
+
+static irqreturn_t fsl_sai_isr(int irq, void *devid)
+{
+	struct fsl_sai *sai = (struct fsl_sai *)devid;
+	struct device *dev = &sai->pdev->dev;
+	u32 xcsr;
+
+	regmap_read(sai->regmap, FSL_SAI_TCSR, &xcsr);
+	regmap_write(sai->regmap, FSL_SAI_TCSR, xcsr);
+
+	if (xcsr & FSL_SAI_CSR_WSF)
+		dev_dbg(dev, "isr: Start of Tx word detected\n");
+
+	if (xcsr & FSL_SAI_CSR_SEF)
+		dev_dbg(dev, "isr: Tx Frame sync error detected\n");
+
+	if (xcsr & FSL_SAI_CSR_FEF)
+		dev_dbg(dev, "isr: Transmit underrun detected\n");
+
+	if (xcsr & FSL_SAI_CSR_FWF)
+		dev_dbg(dev, "isr: Enabled transmit FIFO is empty\n");
+
+	if (xcsr & FSL_SAI_CSR_FRF)
+		dev_dbg(dev, "isr: Transmit FIFO watermark has been reached\n");
+
+	regmap_read(sai->regmap, FSL_SAI_RCSR, &xcsr);
+	regmap_write(sai->regmap, FSL_SAI_RCSR, xcsr);
+
+	if (xcsr & FSL_SAI_CSR_WSF)
+		dev_dbg(dev, "isr: Start of Rx word detected\n");
+
+	if (xcsr & FSL_SAI_CSR_SEF)
+		dev_dbg(dev, "isr: Rx Frame sync error detected\n");
+
+	if (xcsr & FSL_SAI_CSR_FEF)
+		dev_dbg(dev, "isr: Receive overflow detected\n");
+
+	if (xcsr & FSL_SAI_CSR_FWF)
+		dev_dbg(dev, "isr: Enabled receive FIFO is full\n");
+
+	if (xcsr & FSL_SAI_CSR_FRF)
+		dev_dbg(dev, "isr: Receive FIFO watermark has been reached\n");
+
+	return IRQ_HANDLED;
+}
+
 static int fsl_sai_set_dai_sysclk_tr(struct snd_soc_dai *cpu_dai,
 		int clk_id, unsigned int freq, int fsl_dir)
 {
@@ -373,8 +422,8 @@ static int fsl_sai_dai_probe(struct snd_soc_dai *cpu_dai)
 {
 	struct fsl_sai *sai = dev_get_drvdata(cpu_dai->dev);
 
-	regmap_update_bits(sai->regmap, FSL_SAI_TCSR, 0xffffffff, 0x0);
-	regmap_update_bits(sai->regmap, FSL_SAI_RCSR, 0xffffffff, 0x0);
+	regmap_update_bits(sai->regmap, FSL_SAI_TCSR, 0xffffffff, FSL_SAI_FLAGS);
+	regmap_update_bits(sai->regmap, FSL_SAI_RCSR, 0xffffffff, FSL_SAI_FLAGS);
 	regmap_update_bits(sai->regmap, FSL_SAI_TCR1, FSL_SAI_CR1_RFW_MASK,
 			   FSL_SAI_MAXBURST_TX * 2);
 	regmap_update_bits(sai->regmap, FSL_SAI_RCR1, FSL_SAI_CR1_RFW_MASK,
@@ -490,12 +539,14 @@ static int fsl_sai_probe(struct platform_device *pdev)
 	struct fsl_sai *sai;
 	struct resource *res;
 	void __iomem *base;
-	int ret;
+	int irq, ret;
 
 	sai = devm_kzalloc(&pdev->dev, sizeof(*sai), GFP_KERNEL);
 	if (!sai)
 		return -ENOMEM;
 
+	sai->pdev = pdev;
+
 	sai->big_endian_regs = of_property_read_bool(np, "big-endian-regs");
 	if (sai->big_endian_regs)
 		fsl_sai_regmap_config.val_format_endian = REGMAP_ENDIAN_BIG;
@@ -514,6 +565,18 @@ static int fsl_sai_probe(struct platform_device *pdev)
 		return PTR_ERR(sai->regmap);
 	}
 
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(&pdev->dev, "no irq for node %s\n", np->full_name);
+		return irq;
+	}
+
+	ret = devm_request_irq(&pdev->dev, irq, fsl_sai_isr, 0, np->name, sai);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to claim irq %u\n", irq);
+		return ret;
+	}
+
 	sai->dma_params_rx.addr = res->start + FSL_SAI_RDR;
 	sai->dma_params_tx.addr = res->start + FSL_SAI_TDR;
 	sai->dma_params_rx.maxburst = FSL_SAI_MAXBURST_RX;
diff --git a/sound/soc/fsl/fsl_sai.h b/sound/soc/fsl/fsl_sai.h
index e432260..05d1a1f 100644
--- a/sound/soc/fsl/fsl_sai.h
+++ b/sound/soc/fsl/fsl_sai.h
@@ -37,7 +37,15 @@
 
 /* SAI Transmit/Recieve Control Register */
 #define FSL_SAI_CSR_TERE	BIT(31)
+#define FSL_SAI_CSR_WSF		BIT(20)
+#define FSL_SAI_CSR_SEF		BIT(19)
+#define FSL_SAI_CSR_FEF		BIT(18)
 #define FSL_SAI_CSR_FWF		BIT(17)
+#define FSL_SAI_CSR_FRF		BIT(16)
+#define FSL_SAI_CSR_WSIE	BIT(12)
+#define FSL_SAI_CSR_SEIE	BIT(11)
+#define FSL_SAI_CSR_FEIE	BIT(10)
+#define FSL_SAI_CSR_FWIE	BIT(9)
 #define FSL_SAI_CSR_FRIE	BIT(8)
 #define FSL_SAI_CSR_FRDE	BIT(0)
 
@@ -99,6 +107,7 @@
 #define FSL_SAI_MAXBURST_RX 6
 
 struct fsl_sai {
+	struct platform_device *pdev;
 	struct regmap *regmap;
 
 	bool big_endian_regs;
-- 
1.8.4


