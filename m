Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289Ab3KFKSI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 05:18:08 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:33061 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203Ab3KFKRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 05:17:06 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>,
        alsa-devel@alsa-project.org, Mark Brown <broonie@kernel.org>
Subject: [PATCH 10/13] ASoC: ux500_pcm: Extend Device Tree support to deal with DMA data
Date: Wed,  6 Nov 2013 10:16:22 +0000
Message-Id: <1383732985-18928-11-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383732985-18928-1-git-send-email-lee.jones@linaro.org>
References: <1383732985-18928-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Soon we will strip out pdata support from the Ux500 set of ASoC drivers.
When this happens it will have to supply a DMA slave_config to the
dmaengine. At the moment a great deal of this comes from pdata via
AUXDATA. We need to become independent of this soon. This patch starts
the process by allocating memory for the associated data structures and
fetches the MSP id used for const struct indexing.

Cc: alsa-devel@alsa-project.org
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 sound/soc/ux500/ux500_msp_i2s.c | 68 ++++++++++++++++++++++++++++-------------
 1 file changed, 47 insertions(+), 21 deletions(-)

diff --git a/sound/soc/ux500/ux500_msp_i2s.c b/sound/soc/ux500/ux500_msp_i2s.c
index 0a99372..2e916d1 100644
--- a/sound/soc/ux500/ux500_msp_i2s.c
+++ b/sound/soc/ux500/ux500_msp_i2s.c
@@ -646,6 +646,41 @@ int ux500_msp_i2s_close(struct ux500_msp *msp, unsigned int dir)
 
 }
 
+int ux500_msp_i2s_of_init_msp(struct platform_device *pdev,
+			      struct ux500_msp *msp,
+			      struct msp_i2s_platform_data **platform_data)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct msp_i2s_platform_data *pdata;
+
+	*platform_data = devm_kzalloc(&pdev->dev,
+				     sizeof(struct msp_i2s_platform_data),
+				     GFP_KERNEL);
+	pdata = *platform_data;
+	if (!pdata)
+		return -ENOMEM;
+
+	msp->playback_dma_data.dma_cfg = devm_kzalloc(&pdev->dev,
+					sizeof(struct stedma40_chan_cfg),
+					GFP_KERNEL);
+	if (!msp->playback_dma_data.dma_cfg)
+		return -ENOMEM;
+
+	msp->capture_dma_data.dma_cfg = devm_kzalloc(&pdev->dev,
+					sizeof(struct stedma40_chan_cfg),
+					GFP_KERNEL);
+	if (!msp->capture_dma_data.dma_cfg)
+		return -ENOMEM;
+
+	if (of_property_read_u32(np, "id", &pdata->id)) {
+		dev_err(&pdev->dev,
+			"No 'id' property found in DT\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 int ux500_msp_i2s_init_msp(struct platform_device *pdev,
 			struct ux500_msp **msp_p,
 			struct msp_i2s_platform_data *platform_data)
@@ -653,37 +688,28 @@ int ux500_msp_i2s_init_msp(struct platform_device *pdev,
 	struct resource *res = NULL;
 	struct device_node *np = pdev->dev.of_node;
 	struct ux500_msp *msp;
+	int ret;
 
 	*msp_p = devm_kzalloc(&pdev->dev, sizeof(struct ux500_msp), GFP_KERNEL);
 	msp = *msp_p;
 	if (!msp)
 		return -ENOMEM;
 
-	if (np) {
-		if (!platform_data) {
-			platform_data = devm_kzalloc(&pdev->dev,
-				sizeof(struct msp_i2s_platform_data), GFP_KERNEL);
-			if (!platform_data)
-				return -ENOMEM;
-
-			if (!of_property_read_u32(np, "id",
-						  &platform_data->id)) {
-				dev_err(&pdev->dev,
-					"No 'id' property found in DT\n");
-				return -EINVAL;
-			}
-		}
-	} else
-		if (!platform_data)
+	if (!platform_data) {
+		if (np) {
+			ret = ux500_msp_i2s_of_init_msp(pdev, msp,
+							&platform_data);
+			if (ret)
+				return ret;
+		} else
 			return -EINVAL;
-
-	dev_dbg(&pdev->dev, "%s: Enter (name: %s, id: %d).\n", __func__,
-		pdev->name, platform_data->id);
+	} else {
+		msp->playback_dma_data.dma_cfg = platform_data->msp_i2s_dma_tx;
+		msp->capture_dma_data.dma_cfg = platform_data->msp_i2s_dma_rx;
+	}
 
 	msp->id = platform_data->id;
 	msp->dev = &pdev->dev;
-	msp->playback_dma_data.dma_cfg = platform_data->msp_i2s_dma_tx;
-	msp->capture_dma_data.dma_cfg = platform_data->msp_i2s_dma_rx;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (res == NULL) {
-- 
1.8.1.2

