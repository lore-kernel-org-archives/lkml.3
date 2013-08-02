Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab3HBXlC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 19:41:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54540 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772Ab3HBXk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 19:40:59 -0400
Date: Fri, 2 Aug 2013 16:40:49 -0700
From: tip-bot for David Herrmann <tipbot@zytor.com>
Message-ID: <tip-e6816a8d85549444feb3838920b1f4efba73d1da@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, dh.herrmann@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, dh.herrmann@gmail.com, hpa@linux.intel.com
In-Reply-To: <1375445127-15480-8-git-send-email-dh.herrmann@gmail.com>
References: <1375445127-15480-8-git-send-email-dh.herrmann@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fb] fbdev: efifb: bind to efi-framebuffer
Git-Commit-ID: e6816a8d85549444feb3838920b1f4efba73d1da
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 02 Aug 2013 16:40:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e6816a8d85549444feb3838920b1f4efba73d1da
Gitweb:     http://git.kernel.org/tip/e6816a8d85549444feb3838920b1f4efba73d1da
Author:     David Herrmann <dh.herrmann@gmail.com>
AuthorDate: Fri, 2 Aug 2013 14:05:26 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 2 Aug 2013 16:17:50 -0700

fbdev: efifb: bind to efi-framebuffer

Instead of creating a dummy device, we now bind to the efi-fb device
which is provided by x86 initialization code.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
Link: http://lkml.kernel.org/r/1375445127-15480-8-git-send-email-dh.herrmann@gmail.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
