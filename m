Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbaLWN60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 08:58:26 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.140]:38023 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755858AbaLWN50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 08:57:26 -0500
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
Subject: [PATCH v4 3/5] ASoC: dwc: Read I2S block configuration from registers
Date: Tue, 23 Dec 2014 13:56:25 +0000
Message-Id: <a29eb9e5b4b6f68f9f42f2382fa49c6a03eebda3.1419342218.git.Andrew.Jackson@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1419342218.git.Andrew.Jackson@arm.com>
References: <cover.1419342218.git.Andrew.Jackson@arm.com>
In-Reply-To: <cover.1419342218.git.Andrew.Jackson@arm.com>
References: <cover.1419342218.git.Andrew.Jackson@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Jackson <Andrew.Jackson@arm.com>

The I2S block provides component parameter registers which
describe how the block is instantiated.  Use these registers
to extract the block's configuration rather than relying on
platform data.

Signed-off-by: Andrew Jackson <Andrew.Jackson@arm.com>
---
 sound/soc/dwc/designware_i2s.c |   96 +++++++++++++++++++++++++++++++++++----
 1 files changed, 86 insertions(+), 10 deletions(-)

diff --git a/sound/soc/dwc/designware_i2s.c b/sound/soc/dwc/designware_i2s.c
index b3dc535..c89b9eb 100644
--- a/sound/soc/dwc/designware_i2s.c
+++ b/sound/soc/dwc/designware_i2s.c
@@ -54,6 +54,31 @@
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
+/* Number of entries in WORDSIZE and DATA_WIDTH parameter registers */
+#define	COMP_MAX_WORDSIZE	(1 << 3)
+#define	COMP_MAX_DATA_WIDTH	(1 << 2)
+
 #define MAX_CHANNEL_NUM		8
 #define MIN_CHANNEL_NUM		2
 
@@ -335,11 +360,50 @@ static int dw_i2s_resume(struct snd_soc_dai *dai)
 #define dw_i2s_resume	NULL
 #endif
 
-static void dw_configure_dai_by_pd(struct dw_i2s_dev *dev,
+/*
+ * The following tables allow a direct lookup of various parameters
+ * defined in the I2S block's configuration in terms of sound system
+ * parameters.  Each table is sized to the number of entries possible
+ * according to the number of configuration bits describing an I2S
+ * block parameter.
+ */
+
+/* Width of (DMA) bus */
+static const u32 bus_widths[COMP_MAX_DATA_WIDTH] = {
+	DMA_SLAVE_BUSWIDTH_1_BYTE,
+	DMA_SLAVE_BUSWIDTH_2_BYTES,
+	DMA_SLAVE_BUSWIDTH_4_BYTES,
+	DMA_SLAVE_BUSWIDTH_UNDEFINED
+};
+
+/* PCM format to support channel resolution */
+static const u32 formats[COMP_MAX_WORDSIZE] = {
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
+static int dw_configure_dai_by_pd(struct dw_i2s_dev *dev,
 				   struct snd_soc_dai_driver *dw_i2s_dai,
 				   struct resource *res,
 				   const struct i2s_platform_data *pdata)
 {
+	/*
+	 * Read component parameter registers to extract
+	 * the I2S block's configuration.
+	 */
+	u32 comp1 = i2s_read_reg(dev->i2s_base, I2S_COMP_PARAM_1);
+	u32 comp2 = i2s_read_reg(dev->i2s_base, I2S_COMP_PARAM_2);
+	u32 idx = COMP1_APB_DATA_WIDTH(comp1);
+
+	if (WARN_ON(idx >= ARRAY_SIZE(bus_widths)))
+		return -EINVAL;
+
 	/* Set DMA slaves info */
 
 	dev->play_dma_data.data = pdata->play_dma_data;
@@ -348,26 +412,36 @@ static void dw_configure_dai_by_pd(struct dw_i2s_dev *dev,
 	dev->capture_dma_data.addr = res->start + I2S_RXDMA;
 	dev->play_dma_data.max_burst = 16;
 	dev->capture_dma_data.max_burst = 16;
-	dev->play_dma_data.addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
-	dev->capture_dma_data.addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
+	dev->play_dma_data.addr_width = bus_widths[idx];
+	dev->capture_dma_data.addr_width = bus_widths[idx];
 	dev->play_dma_data.filter = pdata->filter;
 	dev->capture_dma_data.filter = pdata->filter;
 
-	if (pdata->cap & DWC_I2S_PLAY) {
+	if (COMP1_TX_ENABLED(comp1)) {
 		dev_dbg(dev->dev, " designware: play supported\n");
+		idx = COMP1_TX_WORDSIZE_0(comp1);
+		if (WARN_ON(idx >= ARRAY_SIZE(formats)))
+			return -EINVAL;
 		dw_i2s_dai->playback.channels_min = MIN_CHANNEL_NUM;
-		dw_i2s_dai->playback.channels_max = pdata->channel;
-		dw_i2s_dai->playback.formats = pdata->snd_fmts;
+		dw_i2s_dai->playback.channels_max =
+				1 << (COMP1_TX_CHANNELS(comp1) + 1);
+		dw_i2s_dai->playback.formats = formats[idx];
 		dw_i2s_dai->playback.rates = pdata->snd_rates;
 	}
 
-	if (pdata->cap & DWC_I2S_RECORD) {
+	if (COMP1_RX_ENABLED(comp1)) {
 		dev_dbg(dev->dev, "designware: record supported\n");
+		idx = COMP2_RX_WORDSIZE_0(comp2);
+		if (WARN_ON(idx >= ARRAY_SIZE(formats)))
+			return -EINVAL;
 		dw_i2s_dai->capture.channels_min = MIN_CHANNEL_NUM;
-		dw_i2s_dai->capture.channels_max = pdata->channel;
-		dw_i2s_dai->capture.formats = pdata->snd_fmts;
+		dw_i2s_dai->capture.channels_max =
+				1 << (COMP1_RX_CHANNELS(comp1) + 1);
+		dw_i2s_dai->capture.formats = formats[idx];
 		dw_i2s_dai->capture.rates = pdata->snd_rates;
 	}
+
+	return 0;
 }
 
 static int dw_i2s_probe(struct platform_device *pdev)
@@ -403,7 +477,9 @@ static int dw_i2s_probe(struct platform_device *pdev)
 		return PTR_ERR(dev->i2s_base);
 
 	dev->dev = &pdev->dev;
-	dw_configure_dai_by_pd(dev, dw_i2s_dai, res, pdata);
+	ret = dw_configure_dai_by_pd(dev, dw_i2s_dai, res, pdata);
+	if (ret < 0)
+		return ret;
 
 	dev->capability = pdata->cap;
 	dev->i2s_clk_cfg = pdata->i2s_clk_cfg;
-- 
1.7.1

