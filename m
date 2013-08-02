Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab3HBMGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 08:06:43 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:36207 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab3HBMGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 08:06:37 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Geert Uytterhoeven <geert@linux-m68k.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Peter Jones <pjones@redhat.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-fbdev@vger.kernel.org, akpm@linux-foundation.org,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH RESEND 6/8] fbdev: vesafb: bind to platform-framebuffer device
Date: Fri,  2 Aug 2013 14:05:25 +0200
Message-Id: <1375445127-15480-7-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1375445127-15480-1-git-send-email-dh.herrmann@gmail.com>
References: <1375445127-15480-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86 creates platform-framebuffer platform devices for every system
framebuffer. Use these instead of creating a dummy device.

This requires us to remove the __init annotations as hotplugging may occur
during runtime.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 drivers/video/vesafb.c | 55 +++++++++++++++-----------------------------------
 1 file changed, 16 insertions(+), 39 deletions(-)

diff --git a/drivers/video/vesafb.c b/drivers/video/vesafb.c
index 501b340..bd83233 100644
--- a/drivers/video/vesafb.c
+++ b/drivers/video/vesafb.c
@@ -29,7 +29,7 @@
 
 /* --------------------------------------------------------------------- */
 
-static struct fb_var_screeninfo vesafb_defined __initdata = {
+static struct fb_var_screeninfo vesafb_defined = {
 	.activate	= FB_ACTIVATE_NOW,
 	.height		= -1,
 	.width		= -1,
@@ -40,7 +40,7 @@ static struct fb_var_screeninfo vesafb_defined __initdata = {
 	.vmode		= FB_VMODE_NONINTERLACED,
 };
 
-static struct fb_fix_screeninfo vesafb_fix __initdata = {
+static struct fb_fix_screeninfo vesafb_fix = {
 	.id	= "VESA VGA",
 	.type	= FB_TYPE_PACKED_PIXELS,
 	.accel	= FB_ACCEL_NONE,
@@ -48,8 +48,8 @@ static struct fb_fix_screeninfo vesafb_fix __initdata = {
 
 static int   inverse    __read_mostly;
 static int   mtrr       __read_mostly;		/* disable mtrr */
-static int   vram_remap __initdata;		/* Set amount of memory to be used */
-static int   vram_total __initdata;		/* Set total amount of memory */
+static int   vram_remap;			/* Set amount of memory to be used */
+static int   vram_total;			/* Set total amount of memory */
 static int   pmi_setpal __read_mostly = 1;	/* pmi for palette changes ??? */
 static int   ypan       __read_mostly;		/* 0..nothing, 1..ypan, 2..ywrap */
 static void  (*pmi_start)(void) __read_mostly;
@@ -192,7 +192,7 @@ static struct fb_ops vesafb_ops = {
 	.fb_imageblit	= cfb_imageblit,
 };
 
-static int __init vesafb_setup(char *options)
+static int vesafb_setup(char *options)
 {
 	char *this_opt;
 	
@@ -226,13 +226,18 @@ static int __init vesafb_setup(char *options)
 	return 0;
 }
 
-static int __init vesafb_probe(struct platform_device *dev)
+static int vesafb_probe(struct platform_device *dev)
 {
 	struct fb_info *info;
 	int i, err;
 	unsigned int size_vmode;
 	unsigned int size_remap;
 	unsigned int size_total;
+	char *option = NULL;
+
+	/* ignore error return of fb_get_options */
+	fb_get_options("vesafb", &option);
+	vesafb_setup(option);
 
 	if (screen_info.orig_video_isVGA != VIDEO_TYPE_VLFB)
 		return -ENODEV;
@@ -496,40 +501,12 @@ err:
 }
 
 static struct platform_driver vesafb_driver = {
-	.driver	= {
-		.name	= "vesafb",
+	.driver = {
+		.name = "vesa-framebuffer",
+		.owner = THIS_MODULE,
 	},
+	.probe = vesafb_probe,
 };
 
-static struct platform_device *vesafb_device;
-
-static int __init vesafb_init(void)
-{
-	int ret;
-	char *option = NULL;
-
-	/* ignore error return of fb_get_options */
-	fb_get_options("vesafb", &option);
-	vesafb_setup(option);
-
-	vesafb_device = platform_device_alloc("vesafb", 0);
-	if (!vesafb_device)
-		return -ENOMEM;
-
-	ret = platform_device_add(vesafb_device);
-	if (!ret) {
-		ret = platform_driver_probe(&vesafb_driver, vesafb_probe);
-		if (ret)
-			platform_device_del(vesafb_device);
-	}
-
-	if (ret) {
-		platform_device_put(vesafb_device);
-		vesafb_device = NULL;
-	}
-
-	return ret;
-}
-module_init(vesafb_init);
-
+module_platform_driver(vesafb_driver);
 MODULE_LICENSE("GPL");
-- 
1.8.3.4

