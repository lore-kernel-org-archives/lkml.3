Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748Ab3LSPzp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:55:45 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:51749 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488Ab3LSPzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:55:42 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, broonie@kernel.org, alsa-devel@alsa-project.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 07/11] ASoC: ux500_pcm: Extend Device Tree support to deal with DMA data
Date: Thu, 19 Dec 2013 15:55:04 +0000
Message-Id: <1387468508-12286-8-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387468508-12286-1-git-send-email-lee.jones@linaro.org>
References: <1387468508-12286-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Soon we will strip out pdata support from the Ux500 set of ASoC drivers.
When this happens it will have to supply a DMA slave_config to the
dmaengine. At the moment a great deal of this comes from pdata via
AUXDATA. We need to become independent of this soon. This patch starts
the process by allocating memory for the associated data structures and
fetches the MSP id used for const struct indexing.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 sound/soc/ux500/ux500_msp_i2s.c | 56 ++++++++++++++++++++++++++++++-----------
 1 file changed, 41 insertions(+), 15 deletions(-)

diff --git a/sound/soc/ux500/ux500_msp_i2s.c b/sound/soc/ux500/ux500_msp_i2s.c
index 1ca8b08..7f2a4ac 100644
--- a/sound/soc/ux500/ux500_msp_i2s.c
+++ b/sound/soc/ux500/ux500_msp_i2s.c
@@ -646,6 +646,34 @@ int ux500_msp_i2s_close(struct ux500_msp *msp, unsigned int dir)
 
 }
 
+int ux500_msp_i2s_of_init_msp(struct platform_device *pdev,
+			      struct ux500_msp *msp,
+			      struct msp_i2s_platform_data **platform_data)
+{
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
+	return 0;
+}
+
 int ux500_msp_i2s_init_msp(struct platform_device *pdev,
 			struct ux500_msp **msp_p,
 			struct msp_i2s_platform_data *platform_data)
@@ -653,30 +681,28 @@ int ux500_msp_i2s_init_msp(struct platform_device *pdev,
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
+	} else {
+		msp->playback_dma_data.dma_cfg = platform_data->msp_i2s_dma_tx;
+		msp->capture_dma_data.dma_cfg = platform_data->msp_i2s_dma_rx;
+		msp->id = platform_data->id;
+	}
 
-	dev_dbg(&pdev->dev, "%s: Enter (name: %s, id: %d).\n", __func__,
-		pdev->name, platform_data->id);
-
-	msp->id = platform_data->id;
 	msp->dev = &pdev->dev;
-	msp->playback_dma_data.dma_cfg = platform_data->msp_i2s_dma_tx;
-	msp->capture_dma_data.dma_cfg = platform_data->msp_i2s_dma_rx;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (res == NULL) {
-- 
1.8.3.2

