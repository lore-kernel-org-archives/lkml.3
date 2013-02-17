Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075Ab3BQSAh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 13:00:37 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:59350 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab3BQSAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 13:00:03 -0500
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH 8/9] drm: dvbe: implement VBE/VESA blitting backend
Date: Sun, 17 Feb 2013 18:59:10 +0100
Message-Id: <1361123951-587-9-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1361123951-587-1-git-send-email-dh.herrmann@gmail.com>
References: <1361123951-587-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend the dvbe core driver by a VESA/VBE backend that simply blits the
data from a framebuffer into the hardware framebuffer on damage.
Modesetting has to be done during the boot-process by the architecture
code (same way as vesafb requires it). No runtime modesetting is allowed
due to RealMode/ProtectedMode restrictions.

On dirty-ioctls we simply vmap the framebuffer memory and copy each pixel
into the target framebuffer. Unfortunately, the VBE bpp/depth combinations
cannot easily be forwarded to the user via the DRM API as it allows a lot
more combinations. Hence, we need to convert each pixel from the user's
buffer format into the target format while blitting.
Fast-paths for xrgb32/etc. could be implemented if we want to improve
blitting performance.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 drivers/gpu/drm/dvbe/Kconfig     |   1 +
 drivers/gpu/drm/dvbe/Makefile    |   2 +-
 drivers/gpu/drm/dvbe/dvbe.h      |  25 ++++
 drivers/gpu/drm/dvbe/dvbe_main.c |  39 +++++-
 drivers/gpu/drm/dvbe/dvbe_vesa.c | 263 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 325 insertions(+), 5 deletions(-)
 create mode 100644 drivers/gpu/drm/dvbe/dvbe_vesa.c

diff --git a/drivers/gpu/drm/dvbe/Kconfig b/drivers/gpu/drm/dvbe/Kconfig
index bb3aa7b..e49df10 100644
--- a/drivers/gpu/drm/dvbe/Kconfig
+++ b/drivers/gpu/drm/dvbe/Kconfig
@@ -3,6 +3,7 @@ config DRM_DVBE
 	depends on DRM
 	select DRM_KMS_HELPER
 	select DRM_SYSFB
+	select FB_BOOT_VESA_SUPPORT
 	help
 	  This is a DRM/KMS driver for VESA BIOS Extension (VBE) compatible
 	  cards. At least VBE 2.0 is needed. Older VBE 1.2 cards are not
diff --git a/drivers/gpu/drm/dvbe/Makefile b/drivers/gpu/drm/dvbe/Makefile
index b053da3..f6fb888 100644
--- a/drivers/gpu/drm/dvbe/Makefile
+++ b/drivers/gpu/drm/dvbe/Makefile
@@ -1,4 +1,4 @@
 ccflags-y := -Iinclude/drm
 
-dvbe-y := dvbe_drv.o dvbe_main.o dvbe_mem.o
+dvbe-y := dvbe_drv.o dvbe_main.o dvbe_mem.o dvbe_vesa.o
 obj-$(CONFIG_DRM_DVBE) := dvbe.o
diff --git a/drivers/gpu/drm/dvbe/dvbe.h b/drivers/gpu/drm/dvbe/dvbe.h
index 0235a95..68fd452 100644
--- a/drivers/gpu/drm/dvbe/dvbe.h
+++ b/drivers/gpu/drm/dvbe/dvbe.h
@@ -25,6 +25,23 @@
 struct dvbe_device {
 	struct drm_device *ddev;
 
+	/* vbe information */
+	unsigned long vbe_addr;
+	unsigned long vbe_vsize;
+	unsigned long vbe_size;
+	unsigned int vbe_depth;
+	unsigned int vbe_bpp;
+	unsigned int vbe_width;
+	unsigned int vbe_height;
+	unsigned int vbe_stride;
+	uint8_t vbe_red_size;
+	uint8_t vbe_red_pos;
+	uint8_t vbe_green_size;
+	uint8_t vbe_green_pos;
+	uint8_t vbe_blue_size;
+	uint8_t vbe_blue_pos;
+	uint8_t *vbe_map;
+
 	/* mode-setting objects */
 	struct drm_crtc crtc;
 	struct drm_encoder enc;
@@ -70,4 +87,12 @@ struct dvbe_framebuffer {
 
 #define to_dvbe_fb(x) container_of(x, struct dvbe_framebuffer, base)
 
+/* vesa helpers */
+
+int dvbe_vesa_init(struct dvbe_device *dvbe);
+void dvbe_vesa_cleanup(struct dvbe_device *dvbe);
+int dvbe_vesa_damage(struct dvbe_device *dvbe, struct dvbe_framebuffer *fb,
+		     unsigned int flags, unsigned int color,
+		     struct drm_clip_rect *clips, unsigned int num);
+
 #endif /* DVBE_DRV_H */
diff --git a/drivers/gpu/drm/dvbe/dvbe_main.c b/drivers/gpu/drm/dvbe/dvbe_main.c
index e73c77e..c418310 100644
--- a/drivers/gpu/drm/dvbe/dvbe_main.c
+++ b/drivers/gpu/drm/dvbe/dvbe_main.c
@@ -46,6 +46,15 @@ static bool dvbe_crtc_mode_fixup(struct drm_crtc *crtc,
 				 const struct drm_display_mode *mode,
 				 struct drm_display_mode *adjusted_mode)
 {
+	struct dvbe_device *dvbe = crtc->dev->dev_private;
+
+	if (mode->hdisplay != dvbe->vbe_width ||
+	    mode->vdisplay != dvbe->vbe_height) {
+		dev_dbg(dvbe->ddev->dev, "invalid mode %ux%u\n",
+			mode->hdisplay, mode->vdisplay);
+		return false;
+	}
+
 	drm_mode_copy(adjusted_mode, mode);
 	return true;
 }
@@ -66,6 +75,7 @@ static int dvbe_crtc_mode_set(struct drm_crtc *crtc,
 			      int x, int y,
 			      struct drm_framebuffer *old_fb)
 {
+	struct dvbe_device *dvbe = crtc->dev->dev_private;
 	struct dvbe_framebuffer *dfb = to_dvbe_fb(crtc->fb);
 
 	/* We can scan out any framebuffer that is given. The framebuffer
@@ -79,7 +89,7 @@ static int dvbe_crtc_mode_set(struct drm_crtc *crtc,
 	if (x >= dfb->base.width || y >= dfb->base.height)
 		return -EINVAL;
 
-	return 0;
+	return dvbe_vesa_damage(dvbe, dfb, 0, 0, NULL, 0);
 }
 
 /*
@@ -89,12 +99,13 @@ static int dvbe_crtc_mode_set(struct drm_crtc *crtc,
 static int dvbe_crtc_mode_set_base(struct drm_crtc *crtc, int x, int y,
 				   struct drm_framebuffer *fb)
 {
+	struct dvbe_device *dvbe = crtc->dev->dev_private;
 	struct dvbe_framebuffer *dfb = to_dvbe_fb(crtc->fb);
 
 	if (x >= dfb->base.width || y >= dfb->base.height)
 		return -EINVAL;
 
-	return 0;
+	return dvbe_vesa_damage(dvbe, dfb, 0, 0, NULL, 0);
 }
 
 static const struct drm_crtc_helper_funcs dvbe_crtc_helper_ops = {
@@ -159,7 +170,19 @@ static const struct drm_encoder_funcs dvbe_enc_ops = {
 
 static int dvbe_conn_get_modes(struct drm_connector *conn)
 {
-	return 0;
+	struct dvbe_device *dvbe = conn->dev->dev_private;
+	struct drm_display_mode *mode;
+
+	mode = drm_gtf_mode(dvbe->ddev, dvbe->vbe_width, dvbe->vbe_height,
+			    60, 0, 0);
+	if (!mode)
+		return 0;
+
+	mode->type = DRM_MODE_TYPE_DRIVER | DRM_MODE_TYPE_PREFERRED;
+	drm_mode_probed_add(conn, mode);
+	dvbe->mode = mode;
+
+	return 1;
 }
 
 static int dvbe_conn_mode_valid(struct drm_connector *conn,
@@ -226,11 +249,12 @@ static int dvbe_fb_dirty(struct drm_framebuffer *fb, struct drm_file *file,
 			 struct drm_clip_rect *clips, unsigned int num)
 {
 	struct dvbe_device *dvbe = fb->dev->dev_private;
+	struct dvbe_framebuffer *dfb = to_dvbe_fb(fb);
 
 	if (dvbe->crtc.fb != fb)
 		return 0;
 
-	return 0;
+	return dvbe_vesa_damage(dvbe, dfb, flags, color, clips, num);
 }
 
 static void dvbe_fb_destroy(struct drm_framebuffer *fb)
@@ -334,6 +358,10 @@ int dvbe_drm_load(struct drm_device *ddev, unsigned long flags)
 	dvbe->ddev = ddev;
 	ddev->dev_private = dvbe;
 
+	ret = dvbe_vesa_init(dvbe);
+	if (ret)
+		goto err_free;
+
 	drm_mode_config_init(ddev);
 	ddev->mode_config.min_width = 0;
 	ddev->mode_config.min_height = 0;
@@ -384,6 +412,8 @@ int dvbe_drm_load(struct drm_device *ddev, unsigned long flags)
 
 err_cleanup:
 	drm_mode_config_cleanup(ddev);
+	dvbe_vesa_cleanup(dvbe);
+err_free:
 	kfree(dvbe);
 	return ret;
 }
@@ -393,6 +423,7 @@ int dvbe_drm_unload(struct drm_device *ddev)
 	struct dvbe_device *dvbe = ddev->dev_private;
 
 	drm_mode_config_cleanup(ddev);
+	dvbe_vesa_cleanup(dvbe);
 	kfree(dvbe);
 
 	return 0;
diff --git a/drivers/gpu/drm/dvbe/dvbe_vesa.c b/drivers/gpu/drm/dvbe/dvbe_vesa.c
new file mode 100644
index 0000000..c3f96a0
--- /dev/null
+++ b/drivers/gpu/drm/dvbe/dvbe_vesa.c
@@ -0,0 +1,263 @@
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
+ * VESA BIOS Extension Layer
+ * This layer provides access to the VBE data for the dvbe driver. It reads the
+ * mode information from the initial boot screen_info and initializes the
+ * framebuffer for user-mode access.
+ *
+ * This driver requires the VESA mode to be a TRUECOLOR format with a bpp value
+ * of 8, 15, 16 or 32. All other layouts are unsupported.
+ */
+
+#include <asm/io.h>
+#include <linux/ioport.h>
+#include <linux/module.h>
+#include <linux/screen_info.h>
+#include <drm/drmP.h>
+#include "dvbe.h"
+
+static void dvbe_vesa_read(const uint8_t *src, unsigned int format,
+			   uint8_t *r, uint8_t *g, uint8_t *b)
+{
+	uint32_t val;
+
+	switch (format) {
+	case DRM_FORMAT_RGB565:
+		val = *(uint16_t*)src;
+		*r = (val & 0xf800) >> 11;
+		*g = (val & 0x07e0) >> 5;
+		*b = (val & 0x001f) >> 0;
+		break;
+	case DRM_FORMAT_BGR565:
+		val = *(uint16_t*)src;
+		*b = (val & 0xf800) >> 11;
+		*g = (val & 0x07e0) >> 5;
+		*r = (val & 0x001f) >> 0;
+		break;
+	case DRM_FORMAT_XRGB8888:
+	case DRM_FORMAT_ARGB8888:
+		val = *(uint32_t*)src;
+		*r = (val & 0x00ff0000) >> 16;
+		*g = (val & 0x0000ff00) >> 8;
+		*b = (val & 0x000000ff) >> 0;
+		break;
+	case DRM_FORMAT_XBGR8888:
+	case DRM_FORMAT_ABGR8888:
+		val = *(uint32_t*)src;
+		*b = (val & 0x00ff0000) >> 16;
+		*g = (val & 0x0000ff00) >> 8;
+		*r = (val & 0x000000ff) >> 0;
+		break;
+	default:
+		*r = 0;
+		*g = 0;
+		*b = 0;
+	}
+}
+
+static void dvbe_vesa_write(struct dvbe_device *dvbe, uint8_t *dst,
+			    uint8_t r, uint8_t g, uint8_t b)
+{
+	uint32_t val;
+
+	val = (r >> (8 - dvbe->vbe_red_size)) << dvbe->vbe_red_pos;
+	val |= (g >> (8 - dvbe->vbe_green_size)) << dvbe->vbe_green_pos;
+	val |= (b >> (8 - dvbe->vbe_blue_size)) << dvbe->vbe_blue_pos;
+
+	switch (dvbe->vbe_bpp) {
+	case 8:
+		*dst = val & 0xff;
+		break;
+	case 16:
+		*((uint16_t*)dst) = val & 0xffff;
+		break;
+	case 32:
+		*((uint32_t*)dst) = val & 0xffffffff;
+		break;
+	}
+}
+
+static void dvbe_vesa_blit(struct dvbe_device *dvbe, const uint8_t *src,
+			   unsigned int src_stride, unsigned int src_f,
+			   unsigned int src_bpp, unsigned int x, unsigned int y,
+			   unsigned int width, unsigned int height)
+{
+	uint8_t *dst, *d, r, g, b;
+	const uint8_t *s;
+	unsigned int i, j, sBpp, dBpp;
+
+	sBpp = src_bpp / 8;
+	dBpp = dvbe->vbe_bpp / 8;
+	src = src + y * src_stride + x * sBpp;
+	dst = dvbe->vbe_map + y * dvbe->vbe_stride + x * dBpp;
+
+	for (i = 0; i < height; ++i) {
+		s = src;
+		d = dst;
+		for (j = 0; j < width; ++j) {
+			dvbe_vesa_read(src, src_f, &r, &g, &b);
+			dvbe_vesa_write(dvbe, d, r, g, b);
+			s += sBpp;
+			d += dBpp;
+		}
+
+		src += src_stride;
+		dst += dvbe->vbe_stride;
+	}
+}
+
+int dvbe_vesa_damage(struct dvbe_device *dvbe, struct dvbe_framebuffer *fb,
+		     unsigned int flags, unsigned int color,
+		     struct drm_clip_rect *clips, unsigned int num)
+{
+	unsigned int i, maxw, maxh;
+	unsigned int width, height, ret;
+	uint8_t *src;
+	bool annotated;
+
+	ret = dvbe_gem_vmap(fb->obj);
+	if (ret)
+		return ret;
+
+	annotated = flags & DRM_MODE_FB_DIRTY_ANNOTATE_COPY;
+	src = fb->obj->vmapping + fb->base.offsets[0];
+	maxw = min(fb->base.width, dvbe->vbe_width);
+	maxh = min(fb->base.height, dvbe->vbe_height);
+
+	if (!num) {
+		dvbe_vesa_blit(dvbe, src, fb->base.pitches[0],
+			       fb->base.pixel_format, fb->base.bits_per_pixel,
+			       0, 0, maxw, maxh);
+		return 0;
+	}
+
+	for (i = 0; i < num; ++i) {
+		if (annotated && !(i & 0x1))
+			continue;
+		if (clips[i].x2 <= clips[i].x1 || clips[i].y2 <= clips[i].y1)
+			continue;
+
+		/* clip to framebuffer size */
+		if (clips[i].x1 >= maxw ||
+		    clips[i].y1 >= maxh)
+			continue;
+		if (clips[i].x2 > maxw)
+			width = maxw - clips[i].x1;
+		else
+			width = clips[i].x2 - clips[i].x1;
+		if (clips[i].y2 > maxh)
+			height = maxh - clips[i].y1;
+		else
+			height = clips[i].y2 - clips[i].y1;
+
+		dvbe_vesa_blit(dvbe, src, fb->base.pitches[0],
+			       fb->base.pixel_format, fb->base.bits_per_pixel,
+			       clips[i].x1, clips[i].y1, width, height);
+	}
+
+	return 0;
+}
+
+int dvbe_vesa_init(struct dvbe_device *dvbe)
+{
+	int ret;
+
+	if (screen_info.orig_video_isVGA != VIDEO_TYPE_VLFB) {
+		dev_info(dvbe->ddev->dev, "no VBE capable device found\n");
+		return -ENODEV;
+	}
+
+	dvbe->vbe_addr = (unsigned long)screen_info.lfb_base;
+	dvbe->vbe_width = screen_info.lfb_width;
+	dvbe->vbe_height = screen_info.lfb_height;
+	dvbe->vbe_stride = screen_info.lfb_linelength;
+	dvbe->vbe_depth = screen_info.lfb_depth;
+	dvbe->vbe_bpp = (dvbe->vbe_depth == 15) ? 16 : dvbe->vbe_depth;
+	dvbe->vbe_size = dvbe->vbe_height * dvbe->vbe_stride;
+	dvbe->vbe_vsize = screen_info.lfb_size * 0x10000;
+	if (dvbe->vbe_vsize < dvbe->vbe_size)
+		dvbe->vbe_vsize = dvbe->vbe_size;
+
+	dev_info(dvbe->ddev->dev, "VMEM at: %ld vsize: %ld rsize: %ld\n",
+		 dvbe->vbe_addr, dvbe->vbe_vsize, dvbe->vbe_size);
+	dev_info(dvbe->ddev->dev, "width: %d height: %d stride: %d bpp: %d\n",
+		 dvbe->vbe_width, dvbe->vbe_height, dvbe->vbe_stride,
+		 dvbe->vbe_bpp);
+
+	if (dvbe->vbe_bpp != 8 && dvbe->vbe_bpp != 16 && dvbe->vbe_bpp != 32) {
+		dev_err(dvbe->ddev->dev, "unsupported bpp value %d\n",
+			dvbe->vbe_bpp);
+		return -ENODEV;
+	}
+	if (!screen_info.red_pos && !screen_info.green_pos &&
+	    !screen_info.blue_pos) {
+		dev_err(dvbe->ddev->dev, "hardware not truecolor capable\n");
+		return -ENODEV;
+	}
+	if (!screen_info.red_size && !screen_info.green_size &&
+	    !screen_info.blue_size) {
+		dev_err(dvbe->ddev->dev, "hardware not truecolor capable\n");
+		return -ENODEV;
+	}
+
+	dvbe->vbe_red_size = screen_info.red_size;
+	dvbe->vbe_red_pos = screen_info.red_pos;
+	dvbe->vbe_green_size = screen_info.green_size;
+	dvbe->vbe_green_pos = screen_info.green_pos;
+	dvbe->vbe_blue_size = screen_info.blue_size;
+	dvbe->vbe_blue_pos = screen_info.blue_pos;
+
+	dev_info(dvbe->ddev->dev, "color %d:%d r: %d:%d g: %d:%d b: %d:%d\n",
+		 dvbe->vbe_depth, dvbe->vbe_bpp,
+		 dvbe->vbe_red_pos, dvbe->vbe_red_size,
+		 dvbe->vbe_green_pos, dvbe->vbe_green_size,
+		 dvbe->vbe_blue_pos, dvbe->vbe_blue_size);
+
+	if (!request_mem_region(dvbe->vbe_addr, dvbe->vbe_vsize, "dvbe")) {
+		dev_err(dvbe->ddev->dev, "cannot reserve VMEM\n");
+		return -EIO;
+	}
+
+	if (!request_region(0x3c0, 32, "dvbe")) {
+		dev_err(dvbe->ddev->dev, "cannot reserve VBIOS\n");
+		ret = -EIO;
+		goto err_mem_region;
+	}
+
+	dvbe->vbe_map = ioremap(dvbe->vbe_addr, dvbe->vbe_size);
+	if (!dvbe->vbe_map) {
+		dev_err(dvbe->ddev->dev, "cannot remap VMEM\n");
+		ret = -EIO;
+		goto err_region;
+	}
+
+	dev_info(dvbe->ddev->dev, "initialized VBE mode to %ux%u at %p\n",
+		 dvbe->vbe_width, dvbe->vbe_height, dvbe->vbe_map);
+
+	return 0;
+
+err_region:
+	release_region(0x3c0, 32);
+err_mem_region:
+	release_mem_region(dvbe->vbe_addr, dvbe->vbe_vsize);
+	return -ENODEV;
+}
+
+void dvbe_vesa_cleanup(struct dvbe_device *dvbe)
+{
+	dev_info(dvbe->ddev->dev, "VBE cleanup\n");
+	iounmap(dvbe->vbe_map);
+	release_region(0x3c0, 32);
+	release_mem_region(dvbe->vbe_addr, dvbe->vbe_vsize);
+}
-- 
1.8.1.3

