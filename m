Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbaAWIrN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 03:47:13 -0500
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:38967
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751359AbaAWIrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 03:47:11 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zze0eahzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdchz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>, <timur@tabi.org>,
        <Guangyu.Chen@freescale.com>
CC: <perex@perex.cz>, <tiwai@suse.de>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] ASoC: fsl-sai: convert to use regmap API for Freeacale SAI
Date: Thu, 23 Jan 2014 15:48:03 +0800
Message-ID: <1390463283-7545-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
Cc: Nicolin Chen <Guangyu.Chen@freescale.com>
---
 sound/soc/fsl/fsl_sai.c | 243 +++++++++++++++++++++++++-----------------------
 sound/soc/fsl/fsl_sai.h |  47 +++++-----
 2 files changed, 150 insertions(+), 140 deletions(-)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index 2858a6c..a80d709 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -15,6 +15,7 @@
 #include <linux/dmaengine.h>
 #include <linux/module.h>
 #include <linux/of_address.h>
+#include <linux/regmap.h>
 #include <linux/slab.h>
 #include <sound/core.h>
 #include <sound/dmaengine_pcm.h>
@@ -22,34 +23,6 @@
 
 #include "fsl_sai.h"
 
-static inline u32 sai_readl(struct fsl_sai *sai,
-		const void __iomem *addr)
-{
-	u32 val;
-
-	val = __raw_readl(addr);
-
-	if (likely(sai->big_endian_regs))
-		val = be32_to_cpu(val);
-	else
-		val = le32_to_cpu(val);
-	rmb();
-
-	return val;
-}
-
-static inline void sai_writel(struct fsl_sai *sai,
-		u32 val, void __iomem *addr)
-{
-	wmb();
-	if (likely(sai->big_endian_regs))
-		val = cpu_to_be32(val);
-	else
-		val = cpu_to_le32(val);
-
-	__raw_writel(val, addr);
-}
-
 static int fsl_sai_set_dai_sysclk_tr(struct snd_soc_dai *cpu_dai,
 		int clk_id, unsigned int freq, int fsl_dir)
 {
@@ -61,7 +34,8 @@ static int fsl_sai_set_dai_sysclk_tr(struct snd_soc_dai *cpu_dai,
 	else
 		reg_cr2 = FSL_SAI_RCR2;
 
-	val_cr2 = sai_readl(sai, sai->base + reg_cr2);
+	regmap_read(sai->regmap, reg_cr2, &val_cr2);
+
 	val_cr2 &= ~FSL_SAI_CR2_MSEL_MASK;
 
 	switch (clk_id) {
@@ -81,40 +55,28 @@ static int fsl_sai_set_dai_sysclk_tr(struct snd_soc_dai *cpu_dai,
 		return -EINVAL;
 	}
 
-	sai_writel(sai, val_cr2, sai->base + reg_cr2);
-
-	return 0;
+	return regmap_write(sai->regmap, reg_cr2, val_cr2);
 }
 
 static int fsl_sai_set_dai_sysclk(struct snd_soc_dai *cpu_dai,
 		int clk_id, unsigned int freq, int dir)
 {
-	struct fsl_sai *sai = snd_soc_dai_get_drvdata(cpu_dai);
 	int ret;
 
 	if (dir == SND_SOC_CLOCK_IN)
 		return 0;
 
-	ret = clk_prepare_enable(sai->clk);
-	if (ret)
-		return ret;
-
 	ret = fsl_sai_set_dai_sysclk_tr(cpu_dai, clk_id, freq,
 					FSL_FMT_TRANSMITTER);
 	if (ret) {
 		dev_err(cpu_dai->dev, "Cannot set tx sysclk: %d\n", ret);
-		goto err_clk;
+		return ret;
 	}
 
 	ret = fsl_sai_set_dai_sysclk_tr(cpu_dai, clk_id, freq,
 					FSL_FMT_RECEIVER);
-	if (ret) {
+	if (ret)
 		dev_err(cpu_dai->dev, "Cannot set rx sysclk: %d\n", ret);
-		goto err_clk;
-	}
-
-err_clk:
-	clk_disable_unprepare(sai->clk);
 
 	return ret;
 }
@@ -133,8 +95,8 @@ static int fsl_sai_set_dai_fmt_tr(struct snd_soc_dai *cpu_dai,
 		reg_cr4 = FSL_SAI_RCR4;
 	}
 
-	val_cr2 = sai_readl(sai, sai->base + reg_cr2);
-	val_cr4 = sai_readl(sai, sai->base + reg_cr4);
+	regmap_read(sai->regmap, reg_cr2, &val_cr2);
+	regmap_read(sai->regmap, reg_cr4, &val_cr4);
 
 	if (sai->big_endian_data)
 		val_cr4 &= ~FSL_SAI_CR4_MF;
@@ -183,35 +145,25 @@ static int fsl_sai_set_dai_fmt_tr(struct snd_soc_dai *cpu_dai,
 		return -EINVAL;
 	}
 
-	sai_writel(sai, val_cr2, sai->base + reg_cr2);
-	sai_writel(sai, val_cr4, sai->base + reg_cr4);
+	regmap_write(sai->regmap, reg_cr2, val_cr2);
+	regmap_write(sai->regmap, reg_cr4, val_cr4);
 
 	return 0;
 }
 
 static int fsl_sai_set_dai_fmt(struct snd_soc_dai *cpu_dai, unsigned int fmt)
 {
-	struct fsl_sai *sai = snd_soc_dai_get_drvdata(cpu_dai);
 	int ret;
 
-	ret = clk_prepare_enable(sai->clk);
-	if (ret)
-		return ret;
-
 	ret = fsl_sai_set_dai_fmt_tr(cpu_dai, fmt, FSL_FMT_TRANSMITTER);
 	if (ret) {
 		dev_err(cpu_dai->dev, "Cannot set tx format: %d\n", ret);
-		goto err_clk;
+		return ret;
 	}
 
 	ret = fsl_sai_set_dai_fmt_tr(cpu_dai, fmt, FSL_FMT_RECEIVER);
-	if (ret) {
+	if (ret)
 		dev_err(cpu_dai->dev, "Cannot set rx format: %d\n", ret);
-		goto err_clk;
-	}
-
-err_clk:
-	clk_disable_unprepare(sai->clk);
 
 	return ret;
 }
@@ -235,11 +187,12 @@ static int fsl_sai_hw_params(struct snd_pcm_substream *substream,
 		reg_mr = FSL_SAI_RMR;
 	}
 
-	val_cr4 = sai_readl(sai, sai->base + reg_cr4);
+	regmap_read(sai->regmap, reg_cr4, &val_cr4);
+	regmap_read(sai->regmap, reg_cr4, &val_cr5);
+
 	val_cr4 &= ~FSL_SAI_CR4_SYWD_MASK;
 	val_cr4 &= ~FSL_SAI_CR4_FRSZ_MASK;
 
-	val_cr5 = sai_readl(sai, sai->base + reg_cr5);
 	val_cr5 &= ~FSL_SAI_CR5_WNW_MASK;
 	val_cr5 &= ~FSL_SAI_CR5_W0W_MASK;
 	val_cr5 &= ~FSL_SAI_CR5_FBT_MASK;
@@ -257,9 +210,9 @@ static int fsl_sai_hw_params(struct snd_pcm_substream *substream,
 	val_cr4 |= FSL_SAI_CR4_FRSZ(channels);
 	val_mr = ~0UL - ((1 << channels) - 1);
 
-	sai_writel(sai, val_cr4, sai->base + reg_cr4);
-	sai_writel(sai, val_cr5, sai->base + reg_cr5);
-	sai_writel(sai, val_mr, sai->base + reg_mr);
+	regmap_write(sai->regmap, reg_cr4, val_cr4);
+	regmap_write(sai->regmap, reg_cr5, val_cr5);
+	regmap_write(sai->regmap, reg_mr, val_mr);
 
 	return 0;
 }
@@ -268,18 +221,15 @@ static int fsl_sai_trigger(struct snd_pcm_substream *substream, int cmd,
 		struct snd_soc_dai *cpu_dai)
 {
 	struct fsl_sai *sai = snd_soc_dai_get_drvdata(cpu_dai);
-	u32 tcsr, rcsr, val_cr2;
-
-	val_cr2 = sai_readl(sai, sai->base + FSL_SAI_TCR2);
-	val_cr2 &= ~FSL_SAI_CR2_SYNC;
-	sai_writel(sai, val_cr2, sai->base + FSL_SAI_TCR2);
+	u32 tcsr, rcsr;
 
-	val_cr2 = sai_readl(sai, sai->base + FSL_SAI_RCR2);
-	val_cr2 |= FSL_SAI_CR2_SYNC;
-	sai_writel(sai, val_cr2, sai->base + FSL_SAI_RCR2);
+	regmap_update_bits(sai->regmap, FSL_SAI_TCR2, FSL_SAI_CR2_SYNC,
+			   ~FSL_SAI_CR2_SYNC);
+	regmap_update_bits(sai->regmap, FSL_SAI_RCR2, FSL_SAI_CR2_SYNC,
+			   FSL_SAI_CR2_SYNC);
 
-	tcsr = sai_readl(sai, sai->base + FSL_SAI_TCSR);
-	rcsr = sai_readl(sai, sai->base + FSL_SAI_RCSR);
+	regmap_read(sai->regmap, FSL_SAI_TCSR, &tcsr);
+	regmap_read(sai->regmap, FSL_SAI_RCSR, &rcsr);
 
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
 		tcsr |= FSL_SAI_CSR_FRDE;
@@ -296,10 +246,9 @@ static int fsl_sai_trigger(struct snd_pcm_substream *substream, int cmd,
 		tcsr |= FSL_SAI_CSR_TERE;
 		rcsr |= FSL_SAI_CSR_TERE;
 
-		sai_writel(sai, rcsr, sai->base + FSL_SAI_RCSR);
-		sai_writel(sai, tcsr, sai->base + FSL_SAI_TCSR);
+		regmap_write(sai->regmap, FSL_SAI_RCSR, rcsr);
+		regmap_write(sai->regmap, FSL_SAI_TCSR, tcsr);
 		break;
-
 	case SNDRV_PCM_TRIGGER_STOP:
 	case SNDRV_PCM_TRIGGER_SUSPEND:
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
@@ -308,8 +257,8 @@ static int fsl_sai_trigger(struct snd_pcm_substream *substream, int cmd,
 			rcsr &= ~FSL_SAI_CSR_TERE;
 		}
 
-		sai_writel(sai, tcsr, sai->base + FSL_SAI_TCSR);
-		sai_writel(sai, rcsr, sai->base + FSL_SAI_RCSR);
+		regmap_write(sai->regmap, FSL_SAI_TCSR, tcsr);
+		regmap_write(sai->regmap, FSL_SAI_RCSR, rcsr);
 		break;
 	default:
 		return -EINVAL;
@@ -322,41 +271,32 @@ static int fsl_sai_startup(struct snd_pcm_substream *substream,
 		struct snd_soc_dai *cpu_dai)
 {
 	struct fsl_sai *sai = snd_soc_dai_get_drvdata(cpu_dai);
-	u32 val, reg;
-	int ret;
-
-	ret = clk_prepare_enable(sai->clk);
-	if (ret)
-		return ret;
+	u32 reg;
 
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
 		reg = FSL_SAI_TCR3;
 	else
 		reg = FSL_SAI_RCR3;
 
-	val = sai_readl(sai, sai->base + reg);
-	val |= FSL_SAI_CR3_TRCE;
-	sai_writel(sai, val, sai->base + reg);
+	regmap_update_bits(sai->regmap, reg, FSL_SAI_CR3_TRCE,
+			   FSL_SAI_CR3_TRCE);
 
-	return clk_prepare_enable(sai->clk);
+	return 0;
 }
 
 static void fsl_sai_shutdown(struct snd_pcm_substream *substream,
 		struct snd_soc_dai *cpu_dai)
 {
 	struct fsl_sai *sai = snd_soc_dai_get_drvdata(cpu_dai);
-	u32 val, reg;
+	u32 reg;
 
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
 		reg = FSL_SAI_TCR3;
 	else
 		reg = FSL_SAI_RCR3;
 
-	val = sai_readl(sai, sai->base + reg);
-	val &= ~FSL_SAI_CR3_TRCE;
-	sai_writel(sai, val, sai->base + reg);
-
-	clk_disable_unprepare(sai->clk);
+	regmap_update_bits(sai->regmap, reg, FSL_SAI_CR3_TRCE,
+			   ~FSL_SAI_CR3_TRCE);
 }
 
 static const struct snd_soc_dai_ops fsl_sai_pcm_dai_ops = {
@@ -371,18 +311,13 @@ static const struct snd_soc_dai_ops fsl_sai_pcm_dai_ops = {
 static int fsl_sai_dai_probe(struct snd_soc_dai *cpu_dai)
 {
 	struct fsl_sai *sai = dev_get_drvdata(cpu_dai->dev);
-	int ret;
-
-	ret = clk_prepare_enable(sai->clk);
-	if (ret)
-		return ret;
 
-	sai_writel(sai, 0x0, sai->base + FSL_SAI_RCSR);
-	sai_writel(sai, 0x0, sai->base + FSL_SAI_TCSR);
-	sai_writel(sai, FSL_SAI_MAXBURST_TX * 2, sai->base + FSL_SAI_TCR1);
-	sai_writel(sai, FSL_SAI_MAXBURST_RX - 1, sai->base + FSL_SAI_RCR1);
-
-	clk_disable_unprepare(sai->clk);
+	regmap_update_bits(sai->regmap, FSL_SAI_TCSR, 0xffffffff, 0x0);
+	regmap_update_bits(sai->regmap, FSL_SAI_RCSR, 0xffffffff, 0x0);
+	regmap_update_bits(sai->regmap, FSL_SAI_TCR1, FSL_SAI_CR1_RFW_MASK,
+			   FSL_SAI_MAXBURST_TX * 2);
+	regmap_update_bits(sai->regmap, FSL_SAI_RCR1, FSL_SAI_CR1_RFW_MASK,
+			   FSL_SAI_MAXBURST_RX - 1);
 
 	snd_soc_dai_init_dma_data(cpu_dai, &sai->dma_params_tx,
 				&sai->dma_params_rx);
@@ -413,11 +348,88 @@ static const struct snd_soc_component_driver fsl_component = {
 	.name           = "fsl-sai",
 };
 
+/* Freescale SAI regmap */
+static bool fsl_sai_readable_reg(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case FSL_SAI_TCSR:
+	case FSL_SAI_TCR1:
+	case FSL_SAI_TCR2:
+	case FSL_SAI_TCR3:
+	case FSL_SAI_TCR4:
+	case FSL_SAI_TCR5:
+	case FSL_SAI_TFR:
+	case FSL_SAI_TMR:
+	case FSL_SAI_RCSR:
+	case FSL_SAI_RCR1:
+	case FSL_SAI_RCR2:
+	case FSL_SAI_RCR3:
+	case FSL_SAI_RCR4:
+	case FSL_SAI_RCR5:
+	case FSL_SAI_RDR:
+	case FSL_SAI_RFR:
+	case FSL_SAI_RMR:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static bool fsl_sai_volatile_reg(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case FSL_SAI_TFR:
+	case FSL_SAI_RFR:
+	case FSL_SAI_TDR:
+	case FSL_SAI_RDR:
+		return true;
+	default:
+		return false;
+	}
+
+}
+
+static bool fsl_sai_writeable_reg(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case FSL_SAI_TCSR:
+	case FSL_SAI_TCR1:
+	case FSL_SAI_TCR2:
+	case FSL_SAI_TCR3:
+	case FSL_SAI_TCR4:
+	case FSL_SAI_TCR5:
+	case FSL_SAI_TDR:
+	case FSL_SAI_TMR:
+	case FSL_SAI_RCSR:
+	case FSL_SAI_RCR1:
+	case FSL_SAI_RCR2:
+	case FSL_SAI_RCR3:
+	case FSL_SAI_RCR4:
+	case FSL_SAI_RCR5:
+	case FSL_SAI_RMR:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static const struct regmap_config fsl_sai_regmap_config = {
+	.reg_bits = 32,
+	.reg_stride = 4,
+	.val_bits = 32,
+
+	.max_register = FSL_SAI_RMR,
+	.readable_reg = fsl_sai_readable_reg,
+	.volatile_reg = fsl_sai_volatile_reg,
+	.writeable_reg = fsl_sai_writeable_reg,
+};
+
 static int fsl_sai_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
 	struct fsl_sai *sai;
 	struct resource *res;
+	void __iomem *base;
 	int ret;
 
 	sai = devm_kzalloc(&pdev->dev, sizeof(*sai), GFP_KERNEL);
@@ -425,14 +437,15 @@ static int fsl_sai_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	sai->base = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(sai->base))
-		return PTR_ERR(sai->base);
-
-	sai->clk = devm_clk_get(&pdev->dev, "sai");
-	if (IS_ERR(sai->clk)) {
-		dev_err(&pdev->dev, "Cannot get SAI's clock\n");
-		return PTR_ERR(sai->clk);
+	base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
+
+	sai->regmap = devm_regmap_init_mmio_clk(&pdev->dev,
+			"sai", base, &fsl_sai_regmap_config);
+	if (IS_ERR(sai->regmap)) {
+		dev_err(&pdev->dev, "regmap init failed\n");
+		return PTR_ERR(sai->regmap);
 	}
 
 	sai->dma_params_rx.addr = res->start + FSL_SAI_RDR;
diff --git a/sound/soc/fsl/fsl_sai.h b/sound/soc/fsl/fsl_sai.h
index 41bb62e..1571459 100644
--- a/sound/soc/fsl/fsl_sai.h
+++ b/sound/soc/fsl/fsl_sai.h
@@ -15,31 +15,36 @@
 			 SNDRV_PCM_FMTBIT_S20_3LE |\
 			 SNDRV_PCM_FMTBIT_S24_LE)
 
+/* SAI Register Map Register */
+#define FSL_SAI_TCSR	0x00 /* SAI Transmit Control */
+#define FSL_SAI_TCR1	0x04 /* SAI Transmit Configuration 1 */
+#define FSL_SAI_TCR2	0x08 /* SAI Transmit Configuration 2 */
+#define FSL_SAI_TCR3	0x0c /* SAI Transmit Configuration 3 */
+#define FSL_SAI_TCR4	0x10 /* SAI Transmit Configuration 4 */
+#define FSL_SAI_TCR5	0x14 /* SAI Transmit Configuration 5 */
+#define FSL_SAI_TDR	0x20 /* SAI Transmit Data */
+#define FSL_SAI_TFR	0x40 /* SAI Transmit FIFO */
+#define FSL_SAI_TMR	0x60 /* SAI Transmit Mask */
+#define FSL_SAI_RCSR	0x80 /* SAI Receive Control */
+#define FSL_SAI_RCR1	0x84 /* SAI Receive Configuration 1 */
+#define FSL_SAI_RCR2	0x88 /* SAI Receive Configuration 2 */
+#define FSL_SAI_RCR3	0x8c /* SAI Receive Configuration 3 */
+#define FSL_SAI_RCR4	0x90 /* SAI Receive Configuration 4 */
+#define FSL_SAI_RCR5	0x94 /* SAI Receive Configuration 5 */
+#define FSL_SAI_RDR	0xa0 /* SAI Receive Data */
+#define FSL_SAI_RFR	0xc0 /* SAI Receive FIFO */
+#define FSL_SAI_RMR	0xe0 /* SAI Receive Mask */
+
 /* SAI Transmit/Recieve Control Register */
-#define FSL_SAI_TCSR		0x00
-#define FSL_SAI_RCSR		0x80
 #define FSL_SAI_CSR_TERE	BIT(31)
 #define FSL_SAI_CSR_FWF		BIT(17)
 #define FSL_SAI_CSR_FRIE	BIT(8)
 #define FSL_SAI_CSR_FRDE	BIT(0)
 
-/* SAI Transmit Data/FIFO/MASK Register */
-#define FSL_SAI_TDR		0x20
-#define FSL_SAI_TFR		0x40
-#define FSL_SAI_TMR		0x60
-
-/* SAI Recieve Data/FIFO/MASK Register */
-#define FSL_SAI_RDR		0xa0
-#define FSL_SAI_RFR		0xc0
-#define FSL_SAI_RMR		0xe0
-
 /* SAI Transmit and Recieve Configuration 1 Register */
-#define FSL_SAI_TCR1		0x04
-#define FSL_SAI_RCR1		0x84
+#define FSL_SAI_CR1_RFW_MASK	0x1f
 
 /* SAI Transmit and Recieve Configuration 2 Register */
-#define FSL_SAI_TCR2		0x08
-#define FSL_SAI_RCR2		0x88
 #define FSL_SAI_CR2_SYNC	BIT(30)
 #define FSL_SAI_CR2_MSEL_MASK	(0xff << 26)
 #define FSL_SAI_CR2_MSEL_BUS	0
@@ -50,15 +55,11 @@
 #define FSL_SAI_CR2_BCD_MSTR	BIT(24)
 
 /* SAI Transmit and Recieve Configuration 3 Register */
-#define FSL_SAI_TCR3		0x0c
-#define FSL_SAI_RCR3		0x8c
 #define FSL_SAI_CR3_TRCE	BIT(16)
 #define FSL_SAI_CR3_WDFL(x)	(x)
 #define FSL_SAI_CR3_WDFL_MASK	0x1f
 
 /* SAI Transmit and Recieve Configuration 4 Register */
-#define FSL_SAI_TCR4		0x10
-#define FSL_SAI_RCR4		0x90
 #define FSL_SAI_CR4_FRSZ(x)	(((x) - 1) << 16)
 #define FSL_SAI_CR4_FRSZ_MASK	(0x1f << 16)
 #define FSL_SAI_CR4_SYWD(x)	(((x) - 1) << 8)
@@ -69,8 +70,6 @@
 #define FSL_SAI_CR4_FSD_MSTR	BIT(0)
 
 /* SAI Transmit and Recieve Configuration 5 Register */
-#define FSL_SAI_TCR5		0x14
-#define FSL_SAI_RCR5		0x94
 #define FSL_SAI_CR5_WNW(x)	(((x) - 1) << 24)
 #define FSL_SAI_CR5_WNW_MASK	(0x1f << 24)
 #define FSL_SAI_CR5_W0W(x)	(((x) - 1) << 16)
@@ -100,9 +99,7 @@
 #define FSL_SAI_MAXBURST_RX 6
 
 struct fsl_sai {
-	struct clk *clk;
-
-	void __iomem *base;
+	struct regmap *regmap;
 
 	bool big_endian_regs;
 	bool big_endian_data;
-- 
1.8.4


