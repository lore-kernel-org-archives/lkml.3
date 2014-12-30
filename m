Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbaL3K5t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 05:57:49 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.140]:46477 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752088AbaL3K4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 05:56:45 -0500
From: Andrew Jackson <andrew.jackson@arm.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        Andrew Jackson <Andrew.Jackson@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Arnd Bergmann <arnd@arndb.de>,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 6/6] ASoC: dwc: Add devicetree support for Designware I2S
Date: Tue, 30 Dec 2014 10:55:48 +0000
Message-Id: <8da45b000fb1f9a029b30fcf5abe50941f45e32e.1419936132.git.Andrew.Jackson@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1419936132.git.Andrew.Jackson@arm.com>
References: <cover.1419936132.git.Andrew.Jackson@arm.com>
In-Reply-To: <cover.1419936132.git.Andrew.Jackson@arm.com>
References: <cover.1419936132.git.Andrew.Jackson@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Jackson <Andrew.Jackson@arm.com>

Allow the driver to be configured through a device tree rather than platform
data.

Signed-off-by: Andrew Jackson <Andrew.Jackson@arm.com>
---
 sound/soc/dwc/Kconfig          |    1 +
 sound/soc/dwc/designware_i2s.c |  193 +++++++++++++++++++++++++++++++---------
 2 files changed, 151 insertions(+), 43 deletions(-)

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
index e1c0e2c..99cf64b 100644
--- a/sound/soc/dwc/designware_i2s.c
+++ b/sound/soc/dwc/designware_i2s.c
@@ -22,6 +22,7 @@
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
+#include <sound/dmaengine_pcm.h>
 
 /* common register for all channel */
 #define IER		0x000
@@ -82,6 +83,11 @@
 #define MAX_CHANNEL_NUM		8
 #define MIN_CHANNEL_NUM		2
 
+union dw_i2s_snd_dma_data {
+	struct i2s_dma_data pd;
+	struct snd_dmaengine_dai_dma_data dt;
+};
+
 struct dw_i2s_dev {
 	void __iomem *i2s_base;
 	struct clk *clk;
@@ -90,8 +96,8 @@ struct dw_i2s_dev {
 	struct device *dev;
 
 	/* data related to DMA transfers b/w i2s and DMAC */
-	struct i2s_dma_data play_dma_data;
-	struct i2s_dma_data capture_dma_data;
+	union dw_i2s_snd_dma_data play_dma_data;
+	union dw_i2s_snd_dma_data capture_dma_data;
 	struct i2s_clk_config_data config;
 	int (*i2s_clk_cfg)(struct i2s_clk_config_data *config);
 };
@@ -178,7 +184,7 @@ static int dw_i2s_startup(struct snd_pcm_substream *substream,
 		struct snd_soc_dai *cpu_dai)
 {
 	struct dw_i2s_dev *dev = snd_soc_dai_get_drvdata(cpu_dai);
-	struct i2s_dma_data *dma_data = NULL;
+	union dw_i2s_snd_dma_data *dma_data = NULL;
 
 	if (!(dev->capability & DWC_I2S_RECORD) &&
 			(substream->stream == SNDRV_PCM_STREAM_CAPTURE))
@@ -267,13 +273,21 @@ static int dw_i2s_hw_params(struct snd_pcm_substream *substream,
 
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
+		u32 bitclk = config->sample_rate * config->data_width * 2;
 
-	ret = dev->i2s_clk_cfg(config);
-	if (ret < 0) {
-		dev_err(dev->dev, "runtime audio clk config fail\n");
-		return ret;
+		ret = clk_set_rate(dev->clk, bitclk);
+		if (ret) {
+			dev_err(dev->dev, "Can't set I2S clock rate: %d\n",
+				ret);
+			return ret;
+		}
 	}
 
 	return 0;
@@ -368,6 +382,11 @@ static int dw_i2s_resume(struct snd_soc_dai *dai)
  * block parameter.
  */
 
+/* Maximum bit resolution of a channel - not uniformly spaced */
+static const u32 fifo_width[COMP_MAX_WORDSIZE] = {
+	12, 16, 20, 24, 32, 0, 0, 0
+};
+
 /* Width of (DMA) bus */
 static const u32 bus_widths[COMP_MAX_DATA_WIDTH] = {
 	DMA_SLAVE_BUSWIDTH_1_BYTE,
@@ -388,10 +407,9 @@ static const u32 formats[COMP_MAX_WORDSIZE] = {
 	0
 };
 
-static int dw_configure_dai_by_pd(struct dw_i2s_dev *dev,
+static int dw_configure_dai(struct dw_i2s_dev *dev,
 				   struct snd_soc_dai_driver *dw_i2s_dai,
-				   struct resource *res,
-				   const struct i2s_platform_data *pdata)
+				   unsigned int rates)
 {
 	/*
 	 * Read component parameter registers to extract
@@ -399,23 +417,7 @@ static int dw_configure_dai_by_pd(struct dw_i2s_dev *dev,
 	 */
 	u32 comp1 = i2s_read_reg(dev->i2s_base, I2S_COMP_PARAM_1);
 	u32 comp2 = i2s_read_reg(dev->i2s_base, I2S_COMP_PARAM_2);
-	u32 idx = COMP1_APB_DATA_WIDTH(comp1);
-
-	if (WARN_ON(idx >= ARRAY_SIZE(bus_widths)))
-		return -EINVAL;
-
-	/* Set DMA slaves info */
-
-	dev->play_dma_data.data = pdata->play_dma_data;
-	dev->capture_dma_data.data = pdata->capture_dma_data;
-	dev->play_dma_data.addr = res->start + I2S_TXDMA;
-	dev->capture_dma_data.addr = res->start + I2S_RXDMA;
-	dev->play_dma_data.max_burst = 16;
-	dev->capture_dma_data.max_burst = 16;
-	dev->play_dma_data.addr_width = bus_widths[idx];
-	dev->capture_dma_data.addr_width = bus_widths[idx];
-	dev->play_dma_data.filter = pdata->filter;
-	dev->capture_dma_data.filter = pdata->filter;
+	u32 idx;
 
 	if (COMP1_TX_ENABLED(comp1)) {
 		dev_dbg(dev->dev, " designware: play supported\n");
@@ -426,7 +428,7 @@ static int dw_configure_dai_by_pd(struct dw_i2s_dev *dev,
 		dw_i2s_dai->playback.channels_max =
 				1 << (COMP1_TX_CHANNELS(comp1) + 1);
 		dw_i2s_dai->playback.formats = formats[idx];
-		dw_i2s_dai->playback.rates = pdata->snd_rates;
+		dw_i2s_dai->playback.rates = rates;
 	}
 
 	if (COMP1_RX_ENABLED(comp1)) {
@@ -438,10 +440,86 @@ static int dw_configure_dai_by_pd(struct dw_i2s_dev *dev,
 		dw_i2s_dai->capture.channels_max =
 				1 << (COMP1_RX_CHANNELS(comp1) + 1);
 		dw_i2s_dai->capture.formats = formats[idx];
-		dw_i2s_dai->capture.rates = pdata->snd_rates;
+		dw_i2s_dai->capture.rates = rates;
+	}
+
+	return 0;
+}
+
+static int dw_configure_dai_by_pd(struct dw_i2s_dev *dev,
+				   struct snd_soc_dai_driver *dw_i2s_dai,
+				   struct resource *res,
+				   const struct i2s_platform_data *pdata)
+{
+	u32 comp1 = i2s_read_reg(dev->i2s_base, I2S_COMP_PARAM_1);
+	u32 idx = COMP1_APB_DATA_WIDTH(comp1);
+	int ret;
+
+	if (WARN_ON(idx >= ARRAY_SIZE(bus_widths)))
+		return -EINVAL;
+
+	ret = dw_configure_dai(dev, dw_i2s_dai, pdata->snd_rates);
+	if (ret < 0)
+		return ret;
+
+	/* Set DMA slaves info */
+	dev->play_dma_data.pd.data = pdata->play_dma_data;
+	dev->capture_dma_data.pd.data = pdata->capture_dma_data;
+	dev->play_dma_data.pd.addr = res->start + I2S_TXDMA;
+	dev->capture_dma_data.pd.addr = res->start + I2S_RXDMA;
+	dev->play_dma_data.pd.max_burst = 16;
+	dev->capture_dma_data.pd.max_burst = 16;
+	dev->play_dma_data.pd.addr_width = bus_widths[idx];
+	dev->capture_dma_data.pd.addr_width = bus_widths[idx];
+	dev->play_dma_data.pd.filter = pdata->filter;
+	dev->capture_dma_data.pd.filter = pdata->filter;
+
+	return 0;
+}
+
+static int dw_configure_dai_by_dt(struct dw_i2s_dev *dev,
+				   struct snd_soc_dai_driver *dw_i2s_dai,
+				   struct resource *res)
+{
+	u32 comp1 = i2s_read_reg(dev->i2s_base, I2S_COMP_PARAM_1);
+	u32 comp2 = i2s_read_reg(dev->i2s_base, I2S_COMP_PARAM_2);
+	u32 fifo_depth = 1 << (1 + COMP1_FIFO_DEPTH_GLOBAL(comp1));
+	u32 idx = COMP1_APB_DATA_WIDTH(comp1);
+	u32 idx2;
+	int ret;
+
+	if (WARN_ON(idx >= ARRAY_SIZE(bus_widths)))
+		return -EINVAL;
+
+	ret = dw_configure_dai(dev, dw_i2s_dai, SNDRV_PCM_RATE_8000_192000);
+	if (ret < 0)
+		return ret;
+
+	if (COMP1_TX_ENABLED(comp1)) {
+		idx2 = COMP1_TX_WORDSIZE_0(comp1);
+
+		dev->capability |= DWC_I2S_PLAY;
+		dev->play_dma_data.dt.addr = res->start + I2S_TXDMA;
+		dev->play_dma_data.dt.addr_width = bus_widths[idx];
+		dev->play_dma_data.dt.chan_name = "TX";
+		dev->play_dma_data.dt.fifo_size = fifo_depth *
+			(fifo_width[idx2]) >> 8;
+		dev->play_dma_data.dt.maxburst = 16;
+	}
+	if (COMP1_RX_ENABLED(comp1)) {
+		idx2 = COMP2_RX_WORDSIZE_0(comp2);
+
+		dev->capability |= DWC_I2S_RECORD;
+		dev->capture_dma_data.dt.addr = res->start + I2S_RXDMA;
+		dev->capture_dma_data.dt.addr_width = bus_widths[idx];
+		dev->capture_dma_data.dt.chan_name = "RX";
+		dev->capture_dma_data.dt.fifo_size = fifo_depth *
+			(fifo_width[idx2] >> 8);
+		dev->capture_dma_data.dt.maxburst = 16;
 	}
 
 	return 0;
+
 }
 
 static int dw_i2s_probe(struct platform_device *pdev)
@@ -452,11 +530,6 @@ static int dw_i2s_probe(struct platform_device *pdev)
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
@@ -477,15 +550,28 @@ static int dw_i2s_probe(struct platform_device *pdev)
 		return PTR_ERR(dev->i2s_base);
 
 	dev->dev = &pdev->dev;
-	ret = dw_configure_dai_by_pd(dev, dw_i2s_dai, res, pdata);
-	if (ret < 0)
-		return ret;
+	if (pdata) {
+		ret = dw_configure_dai_by_pd(dev, dw_i2s_dai, res, pdata);
+		if (ret < 0)
+			return ret;
+
+		dev->capability = pdata->cap;
+		dev->i2s_clk_cfg = pdata->i2s_clk_cfg;
+		if (!dev->i2s_clk_cfg) {
+			dev_err(&pdev->dev, "no clock configure method\n");
+			return -ENODEV;
+		}
+
+		dev->clk = devm_clk_get(&pdev->dev, NULL);
+	} else {
+		ret = dw_configure_dai_by_dt(dev, dw_i2s_dai, res);
+		if (ret < 0)
+			return ret;
 
-	dev->capability = pdata->cap;
-	dev->i2s_clk_cfg = pdata->i2s_clk_cfg;
-	dev->clk = devm_clk_get(&pdev->dev, NULL);
+		dev->clk = devm_clk_get(&pdev->dev, "i2sclk");
+	}
 	if (IS_ERR(dev->clk))
-		return  PTR_ERR(dev->clk);
+		return PTR_ERR(dev->clk);
 
 	ret = clk_prepare_enable(dev->clk);
 	if (ret < 0)
@@ -499,6 +585,15 @@ static int dw_i2s_probe(struct platform_device *pdev)
 		goto err_clk_disable;
 	}
 
+	if (!pdata) {
+		ret = devm_snd_dmaengine_pcm_register(&pdev->dev, NULL, 0);
+		if (ret) {
+			dev_err(&pdev->dev,
+				"Could not register PCM: %d\n", ret);
+			goto err_clk_disable;
+		}
+	}
+
 	return 0;
 
 err_clk_disable:
@@ -515,11 +610,23 @@ static int dw_i2s_remove(struct platform_device *pdev)
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
+		.of_match_table = of_match_ptr(dw_i2s_of_match),
+#endif
 	},
 };
 
-- 
1.7.1

