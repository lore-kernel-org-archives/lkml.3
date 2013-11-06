Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248Ab3KFKRM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 05:17:12 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:39982 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932137Ab3KFKRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 05:17:08 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>,
        alsa-devel@alsa-project.org, Mark Brown <broonie@kernel.org>
Subject: [PATCH 11/13] ASoC: ux500: Store DMA data in the DAI differently in the pdata and DT case
Date: Wed,  6 Nov 2013 10:16:23 +0000
Message-Id: <1383732985-18928-12-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383732985-18928-1-git-send-email-lee.jones@linaro.org>
References: <1383732985-18928-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this patch we do two things. Firstly, instead of open coding the
store of DMA data in to the DAI for later use, we use the API provided.
Secondly we create and store similar DMA data for the DT case, only
this time we use 'struct snd_dmaengine_dai_dma_data' which is provided
by the core for this very reason.

Cc: alsa-devel@alsa-project.org
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 sound/soc/ux500/ux500_msp_dai.c | 41 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 2 deletions(-)

diff --git a/sound/soc/ux500/ux500_msp_dai.c b/sound/soc/ux500/ux500_msp_dai.c
index c6fb5cc..35187d8 100644
--- a/sound/soc/ux500/ux500_msp_dai.c
+++ b/sound/soc/ux500/ux500_msp_dai.c
@@ -17,12 +17,14 @@
 #include <linux/bitops.h>
 #include <linux/platform_device.h>
 #include <linux/clk.h>
+#include <linux/of.h>
 #include <linux/regulator/consumer.h>
 #include <linux/mfd/dbx500-prcmu.h>
 #include <linux/platform_data/asoc-ux500-msp.h>
 
 #include <sound/soc.h>
 #include <sound/soc-dai.h>
+#include <sound/dmaengine_pcm.h>
 
 #include "ux500_msp_i2s.h"
 #include "ux500_msp_dai.h"
@@ -654,16 +656,51 @@ static int ux500_msp_dai_trigger(struct snd_pcm_substream *substream,
 	return ret;
 }
 
+static int ux500_msp_dai_of_probe(struct snd_soc_dai *dai)
+{
+	struct snd_dmaengine_dai_dma_data *playback_dma_data;
+	struct snd_dmaengine_dai_dma_data *capture_dma_data;
+
+	playback_dma_data = devm_kzalloc(dai->dev,
+					 sizeof(*playback_dma_data),
+					 GFP_KERNEL);
+	if (!playback_dma_data)
+		return -ENOMEM;
+
+	capture_dma_data = devm_kzalloc(dai->dev,
+					sizeof(*capture_dma_data),
+					GFP_KERNEL);
+	if (!capture_dma_data)
+		return -ENOMEM;
+
+	playback_dma_data->addr = drvdata->msp->playback_dma_data.tx_rx_addr;
+	capture_dma_data->addr = drvdata->msp->capture_dma_data.tx_rx_addr;
+
+	playback_dma_data->maxburst = 4;
+	capture_dma_data->maxburst = 4;
+
+	snd_soc_dai_init_dma_data(dai, playback_dma_data, capture_dma_data);
+
+	return 0;
+}
+
 static int ux500_msp_dai_probe(struct snd_soc_dai *dai)
 {
 	struct ux500_msp_i2s_drvdata *drvdata = dev_get_drvdata(dai->dev);
+	struct device_node *np = dai->dev->of_node;
+	int ret;
 
-	dai->playback_dma_data = &drvdata->msp->playback_dma_data;
-	dai->capture_dma_data = &drvdata->msp->capture_dma_data;
+	if (np) {
+		ret = ux500_msp_dai_of_probe(dai);
+		return ret;
+	}
 
 	drvdata->msp->playback_dma_data.data_size = drvdata->slot_width;
 	drvdata->msp->capture_dma_data.data_size = drvdata->slot_width;
 
+	snd_soc_dai_init_dma_data(dai,
+				  &drvdata->msp->playback_dma_data,
+				  &drvdata->msp->capture_dma_data);
 	return 0;
 }
 
-- 
1.8.1.2

