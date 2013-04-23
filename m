Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727Ab3DWPXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 11:23:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755620Ab3DWPX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 11:23:29 -0400
From: Peter Jones <pjones@redhat.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Josh Boyer <jwboyer@redhat.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Jones <pjones@redhat.com>
Subject: [PATCH] Handle efifb with no lfb_base better.
Date: Tue, 23 Apr 2013 11:23:18 -0400
Message-Id: <1366730598-13942-1-git-send-email-pjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now we get a WARN from platform_device_unregister() because our
platform_device has no ->release function.  This is clearly wrong, but
we should be warning so we can figure out what happened, as this failure
results in bug reports.  So WARN() about the real problem, and use the
registration function that gives us a default release() function.

This fixes the tracback reported at
https://bugzilla.redhat.com/show_bug.cgi?id=840621 , though it does not
fix the actual /problem/ the user is seeing.

Signed-off-by: Peter Jones <pjones@redhat.com>
---
 drivers/video/efifb.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/video/efifb.c b/drivers/video/efifb.c
index 50fe668..390b61b 100644
--- a/drivers/video/efifb.c
+++ b/drivers/video/efifb.c
@@ -285,6 +285,7 @@ static void efifb_destroy(struct fb_info *info)
 {
 	if (info->screen_base)
 		iounmap(info->screen_base);
+	fb_dealloc_cmap(&info->cmap);
 	if (request_mem_succeeded)
 		release_mem_region(info->apertures->ranges[0].base,
 				   info->apertures->ranges[0].size);
@@ -382,6 +383,8 @@ static int __init efifb_probe(struct platform_device *dev)
 	if (!screen_info.pages)
 		screen_info.pages = 1;
 	if (!screen_info.lfb_base) {
+		WARN(1, KERN_WARNING, "invalid framebuffer address for "
+				      "device '%s'\n", dev_name(dev));
 		printk(KERN_DEBUG "efifb: invalid framebuffer address\n");
 		return -ENODEV;
 	}
@@ -544,9 +547,7 @@ static struct platform_driver efifb_driver = {
 	},
 };
 
-static struct platform_device efifb_device = {
-	.name	= "efifb",
-};
+static struct platform_device *efifb_device;
 
 static int __init efifb_init(void)
 {
@@ -571,9 +572,9 @@ static int __init efifb_init(void)
 	if (!screen_info.lfb_linelength)
 		return -ENODEV;
 
-	ret = platform_device_register(&efifb_device);
-	if (ret)
-		return ret;
+	efifb_device = platform_device_register_simple("efifb", 0, NULL, 0);
+	if (IS_ERROR(efifb_device))
+		return PTR_ERR(efifb_device);
 
 	/*
 	 * This is not just an optimization.  We will interfere
@@ -582,7 +583,7 @@ static int __init efifb_init(void)
 	 */
 	ret = platform_driver_probe(&efifb_driver, efifb_probe);
 	if (ret) {
-		platform_device_unregister(&efifb_device);
+		platform_device_unregister(efifb_device);
 		return ret;
 	}
 
-- 
1.8.1.4

