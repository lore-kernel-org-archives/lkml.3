Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436AbaFKUSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 16:18:17 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:54325 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbaFKUSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 16:18:15 -0400
From: Franck Jullien <franck.jullien@gmail.com>
To: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org
Cc: tomi.valkeinen@ti.com, plagnioj@jcrosoft.com,
        stefan.kristiansson@saunalahti.fi,
        Franck Jullien <franck.jullien@gmail.com>
Subject: [PATCH] video: OF display-timings support for ocfb
Date: Wed, 11 Jun 2014 22:17:51 +0200
Message-Id: <1402517871-27503-1-git-send-email-franck.jullien@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Franck Jullien <franck.jullien@gmail.com>
---
 drivers/video/fbdev/Kconfig |    2 ++
 drivers/video/fbdev/ocfb.c  |   31 ++++++++++++++++++++++++++-----
 2 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig
index e1f4727..b4ac6bb 100644
--- a/drivers/video/fbdev/Kconfig
+++ b/drivers/video/fbdev/Kconfig
@@ -942,6 +942,8 @@ config FB_OPENCORES
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
+	select VIDEOMODE_HELPERS
+	select FB_MODE_HELPERS
 	help
 	  This enables support for the OpenCores VGA/LCD core.
 
diff --git a/drivers/video/fbdev/ocfb.c b/drivers/video/fbdev/ocfb.c
index 7f9dc9b..6d15565 100644
--- a/drivers/video/fbdev/ocfb.c
+++ b/drivers/video/fbdev/ocfb.c
@@ -22,6 +22,8 @@
 #include <linux/string.h>
 #include <linux/slab.h>
 
+#include <video/of_display_timing.h>
+
 /* OCFB register defines */
 #define OCFB_CTRL	0x000
 #define OCFB_STAT	0x004
@@ -310,11 +312,30 @@ static int ocfb_probe(struct platform_device *pdev)
 	fbdev->info.device = &pdev->dev;
 	fbdev->info.par = fbdev;
 
-	/* Video mode setup */
-	if (!fb_find_mode(&fbdev->info.var, &fbdev->info, mode_option,
-			  NULL, 0, &default_mode, 16)) {
-		dev_err(&pdev->dev, "No valid video modes found\n");
-		return -EINVAL;
+	if (!mode_option && IS_ENABLED(CONFIG_OF)) {
+		struct fb_videomode mode;
+		u32 bpp;
+
+		ret = of_get_fb_videomode(pdev->dev.of_node, &mode,
+					  OF_USE_NATIVE_MODE);
+		if (ret)
+			return ret;
+
+		fb_videomode_to_var(&fbdev->info.var, &mode);
+
+		ret = of_property_read_u32(pdev->dev.of_node, "bits-per-pixel",
+					   &bpp);
+		if (ret)
+			return ret;
+
+		fbdev->info.var.bits_per_pixel = bpp;
+
+	} else {
+		if (!fb_find_mode(&fbdev->info.var, &fbdev->info, mode_option,
+				  NULL, 0, &default_mode, 16)) {
+			dev_err(&pdev->dev, "No valid video modes found\n");
+			return -EINVAL;
+		}
 	}
 	ocfb_init_var(fbdev);
 	ocfb_init_fix(fbdev);
-- 
1.7.1

