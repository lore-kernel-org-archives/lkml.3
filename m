Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab3A0TCl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 14:02:41 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:56241 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618Ab3A0TCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 14:02:35 -0500
From: David Herrmann <dh.herrmann@googlemail.com>
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
        David Herrmann <dh.herrmann@googlemail.com>
Subject: [RFC v1] drm: new VESA BIOS Extension DRM driver
Date: Sun, 27 Jan 2013 20:00:49 +0100
Message-Id: <1359313249-2369-1-git-send-email-dh.herrmann@googlemail.com>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver uses the VESA BIOS Extensions to control the display device.
Modesetting has to be done during the boot-process by the architecture
code (same way as vesafb requires it). No runtime modesetting is allowed
due to RealMode/ProtectedMode restrictions.

The driver simply provides a single crtc+encoder+connector combination
that user-space can use to access the VBE framebuffer. No page-flips are
supported and users must explicitly mark buffers as dirty to get them
copied into the framebuffer.

All buffer objects are backed by shmem so we can later add PRIME support.
On dirty-ioctls we simply vmap the framebuffer memory and copy each pixel
into the target framebuffer. Unfortunately, the VBE bpp/depth combinations
cannot easily be forwarded to the user via the DRM API as it allows a lot
more combinations. Hence, we need to convert each pixel from the user's
buffer format into the target format while blitting.
Fast-paths for xrgb32/etc. could be implemented if we want to improve
blitting performance.

Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
---
Hi

This driver is a very basic DRM driver with roughly the same functionality as
vesafb but with a userspace API that doesn't suck. It is part of my effort to
replace the linux console with a user-space replacement.
This driver is basically meant as a replacement for vesafb+fbcon. I am still
working on a "drmlog" driver which can show the kernel-log (panics, oopses, ...)
on all connected monitors via the in-kernel DRM API. As I want to avoid using
the fbdev API, I thought a VBE DRM driver would be a really useful
thing to have as it works on all x86 hardware. I previously sent patches for an
"fblog" driver which does exactly that by using the in-kernel fbdev notifier.
However, the fbdev notifiers are so racy that I decided to do that with DRM
instead.

This driver currently lacks any shared-resource-control so you should not use
it in parallel with i915/nouveau/radeon/etc. We would have to add some mechanism
to unload it when a conflicting driver gets loaded.

We might also add some driver-specific ioctls to introduce real modesetting like
uvesafb provides so user-space can perform the VBE BIOS calls. However, I don't
really care for this as I am totally fine with the vga= kernel command-line.

There is still some stuff missing (unload on conflicting drivers) which I will
work on in the following weeks but I thought I'd first try to get some comments
from other developers. I tested this on a nvidia nv50 and i915 gen3 card and it
worked fine. Comments are welcome!

Some notes if you want to review the driver:
  dvbe_drv.c: Implements the platform_driver and probes a single device
  dvbe_main.c: Implements device loading/unloading and modesetting
  dvbe_mem.c: Memory management, dumb-buffers + framebuffers
  dvbe_vesa.c: VBE initialization and blitting functions

Regards
David

 drivers/gpu/drm/Kconfig          |   2 +
 drivers/gpu/drm/Makefile         |   1 +
 drivers/gpu/drm/dvbe/Kconfig     |  14 ++
 drivers/gpu/drm/dvbe/Makefile    |   4 +
 drivers/gpu/drm/dvbe/dvbe.h      |  98 +++++++++
 drivers/gpu/drm/dvbe/dvbe_drv.c  | 133 ++++++++++++
 drivers/gpu/drm/dvbe/dvbe_main.c | 432 +++++++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/dvbe/dvbe_mem.c  | 269 ++++++++++++++++++++++++
 drivers/gpu/drm/dvbe/dvbe_vesa.c | 242 ++++++++++++++++++++++
 9 files changed, 1195 insertions(+)
 create mode 100644 drivers/gpu/drm/dvbe/Kconfig
 create mode 100644 drivers/gpu/drm/dvbe/Makefile
 create mode 100644 drivers/gpu/drm/dvbe/dvbe.h
 create mode 100644 drivers/gpu/drm/dvbe/dvbe_drv.c
 create mode 100644 drivers/gpu/drm/dvbe/dvbe_main.c
 create mode 100644 drivers/gpu/drm/dvbe/dvbe_mem.c
 create mode 100644 drivers/gpu/drm/dvbe/dvbe_vesa.c

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 983201b..e116998 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -212,3 +212,5 @@ source "drivers/gpu/drm/cirrus/Kconfig"
 source "drivers/gpu/drm/shmobile/Kconfig"
 
 source "drivers/gpu/drm/tegra/Kconfig"
+
+source "drivers/gpu/drm/dvbe/Kconfig"
diff --git a/drivers/gpu/drm/Makefile b/drivers/gpu/drm/Makefile
index 6f58c81..daf3114 100644
--- a/drivers/gpu/drm/Makefile
+++ b/drivers/gpu/drm/Makefile
@@ -50,4 +50,5 @@ obj-$(CONFIG_DRM_UDL) += udl/
 obj-$(CONFIG_DRM_AST) += ast/
 obj-$(CONFIG_DRM_SHMOBILE) +=shmobile/
 obj-$(CONFIG_DRM_TEGRA) += tegra/
+obj-$(CONFIG_DRM_DVBE) += dvbe/
 obj-y			+= i2c/
diff --git a/drivers/gpu/drm/dvbe/Kconfig b/drivers/gpu/drm/dvbe/Kconfig
new file mode 100644
index 0000000..a5277c6
--- /dev/null
+++ b/drivers/gpu/drm/dvbe/Kconfig
@@ -0,0 +1,14 @@
+config DRM_DVBE
+	tristate "VESA BIOS Extension DRM Driver"
+	depends on DRM
+	select DRM_KMS_HELPER
+	help
+	  This is a DRM/KMS driver for VESA BIOS Extension (VBE) compatible
+	  cards. It does not allow mode-switching during runtime but requires
+	  the kernel to setup the mode with the vga= kernel command line
+	  option.
+
+	  If unsure, say N.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called dvbe.
diff --git a/drivers/gpu/drm/dvbe/Makefile b/drivers/gpu/drm/dvbe/Makefile
new file mode 100644
index 0000000..f6fb888
--- /dev/null
+++ b/drivers/gpu/drm/dvbe/Makefile
@@ -0,0 +1,4 @@
+ccflags-y := -Iinclude/drm
+
+dvbe-y := dvbe_drv.o dvbe_main.o dvbe_mem.o dvbe_vesa.o
+obj-$(CONFIG_DRM_DVBE) := dvbe.o
diff --git a/drivers/gpu/drm/dvbe/dvbe.h b/drivers/gpu/drm/dvbe/dvbe.h
new file mode 100644
index 0000000..68fd452
--- /dev/null
+++ b/drivers/gpu/drm/dvbe/dvbe.h
@@ -0,0 +1,98 @@
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
+#ifndef DVBE_DRV_H
+#define DVBE_DRV_H
+
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include <drm/drmP.h>
+
+/* dvbe devices */
+
+struct dvbe_device {
+	struct drm_device *ddev;
+
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
+	/* mode-setting objects */
+	struct drm_crtc crtc;
+	struct drm_encoder enc;
+	struct drm_connector conn;
+	struct drm_display_mode *mode;
+};
+
+int dvbe_drm_load(struct drm_device *ddev, unsigned long flags);
+int dvbe_drm_unload(struct drm_device *ddev);
+int dvbe_drm_mmap(struct file *filp, struct vm_area_struct *vma);
+
+/* dvbe gem objects */
+
+struct dvbe_gem_object {
+	struct drm_gem_object base;
+	struct page **pages;
+	uint8_t *vmapping;
+};
+
+#define to_dvbe_bo(x) container_of(x, struct dvbe_gem_object, base)
+
+int dvbe_gem_init_object(struct drm_gem_object *obj);
+void dvbe_gem_free_object(struct drm_gem_object *obj);
+int dvbe_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf);
+int dvbe_gem_vmap(struct dvbe_gem_object *obj);
+void dvbe_gem_vunmap(struct dvbe_gem_object *obj);
+
+/* dumb buffers */
+
+int dvbe_dumb_create(struct drm_file *file_priv, struct drm_device *ddev,
+		     struct drm_mode_create_dumb *arg);
+int dvbe_dumb_destroy(struct drm_file *file_priv, struct drm_device *ddev,
+		      uint32_t handle);
+int dvbe_dumb_map_offset(struct drm_file *file_priv, struct drm_device *ddev,
+			 uint32_t handle, uint64_t *offset);
+
+/* dvbe framebuffers */
+
+struct dvbe_framebuffer {
+	struct drm_framebuffer base;
+	struct dvbe_gem_object *obj;
+};
+
+#define to_dvbe_fb(x) container_of(x, struct dvbe_framebuffer, base)
+
+/* vesa helpers */
+
+int dvbe_vesa_init(struct dvbe_device *dvbe);
+void dvbe_vesa_cleanup(struct dvbe_device *dvbe);
+int dvbe_vesa_damage(struct dvbe_device *dvbe, struct dvbe_framebuffer *fb,
+		     unsigned int flags, unsigned int color,
+		     struct drm_clip_rect *clips, unsigned int num);
+
+#endif /* DVBE_DRV_H */
diff --git a/drivers/gpu/drm/dvbe/dvbe_drv.c b/drivers/gpu/drm/dvbe/dvbe_drv.c
new file mode 100644
index 0000000..daeab16
--- /dev/null
+++ b/drivers/gpu/drm/dvbe/dvbe_drv.c
@@ -0,0 +1,133 @@
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
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/string.h>
+#include <drm/drmP.h>
+#include "dvbe.h"
+
+static const struct vm_operations_struct dvbe_gem_vm_ops = {
+	.fault = dvbe_gem_fault,
+	.open = drm_gem_vm_open,
+	.close = drm_gem_vm_close,
+};
+
+static const struct file_operations dvbe_drm_fops = {
+	.owner = THIS_MODULE,
+	.open = drm_open,
+	.mmap = dvbe_drm_mmap,
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
+static struct drm_driver dvbe_drm_driver = {
+	.driver_features = DRIVER_MODESET | DRIVER_GEM,
+	.load = dvbe_drm_load,
+	.unload = dvbe_drm_unload,
+	.fops = &dvbe_drm_fops,
+
+	.gem_init_object = dvbe_gem_init_object,
+	.gem_free_object = dvbe_gem_free_object,
+	.gem_vm_ops = &dvbe_gem_vm_ops,
+
+	.dumb_create = dvbe_dumb_create,
+	.dumb_map_offset = dvbe_dumb_map_offset,
+	.dumb_destroy = dvbe_dumb_destroy,
+
+	.name = "dvbe",
+	.desc = "DRM VESA BIOS Extension Driver",
+	.date = "20130127",
+	.major = 0,
+	.minor = 0,
+	.patchlevel = 1,
+};
+
+#ifdef CONFIG_PM_SLEEP
+static int dvbe_platform_suspend(struct device *dev)
+{
+	return 0;
+}
+
+static int dvbe_platform_resume(struct device *dev)
+{
+	return 0;
+}
+#endif
+
+static const struct dev_pm_ops dvbe_platform_pm = {
+	SET_SYSTEM_SLEEP_PM_OPS(dvbe_platform_suspend, dvbe_platform_resume)
+};
+
+static int dvbe_platform_probe(struct platform_device *pdev)
+{
+	return drm_platform_init(&dvbe_drm_driver, pdev);
+}
+
+static int dvbe_platform_remove(struct platform_device *pdev)
+{
+	drm_platform_exit(&dvbe_drm_driver, pdev);
+
+	return 0;
+}
+
+static struct platform_driver dvbe_platform_driver = {
+	.probe = dvbe_platform_probe,
+	.remove = dvbe_platform_remove,
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = "drm-dvbe",
+		.pm = &dvbe_platform_pm,
+	},
+};
+
+static struct platform_device *dvbe_platform_dev;
+
+static int __init dvbe_init(void)
+{
+	int ret;
+
+	ret = platform_driver_register(&dvbe_platform_driver);
+	if (ret)
+		return ret;
+
+	dvbe_platform_dev = platform_device_register_simple("drm-dvbe", -1,
+							    NULL, 0);
+	if (IS_ERR(dvbe_platform_dev)) {
+		platform_driver_unregister(&dvbe_platform_driver);
+		return PTR_ERR(dvbe_platform_dev);
+	}
+
+	return 0;
+}
+
+static void __exit dvbe_exit(void)
+{
+	platform_device_unregister(dvbe_platform_dev);
+	platform_driver_unregister(&dvbe_platform_driver);
+}
+
+module_init(dvbe_init);
+module_exit(dvbe_exit);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("David Herrmann <dh.herrmann@gmail.com>");
+MODULE_DESCRIPTION("DRM VESA BIOS Extension Driver");
diff --git a/drivers/gpu/drm/dvbe/dvbe_main.c b/drivers/gpu/drm/dvbe/dvbe_main.c
new file mode 100644
index 0000000..5950d21
--- /dev/null
+++ b/drivers/gpu/drm/dvbe/dvbe_main.c
@@ -0,0 +1,432 @@
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
+ * Main Modesetting and Control
+ * We register exactly one CRTC, encoder and connector on initialization. This
+ * simplifies the logic a lot. The actual device control is not implemented
+ * here. This file only provides the interaction with DRM core.
+ *
+ * Userspace has only one valid CRTC+encoder+connector combination which
+ * corresponds to the VESA framebuffer that we detected. The initial mode is
+ * deduced from the initial VESA configuration and should be used by user-space.
+ * Real mode-setting (i.e., changing display resolution) requires the processor
+ * to be in RealMode, which we cannot do in the kernel so it is not provided.
+ * Driver-specific ioctls may be used to allow userspace to perform mode-setting
+ * themself.
+ */
+
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include <drm/drmP.h>
+#include <drm/drm_crtc_helper.h>
+#include "dvbe.h"
+
+/* crtcs */
+
+static void dvbe_crtc_dpms(struct drm_crtc *crtc, int mode)
+{
+	/* There is no way to tell DRM core that we do not support DPMS.
+	 * Therefore, simply make this a no-op and always be online. */
+}
+
+static bool dvbe_crtc_mode_fixup(struct drm_crtc *crtc,
+				 const struct drm_display_mode *mode,
+				 struct drm_display_mode *adjusted_mode)
+{
+	struct dvbe_device *dvbe = crtc->dev->dev_private;
+
+	if (mode->hdisplay != dvbe->vbe_width ||
+	    mode->vdisplay != dvbe->vbe_height) {
+		dev_dbg(dvbe->ddev->dev, "invalid mode %ux%u\n",
+			mode->hdisplay, mode->vdisplay);
+		return false;
+	}
+
+	drm_mode_copy(adjusted_mode, mode);
+	return true;
+}
+
+static void dvbe_crtc_prepare(struct drm_crtc *crtc)
+{
+	/* nothing to prepare */
+}
+
+static void dvbe_crtc_commit(struct drm_crtc *crtc)
+{
+	/* all work already done by immediate mode-set */
+}
+
+static int dvbe_crtc_mode_set(struct drm_crtc *crtc,
+			      struct drm_display_mode *mode,
+			      struct drm_display_mode *adjusted_mode,
+			      int x, int y,
+			      struct drm_framebuffer *old_fb)
+{
+	struct dvbe_device *dvbe = crtc->dev->dev_private;
+	struct dvbe_framebuffer *dfb = to_dvbe_fb(crtc->fb);
+
+	/* We can scan out any framebuffer that is given. The framebuffer
+	 * allocation guarantees that it is a valid framebuffer. If the x/y
+	 * corrdinates are out of bounds, we fail. We don't care whether the
+	 * framebuffer is bigger/smaller than the real screen. The
+	 * blit-functions clip it correctly.
+	 * The mode was already checked by mode_fixup above so we can savely let
+	 * it pass. */
+
+	if (x >= dfb->base.width || y >= dfb->base.height)
+		return -EINVAL;
+
+	return dvbe_vesa_damage(dvbe, dfb, 0, 0, NULL, 0);
+}
+
+/*
+ * Shortcut if no full mode-set is needed but only the offsets or framebuffer
+ * parameters changed. See @mode_set for details.
+ */
+static int dvbe_crtc_mode_set_base(struct drm_crtc *crtc, int x, int y,
+				   struct drm_framebuffer *fb)
+{
+	struct dvbe_device *dvbe = crtc->dev->dev_private;
+	struct dvbe_framebuffer *dfb = to_dvbe_fb(crtc->fb);
+
+	if (x >= dfb->base.width || y >= dfb->base.height)
+		return -EINVAL;
+
+	return dvbe_vesa_damage(dvbe, dfb, 0, 0, NULL, 0);
+}
+
+static const struct drm_crtc_helper_funcs dvbe_crtc_helper_ops = {
+	.dpms = dvbe_crtc_dpms,
+	.mode_fixup = dvbe_crtc_mode_fixup,
+	.prepare = dvbe_crtc_prepare,
+	.commit = dvbe_crtc_commit,
+	.mode_set = dvbe_crtc_mode_set,
+	.mode_set_base = dvbe_crtc_mode_set_base,
+};
+
+static const struct drm_crtc_funcs dvbe_crtc_ops = {
+	.destroy = drm_crtc_cleanup,
+	.set_config = drm_crtc_helper_set_config,
+};
+
+/* encoders */
+
+static void dvbe_enc_dpms(struct drm_encoder *enc, int mode)
+{
+	/* DPMS is done by the CRTC */
+}
+
+static bool dvbe_enc_mode_fixup(struct drm_encoder *enc,
+				const struct drm_display_mode *mode,
+				struct drm_display_mode *adjusted_mode)
+{
+	/* mode-fixup is done by the CRTC */
+	return true;
+}
+
+static void dvbe_enc_prepare(struct drm_encoder *enc)
+{
+	/* no preparation to do */
+}
+
+static void dvbe_enc_mode_set(struct drm_encoder *enc,
+			      struct drm_display_mode *mode,
+			      struct drm_display_mode *adjusted_mode)
+{
+	/* mode-setting is done by the CRTC */
+}
+
+static void dvbe_enc_commit(struct drm_encoder *enc)
+{
+	/* committing mode changes is done by the CRTC */
+}
+
+static const struct drm_encoder_helper_funcs dvbe_enc_helper_ops = {
+	.dpms = dvbe_enc_dpms,
+	.mode_fixup = dvbe_enc_mode_fixup,
+	.prepare = dvbe_enc_prepare,
+	.mode_set = dvbe_enc_mode_set,
+	.commit = dvbe_enc_commit,
+};
+
+static const struct drm_encoder_funcs dvbe_enc_ops = {
+	.destroy = drm_encoder_cleanup,
+};
+
+/* connectors */
+
+static int dvbe_conn_get_modes(struct drm_connector *conn)
+{
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
+}
+
+static int dvbe_conn_mode_valid(struct drm_connector *conn,
+				struct drm_display_mode *mode)
+{
+	/* every mode of our own is valid */
+	return MODE_OK;
+}
+
+static struct drm_encoder *dvbe_conn_best_encoder(struct drm_connector *conn)
+{
+	struct dvbe_device *dvbe = conn->dev->dev_private;
+
+	/* We only have a single encoder for the VBE device. Hence, return it
+	 * as best-encoder so it is always used. There is no real encoder that
+	 * we control as VBE doesn't provide such information. */
+	return &dvbe->enc;
+}
+
+static const struct drm_connector_helper_funcs dvbe_conn_helper_ops = {
+	.get_modes = dvbe_conn_get_modes,
+	.mode_valid = dvbe_conn_mode_valid,
+	.best_encoder = dvbe_conn_best_encoder,
+};
+
+static enum drm_connector_status dvbe_conn_detect(struct drm_connector *conn,
+						  bool force)
+{
+	/* We simulate an always connected monitor. The VESA ABI doesn't
+	 * provide any way to detect whether the connector is active. Hence,
+	 * signal DRM core that it is always connected. */
+	return connector_status_connected;
+}
+
+static void dvbe_conn_destroy(struct drm_connector *conn)
+{
+	/* Remove the fake-connector from sysfs and then let the DRM core
+	 * clean up all associated resources. */
+	if (device_is_registered(&conn->kdev))
+		drm_sysfs_connector_remove(conn);
+	drm_connector_cleanup(conn);
+}
+
+static const struct drm_connector_funcs dvbe_conn_ops = {
+	.dpms = drm_helper_connector_dpms,
+	.detect = dvbe_conn_detect,
+	.fill_modes = drm_helper_probe_single_connector_modes,
+	.destroy = dvbe_conn_destroy,
+};
+
+/* framebuffers */
+
+static int dvbe_fb_create_handle(struct drm_framebuffer *fb,
+				 struct drm_file *dfile,
+				 unsigned int *handle)
+{
+	struct dvbe_framebuffer *dfb = to_dvbe_fb(fb);
+
+	return drm_gem_handle_create(dfile, &dfb->obj->base, handle);
+}
+
+static int dvbe_fb_dirty(struct drm_framebuffer *fb, struct drm_file *file,
+			 unsigned int flags, unsigned int color,
+			 struct drm_clip_rect *clips, unsigned int num)
+{
+	struct dvbe_device *dvbe = fb->dev->dev_private;
+	struct dvbe_framebuffer *dfb = to_dvbe_fb(fb);
+
+	if (dvbe->crtc.fb != fb)
+		return 0;
+
+	return dvbe_vesa_damage(dvbe, dfb, flags, color, clips, num);
+}
+
+static void dvbe_fb_destroy(struct drm_framebuffer *fb)
+{
+	struct dvbe_framebuffer *dfb = to_dvbe_fb(fb);
+
+	drm_framebuffer_cleanup(fb);
+	drm_gem_object_unreference_unlocked(&dfb->obj->base);
+	kfree(dfb);
+}
+
+static const struct drm_framebuffer_funcs dvbe_fb_ops = {
+	.create_handle = dvbe_fb_create_handle,
+	.dirty = dvbe_fb_dirty,
+	.destroy = dvbe_fb_destroy,
+};
+
+static struct drm_framebuffer *dvbe_fb_create(struct drm_device *ddev,
+					      struct drm_file *dfile,
+					      struct drm_mode_fb_cmd2 *cmd)
+{
+	struct dvbe_framebuffer *dfb;
+	int ret;
+	struct drm_gem_object *dobj;
+	unsigned int Bpp;
+	size_t siz;
+	void *err;
+
+	if (cmd->flags)
+		return ERR_PTR(-EINVAL);
+
+	switch (cmd->pixel_format) {
+	case DRM_FORMAT_RGB565:
+	case DRM_FORMAT_BGR565:
+		Bpp = 2;
+		break;
+	case DRM_FORMAT_XRGB8888:
+	case DRM_FORMAT_ARGB8888:
+	case DRM_FORMAT_XBGR8888:
+	case DRM_FORMAT_ABGR8888:
+		Bpp = 4;
+		break;
+	default:
+		return ERR_PTR(-EINVAL);
+	}
+
+	siz = cmd->pitches[0] * (cmd->height - 1) +
+	      Bpp * cmd->width + cmd->offsets[0];
+
+	dobj = drm_gem_object_lookup(ddev, dfile, cmd->handles[0]);
+	if (!dobj)
+		return ERR_PTR(-EINVAL);
+	if (dobj->size < siz) {
+		err = ERR_PTR(-ENOMEM);
+		goto err_unref;
+	}
+
+	dfb = kzalloc(sizeof(*dfb), GFP_KERNEL);
+	if (!dfb) {
+		err = ERR_PTR(-ENOMEM);
+		goto err_unref;
+	}
+	dfb->obj = to_dvbe_bo(dobj);
+
+	ret = drm_helper_mode_fill_fb_struct(&dfb->base, cmd);
+	if (ret < 0) {
+		err = ERR_PTR(ret);
+		goto err_free;
+	}
+
+	ret = drm_framebuffer_init(ddev, &dfb->base, &dvbe_fb_ops);
+	if (ret < 0) {
+		err = ERR_PTR(ret);
+		goto err_free;
+	}
+
+	return &dfb->base;
+
+err_free:
+	kfree(dfb);
+err_unref:
+	drm_gem_object_unreference_unlocked(dobj);
+	return err;
+}
+
+static const struct drm_mode_config_funcs dvbe_mode_config_ops = {
+	.fb_create = dvbe_fb_create,
+};
+
+/* initialization */
+
+int dvbe_drm_load(struct drm_device *ddev, unsigned long flags)
+{
+	struct dvbe_device *dvbe;
+	struct platform_device *pdev = ddev->platformdev;
+	int ret;
+
+	dvbe = kzalloc(sizeof(*dvbe), GFP_KERNEL);
+	if (!dvbe)
+		return -ENOMEM;
+
+	dvbe->ddev = ddev;
+	ddev->dev_private = dvbe;
+
+	ret = dvbe_vesa_init(dvbe);
+	if (ret)
+		goto err_free;
+
+	drm_mode_config_init(ddev);
+	ddev->mode_config.min_width = 0;
+	ddev->mode_config.min_height = 0;
+	ddev->mode_config.max_width = 4095;
+	ddev->mode_config.max_height = 4095;
+	ddev->mode_config.funcs = &dvbe_mode_config_ops;
+
+	ret = drm_mode_create_dirty_info_property(ddev);
+	if (ret)
+		goto err_cleanup;
+
+	ret = drm_crtc_init(ddev, &dvbe->crtc, &dvbe_crtc_ops);
+	if (ret)
+		goto err_cleanup;
+	drm_crtc_helper_add(&dvbe->crtc, &dvbe_crtc_helper_ops);
+
+	dvbe->enc.possible_crtcs = 1;
+	dvbe->enc.possible_clones = 0;
+	ret = drm_encoder_init(ddev, &dvbe->enc, &dvbe_enc_ops,
+			       DRM_MODE_ENCODER_VIRTUAL);
+	if (ret)
+		goto err_cleanup;
+	drm_encoder_helper_add(&dvbe->enc, &dvbe_enc_helper_ops);
+
+	dvbe->conn.display_info.width_mm = 0;
+	dvbe->conn.display_info.height_mm = 0;
+	dvbe->conn.interlace_allowed = false;
+	dvbe->conn.doublescan_allowed = false;
+	dvbe->conn.polled = 0;
+	ret = drm_connector_init(ddev, &dvbe->conn, &dvbe_conn_ops,
+				 DRM_MODE_CONNECTOR_VIRTUAL);
+	if (ret)
+		goto err_cleanup;
+	drm_connector_helper_add(&dvbe->conn, &dvbe_conn_helper_ops);
+
+	drm_object_attach_property(&dvbe->conn.base,
+				   ddev->mode_config.dirty_info_property, 1);
+
+	ret = drm_mode_connector_attach_encoder(&dvbe->conn, &dvbe->enc);
+	if (ret)
+		goto err_cleanup;
+
+	ret = drm_sysfs_connector_add(&dvbe->conn);
+	if (ret)
+		goto err_cleanup;
+
+	platform_set_drvdata(pdev, dvbe);
+	return 0;
+
+err_cleanup:
+	drm_mode_config_cleanup(ddev);
+	dvbe_vesa_cleanup(dvbe);
+err_free:
+	kfree(dvbe);
+	return ret;
+}
+
+int dvbe_drm_unload(struct drm_device *ddev)
+{
+	struct dvbe_device *dvbe = ddev->dev_private;
+
+	drm_mode_config_cleanup(ddev);
+	dvbe_vesa_cleanup(dvbe);
+	kfree(dvbe);
+
+	return 0;
+}
diff --git a/drivers/gpu/drm/dvbe/dvbe_mem.c b/drivers/gpu/drm/dvbe/dvbe_mem.c
new file mode 100644
index 0000000..211aebf
--- /dev/null
+++ b/drivers/gpu/drm/dvbe/dvbe_mem.c
@@ -0,0 +1,269 @@
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
+ * DVBA Memory Objects
+ * Due to the limited functionality of the VESA ABI, we support only one memory
+ * object type which is the framebuffer object. To allow file-descriptors for
+ * frambuffers we use shmem storage for all gem objects.
+ *
+ * Furthermore, we use lazy storage allocation. As long as the storage isn't
+ * mapped or accessed, we do not allocate it. If it is mapped, we allocate an
+ * array of pointers to the pages so we can easily vmap/vunmap it for CPU
+ * access.
+ */
+
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/shmem_fs.h>
+#include <linux/string.h>
+#include <drm/drmP.h>
+#include <drm/drm_mem_util.h>
+#include "dvbe.h"
+
+static struct dvbe_gem_object *dvbe_gem_alloc_object(struct drm_device *ddev,
+						     size_t size)
+{
+	struct dvbe_gem_object *obj;
+
+	BUG_ON((size & (PAGE_SIZE - 1)) != 0);
+
+	obj = kzalloc(sizeof(*obj), GFP_KERNEL);
+	if (!obj)
+		return NULL;
+
+	if (drm_gem_object_init(ddev, &obj->base, size)) {
+		kfree(obj);
+		return NULL;
+	}
+
+	return obj;
+}
+
+/*
+ * First time user-space requests access to a gem object, we allocate an array
+ * of all backing pages so our page-fault handler can map them efficiently.
+ * shmem_read_mapping_page_gfp allocates missing pages with the given GFP mask
+ * which we deduce from the tmpfs-dentry object.
+ */
+static int dvbe_gem_get_pages(struct dvbe_gem_object *obj)
+{
+	size_t i, page_count = obj->base.size / PAGE_SIZE;
+	struct page *page;
+	struct address_space *mapping;
+	gfp_t gfp;
+
+	if (obj->pages)
+		return 0;
+
+	obj->pages = drm_malloc_ab(page_count, sizeof(struct page*));
+	if (!obj->pages)
+		return -ENOMEM;
+
+	mapping = obj->base.filp->f_path.dentry->d_inode->i_mapping;
+	gfp = mapping_gfp_mask(mapping) | GFP_KERNEL;
+
+	for (i = 0; i < page_count; ++i) {
+		page = shmem_read_mapping_page_gfp(mapping, i, gfp);
+		if (IS_ERR(page))
+			goto err_pages;
+
+		obj->pages[i] = page;
+	}
+
+	return 0;
+
+err_pages:
+	while (i--)
+		page_cache_release(obj->pages[i]);
+	drm_free_large(obj->pages);
+	obj->pages = NULL;
+	return PTR_ERR(page);
+}
+
+static void dvbe_gem_put_pages(struct dvbe_gem_object *obj)
+{
+	size_t i, page_count = obj->base.size / PAGE_SIZE;
+
+	if (!obj->pages)
+		return;
+
+	for (i = 0; i < page_count; ++i)
+		page_cache_release(obj->pages[i]);
+
+	drm_free_large(obj->pages);
+	obj->pages = NULL;
+}
+
+int dvbe_gem_vmap(struct dvbe_gem_object *obj)
+{
+	int ret, page_count = obj->base.size / PAGE_SIZE;
+
+	if (obj->vmapping)
+		return 0;
+
+	ret = dvbe_gem_get_pages(obj);
+	if (ret)
+		return ret;
+
+	obj->vmapping = vmap(obj->pages, page_count, 0, PAGE_KERNEL);
+	if (!obj->vmapping)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void dvbe_gem_vunmap(struct dvbe_gem_object *obj)
+{
+	if (!obj->vmapping)
+		return;
+
+	vunmap(obj->vmapping);
+	obj->vmapping = NULL;
+}
+
+/* drm_gem_object_alloc() is not supported */
+int dvbe_gem_init_object(struct drm_gem_object *gobj)
+{
+	BUG();
+
+	return -EINVAL;
+}
+
+void dvbe_gem_free_object(struct drm_gem_object *gobj)
+{
+	struct dvbe_gem_object *obj = to_dvbe_bo(gobj);
+
+	if (gobj->map_list.map)
+		drm_gem_free_mmap_offset(gobj);
+	dvbe_gem_vunmap(obj);
+	dvbe_gem_put_pages(obj);
+	drm_gem_object_release(gobj);
+	kfree(obj);
+}
+
+/*
+ * On page-faults we need to calculate the page-offset ourself as the vma-offset
+ * is based on the fake-offset of drm_mmap() instead of any real offset.
+ * We simply insert the page via vm_insert_page() as it has been marked as
+ * VM_MIXEDMAP in the vma.
+ */
+int dvbe_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	struct dvbe_gem_object *obj = to_dvbe_bo(vma->vm_private_data);
+	unsigned long off, vaddr;
+	int ret;
+
+	if (!obj->pages)
+		return VM_FAULT_SIGBUS;
+
+	vaddr = (unsigned long)vmf->virtual_address;
+	off = (vaddr - vma->vm_start) >> PAGE_SHIFT;
+
+	ret = vm_insert_page(vma, vaddr, obj->pages[off]);
+	switch (ret) {
+	case -ENOMEM:
+		return VM_FAULT_OOM;
+	case -EAGAIN:
+		set_need_resched();
+		/* fallthrough */
+	case -ERESTARTSYS:
+	case 0:
+		return VM_FAULT_NOPAGE;
+	}
+
+	return VM_FAULT_SIGBUS;
+}
+
+int dvbe_dumb_create(struct drm_file *dfile, struct drm_device *ddev,
+		     struct drm_mode_create_dumb *args)
+{
+	struct dvbe_gem_object *obj;
+	int ret;
+
+	args->pitch = args->width * ((args->bpp + 7) / 8);
+	args->size = args->pitch * args->height;
+
+	if (!args->size)
+		return -EINVAL;
+
+	args->size = roundup(args->size, PAGE_SIZE);
+	obj = dvbe_gem_alloc_object(ddev, args->size);
+	if (!obj)
+		return -ENOMEM;
+
+	ret = drm_gem_handle_create(dfile, &obj->base, &args->handle);
+	if (ret) {
+		drm_gem_object_unreference(&obj->base);
+		return ret;
+	}
+
+	drm_gem_object_unreference(&obj->base);
+	return 0;
+}
+
+int dvbe_dumb_destroy(struct drm_file *dfile, struct drm_device *ddev,
+		      uint32_t handle)
+{
+	return drm_gem_handle_delete(dfile, handle);
+}
+
+int dvbe_dumb_map_offset(struct drm_file *dfile, struct drm_device *ddev,
+			 uint32_t handle, uint64_t *offset)
+{
+	struct dvbe_gem_object *obj;
+	struct drm_gem_object *gobj;
+	int ret;
+
+	mutex_lock(&ddev->struct_mutex);
+	gobj = drm_gem_object_lookup(ddev, dfile, handle);
+	if (!gobj) {
+		ret = -ENOENT;
+		goto out_unlock;
+	}
+	obj = to_dvbe_bo(gobj);
+
+	ret = dvbe_gem_get_pages(obj);
+	if (ret)
+		goto out_unref;
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
+int dvbe_drm_mmap(struct file *filp, struct vm_area_struct *vma)
+{
+	int ret;
+
+	ret = drm_gem_mmap(filp, vma);
+	if (ret)
+		return ret;
+
+	vma->vm_flags &= ~VM_PFNMAP;
+	vma->vm_flags |= VM_MIXEDMAP;
+	vma->vm_page_prot = pgprot_writecombine(vm_get_page_prot(vma->vm_flags));
+
+	return ret;
+}
diff --git a/drivers/gpu/drm/dvbe/dvbe_vesa.c b/drivers/gpu/drm/dvbe/dvbe_vesa.c
new file mode 100644
index 0000000..dc815cf
--- /dev/null
+++ b/drivers/gpu/drm/dvbe/dvbe_vesa.c
@@ -0,0 +1,242 @@
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
+#include <asm/mtrr.h>
+#include <linux/ioport.h>
+#include <linux/module.h>
+#include <linux/screen_info.h>
+#include <drm/drmP.h>
+#include <video/vga.h>
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
+	dvbe->vbe_vsize = screen_info.lfb_size * 0x10000;
+	dvbe->vbe_width = screen_info.lfb_width;
+	dvbe->vbe_height = screen_info.lfb_height;
+	dvbe->vbe_stride = screen_info.lfb_linelength;
+	dvbe->vbe_depth = screen_info.lfb_depth;
+	dvbe->vbe_bpp = (dvbe->vbe_depth == 15) ? 16 : dvbe->vbe_depth;
+
+	if (dvbe->vbe_bpp != 8 && dvbe->vbe_bpp != 16 && dvbe->vbe_bpp != 32)
+		return -ENODEV;
+	if (!screen_info.red_pos && !screen_info.green_pos &&
+	    !screen_info.blue_pos)
+		return -ENODEV;
+	if (!screen_info.red_size && !screen_info.green_size &&
+	    !screen_info.blue_size)
+		return -ENODEV;
+
+	dvbe->vbe_red_size = screen_info.red_size;
+	dvbe->vbe_red_pos = screen_info.red_pos;
+	dvbe->vbe_green_size = screen_info.green_size;
+	dvbe->vbe_green_pos = screen_info.green_pos;
+	dvbe->vbe_blue_size = screen_info.blue_size;
+	dvbe->vbe_blue_pos = screen_info.blue_pos;
+
+	dvbe->vbe_size = dvbe->vbe_height * dvbe->vbe_stride;
+	if (dvbe->vbe_vsize < dvbe->vbe_size)
+		dvbe->vbe_vsize = dvbe->vbe_size;
+
+	if (!request_mem_region(dvbe->vbe_addr, dvbe->vbe_vsize, "dvbe"))
+		return -EIO;
+
+	if (!request_region(0x3c0, 32, "dvbe")) {
+		ret = -EIO;
+		goto err_mem_region;
+	}
+
+	dvbe->vbe_map = ioremap(dvbe->vbe_addr, dvbe->vbe_size);
+	if (!dvbe->vbe_map) {
+		ret = -EIO;
+		goto err_region;
+	}
+
+	dev_info(dvbe->ddev->dev, "initialized VBE mode to %ux%u\n",
+		dvbe->vbe_width, dvbe->vbe_height);
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
+	iounmap(dvbe->vbe_map);
+	release_region(0x3c0, 32);
+	release_mem_region(dvbe->vbe_addr, dvbe->vbe_vsize);
+}
-- 
1.8.1.1

