Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532Ab3FXW2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 18:28:21 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:49817 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab3FXW2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 18:28:18 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@gmail.com>,
        linux-fbdev@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Olof Johansson <olof@lixom.net>,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [RFC 4/6] drm: simpledrm: add fbdev fallback support
Date: Tue, 25 Jun 2013 00:27:27 +0200
Message-Id: <1372112849-670-5-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1372112849-670-1-git-send-email-dh.herrmann@gmail.com>
References: <1372112849-670-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a simple fbdev device during SimpleDRM setup so legacy user-space
and fbcon can use it.

fbdev deletion is quite buggy. A unregister_framebuffer() call followed by
a printk() causes NULL-derefs in hide_cursor() and other places in the VT
layer. Hence, we leak the fbdev device currently to make the VT layer
happy. This needs to be fixed soon! Otherwise, we need a "depends !VT"
line for SimpleDRM.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 drivers/gpu/drm/simpledrm/Kconfig           |  11 ++
 drivers/gpu/drm/simpledrm/Makefile          |   4 +
 drivers/gpu/drm/simpledrm/simpledrm.h       |  22 ++++
 drivers/gpu/drm/simpledrm/simpledrm_fbdev.c | 180 ++++++++++++++++++++++++++++
 drivers/gpu/drm/simpledrm/simpledrm_main.c  |   2 +
 5 files changed, 219 insertions(+)
 create mode 100644 drivers/gpu/drm/simpledrm/simpledrm_fbdev.c

diff --git a/drivers/gpu/drm/simpledrm/Kconfig b/drivers/gpu/drm/simpledrm/Kconfig
index 1d4f38e..7936211 100644
--- a/drivers/gpu/drm/simpledrm/Kconfig
+++ b/drivers/gpu/drm/simpledrm/Kconfig
@@ -12,7 +12,18 @@ config DRM_SIMPLEDRM
 	  SimpleDRM supports: "simple-framebuffer" DeviceTree objects, x86 VESA
 	  BIOS Extensions (VBE), EFI framebuffers
 
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
index 2d474a5..e77bd9b 100644
--- a/drivers/gpu/drm/simpledrm/Makefile
+++ b/drivers/gpu/drm/simpledrm/Makefile
@@ -2,4 +2,8 @@ ccflags-y := -Iinclude/drm
 
 simpledrm-y := simpledrm_drv.o simpledrm_main.o simpledrm_mem.o
 
+ifdef CONFIG_DRM_SIMPLEDRM_FBDEV
+	simpledrm-y += simpledrm_fbdev.o
+endif
+
 obj-$(CONFIG_DRM_SIMPLEDRM) := simpledrm.o
diff --git a/drivers/gpu/drm/simpledrm/simpledrm.h b/drivers/gpu/drm/simpledrm/simpledrm.h
index 279d847..cfd99f9 100644
--- a/drivers/gpu/drm/simpledrm/simpledrm.h
+++ b/drivers/gpu/drm/simpledrm/simpledrm.h
@@ -48,6 +48,9 @@ struct sdrm_device {
 	struct drm_encoder enc;
 	struct drm_connector conn;
 	struct drm_display_mode *mode;
+
+	/* fbdev */
+	struct fb_info *fbdev;
 };
 
 int sdrm_drm_load(struct drm_device *ddev, unsigned long flags);
@@ -88,4 +91,23 @@ struct sdrm_framebuffer {
 
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
index 0000000..40a2696
--- /dev/null
+++ b/drivers/gpu/drm/simpledrm/simpledrm_fbdev.c
@@ -0,0 +1,180 @@
+/*
+ * SimpleDRM firmware framebuffer driver
+ * Copyright (c) 2012-2013 David Herrmann <dh.herrmann@gmail.com>
+ */
+
+/*
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
+	u32 palette[256];
+};
+
+static int sdrm_fbdev_setcolreg(unsigned regno, unsigned red, unsigned green,
+				unsigned blue, unsigned transp,
+				struct fb_info *info)
+{
+	/*
+	 * Set a single color register. The values supplied are
+	 * already rounded down to the hardware's capabilities
+	 * (according to the entries in the `var' structure). Return != 0 for
+	 * invalid regno.
+	 */
+
+	if (regno >= info->cmap.len)
+		return 1;
+	if (info->var.bits_per_pixel == 8)
+		return -EINVAL;
+	if (regno >= 16)
+		return 0;
+
+	switch (info->var.bits_per_pixel) {
+	case 16:
+		if (info->var.red.offset == 10) {
+			/* 1:5:5:5 */
+			((u32*) (info->pseudo_palette))[regno] =
+				((red   & 0xf800) >>  1) |
+				((green & 0xf800) >>  6) |
+				((blue  & 0xf800) >> 11);
+		} else {
+			/* 0:5:6:5 */
+			((u32*) (info->pseudo_palette))[regno] =
+				((red   & 0xf800)      ) |
+				((green & 0xfc00) >>  5) |
+				((blue  & 0xf800) >> 11);
+		}
+		break;
+	case 24:
+	case 32:
+		red   >>= 8;
+		green >>= 8;
+		blue  >>= 8;
+		((u32*) (info->pseudo_palette))[regno] =
+			(red   << info->var.red.offset)   |
+			(green << info->var.green.offset) |
+			(blue  << info->var.blue.offset);
+		break;
+	}
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
+	info = framebuffer_alloc(sizeof(struct sdrm_fbdev), sdrm->ddev->dev);
+	if (!info)
+		goto err_out;
+
+	fb = info->par;
+	info->flags = FBINFO_FLAG_DEFAULT | FBINFO_MISC_FIRMWARE;
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
+err_out:
+	dev_warn(sdrm->ddev->dev, "cannot create fbdev frontend\n");
+}
+
+void sdrm_fbdev_cleanup(struct sdrm_device *sdrm)
+{
+	struct fb_info *info;
+
+	if (!sdrm->info)
+		return;
+
+	dev_info(sdrm->ddev->dev, "fbdev cleanup\n");
+	info = sdrm->fbdev;
+	sdrm->fbdev = NULL;
+
+	unregister_framebuffer(info);
+
+	/*
+	 * FIXME: unregister_framebuffer() may silently fail, which is odd
+	 * because there is no sane way for us to detect when to release the
+	 * framebuffer.
+	 * If we fix unbind_console() to not fail during framebuffer
+	 * unregistration, we end up with NULL-derefs in the VT layer
+	 * afterwards. So lets just leak the FB here for the VT layer's sake.
+	 */
+	/* framebuffer_release(info); */
+}
diff --git a/drivers/gpu/drm/simpledrm/simpledrm_main.c b/drivers/gpu/drm/simpledrm/simpledrm_main.c
index dcc3d0a..ffa1abb 100644
--- a/drivers/gpu/drm/simpledrm/simpledrm_main.c
+++ b/drivers/gpu/drm/simpledrm/simpledrm_main.c
@@ -305,6 +305,7 @@ int sdrm_drm_load(struct drm_device *ddev, unsigned long flags)
 	if (ret)
 		goto err_cleanup;
 
+	sdrm_fbdev_init(sdrm);
 	return 0;
 
 err_cleanup:
@@ -322,6 +323,7 @@ int sdrm_drm_unload(struct drm_device *ddev)
 {
 	struct sdrm_device *sdrm = ddev->dev_private;
 
+	sdrm_fbdev_cleanup(sdrm);
 	drm_mode_config_cleanup(ddev);
 	sdrm_pdev_destroy(sdrm);
 	kfree(sdrm);
-- 
1.8.3.1

