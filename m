Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab3JQJLX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 05:11:23 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:58292 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752893Ab3JQJLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 05:11:17 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 2
X-BigFish: VS2(zzbb2dIc8kzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <r65073@freescale.com>, <timur@tabi.org>, <lgirdwood@gmail.com>,
        <broonie@kernel.org>
CC: <r64188@freescale.com>, <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ian.campbell@citrix.com>, <rob@landley.net>, <linux@arm.linux.org.uk>,
        <perex@perex.cz>, <tiwai@suse.de>, <grant.likely@linaro.org>,
        <fabio.estevam@freescale.com>, <LW@KARO-electronics.de>,
        <oskar@scara.com>, <shawn.guo@linaro.org>, <b42378@freescale.com>,
        <b18965@freescale.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <alsa-devel@alsa-project.org>,
        <linuxppc-dev@lists.ozlabs.org>
Subject: [PATCHv1 1/8] ALSA: Add SAI SoC Digital Audio Interface driver.
Date: Thu, 17 Oct 2013 17:01:10 +0800
Message-ID: <1382000477-17304-2-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1382000477-17304-1-git-send-email-Li.Xiubo@freescale.com>
References: <1382000477-17304-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds Freescale SAI ASoC Audio support.
This implementation is only compatible with device tree definition.
Features:
o Supports playback/capture
o Supports 16/20/24 bit PCM
o Supports 8k - 96k sample rates
o Supports slave mode only.

Signed-off-by: Alison Wang <b18965@freescale.com
Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 sound/soc/fsl/Kconfig       |  19 ++
 sound/soc/fsl/Makefile      |   7 +
 sound/soc/fsl/fsl-pcm-dma.c |  51 +++++
 sound/soc/fsl/fsl-sai.c     | 515 ++++++++++++++++++++++++++++++++++++++++++++
 sound/soc/fsl/fsl-sai.h     | 127 +++++++++++
 5 files changed, 719 insertions(+)
 create mode 100644 sound/soc/fsl/fsl-pcm-dma.c
 create mode 100644 sound/soc/fsl/fsl-sai.c
 create mode 100644 sound/soc/fsl/fsl-sai.h

diff --git a/sound/soc/fsl/Kconfig b/sound/soc/fsl/Kconfig
index cd088cc..a49b386 100644
--- a/sound/soc/fsl/Kconfig
+++ b/sound/soc/fsl/Kconfig
@@ -202,3 +202,22 @@ config SND_SOC_IMX_MC13783
 	select SND_SOC_IMX_PCM_DMA
 
 endif # SND_IMX_SOC
+
+menuconfig SND_FSL_SOC
+	tristate "SoC Audio for Freescale FSL CPUs"
+	help
+	  Say Y or M if you want to add support for codecs attached to
+	  the FSL CPUs.
+
+	  This will enable Freeacale SAI, SGT15000 codec.
+
+if SND_FSL_SOC
+
+config SND_SOC_FSL_SAI
+	tristate
+
+config SND_SOC_FSL_PCM
+	tristate
+	select SND_SOC_GENERIC_DMAENGINE_PCM
+
+endif # SND_FSL_SOC
diff --git a/sound/soc/fsl/Makefile b/sound/soc/fsl/Makefile
index 4b5970e..865ac23 100644
--- a/sound/soc/fsl/Makefile
+++ b/sound/soc/fsl/Makefile
@@ -54,3 +54,10 @@ obj-$(CONFIG_SND_MXC_SOC_WM1133_EV1) += snd-soc-wm1133-ev1.o
 obj-$(CONFIG_SND_SOC_IMX_SGTL5000) += snd-soc-imx-sgtl5000.o
 obj-$(CONFIG_SND_SOC_IMX_WM8962) += snd-soc-imx-wm8962.o
 obj-$(CONFIG_SND_SOC_IMX_MC13783) += snd-soc-imx-mc13783.o
+
+# FSL ARM SAI/SGT15000 Platform Support
+snd-soc-fsl-sai-objs := fsl-sai.o
+snd-soc-fsl-pcm-objs := fsl-pcm-dma.o
+
+obj-$(CONFIG_SND_SOC_FSL_SAI) += snd-soc-fsl-sai.o
+obj-$(CONFIG_SND_SOC_FSL_PCM) += snd-soc-fsl-pcm.o
diff --git a/sound/soc/fsl/fsl-pcm-dma.c b/sound/soc/fsl/fsl-pcm-dma.c
new file mode 100644
index 0000000..c4d925e
--- /dev/null
+++ b/sound/soc/fsl/fsl-pcm-dma.c
@@ -0,0 +1,51 @@
+/*
+ * Copyright 2012-2013 Freescale Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
+ */
+
+#include <linux/dmaengine.h>
+#include <sound/dmaengine_pcm.h>
+#include "fsl-sai.h"
+
+static struct snd_pcm_hardware snd_fsl_hardware = {
+	.info = SNDRV_PCM_INFO_INTERLEAVED |
+		SNDRV_PCM_INFO_BLOCK_TRANSFER |
+		SNDRV_PCM_INFO_MMAP |
+		SNDRV_PCM_INFO_MMAP_VALID |
+		SNDRV_PCM_INFO_PAUSE |
+		SNDRV_PCM_INFO_RESUME,
+	.formats = SNDRV_PCM_FMTBIT_S16_LE,
+	.rate_min = 8000,
+	.channels_min = 2,
+	.channels_max = 2,
+	.buffer_bytes_max = FSL_SAI_DMABUF_SIZE,
+	.period_bytes_min = 4096,
+	.period_bytes_max = FSL_SAI_DMABUF_SIZE / TCD_NUMBER,
+	.periods_min = TCD_NUMBER,
+	.periods_max = TCD_NUMBER,
+	.fifo_size = 0,
+};
+
+static const struct snd_dmaengine_pcm_config fsl_dmaengine_pcm_config = {
+	.pcm_hardware = &snd_fsl_hardware,
+	.prepare_slave_config = snd_dmaengine_pcm_prepare_slave_config,
+	.prealloc_buffer_size = FSL_SAI_DMABUF_SIZE,
+};
+
+int fsl_pcm_dma_init(struct platform_device *pdev)
+{
+	return snd_dmaengine_pcm_register(&pdev->dev, &fsl_dmaengine_pcm_config,
+			SND_DMAENGINE_PCM_FLAG_NO_RESIDUE);
+}
+EXPORT_SYMBOL_GPL(fsl_pcm_dma_init);
+
+void fsl_pcm_dma_exit(struct platform_device *pdev)
+{
+	snd_dmaengine_pcm_unregister(&pdev->dev);
+}
+EXPORT_SYMBOL_GPL(fsl_pcm_dma_exit);
diff --git a/sound/soc/fsl/fsl-sai.c b/sound/soc/fsl/fsl-sai.c
new file mode 100644
index 0000000..d4c8b44
--- /dev/null
+++ b/sound/soc/fsl/fsl-sai.c
@@ -0,0 +1,515 @@
+/*
+ * Freescale SAI ALSA SoC Digital Audio Interface driver.
+ *
+ * Copyright 2012-2013 Freescale Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ */
+
+#include <linux/clk.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/of_address.h>
+#include <sound/core.h>
+#include <sound/pcm_params.h>
+#include <linux/delay.h>
+
+#include "fsl-sai.h"
+
+static int fsl_sai_set_dai_sysclk_tr(struct snd_soc_dai *cpu_dai,
+		int clk_id, unsigned int freq, int fsl_dir)
+{
+	u32 val_cr2, reg_cr2;
+	struct fsl_sai *sai = snd_soc_dai_get_drvdata(cpu_dai);
+
+	if (fsl_dir == FSL_FMT_TRANSMITTER)
+		reg_cr2 = SAI_TCR2;
+	else
+		reg_cr2 = SAI_RCR2;
+
+	val_cr2 = readl(sai->base + reg_cr2);
+	switch (clk_id) {
+	case FSL_SAI_CLK_BUS:
+		val_cr2 &= ~SAI_CR2_MSEL_MASK;
+		val_cr2 |= SAI_CR2_MSEL_BUS;
+		break;
+	case FSL_SAI_CLK_MAST1:
+		val_cr2 &= ~SAI_CR2_MSEL_MASK;
+		val_cr2 |= SAI_CR2_MSEL_MCLK1;
+		break;
+	case FSL_SAI_CLK_MAST2:
+		val_cr2 &= ~SAI_CR2_MSEL_MASK;
+		val_cr2 |= SAI_CR2_MSEL_MCLK2;
+		break;
+	case FSL_SAI_CLK_MAST3:
+		val_cr2 &= ~SAI_CR2_MSEL_MASK;
+		val_cr2 |= SAI_CR2_MSEL_MCLK3;
+		break;
+	default:
+		return -EINVAL;
+	}
+	writel(val_cr2, sai->base + reg_cr2);
+
+	return 0;
+}
+
+static int fsl_sai_set_dai_sysclk(struct snd_soc_dai *cpu_dai,
+		int clk_id, unsigned int freq, int dir)
+{
+	int ret;
+
+	if (dir == SND_SOC_CLOCK_IN)
+		return 0;
+
+	ret = fsl_sai_set_dai_sysclk_tr(cpu_dai, clk_id, freq,
+					FSL_FMT_TRANSMITTER);
+	if (ret) {
+		dev_err(cpu_dai->dev,
+				"Cannot set sai's transmitter sysclk: %d\n",
+				ret);
+		return ret;
+	}
+
+	ret = fsl_sai_set_dai_sysclk_tr(cpu_dai, clk_id, freq,
+					FSL_FMT_RECEIVER);
+	if (ret) {
+		dev_err(cpu_dai->dev,
+				"Cannot set sai's receiver sysclk: %d\n",
+				ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int fsl_sai_set_dai_clkdiv(struct snd_soc_dai *cpu_dai,
+		int div_id, int div)
+{
+	struct fsl_sai *sai = snd_soc_dai_get_drvdata(cpu_dai);
+	u32 tcr2, rcr2;
+
+	if (div_id == FSL_SAI_TX_DIV) {
+		tcr2 = readl(sai->base + SAI_TCR2);
+		tcr2 &= ~SAI_CR2_DIV_MASK;
+		tcr2 |= SAI_CR2_DIV(div);
+		writel(tcr2, sai->base + SAI_TCR2);
+
+	} else if (div_id == FSL_SAI_RX_DIV) {
+		rcr2 = readl(sai->base + SAI_RCR2);
+		rcr2 &= ~SAI_CR2_DIV_MASK;
+		rcr2 |= SAI_CR2_DIV(div);
+		writel(rcr2, sai->base + SAI_RCR2);
+
+	} else
+		return -EINVAL;
+
+	return 0;
+}
+
+static int fsl_sai_set_dai_fmt_tr(struct snd_soc_dai *cpu_dai,
+				unsigned int fmt, int fsl_dir)
+{
+	u32 val_cr2, val_cr3, val_cr4, reg_cr2, reg_cr3, reg_cr4;
+	struct fsl_sai *sai = snd_soc_dai_get_drvdata(cpu_dai);
+
+	if (fsl_dir == FSL_FMT_TRANSMITTER) {
+		reg_cr2 = SAI_TCR2;
+		reg_cr3 = SAI_TCR3;
+		reg_cr4 = SAI_TCR4;
+	} else {
+		reg_cr2 = SAI_RCR2;
+		reg_cr3 = SAI_RCR3;
+		reg_cr4 = SAI_RCR4;
+	}
+
+	val_cr2 = readl(sai->base + reg_cr2);
+	val_cr3 = readl(sai->base + reg_cr3);
+	val_cr4 = readl(sai->base + reg_cr4);
+
+	if (sai->fbt == FSL_SAI_FBT_MSB)
+		val_cr4 |= SAI_CR4_MF;
+	else if (sai->fbt == FSL_SAI_FBT_LSB)
+		val_cr4 &= ~SAI_CR4_MF;
+
+	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
+	case SND_SOC_DAIFMT_I2S:
+		val_cr4 |= SAI_CR4_FSE;
+		val_cr4 |= SAI_CR4_FSP;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	switch (fmt & SND_SOC_DAIFMT_INV_MASK) {
+	case SND_SOC_DAIFMT_IB_IF:
+		val_cr4 |= SAI_CR4_FSP;
+		val_cr2 &= ~SAI_CR2_BCP;
+		break;
+	case SND_SOC_DAIFMT_IB_NF:
+		val_cr4 &= ~SAI_CR4_FSP;
+		val_cr2 &= ~SAI_CR2_BCP;
+		break;
+	case SND_SOC_DAIFMT_NB_IF:
+		val_cr4 |= SAI_CR4_FSP;
+		val_cr2 |= SAI_CR2_BCP;
+		break;
+	case SND_SOC_DAIFMT_NB_NF:
+		val_cr4 &= ~SAI_CR4_FSP;
+		val_cr2 |= SAI_CR2_BCP;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
+	case SND_SOC_DAIFMT_CBS_CFS:
+		val_cr2 |= SAI_CR2_BCD_MSTR;
+		val_cr4 |= SAI_CR4_FSD_MSTR;
+		break;
+	case SND_SOC_DAIFMT_CBM_CFM:
+		val_cr2 &= ~SAI_CR2_BCD_MSTR;
+		val_cr4 &= ~SAI_CR4_FSD_MSTR;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	val_cr3 |= SAI_CR3_TRCE;
+
+	if (fsl_dir == FSL_FMT_RECEIVER)
+		val_cr2 |= SAI_CR2_SYNC;
+
+	writel(val_cr2, sai->base + reg_cr2);
+	writel(val_cr3, sai->base + reg_cr3);
+	writel(val_cr4, sai->base + reg_cr4);
+
+	return 0;
+
+}
+
+static int fsl_sai_set_dai_fmt(struct snd_soc_dai *cpu_dai, unsigned int fmt)
+{
+	int ret;
+
+	ret = fsl_sai_set_dai_fmt_tr(cpu_dai, fmt, FSL_FMT_TRANSMITTER);
+	if (ret) {
+		dev_err(cpu_dai->dev,
+				"Cannot set sai's transmitter format: %d\n",
+				ret);
+		return ret;
+	}
+
+	ret = fsl_sai_set_dai_fmt_tr(cpu_dai, fmt, FSL_FMT_RECEIVER);
+	if (ret) {
+		dev_err(cpu_dai->dev,
+				"Cannot set sai's receiver format: %d\n",
+				ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int fsl_sai_set_dai_tdm_slot(struct snd_soc_dai *cpu_dai,
+		unsigned int tx_mask, unsigned int rx_mask,
+		int slots, int slot_width)
+{
+	struct fsl_sai *sai = snd_soc_dai_get_drvdata(cpu_dai);
+	u32 tcr4, rcr4;
+
+	tcr4 = readl(sai->base + SAI_TCR4);
+	tcr4 &= ~SAI_CR4_FRSZ_MASK;
+	tcr4 |= SAI_CR4_FRSZ(2);
+	writel(tcr4, sai->base + SAI_TCR4);
+	writel(tx_mask, sai->base + SAI_TMR);
+
+	rcr4 = readl(sai->base + SAI_RCR4);
+	rcr4 &= ~SAI_CR4_FRSZ_MASK;
+	rcr4 |= SAI_CR4_FRSZ(2);
+	writel(rcr4, sai->base + SAI_RCR4);
+	writel(rx_mask, sai->base + SAI_RMR);
+
+	return 0;
+}
+
+static int fsl_sai_hw_params_tr(struct snd_pcm_substream *substream,
+		struct snd_pcm_hw_params *params,
+		struct snd_soc_dai *cpu_dai, int fsl_dir)
+{
+	u32 val_cr4, val_cr5, reg_cr4, reg_cr5, word_width;
+	struct fsl_sai *sai = snd_soc_dai_get_drvdata(cpu_dai);
+
+	if (fsl_dir == FSL_FMT_TRANSMITTER) {
+		reg_cr4 = SAI_TCR4;
+		reg_cr5 = SAI_TCR5;
+	} else {
+		reg_cr4 = SAI_RCR4;
+		reg_cr5 = SAI_RCR5;
+	}
+
+	val_cr4 = readl(sai->base + reg_cr4);
+	val_cr4 &= ~SAI_CR4_SYWD_MASK;
+
+	val_cr5 = readl(sai->base + reg_cr5);
+	val_cr5 &= ~SAI_CR5_WNW_MASK;
+	val_cr5 &= ~SAI_CR5_W0W_MASK;
+	val_cr5 &= ~SAI_CR5_FBT_MASK;
+
+	switch (params_format(params)) {
+	case SNDRV_PCM_FORMAT_S16_LE:
+		word_width = 16;
+		break;
+	case SNDRV_PCM_FORMAT_S20_3LE:
+		word_width = 20;
+		break;
+	case SNDRV_PCM_FORMAT_S24_LE:
+		word_width = 24;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	val_cr4 |= SAI_CR4_SYWD(word_width);
+	val_cr5 |= SAI_CR5_WNW(word_width);
+	val_cr5 |= SAI_CR5_W0W(word_width);
+
+	if (sai->fbt == FSL_SAI_FBT_MSB)
+		val_cr5 |= SAI_CR5_FBT(word_width - 1);
+	else if (sai->fbt == FSL_SAI_FBT_LSB)
+		val_cr5 |= SAI_CR5_FBT(0);
+
+	writel(val_cr4, sai->base + reg_cr4);
+	writel(val_cr5, sai->base + reg_cr5);
+
+	return 0;
+
+}
+
+static int fsl_sai_hw_params(struct snd_pcm_substream *substream,
+		struct snd_pcm_hw_params *params,
+		struct snd_soc_dai *cpu_dai)
+{
+	int ret;
+
+	ret = fsl_sai_hw_params_tr(substream, params, cpu_dai,
+				FSL_FMT_TRANSMITTER);
+	if (ret) {
+		dev_err(cpu_dai->dev,
+				"Cannot set sai transmitter hw params: %d\n",
+				ret);
+		return ret;
+	}
+
+	ret = fsl_sai_hw_params_tr(substream, params, cpu_dai,
+				FSL_FMT_RECEIVER);
+	if (ret) {
+		dev_err(cpu_dai->dev,
+				"Cannot set sai's receiver hw params: %d\n",
+				ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int fsl_sai_trigger(struct snd_pcm_substream *substream, int cmd,
+		struct snd_soc_dai *dai)
+{
+	struct fsl_sai *sai = snd_soc_dai_get_drvdata(dai);
+	unsigned int tcsr, rcsr;
+
+	tcsr = readl(sai->base + SAI_TCSR);
+	rcsr = readl(sai->base + SAI_RCSR);
+
+	switch (cmd) {
+	case SNDRV_PCM_TRIGGER_START:
+	case SNDRV_PCM_TRIGGER_RESUME:
+	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
+		rcsr |= SAI_CSR_TERE | SAI_CSR_FRDE;
+		tcsr |= SAI_CSR_TERE | SAI_CSR_FRDE;
+		writel(rcsr, sai->base + SAI_RCSR);
+		udelay(10);
+		writel(tcsr, sai->base + SAI_TCSR);
+		break;
+
+	case SNDRV_PCM_TRIGGER_STOP:
+	case SNDRV_PCM_TRIGGER_SUSPEND:
+	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
+		tcsr &= ~(SAI_CSR_TERE | SAI_CSR_FRDE);
+		rcsr &= ~(SAI_CSR_TERE | SAI_CSR_FRDE);
+		writel(tcsr, sai->base + SAI_TCSR);
+		udelay(10);
+		writel(rcsr, sai->base + SAI_RCSR);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static struct snd_soc_dai_ops fsl_sai_pcm_dai_ops = {
+	.set_sysclk	= fsl_sai_set_dai_sysclk,
+	.set_clkdiv	= fsl_sai_set_dai_clkdiv,
+	.set_fmt	= fsl_sai_set_dai_fmt,
+	.set_tdm_slot	= fsl_sai_set_dai_tdm_slot,
+	.hw_params	= fsl_sai_hw_params,
+	.trigger	= fsl_sai_trigger,
+};
+
+static int fsl_sai_dai_probe(struct snd_soc_dai *dai)
+{
+	int ret;
+	struct fsl_sai *sai = dev_get_drvdata(dai->dev);
+
+	ret = clk_prepare_enable(sai->clk);
+	if (ret)
+		return ret;
+
+	writel(0x0, sai->base + SAI_RCSR);
+	writel(0x0, sai->base + SAI_TCSR);
+	writel(sai->dma_params_tx.maxburst, sai->base + SAI_TCR1);
+	writel(sai->dma_params_rx.maxburst, sai->base + SAI_RCR1);
+
+	dai->playback_dma_data = &sai->dma_params_tx;
+	dai->capture_dma_data = &sai->dma_params_rx;
+
+	snd_soc_dai_set_drvdata(dai, sai);
+
+	return 0;
+}
+
+int fsl_sai_dai_remove(struct snd_soc_dai *dai)
+{
+	struct fsl_sai *sai = dev_get_drvdata(dai->dev);
+
+	clk_disable_unprepare(sai->clk);
+
+	return 0;
+}
+
+static struct snd_soc_dai_driver fsl_sai_dai = {
+	.probe = fsl_sai_dai_probe,
+	.remove = fsl_sai_dai_remove,
+	.playback = {
+		.channels_min = 1,
+		.channels_max = 2,
+		.rates = SNDRV_PCM_RATE_8000_96000,
+		.formats = FSL_SAI_FORMATS,
+	},
+	.capture = {
+		.channels_min = 1,
+		.channels_max = 2,
+		.rates = SNDRV_PCM_RATE_8000_96000,
+		.formats = FSL_SAI_FORMATS,
+	},
+	.ops = &fsl_sai_pcm_dai_ops,
+};
+
+static const struct snd_soc_component_driver fsl_component = {
+	.name           = "fsl-sai",
+};
+
+static int fsl_sai_probe(struct platform_device *pdev)
+{
+	struct of_phandle_args	dma_args;
+	int index;
+	struct resource *res;
+	struct fsl_sai *sai;
+	int ret = 0;
+	struct device_node *np = pdev->dev.of_node;
+
+	sai = devm_kzalloc(&pdev->dev, sizeof(*sai), GFP_KERNEL);
+	if (!sai)
+		return -ENOMEM;
+
+	sai->fbt = FSL_SAI_FBT_MSB;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	sai->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(sai->base)) {
+		ret = PTR_ERR(sai->base);
+		return ret;
+	}
+
+	sai->clk = devm_clk_get(&pdev->dev, "sai");
+	if (IS_ERR(sai->clk)) {
+		ret = PTR_ERR(sai->clk);
+		dev_err(&pdev->dev, "Cannot get sai's clock: %d\n", ret);
+		return ret;
+	}
+
+	sai->dma_params_rx.addr = res->start + SAI_RDR;
+	sai->dma_params_rx.maxburst = 6;
+	index = of_property_match_string(np, "dma-names", "rx");
+	ret = of_parse_phandle_with_args(np, "dmas", "#dma-cells", index,
+				&dma_args);
+	if (ret)
+		return ret;
+	sai->dma_params_rx.slave_id = dma_args.args[1];
+
+	sai->dma_params_tx.addr = res->start + SAI_TDR;
+	sai->dma_params_tx.maxburst = 6;
+	index = of_property_match_string(np, "dma-names", "tx");
+	ret = of_parse_phandle_with_args(np, "dmas", "#dma-cells", index,
+				&dma_args);
+	if (ret)
+		return ret;
+	sai->dma_params_tx.slave_id = dma_args.args[1];
+
+	ret = snd_soc_register_component(&pdev->dev, &fsl_component,
+			&fsl_sai_dai, 1);
+	if (ret)
+		return ret;
+
+	ret = fsl_pcm_dma_init(pdev);
+	if (ret)
+		goto out;
+
+	platform_set_drvdata(pdev, sai);
+
+	return 0;
+
+out:
+	snd_soc_unregister_component(&pdev->dev);
+	return ret;
+}
+
+static int fsl_sai_remove(struct platform_device *pdev)
+{
+	struct fsl_sai *sai = platform_get_drvdata(pdev);
+
+	fsl_pcm_dma_exit(pdev);
+
+	snd_soc_unregister_component(&pdev->dev);
+
+	clk_disable_unprepare(sai->clk);
+
+	return 0;
+}
+
+static const struct of_device_id fsl_sai_ids[] = {
+	{ .compatible = "fsl,vf610-sai", },
+	{ /*sentinel*/ },
+};
+
+static struct platform_driver fsl_sai_driver = {
+	.probe = fsl_sai_probe,
+	.remove = fsl_sai_remove,
+
+	.driver = {
+		.name = "fsl-sai",
+		.owner = THIS_MODULE,
+		.of_match_table = fsl_sai_ids,
+	},
+};
+module_platform_driver(fsl_sai_driver);
+
+MODULE_AUTHOR("Xiubo Li, <Li.Xiubo@freescale.com>");
+MODULE_AUTHOR("Alison Wang, <b18965@freescale.com>");
+MODULE_DESCRIPTION("Freescale Soc SAI Interface");
+MODULE_LICENSE("GPL");
diff --git a/sound/soc/fsl/fsl-sai.h b/sound/soc/fsl/fsl-sai.h
new file mode 100644
index 0000000..ab76a8e
--- /dev/null
+++ b/sound/soc/fsl/fsl-sai.h
@@ -0,0 +1,127 @@
+/*
+ * Copyright 2012-2013 Freescale Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __FSL_SAI_H
+#define __FSL_SAI_H
+
+#include <sound/dmaengine_pcm.h>
+
+#define FSL_SAI_FORMATS (SNDRV_PCM_FMTBIT_S16_LE |\
+			 SNDRV_PCM_FMTBIT_S20_3LE |\
+			 SNDRV_PCM_FMTBIT_S24_LE)
+
+#define FSL_SAI_DMABUF_SIZE	(32 * 1024)
+#define TCD_NUMBER		4
+#define EDMA_PRIO_HIGH          6
+
+/* SAI Transmit/Recieve Control Register */
+#define SAI_TCSR		0x00
+#define SAI_RCSR		0x80
+#define SAI_CSR_TERE		BIT(31)
+#define SAI_CSR_FWF		BIT(17)
+#define SAI_CSR_FRIE		BIT(8)
+#define SAI_CSR_FRDE		BIT(0)
+
+/* SAI Transmit Data/FIFO/MASK Register */
+#define SAI_TDR			0x20
+#define SAI_TFR			0x40
+#define SAI_TMR			0x60
+
+/* SAI Recieve Data/FIFO/MASK Register */
+#define SAI_RDR			0xa0
+#define SAI_RFR			0xc0
+#define SAI_RMR			0xe0
+
+/* SAI Transmit and Recieve Configuration 1 Register */
+#define SAI_TCR1		0x04
+#define SAI_RCR1		0x84
+
+/* SAI Transmit and Recieve Configuration 2 Register */
+#define SAI_TCR2		0x08
+#define SAI_RCR2		0x88
+#define SAI_CR2_SYNC		BIT(30)
+#define SAI_CR2_MSEL_MASK	(0xff << 26)
+#define SAI_CR2_MSEL_BUS	0
+#define SAI_CR2_MSEL_MCLK1	BIT(26)
+#define SAI_CR2_MSEL_MCLK2	BIT(27)
+#define SAI_CR2_MSEL_MCLK3	(BIT(26)|BIT(27))
+#define SAI_CR2_BCP		BIT(25)
+#define SAI_CR2_BCD_MSTR	BIT(24)
+#define SAI_CR2_DIV(x)		(x)
+#define SAI_CR2_DIV_MASK	0xff
+
+/* SAI Transmit and Recieve Configuration 3 Register */
+#define SAI_TCR3		0x0c
+#define SAI_RCR3		0x8c
+#define SAI_CR3_TRCE		BIT(16)
+#define SAI_CR3_WDFL(x)		(x)
+#define SAI_CR3_WDFL_MASK	0x1f
+
+/* SAI Transmit and Recieve Configuration 4 Register */
+#define SAI_TCR4		0x10
+#define SAI_RCR4		0x90
+#define SAI_CR4_FRSZ(x)		(((x) - 1) << 16)
+#define SAI_CR4_FRSZ_MASK	(0x1f << 16)
+#define SAI_CR4_SYWD(x)		(((x) - 1) << 8)
+#define SAI_CR4_SYWD_MASK	(0x1f << 8)
+#define SAI_CR4_MF		BIT(4)
+#define SAI_CR4_FSE		BIT(3)
+#define SAI_CR4_FSP		BIT(1)
+#define SAI_CR4_FSD_MSTR	BIT(0)
+
+/* SAI Transmit and Recieve Configuration 5 Register */
+#define SAI_TCR5		0x14
+#define SAI_RCR5		0x94
+#define SAI_CR5_WNW(x)		(((x) - 1) << 24)
+#define SAI_CR5_WNW_MASK	(0x1f << 24)
+#define SAI_CR5_W0W(x)		(((x) - 1) << 16)
+#define SAI_CR5_W0W_MASK	(0x1f << 16)
+#define SAI_CR5_FBT(x)		((x) << 8)
+#define SAI_CR5_FBT_MASK	(0x1f << 8)
+
+/* SAI audio dividers */
+#define FSL_SAI_TX_DIV		0
+#define FSL_SAI_RX_DIV		1
+
+/* SAI type */
+#define FSL_SAI_DMA		BIT(0)
+#define FSL_SAI_USE_AC97	BIT(1)
+#define FSL_SAI_NET		BIT(2)
+#define FSL_SAI_TRA_SYN		BIT(3)
+#define FSL_SAI_REC_SYN		BIT(4)
+#define FSL_SAI_USE_I2S_SLAVE	BIT(5)
+
+#define FSL_FMT_TRANSMITTER	0
+#define FSL_FMT_RECEIVER	1
+
+/* SAI clock sources */
+#define FSL_SAI_CLK_BUS		0
+#define FSL_SAI_CLK_MAST1	1
+#define FSL_SAI_CLK_MAST2	2
+#define FSL_SAI_CLK_MAST3	3
+
+enum fsl_sai_fbt {
+	FSL_SAI_FBT_MSB,
+	FSL_SAI_FBT_LSB,
+};
+
+struct fsl_sai {
+	struct clk *clk;
+
+	void __iomem *base;
+
+	enum fsl_sai_fbt fbt;
+
+	struct snd_dmaengine_dai_dma_data dma_params_rx;
+	struct snd_dmaengine_dai_dma_data dma_params_tx;
+};
+
+int fsl_pcm_dma_init(struct platform_device *pdev);
+void fsl_pcm_dma_exit(struct platform_device *pdev);
+
+#endif /* __FSL_SAI_H */
-- 
1.8.0


