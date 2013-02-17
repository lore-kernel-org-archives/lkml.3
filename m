Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837Ab3BQSAA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 13:00:00 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:62794 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab3BQR75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 12:59:57 -0500
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org,
        David Herrmann <dh.herrmann@googlemail.com>
Subject: [PATCH 4/9] video: vesafb: allow building as module
Date: Sun, 17 Feb 2013 18:59:06 +0100
Message-Id: <1361123951-587-5-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1361123951-587-1-git-send-email-dh.herrmann@gmail.com>
References: <1361123951-587-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Herrmann <dh.herrmann@googlemail.com>

Fix the vesafb module to no longer use any static __init data. Also add a
module_exit() function that destroys the platform device.

Note that fbdev hotplugging is broken and the self-reference actually
prevents sane module-unloading. Anyway, this at least allows delayed
module loading of vesafb and helps debugging vesafb a lot.

Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
---
 drivers/video/Kconfig  |   2 +-
 drivers/video/vesafb.c | 100 +++++++++++++++++++++++++++++++------------------
 2 files changed, 64 insertions(+), 38 deletions(-)

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index eac56ef..d5723c2 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -770,7 +770,7 @@ config FB_UVESA
 	  If unsure, say N.
 
 config FB_VESA
-	bool "VESA VGA graphics support"
+	tristate "VESA VGA graphics support"
 	depends on (FB = y) && X86
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
diff --git a/drivers/video/vesafb.c b/drivers/video/vesafb.c
index 501b340..4ad7b40 100644
--- a/drivers/video/vesafb.c
+++ b/drivers/video/vesafb.c
@@ -29,27 +29,10 @@
 
 /* --------------------------------------------------------------------- */
 
-static struct fb_var_screeninfo vesafb_defined __initdata = {
-	.activate	= FB_ACTIVATE_NOW,
-	.height		= -1,
-	.width		= -1,
-	.right_margin	= 32,
-	.upper_margin	= 16,
-	.lower_margin	= 4,
-	.vsync_len	= 4,
-	.vmode		= FB_VMODE_NONINTERLACED,
-};
-
-static struct fb_fix_screeninfo vesafb_fix __initdata = {
-	.id	= "VESA VGA",
-	.type	= FB_TYPE_PACKED_PIXELS,
-	.accel	= FB_ACCEL_NONE,
-};
-
 static int   inverse    __read_mostly;
 static int   mtrr       __read_mostly;		/* disable mtrr */
-static int   vram_remap __initdata;		/* Set amount of memory to be used */
-static int   vram_total __initdata;		/* Set total amount of memory */
+static int   vram_remap;			/* Set amount of memory to be used */
+static int   vram_total;			/* Set total amount of memory */
 static int   pmi_setpal __read_mostly = 1;	/* pmi for palette changes ??? */
 static int   ypan       __read_mostly;		/* 0..nothing, 1..ypan, 2..ywrap */
 static void  (*pmi_start)(void) __read_mostly;
@@ -58,6 +41,11 @@ static int   depth      __read_mostly;
 static int   vga_compat __read_mostly;
 /* --------------------------------------------------------------------- */
 
+struct vesafb_par {
+	struct fb_ops ops;
+	u32 palette[256];
+};
+
 static int vesafb_pan_display(struct fb_var_screeninfo *var,
                               struct fb_info *info)
 {
@@ -182,7 +170,7 @@ static void vesafb_destroy(struct fb_info *info)
 	framebuffer_release(info);
 }
 
-static struct fb_ops vesafb_ops = {
+static const struct fb_ops vesafb_ops = {
 	.owner		= THIS_MODULE,
 	.fb_destroy     = vesafb_destroy,
 	.fb_setcolreg	= vesafb_setcolreg,
@@ -192,7 +180,7 @@ static struct fb_ops vesafb_ops = {
 	.fb_imageblit	= cfb_imageblit,
 };
 
-static int __init vesafb_setup(char *options)
+static int vesafb_setup(char *options)
 {
 	char *this_opt;
 	
@@ -226,13 +214,29 @@ static int __init vesafb_setup(char *options)
 	return 0;
 }
 
-static int __init vesafb_probe(struct platform_device *dev)
+static int vesafb_probe(struct platform_device *dev)
 {
 	struct fb_info *info;
+	struct vesafb_par *par;
 	int i, err;
 	unsigned int size_vmode;
 	unsigned int size_remap;
 	unsigned int size_total;
+	struct fb_var_screeninfo vesafb_defined = {
+		.activate	= FB_ACTIVATE_NOW,
+		.height		= -1,
+		.width		= -1,
+		.right_margin	= 32,
+		.upper_margin	= 16,
+		.lower_margin	= 4,
+		.vsync_len	= 4,
+		.vmode		= FB_VMODE_NONINTERLACED,
+	};
+	struct fb_fix_screeninfo vesafb_fix = {
+		.id	= "VESA VGA",
+		.type	= FB_TYPE_PACKED_PIXELS,
+		.accel	= FB_ACCEL_NONE,
+	};
 
 	if (screen_info.orig_video_isVGA != VIDEO_TYPE_VLFB)
 		return -ENODEV;
@@ -287,13 +291,14 @@ static int __init vesafb_probe(struct platform_device *dev)
 		   spaces our resource handlers simply don't know about */
 	}
 
-	info = framebuffer_alloc(sizeof(u32) * 256, &dev->dev);
+	info = framebuffer_alloc(sizeof(struct vesafb_par), &dev->dev);
 	if (!info) {
 		release_mem_region(vesafb_fix.smem_start, size_total);
 		return -ENOMEM;
 	}
-	info->pseudo_palette = info->par;
-	info->par = NULL;
+	par = info->par;
+	par->ops = vesafb_ops;
+	info->pseudo_palette = par->palette;
 
 	/* set vesafb aperture size for generic probing */
 	info->apertures = alloc_apertures(1);
@@ -466,7 +471,7 @@ static int __init vesafb_probe(struct platform_device *dev)
 	       vesafb_fix.smem_start, info->screen_base,
 	       size_remap/1024, size_total/1024);
 
-	info->fbops = &vesafb_ops;
+	info->fbops = &par->ops;
 	info->var = vesafb_defined;
 	info->fix = vesafb_fix;
 	info->flags = FBINFO_FLAG_DEFAULT | FBINFO_MISC_FIRMWARE |
@@ -486,6 +491,7 @@ static int __init vesafb_probe(struct platform_device *dev)
 	}
 	printk(KERN_INFO "fb%d: %s frame buffer device\n",
 	       info->node, info->fix.id);
+	platform_set_drvdata(dev, info);
 	return 0;
 err:
 	if (info->screen_base)
@@ -495,7 +501,17 @@ err:
 	return err;
 }
 
+static int vesafb_remove(struct platform_device *dev)
+{
+	struct fb_info *info = platform_get_drvdata(dev);
+
+	unregister_framebuffer(info);
+	return 0;
+}
+
 static struct platform_driver vesafb_driver = {
+	.probe = vesafb_probe,
+	.remove = vesafb_remove,
 	.driver	= {
 		.name	= "vesafb",
 	},
@@ -512,24 +528,34 @@ static int __init vesafb_init(void)
 	fb_get_options("vesafb", &option);
 	vesafb_setup(option);
 
-	vesafb_device = platform_device_alloc("vesafb", 0);
+	vesafb_device = platform_device_alloc("vesafb", -1);
 	if (!vesafb_device)
 		return -ENOMEM;
 
+	ret = platform_driver_register(&vesafb_driver);
+	if (ret)
+		goto err_dev;
+
 	ret = platform_device_add(vesafb_device);
-	if (!ret) {
-		ret = platform_driver_probe(&vesafb_driver, vesafb_probe);
-		if (ret)
-			platform_device_del(vesafb_device);
-	}
+	if (ret)
+		goto err_drv;
 
-	if (ret) {
-		platform_device_put(vesafb_device);
-		vesafb_device = NULL;
-	}
+	return 0;
 
+err_drv:
+	platform_driver_unregister(&vesafb_driver);
+err_dev:
+	platform_device_put(vesafb_device);
 	return ret;
 }
-module_init(vesafb_init);
 
+static void __exit vesafb_exit(void)
+{
+	platform_device_del(vesafb_device);
+	platform_device_put(vesafb_device);
+	platform_driver_unregister(&vesafb_driver);
+}
+
+module_init(vesafb_init);
+module_exit(vesafb_exit);
 MODULE_LICENSE("GPL");
-- 
1.8.1.3

