Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab3FLH6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 03:58:17 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:48756 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab3FLH6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 03:58:14 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 1/3] ASoC: ux500: Move DMA parameters into ux500_msp
Date: Wed, 12 Jun 2013 09:57:57 +0200
Message-Id: <1371023879-21884-2-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1371023879-21884-1-git-send-email-fabio.baltieri@linaro.org>
References: <1371023879-21884-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move struct ux500_msp_dma_params declaration from ux500_msp_i2s_drvdata
to ux500_msp, this saves some confusing pointer passing and allows to
access all DMA configuration fields from ux500_msp_i2s.

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 sound/soc/ux500/ux500_msp_dai.c | 11 ++++-------
 sound/soc/ux500/ux500_msp_dai.h |  2 --
 sound/soc/ux500/ux500_msp_i2s.c | 10 ++++++----
 sound/soc/ux500/ux500_msp_i2s.h | 14 +++++++-------
 4 files changed, 17 insertions(+), 20 deletions(-)

diff --git a/sound/soc/ux500/ux500_msp_dai.c b/sound/soc/ux500/ux500_msp_dai.c
index 7d5fc13..c6fb5cc 100644
--- a/sound/soc/ux500/ux500_msp_dai.c
+++ b/sound/soc/ux500/ux500_msp_dai.c
@@ -658,14 +658,11 @@ static int ux500_msp_dai_probe(struct snd_soc_dai *dai)
 {
 	struct ux500_msp_i2s_drvdata *drvdata = dev_get_drvdata(dai->dev);
 
-	drvdata->playback_dma_data.dma_cfg = drvdata->msp->dma_cfg_tx;
-	drvdata->capture_dma_data.dma_cfg = drvdata->msp->dma_cfg_rx;
+	dai->playback_dma_data = &drvdata->msp->playback_dma_data;
+	dai->capture_dma_data = &drvdata->msp->capture_dma_data;
 
-	dai->playback_dma_data = &drvdata->playback_dma_data;
-	dai->capture_dma_data = &drvdata->capture_dma_data;
-
-	drvdata->playback_dma_data.data_size = drvdata->slot_width;
-	drvdata->capture_dma_data.data_size = drvdata->slot_width;
+	drvdata->msp->playback_dma_data.data_size = drvdata->slot_width;
+	drvdata->msp->capture_dma_data.data_size = drvdata->slot_width;
 
 	return 0;
 }
diff --git a/sound/soc/ux500/ux500_msp_dai.h b/sound/soc/ux500/ux500_msp_dai.h
index c721282..312ae53 100644
--- a/sound/soc/ux500/ux500_msp_dai.h
+++ b/sound/soc/ux500/ux500_msp_dai.h
@@ -51,8 +51,6 @@ enum ux500_msp_clock_id {
 struct ux500_msp_i2s_drvdata {
 	struct ux500_msp *msp;
 	struct regulator *reg_vape;
-	struct ux500_msp_dma_params playback_dma_data;
-	struct ux500_msp_dma_params capture_dma_data;
 	unsigned int fmt;
 	unsigned int tx_mask;
 	unsigned int rx_mask;
diff --git a/sound/soc/ux500/ux500_msp_i2s.c b/sound/soc/ux500/ux500_msp_i2s.c
index cba0e86..14a4a5b 100644
--- a/sound/soc/ux500/ux500_msp_i2s.c
+++ b/sound/soc/ux500/ux500_msp_i2s.c
@@ -367,12 +367,14 @@ static int enable_msp(struct ux500_msp *msp, struct ux500_msp_config *config)
 	}
 
 	/* Make sure the correct DMA-directions are configured */
-	if ((config->direction & MSP_DIR_RX) && (!msp->dma_cfg_rx)) {
+	if ((config->direction & MSP_DIR_RX) &&
+			!msp->capture_dma_data.dma_cfg) {
 		dev_err(msp->dev, "%s: ERROR: MSP RX-mode is not configured!",
 			__func__);
 		return -EINVAL;
 	}
-	if ((config->direction == MSP_DIR_TX) && (!msp->dma_cfg_tx)) {
+	if ((config->direction == MSP_DIR_TX) &&
+			!msp->playback_dma_data.dma_cfg) {
 		dev_err(msp->dev, "%s: ERROR: MSP TX-mode is not configured!",
 			__func__);
 		return -EINVAL;
@@ -673,8 +675,8 @@ int ux500_msp_i2s_init_msp(struct platform_device *pdev,
 
 	msp->id = platform_data->id;
 	msp->dev = &pdev->dev;
-	msp->dma_cfg_rx = platform_data->msp_i2s_dma_rx;
-	msp->dma_cfg_tx = platform_data->msp_i2s_dma_tx;
+	msp->playback_dma_data.dma_cfg = platform_data->msp_i2s_dma_tx;
+	msp->capture_dma_data.dma_cfg = platform_data->msp_i2s_dma_rx;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (res == NULL) {
diff --git a/sound/soc/ux500/ux500_msp_i2s.h b/sound/soc/ux500/ux500_msp_i2s.h
index 189a375..8796171 100644
--- a/sound/soc/ux500/ux500_msp_i2s.h
+++ b/sound/soc/ux500/ux500_msp_i2s.h
@@ -468,12 +468,17 @@ struct ux500_msp_config {
 	unsigned int iodelay;
 };
 
+struct ux500_msp_dma_params {
+	unsigned int data_size;
+	struct stedma40_chan_cfg *dma_cfg;
+};
+
 struct ux500_msp {
 	enum msp_i2s_id id;
 	void __iomem *registers;
 	struct device *dev;
-	struct stedma40_chan_cfg *dma_cfg_rx;
-	struct stedma40_chan_cfg *dma_cfg_tx;
+	struct ux500_msp_dma_params playback_dma_data;
+	struct ux500_msp_dma_params capture_dma_data;
 	enum msp_state msp_state;
 	int def_elem_len;
 	unsigned int dir_busy;
@@ -481,11 +486,6 @@ struct ux500_msp {
 	unsigned int f_bitclk;
 };
 
-struct ux500_msp_dma_params {
-	unsigned int data_size;
-	struct stedma40_chan_cfg *dma_cfg;
-};
-
 struct msp_i2s_platform_data;
 int ux500_msp_i2s_init_msp(struct platform_device *pdev,
 			struct ux500_msp **msp_p,
-- 
1.8.2

