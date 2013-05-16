Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612Ab3EPHL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 03:11:26 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:55628 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754988Ab3EPHLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 03:11:21 -0400
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LFBDEV <linux-fbdev@vger.kernel.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 2/2] video:da8xx-fb: Convert to devm_* api
Date: Thu, 16 May 2013 12:40:57 +0530
Message-Id: <1368688257-18705-3-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1368688257-18705-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1368688257-18705-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Use devm_ioremap_resource instead of reques_mem_region()/ioremap() and
devm_request_irq() instead of request_irq().

This ensures more consistent error values and simplifies error paths.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/video/da8xx-fb.c |   39 +++++++--------------------------------
 1 files changed, 7 insertions(+), 32 deletions(-)

diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index aafe8b9..d35ea1d 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -134,7 +134,6 @@
 #define LOWER_MARGIN	32
 
 static void __iomem *da8xx_fb_reg_base;
-static struct resource *lcdc_regs;
 static unsigned int lcd_revision;
 static irq_handler_t lcdc_irq_handler;
 static wait_queue_head_t frame_done_wq;
@@ -1015,12 +1014,9 @@ static int fb_remove(struct platform_device *dev)
 				  par->p_palette_base);
 		dma_free_coherent(NULL, par->vram_size, par->vram_virt,
 				  par->vram_phys);
-		free_irq(par->irq, par);
 		pm_runtime_put_sync(&dev->dev);
 		pm_runtime_disable(&dev->dev);
 		framebuffer_release(info);
-		iounmap(da8xx_fb_reg_base);
-		release_mem_region(lcdc_regs->start, resource_size(lcdc_regs));
 
 	}
 	return 0;
@@ -1212,12 +1208,12 @@ static int fb_probe(struct platform_device *device)
 {
 	struct da8xx_lcdc_platform_data *fb_pdata =
 						device->dev.platform_data;
+	static struct resource *lcdc_regs;
 	struct lcd_ctrl_config *lcd_cfg;
 	struct fb_videomode *lcdc_info;
 	struct fb_info *da8xx_fb_info;
 	struct clk *fb_clk = NULL;
 	struct da8xx_fb_par *par;
-	resource_size_t len;
 	int ret, i;
 	unsigned long ulcm;
 
@@ -1227,29 +1223,14 @@ static int fb_probe(struct platform_device *device)
 	}
 
 	lcdc_regs = platform_get_resource(device, IORESOURCE_MEM, 0);
-	if (!lcdc_regs) {
-		dev_err(&device->dev,
-			"Can not get memory resource for LCD controller\n");
-		return -ENOENT;
-	}
-
-	len = resource_size(lcdc_regs);
-
-	lcdc_regs = request_mem_region(lcdc_regs->start, len, lcdc_regs->name);
-	if (!lcdc_regs)
-		return -EBUSY;
-
-	da8xx_fb_reg_base = ioremap(lcdc_regs->start, len);
-	if (!da8xx_fb_reg_base) {
-		ret = -EBUSY;
-		goto err_request_mem;
-	}
+	da8xx_fb_reg_base = devm_ioremap_resource(&device->dev, lcdc_regs);
+	if (IS_ERR(da8xx_fb_reg_base))
+		return PTR_ERR(da8xx_fb_reg_base);
 
 	fb_clk = clk_get(&device->dev, "fck");
 	if (IS_ERR(fb_clk)) {
 		dev_err(&device->dev, "Can not get device clock\n");
-		ret = -ENODEV;
-		goto err_ioremap;
+		return -ENODEV;
 	}
 
 	pm_runtime_enable(&device->dev);
@@ -1430,8 +1411,8 @@ static int fb_probe(struct platform_device *device)
 		lcdc_irq_handler = lcdc_irq_handler_rev02;
 	}
 
-	ret = request_irq(par->irq, lcdc_irq_handler, 0,
-			DRIVER_NAME, par);
+	ret = devm_request_irq(&device->dev, par->irq, lcdc_irq_handler, 0,
+			       DRIVER_NAME, par);
 	if (ret)
 		goto irq_freq;
 	return 0;
@@ -1460,12 +1441,6 @@ err_pm_runtime_disable:
 	pm_runtime_put_sync(&device->dev);
 	pm_runtime_disable(&device->dev);
 
-err_ioremap:
-	iounmap(da8xx_fb_reg_base);
-
-err_request_mem:
-	release_mem_region(lcdc_regs->start, len);
-
 	return ret;
 }
 
-- 
1.7.4.1

