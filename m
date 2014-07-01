Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343AbaGADdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 23:33:16 -0400
Received: from cluster-d.mailcontrol.com ([85.115.60.190]:40135 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbaGADdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 23:33:12 -0400
X-PGP-Universal: processed;
	by shaapppus01.asia.root.pri on Tue, 01 Jul 2014 10:20:27 +0800
From: Rongjun Ying <rongjun.ying@csr.com>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Barry Song <baohua@kernel.org>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, <linux-kernel@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <Workgroup.linux@csr.com>
CC: Rongjun Ying <rongjun.ying@csr.com>
Subject: [PATCH 1/2] ASoC: sirf: Add audio usp interface driver
Date: Tue, 1 Jul 2014 10:18:53 +0800
Message-ID: <1404181134-21663-2-git-send-email-rongjun.ying@csr.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404181134-21663-1-git-send-email-rongjun.ying@csr.com>
References: <1404181134-21663-1-git-send-email-rongjun.ying@csr.com>
MIME-Version: 1.0
X-Originating-IP: [10.125.12.180]
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds ASoC support for SiRF SoCs USP interface.
Features include:
1. Only support slave mode.
2. Support I2S and DSP_A mode.
3. Support S16_LE, S24_LE and S24_3LE formats.
4. Support stereo and mono mode.
5. The biggest Support is 192Khz sample rate.

Signed-off-by: Rongjun Ying <rongjun.ying@csr.com>
---
 sound/soc/sirf/Kconfig    |   6 +
 sound/soc/sirf/Makefile   |   2 +
 sound/soc/sirf/sirf-usp.c | 409 ++++++++++++++++++++++++++++++++++++++++++++++
 sound/soc/sirf/sirf-usp.h | 293 +++++++++++++++++++++++++++++++++
 4 files changed, 710 insertions(+)
 create mode 100644 sound/soc/sirf/sirf-usp.c
 create mode 100644 sound/soc/sirf/sirf-usp.h

diff --git a/sound/soc/sirf/Kconfig b/sound/soc/sirf/Kconfig
index 89e8942..840058d 100644
--- a/sound/soc/sirf/Kconfig
+++ b/sound/soc/sirf/Kconfig
@@ -12,3 +12,9 @@ config SND_SOC_SIRF_AUDIO
 config SND_SOC_SIRF_AUDIO_PORT
 	select REGMAP_MMIO
 	tristate
+
+config SND_SOC_SIRF_USP
+	tristate "SoC Audio (I2S protocol) for SiRF SoC USP interface"
+	depends on SND_SOC_SIRF
+	select REGMAP_MMIO
+	tristate
diff --git a/sound/soc/sirf/Makefile b/sound/soc/sirf/Makefile
index 913b932..dd917f2 100644
--- a/sound/soc/sirf/Makefile
+++ b/sound/soc/sirf/Makefile
@@ -1,5 +1,7 @@
 snd-soc-sirf-audio-objs := sirf-audio.o
 snd-soc-sirf-audio-port-objs := sirf-audio-port.o
+snd-soc-sirf-usp-objs := sirf-usp.o
 
 obj-$(CONFIG_SND_SOC_SIRF_AUDIO) += snd-soc-sirf-audio.o
 obj-$(CONFIG_SND_SOC_SIRF_AUDIO_PORT) += snd-soc-sirf-audio-port.o
+obj-$(CONFIG_SND_SOC_SIRF_USP) += snd-soc-sirf-usp.o
diff --git a/sound/soc/sirf/sirf-usp.c b/sound/soc/sirf/sirf-usp.c
new file mode 100644
index 0000000..fe2a2f9
--- /dev/null
+++ b/sound/soc/sirf/sirf-usp.c
@@ -0,0 +1,409 @@
+/*
+ * SiRF USP in I2S/DSP mode
+ *
+ * Copyright (c) 2011 Cambridge Silicon Radio Limited, a CSR plc group company.
+ *
+ * Licensed under GPLv2 or later.
+ */
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/clk.h>
+#include <linux/pm_runtime.h>
+#include <sound/soc.h>
+#include <sound/pcm_params.h>
+#include <sound/dmaengine_pcm.h>
+
+#include "sirf-usp.h"
+
+struct sirf_usp {
+	struct regmap *regmap;
+	struct clk *clk;
+	u32 mode1_reg;
+	u32 mode2_reg;
+	int daifmt_format;
+	struct snd_dmaengine_dai_dma_data playback_dma_data;
+	struct snd_dmaengine_dai_dma_data capture_dma_data;
+};
+
+static void sirf_usp_tx_enable(struct sirf_usp *usp)
+{
+	regmap_update_bits(usp->regmap, USP_TX_FIFO_OP,
+		USP_TX_FIFO_RESET, USP_TX_FIFO_RESET);
+	regmap_write(usp->regmap, USP_TX_FIFO_OP, 0);
+
+	regmap_update_bits(usp->regmap, USP_TX_FIFO_OP,
+		USP_TX_FIFO_START, USP_TX_FIFO_START);
+
+	regmap_update_bits(usp->regmap, USP_TX_RX_ENABLE,
+		USP_TX_ENA, USP_TX_ENA);
+}
+
+static void sirf_usp_tx_disable(struct sirf_usp *usp)
+{
+	regmap_update_bits(usp->regmap, USP_TX_RX_ENABLE,
+		USP_TX_ENA, ~USP_TX_ENA);
+	/* FIFO stop */
+	regmap_write(usp->regmap, USP_TX_FIFO_OP, 0);
+}
+
+static void sirf_usp_rx_enable(struct sirf_usp *usp)
+{
+	regmap_update_bits(usp->regmap, USP_RX_FIFO_OP,
+		USP_RX_FIFO_RESET, USP_RX_FIFO_RESET);
+	regmap_write(usp->regmap, USP_RX_FIFO_OP, 0);
+
+	regmap_update_bits(usp->regmap, USP_RX_FIFO_OP,
+		USP_RX_FIFO_START, USP_RX_FIFO_START);
+
+	regmap_update_bits(usp->regmap, USP_TX_RX_ENABLE,
+		USP_RX_ENA, USP_RX_ENA);
+}
+
+static void sirf_usp_rx_disable(struct sirf_usp *usp)
+{
+	regmap_update_bits(usp->regmap, USP_TX_RX_ENABLE,
+		USP_RX_ENA, ~USP_RX_ENA);
+	/* FIFO stop */
+	regmap_write(usp->regmap, USP_RX_FIFO_OP, 0);
+}
+
+static int sirf_usp_pcm_dai_probe(struct snd_soc_dai *dai)
+{
+	struct sirf_usp *usp = snd_soc_dai_get_drvdata(dai);
+	snd_soc_dai_init_dma_data(dai, &usp->playback_dma_data,
+			&usp->capture_dma_data);
+	return 0;
+}
+
+static int sirf_usp_pcm_set_dai_fmt(struct snd_soc_dai *dai,
+		unsigned int fmt)
+{
+	struct sirf_usp *usp = snd_soc_dai_get_drvdata(dai);
+
+	/* set master/slave audio interface */
+	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
+	case SND_SOC_DAIFMT_CBM_CFM:
+		break;
+	default:
+		dev_err(dai->dev, "Only CBM and CFM supported\n");
+		return -EINVAL;
+	}
+
+	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
+	case SND_SOC_DAIFMT_I2S:
+	case SND_SOC_DAIFMT_DSP_A:
+		usp->daifmt_format = (fmt & SND_SOC_DAIFMT_FORMAT_MASK);
+		break;
+	default:
+		dev_err(dai->dev, "Only I2S and DSP_A format supported\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int sirf_usp_i2s_startup(struct snd_pcm_substream *substream,
+		struct snd_soc_dai *dai)
+{
+	struct sirf_usp *usp = snd_soc_dai_get_drvdata(dai);
+
+	/* Configure RISC mode */
+	regmap_update_bits(usp->regmap, USP_RISC_DSP_MODE,
+		USP_RISC_DSP_SEL, ~USP_RISC_DSP_SEL);
+
+	/*
+	 * Configure DMA IO Length register
+	 * Set no limit, USP can receive data continuously until it is diabled
+	 */
+	regmap_write(usp->regmap, USP_TX_DMA_IO_LEN, 0);
+	regmap_write(usp->regmap, USP_RX_DMA_IO_LEN, 0);
+
+	regmap_write(usp->regmap, USP_RX_FRAME_CTRL, USP_SINGLE_SYNC_MODE);
+
+	regmap_write(usp->regmap, USP_TX_FRAME_CTRL, USP_TXC_SLAVE_CLK_SAMPLE);
+
+	/* Configure Mode2 register */
+	regmap_write(usp->regmap, USP_MODE2, (1 << USP_RXD_DELAY_LEN_OFFSET) |
+		(0 << USP_TXD_DELAY_LEN_OFFSET));
+
+	/* Configure Mode1 register */
+	regmap_write(usp->regmap, USP_MODE1,
+		USP_SYNC_MODE | USP_EN | USP_TXD_ACT_EDGE_FALLING |
+		USP_RFS_ACT_LEVEL_LOGIC1 | USP_TFS_ACT_LEVEL_LOGIC1 |
+		USP_TX_UFLOW_REPEAT_ZERO);
+
+	/* Configure RX DMA IO Control register */
+	regmap_write(usp->regmap, USP_RX_DMA_IO_CTRL, 0);
+
+	/* Congiure RX FIFO Control register */
+	regmap_write(usp->regmap, USP_RX_FIFO_CTRL,
+		(USP_RX_FIFO_THRESHOLD << USP_RX_FIFO_THD_OFFSET) |
+		(USP_TX_RX_FIFO_WIDTH_DWORD << USP_RX_FIFO_WIDTH_OFFSET));
+
+	/* Congiure RX FIFO Level Check register */
+	regmap_write(usp->regmap, USP_RX_FIFO_LEVEL_CHK,
+		RX_FIFO_SC(0x04) | RX_FIFO_LC(0x0E) | RX_FIFO_HC(0x1B));
+
+	/* Configure TX DMA IO Control register*/
+	regmap_write(usp->regmap, USP_TX_DMA_IO_CTRL, 0);
+
+	/* Configure TX FIFO Control register */
+	regmap_write(usp->regmap, USP_TX_FIFO_CTRL,
+		(USP_TX_FIFO_THRESHOLD << USP_TX_FIFO_THD_OFFSET) |
+		(USP_TX_RX_FIFO_WIDTH_DWORD << USP_TX_FIFO_WIDTH_OFFSET));
+	/* Congiure TX FIFO Level Check register */
+	regmap_write(usp->regmap, USP_TX_FIFO_LEVEL_CHK,
+		TX_FIFO_SC(0x1B) | TX_FIFO_LC(0x0E) | TX_FIFO_HC(0x04));
+
+	return 0;
+}
+
+static int sirf_usp_pcm_hw_params(struct snd_pcm_substream *substream,
+		struct snd_pcm_hw_params *params, struct snd_soc_dai *dai)
+{
+	struct sirf_usp *usp = snd_soc_dai_get_drvdata(dai);
+	u32 data_len, frame_len, shifter_len;
+
+	switch (params_format(params)) {
+	case SNDRV_PCM_FORMAT_S16_LE:
+		data_len = 16;
+		frame_len = 16;
+		break;
+	case SNDRV_PCM_FORMAT_S24_LE:
+		data_len = 24;
+		frame_len = 32;
+		break;
+	case SNDRV_PCM_FORMAT_S24_3LE:
+		data_len = 24;
+		frame_len = 24;
+		break;
+	default:
+		dev_err(dai->dev, "Format unsupported\n");
+		return -EINVAL;
+	}
+
+	shifter_len = data_len;
+
+	if (usp->daifmt_format == SND_SOC_DAIFMT_I2S)
+		regmap_update_bits(usp->regmap, USP_RX_FRAME_CTRL,
+			USP_I2S_SYNC_CHG, USP_I2S_SYNC_CHG);
+	else if (usp->daifmt_format == SND_SOC_DAIFMT_DSP_A) {
+		regmap_update_bits(usp->regmap, USP_RX_FRAME_CTRL,
+			USP_I2S_SYNC_CHG, 0);
+		frame_len = data_len * params_channels(params);
+		data_len = frame_len;
+	}
+
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
+		regmap_update_bits(usp->regmap, USP_TX_FRAME_CTRL,
+			USP_TXC_DATA_LEN_MASK | USP_TXC_FRAME_LEN_MASK
+			| USP_TXC_SHIFTER_LEN_MASK,
+			((data_len - 1) << USP_TXC_DATA_LEN_OFFSET)
+			| ((frame_len - 1) << USP_TXC_FRAME_LEN_OFFSET)
+			| ((shifter_len - 1) << USP_TXC_SHIFTER_LEN_OFFSET));
+	else
+		regmap_update_bits(usp->regmap, USP_RX_FRAME_CTRL,
+			USP_RXC_DATA_LEN_MASK | USP_RXC_FRAME_LEN_MASK
+			| USP_RXC_SHIFTER_LEN_MASK,
+			((data_len - 1) << USP_RXC_DATA_LEN_OFFSET)
+			| ((frame_len - 1) << USP_RXC_FRAME_LEN_OFFSET)
+			| ((shifter_len - 1) << USP_RXC_SHIFTER_LEN_OFFSET));
+
+	regmap_update_bits(usp->regmap, USP_MODE1,
+			USP_CLOCK_MODE_SLAVE, USP_CLOCK_MODE_SLAVE);
+	regmap_update_bits(usp->regmap, USP_MODE2,
+			USP_TFS_CLK_SLAVE_MODE | USP_RFS_CLK_SLAVE_MODE,
+			USP_TFS_CLK_SLAVE_MODE | USP_RFS_CLK_SLAVE_MODE);
+
+	return 0;
+}
+
+static int sirf_usp_pcm_trigger(struct snd_pcm_substream *substream, int cmd,
+				struct snd_soc_dai *dai)
+{
+	int playback = substream->stream == SNDRV_PCM_STREAM_PLAYBACK;
+	struct sirf_usp *usp = snd_soc_dai_get_drvdata(dai);
+
+	switch (cmd) {
+	case SNDRV_PCM_TRIGGER_START:
+	case SNDRV_PCM_TRIGGER_RESUME:
+	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
+		if (playback)
+			sirf_usp_tx_enable(usp);
+		else
+			sirf_usp_rx_enable(usp);
+		break;
+	case SNDRV_PCM_TRIGGER_STOP:
+	case SNDRV_PCM_TRIGGER_SUSPEND:
+	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
+		if (playback)
+			sirf_usp_tx_disable(usp);
+		else
+			sirf_usp_rx_disable(usp);
+		break;
+	}
+
+	return 0;
+}
+
+static const struct snd_soc_dai_ops sirf_usp_pcm_dai_ops = {
+	.startup = sirf_usp_i2s_startup,
+	.trigger = sirf_usp_pcm_trigger,
+	.set_fmt = sirf_usp_pcm_set_dai_fmt,
+	.hw_params = sirf_usp_pcm_hw_params,
+};
+
+static struct snd_soc_dai_driver sirf_usp_pcm_dai = {
+	.probe = sirf_usp_pcm_dai_probe,
+	.name		= "sirf-usp-pcm",
+	.id			= 0,
+	.playback = {
+		.stream_name = "SiRF USP PCM Playback",
+		.channels_min = 1,
+		.channels_max = 2,
+		.rates = SNDRV_PCM_RATE_8000_192000,
+		.formats = SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S24_LE |
+			SNDRV_PCM_FMTBIT_S24_3LE,
+	},
+	.capture = {
+		.stream_name = "SiRF USP PCM Capture",
+		.channels_min = 1,
+		.channels_max = 2,
+		.rates = SNDRV_PCM_RATE_8000_192000,
+		.formats = SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S24_LE |
+			SNDRV_PCM_FMTBIT_S24_3LE,
+	},
+	.ops = &sirf_usp_pcm_dai_ops,
+};
+
+#ifdef CONFIG_PM_RUNTIME
+static int sirf_usp_pcm_runtime_suspend(struct device *dev)
+{
+	struct sirf_usp *usp = dev_get_drvdata(dev);
+	clk_disable_unprepare(usp->clk);
+	return 0;
+}
+
+static int sirf_usp_pcm_runtime_resume(struct device *dev)
+{
+	struct sirf_usp *usp = dev_get_drvdata(dev);
+	return clk_prepare_enable(usp->clk);
+}
+#endif
+
+#ifdef CONFIG_PM_SLEEP
+static int sirf_usp_pcm_suspend(struct device *dev)
+{
+	struct sirf_usp *usp = dev_get_drvdata(dev);
+
+	if (!pm_runtime_status_suspended(dev)) {
+		regmap_read(usp->regmap, USP_MODE1, &usp->mode1_reg);
+		regmap_read(usp->regmap, USP_MODE2, &usp->mode2_reg);
+		sirf_usp_pcm_runtime_suspend(dev);
+	}
+	return 0;
+}
+
+static int sirf_usp_pcm_resume(struct device *dev)
+{
+	struct sirf_usp *usp = dev_get_drvdata(dev);
+	int ret;
+
+	if (!pm_runtime_status_suspended(dev)) {
+		ret = sirf_usp_pcm_runtime_resume(dev);
+		if (ret)
+			return ret;
+		regmap_write(usp->regmap, USP_MODE1, usp->mode1_reg);
+		regmap_write(usp->regmap, USP_MODE2, usp->mode2_reg);
+	}
+	return 0;
+}
+#endif
+
+static const struct snd_soc_component_driver sirf_usp_component = {
+	.name		= "sirf-usp",
+};
+
+static const struct regmap_config sirf_usp_regmap_config = {
+	.reg_bits = 32,
+	.reg_stride = 4,
+	.val_bits = 32,
+	.max_register = USP_RX_FIFO_DATA,
+	.cache_type = REGCACHE_NONE,
+};
+
+static int sirf_usp_pcm_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct sirf_usp *usp;
+	void __iomem *base;
+	struct resource *mem_res;
+
+	usp = devm_kzalloc(&pdev->dev, sizeof(struct sirf_usp),
+			GFP_KERNEL);
+	if (!usp)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, usp);
+
+	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	base = devm_ioremap(&pdev->dev, mem_res->start,
+		resource_size(mem_res));
+	if (base == NULL)
+		return -ENOMEM;
+	usp->regmap = devm_regmap_init_mmio(&pdev->dev, base,
+					    &sirf_usp_regmap_config);
+	if (IS_ERR(usp->regmap))
+		return PTR_ERR(usp->regmap);
+
+	usp->clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(usp->clk)) {
+		dev_err(&pdev->dev, "Get clock failed.\n");
+		return PTR_ERR(usp->clk);
+	}
+
+	pm_runtime_enable(&pdev->dev);
+
+	ret = devm_snd_soc_register_component(&pdev->dev, &sirf_usp_component,
+		&sirf_usp_pcm_dai, 1);
+	if (ret) {
+		dev_err(&pdev->dev, "Register Audio SoC dai failed.\n");
+		return ret;
+	}
+	return devm_snd_dmaengine_pcm_register(&pdev->dev, NULL, 0);
+}
+
+static int sirf_usp_pcm_remove(struct platform_device *pdev)
+{
+	pm_runtime_disable(&pdev->dev);
+	return 0;
+}
+
+static const struct of_device_id sirf_usp_pcm_of_match[] = {
+	{ .compatible = "sirf,prima2-usp-pcm", },
+	{}
+};
+MODULE_DEVICE_TABLE(of, sirf_usp_pcm_of_match);
+
+static const struct dev_pm_ops sirf_usp_pcm_pm_ops = {
+	SET_RUNTIME_PM_OPS(sirf_usp_pcm_runtime_suspend, sirf_usp_pcm_runtime_resume, NULL)
+	SET_SYSTEM_SLEEP_PM_OPS(sirf_usp_pcm_suspend, sirf_usp_pcm_resume)
+};
+
+static struct platform_driver sirf_usp_pcm_driver = {
+	.driver = {
+		.name = "sirf-usp-pcm",
+		.owner = THIS_MODULE,
+		.of_match_table = sirf_usp_pcm_of_match,
+		.pm = &sirf_usp_pcm_pm_ops,
+	},
+	.probe = sirf_usp_pcm_probe,
+	.remove = sirf_usp_pcm_remove,
+};
+
+module_platform_driver(sirf_usp_pcm_driver);
+
+MODULE_DESCRIPTION("SiRF SoC USP PCM bus driver");
+MODULE_AUTHOR("RongJun Ying <Rongjun.Ying@csr.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/sound/soc/sirf/sirf-usp.h b/sound/soc/sirf/sirf-usp.h
new file mode 100644
index 0000000..bf0201c
--- /dev/null
+++ b/sound/soc/sirf/sirf-usp.h
@@ -0,0 +1,293 @@
+/*
+ * arch/arm/mach-prima2/include/mach/sirfsoc_usp.h
+ *
+ * Copyright (c) 2011 Cambridge Silicon Radio Limited, a CSR plc group company.
+ *
+ * Licensed under GPLv2 or later.
+ */
+
+#ifndef _SIRF_USP_H
+#define _SIRF_USP_H
+
+/* USP Registers */
+#define USP_MODE1		0x00
+#define USP_MODE2		0x04
+#define USP_TX_FRAME_CTRL	0x08
+#define USP_RX_FRAME_CTRL	0x0C
+#define USP_TX_RX_ENABLE	0x10
+#define USP_INT_ENABLE		0x14
+#define USP_INT_STATUS		0x18
+#define USP_PIN_IO_DATA		0x1C
+#define USP_RISC_DSP_MODE	0x20
+#define USP_AYSNC_PARAM_REG	0x24
+#define USP_IRDA_X_MODE_DIV	0x28
+#define USP_SM_CFG		0x2C
+#define USP_TX_DMA_IO_CTRL	0x100
+#define USP_TX_DMA_IO_LEN	0x104
+#define USP_TX_FIFO_CTRL	0x108
+#define USP_TX_FIFO_LEVEL_CHK	0x10C
+#define USP_TX_FIFO_OP		0x110
+#define USP_TX_FIFO_STATUS	0x114
+#define USP_TX_FIFO_DATA	0x118
+#define USP_RX_DMA_IO_CTRL	0x120
+#define USP_RX_DMA_IO_LEN	0x124
+#define USP_RX_FIFO_CTRL	0x128
+#define USP_RX_FIFO_LEVEL_CHK	0x12C
+#define USP_RX_FIFO_OP		0x130
+#define USP_RX_FIFO_STATUS	0x134
+#define USP_RX_FIFO_DATA	0x138
+
+/* USP MODE register-1 */
+#define USP_SYNC_MODE			0x00000001
+#define USP_CLOCK_MODE_SLAVE		0x00000002
+#define USP_LOOP_BACK_EN		0x00000004
+#define USP_HPSIR_EN			0x00000008
+#define USP_ENDIAN_CTRL_LSBF		0x00000010
+#define USP_EN				0x00000020
+#define USP_RXD_ACT_EDGE_FALLING	0x00000040
+#define USP_TXD_ACT_EDGE_FALLING	0x00000080
+#define USP_RFS_ACT_LEVEL_LOGIC1	0x00000100
+#define USP_TFS_ACT_LEVEL_LOGIC1	0x00000200
+#define USP_SCLK_IDLE_MODE_TOGGLE	0x00000400
+#define USP_SCLK_IDLE_LEVEL_LOGIC1	0x00000800
+#define USP_SCLK_PIN_MODE_IO	0x00001000
+#define USP_RFS_PIN_MODE_IO	0x00002000
+#define USP_TFS_PIN_MODE_IO	0x00004000
+#define USP_RXD_PIN_MODE_IO	0x00008000
+#define USP_TXD_PIN_MODE_IO	0x00010000
+#define USP_SCLK_IO_MODE_INPUT	0x00020000
+#define USP_RFS_IO_MODE_INPUT	0x00040000
+#define USP_TFS_IO_MODE_INPUT	0x00080000
+#define USP_RXD_IO_MODE_INPUT	0x00100000
+#define USP_TXD_IO_MODE_INPUT	0x00200000
+#define USP_IRDA_WIDTH_DIV_MASK	0x3FC00000
+#define USP_IRDA_WIDTH_DIV_OFFSET	0
+#define USP_IRDA_IDLE_LEVEL_HIGH	0x40000000
+#define USP_TX_UFLOW_REPEAT_ZERO	0x80000000
+#define USP_TX_ENDIAN_MODE		0x00000020
+#define USP_RX_ENDIAN_MODE		0x00000020
+
+/* USP Mode Register-2 */
+#define USP_RXD_DELAY_LEN_MASK		0x000000FF
+#define USP_RXD_DELAY_LEN_OFFSET	0
+
+#define USP_TXD_DELAY_LEN_MASK		0x0000FF00
+#define USP_TXD_DELAY_LEN_OFFSET	8
+
+#define USP_ENA_CTRL_MODE		0x00010000
+#define USP_FRAME_CTRL_MODE		0x00020000
+#define USP_TFS_SOURCE_MODE             0x00040000
+#define USP_TFS_MS_MODE                 0x00080000
+#define USP_CLK_DIVISOR_MASK		0x7FE00000
+#define USP_CLK_DIVISOR_OFFSET		21
+
+#define USP_TFS_CLK_SLAVE_MODE		(1<<20)
+#define USP_RFS_CLK_SLAVE_MODE		(1<<19)
+
+#define USP_IRDA_DATA_WIDTH		0x80000000
+
+/* USP Transmit Frame Control Register */
+
+#define USP_TXC_DATA_LEN_MASK		0x000000FF
+#define USP_TXC_DATA_LEN_OFFSET		0
+
+#define USP_TXC_SYNC_LEN_MASK		0x0000FF00
+#define USP_TXC_SYNC_LEN_OFFSET		8
+
+#define USP_TXC_FRAME_LEN_MASK		0x00FF0000
+#define USP_TXC_FRAME_LEN_OFFSET	16
+
+#define USP_TXC_SHIFTER_LEN_MASK	0x1F000000
+#define USP_TXC_SHIFTER_LEN_OFFSET	24
+
+#define USP_TXC_SLAVE_CLK_SAMPLE	0x20000000
+
+#define USP_TXC_CLK_DIVISOR_MASK	0xC0000000
+#define USP_TXC_CLK_DIVISOR_OFFSET	30
+
+/* USP Receive Frame Control Register */
+
+#define USP_RXC_DATA_LEN_MASK		0x000000FF
+#define USP_RXC_DATA_LEN_OFFSET		0
+
+#define USP_RXC_FRAME_LEN_MASK		0x0000FF00
+#define USP_RXC_FRAME_LEN_OFFSET	8
+
+#define USP_RXC_SHIFTER_LEN_MASK	0x001F0000
+#define USP_RXC_SHIFTER_LEN_OFFSET	16
+
+#define USP_START_EDGE_MODE	0x00800000
+#define USP_I2S_SYNC_CHG	0x00200000
+
+#define USP_RXC_CLK_DIVISOR_MASK	0x0F000000
+#define USP_RXC_CLK_DIVISOR_OFFSET	24
+#define USP_SINGLE_SYNC_MODE		0x00400000
+
+/* Tx - RX Enable Register */
+
+#define USP_RX_ENA		0x00000001
+#define USP_TX_ENA		0x00000002
+
+/* USP Interrupt Enable and status Register */
+#define USP_RX_DONE_INT			0x00000001
+#define USP_TX_DONE_INT			0x00000002
+#define USP_RX_OFLOW_INT		0x00000004
+#define USP_TX_UFLOW_INT		0x00000008
+#define USP_RX_IO_DMA_INT		0x00000010
+#define USP_TX_IO_DMA_INT		0x00000020
+#define USP_RXFIFO_FULL_INT		0x00000040
+#define USP_TXFIFO_EMPTY_INT		0x00000080
+#define USP_RXFIFO_THD_INT		0x00000100
+#define USP_TXFIFO_THD_INT		0x00000200
+#define USP_UART_FRM_ERR_INT		0x00000400
+#define USP_RX_TIMEOUT_INT		0x00000800
+#define USP_TX_ALLOUT_INT		0x00001000
+#define USP_RXD_BREAK_INT		0x00008000
+
+/* All possible TX interruots */
+#define USP_TX_INTERRUPT		(USP_TX_DONE_INT|USP_TX_UFLOW_INT|\
+					USP_TX_IO_DMA_INT|\
+					USP_TXFIFO_EMPTY_INT|\
+					USP_TXFIFO_THD_INT)
+/* All possible RX interruots */
+#define USP_RX_INTERRUPT		(USP_RX_DONE_INT|USP_RX_OFLOW_INT|\
+					USP_RX_IO_DMA_INT|\
+					USP_RXFIFO_FULL_INT|\
+					USP_RXFIFO_THD_INT|\
+					USP_RXFIFO_THD_INT|USP_RX_TIMEOUT_INT)
+
+#define USP_INT_ALL        0x1FFF
+
+/* USP Pin I/O Data Register */
+
+#define USP_RFS_PIN_VALUE_MASK	0x00000001
+#define USP_TFS_PIN_VALUE_MASK	0x00000002
+#define USP_RXD_PIN_VALUE_MASK	0x00000004
+#define USP_TXD_PIN_VALUE_MASK	0x00000008
+#define USP_SCLK_PIN_VALUE_MASK	0x00000010
+
+/* USP RISC/DSP Mode Register */
+#define USP_RISC_DSP_SEL	0x00000001
+
+/* USP ASYNC PARAMETER Register*/
+
+#define USP_ASYNC_TIMEOUT_MASK	0x0000FFFF
+#define USP_ASYNC_TIMEOUT_OFFSET	0
+#define USP_ASYNC_TIMEOUT(x)	(((x)&USP_ASYNC_TIMEOUT_MASK) \
+				<<USP_ASYNC_TIMEOUT_OFFSET)
+
+#define USP_ASYNC_DIV2_MASK		0x003F0000
+#define USP_ASYNC_DIV2_OFFSET		16
+
+/* USP TX DMA I/O MODE Register */
+#define USP_TX_MODE_IO			0x00000001
+
+/* USP TX DMA I/O Length Register */
+#define USP_TX_DATA_LEN_MASK		0xFFFFFFFF
+#define USP_TX_DATA_LEN_OFFSET		0
+
+/* USP TX FIFO Control Register */
+#define USP_TX_FIFO_WIDTH_MASK		0x00000003
+#define USP_TX_FIFO_WIDTH_OFFSET	0
+
+#define USP_TX_FIFO_THD_MASK		0x000001FC
+#define USP_TX_FIFO_THD_OFFSET		2
+
+/* USP TX FIFO Level Check Register */
+#define USP_TX_FIFO_LEVEL_CHECK_MASK	0x1F
+#define USP_TX_FIFO_SC_OFFSET	0
+#define USP_TX_FIFO_LC_OFFSET	10
+#define USP_TX_FIFO_HC_OFFSET	20
+
+#define TX_FIFO_SC(x)		(((x) & USP_TX_FIFO_LEVEL_CHECK_MASK) \
+				<< USP_TX_FIFO_SC_OFFSET)
+#define TX_FIFO_LC(x)		(((x) & USP_TX_FIFO_LEVEL_CHECK_MASK) \
+				<< USP_TX_FIFO_LC_OFFSET)
+#define TX_FIFO_HC(x)		(((x) & USP_TX_FIFO_LEVEL_CHECK_MASK) \
+				<< USP_TX_FIFO_HC_OFFSET)
+
+/* USP TX FIFO Operation Register */
+#define USP_TX_FIFO_RESET		0x00000001
+#define USP_TX_FIFO_START		0x00000002
+
+/* USP TX FIFO Status Register */
+#define USP_TX_FIFO_LEVEL_MASK		0x0000007F
+#define USP_TX_FIFO_LEVEL_OFFSET	0
+
+#define USP_TX_FIFO_FULL		0x00000080
+#define USP_TX_FIFO_EMPTY		0x00000100
+
+/* USP TX FIFO Data Register */
+#define USP_TX_FIFO_DATA_MASK		0xFFFFFFFF
+#define USP_TX_FIFO_DATA_OFFSET		0
+
+/* USP RX DMA I/O MODE Register */
+#define USP_RX_MODE_IO			0x00000001
+#define USP_RX_DMA_FLUSH		0x00000004
+
+/* USP RX DMA I/O Length Register */
+#define USP_RX_DATA_LEN_MASK		0xFFFFFFFF
+#define USP_RX_DATA_LEN_OFFSET		0
+
+/* USP RX FIFO Control Register */
+#define USP_RX_FIFO_WIDTH_MASK		0x00000003
+#define USP_RX_FIFO_WIDTH_OFFSET	0
+
+#define USP_RX_FIFO_THD_MASK		0x000001FC
+#define USP_RX_FIFO_THD_OFFSET		2
+
+/* USP RX FIFO Level Check Register */
+
+#define USP_RX_FIFO_LEVEL_CHECK_MASK	0x1F
+#define USP_RX_FIFO_SC_OFFSET	0
+#define USP_RX_FIFO_LC_OFFSET	10
+#define USP_RX_FIFO_HC_OFFSET	20
+
+#define RX_FIFO_SC(x)		(((x) & USP_RX_FIFO_LEVEL_CHECK_MASK) \
+				<< USP_RX_FIFO_SC_OFFSET)
+#define RX_FIFO_LC(x)		(((x) & USP_RX_FIFO_LEVEL_CHECK_MASK) \
+				<< USP_RX_FIFO_LC_OFFSET)
+#define RX_FIFO_HC(x)		(((x) & USP_RX_FIFO_LEVEL_CHECK_MASK) \
+				<< USP_RX_FIFO_HC_OFFSET)
+
+/* USP RX FIFO Operation Register */
+#define USP_RX_FIFO_RESET		0x00000001
+#define USP_RX_FIFO_START		0x00000002
+
+/* USP RX FIFO Status Register */
+
+#define USP_RX_FIFO_LEVEL_MASK		0x0000007F
+#define USP_RX_FIFO_LEVEL_OFFSET	0
+
+#define USP_RX_FIFO_FULL		0x00000080
+#define USP_RX_FIFO_EMPTY		0x00000100
+
+/* USP RX FIFO Data Register */
+
+#define USP_RX_FIFO_DATA_MASK		0xFFFFFFFF
+#define USP_RX_FIFO_DATA_OFFSET		0
+
+/*
+ * When rx thd irq occur, sender just disable tx empty irq,
+ * Remaining data in tx fifo wil also be sent out.
+ */
+#define USP_FIFO_SIZE			128
+#define USP_TX_FIFO_THRESHOLD		(USP_FIFO_SIZE/2)
+#define USP_RX_FIFO_THRESHOLD		(USP_FIFO_SIZE/2)
+
+/* FIFO_WIDTH for the USP_TX_FIFO_CTRL and USP_RX_FIFO_CTRL registers */
+#define USP_FIFO_WIDTH_BYTE  0x00
+#define USP_FIFO_WIDTH_WORD  0x01
+#define USP_FIFO_WIDTH_DWORD 0x02
+
+#define USP_ASYNC_DIV2          16
+
+#define USP_PLUGOUT_RETRY_CNT	2
+
+#define USP_TX_RX_FIFO_WIDTH_DWORD    2
+
+#define SIRF_USP_DIV_MCLK	0
+
+#define SIRF_USP_I2S_TFS_SYNC	0
+#define SIRF_USP_I2S_RFS_SYNC	1
+#endif
-- 
1.9.3



Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
More information can be found at www.csr.com. Keep up to date with CSR on our technical blog, www.csr.com/blog, CSR people blog, www.csr.com/people, YouTube, www.youtube.com/user/CSRplc, Facebook, www.facebook.com/pages/CSR/191038434253534, or follow us on Twitter at www.twitter.com/CSR_plc.
New for 2014, you can now access the wide range of products powered by aptX at www.aptx.com.
