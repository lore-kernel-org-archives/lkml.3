Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282AbaAWOQo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 09:16:44 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:37210 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193AbaAWOQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 09:16:10 -0500
From: David Herrmann <dh.herrmann@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: Ingo Molnar <mingo@kernel.org>, linux-fbdev@vger.kernel.org,
        Dave Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-kernel@vger.kernel.org,
        Tom Gundersen <teg@jklm.no>, David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH 10/11] drm: simpledrm: add fbdev fallback support
Date: Thu, 23 Jan 2014 15:15:02 +0100
Message-Id: <1390486503-1504-11-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390486503-1504-1-git-send-email-dh.herrmann@gmail.com>
References: <1390486503-1504-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a simple fbdev device during SimpleDRM setup so legacy user-space
and fbcon can use it.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 drivers/gpu/drm/simpledrm/Kconfig           |  11 +++
 drivers/gpu/drm/simpledrm/Makefile          |   1 +
 drivers/gpu/drm/simpledrm/simpledrm.c       |  13 ++-
 drivers/gpu/drm/simpledrm/simpledrm.h       |  22 +++++
 drivers/gpu/drm/simpledrm/simpledrm_fbdev.c | 148 ++++++++++++++++++++++++++++
 5 files changed, 194 insertions(+), 1 deletion(-)
 create mode 100644 drivers/gpu/drm/simpledrm/simpledrm_fbdev.c

diff --git a/drivers/gpu/drm/simpledrm/Kconfig b/drivers/gpu/drm/simpledrm/Kconfig
index 35bcce8..eef2a36 100644
--- a/drivers/gpu/drm/simpledrm/Kconfig
+++ b/drivers/gpu/drm/simpledrm/Kconfig
@@ -12,7 +12,18 @@ config DRM_SIMPLEDRM
 	  SimpleDRM supports "simple-framebuffer" DeviceTree objects and
 	  compatible platform framebuffers.
 
+	  If fbdev support is enabled, this driver will also provide an fbdev
+	  compatibility layer.
+
 	  If unsure, say Y.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called simpledrm.
+
+config DRM_SIMPLEDRM_FBDEV
+	bool
+	depends on DRM_SIMPLEDRM && FB
+	default y
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
diff --git a/drivers/gpu/drm/simpledrm/Makefile b/drivers/gpu/drm/simpledrm/Makefile
index 35f73ea..363b17d 100644
--- a/drivers/gpu/drm/simpledrm/Makefile
+++ b/drivers/gpu/drm/simpledrm/Makefile
@@ -1,3 +1,4 @@
 sdrm-y := simpledrm.o simpledrm_kms.o simpledrm_gem.o simpledrm_damage.o
+sdrm-$(CONFIG_DRM_SIMPLEDRM_FBDEV) += simpledrm_fbdev.o
 
 obj-$(CONFIG_DRM_SIMPLEDRM) := sdrm.o
diff --git a/drivers/gpu/drm/simpledrm/simpledrm.c b/drivers/gpu/drm/simpledrm/simpledrm.c
index 98273f5..4346bcd 100644
--- a/drivers/gpu/drm/simpledrm/simpledrm.c
+++ b/drivers/gpu/drm/simpledrm/simpledrm.c
@@ -192,7 +192,17 @@ void sdrm_pdev_destroy(struct sdrm_device *sdrm)
 
 static int sdrm_simplefb_probe(struct platform_device *pdev)
 {
-	return drm_platform_init(&sdrm_drm_driver, pdev);
+	struct drm_device *ddev;
+	int r;
+
+	r = drm_platform_init(&sdrm_drm_driver, pdev);
+	if (r < 0)
+		return r;
+
+	ddev = platform_get_drvdata(pdev);
+	sdrm_fbdev_init(ddev->dev_private);
+
+	return 0;
 }
 
 static int sdrm_simplefb_remove(struct platform_device *pdev)
@@ -205,6 +215,7 @@ static int sdrm_simplefb_remove(struct platform_device *pdev)
 	 * CPU is currently doing some GEM-bo access in parallel to us. But, eh,
 	 * what can we do.. Fixes for that is being worked on. */
 
+	sdrm_fbdev_cleanup(sdrm);
 	drm_connector_unplug_all(ddev);
 
 	/* protect fb_map removal against sdrm_blit() */
diff --git a/drivers/gpu/drm/simpledrm/simpledrm.h b/drivers/gpu/drm/simpledrm/simpledrm.h
index 4ece7f5..7050594 100644
--- a/drivers/gpu/drm/simpledrm/simpledrm.h
+++ b/drivers/gpu/drm/simpledrm/simpledrm.h
@@ -45,6 +45,9 @@ struct sdrm_device {
 	struct drm_encoder enc;
 	struct drm_connector conn;
 	struct drm_display_mode *mode;
+
+	/* fbdev */
+	struct fb_info *fbdev;
 };
 
 int sdrm_drm_load(struct drm_device *ddev, unsigned long flags);
@@ -97,4 +100,23 @@ struct sdrm_framebuffer {
 
 #define to_sdrm_fb(x) container_of(x, struct sdrm_framebuffer, base)
 
+/* simpledrm fbdev helpers */
+
+#ifdef CONFIG_DRM_SIMPLEDRM_FBDEV
+
+void sdrm_fbdev_init(struct sdrm_device *sdrm);
+void sdrm_fbdev_cleanup(struct sdrm_device *sdrm);
+
+#else /* CONFIG_DRM_SIMPLEDRM_FBDEV */
+
+static inline void sdrm_fbdev_init(struct sdrm_device *sdrm)
+{
+}
+
+static inline void sdrm_fbdev_cleanup(struct sdrm_device *sdrm)
+{
+}
+
+#endif /* CONFIG_DRM_SIMPLEDRM_FBDEV */
+
 #endif /* SDRM_DRV_H */
diff --git a/drivers/gpu/drm/simpledrm/simpledrm_fbdev.c b/drivers/gpu/drm/simpledrm/simpledrm_fbdev.c
new file mode 100644
index 0000000..5df1482
--- /dev/null
+++ b/drivers/gpu/drm/simpledrm/simpledrm_fbdev.c
@@ -0,0 +1,148 @@
+/*
+ * SimpleDRM firmware framebuffer driver
+ * Copyright (c) 2012-2014 David Herrmann <dh.herrmann@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+/*
+ * fbdev compatibility layer
+ * We provide a basic fbdev device for the same framebuffer that is used for
+ * the pseudo CRTC.
+ */
+
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/fb.h>
+#include "simpledrm.h"
+
+struct sdrm_fbdev {
+	u32 palette[16];
+};
+
+static int sdrm_fbdev_setcolreg(u_int regno, u_int red, u_int green,
+				u_int blue, u_int transp, struct fb_info *info)
+{
+	u32 *pal = info->pseudo_palette;
+	u32 cr = red >> (16 - info->var.red.length);
+	u32 cg = green >> (16 - info->var.green.length);
+	u32 cb = blue >> (16 - info->var.blue.length);
+	u32 value;
+
+	if (regno >= 16)
+		return -EINVAL;
+
+	value = (cr << info->var.red.offset) |
+		(cg << info->var.green.offset) |
+		(cb << info->var.blue.offset);
+
+	if (info->var.transp.length > 0) {
+		u32 mask = (1 << info->var.transp.length) - 1;
+		mask <<= info->var.transp.offset;
+		value |= mask;
+	}
+
+	pal[regno] = value;
+
+	return 0;
+}
+
+static struct fb_ops sdrm_fbdev_ops = {
+	.owner		= THIS_MODULE,
+	.fb_setcolreg	= sdrm_fbdev_setcolreg,
+	.fb_fillrect	= cfb_fillrect,
+	.fb_copyarea	= cfb_copyarea,
+	.fb_imageblit	= cfb_imageblit,
+};
+
+void sdrm_fbdev_init(struct sdrm_device *sdrm)
+{
+	struct sdrm_fbdev *fb;
+	struct fb_info *info;
+	int ret;
+
+	if (fb_get_options("simpledrmfb", NULL))
+		return;
+
+	info = framebuffer_alloc(sizeof(struct sdrm_fbdev), sdrm->ddev->dev);
+	if (!info)
+		goto err_out;
+
+	fb = info->par;
+	info->flags = FBINFO_DEFAULT | FBINFO_MISC_FIRMWARE;
+	info->pseudo_palette = fb->palette;
+	info->fbops = &sdrm_fbdev_ops;
+	info->screen_base = sdrm->fb_map;
+
+	strncpy(info->fix.id, "simpledrmfb", 15);
+	info->fix.type = FB_TYPE_PACKED_PIXELS;
+	info->fix.visual = FB_VISUAL_TRUECOLOR;
+	info->fix.accel = FB_ACCEL_NONE;
+	info->fix.smem_start = (unsigned long)sdrm->fb_base;
+	info->fix.smem_len = sdrm->fb_size;
+	info->fix.line_length = sdrm->fb_stride;
+
+	info->var.activate = FB_ACTIVATE_NOW;
+	info->var.vmode = FB_VMODE_NONINTERLACED;
+	info->var.bits_per_pixel = sdrm->fb_bpp;
+	info->var.height = -1;
+	info->var.width = -1;
+	info->var.xres = sdrm->fb_width;
+	info->var.yres = sdrm->fb_height;
+	info->var.xres_virtual = info->var.xres;
+	info->var.yres_virtual = info->var.yres;
+	info->var.red = sdrm->fb_sformat->red;
+	info->var.green = sdrm->fb_sformat->green;
+	info->var.blue = sdrm->fb_sformat->blue;
+	info->var.transp = sdrm->fb_sformat->transp;
+
+	/* some dummy values for timing to make fbset happy */
+	info->var.pixclock = 10000000 / info->var.xres * 1000 / info->var.yres;
+	info->var.left_margin = (info->var.xres / 8) & 0xf8;
+	info->var.right_margin = 32;
+	info->var.upper_margin = 16;
+	info->var.lower_margin = 4;
+	info->var.hsync_len = (info->var.xres / 8) & 0xf8;
+	info->var.vsync_len = 4;
+
+	sdrm->fbdev = info;
+	ret = register_framebuffer(info);
+	if (ret < 0)
+		goto err_free;
+
+	dev_info(sdrm->ddev->dev, "fbdev frontend %s as fb%d\n",
+		 info->fix.id, info->node);
+
+	return;
+
+err_free:
+	framebuffer_release(info);
+	sdrm->fbdev = NULL;
+err_out:
+	dev_warn(sdrm->ddev->dev, "cannot create fbdev frontend\n");
+}
+
+void sdrm_fbdev_cleanup(struct sdrm_device *sdrm)
+{
+	struct fb_info *info;
+
+	if (!sdrm->fbdev)
+		return;
+
+	info = sdrm->fbdev;
+	sdrm->fbdev = NULL;
+
+	dev_info(sdrm->ddev->dev, "remove fbdev frontend %s (fb%d)\n",
+		 info->fix.id, info->node);
+
+	if (unregister_framebuffer(info))
+		dev_err(sdrm->ddev->dev, "unregister_framebuffer() failed, leaking fw-fb\n");
+	else
+		framebuffer_release(info);
+}
-- 
1.8.5.3

