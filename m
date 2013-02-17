Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949Ab3BQSAd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 13:00:33 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:57501 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab3BQSAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 13:00:04 -0500
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH 9/9] drm: dvbe: add optional fbdev frontend
Date: Sun, 17 Feb 2013 18:59:11 +0100
Message-Id: <1361123951-587-10-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1361123951-587-1-git-send-email-dh.herrmann@gmail.com>
References: <1361123951-587-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a new fbdev frontend to the dvbe driver. It allows userspace to
access the dvbe driver via an fbdev frontend.

It is disabled by default so you can use dvbe without CONFIG_FB. It should
only be used for backwards-compatibility. Use the DRM dumb API to access
dvbe buffers properly.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 drivers/gpu/drm/dvbe/Kconfig      |  18 +++
 drivers/gpu/drm/dvbe/Makefile     |   1 +
 drivers/gpu/drm/dvbe/dvbe.h       |  23 ++++
 drivers/gpu/drm/dvbe/dvbe_fbdev.c | 235 ++++++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/dvbe/dvbe_main.c  |   2 +
 5 files changed, 279 insertions(+)
 create mode 100644 drivers/gpu/drm/dvbe/dvbe_fbdev.c

diff --git a/drivers/gpu/drm/dvbe/Kconfig b/drivers/gpu/drm/dvbe/Kconfig
index e49df10..ca27455 100644
--- a/drivers/gpu/drm/dvbe/Kconfig
+++ b/drivers/gpu/drm/dvbe/Kconfig
@@ -27,3 +27,21 @@ config DRM_DVBE
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called dvbe.
+
+config DRM_DVBE_FBDEV
+	bool "VESA BIOS Extension DRM fbdev Compatibility Layer"
+	depends on DRM_DVBE && FB
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  This provides an fbdev frontend (via /dev/fbX) for the DVBE VESA
+	  driver. Old userspace that depends on the fbdev API can access the
+	  DVBE driver this way. It provides full backwards compatibility to the
+	  old vesafb driver.
+
+	  Newer userspace accesses graphics devices via the DRM API and the old
+	  fbdev compatibility layer is not needed. Activate it only if you
+	  really need to run old userspace programs.
+
+	  If unsure, say N.
diff --git a/drivers/gpu/drm/dvbe/Makefile b/drivers/gpu/drm/dvbe/Makefile
index f6fb888..e01aaa1 100644
--- a/drivers/gpu/drm/dvbe/Makefile
+++ b/drivers/gpu/drm/dvbe/Makefile
@@ -1,4 +1,5 @@
 ccflags-y := -Iinclude/drm
 
 dvbe-y := dvbe_drv.o dvbe_main.o dvbe_mem.o dvbe_vesa.o
+dvbe-$(CONFIG_DRM_DVBE_FBDEV) += dvbe_fbdev.o
 obj-$(CONFIG_DRM_DVBE) := dvbe.o
diff --git a/drivers/gpu/drm/dvbe/dvbe.h b/drivers/gpu/drm/dvbe/dvbe.h
index 68fd452..dfe7c20 100644
--- a/drivers/gpu/drm/dvbe/dvbe.h
+++ b/drivers/gpu/drm/dvbe/dvbe.h
@@ -14,6 +14,7 @@
 #define DVBE_DRV_H
 
 #include <linux/errno.h>
+#include <linux/fb.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/module.h>
@@ -47,6 +48,9 @@ struct dvbe_device {
 	struct drm_encoder enc;
 	struct drm_connector conn;
 	struct drm_display_mode *mode;
+
+	/* fbdev */
+	void *fbdev;
 };
 
 int dvbe_drm_load(struct drm_device *ddev, unsigned long flags);
@@ -95,4 +99,23 @@ int dvbe_vesa_damage(struct dvbe_device *dvbe, struct dvbe_framebuffer *fb,
 		     unsigned int flags, unsigned int color,
 		     struct drm_clip_rect *clips, unsigned int num);
 
+/* fbdev helpers */
+
+#ifdef CONFIG_DRM_DVBE_FBDEV
+
+void dvbe_fbdev_init(struct dvbe_device *dvbe);
+void dvbe_fbdev_cleanup(struct dvbe_device *dvbe);
+
+#else /* CONFIG_DRM_DVBE_FBDEV */
+
+static inline void dvbe_fbdev_init(struct dvbe_device *dvbe)
+{
+}
+
+static inline void dvbe_fbdev_cleanup(struct dvbe_device *dvbe)
+{
+}
+
+#endif /* CONFIG_DRM_DVBE_FBDEV */
+
 #endif /* DVBE_DRV_H */
diff --git a/drivers/gpu/drm/dvbe/dvbe_fbdev.c b/drivers/gpu/drm/dvbe/dvbe_fbdev.c
new file mode 100644
index 0000000..0e22e12
--- /dev/null
+++ b/drivers/gpu/drm/dvbe/dvbe_fbdev.c
@@ -0,0 +1,235 @@
+/*
+ * DRM VESA BIOS Extension Driver
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
+ * This provides an fbdev framebuffer device for the DVBE driver. It is
+ * based on the old vesafb.c driver:
+ *   (c) 1998 Gerd Knorr <kraxel@goldbach.in-berlin.de>
+ */
+
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/fb.h>
+#include "dvbe.h"
+
+struct dvbe_fbdev {
+	struct dvbe_device *dvbe;
+	u32 palette[256];
+};
+
+static int dvbe_fbdev_setcolreg(unsigned regno, unsigned red, unsigned green,
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
+static void dvbe_fbdev_free(struct dvbe_device *dvbe, struct fb_info *info)
+{
+	dev_info(dvbe->ddev->dev, "fbdev cleanup\n");
+	fb_dealloc_cmap(&info->cmap);
+	framebuffer_release(info);
+}
+
+static void dvbe_fbdev_destroy(struct fb_info *info)
+{
+	struct dvbe_fbdev *fb = info->par;
+	struct dvbe_device *dvbe = fb->dvbe;
+
+	mutex_lock(&dvbe->ddev->struct_mutex);
+	info = dvbe->fbdev;
+	dvbe->fbdev = NULL;
+	mutex_unlock(&dvbe->ddev->struct_mutex);
+
+	if (info)
+		dvbe_fbdev_free(dvbe, info);
+}
+
+static struct fb_ops dvbe_fbdev_ops = {
+	.owner		= THIS_MODULE,
+	.fb_destroy	= dvbe_fbdev_destroy,
+	.fb_setcolreg	= dvbe_fbdev_setcolreg,
+	.fb_fillrect	= cfb_fillrect,
+	.fb_copyarea	= cfb_copyarea,
+	.fb_imageblit	= cfb_imageblit,
+};
+
+void dvbe_fbdev_init(struct dvbe_device *dvbe)
+{
+	struct dvbe_fbdev *fb;
+	struct fb_info *info;
+	int ret;
+
+	info = framebuffer_alloc(sizeof(struct dvbe_fbdev), dvbe->ddev->dev);
+	if (!info) {
+		ret = -ENOMEM;
+		goto err_out;
+	}
+
+	fb = info->par;
+	fb->dvbe = dvbe;
+	info->flags = FBINFO_FLAG_DEFAULT | FBINFO_MISC_FIRMWARE;
+	info->pseudo_palette = fb->palette;
+	info->screen_base = dvbe->vbe_map;
+	info->fbops = &dvbe_fbdev_ops;
+
+	strncpy(info->fix.id, "dvbedrmfb", 15);
+	info->fix.type = FB_TYPE_PACKED_PIXELS;
+	info->fix.accel = FB_ACCEL_NONE;
+	info->fix.smem_start = (unsigned long)dvbe->vbe_addr;
+	info->fix.smem_len = dvbe->vbe_size;
+	info->fix.line_length = dvbe->vbe_stride;
+
+	if (dvbe->vbe_bpp == 8)
+		info->fix.visual = FB_VISUAL_STATIC_PSEUDOCOLOR;
+	else
+		info->fix.visual = FB_VISUAL_TRUECOLOR;
+
+	info->var.activate = FB_ACTIVATE_NOW;
+	info->var.vmode = FB_VMODE_NONINTERLACED;
+	info->var.bits_per_pixel = dvbe->vbe_bpp;
+	info->var.xres = dvbe->vbe_width;
+	info->var.yres = dvbe->vbe_height;
+	info->var.xres_virtual = info->var.xres;
+	info->var.yres_virtual = info->var.yres;
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
+	info->var.red.offset    = dvbe->vbe_red_pos;
+	info->var.red.length    = dvbe->vbe_red_size;
+	info->var.green.offset  = dvbe->vbe_green_pos;
+	info->var.green.length  = dvbe->vbe_green_size;
+	info->var.blue.offset   = dvbe->vbe_blue_pos;
+	info->var.blue.length   = dvbe->vbe_blue_size;
+
+	if (info->var.bits_per_pixel <= 8) {
+		info->var.red.length = info->var.bits_per_pixel;
+		info->var.green.length = info->var.bits_per_pixel;
+		info->var.blue.length = info->var.bits_per_pixel;
+	}
+
+	info->apertures = alloc_apertures(1);
+	if (!info->apertures) {
+		ret = -ENOMEM;
+		goto err_free;
+	}
+	info->apertures->ranges[0].base = (unsigned long)dvbe->vbe_addr;
+	info->apertures->ranges[0].size = dvbe->vbe_vsize;
+
+	ret = fb_alloc_cmap(&info->cmap, 256, 0);
+	if (ret < 0)
+		goto err_free;
+
+	/*
+	 * TODO: Fix register_framebuffer() to not reset refcounts!
+	 * So register_framebuffer() resets the refcnt of \info to 1. However,
+	 * any other context might call remove_conflicting_framebuffers()
+	 * before our call to register_framebuffer() returns.
+	 * remove_conflicting_framebuffers() calls unregister_framebuffer()
+	 * which then calls put_fb_info() and destroys \info by calling our
+	 * fb_destroy() callback.
+	 * To summarize, \info might be dead after register_framebuffer()
+	 * returns so don't access it afterwards. There is _no_ reliable way to
+	 * detect that so don't use \info at all now.
+	 * Instead we lock all accesses around dvbe->fbdev and the first one who
+	 * resets it is responsible of freeing it.
+	 */
+
+	dvbe->fbdev = info;
+	ret = register_framebuffer(info);
+	if (ret < 0)
+		goto err_cmap;
+
+	mutex_lock(&dvbe->ddev->struct_mutex);
+	if (dvbe->fbdev)
+		dev_info(dvbe->ddev->dev, "fbdev frontend %s as fb%d\n",
+			 info->fix.id, info->node);
+	mutex_unlock(&dvbe->ddev->struct_mutex);
+
+	return;
+
+err_cmap:
+	fb_dealloc_cmap(&info->cmap);
+err_free:
+	framebuffer_release(info);
+err_out:
+	dev_warn(dvbe->ddev->dev, "cannot create fbdev frontend (%d)\n", ret);
+}
+
+void dvbe_fbdev_cleanup(struct dvbe_device *dvbe)
+{
+	struct fb_info *info;
+
+	mutex_lock(&dvbe->ddev->struct_mutex);
+	info = dvbe->fbdev;
+	dvbe->fbdev = NULL;
+	mutex_unlock(&dvbe->ddev->struct_mutex);
+
+	if (!info)
+		return;
+
+	unregister_framebuffer(info);
+	dvbe_fbdev_free(dvbe, info);
+}
diff --git a/drivers/gpu/drm/dvbe/dvbe_main.c b/drivers/gpu/drm/dvbe/dvbe_main.c
index c418310..95241a6 100644
--- a/drivers/gpu/drm/dvbe/dvbe_main.c
+++ b/drivers/gpu/drm/dvbe/dvbe_main.c
@@ -408,6 +408,7 @@ int dvbe_drm_load(struct drm_device *ddev, unsigned long flags)
 	if (ret)
 		goto err_cleanup;
 
+	dvbe_fbdev_init(dvbe);
 	return 0;
 
 err_cleanup:
@@ -422,6 +423,7 @@ int dvbe_drm_unload(struct drm_device *ddev)
 {
 	struct dvbe_device *dvbe = ddev->dev_private;
 
+	dvbe_fbdev_cleanup(dvbe);
 	drm_mode_config_cleanup(ddev);
 	dvbe_vesa_cleanup(dvbe);
 	kfree(dvbe);
-- 
1.8.1.3

