Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934750AbaLLJ1P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 04:27:15 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.140]:35750 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933358AbaLLJ0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 04:26:04 -0500
From: Andrew Jackson <andrew.jackson@arm.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        Andrew Jackson <Andrew.Jackson@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/6] ASoC: dwc: Reorder code in preparation for DT support
Date: Fri, 12 Dec 2014 09:25:03 +0000
Message-Id: <c1019d1e47c4236170a47d29c7dc95df9b9e6d1f.1418372910.git.Andrew.Jackson@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1418372910.git.Andrew.Jackson@arm.com>
References: <cover.1418372910.git.Andrew.Jackson@arm.com>
In-Reply-To: <cover.1418372910.git.Andrew.Jackson@arm.com>
References: <cover.1418372910.git.Andrew.Jackson@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Jackson <Andrew.Jackson@arm.com>

Move code that configures the DAI and DMA into a separate function.  This
reduces the size of the dw_i2s_probe function and will make it easier to
add support for device tree to the driver.

Signed-off-by: Andrew Jackson <Andrew.Jackson@arm.com>
---
 sound/soc/dwc/designware_i2s.c |   73 +++++++++++++++++++++------------------
 1 files changed, 39 insertions(+), 34 deletions(-)

diff --git a/sound/soc/dwc/designware_i2s.c b/sound/soc/dwc/designware_i2s.c
index 1d26ded..343f5e7 100644
--- a/sound/soc/dwc/designware_i2s.c
+++ b/sound/soc/dwc/designware_i2s.c
@@ -323,13 +323,47 @@ static int dw_i2s_resume(struct snd_soc_dai *dai)
 #define dw_i2s_resume	NULL
 #endif
 
+static void dw_configure_dai_by_pd(struct dw_i2s_dev *dev,
+				   struct snd_soc_dai_driver *dw_i2s_dai,
+				   struct resource *res,
+				   const struct i2s_platform_data *pdata)
+{
+	/* Set DMA slaves info */
+
+	dev->play_dma_data.data = pdata->play_dma_data;
+	dev->capture_dma_data.data = pdata->capture_dma_data;
+	dev->play_dma_data.addr = res->start + I2S_TXDMA;
+	dev->capture_dma_data.addr = res->start + I2S_RXDMA;
+	dev->play_dma_data.max_burst = 16;
+	dev->capture_dma_data.max_burst = 16;
+	dev->play_dma_data.addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
+	dev->capture_dma_data.addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
+	dev->play_dma_data.filter = pdata->filter;
+	dev->capture_dma_data.filter = pdata->filter;
+
+	if (pdata->cap & DWC_I2S_PLAY) {
+		dev_dbg(dev->dev, " designware: play supported\n");
+		dw_i2s_dai->playback.channels_min = MIN_CHANNEL_NUM;
+		dw_i2s_dai->playback.channels_max = pdata->channel;
+		dw_i2s_dai->playback.formats = pdata->snd_fmts;
+		dw_i2s_dai->playback.rates = pdata->snd_rates;
+	}
+
+	if (pdata->cap & DWC_I2S_RECORD) {
+		dev_dbg(dev->dev, "designware: record supported\n");
+		dw_i2s_dai->capture.channels_min = MIN_CHANNEL_NUM;
+		dw_i2s_dai->capture.channels_max = pdata->channel;
+		dw_i2s_dai->capture.formats = pdata->snd_fmts;
+		dw_i2s_dai->capture.rates = pdata->snd_rates;
+	}
+}
+
 static int dw_i2s_probe(struct platform_device *pdev)
 {
 	const struct i2s_platform_data *pdata = pdev->dev.platform_data;
 	struct dw_i2s_dev *dev;
 	struct resource *res;
 	int ret;
-	unsigned int cap;
 	struct snd_soc_dai_driver *dw_i2s_dai;
 
 	if (!pdata) {
@@ -356,23 +390,11 @@ static int dw_i2s_probe(struct platform_device *pdev)
 	if (IS_ERR(dev->i2s_base))
 		return PTR_ERR(dev->i2s_base);
 
-	cap = pdata->cap;
-	dev->capability = cap;
-	dev->i2s_clk_cfg = pdata->i2s_clk_cfg;
-
-	/* Set DMA slaves info */
-
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
+	dev->dev = &pdev->dev;
+	dw_configure_dai_by_pd(dev, dw_i2s_dai, res, pdata);
 
+	dev->capability = pdata->cap;
+	dev->i2s_clk_cfg = pdata->i2s_clk_cfg;
 	dev->clk = clk_get(&pdev->dev, NULL);
 	if (IS_ERR(dev->clk))
 		return  PTR_ERR(dev->clk);
@@ -381,23 +403,6 @@ static int dw_i2s_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto err_clk_put;
 
-	if (cap & DWC_I2S_PLAY) {
-		dev_dbg(&pdev->dev, " designware: play supported\n");
-		dw_i2s_dai->playback.channels_min = MIN_CHANNEL_NUM;
-		dw_i2s_dai->playback.channels_max = pdata->channel;
-		dw_i2s_dai->playback.formats = pdata->snd_fmts;
-		dw_i2s_dai->playback.rates = pdata->snd_rates;
-	}
-
-	if (cap & DWC_I2S_RECORD) {
-		dev_dbg(&pdev->dev, "designware: record supported\n");
-		dw_i2s_dai->capture.channels_min = MIN_CHANNEL_NUM;
-		dw_i2s_dai->capture.channels_max = pdata->channel;
-		dw_i2s_dai->capture.formats = pdata->snd_fmts;
-		dw_i2s_dai->capture.rates = pdata->snd_rates;
-	}
-
-	dev->dev = &pdev->dev;
 	dev_set_drvdata(&pdev->dev, dev);
 	ret = snd_soc_register_component(&pdev->dev, &dw_i2s_component,
 					 dw_i2s_dai, 1);
-- 
1.7.1

