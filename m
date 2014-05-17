Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030380AbaEQSkk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 14:40:40 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:53542 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964889AbaEQSkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 14:40:39 -0400
From: Emil Goode <emilgoode@gmail.com>
To: Shawn Guo <shawn.guo@freescale.com>, Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
Subject: [PATCH v3] ARM: imx: fix error handling in ipu device registration
Date: Sat, 17 May 2014 20:40:33 +0200
Message-Id: <1400352033-18262-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we fail to allocate struct platform_device pdev we
dereference it after the goto label err.

I have rearranged the error handling a bit to fix the issue
and also make it more clear.

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
v3: Made subject line more specific.
v2: Changed to return -ENOMEM instead of ret where possible and
    updated the subject line.

 arch/arm/mach-imx/devices/platform-ipu-core.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-imx/devices/platform-ipu-core.c b/arch/arm/mach-imx/devices/platform-ipu-core.c
index fc4dd7c..68f2a4a 100644
--- a/arch/arm/mach-imx/devices/platform-ipu-core.c
+++ b/arch/arm/mach-imx/devices/platform-ipu-core.c
@@ -77,34 +77,38 @@ struct platform_device *__init imx_alloc_mx3_camera(
 
 	pdev = platform_device_alloc("mx3-camera", 0);
 	if (!pdev)
-		goto err;
+		return ERR_PTR(-ENOMEM);
 
 	pdev->dev.dma_mask = kmalloc(sizeof(*pdev->dev.dma_mask), GFP_KERNEL);
 	if (!pdev->dev.dma_mask)
-		goto err;
+		goto put_pdev;
 
 	*pdev->dev.dma_mask = DMA_BIT_MASK(32);
 	pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
 
 	ret = platform_device_add_resources(pdev, res, ARRAY_SIZE(res));
 	if (ret)
-		goto err;
+		goto free_dma_mask;
 
 	if (pdata) {
 		struct mx3_camera_pdata *copied_pdata;
 
 		ret = platform_device_add_data(pdev, pdata, sizeof(*pdata));
-		if (ret) {
-err:
-			kfree(pdev->dev.dma_mask);
-			platform_device_put(pdev);
-			return ERR_PTR(-ENODEV);
-		}
+		if (ret)
+			goto free_dma_mask;
+
 		copied_pdata = dev_get_platdata(&pdev->dev);
 		copied_pdata->dma_dev = &imx_ipu_coredev->dev;
 	}
 
 	return pdev;
+
+free_dma_mask:
+	kfree(pdev->dev.dma_mask);
+put_pdev:
+	platform_device_put(pdev);
+
+	return ERR_PTR(ret);
 }
 
 struct platform_device *__init imx_add_mx3_sdc_fb(
-- 
1.7.10.4

