Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885Ab3BQSBd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 13:01:33 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:54389 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab3BQR76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 12:59:58 -0500
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH 5/9] video: vesafb: use sysfb bus
Date: Sun, 17 Feb 2013 18:59:07 +0100
Message-Id: <1361123951-587-6-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1361123951-587-1-git-send-email-dh.herrmann@gmail.com>
References: <1361123951-587-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using our own platform device, we now register as sysfb driver
and get notified whenever we are loaded on a system VBE device. This
allows other VBE drivers to be loaded at the same time and users can
bind/unbind drivers via sysfs. We also no longer need to fake a
platform-device because the sysfb bus provides all devices now.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 drivers/video/Kconfig  |  1 +
 drivers/video/vesafb.c | 49 +++++++++++++++----------------------------------
 2 files changed, 16 insertions(+), 34 deletions(-)

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index d5723c2..5c23d32 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -776,6 +776,7 @@ config FB_VESA
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
 	select FB_BOOT_VESA_SUPPORT
+	select SYSFB
 	help
 	  This is the frame buffer device driver for generic VESA 2.0
 	  compliant graphic cards. The older VESA 1.2 cards are not supported.
diff --git a/drivers/video/vesafb.c b/drivers/video/vesafb.c
index 4ad7b40..652858f 100644
--- a/drivers/video/vesafb.c
+++ b/drivers/video/vesafb.c
@@ -19,6 +19,7 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/screen_info.h>
+#include <linux/sysfb.h>
 
 #include <video/vga.h>
 #include <asm/io.h>
@@ -214,7 +215,7 @@ static int vesafb_setup(char *options)
 	return 0;
 }
 
-static int vesafb_probe(struct platform_device *dev)
+static int vesafb_probe(struct sysfb_device *dev)
 {
 	struct fb_info *info;
 	struct vesafb_par *par;
@@ -491,7 +492,7 @@ static int vesafb_probe(struct platform_device *dev)
 	}
 	printk(KERN_INFO "fb%d: %s frame buffer device\n",
 	       info->node, info->fix.id);
-	platform_set_drvdata(dev, info);
+	dev_set_drvdata(&dev->dev, info);
 	return 0;
 err:
 	if (info->screen_base)
@@ -501,59 +502,39 @@ err:
 	return err;
 }
 
-static int vesafb_remove(struct platform_device *dev)
+static void vesafb_remove(struct sysfb_device *dev)
 {
-	struct fb_info *info = platform_get_drvdata(dev);
+	struct fb_info *info = dev_get_drvdata(&dev->dev);
 
 	unregister_framebuffer(info);
-	return 0;
 }
 
-static struct platform_driver vesafb_driver = {
+static struct sysfb_driver vesafb_driver = {
+	.type_mask = SYSFB_VBE,
+	.allow_tainted = false,
+	.driver = {
+		.name = "vesafb",
+		.owner = THIS_MODULE,
+		.mod_name = KBUILD_MODNAME,
+	},
 	.probe = vesafb_probe,
 	.remove = vesafb_remove,
-	.driver	= {
-		.name	= "vesafb",
-	},
 };
 
-static struct platform_device *vesafb_device;
-
 static int __init vesafb_init(void)
 {
-	int ret;
 	char *option = NULL;
 
 	/* ignore error return of fb_get_options */
 	fb_get_options("vesafb", &option);
 	vesafb_setup(option);
 
-	vesafb_device = platform_device_alloc("vesafb", -1);
-	if (!vesafb_device)
-		return -ENOMEM;
-
-	ret = platform_driver_register(&vesafb_driver);
-	if (ret)
-		goto err_dev;
-
-	ret = platform_device_add(vesafb_device);
-	if (ret)
-		goto err_drv;
-
-	return 0;
-
-err_drv:
-	platform_driver_unregister(&vesafb_driver);
-err_dev:
-	platform_device_put(vesafb_device);
-	return ret;
+	return sysfb_register_driver(&vesafb_driver);
 }
 
 static void __exit vesafb_exit(void)
 {
-	platform_device_del(vesafb_device);
-	platform_device_put(vesafb_device);
-	platform_driver_unregister(&vesafb_driver);
+	sysfb_unregister_driver(&vesafb_driver);
 }
 
 module_init(vesafb_init);
-- 
1.8.1.3

