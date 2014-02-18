Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbaBRDZs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 22:25:48 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:55957 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbaBRDZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 22:25:46 -0500
From: Manish Badarkhe <badarkhe.manish@gmail.com>
To: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com
Cc: tomi.valkeinen@ti.com, plagnioj@jcrosoft.com, nsekhar@ti.com,
        badarkhe.manish@gmail.com
Subject: [PATCH] video: da8xx-fb: Use "SIMPLE_DEV_PM_OPS" macro
Date: Tue, 18 Feb 2014 08:55:36 +0530
Message-Id: <1392693936-23862-1-git-send-email-badarkhe.manish@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update driver to use SIMPLE_DEV_PM_OPS macro for power
management suspend and resume operations.

Signed-off-by: Manish Badarkhe <badarkhe.manish@gmail.com>
---
:100644 100644 a1d74dd... 0c0ba92... M	drivers/video/da8xx-fb.c
 drivers/video/da8xx-fb.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index a1d74dd..0c0ba92 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -1546,7 +1546,7 @@ err_pm_runtime_disable:
 	return ret;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static struct lcdc_context {
 	u32 clk_enable;
 	u32 ctrl;
@@ -1610,9 +1610,9 @@ static void lcd_context_restore(void)
 	return;
 }
 
-static int fb_suspend(struct platform_device *dev, pm_message_t state)
+static int fb_suspend(struct device *dev)
 {
-	struct fb_info *info = platform_get_drvdata(dev);
+	struct fb_info *info = dev_get_drvdata(dev);
 	struct da8xx_fb_par *par = info->par;
 
 	console_lock();
@@ -1622,18 +1622,18 @@ static int fb_suspend(struct platform_device *dev, pm_message_t state)
 	fb_set_suspend(info, 1);
 	lcd_disable_raster(DA8XX_FRAME_WAIT);
 	lcd_context_save();
-	pm_runtime_put_sync(&dev->dev);
+	pm_runtime_put_sync(dev);
 	console_unlock();
 
 	return 0;
 }
-static int fb_resume(struct platform_device *dev)
+static int fb_resume(struct device *dev)
 {
-	struct fb_info *info = platform_get_drvdata(dev);
+	struct fb_info *info = dev_get_drvdata(dev);
 	struct da8xx_fb_par *par = info->par;
 
 	console_lock();
-	pm_runtime_get_sync(&dev->dev);
+	pm_runtime_get_sync(dev);
 	lcd_context_restore();
 	if (par->blank == FB_BLANK_UNBLANK) {
 		lcd_enable_raster();
@@ -1647,19 +1647,17 @@ static int fb_resume(struct platform_device *dev)
 
 	return 0;
 }
-#else
-#define fb_suspend NULL
-#define fb_resume NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(fb_pm_ops, fb_suspend, fb_resume);
+
 static struct platform_driver da8xx_fb_driver = {
 	.probe = fb_probe,
 	.remove = fb_remove,
-	.suspend = fb_suspend,
-	.resume = fb_resume,
 	.driver = {
 		   .name = DRIVER_NAME,
 		   .owner = THIS_MODULE,
+		   .pm	= &fb_pm_ops,
 		   },
 };
 module_platform_driver(da8xx_fb_driver);
-- 
1.7.10.4

