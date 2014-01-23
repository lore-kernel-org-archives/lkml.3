Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333AbaAWOSg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 09:18:36 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40438 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066AbaAWOPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 09:15:54 -0500
From: David Herrmann <dh.herrmann@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: Ingo Molnar <mingo@kernel.org>, linux-fbdev@vger.kernel.org,
        Dave Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-kernel@vger.kernel.org,
        Tom Gundersen <teg@jklm.no>, David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH 04/11] fbdev: vesafb: add dev->remove() callback
Date: Thu, 23 Jan 2014 15:14:56 +0100
Message-Id: <1390486503-1504-5-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390486503-1504-1-git-send-email-dh.herrmann@gmail.com>
References: <1390486503-1504-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If x86-sysfb platform-devices are removed from a system, we should
properly unload vesafb. Otherwise, we end up releasing the parent while
our vesa framebuffer is still running. This currently works just fine, but
will cause problems on handover to real hw. So add the ->remove() callback
and unregister vesafb.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 drivers/video/vesafb.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/video/vesafb.c b/drivers/video/vesafb.c
index 1c7da3b..6170e7f 100644
--- a/drivers/video/vesafb.c
+++ b/drivers/video/vesafb.c
@@ -179,7 +179,6 @@ static void vesafb_destroy(struct fb_info *info)
 	if (info->screen_base)
 		iounmap(info->screen_base);
 	release_mem_region(info->apertures->ranges[0].base, info->apertures->ranges[0].size);
-	framebuffer_release(info);
 }
 
 static struct fb_ops vesafb_ops = {
@@ -297,6 +296,7 @@ static int vesafb_probe(struct platform_device *dev)
 		release_mem_region(vesafb_fix.smem_start, size_total);
 		return -ENOMEM;
 	}
+	platform_set_drvdata(dev, info);
 	info->pseudo_palette = info->par;
 	info->par = NULL;
 
@@ -499,12 +499,23 @@ err:
 	return err;
 }
 
+static int vesafb_remove(struct platform_device *pdev)
+{
+	struct fb_info *info = platform_get_drvdata(pdev);
+
+	unregister_framebuffer(info);
+	framebuffer_release(info);
+
+	return 0;
+}
+
 static struct platform_driver vesafb_driver = {
 	.driver = {
 		.name = "vesa-framebuffer",
 		.owner = THIS_MODULE,
 	},
 	.probe = vesafb_probe,
+	.remove = vesafb_remove,
 };
 
 module_platform_driver(vesafb_driver);
-- 
1.8.5.3

