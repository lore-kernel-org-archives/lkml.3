Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab3JBO7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:59:00 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:59344 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab3JBO6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:58:55 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Tom Gundersen <teg@jklm.no>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        dri-devel@lists.freedesktop.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH 1/2] simplefb: fix unmapping fb during destruction
Date: Wed,  2 Oct 2013 16:58:38 +0200
Message-Id: <1380725919-1961-1-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unfortunately, fbdev does not create its own "struct device" for
framebuffers. Instead, it attaches to the device of the parent layer. This
has the side-effect that devm_* managed resources are not cleaned up on
framebuffer-destruction but rather during destruction of the
parent-device. In case of fbdev this might be too late, though.
remove_conflicting_framebuffer() may remove fbdev devices but keep the
parent device as it is.

Therefore, we now use plain ioremap() and unmap the framebuffer in the
fb_destroy() callback. Note that we must not free the device here as this
might race with the parent-device removal. Instead, we rely on
unregister_framebuffer() as barrier and we're safe.

Reported-by: Tom Gundersen <teg@jklm.no>
Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
Hi

I know that simplefb was supposed to stay "as simple as possible" but I really
think this series is the last set of fixes I have. Unfortunately framebuffer DRM
handover is mandatory so we cannot ignore it in simplefb.

Both patches are not critical at all and are targeted at 3.13-rc1.

Thanks
David

 drivers/video/simplefb.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/video/simplefb.c b/drivers/video/simplefb.c
index 8d78106..74b016c 100644
--- a/drivers/video/simplefb.c
+++ b/drivers/video/simplefb.c
@@ -66,8 +66,15 @@ static int simplefb_setcolreg(u_int regno, u_int red, u_int green, u_int blue,
 	return 0;
 }
 
+static void simplefb_destroy(struct fb_info *info)
+{
+	if (info->screen_base)
+		iounmap(info->screen_base);
+}
+
 static struct fb_ops simplefb_ops = {
 	.owner		= THIS_MODULE,
+	.fb_destroy	= simplefb_destroy,
 	.fb_setcolreg	= simplefb_setcolreg,
 	.fb_fillrect	= cfb_fillrect,
 	.fb_copyarea	= cfb_copyarea,
@@ -212,8 +219,8 @@ static int simplefb_probe(struct platform_device *pdev)
 
 	info->fbops = &simplefb_ops;
 	info->flags = FBINFO_DEFAULT | FBINFO_MISC_FIRMWARE;
-	info->screen_base = devm_ioremap(&pdev->dev, info->fix.smem_start,
-					 info->fix.smem_len);
+	info->screen_base = ioremap(info->fix.smem_start,
+				    info->fix.smem_len);
 	if (!info->screen_base) {
 		framebuffer_release(info);
 		return -ENODEV;
@@ -223,6 +230,7 @@ static int simplefb_probe(struct platform_device *pdev)
 	ret = register_framebuffer(info);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Unable to register simplefb: %d\n", ret);
+		iounmap(info->screen_base);
 		framebuffer_release(info);
 		return ret;
 	}
-- 
1.8.4

