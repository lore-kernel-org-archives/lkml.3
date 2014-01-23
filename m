Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155AbaAWOPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 09:15:55 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:55612 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbaAWOPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 09:15:52 -0500
From: David Herrmann <dh.herrmann@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: Ingo Molnar <mingo@kernel.org>, linux-fbdev@vger.kernel.org,
        Dave Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-kernel@vger.kernel.org,
        Tom Gundersen <teg@jklm.no>, David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH 03/11] fbdev: efifb: add dev->remove() callback
Date: Thu, 23 Jan 2014 15:14:55 +0100
Message-Id: <1390486503-1504-4-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390486503-1504-1-git-send-email-dh.herrmann@gmail.com>
References: <1390486503-1504-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If x86-sysfb platform-devices are removed from a system, we should
properly unload efifb. Otherwise, we end up releasing the parent while our
efi framebuffer is still running. This currently works just fine, but will
cause problems on handover to real hw. So add the ->remove() callback and
unregister efifb.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 drivers/video/efifb.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/video/efifb.c b/drivers/video/efifb.c
index cd7c0df..ae9618f 100644
--- a/drivers/video/efifb.c
+++ b/drivers/video/efifb.c
@@ -73,7 +73,6 @@ static void efifb_destroy(struct fb_info *info)
 		release_mem_region(info->apertures->ranges[0].base,
 				   info->apertures->ranges[0].size);
 	fb_dealloc_cmap(&info->cmap);
-	framebuffer_release(info);
 }
 
 static struct fb_ops efifb_ops = {
@@ -244,6 +243,7 @@ static int efifb_probe(struct platform_device *dev)
 		err = -ENOMEM;
 		goto err_release_mem;
 	}
+	platform_set_drvdata(dev, info);
 	info->pseudo_palette = info->par;
 	info->par = NULL;
 
@@ -337,12 +337,23 @@ err_release_mem:
 	return err;
 }
 
+static int efifb_remove(struct platform_device *pdev)
+{
+	struct fb_info *info = platform_get_drvdata(pdev);
+
+	unregister_framebuffer(info);
+	framebuffer_release(info);
+
+	return 0;
+}
+
 static struct platform_driver efifb_driver = {
 	.driver = {
 		.name = "efi-framebuffer",
 		.owner = THIS_MODULE,
 	},
 	.probe = efifb_probe,
+	.remove = efifb_remove,
 };
 
 module_platform_driver(efifb_driver);
-- 
1.8.5.3

