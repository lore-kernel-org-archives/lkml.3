Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab3HBXkx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 19:40:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54533 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220Ab3HBXku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 19:40:50 -0400
Date: Fri, 2 Aug 2013 16:40:39 -0700
From: tip-bot for David Herrmann <tipbot@zytor.com>
Message-ID: <tip-2e5155ecbb729d3a2e7d1cea7c18493516fec55a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, dh.herrmann@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, dh.herrmann@gmail.com, hpa@linux.intel.com
In-Reply-To: <1375445127-15480-7-git-send-email-dh.herrmann@gmail.com>
References: <1375445127-15480-7-git-send-email-dh.herrmann@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fb] fbdev: vesafb: bind to platform-framebuffer device
Git-Commit-ID: 2e5155ecbb729d3a2e7d1cea7c18493516fec55a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 02 Aug 2013 16:40:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2e5155ecbb729d3a2e7d1cea7c18493516fec55a
Gitweb:     http://git.kernel.org/tip/2e5155ecbb729d3a2e7d1cea7c18493516fec55a
Author:     David Herrmann <dh.herrmann@gmail.com>
AuthorDate: Fri, 2 Aug 2013 14:05:25 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 2 Aug 2013 16:17:49 -0700

fbdev: vesafb: bind to platform-framebuffer device

x86 creates platform-framebuffer platform devices for every system
framebuffer. Use these instead of creating a dummy device.

This requires us to remove the __init annotations as hotplugging may occur
during runtime.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
Link: http://lkml.kernel.org/r/1375445127-15480-7-git-send-email-dh.herrmann@gmail.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
