Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684AbaEZQlX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 12:41:23 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:61389 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbaEZQlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:41:22 -0400
From: Emil Goode <emilgoode@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Yann Droneaud <ydroneaud@opteya.com>, Shawn Guo <shawn.guo@freescale.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
Subject: [PATCH 3/3] ARM: imx: don't allocate memory for .dma_mask of struct device
Date: Mon, 26 May 2014 18:41:23 +0200
Message-Id: <1401122483-31603-3-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401122483-31603-1-git-send-email-emilgoode@gmail.com>
References: <1401122483-31603-1-git-send-email-emilgoode@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first patch in this series changed the platform_device_alloc
function to assign the u64 .dma_mask pointer of struct device to
the address of a u64 .dma_mask member of struct platform_object.

This means that we no longer should allocate memory for the .dma_mask
pointer of struct device when using platform_device_alloc() and the
u64 .dma_mask of struct platform_object that it points to will be freed
when the release callback function platform_device_release is called.

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 arch/arm/mach-imx/devices/platform-ipu-core.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm/mach-imx/devices/platform-ipu-core.c b/arch/arm/mach-imx/devices/platform-ipu-core.c
index 6bd7c3f..4499a7d 100644
--- a/arch/arm/mach-imx/devices/platform-ipu-core.c
+++ b/arch/arm/mach-imx/devices/platform-ipu-core.c
@@ -79,10 +79,6 @@ struct platform_device *__init imx_alloc_mx3_camera(
 	if (!pdev)
 		return ERR_PTR(-ENOMEM);
 
-	pdev->dev.dma_mask = kmalloc(sizeof(*pdev->dev.dma_mask), GFP_KERNEL);
-	if (!pdev->dev.dma_mask)
-		goto err;
-
 	*pdev->dev.dma_mask = DMA_BIT_MASK(32);
 	pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
 
@@ -96,7 +92,6 @@ struct platform_device *__init imx_alloc_mx3_camera(
 		ret = platform_device_add_data(pdev, pdata, sizeof(*pdata));
 		if (ret) {
 err:
-			kfree(pdev->dev.dma_mask);
 			platform_device_put(pdev);
 			return ERR_PTR(-ENODEV);
 		}
-- 
1.7.10.4

