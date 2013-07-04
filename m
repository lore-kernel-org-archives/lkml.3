Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712Ab3GDM1J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 08:27:09 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:61366 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807Ab3GDM0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 08:26:43 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH v2 10/14] drm: simpledrm: add fbdev fallback support
Date: Thu,  4 Jul 2013 14:25:10 +0200
Message-Id: <1372940714-12470-11-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1372940714-12470-1-git-send-email-dh.herrmann@gmail.com>
References: <1372940714-12470-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a simple fbdev device during SimpleDRM setup so legacy user-space
and fbcon can use it.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 drivers/gpu/drm/simpledrm/Kconfig           |  11 ++
 drivers/gpu/drm/simpledrm/Makefile          |   1 +
 drivers/gpu/drm/simpledrm/simpledrm.h       |  22 ++++
 drivers/gpu/drm/simpledrm/simpledrm_fbdev.c | 153 ++++++++++++++++++++++++++++
 drivers/gpu/drm/simpledrm/simpledrm_main.c  |   2 +
 5 files changed, 189 insertions(+)
 create mode 100644 drivers/gpu/drm/simpledrm/simpledrm_fbdev.c

diff --git a/drivers/gpu/drm/simpledrm/Kconfig b/drivers/gpu/drm/simpledrm/Kconfig
index 4f82844..1ba585e 100644
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
index 2d474a5..554d617 100644
--- a/drivers/gpu/drm/simpledrm/Makefile
+++ b/drivers/gpu/drm/simpledrm/Makefile
@@ -1,5 +1,6 @@
 ccflags-y := -Iinclude/drm
 
 simpledrm-y := simpledrm_drv.o simpledrm_main.o simpledrm_mem.o
+simpledrm-$(CONFIG_DRM_SIMPLEDRM_FBDEV) += simpledrm_fbdev.o
 
 obj-$(CONFIG_DRM_SIMPLEDRM) := simpledrm.o
diff --git a/drivers/gpu/drm/simpledrm/simpledrm.h b/drivers/gpu/drm/simpledrm/simpledrm.h
index 977b344..b854981 100644
--- a/drivers/gpu/drm/simpledrm/simpledrm.h
+++ b/drivers/gpu/drm/simpledrm/simpledrm.h
@@ -46,6 +46,9 @@ struct sdrm_device {
 	struct drm_encoder enc;
 	struct drm_connector conn;
 	struct drm_display_mode *mode;
+
+	/* fbdev */
+	struct fb_info *fbdev;
 };
 
 int sdrm_drm_load(struct drm_device *ddev, unsigned long flags);
@@ -86,4 +89,23 @@ struct sdrm_framebuffer {
 
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
index 0000000..7e2e4a2
--- /dev/null
+++ b/drivers/gpu/drm/simpledrm/simpledrm_fbdev.c
@@ -0,0 +1,153 @@
+/*
+ * SimpleDRM firmware framebuffer driver
+ * Copyright (c) 2012-2013 David Herrmann <dh.herrmann@gmail.com>
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
+	info->apertures = alloc_apertures(1);
+	if (!info->apertures)
+		goto err_free;
+
+	info->apertures->ranges[0].base = (unsigned long)sdrm->fb_base;
+	info->apertures->ranges[0].size = sdrm->fb_size;
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
+	dev_info(sdrm->ddev->dev, "fbdev cleanup\n");
+	info = sdrm->fbdev;
+	sdrm->fbdev = NULL;
+
+	if (unregister_framebuffer(info))
+		dev_warn(sdrm->ddev->dev, "unregister_framebuffer() failed, leaking fbdev device\n");
+	else
+		framebuffer_release(info);
+}
diff --git a/drivers/gpu/drm/simpledrm/simpledrm_main.c b/drivers/gpu/drm/simpledrm/simpledrm_main.c
index ae507e3..497542d 100644
--- a/drivers/gpu/drm/simpledrm/simpledrm_main.c
+++ b/drivers/gpu/drm/simpledrm/simpledrm_main.c
@@ -303,6 +303,7 @@ int sdrm_drm_load(struct drm_device *ddev, unsigned long flags)
 	if (ret)
 		goto err_cleanup;
 
+	sdrm_fbdev_init(sdrm);
 	return 0;
 
 err_cleanup:
@@ -320,6 +321,7 @@ int sdrm_drm_unload(struct drm_device *ddev)
 {
 	struct sdrm_device *sdrm = ddev->dev_private;
 
+	sdrm_fbdev_cleanup(sdrm);
 	drm_mode_config_cleanup(ddev);
 	sdrm_pdev_destroy(sdrm);
 	kfree(sdrm);
-- 
1.8.3.2

