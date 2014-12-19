Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340AbaLSQU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 11:20:27 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.140]:36565 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751992AbaLSQTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 11:19:08 -0500
From: Andrew Jackson <andrew.jackson@arm.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        Andrew Jackson <Andrew.Jackson@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/5] ASoC: dwc: Add devicetree support for Designware I2S
Date: Fri, 19 Dec 2014 16:18:08 +0000
Message-Id: <9699e11a566938b8d1821f9be3df3276d57cd979.1418826016.git.Andrew.Jackson@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1418826016.git.Andrew.Jackson@arm.com>
References: <cover.1418826016.git.Andrew.Jackson@arm.com>
In-Reply-To: <cover.1418826016.git.Andrew.Jackson@arm.com>
References: <cover.1418826016.git.Andrew.Jackson@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Jackson <Andrew.Jackson@arm.com>

Allow the driver to be configured through a device tree rather than platform
data.  When using device-tree, read the I2S block's configuration from the
relevant registers: this reduces the amount of information required in
the device tree.

Signed-off-by: Andrew Jackson <Andrew.Jackson@arm.com>
---
 sound/soc/dwc/Kconfig          |    1 +
 sound/soc/dwc/designware_i2s.c |  199 ++++++++++++++++++++++++++++++++++------
 2 files changed, 171 insertions(+), 29 deletions(-)

diff --git a/sound/soc/dwc/Kconfig b/sound/soc/dwc/Kconfig
index e334900..d50e085 100644
--- a/sound/soc/dwc/Kconfig
+++ b/sound/soc/dwc/Kconfig
@@ -1,6 +1,7 @@
 config SND_DESIGNWARE_I2S
 	tristate "Synopsys I2S Device Driver"
 	depends on CLKDEV_LOOKUP
+	select SND_SOC_GENERIC_DMAENGINE_PCM
 	help
 	 Say Y or M if you want to add support for I2S driver for
 	 Synopsys desigwnware I2S device. The device supports upto
diff --git a/sound/soc/dwc/designware_i2s.c b/sound/soc/dwc/designware_i2s.c
index 06d3a34..7905c52 100644
--- a/sound/soc/dwc/designware_i2s.c
+++ b/sound/soc/dwc/designware_i2s.c
@@ -22,6 +22,7 @@
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
+#include <sound/dmaengine_pcm.h>
 
 /* common register for all channel */
 #define IER		0x000
@@ -54,9 +55,35 @@
 #define I2S_COMP_VERSION	0x01F8
 #define I2S_COMP_TYPE		0x01FC
 
+/*
+ * Component parameter register fields - define the I2S block's
+ * configuration.
+ */
+#define	COMP1_TX_WORDSIZE_3(r)	(((r) & GENMASK(27, 25)) >> 25)
+#define	COMP1_TX_WORDSIZE_2(r)	(((r) & GENMASK(24, 22)) >> 22)
+#define	COMP1_TX_WORDSIZE_1(r)	(((r) & GENMASK(21, 19)) >> 19)
+#define	COMP1_TX_WORDSIZE_0(r)	(((r) & GENMASK(18, 16)) >> 16)
+#define	COMP1_TX_CHANNELS(r)	(((r) & GENMASK(10, 9)) >> 9)
+#define	COMP1_RX_CHANNELS(r)	(((r) & GENMASK(8, 7)) >> 7)
+#define	COMP1_RX_ENABLED(r)	(((r) & BIT(6)) >> 6)
+#define	COMP1_TX_ENABLED(r)	(((r) & BIT(5)) >> 5)
+#define	COMP1_MODE_EN(r)	(((r) & BIT(4)) >> 4)
+#define	COMP1_FIFO_DEPTH_GLOBAL(r)	(((r) & GENMASK(3, 2)) >> 2)
+#define	COMP1_APB_DATA_WIDTH(r)	(((r) & GENMASK(1, 0)) >> 0)
+
+#define	COMP2_RX_WORDSIZE_3(r)	(((r) & GENMASK(12, 10)) >> 10)
+#define	COMP2_RX_WORDSIZE_2(r)	(((r) & GENMASK(9, 7)) >> 7)
+#define	COMP2_RX_WORDSIZE_1(r)	(((r) & GENMASK(5, 3)) >> 3)
+#define	COMP2_RX_WORDSIZE_0(r)	(((r) & GENMASK(2, 0)) >> 0)
+
 #define MAX_CHANNEL_NUM		8
 #define MIN_CHANNEL_NUM		2
 
+union snd_dma_data {
+	struct i2s_dma_data pd;
+	struct snd_dmaengine_dai_dma_data dt;
+};
+
 struct dw_i2s_dev {
 	void __iomem *i2s_base;
 	struct clk *clk;
@@ -65,8 +92,8 @@ struct dw_i2s_dev {
 	struct device *dev;
 
 	/* data related to DMA transfers b/w i2s and DMAC */
-	struct i2s_dma_data play_dma_data;
-	struct i2s_dma_data capture_dma_data;
+	union snd_dma_data play_dma_data;
+	union snd_dma_data capture_dma_data;
 	struct i2s_clk_config_data config;
 	int (*i2s_clk_cfg)(struct i2s_clk_config_data *config);
 };
@@ -153,7 +180,7 @@ static int dw_i2s_startup(struct snd_pcm_substream *substream,
 		struct snd_soc_dai *cpu_dai)
 {
 	struct dw_i2s_dev *dev = snd_soc_dai_get_drvdata(cpu_dai);
-	struct i2s_dma_data *dma_data = NULL;
+	union snd_dma_data *dma_data = NULL;
 
 	if (!(dev->capability & DWC_I2S_RECORD) &&
 			(substream->stream == SNDRV_PCM_STREAM_CAPTURE))
@@ -242,13 +269,18 @@ static int dw_i2s_hw_params(struct snd_pcm_substream *substream,
 
 	config->sample_rate = params_rate(params);
 
-	if (!dev->i2s_clk_cfg)
-		return -EINVAL;
+	if (dev->i2s_clk_cfg) {
+		ret = dev->i2s_clk_cfg(config);
+		if (ret < 0) {
+			dev_err(dev->dev, "runtime audio clk config fail\n");
+			return ret;
+		}
+	} else {
+		u32	bitclk;
 
-	ret = dev->i2s_clk_cfg(config);
-	if (ret < 0) {
-		dev_err(dev->dev, "runtime audio clk config fail\n");
-		return ret;
+		/* TODO: Validate sample rate against permissible set */
+		bitclk = config->sample_rate * config->data_width * 2;
+		clk_set_rate(dev->clk, bitclk);
 	}
 
 	return 0;
@@ -335,6 +367,31 @@ static int dw_i2s_resume(struct snd_soc_dai *dai)
 #define dw_i2s_resume	NULL
 #endif
 
+/* Maximum resolution of a channel - not uniformly spaced */
+static const u32 fifo_width[] = {
+	12, 16, 20, 24, 32, 0, 0, 0
+};
+
+/* Width of (DMA) bus */
+static const u32 bus_widths[] = {
+	DMA_SLAVE_BUSWIDTH_1_BYTE,
+	DMA_SLAVE_BUSWIDTH_2_BYTES,
+	DMA_SLAVE_BUSWIDTH_4_BYTES,
+	DMA_SLAVE_BUSWIDTH_UNDEFINED
+};
+
+/* PCM format to support channel resolution */
+static const u32 formats[] = {
+	SNDRV_PCM_FMTBIT_S16_LE,
+	SNDRV_PCM_FMTBIT_S16_LE,
+	SNDRV_PCM_FMTBIT_S24_LE,
+	SNDRV_PCM_FMTBIT_S24_LE,
+	SNDRV_PCM_FMTBIT_S32_LE,
+	0,
+	0,
+	0
+};
+
 static void dw_configure_dai_by_pd(struct dw_i2s_dev *dev,
 				   struct snd_soc_dai_driver *dw_i2s_dai,
 				   struct resource *res,
@@ -342,16 +399,16 @@ static void dw_configure_dai_by_pd(struct dw_i2s_dev *dev,
 {
 	/* Set DMA slaves info */
 
-	dev->play_dma_data.data = pdata->play_dma_data;
-	dev->capture_dma_data.data = pdata->capture_dma_data;
-	dev->play_dma_data.addr = res->start + I2S_TXDMA;
-	dev->capture_dma_data.addr = res->start + I2S_RXDMA;
-	dev->play_dma_data.max_burst = 16;
-	dev->capture_dma_data.max_burst = 16;
-	dev->play_dma_data.addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
-	dev->capture_dma_data.addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
-	dev->play_dma_data.filter = pdata->filter;
-	dev->capture_dma_data.filter = pdata->filter;
+	dev->play_dma_data.pd.data = pdata->play_dma_data;
+	dev->capture_dma_data.pd.data = pdata->capture_dma_data;
+	dev->play_dma_data.pd.addr = res->start + I2S_TXDMA;
+	dev->capture_dma_data.pd.addr = res->start + I2S_RXDMA;
+	dev->play_dma_data.pd.max_burst = 16;
+	dev->capture_dma_data.pd.max_burst = 16;
+	dev->play_dma_data.pd.addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
+	dev->capture_dma_data.pd.addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
+	dev->play_dma_data.pd.filter = pdata->filter;
+	dev->capture_dma_data.pd.filter = pdata->filter;
 
 	if (pdata->cap & DWC_I2S_PLAY) {
 		dev_dbg(dev->dev, " designware: play supported\n");
@@ -370,6 +427,59 @@ static void dw_configure_dai_by_pd(struct dw_i2s_dev *dev,
 	}
 }
 
+static void dw_configure_dai_by_dt(struct dw_i2s_dev *dev,
+				   struct snd_soc_dai_driver *dw_i2s_dai,
+				   struct resource *res)
+{
+	/*
+	 * Read component parameter registers to extract
+	 * the I2S block's configuration.
+	 */
+	u32 comp1 = i2s_read_reg(dev->i2s_base, I2S_COMP_PARAM_1);
+	u32 comp2 = i2s_read_reg(dev->i2s_base, I2S_COMP_PARAM_2);
+	u32 bus_width = bus_widths[COMP1_APB_DATA_WIDTH(comp1)];
+	u32 fifo_depth = 1 << (1 + COMP1_FIFO_DEPTH_GLOBAL(comp1));
+	u32 max_size;
+
+	/*
+	 * All channels' hardware configuration assumed to be the same.
+	 */
+	if (COMP1_TX_ENABLED(comp1)) {
+		dev_dbg(dev->dev, "playback capable\n");
+
+		dev->capability |= DWC_I2S_PLAY;
+		max_size = COMP1_TX_WORDSIZE_0(comp1);
+		dev->play_dma_data.dt.addr = res->start + I2S_TXDMA;
+		dev->play_dma_data.dt.addr_width = bus_width;
+		dev->play_dma_data.dt.chan_name = "TX";
+		dev->play_dma_data.dt.fifo_size = fifo_depth *
+			(fifo_width[max_size]) >> 8;
+		dev->play_dma_data.dt.maxburst = 16;
+		dw_i2s_dai->playback.channels_min = MIN_CHANNEL_NUM;
+		dw_i2s_dai->playback.channels_max =
+				1 << (COMP1_TX_CHANNELS(comp1) + 1);
+		dw_i2s_dai->playback.formats = formats[max_size];
+		dw_i2s_dai->playback.rates = SNDRV_PCM_RATE_8000_192000;
+	}
+	if (COMP1_RX_ENABLED(comp1)) {
+		dev_dbg(dev->dev, "record capable\n");
+
+		dev->capability |= DWC_I2S_RECORD;
+		max_size = COMP2_RX_WORDSIZE_0(comp2);
+		dev->capture_dma_data.dt.addr = res->start + I2S_RXDMA;
+		dev->capture_dma_data.dt.addr_width = bus_width;
+		dev->capture_dma_data.dt.chan_name = "RX";
+		dev->capture_dma_data.dt.fifo_size = fifo_depth *
+			(fifo_width[max_size] >> 8);
+		dev->capture_dma_data.dt.maxburst = 16;
+		dw_i2s_dai->capture.channels_min = MIN_CHANNEL_NUM;
+		dw_i2s_dai->capture.channels_max =
+				1 << (COMP1_RX_CHANNELS(comp1) + 1);
+		dw_i2s_dai->capture.formats = formats[max_size];
+		dw_i2s_dai->capture.rates = SNDRV_PCM_RATE_8000_192000;
+	}
+}
+
 static int dw_i2s_probe(struct platform_device *pdev)
 {
 	const struct i2s_platform_data *pdata = pdev->dev.platform_data;
@@ -378,11 +488,6 @@ static int dw_i2s_probe(struct platform_device *pdev)
 	int ret;
 	struct snd_soc_dai_driver *dw_i2s_dai;
 
-	if (!pdata) {
-		dev_err(&pdev->dev, "Invalid platform data\n");
-		return -EINVAL;
-	}
-
 	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
 	if (!dev) {
 		dev_warn(&pdev->dev, "kzalloc fail\n");
@@ -403,13 +508,28 @@ static int dw_i2s_probe(struct platform_device *pdev)
 		return PTR_ERR(dev->i2s_base);
 
 	dev->dev = &pdev->dev;
-	dw_configure_dai_by_pd(dev, dw_i2s_dai, res, pdata);
+	if (pdata) {
+		dw_configure_dai_by_pd(dev, dw_i2s_dai, res, pdata);
+
+		dev->capability = pdata->cap;
+		dev->i2s_clk_cfg = pdata->i2s_clk_cfg;
+		if (!dev->i2s_clk_cfg) {
+			dev_err(&pdev->dev, "no clock configure method\n");
+			return -ENODEV;
+		}
 
-	dev->capability = pdata->cap;
-	dev->i2s_clk_cfg = pdata->i2s_clk_cfg;
-	dev->clk = clk_get(&pdev->dev, NULL);
+		dev->clk = clk_get(&pdev->dev, NULL);
+	} else {
+		dw_configure_dai_by_dt(dev, dw_i2s_dai, res);
+
+		dev->clk = devm_clk_get(&pdev->dev, "i2sclk");
+	}
 	if (IS_ERR(dev->clk))
-		return  PTR_ERR(dev->clk);
+		return PTR_ERR(dev->clk);
+
+	ret = clk_prepare(dev->clk);
+	if (ret < 0)
+		goto err_clk_put;
 
 	ret = clk_enable(dev->clk);
 	if (ret < 0)
@@ -423,6 +543,15 @@ static int dw_i2s_probe(struct platform_device *pdev)
 		goto err_clk_disable;
 	}
 
+	if (!pdata) {
+		ret = devm_snd_dmaengine_pcm_register(&pdev->dev, NULL, 0);
+		if (ret) {
+			dev_err(&pdev->dev,
+				"Could not register PCM: %d\n", ret);
+			return ret;
+		}
+	}
+
 	return 0;
 
 err_clk_disable:
@@ -443,11 +572,23 @@ static int dw_i2s_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_OF
+static const struct of_device_id dw_i2s_of_match[] = {
+	{ .compatible = "snps,designware-i2s",	 },
+	{},
+};
+
+MODULE_DEVICE_TABLE(of, dw_i2s_of_match);
+#endif
+
 static struct platform_driver dw_i2s_driver = {
 	.probe		= dw_i2s_probe,
 	.remove		= dw_i2s_remove,
 	.driver		= {
 		.name	= "designware-i2s",
+#ifdef CONFIG_OF
+		.of_match_table = dw_i2s_of_match,
+#endif
 	},
 };
 
-- 
1.7.1

