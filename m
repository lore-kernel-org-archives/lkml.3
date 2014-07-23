Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843AbaGWFVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 01:21:24 -0400
Received: from cluster-d.mailcontrol.com ([85.115.60.190]:56538 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755866AbaGWFVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 01:21:23 -0400
X-PGP-Universal: processed;
	by shaapppus01.asia.root.pri on Wed, 23 Jul 2014 13:20:45 +0800
From: Rongjun Ying <rongjun.ying@csr.com>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Barry Song <baohua@kernel.org>, Arnd Bergmann <arnd@arndb.de>
CC: <alsa-devel@alsa-project.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <Workgroup.Linux@csr.com>,
        Rongjun Ying <rongjun.ying@csr.com>
Subject: [PATCH 1/1] ASoC: sirf-usp: Fixed a bug for playback and capture work at the same time
Date: Wed, 23 Jul 2014 13:19:32 +0800
Message-ID: <1406092772-26371-1-git-send-email-rongjun.ying@csr.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
X-Originating-IP: [10.125.12.180]
X-CFilter-Loop: Reflected
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. The startup function invoked when the playback and capture.
   If start playback when capturing, the registers are re-initinitialised.
   That cause the playback fail. So move the startup code into runtime resume.
2. Modified: If non RUNTIME_PM support, the probe need enable clock and
   initinitialise registers.
3. Refine code.

Signed-off-by: Rongjun Ying <rongjun.ying@csr.com>
---
 sound/soc/sirf/sirf-usp.c | 54 +++++++++++++++++++++++------------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/sound/soc/sirf/sirf-usp.c b/sound/soc/sirf/sirf-usp.c
index 9693bc2..3a73037 100644
--- a/sound/soc/sirf/sirf-usp.c
+++ b/sound/soc/sirf/sirf-usp.c
@@ -103,11 +103,8 @@ static int sirf_usp_pcm_set_dai_fmt(struct snd_soc_dai *dai,
 	return 0;
 }
 
-static int sirf_usp_i2s_startup(struct snd_pcm_substream *substream,
-		struct snd_soc_dai *dai)
+static void sirf_usp_i2s_init(struct sirf_usp *usp)
 {
-	struct sirf_usp *usp = snd_soc_dai_get_drvdata(dai);
-
 	/* Configure RISC mode */
 	regmap_update_bits(usp->regmap, USP_RISC_DSP_MODE,
 		USP_RISC_DSP_SEL, ~USP_RISC_DSP_SEL);
@@ -119,19 +116,16 @@ static int sirf_usp_i2s_startup(struct snd_pcm_substream *substream,
 	regmap_write(usp->regmap, USP_TX_DMA_IO_LEN, 0);
 	regmap_write(usp->regmap, USP_RX_DMA_IO_LEN, 0);
 
-	regmap_write(usp->regmap, USP_RX_FRAME_CTRL, USP_SINGLE_SYNC_MODE);
-
-	regmap_write(usp->regmap, USP_TX_FRAME_CTRL, USP_TXC_SLAVE_CLK_SAMPLE);
-
 	/* Configure Mode2 register */
 	regmap_write(usp->regmap, USP_MODE2, (1 << USP_RXD_DELAY_LEN_OFFSET) |
-		(0 << USP_TXD_DELAY_LEN_OFFSET));
+		(0 << USP_TXD_DELAY_LEN_OFFSET) |
+		USP_TFS_CLK_SLAVE_MODE | USP_RFS_CLK_SLAVE_MODE);
 
 	/* Configure Mode1 register */
 	regmap_write(usp->regmap, USP_MODE1,
 		USP_SYNC_MODE | USP_EN | USP_TXD_ACT_EDGE_FALLING |
 		USP_RFS_ACT_LEVEL_LOGIC1 | USP_TFS_ACT_LEVEL_LOGIC1 |
-		USP_TX_UFLOW_REPEAT_ZERO);
+		USP_TX_UFLOW_REPEAT_ZERO | USP_CLOCK_MODE_SLAVE);
 
 	/* Configure RX DMA IO Control register */
 	regmap_write(usp->regmap, USP_RX_DMA_IO_CTRL, 0);
@@ -155,8 +149,6 @@ static int sirf_usp_i2s_startup(struct snd_pcm_substream *substream,
 	/* Congiure TX FIFO Level Check register */
 	regmap_write(usp->regmap, USP_TX_FIFO_LEVEL_CHK,
 		TX_FIFO_SC(0x1B) | TX_FIFO_LC(0x0E) | TX_FIFO_HC(0x04));
-
-	return 0;
 }
 
 static int sirf_usp_pcm_hw_params(struct snd_pcm_substream *substream,
@@ -204,23 +196,19 @@ static int sirf_usp_pcm_hw_params(struct snd_pcm_substream *substream,
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
 		regmap_update_bits(usp->regmap, USP_TX_FRAME_CTRL,
 			USP_TXC_DATA_LEN_MASK | USP_TXC_FRAME_LEN_MASK
-			| USP_TXC_SHIFTER_LEN_MASK,
+			| USP_TXC_SHIFTER_LEN_MASK | USP_TXC_SLAVE_CLK_SAMPLE,
 			((data_len - 1) << USP_TXC_DATA_LEN_OFFSET)
 			| ((frame_len - 1) << USP_TXC_FRAME_LEN_OFFSET)
-			| ((shifter_len - 1) << USP_TXC_SHIFTER_LEN_OFFSET));
+			| ((shifter_len - 1) << USP_TXC_SHIFTER_LEN_OFFSET)
+			| USP_TXC_SLAVE_CLK_SAMPLE);
 	else
 		regmap_update_bits(usp->regmap, USP_RX_FRAME_CTRL,
 			USP_RXC_DATA_LEN_MASK | USP_RXC_FRAME_LEN_MASK
-			| USP_RXC_SHIFTER_LEN_MASK,
+			| USP_RXC_SHIFTER_LEN_MASK | USP_SINGLE_SYNC_MODE,
 			((data_len - 1) << USP_RXC_DATA_LEN_OFFSET)
 			| ((frame_len - 1) << USP_RXC_FRAME_LEN_OFFSET)
-			| ((shifter_len - 1) << USP_RXC_SHIFTER_LEN_OFFSET));
-
-	regmap_update_bits(usp->regmap, USP_MODE1,
-			USP_CLOCK_MODE_SLAVE, USP_CLOCK_MODE_SLAVE);
-	regmap_update_bits(usp->regmap, USP_MODE2,
-			USP_TFS_CLK_SLAVE_MODE | USP_RFS_CLK_SLAVE_MODE,
-			USP_TFS_CLK_SLAVE_MODE | USP_RFS_CLK_SLAVE_MODE);
+			| ((shifter_len - 1) << USP_RXC_SHIFTER_LEN_OFFSET)
+			| USP_SINGLE_SYNC_MODE);
 
 	return 0;
 }
@@ -253,7 +241,6 @@ static int sirf_usp_pcm_trigger(struct snd_pcm_substream *substream, int cmd,
 }
 
 static const struct snd_soc_dai_ops sirf_usp_pcm_dai_ops = {
-	.startup = sirf_usp_i2s_startup,
 	.trigger = sirf_usp_pcm_trigger,
 	.set_fmt = sirf_usp_pcm_set_dai_fmt,
 	.hw_params = sirf_usp_pcm_hw_params,
@@ -282,7 +269,6 @@ static struct snd_soc_dai_driver sirf_usp_pcm_dai = {
 	.ops = &sirf_usp_pcm_dai_ops,
 };
 
-#ifdef CONFIG_PM
 static int sirf_usp_pcm_runtime_suspend(struct device *dev)
 {
 	struct sirf_usp *usp = dev_get_drvdata(dev);
@@ -293,9 +279,15 @@ static int sirf_usp_pcm_runtime_suspend(struct device *dev)
 static int sirf_usp_pcm_runtime_resume(struct device *dev)
 {
 	struct sirf_usp *usp = dev_get_drvdata(dev);
-	return clk_prepare_enable(usp->clk);
+	int ret;
+	ret = clk_prepare_enable(usp->clk);
+	if (ret) {
+		dev_err(dev, "clk_enable failed: %d\n", ret);
+		return ret;
+	}
+	sirf_usp_i2s_init(usp);
+	return 0;
 }
-#endif
 
 #ifdef CONFIG_PM_SLEEP
 static int sirf_usp_pcm_suspend(struct device *dev)
@@ -369,6 +361,11 @@ static int sirf_usp_pcm_probe(struct platform_device *pdev)
 	}
 
 	pm_runtime_enable(&pdev->dev);
+	if (!pm_runtime_enabled(&pdev->dev)) {
+		ret = sirf_usp_pcm_runtime_resume(&pdev->dev);
+		if (ret)
+			return ret;
+	}
 
 	ret = devm_snd_soc_register_component(&pdev->dev, &sirf_usp_component,
 		&sirf_usp_pcm_dai, 1);
@@ -381,7 +378,10 @@ static int sirf_usp_pcm_probe(struct platform_device *pdev)
 
 static int sirf_usp_pcm_remove(struct platform_device *pdev)
 {
-	pm_runtime_disable(&pdev->dev);
+	if (!pm_runtime_enabled(&pdev->dev))
+		sirf_usp_pcm_runtime_suspend(&pdev->dev);
+	else
+		pm_runtime_disable(&pdev->dev);
 	return 0;
 }
 
-- 
1.9.3



Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
More information can be found at www.csr.com. Keep up to date with CSR on our technical blog, www.csr.com/blog, CSR people blog, www.csr.com/people, YouTube, www.youtube.com/user/CSRplc, Facebook, www.facebook.com/pages/CSR/191038434253534, or follow us on Twitter at www.twitter.com/CSR_plc.
New for 2014, you can now access the wide range of products powered by aptX at www.aptx.com.
