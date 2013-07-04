Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab3GDM1H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 08:27:07 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:51297 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755551Ab3GDM0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 08:26:39 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH v2 09/14] drm: add SimpleDRM driver
Date: Thu,  4 Jul 2013 14:25:09 +0200
Message-Id: <1372940714-12470-10-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1372940714-12470-1-git-send-email-dh.herrmann@gmail.com>
References: <1372940714-12470-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SimpleDRM driver binds to simple-framebuffer devices and provides a
DRM/KMS API. It provides only a single CRTC+encoder+connector combination
plus one initial mode.

Userspace can create one dumb-buffer and attach it to the CRTC. Only if
the buffer is destroyed, a new buffer can be created. The buffer is
directly mapped into user-space, so we have only resources for a single
buffer. Otherwise, shadow buffers plus damage-request would be needed.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 MAINTAINERS                                |   8 +
 drivers/gpu/drm/Kconfig                    |   2 +
 drivers/gpu/drm/Makefile                   |   1 +
 drivers/gpu/drm/simpledrm/Kconfig          |  18 ++
 drivers/gpu/drm/simpledrm/Makefile         |   5 +
 drivers/gpu/drm/simpledrm/simpledrm.h      |  89 ++++++++
 drivers/gpu/drm/simpledrm/simpledrm_drv.c  | 226 ++++++++++++++++++++
 drivers/gpu/drm/simpledrm/simpledrm_main.c | 328 +++++++++++++++++++++++++++++
 drivers/gpu/drm/simpledrm/simpledrm_mem.c  | 252 ++++++++++++++++++++++
 9 files changed, 929 insertions(+)
 create mode 100644 drivers/gpu/drm/simpledrm/Kconfig
 create mode 100644 drivers/gpu/drm/simpledrm/Makefile
 create mode 100644 drivers/gpu/drm/simpledrm/simpledrm.h
 create mode 100644 drivers/gpu/drm/simpledrm/simpledrm_drv.c
 create mode 100644 drivers/gpu/drm/simpledrm/simpledrm_main.c
 create mode 100644 drivers/gpu/drm/simpledrm/simpledrm_mem.c

diff --git a/MAINTAINERS b/MAINTAINERS
index ad7e322..b9aa4e4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7305,6 +7305,14 @@ S:	Odd Fixes
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
index b16c50e..b3ccef6 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -220,3 +220,5 @@ source "drivers/gpu/drm/omapdrm/Kconfig"
 source "drivers/gpu/drm/tilcdc/Kconfig"
 
 source "drivers/gpu/drm/qxl/Kconfig"
+
+source "drivers/gpu/drm/simpledrm/Kconfig"
diff --git a/drivers/gpu/drm/Makefile b/drivers/gpu/drm/Makefile
index 1c9f2439..59c424d 100644
--- a/drivers/gpu/drm/Makefile
+++ b/drivers/gpu/drm/Makefile
@@ -52,4 +52,5 @@ obj-$(CONFIG_DRM_SHMOBILE) +=shmobile/
 obj-$(CONFIG_DRM_OMAP)	+= omapdrm/
 obj-$(CONFIG_DRM_TILCDC)	+= tilcdc/
 obj-$(CONFIG_DRM_QXL) += qxl/
+obj-$(CONFIG_DRM_SIMPLEDRM) += simpledrm/
 obj-y			+= i2c/
diff --git a/drivers/gpu/drm/simpledrm/Kconfig b/drivers/gpu/drm/simpledrm/Kconfig
new file mode 100644
index 0000000..4f82844
--- /dev/null
+++ b/drivers/gpu/drm/simpledrm/Kconfig
@@ -0,0 +1,18 @@
+config DRM_SIMPLEDRM
+	tristate "Simple firmware framebuffer DRM driver"
+	depends on DRM && !FB_SIMPLE
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
index 0000000..2d474a5
--- /dev/null
+++ b/drivers/gpu/drm/simpledrm/Makefile
@@ -0,0 +1,5 @@
+ccflags-y := -Iinclude/drm
+
+simpledrm-y := simpledrm_drv.o simpledrm_main.o simpledrm_mem.o
+
+obj-$(CONFIG_DRM_SIMPLEDRM) := simpledrm.o
diff --git a/drivers/gpu/drm/simpledrm/simpledrm.h b/drivers/gpu/drm/simpledrm/simpledrm.h
new file mode 100644
index 0000000..977b344
--- /dev/null
+++ b/drivers/gpu/drm/simpledrm/simpledrm.h
@@ -0,0 +1,89 @@
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
+	struct sdrm_gem_object *fb_obj;
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
+/* simpledrm gem objects */
+
+struct sdrm_gem_object {
+	struct drm_gem_object base;
+	unsigned long fb_base;
+	unsigned long fb_size;
+};
+
+#define to_sdrm_bo(x) container_of(x, struct sdrm_gem_object, base)
+
+int sdrm_gem_init_object(struct drm_gem_object *obj);
+void sdrm_gem_free_object(struct drm_gem_object *obj);
+void sdrm_gem_unmap_object(struct sdrm_gem_object *obj);
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
diff --git a/drivers/gpu/drm/simpledrm/simpledrm_drv.c b/drivers/gpu/drm/simpledrm/simpledrm_drv.c
new file mode 100644
index 0000000..b774d5c
--- /dev/null
+++ b/drivers/gpu/drm/simpledrm/simpledrm_drv.c
@@ -0,0 +1,226 @@
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
+	.fasync = drm_fasync,
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
+	.gem_init_object = sdrm_gem_init_object,
+	.gem_free_object = sdrm_gem_free_object,
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
+	if (!request_mem_region(sdrm->fb_base, sdrm->fb_size,
+				"simple-framebuffer")) {
+		dev_err(sdrm->ddev->dev, "cannot reserve VMEM\n");
+		return -EIO;
+	}
+
+	sdrm->fb_map = ioremap_wc(sdrm->fb_base, sdrm->fb_size);
+	if (!sdrm->fb_map) {
+		dev_err(sdrm->ddev->dev, "cannot remap VMEM\n");
+		ret = -EIO;
+		goto err_region;
+	}
+
+	return 0;
+
+err_region:
+	release_mem_region(sdrm->fb_base, sdrm->fb_size);
+	return ret;
+}
+
+void sdrm_pdev_destroy(struct sdrm_device *sdrm)
+{
+	if (sdrm->fb_map) {
+		iounmap(sdrm->fb_map);
+		release_mem_region(sdrm->fb_base, sdrm->fb_size);
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
+	drm_platform_exit(&sdrm_drm_driver, pdev);
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
diff --git a/drivers/gpu/drm/simpledrm/simpledrm_main.c b/drivers/gpu/drm/simpledrm/simpledrm_main.c
new file mode 100644
index 0000000..ae507e3
--- /dev/null
+++ b/drivers/gpu/drm/simpledrm/simpledrm_main.c
@@ -0,0 +1,328 @@
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
+	if (set->x || set->y)
+		return -EINVAL;
+	if (set->mode->hdisplay != sdrm->fb_width ||
+	    set->mode->vdisplay != sdrm->fb_height)
+		return -EINVAL;
+
+	sdrm->conn.encoder = &sdrm->enc;
+	sdrm->conn.dpms = DRM_MODE_DPMS_ON;
+	sdrm->enc.crtc = &sdrm->crtc;
+	sdrm->crtc.fb = set->fb;
+	sdrm->crtc.enabled = true;
+	sdrm->crtc.mode = *set->mode;
+	sdrm->crtc.hwmode = *set->mode;
+	sdrm->crtc.x = 0;
+	sdrm->crtc.y = 0;
+
+	drm_calc_timestamping_constants(&sdrm->crtc);
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
+	int ret;
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
+	mode = drm_gtf_mode(sdrm->ddev, sdrm->fb_width, sdrm->fb_height,
+			    60, 0, 0);
+	if (mode) {
+		mode->type = DRM_MODE_TYPE_DRIVER | DRM_MODE_TYPE_PREFERRED;
+		drm_mode_probed_add(conn, mode);
+		sdrm->mode = mode;
+		drm_mode_connector_list_update(conn);
+		ret = 1;
+	} else {
+		ret = 0;
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
+	return ret;
+}
+
+static void sdrm_conn_destroy(struct drm_connector *conn)
+{
+	/* Remove the fake-connector from sysfs and then let the DRM core
+	 * clean up all associated resources. */
+	if (device_is_registered(&conn->kdev))
+		drm_sysfs_connector_remove(conn);
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
+	.destroy = sdrm_fb_destroy,
+};
+
+static struct drm_framebuffer *sdrm_fb_create(struct drm_device *ddev,
+					      struct drm_file *dfile,
+					      struct drm_mode_fb_cmd2 *cmd)
+{
+	struct sdrm_device *sdrm = ddev->dev_private;
+	struct sdrm_framebuffer *fb;
+	struct drm_gem_object *gobj;
+	int ret, i;
+	void *err;
+
+	if (cmd->flags || cmd->pixel_format != sdrm->fb_format)
+		return ERR_PTR(-EINVAL);
+	if (cmd->height != sdrm->fb_height || cmd->width != sdrm->fb_width)
+		return ERR_PTR(-EINVAL);
+	if (cmd->offsets[0] || cmd->pitches[0] != sdrm->fb_stride)
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
+	for (i = 1; i < 4; i++) {
+		fb->base.pitches[i] = 0;
+		fb->base.offsets[i] = 0;
+	}
+
+	fb->base.width = cmd->width;
+	fb->base.height = cmd->height;
+	fb->base.pixel_format = cmd->pixel_format;
+	drm_fb_get_bpp_depth(cmd->pixel_format, &fb->base.depth,
+			     &fb->base.bits_per_pixel);
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
+	ddev->mode_config.min_width = 0;
+	ddev->mode_config.min_height = 0;
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
diff --git a/drivers/gpu/drm/simpledrm/simpledrm_mem.c b/drivers/gpu/drm/simpledrm/simpledrm_mem.c
new file mode 100644
index 0000000..ba89be4
--- /dev/null
+++ b/drivers/gpu/drm/simpledrm/simpledrm_mem.c
@@ -0,0 +1,252 @@
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
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include <drm/drmP.h>
+#include "simpledrm.h"
+
+/*
+ * Create GEM Object
+ * Allocates a new GEM object to manage the physical memory at @fb_base with
+ * size @fb_size. Both parameters must be page-aligned and point to the
+ * physical memory of the framebuffer to manage. They must not have a
+ * "struct page" and have to be reserved before.
+ * It is the callers responsibility to create only one object per framebuffer.
+ */
+static struct sdrm_gem_object *sdrm_gem_alloc_object(struct drm_device *ddev,
+						     unsigned long fb_base,
+						     unsigned long fb_size)
+{
+	struct sdrm_gem_object *obj;
+
+	WARN_ON((fb_base & ~PAGE_MASK) != 0);
+	WARN_ON((fb_size & ~PAGE_MASK) != 0);
+
+	/* align to page-size */
+	fb_size = fb_size + (fb_base & ~PAGE_MASK);
+	fb_base = fb_base & PAGE_MASK;
+	fb_size = PAGE_ALIGN(fb_size);
+
+	if (fb_base + fb_size < fb_base)
+		return NULL;
+
+	obj = kzalloc(sizeof(*obj), GFP_KERNEL);
+	if (!obj)
+		return NULL;
+	obj->fb_base = fb_base;
+	obj->fb_size = fb_size;
+
+	if (drm_gem_private_object_init(ddev, &obj->base, fb_size)) {
+		kfree(obj);
+		return NULL;
+	}
+
+	return obj;
+}
+
+/* drm_gem_object_alloc() is not supported */
+int sdrm_gem_init_object(struct drm_gem_object *gobj)
+{
+	return -EINVAL;
+}
+
+/*
+ * Unmap GEM Object
+ * Destroy any memory-mappings that user-space created on this object. Note
+ * that this will cause SIGBUS errors if user-space continues writing to it.
+ * There is no way to remap the pages in fault-handlers as this is not what
+ * we want. You should destroy the mappings only when destroying the object
+ * so no remapping will be needed.
+ * It's the callers responsibility to prevent any further mappings. This only
+ * destroys all current mappings.
+ */
+void sdrm_gem_unmap_object(struct sdrm_gem_object *obj)
+{
+	struct drm_device *ddev = obj->base.dev;
+	loff_t off;
+
+	off = obj->base.map_list.hash.key << PAGE_SHIFT;
+	unmap_mapping_range(ddev->dev_mapping, off, obj->fb_size, 1);
+}
+
+/*
+ * Free GEM Object
+ * Frees the given GEM object. It does not release the framebuffer memory that
+ * was passed during allocation, but destroys all user-space mappings.
+ */
+void sdrm_gem_free_object(struct drm_gem_object *gobj)
+{
+	struct sdrm_gem_object *obj = to_sdrm_bo(gobj);
+	struct drm_device *ddev = gobj->dev;
+	struct sdrm_device *sdrm = ddev->dev_private;
+
+	if (sdrm->fb_obj == obj)
+		sdrm->fb_obj = NULL;
+
+	sdrm_gem_unmap_object(obj);
+
+	if (gobj->map_list.map)
+		drm_gem_free_mmap_offset(gobj);
+	drm_gem_object_release(gobj);
+	kfree(obj);
+}
+
+/*
+ * Create Dumb Buffer
+ * IOCTL backend for dumb-buffers. We only support one framebuffer per
+ * simple-DRM device so this function fails if there is already a framebuffer
+ * allocated. If not, an initial GEM-object plus framebuffer is created and
+ * forwarded to the caller.
+ *
+ * We could try to kill off the previous framebuffer and create a new one for
+ * the caller. However, user-space often allocates two buffers in a row to
+ * allow double-buffering. If we kill the previous buffer, user-space would
+ * have no chance to notice that only one buffer is available.
+ *
+ * So user-space must make sure they either destroy their buffer when dropping
+ * DRM-Master or leave the CRTC intact and let others share the buffer via
+ * drmModeGetFB().
+ *
+ * The buffer parameters must be the same as from the default-mode of the CRTC.
+ * No other sizes can be supported!
+ */
+int sdrm_dumb_create(struct drm_file *dfile, struct drm_device *ddev,
+		     struct drm_mode_create_dumb *args)
+{
+	struct drm_device *dev = dfile->minor->dev;
+	struct sdrm_device *sdrm = dev->dev_private;
+	struct sdrm_gem_object *obj;
+	int ret;
+
+	/* only allow one framebuffer at a time */
+	if (sdrm->fb_obj)
+		return -ENOMEM;
+
+	if (args->width != sdrm->fb_width ||
+	    args->height != sdrm->fb_height ||
+	    args->bpp != sdrm->fb_bpp ||
+	    args->flags)
+		return -EINVAL;
+
+	args->pitch = sdrm->fb_stride;
+	args->size = sdrm->fb_size;
+	obj = sdrm_gem_alloc_object(ddev, sdrm->fb_base, sdrm->fb_size);
+	if (!obj)
+		return -ENOMEM;
+
+	ret = drm_gem_handle_create(dfile, &obj->base, &args->handle);
+	if (ret) {
+		drm_gem_object_unreference(&obj->base);
+		return ret;
+	}
+
+	/* fb_obj is cleared by sdrm_gem_free_object() */
+	sdrm->fb_obj = obj;
+	drm_gem_object_unreference(&obj->base);
+
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
+	int ret;
+
+	mutex_lock(&ddev->struct_mutex);
+
+	gobj = drm_gem_object_lookup(ddev, dfile, handle);
+	if (!gobj) {
+		ret = -ENOENT;
+		goto out_unlock;
+	}
+
+	if (!gobj->map_list.map) {
+		ret = drm_gem_create_mmap_offset(gobj);
+		if (ret)
+			goto out_unref;
+	}
+
+	*offset = gobj->map_list.hash.key << PAGE_SHIFT;
+
+out_unref:
+	drm_gem_object_unreference(gobj);
+out_unlock:
+	mutex_unlock(&ddev->struct_mutex);
+	return ret;
+}
+
+/*
+ * mmap ioctl
+ * We simply map the physical range of the FB into user-space as requested. We
+ * perform few sanity-checks and then let io_remap_pfn_range() do all the work.
+ * No vma_ops are needed this way as pages are either cleared or present.
+ */
+int sdrm_drm_mmap(struct file *filp, struct vm_area_struct *vma)
+{
+	struct drm_file *priv = filp->private_data;
+	struct drm_device *dev = priv->minor->dev;
+	struct drm_gem_mm *mm = dev->mm_private;
+	struct drm_local_map *map;
+	struct drm_hash_item *item;
+	struct drm_gem_object *gobj;
+	struct sdrm_gem_object *obj;
+	unsigned long len;
+	int ret;
+
+	mutex_lock(&dev->struct_mutex);
+
+	if (drm_ht_find_item(&mm->offset_hash, vma->vm_pgoff, &item)) {
+		mutex_unlock(&dev->struct_mutex);
+		return drm_mmap(filp, vma);
+	}
+
+	map = drm_hash_entry(item, struct drm_map_list, hash)->map;
+	if (!map ||
+	    ((map->flags & _DRM_RESTRICTED) && !capable(CAP_SYS_ADMIN))) {
+		ret =  -EPERM;
+		goto out_unlock;
+	}
+
+	gobj = map->handle;
+	obj = to_sdrm_bo(gobj);
+
+	vma->vm_flags |= VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP;
+	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
+	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
+	/* FIXME: do we need fb_pgprotect() here? */
+
+	/* verify mapping size */
+	len = vma->vm_end - vma->vm_start;
+	if (len > obj->fb_size) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	/* This object is _not_ referenced here. Therefore, we _must_ destroy
+	 * the mapping before destroying the bo! */
+
+	ret = io_remap_pfn_range(vma, vma->vm_start, obj->fb_base >> PAGE_SHIFT,
+				 obj->fb_size, vma->vm_page_prot);
+
+out_unlock:
+	mutex_unlock(&dev->struct_mutex);
+	return ret;
+}
-- 
1.8.3.2

