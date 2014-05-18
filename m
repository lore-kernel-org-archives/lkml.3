Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363AbaERUvS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 16:51:18 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:45208 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025AbaERUvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 16:51:15 -0400
From: Emil Goode <emilgoode@gmail.com>
To: Shawn Guo <shawn.guo@freescale.com>, Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
Subject: [PATCH 2/2] ARM: imx: convert camera init to use platform_device_register_full()
Date: Sun, 18 May 2014 22:51:00 +0200
Message-Id: <1400446261-27085-3-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400446261-27085-1-git-send-email-emilgoode@gmail.com>
References: <1400446261-27085-1-git-send-email-emilgoode@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts the imx camera allocation and initialization functions
to use platform_device_register_full() thus simplifying the code.

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
Only build tested, unfortunately I currently don't have the hardware.

 arch/arm/mach-imx/devices/platform-ipu-core.c |   43 +++++++++----------------
 arch/arm/mach-imx/mach-mx31_3ds.c             |    5 ++-
 arch/arm/mach-imx/mach-mx31moboard.c          |    6 ++--
 arch/arm/mach-imx/mach-mx35_3ds.c             |    5 ++-
 arch/arm/mach-imx/mach-pcm037.c               |    5 ++-
 5 files changed, 23 insertions(+), 41 deletions(-)

diff --git a/arch/arm/mach-imx/devices/platform-ipu-core.c b/arch/arm/mach-imx/devices/platform-ipu-core.c
index 6bd7c3f..13ea542 100644
--- a/arch/arm/mach-imx/devices/platform-ipu-core.c
+++ b/arch/arm/mach-imx/devices/platform-ipu-core.c
@@ -69,42 +69,29 @@ struct platform_device *__init imx_alloc_mx3_camera(
 			.flags = IORESOURCE_MEM,
 		},
 	};
-	int ret = -ENOMEM;
-	struct platform_device *pdev;
+	struct platform_device_info pdevinfo;
+	struct mx3_camera_pdata tmppdata;
 
 	if (IS_ERR_OR_NULL(imx_ipu_coredev))
 		return ERR_PTR(-ENODEV);
 
-	pdev = platform_device_alloc("mx3-camera", 0);
-	if (!pdev)
-		return ERR_PTR(-ENOMEM);
-
-	pdev->dev.dma_mask = kmalloc(sizeof(*pdev->dev.dma_mask), GFP_KERNEL);
-	if (!pdev->dev.dma_mask)
-		goto err;
-
-	*pdev->dev.dma_mask = DMA_BIT_MASK(32);
-	pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
-
-	ret = platform_device_add_resources(pdev, res, ARRAY_SIZE(res));
-	if (ret)
-		goto err;
+	memset(&pdevinfo, 0, sizeof(pdevinfo));
+	pdevinfo.name = "mx3-camera";
+	pdevinfo.id = 0;
+	pdevinfo.res = res;
+	pdevinfo.num_res = ARRAY_SIZE(res);
+	pdevinfo.dma_mask = DMA_BIT_MASK(32);
 
 	if (pdata) {
-		struct mx3_camera_pdata *copied_pdata;
-
-		ret = platform_device_add_data(pdev, pdata, sizeof(*pdata));
-		if (ret) {
-err:
-			kfree(pdev->dev.dma_mask);
-			platform_device_put(pdev);
-			return ERR_PTR(-ENODEV);
-		}
-		copied_pdata = dev_get_platdata(&pdev->dev);
-		copied_pdata->dma_dev = &imx_ipu_coredev->dev;
+		tmppdata = *pdata;
+		tmppdata.dma_dev = &imx_ipu_coredev->dev;
+
+		pdata = &tmppdata;
+		pdevinfo.data = pdata;
+		pdevinfo.size_data = sizeof(*pdata);
 	}
 
-	return pdev;
+	return platform_device_register_full(&pdevinfo);
 }
 
 struct platform_device *__init imx_add_mx3_sdc_fb(
diff --git a/arch/arm/mach-imx/mach-mx31_3ds.c b/arch/arm/mach-imx/mach-mx31_3ds.c
index 4217871..a73a933 100644
--- a/arch/arm/mach-imx/mach-mx31_3ds.c
+++ b/arch/arm/mach-imx/mach-mx31_3ds.c
@@ -199,10 +199,9 @@ static int __init mx31_3ds_init_camera(void)
 	if (!(dma & DMA_MEMORY_MAP))
 		goto err;
 
-	ret = platform_device_add(pdev);
-	if (ret)
+	return 0;
 err:
-		platform_device_put(pdev);
+	platform_device_put(pdev);
 
 	return ret;
 }
diff --git a/arch/arm/mach-imx/mach-mx31moboard.c b/arch/arm/mach-imx/mach-mx31moboard.c
index 08730f2..14ca3b8 100644
--- a/arch/arm/mach-imx/mach-mx31moboard.c
+++ b/arch/arm/mach-imx/mach-mx31moboard.c
@@ -492,13 +492,11 @@ static int __init mx31moboard_init_cam(void)
 	if (!(dma & DMA_MEMORY_MAP))
 		goto err;
 
-	ret = platform_device_add(pdev);
-	if (ret)
+	return 0;
 err:
-		platform_device_put(pdev);
+	platform_device_put(pdev);
 
 	return ret;
-
 }
 
 static void mx31moboard_poweroff(void)
diff --git a/arch/arm/mach-imx/mach-mx35_3ds.c b/arch/arm/mach-imx/mach-mx35_3ds.c
index 4e8b184..c5a1b44 100644
--- a/arch/arm/mach-imx/mach-mx35_3ds.c
+++ b/arch/arm/mach-imx/mach-mx35_3ds.c
@@ -282,10 +282,9 @@ static int __init imx35_3ds_init_camera(void)
 	if (!(dma & DMA_MEMORY_MAP))
 		goto err;
 
-	ret = platform_device_add(pdev);
-	if (ret)
+	return 0;
 err:
-		platform_device_put(pdev);
+	platform_device_put(pdev);
 
 	return ret;
 }
diff --git a/arch/arm/mach-imx/mach-pcm037.c b/arch/arm/mach-imx/mach-pcm037.c
index 81b8aff..fa00e6d 100644
--- a/arch/arm/mach-imx/mach-pcm037.c
+++ b/arch/arm/mach-imx/mach-pcm037.c
@@ -425,10 +425,9 @@ static int __init pcm037_init_camera(void)
 	if (!(dma & DMA_MEMORY_MAP))
 		goto err;
 
-	ret = platform_device_add(pdev);
-	if (ret)
+	return 0;
 err:
-		platform_device_put(pdev);
+	platform_device_put(pdev);
 
 	return ret;
 }
-- 
1.7.10.4

