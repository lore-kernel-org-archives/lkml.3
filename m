Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496Ab3GDM1E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 08:27:04 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:62227 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347Ab3GDM0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 08:26:34 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        David Herrmann <dh.herrmann@gmail.com>,
        Peter Jones <pjones@redhat.com>
Subject: [PATCH v2 07/14] fbdev: efifb: bind to efi-framebuffer
Date: Thu,  4 Jul 2013 14:25:07 +0200
Message-Id: <1372940714-12470-8-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1372940714-12470-1-git-send-email-dh.herrmann@gmail.com>
References: <1372940714-12470-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of creating a dummy device, we now bind to the efi-fb device
which is provided by x86 initialization code.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 drivers/video/efifb.c | 68 +++++++++++++++++----------------------------------
 1 file changed, 22 insertions(+), 46 deletions(-)

diff --git a/drivers/video/efifb.c b/drivers/video/efifb.c
index e493bcb..2a8286e 100644
--- a/drivers/video/efifb.c
+++ b/drivers/video/efifb.c
@@ -96,7 +96,7 @@ void vga_set_default_device(struct pci_dev *pdev)
 	default_vga = pdev;
 }
 
-static int __init efifb_setup(char *options)
+static int efifb_setup(char *options)
 {
 	char *this_opt;
 	int i;
@@ -153,13 +153,28 @@ static int __init efifb_setup(char *options)
 	return 0;
 }
 
-static int __init efifb_probe(struct platform_device *dev)
+static int efifb_probe(struct platform_device *dev)
 {
 	struct fb_info *info;
 	int err;
 	unsigned int size_vmode;
 	unsigned int size_remap;
 	unsigned int size_total;
+	char *option = NULL;
+
+	if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI)
+		return -ENODEV;
+
+	if (fb_get_options("efifb", &option))
+		return -ENODEV;
+	efifb_setup(option);
+
+	/* We don't get linelength from UGA Draw Protocol, only from
+	 * EFI Graphics Protocol.  So if it's not in DMI, and it's not
+	 * passed in from the user, we really can't use the framebuffer.
+	 */
+	if (!screen_info.lfb_linelength)
+		return -ENODEV;
 
 	if (!screen_info.lfb_depth)
 		screen_info.lfb_depth = 32;
@@ -323,51 +338,12 @@ err_release_mem:
 }
 
 static struct platform_driver efifb_driver = {
-	.driver	= {
-		.name	= "efifb",
+	.driver = {
+		.name = "efi-framebuffer",
+		.owner = THIS_MODULE,
 	},
+	.probe = efifb_probe,
 };
 
-static struct platform_device efifb_device = {
-	.name	= "efifb",
-};
-
-static int __init efifb_init(void)
-{
-	int ret;
-	char *option = NULL;
-
-	if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI)
-		return -ENODEV;
-
-	if (fb_get_options("efifb", &option))
-		return -ENODEV;
-	efifb_setup(option);
-
-	/* We don't get linelength from UGA Draw Protocol, only from
-	 * EFI Graphics Protocol.  So if it's not in DMI, and it's not
-	 * passed in from the user, we really can't use the framebuffer.
-	 */
-	if (!screen_info.lfb_linelength)
-		return -ENODEV;
-
-	ret = platform_device_register(&efifb_device);
-	if (ret)
-		return ret;
-
-	/*
-	 * This is not just an optimization.  We will interfere
-	 * with a real driver if we get reprobed, so don't allow
-	 * it.
-	 */
-	ret = platform_driver_probe(&efifb_driver, efifb_probe);
-	if (ret) {
-		platform_device_unregister(&efifb_device);
-		return ret;
-	}
-
-	return ret;
-}
-module_init(efifb_init);
-
+module_platform_driver(efifb_driver);
 MODULE_LICENSE("GPL");
-- 
1.8.3.2

