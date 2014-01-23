Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301AbaAWORG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 09:17:06 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:60022 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932209AbaAWOQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 09:16:09 -0500
From: David Herrmann <dh.herrmann@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: Ingo Molnar <mingo@kernel.org>, linux-fbdev@vger.kernel.org,
        Dave Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-kernel@vger.kernel.org,
        Tom Gundersen <teg@jklm.no>, David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH 09/11] drm: add SimpleDRM driver
Date: Thu, 23 Jan 2014 15:15:01 +0100
Message-Id: <1390486503-1504-10-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390486503-1504-1-git-send-email-dh.herrmann@gmail.com>
References: <1390486503-1504-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SimpleDRM driver binds to simple-framebuffer devices and provides a
DRM/KMS API. It provides only a single CRTC+encoder+connector combination
plus one initial mode.

Userspace can create dumb-buffers which can be blit into the real
framebuffer similar to UDL. No access to the real framebuffer is allowed
(compared to earlier version of this driver) to avoid security issues.
Furthermore, this way we can support arbitrary modes as long as we have a
convertion-helper.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 MAINTAINERS                                  |   8 +
 drivers/gpu/drm/Kconfig                      |   2 +
 drivers/gpu/drm/Makefile                     |   1 +
 drivers/gpu/drm/simpledrm/Kconfig            |  18 ++
 drivers/gpu/drm/simpledrm/Makefile           |   3 +
 drivers/gpu/drm/simpledrm/simpledrm.c        | 252 ++++++++++++++++++
 drivers/gpu/drm/simpledrm/simpledrm.h        | 100 ++++++++
 drivers/gpu/drm/simpledrm/simpledrm_damage.c | 306 ++++++++++++++++++++++
 drivers/gpu/drm/simpledrm/simpledrm_gem.c    | 282 +++++++++++++++++++++
 drivers/gpu/drm/simpledrm/simpledrm_kms.c    | 365 +++++++++++++++++++++++++++
 10 files changed, 1337 insertions(+)
 create mode 100644 drivers/gpu/drm/simpledrm/Kconfig
 create mode 100644 drivers/gpu/drm/simpledrm/Makefile
 create mode 100644 drivers/gpu/drm/simpledrm/simpledrm.c
 create mode 100644 drivers/gpu/drm/simpledrm/simpledrm.h
 create mode 100644 drivers/gpu/drm/simpledrm/simpledrm_damage.c
 create mode 100644 drivers/gpu/drm/simpledrm/simpledrm_gem.c
 create mode 100644 drivers/gpu/drm/simpledrm/simpledrm_kms.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 31a0462..e7adc84 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7725,6 +7725,14 @@ S:	Odd Fixes
 F:	drivers/media/platform/sh_vou.c
 F:	include/media/sh_vou.h
 
+SIMPLE DRM DRIVER
+M:	David Herrmann <dh.herrmann@gmail.com>
+L:	dri-devel@lists.freedesktop.org
+T:	git git://people.freedesktop.org/~dvdhrm/linux
+S:	Maintained
+F:	drivers/gpu/drm/simpledrm
+F:	include/linux/platform_data/simpledrm.h
+
 SIMPLE FIRMWARE INTERFACE (SFI)
 M:	Len Brown <lenb@kernel.org>
 L:	sfi-devel@simplefirmware.org
diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 8e7fa4d..f795359 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -199,3 +199,5 @@ source "drivers/gpu/drm/msm/Kconfig"
 source "drivers/gpu/drm/tegra/Kconfig"
 
 source "drivers/gpu/drm/panel/Kconfig"
+
+source "drivers/gpu/drm/simpledrm/Kconfig"
diff --git a/drivers/gpu/drm/Makefile b/drivers/gpu/drm/Makefile
index 292a79d..7b27e07 100644
--- a/drivers/gpu/drm/Makefile
+++ b/drivers/gpu/drm/Makefile
@@ -61,5 +61,6 @@ obj-$(CONFIG_DRM_QXL) += qxl/
 obj-$(CONFIG_DRM_BOCHS) += bochs/
 obj-$(CONFIG_DRM_MSM) += msm/
 obj-$(CONFIG_DRM_TEGRA) += tegra/
+obj-$(CONFIG_DRM_SIMPLEDRM) += simpledrm/
 obj-y			+= i2c/
 obj-y			+= panel/
diff --git a/drivers/gpu/drm/simpledrm/Kconfig b/drivers/gpu/drm/simpledrm/Kconfig
new file mode 100644
index 0000000..35bcce8
--- /dev/null
+++ b/drivers/gpu/drm/simpledrm/Kconfig
@@ -0,0 +1,18 @@
+config DRM_SIMPLEDRM
+	tristate "Simple firmware framebuffer DRM driver"
+	depends on DRM && (FB_SIMPLE = n)
+	help
+	  SimpleDRM can run on all systems with pre-initialized graphics
+	  hardware. It uses a framebuffer that was initialized during
+	  firmware boot. No page-flipping, modesetting or other advanced
+	  features are available. However, other DRM drivers can be loaded
+	  later and take over from SimpleDRM if they provide real hardware
+	  support.
+
+	  SimpleDRM supports "simple-framebuffer" DeviceTree objects and
+	  compatible platform framebuffers.
+
+	  If unsure, say Y.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called simpledrm.
diff --git a/drivers/gpu/drm/simpledrm/Makefile b/drivers/gpu/drm/simpledrm/Makefile
new file mode 100644
index 0000000..35f73ea
--- /dev/null
+++ b/drivers/gpu/drm/simpledrm/Makefile
@@ -0,0 +1,3 @@
+sdrm-y := simpledrm.o simpledrm_kms.o simpledrm_gem.o simpledrm_damage.o
+
+obj-$(CONFIG_DRM_SIMPLEDRM) := sdrm.o
diff --git a/drivers/gpu/drm/simpledrm/simpledrm.c b/drivers/gpu/drm/simpledrm/simpledrm.c
new file mode 100644
index 0000000..98273f5
--- /dev/null
+++ b/drivers/gpu/drm/simpledrm/simpledrm.c
@@ -0,0 +1,252 @@
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
+#include <linux/errno.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/platform_data/simplefb.h>
+#include <linux/string.h>
+#include <drm/drmP.h>
+#include "simpledrm.h"
+
+static const struct file_operations sdrm_drm_fops = {
+	.owner = THIS_MODULE,
+	.open = drm_open,
+	.mmap = sdrm_drm_mmap,
+	.poll = drm_poll,
+	.read = drm_read,
+	.unlocked_ioctl = drm_ioctl,
+	.release = drm_release,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = drm_compat_ioctl,
+#endif
+	.llseek = noop_llseek,
+};
+
+static struct drm_driver sdrm_drm_driver = {
+	.driver_features = DRIVER_MODESET | DRIVER_GEM,
+	.load = sdrm_drm_load,
+	.unload = sdrm_drm_unload,
+	.fops = &sdrm_drm_fops,
+
+	.gem_free_object = sdrm_gem_free_object,
+	.prime_fd_to_handle = drm_gem_prime_fd_to_handle,
+	.gem_prime_import = sdrm_gem_prime_import,
+
+	.dumb_create = sdrm_dumb_create,
+	.dumb_map_offset = sdrm_dumb_map_offset,
+	.dumb_destroy = sdrm_dumb_destroy,
+
+	.name = "simpledrm",
+	.desc = "Simple firmware framebuffer DRM driver",
+	.date = "20130601",
+	.major = 0,
+	.minor = 0,
+	.patchlevel = 1,
+};
+
+static int parse_dt(struct platform_device *pdev,
+		    struct simplefb_platform_data *mode)
+{
+	struct device_node *np = pdev->dev.of_node;
+	const char *format;
+	int ret;
+
+	if (!np)
+		return -ENODEV;
+
+	ret = of_property_read_u32(np, "width", &mode->width);
+	if (ret) {
+		dev_err(&pdev->dev, "Can't parse width property\n");
+		return ret;
+	}
+
+	ret = of_property_read_u32(np, "height", &mode->height);
+	if (ret) {
+		dev_err(&pdev->dev, "Can't parse height property\n");
+		return ret;
+	}
+
+	ret = of_property_read_u32(np, "stride", &mode->stride);
+	if (ret) {
+		dev_err(&pdev->dev, "Can't parse stride property\n");
+		return ret;
+	}
+
+	ret = of_property_read_string(np, "format", &format);
+	if (ret) {
+		dev_err(&pdev->dev, "Can't parse format property\n");
+		return ret;
+	}
+	mode->format = format;
+
+	return 0;
+}
+
+static struct simplefb_format simplefb_formats[] = SIMPLEFB_FORMATS;
+
+int sdrm_pdev_init(struct sdrm_device *sdrm)
+{
+	struct platform_device *pdev = sdrm->ddev->platformdev;
+	struct simplefb_platform_data *mode = pdev->dev.platform_data;
+	struct simplefb_platform_data pmode;
+	struct resource *mem;
+	unsigned int depth;
+	int ret, i, bpp;
+
+	if (!mode) {
+		mode = &pmode;
+		ret = parse_dt(pdev, mode);
+		if (ret)
+			return ret;
+	}
+
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem) {
+		dev_err(sdrm->ddev->dev, "No memory resource\n");
+		return -ENODEV;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(simplefb_formats); ++i) {
+		if (strcmp(mode->format, simplefb_formats[i].name))
+			continue;
+
+		sdrm->fb_sformat = &simplefb_formats[i];
+		sdrm->fb_format = simplefb_formats[i].fourcc;
+		sdrm->fb_width = mode->width;
+		sdrm->fb_height = mode->height;
+		sdrm->fb_stride = mode->stride;
+		sdrm->fb_base = mem->start;
+		sdrm->fb_size = resource_size(mem);
+		break;
+	}
+
+	if (i >= ARRAY_SIZE(simplefb_formats)) {
+		dev_err(sdrm->ddev->dev, "Unknown format %s\n", mode->format);
+		return -ENODEV;
+	}
+
+	switch (sdrm->fb_format) {
+	case DRM_FORMAT_RGB565:
+	case DRM_FORMAT_XRGB1555:
+	case DRM_FORMAT_ARGB1555:
+	case DRM_FORMAT_RGB888:
+	case DRM_FORMAT_XRGB8888:
+	case DRM_FORMAT_ARGB8888:
+	case DRM_FORMAT_ABGR8888:
+	case DRM_FORMAT_XRGB2101010:
+	case DRM_FORMAT_ARGB2101010:
+		/* You must adjust sdrm_put() whenever you add a new format
+		 * here, otherwise, blitting operations will not work.
+		 * Furthermore, include/linux/platform_data/simplefb.h needs
+		 * to be adjusted so the platform-device actually allows this
+		 * format. */
+		break;
+	default:
+		dev_err(sdrm->ddev->dev, "Unsupported format %s\n",
+			mode->format);
+		return -ENODEV;
+	}
+
+	drm_fb_get_bpp_depth(sdrm->fb_format, &depth, &bpp);
+	if (!bpp) {
+		dev_err(sdrm->ddev->dev, "Unknown format %s\n", mode->format);
+		return -ENODEV;
+	}
+
+	if (sdrm->fb_size < sdrm->fb_stride * sdrm->fb_height) {
+		dev_err(sdrm->ddev->dev, "FB too small\n");
+		return -ENODEV;
+	} else if ((bpp + 7) / 8 * sdrm->fb_width > sdrm->fb_stride) {
+		dev_err(sdrm->ddev->dev, "Invalid stride\n");
+		return -ENODEV;
+	}
+
+	sdrm->fb_bpp = bpp;
+
+	sdrm->fb_map = ioremap_wc(sdrm->fb_base, sdrm->fb_size);
+	if (!sdrm->fb_map) {
+		dev_err(sdrm->ddev->dev, "cannot remap VMEM\n");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+void sdrm_pdev_destroy(struct sdrm_device *sdrm)
+{
+	if (sdrm->fb_map) {
+		iounmap(sdrm->fb_map);
+		sdrm->fb_map = NULL;
+	}
+}
+
+static int sdrm_simplefb_probe(struct platform_device *pdev)
+{
+	return drm_platform_init(&sdrm_drm_driver, pdev);
+}
+
+static int sdrm_simplefb_remove(struct platform_device *pdev)
+{
+	struct drm_device *ddev = platform_get_drvdata(pdev);
+	struct sdrm_device *sdrm = ddev->dev_private;
+
+	/* Oh, god! This is racy, but always has been. Unless we finally get
+	 * immediate device removal in DRM, we can never guarantee that no other
+	 * CPU is currently doing some GEM-bo access in parallel to us. But, eh,
+	 * what can we do.. Fixes for that is being worked on. */
+
+	drm_connector_unplug_all(ddev);
+
+	/* protect fb_map removal against sdrm_blit() */
+	drm_modeset_lock_all(ddev);
+	sdrm_pdev_destroy(sdrm);
+	drm_modeset_unlock_all(ddev);
+
+	drm_unplug_dev(ddev);
+
+	return 0;
+}
+
+static const struct of_device_id simplefb_of_match[] = {
+	{ .compatible = "simple-framebuffer", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, simplefb_of_match);
+
+static struct platform_driver sdrm_simplefb_driver = {
+	.probe = sdrm_simplefb_probe,
+	.remove = sdrm_simplefb_remove,
+	.driver = {
+		.name = "simple-framebuffer",
+		.mod_name = KBUILD_MODNAME,
+		.owner = THIS_MODULE,
+		.of_match_table = simplefb_of_match,
+	},
+};
+
+static int __init sdrm_init(void)
+{
+	return platform_driver_register(&sdrm_simplefb_driver);
+}
+
+static void __exit sdrm_exit(void)
+{
+	platform_driver_unregister(&sdrm_simplefb_driver);
+}
+
+module_init(sdrm_init);
+module_exit(sdrm_exit);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("David Herrmann <dh.herrmann@gmail.com>");
+MODULE_DESCRIPTION("Simple firmware framebuffer DRM driver");
+MODULE_ALIAS("platform:simple-framebuffer");
diff --git a/drivers/gpu/drm/simpledrm/simpledrm.h b/drivers/gpu/drm/simpledrm/simpledrm.h
new file mode 100644
index 0000000..4ece7f5
--- /dev/null
+++ b/drivers/gpu/drm/simpledrm/simpledrm.h
@@ -0,0 +1,100 @@
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
+#ifndef SDRM_DRV_H
+#define SDRM_DRV_H
+
+#include <linux/errno.h>
+#include <linux/fb.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/platform_data/simplefb.h>
+#include <linux/string.h>
+#include <drm/drmP.h>
+
+struct sdrm_device;
+struct sdrm_gem_object;
+struct sdrm_framebuffer;
+
+/* simpledrm devices */
+
+struct sdrm_device {
+	struct drm_device *ddev;
+
+	/* framebuffer information */
+	const struct simplefb_format *fb_sformat;
+	u32 fb_format;
+	u32 fb_width;
+	u32 fb_height;
+	u32 fb_stride;
+	u32 fb_bpp;
+	unsigned long fb_base;
+	unsigned long fb_size;
+	void *fb_map;
+
+	/* mode-setting objects */
+	struct drm_crtc crtc;
+	struct drm_encoder enc;
+	struct drm_connector conn;
+	struct drm_display_mode *mode;
+};
+
+int sdrm_drm_load(struct drm_device *ddev, unsigned long flags);
+int sdrm_drm_unload(struct drm_device *ddev);
+int sdrm_drm_mmap(struct file *filp, struct vm_area_struct *vma);
+int sdrm_pdev_init(struct sdrm_device *sdrm);
+void sdrm_pdev_destroy(struct sdrm_device *sdrm);
+
+int sdrm_dirty(struct drm_framebuffer *fb,
+	       struct drm_file *file,
+	       unsigned flags, unsigned color,
+	       struct drm_clip_rect *clips,
+	       unsigned num_clips);
+int sdrm_dirty_all_locked(struct sdrm_device *sdrm);
+int sdrm_dirty_all_unlocked(struct sdrm_device *sdrm);
+
+/* simpledrm gem objects */
+
+struct sdrm_gem_object {
+	struct drm_gem_object base;
+	struct sg_table *sg;
+	struct page **pages;
+	void *vmapping;
+};
+
+#define to_sdrm_bo(x) container_of(x, struct sdrm_gem_object, base)
+
+struct sdrm_gem_object *sdrm_gem_alloc_object(struct drm_device *ddev,
+					      size_t size);
+struct drm_gem_object *sdrm_gem_prime_import(struct drm_device *ddev,
+					     struct dma_buf *dma_buf);
+void sdrm_gem_free_object(struct drm_gem_object *obj);
+int sdrm_gem_get_pages(struct sdrm_gem_object *obj);
+
+/* dumb buffers */
+
+int sdrm_dumb_create(struct drm_file *file_priv, struct drm_device *ddev,
+		     struct drm_mode_create_dumb *arg);
+int sdrm_dumb_destroy(struct drm_file *file_priv, struct drm_device *ddev,
+		      uint32_t handle);
+int sdrm_dumb_map_offset(struct drm_file *file_priv, struct drm_device *ddev,
+			 uint32_t handle, uint64_t *offset);
+
+/* simpledrm framebuffers */
+
+struct sdrm_framebuffer {
+	struct drm_framebuffer base;
+	struct sdrm_gem_object *obj;
+};
+
+#define to_sdrm_fb(x) container_of(x, struct sdrm_framebuffer, base)
+
+#endif /* SDRM_DRV_H */
diff --git a/drivers/gpu/drm/simpledrm/simpledrm_damage.c b/drivers/gpu/drm/simpledrm/simpledrm_damage.c
new file mode 100644
index 0000000..67a2841
--- /dev/null
+++ b/drivers/gpu/drm/simpledrm/simpledrm_damage.c
@@ -0,0 +1,306 @@
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
+#include <asm/unaligned.h>
+#include <linux/dma-buf.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include <drm/drmP.h>
+#include <drm/drm_crtc.h>
+#include "simpledrm.h"
+
+static inline void sdrm_put(u8 *dst, u32 four_cc, u16 r, u16 g, u16 b)
+{
+	switch (four_cc) {
+	case DRM_FORMAT_RGB565:
+		r &= 0x1f;
+		g &= 0x3f;
+		b &= 0x1f;
+		put_unaligned((u16)((r << 11) | (g << 5) | b), (u16*)dst);
+		break;
+	case DRM_FORMAT_XRGB1555:
+	case DRM_FORMAT_ARGB1555:
+		r &= 0x1f;
+		g &= 0x1f;
+		b &= 0x1f;
+		put_unaligned((u16)((r << 10) | (g << 5) | b), (u16*)dst);
+		break;
+	case DRM_FORMAT_RGB888:
+		r &= 0xff;
+		g &= 0xff;
+		b &= 0xff;
+#ifdef __LITTLE_ENDIAN
+		dst[2] = r;
+		dst[1] = g;
+		dst[0] = b;
+#elif defined(__BIG_ENDIAN)
+		dst[0] = r;
+		dst[1] = g;
+		dst[2] = b;
+#endif
+		break;
+	case DRM_FORMAT_XRGB8888:
+	case DRM_FORMAT_ARGB8888:
+		r &= 0xff;
+		g &= 0xff;
+		b &= 0xff;
+		put_unaligned((u32)((r << 16) | (g << 8) | b), (u32*)dst);
+		break;
+	case DRM_FORMAT_ABGR8888:
+		r &= 0xff;
+		g &= 0xff;
+		b &= 0xff;
+		put_unaligned((u32)((b << 16) | (g << 8) | r), (u32*)dst);
+		break;
+	case DRM_FORMAT_XRGB2101010:
+	case DRM_FORMAT_ARGB2101010:
+		r &= 0x3ff;
+		g &= 0x3ff;
+		b &= 0x3ff;
+		put_unaligned((u32)((r << 20) | (g << 10) | b), (u32*)dst);
+		break;
+	}
+}
+
+static void sdrm_blit_from_xrgb8888(const u8 *src, u32 src_stride, u32 src_Bpp,
+				    u8 *dst, u32 dst_stride, u32 dst_Bpp,
+				    u32 dst_four_cc, u32 width, u32 height)
+{
+	u32 val, i;
+
+	while (height--) {
+		for (i = 0; i < width; ++i) {
+			val = get_unaligned((const u32*)&src[i * src_Bpp]);
+			sdrm_put(&dst[i * dst_Bpp], dst_four_cc,
+				 (val & 0x00ff0000U) >> 16,
+				 (val & 0x0000ff00U) >> 8,
+				 (val & 0x000000ffU));
+		}
+
+		src += src_stride;
+		dst += dst_stride;
+	}
+}
+
+static void sdrm_blit_from_rgb565(const u8 *src, u32 src_stride, u32 src_Bpp,
+				  u8 *dst, u32 dst_stride, u32 dst_Bpp,
+				  u32 dst_four_cc, u32 width, u32 height)
+{
+	u32 val, i;
+
+	while (height--) {
+		for (i = 0; i < width; ++i) {
+			val = get_unaligned((const u16*)&src[i * src_Bpp]);
+			sdrm_put(&dst[i * dst_Bpp], dst_four_cc,
+				 (val & 0xf800) >> 11,
+				 (val & 0x07e0) >> 5,
+				 (val & 0x001f));
+		}
+
+		src += src_stride;
+		dst += dst_stride;
+	}
+}
+
+static void sdrm_blit_lines(const u8 *src, u32 src_stride,
+			    u8 *dst, u32 dst_stride,
+			    u32 Bpp, u32 width, u32 height)
+{
+	u32 len;
+
+	len = width * Bpp;
+
+	while (height--) {
+		memcpy(dst, src, len);
+		src += src_stride;
+		dst += dst_stride;
+	}
+}
+
+static void sdrm_blit(struct sdrm_framebuffer *sfb, u32 x, u32 y,
+		      u32 width, u32 height)
+{
+	struct drm_framebuffer *fb = &sfb->base;
+	struct drm_device *ddev = fb->dev;
+	struct sdrm_device *sdrm = ddev->dev_private;
+	u32 src_Bpp, dst_Bpp, xoff, yoff, x2, y2;
+	u8 *src, *dst;
+
+	/* already unmapped; ongoing handover? */
+	if (!sdrm->fb_map)
+		return;
+
+	/* empty dirty-region, nothing to do */
+	if (!width || !height)
+		return;
+	if (x >= fb->width || y >= fb->height)
+		return;
+
+	/* sanity checks */
+	if (x + width < x)
+		width = fb->width - x;
+	if (y + height < y)
+		height = fb->height - y;
+
+	/* get scanout offsets */
+	xoff = 0;
+	yoff = 0;
+	if (sdrm->crtc.fb == fb) {
+		xoff = sdrm->crtc.x;
+		yoff = sdrm->crtc.y;
+	}
+
+	/* get intersection of dirty region and scan-out region */
+	x2 = min(x + width, xoff + sdrm->fb_width);
+	y2 = min(y + height, yoff + sdrm->fb_height);
+	x = max(x, xoff);
+	y = max(y, yoff);
+	if (x2 <= x || y2 <= y)
+		return;
+	width = x2 - x;
+	height = y2 - y;
+
+	/* get buffer offsets */
+	src = sfb->obj->vmapping;
+	dst = sdrm->fb_map;
+
+	/* bo is guaranteed to be big enough; size checks not needed */
+	src_Bpp = (fb->bits_per_pixel + 7) / 8;
+	src += fb->offsets[0] + y * fb->pitches[0] + x * src_Bpp;
+
+	dst_Bpp = (sdrm->fb_bpp + 7) / 8;
+	dst += (y - yoff) * sdrm->fb_stride + (x - xoff) * dst_Bpp;
+
+	/* if formats are identical, do a line-by-line copy.. */
+	if (fb->pixel_format == sdrm->fb_format) {
+		sdrm_blit_lines(src, fb->pitches[0],
+				dst, sdrm->fb_stride,
+				src_Bpp, width, height);
+		return;
+	}
+
+	/* ..otherwise call slow blit-function */
+	switch (fb->pixel_format) {
+	case DRM_FORMAT_ARGB8888:
+		/* fallthrough */
+	case DRM_FORMAT_XRGB8888:
+		sdrm_blit_from_xrgb8888(src, fb->pitches[0], src_Bpp,
+					dst, sdrm->fb_stride, dst_Bpp,
+					sdrm->fb_format, width, height);
+		break;
+	case DRM_FORMAT_RGB565:
+		sdrm_blit_from_rgb565(src, fb->pitches[0], src_Bpp,
+				      dst, sdrm->fb_stride, dst_Bpp,
+				      sdrm->fb_format, width, height);
+		break;
+	}
+}
+
+static int sdrm_begin_access(struct sdrm_framebuffer *sfb)
+{
+	int r;
+
+	r = sdrm_gem_get_pages(sfb->obj);
+	if (r)
+		return r;
+
+	if (!sfb->obj->base.import_attach)
+		return 0;
+
+	return dma_buf_begin_cpu_access(sfb->obj->base.import_attach->dmabuf,
+					0, sfb->obj->base.size,
+					DMA_FROM_DEVICE);
+}
+
+static void sdrm_end_access(struct sdrm_framebuffer *sfb)
+{
+	if (!sfb->obj->base.import_attach)
+		return;
+
+	dma_buf_end_cpu_access(sfb->obj->base.import_attach->dmabuf,
+			       0, sfb->obj->base.size,
+			       DMA_FROM_DEVICE);
+}
+
+int sdrm_dirty(struct drm_framebuffer *fb,
+	       struct drm_file *file,
+	       unsigned flags, unsigned color,
+	       struct drm_clip_rect *clips,
+	       unsigned num_clips)
+{
+	struct sdrm_framebuffer *sfb = to_sdrm_fb(fb);
+	struct drm_device *ddev = fb->dev;
+	struct sdrm_device *sdrm = ddev->dev_private;
+	unsigned int i;
+	int r;
+
+	drm_modeset_lock_all(ddev);
+
+	if (sdrm->crtc.fb != fb) {
+		r = 0;
+		goto unlock;
+	}
+
+	r = sdrm_begin_access(sfb);
+	if (r)
+		goto unlock;
+
+	for (i = 0; i < num_clips; i++) {
+		if (clips[i].x2 <= clips[i].x1 ||
+		    clips[i].y2 <= clips[i].y1)
+			continue;
+
+		sdrm_blit(sfb, clips[i].x1, clips[i].y1,
+			  clips[i].x2 - clips[i].x1,
+			  clips[i].y2 - clips[i].y1);
+	}
+
+	sdrm_end_access(sfb);
+
+unlock:
+	drm_modeset_unlock_all(ddev);
+	return 0;
+}
+
+int sdrm_dirty_all_locked(struct sdrm_device *sdrm)
+{
+	struct drm_framebuffer *fb;
+	struct sdrm_framebuffer *sfb;
+	int r;
+
+	fb = sdrm->crtc.fb;
+	if (!fb)
+		return 0;
+
+	sfb = to_sdrm_fb(fb);
+	r = sdrm_begin_access(sfb);
+	if (r)
+		return r;
+
+	sdrm_blit(sfb, 0, 0, fb->width, fb->height);
+
+	sdrm_end_access(sfb);
+
+	return 0;
+}
+
+int sdrm_dirty_all_unlocked(struct sdrm_device *sdrm)
+{
+	int r;
+
+	drm_modeset_lock_all(sdrm->ddev);
+	r = sdrm_dirty_all_locked(sdrm);
+	drm_modeset_unlock_all(sdrm->ddev);
+
+	return r;
+}
diff --git a/drivers/gpu/drm/simpledrm/simpledrm_gem.c b/drivers/gpu/drm/simpledrm/simpledrm_gem.c
new file mode 100644
index 0000000..f12c56c
--- /dev/null
+++ b/drivers/gpu/drm/simpledrm/simpledrm_gem.c
@@ -0,0 +1,282 @@
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
+#include <linux/dma-buf.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include <drm/drmP.h>
+#include "simpledrm.h"
+
+int sdrm_gem_get_pages(struct sdrm_gem_object *obj)
+{
+	size_t num, i;
+
+	if (obj->vmapping)
+		return 0;
+
+	if (obj->base.import_attach) {
+		obj->vmapping = dma_buf_vmap(obj->base.import_attach->dmabuf);
+		return !obj->vmapping ? -ENOMEM : 0;
+	}
+
+	num = obj->base.size >> PAGE_SHIFT;
+	obj->pages = drm_malloc_ab(num, sizeof(*obj->pages));
+	if (!obj->pages)
+		return -ENOMEM;
+
+	for (i = 0; i < num; ++i) {
+		obj->pages[i] = alloc_page(GFP_KERNEL | __GFP_ZERO);
+		if (!obj->pages[i])
+			goto error;
+	}
+
+	obj->vmapping = vmap(obj->pages, num, 0, PAGE_KERNEL);
+	if (!obj->vmapping)
+		goto error;
+
+	return 0;
+
+error:
+	while (i > 0)
+		__free_pages(obj->pages[--i], 0);
+
+	drm_free_large(obj->pages);
+	obj->pages = NULL;
+	return -ENOMEM;
+}
+
+static void sdrm_gem_put_pages(struct sdrm_gem_object *obj)
+{
+	size_t num, i;
+
+	if (!obj->vmapping)
+		return;
+
+	if (obj->base.import_attach) {
+		dma_buf_vunmap(obj->base.import_attach->dmabuf, obj->vmapping);
+		obj->vmapping = NULL;
+		return;
+	}
+
+	vunmap(obj->vmapping);
+	obj->vmapping = NULL;
+
+	num = obj->base.size >> PAGE_SHIFT;
+	for (i = 0; i < num; ++i)
+		__free_pages(obj->pages[i], 0);
+
+	drm_free_large(obj->pages);
+	obj->pages = NULL;
+}
+
+struct sdrm_gem_object *sdrm_gem_alloc_object(struct drm_device *ddev,
+					      size_t size)
+{
+	struct sdrm_gem_object *obj;
+
+	WARN_ON(!size || (size & ~PAGE_MASK) != 0);
+
+	obj = kzalloc(sizeof(*obj), GFP_KERNEL);
+	if (!obj)
+		return NULL;
+
+	drm_gem_private_object_init(ddev, &obj->base, size);
+	return obj;
+}
+
+void sdrm_gem_free_object(struct drm_gem_object *gobj)
+{
+	struct sdrm_gem_object *obj = to_sdrm_bo(gobj);
+	struct drm_device *ddev = gobj->dev;
+
+	if (obj->pages) {
+		/* kill all user-space mappings */
+		drm_vma_node_unmap(&gobj->vma_node, ddev->anon_inode->i_mapping);
+		sdrm_gem_put_pages(obj);
+	}
+
+	if (gobj->import_attach)
+		drm_prime_gem_destroy(gobj, obj->sg);
+
+	drm_gem_free_mmap_offset(gobj);
+	drm_gem_object_release(gobj);
+	kfree(obj);
+}
+
+int sdrm_dumb_create(struct drm_file *dfile, struct drm_device *ddev,
+		     struct drm_mode_create_dumb *args)
+{
+	struct sdrm_gem_object *obj;
+	int r;
+
+	if (args->flags)
+		return -EINVAL;
+
+	/* overflow checks are done by DRM core */
+	args->pitch = (args->bpp + 7) / 8 * args->width;
+	args->size = PAGE_ALIGN(args->pitch * args->height);
+
+	obj = sdrm_gem_alloc_object(ddev, args->size);
+	if (!obj)
+		return -ENOMEM;
+
+	r = drm_gem_handle_create(dfile, &obj->base, &args->handle);
+	if (r) {
+		drm_gem_object_unreference(&obj->base);
+		return r;
+	}
+
+	/* handle owns a reference */
+	drm_gem_object_unreference(&obj->base);
+	return 0;
+}
+
+int sdrm_dumb_destroy(struct drm_file *dfile, struct drm_device *ddev,
+		      uint32_t handle)
+{
+	return drm_gem_handle_delete(dfile, handle);
+}
+
+int sdrm_dumb_map_offset(struct drm_file *dfile, struct drm_device *ddev,
+			 uint32_t handle, uint64_t *offset)
+{
+	struct drm_gem_object *gobj;
+	int r;
+
+	mutex_lock(&ddev->struct_mutex);
+
+	gobj = drm_gem_object_lookup(ddev, dfile, handle);
+	if (!gobj) {
+		r = -ENOENT;
+		goto out_unlock;
+	}
+
+	r = drm_gem_create_mmap_offset(gobj);
+	if (r)
+		goto out_unref;
+
+	*offset = drm_vma_node_offset_addr(&gobj->vma_node);
+
+out_unref:
+	drm_gem_object_unreference(gobj);
+out_unlock:
+	mutex_unlock(&ddev->struct_mutex);
+	return r;
+}
+
+int sdrm_drm_mmap(struct file *filp, struct vm_area_struct *vma)
+{
+	struct drm_file *priv = filp->private_data;
+	struct drm_device *dev = priv->minor->dev;
+	struct drm_vma_offset_node *node;
+	struct drm_gem_object *gobj;
+	struct sdrm_gem_object *obj;
+	size_t size, i, num;
+	int r;
+
+	if (drm_device_is_unplugged(dev))
+		return -ENODEV;
+
+	mutex_lock(&dev->struct_mutex);
+
+	node = drm_vma_offset_exact_lookup(dev->vma_offset_manager,
+					   vma->vm_pgoff,
+					   vma_pages(vma));
+	if (!node) {
+		mutex_unlock(&dev->struct_mutex);
+		return drm_mmap(filp, vma);
+	} else if (!drm_vma_node_is_allowed(node, filp)) {
+		r = -EACCES;
+		goto out_unlock;
+	}
+
+	gobj = container_of(node, struct drm_gem_object, vma_node);
+	obj = to_sdrm_bo(gobj);
+	size = drm_vma_node_size(node) << PAGE_SHIFT;
+	if (size < vma->vm_end - vma->vm_start) {
+		r = -EINVAL;
+		goto out_unlock;
+	}
+
+	r = sdrm_gem_get_pages(obj);
+	if (r < 0)
+		goto out_unlock;
+
+	/* prevent dmabuf-imported mmap to user-space */
+	if (!obj->pages) {
+		r = -EACCES;
+		goto out_unlock;
+	}
+
+	vma->vm_flags |= VM_DONTEXPAND;
+	vma->vm_page_prot = pgprot_writecombine(vm_get_page_prot(vma->vm_flags));
+
+	num = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
+	for (i = 0; i < num; ++i) {
+		r = vm_insert_page(vma, vma->vm_start + i * PAGE_SIZE,
+				   obj->pages[i]);
+		if (r < 0) {
+			if (i > 0)
+				zap_vma_ptes(vma, vma->vm_start, i * PAGE_SIZE);
+			goto out_unlock;
+		}
+	}
+
+	r = 0;
+
+out_unlock:
+	mutex_unlock(&dev->struct_mutex);
+	return r;
+}
+
+struct drm_gem_object *sdrm_gem_prime_import(struct drm_device *ddev,
+					     struct dma_buf *dma_buf)
+{
+	struct dma_buf_attachment *attach;
+	struct sdrm_gem_object *obj;
+	struct sg_table *sg;
+	int ret;
+
+	/* need to attach */
+	attach = dma_buf_attach(dma_buf, ddev->dev);
+	if (IS_ERR(attach))
+		return ERR_CAST(attach);
+
+	get_dma_buf(dma_buf);
+
+	sg = dma_buf_map_attachment(attach, DMA_BIDIRECTIONAL);
+	if (IS_ERR(sg)) {
+		ret = PTR_ERR(sg);
+		goto fail_detach;
+	}
+
+	/* dma_buf_vmap() gives us a page-aligned mapping, so lets bump the
+	 * size of the dma-buf to the next page-boundary */
+	obj = sdrm_gem_alloc_object(ddev, PAGE_ALIGN(dma_buf->size));
+	if (!obj) {
+		ret = -ENOMEM;
+		goto fail_unmap;
+	}
+
+	obj->sg = sg;
+	obj->base.import_attach = attach;
+
+	return &obj->base;
+
+fail_unmap:
+	dma_buf_unmap_attachment(attach, sg, DMA_BIDIRECTIONAL);
+fail_detach:
+	dma_buf_detach(dma_buf, attach);
+	dma_buf_put(dma_buf);
+	return ERR_PTR(ret);
+}
diff --git a/drivers/gpu/drm/simpledrm/simpledrm_kms.c b/drivers/gpu/drm/simpledrm/simpledrm_kms.c
new file mode 100644
index 0000000..3e686bb
--- /dev/null
+++ b/drivers/gpu/drm/simpledrm/simpledrm_kms.c
@@ -0,0 +1,365 @@
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
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include <drm/drmP.h>
+#include <drm/drm_crtc.h>
+#include "simpledrm.h"
+
+/* crtcs */
+
+static int sdrm_crtc_set_config(struct drm_mode_set *set)
+{
+	struct drm_device *ddev;
+	struct sdrm_device *sdrm;
+	struct sdrm_framebuffer *fb;
+
+	if (!set || !set->crtc)
+		return -EINVAL;
+
+	ddev = set->crtc->dev;
+	sdrm = ddev->dev_private;
+
+	if (set->crtc != &sdrm->crtc)
+		return -EINVAL;
+
+	if (!set->mode || !set->fb || !set->num_connectors) {
+		sdrm->conn.encoder = NULL;
+		sdrm->conn.dpms = DRM_MODE_DPMS_OFF;
+		sdrm->enc.crtc = NULL;
+		sdrm->crtc.fb = NULL;
+		sdrm->crtc.enabled = false;
+		return 0;
+	}
+
+	fb = to_sdrm_fb(set->fb);
+
+	if (set->num_connectors != 1 || set->connectors[0] != &sdrm->conn)
+		return -EINVAL;
+	if (set->mode->hdisplay != sdrm->fb_width ||
+	    set->mode->vdisplay != sdrm->fb_height)
+		return -EINVAL;
+	if (fb->base.width <= set->x ||
+	    fb->base.height <= set->y ||
+	    fb->base.width - set->x < sdrm->fb_width ||
+	    fb->base.height - set->y < sdrm->fb_height)
+		return -EINVAL;
+
+	sdrm->conn.encoder = &sdrm->enc;
+	sdrm->conn.dpms = DRM_MODE_DPMS_ON;
+	sdrm->enc.crtc = &sdrm->crtc;
+	sdrm->crtc.fb = set->fb;
+	sdrm->crtc.enabled = true;
+	sdrm->crtc.mode = *set->mode;
+	sdrm->crtc.hwmode = *set->mode;
+	sdrm->crtc.x = set->x;
+	sdrm->crtc.y = set->y;
+
+	drm_calc_timestamping_constants(&sdrm->crtc, &sdrm->crtc.hwmode);
+	sdrm_dirty_all_locked(sdrm);
+	return 0;
+}
+
+static const struct drm_crtc_funcs sdrm_crtc_ops = {
+	.set_config = sdrm_crtc_set_config,
+	.destroy = drm_crtc_cleanup,
+};
+
+/* encoders */
+
+static const struct drm_encoder_funcs sdrm_enc_ops = {
+	.destroy = drm_encoder_cleanup,
+};
+
+/* connectors */
+
+static void sdrm_conn_dpms(struct drm_connector *conn, int mode)
+{
+	conn->dpms = mode;
+}
+
+static enum drm_connector_status sdrm_conn_detect(struct drm_connector *conn,
+						  bool force)
+{
+	/* We simulate an always connected monitor. simple-fb doesn't
+	 * provide any way to detect whether the connector is active. Hence,
+	 * signal DRM core that it is always connected. */
+
+	return connector_status_connected;
+}
+
+static int sdrm_conn_fill_modes(struct drm_connector *conn, uint32_t max_x,
+				uint32_t max_y)
+{
+	struct sdrm_device *sdrm = conn->dev->dev_private;
+	struct drm_display_mode *mode;
+	int r;
+
+	if (conn->force == DRM_FORCE_ON)
+		conn->status = connector_status_connected;
+	else if (conn->force)
+		conn->status = connector_status_disconnected;
+	else
+		conn->status = connector_status_connected;
+
+	list_for_each_entry(mode, &conn->modes, head)
+		mode->status = MODE_UNVERIFIED;
+
+	mode = drm_mode_create(sdrm->ddev);
+	if (!mode) {
+		r = 0;
+	} else {
+		/* some values with 10% vsync/hsync to make user-space happy */
+		mode->hdisplay = sdrm->fb_width;
+		mode->hsync_start = mode->hdisplay;
+		mode->hsync_end = mode->hdisplay * 11 / 10;
+		mode->htotal = mode->hsync_end;
+
+		mode->vdisplay = sdrm->fb_height;
+		mode->vsync_start = mode->vdisplay;
+		mode->vsync_end = mode->vdisplay * 11 / 10;
+		mode->vtotal = mode->vsync_end;
+
+		mode->vrefresh = 60;
+		mode->clock = mode->htotal * mode->vtotal * mode->vrefresh;
+		mode->clock /= 1000; /* Hz => kHz */
+		mode->type = DRM_MODE_TYPE_DRIVER | DRM_MODE_TYPE_PREFERRED;
+
+		mode->crtc_htotal = mode->htotal;
+		mode->crtc_vtotal = mode->vtotal;
+		mode->crtc_clock = mode->clock;
+
+		drm_mode_set_name(mode);
+		drm_mode_probed_add(conn, mode);
+		drm_mode_connector_list_update(conn);
+		r = 1;
+	}
+
+	if (max_x && max_y)
+		drm_mode_validate_size(conn->dev, &conn->modes,
+				       max_x, max_y, 0);
+
+	drm_mode_prune_invalid(conn->dev, &conn->modes, false);
+	if (list_empty(&conn->modes))
+		return 0;
+
+	drm_mode_sort(&conn->modes);
+
+	list_for_each_entry(mode, &conn->modes, head) {
+		mode->vrefresh = drm_mode_vrefresh(mode);
+		drm_mode_set_crtcinfo(mode, CRTC_INTERLACE_HALVE_V);
+	}
+
+	return r;
+}
+
+static void sdrm_conn_destroy(struct drm_connector *conn)
+{
+	/* Remove the fake-connector from sysfs and then let the DRM core
+	 * clean up all associated resources. */
+	drm_sysfs_connector_remove(conn);
+	drm_connector_cleanup(conn);
+}
+
+static const struct drm_connector_funcs sdrm_conn_ops = {
+	.dpms = sdrm_conn_dpms,
+	.detect = sdrm_conn_detect,
+	.fill_modes = sdrm_conn_fill_modes,
+	.destroy = sdrm_conn_destroy,
+};
+
+/* framebuffers */
+
+static int sdrm_fb_create_handle(struct drm_framebuffer *fb,
+				 struct drm_file *dfile,
+				 unsigned int *handle)
+{
+	struct sdrm_framebuffer *sfb = to_sdrm_fb(fb);
+
+	return drm_gem_handle_create(dfile, &sfb->obj->base, handle);
+}
+
+static void sdrm_fb_destroy(struct drm_framebuffer *fb)
+{
+	struct sdrm_framebuffer *sfb = to_sdrm_fb(fb);
+
+	drm_framebuffer_cleanup(fb);
+	drm_gem_object_unreference_unlocked(&sfb->obj->base);
+	kfree(sfb);
+}
+
+static const struct drm_framebuffer_funcs sdrm_fb_ops = {
+	.create_handle = sdrm_fb_create_handle,
+	.dirty = sdrm_dirty,
+	.destroy = sdrm_fb_destroy,
+};
+
+static struct drm_framebuffer *sdrm_fb_create(struct drm_device *ddev,
+					      struct drm_file *dfile,
+					      struct drm_mode_fb_cmd2 *cmd)
+{
+	struct sdrm_framebuffer *fb;
+	struct drm_gem_object *gobj;
+	u32 Bpp, size;
+	int ret;
+	void *err;
+
+	if (cmd->flags)
+		return ERR_PTR(-EINVAL);
+	if (cmd->pixel_format != DRM_FORMAT_ARGB8888 &&
+	    cmd->pixel_format != DRM_FORMAT_XRGB8888 &&
+	    cmd->pixel_format != DRM_FORMAT_RGB565)
+		return ERR_PTR(-EINVAL);
+
+	gobj = drm_gem_object_lookup(ddev, dfile, cmd->handles[0]);
+	if (!gobj)
+		return ERR_PTR(-EINVAL);
+
+	fb = kzalloc(sizeof(*fb), GFP_KERNEL);
+	if (!fb) {
+		err = ERR_PTR(-ENOMEM);
+		goto err_unref;
+	}
+	fb->obj = to_sdrm_bo(gobj);
+
+	fb->base.pitches[0] = cmd->pitches[0];
+	fb->base.offsets[0] = cmd->offsets[0];
+	fb->base.width = cmd->width;
+	fb->base.height = cmd->height;
+	fb->base.pixel_format = cmd->pixel_format;
+	drm_fb_get_bpp_depth(cmd->pixel_format, &fb->base.depth,
+			     &fb->base.bits_per_pixel);
+
+	/* width/height are already clamped into min/max_width/height range,
+	 * so overflows are not possible */
+
+	Bpp = (fb->base.bits_per_pixel + 7) / 8;
+	size = cmd->pitches[0] * cmd->height;
+	if (!Bpp ||
+	    Bpp > 4 ||
+	    cmd->pitches[0] < Bpp * fb->base.width ||
+	    cmd->pitches[0] > 0xffffU ||
+	    size + fb->base.offsets[0] < size ||
+	    size + fb->base.offsets[0] > fb->obj->base.size) {
+		err = ERR_PTR(-EINVAL);
+		goto err_free;
+	}
+
+	ret = drm_framebuffer_init(ddev, &fb->base, &sdrm_fb_ops);
+	if (ret < 0) {
+		err = ERR_PTR(ret);
+		goto err_free;
+	}
+
+	return &fb->base;
+
+err_free:
+	kfree(fb);
+err_unref:
+	drm_gem_object_unreference_unlocked(gobj);
+	return err;
+}
+
+static const struct drm_mode_config_funcs sdrm_mode_config_ops = {
+	.fb_create = sdrm_fb_create,
+};
+
+/* initialization */
+
+int sdrm_drm_load(struct drm_device *ddev, unsigned long flags)
+{
+	struct sdrm_device *sdrm;
+	int ret;
+
+	sdrm = kzalloc(sizeof(*sdrm), GFP_KERNEL);
+	if (!sdrm)
+		return -ENOMEM;
+
+	platform_set_drvdata(ddev->platformdev, ddev);
+	sdrm->ddev = ddev;
+	ddev->dev_private = sdrm;
+
+	ddev->devname = kstrdup("simpledrm", GFP_KERNEL);
+	if (!ddev->devname) {
+		ret = -ENOMEM;
+		goto err_free;
+	}
+
+	ret = sdrm_pdev_init(sdrm);
+	if (ret)
+		goto err_name;
+
+	drm_mode_config_init(ddev);
+	ddev->mode_config.min_width = 1;
+	ddev->mode_config.min_height = 1;
+	ddev->mode_config.max_width = 8192;
+	ddev->mode_config.max_height = 8192;
+	ddev->mode_config.funcs = &sdrm_mode_config_ops;
+
+	ret = drm_crtc_init(ddev, &sdrm->crtc, &sdrm_crtc_ops);
+	if (ret)
+		goto err_cleanup;
+
+	sdrm->enc.possible_crtcs = 1;
+	sdrm->enc.possible_clones = 0;
+	ret = drm_encoder_init(ddev, &sdrm->enc, &sdrm_enc_ops,
+			       DRM_MODE_ENCODER_VIRTUAL);
+	if (ret)
+		goto err_cleanup;
+
+	sdrm->conn.display_info.width_mm = 0;
+	sdrm->conn.display_info.height_mm = 0;
+	sdrm->conn.interlace_allowed = false;
+	sdrm->conn.doublescan_allowed = false;
+	sdrm->conn.polled = 0;
+	ret = drm_connector_init(ddev, &sdrm->conn, &sdrm_conn_ops,
+				 DRM_MODE_CONNECTOR_VIRTUAL);
+	if (ret)
+		goto err_cleanup;
+
+	ret = drm_mode_connector_attach_encoder(&sdrm->conn, &sdrm->enc);
+	if (ret)
+		goto err_cleanup;
+
+	ret = drm_mode_create_dirty_info_property(ddev);
+	if (ret)
+		goto err_cleanup;
+
+	ret = drm_sysfs_connector_add(&sdrm->conn);
+	if (ret)
+		goto err_cleanup;
+
+	return 0;
+
+err_cleanup:
+	drm_mode_config_cleanup(ddev);
+	sdrm_pdev_destroy(sdrm);
+err_name:
+	kfree(ddev->devname);
+	ddev->devname = NULL;
+err_free:
+	kfree(sdrm);
+	return ret;
+}
+
+int sdrm_drm_unload(struct drm_device *ddev)
+{
+	struct sdrm_device *sdrm = ddev->dev_private;
+
+	drm_mode_config_cleanup(ddev);
+	sdrm_pdev_destroy(sdrm);
+	kfree(sdrm);
+
+	return 0;
+}
-- 
1.8.5.3

