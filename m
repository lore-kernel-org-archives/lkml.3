Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab3BQSAf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 13:00:35 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:41799 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844Ab3BQSAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 13:00:04 -0500
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH 7/9] drm: new VESA BIOS Extension DRM driver stub
Date: Sun, 17 Feb 2013 18:59:09 +0100
Message-Id: <1361123951-587-8-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1361123951-587-1-git-send-email-dh.herrmann@gmail.com>
References: <1361123951-587-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver uses the VESA BIOS Extensions to control the display device.
Modesetting has to be done during the boot-process by the architecture
code (same way as vesafb requires it). No runtime modesetting is allowed
due to RealMode/ProtectedMode restrictions.

This patch only introduces the stub DRM driver without any VESA/VBE
backend that actually touches the hardware.

The driver simply provides a single crtc+encoder+connector combination
that user-space can use to access the VBE framebuffer. No page-flips are
supported and users must explicitly mark buffers as dirty to get them
copied into the framebuffer.

All buffer objects are backed by shmem so we can later add PRIME support.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 drivers/gpu/drm/Kconfig          |   2 +
 drivers/gpu/drm/Makefile         |   1 +
 drivers/gpu/drm/dvbe/Kconfig     |  28 +++
 drivers/gpu/drm/dvbe/Makefile    |   4 +
 drivers/gpu/drm/dvbe/dvbe.h      |  73 +++++++
 drivers/gpu/drm/dvbe/dvbe_drv.c  | 104 ++++++++++
 drivers/gpu/drm/dvbe/dvbe_main.c | 399 +++++++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/dvbe/dvbe_mem.c  | 269 ++++++++++++++++++++++++++
 8 files changed, 880 insertions(+)
 create mode 100644 drivers/gpu/drm/dvbe/Kconfig
 create mode 100644 drivers/gpu/drm/dvbe/Makefile
 create mode 100644 drivers/gpu/drm/dvbe/dvbe.h
 create mode 100644 drivers/gpu/drm/dvbe/dvbe_drv.c
 create mode 100644 drivers/gpu/drm/dvbe/dvbe_main.c
 create mode 100644 drivers/gpu/drm/dvbe/dvbe_mem.c

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 2df448e..fbbdabc 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -215,3 +215,5 @@ source "drivers/gpu/drm/mgag200/Kconfig"
 source "drivers/gpu/drm/cirrus/Kconfig"
 
 source "drivers/gpu/drm/shmobile/Kconfig"
+
+source "drivers/gpu/drm/dvbe/Kconfig"
diff --git a/drivers/gpu/drm/Makefile b/drivers/gpu/drm/Makefile
index 9249b66..ec91ae8 100644
--- a/drivers/gpu/drm/Makefile
+++ b/drivers/gpu/drm/Makefile
@@ -49,4 +49,5 @@ obj-$(CONFIG_DRM_GMA500) += gma500/
 obj-$(CONFIG_DRM_UDL) += udl/
 obj-$(CONFIG_DRM_AST) += ast/
 obj-$(CONFIG_DRM_SHMOBILE) +=shmobile/
+obj-$(CONFIG_DRM_DVBE) += dvbe/
 obj-y			+= i2c/
diff --git a/drivers/gpu/drm/dvbe/Kconfig b/drivers/gpu/drm/dvbe/Kconfig
new file mode 100644
index 0000000..bb3aa7b
--- /dev/null
+++ b/drivers/gpu/drm/dvbe/Kconfig
@@ -0,0 +1,28 @@
+config DRM_DVBE
+	tristate "VESA BIOS Extension DRM Driver"
+	depends on DRM
+	select DRM_KMS_HELPER
+	select DRM_SYSFB
+	help
+	  This is a DRM/KMS driver for VESA BIOS Extension (VBE) compatible
+	  cards. At least VBE 2.0 is needed. Older VBE 1.2 cards are not
+	  supported.
+	  Nearly all modern x86 graphics cards support VBE 2.0 so this driver
+	  should work with all those graphics cards. However, it does not allow
+	  mode-switching during runtime but requires the kernel to setup the
+	  mode with the vga= kernel command line option. If you want full
+	  support for your graphics card, please select a driver for your
+	  specific model.
+
+	  This driver can be enabled together with any other DRM graphics
+	  driver. If another driver probes a device that conflicts with DVBE,
+	  then DVBE will automatically drop the device and let the
+	  model-specific driver take precedence.
+
+	  This driver replaces the old vesafb framebuffer driver and provides
+	  full backwards compatibility.
+
+	  If unsure, say Y.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called dvbe.
diff --git a/drivers/gpu/drm/dvbe/Makefile b/drivers/gpu/drm/dvbe/Makefile
new file mode 100644
index 0000000..b053da3
--- /dev/null
+++ b/drivers/gpu/drm/dvbe/Makefile
@@ -0,0 +1,4 @@
+ccflags-y := -Iinclude/drm
+
+dvbe-y := dvbe_drv.o dvbe_main.o dvbe_mem.o
+obj-$(CONFIG_DRM_DVBE) := dvbe.o
diff --git a/drivers/gpu/drm/dvbe/dvbe.h b/drivers/gpu/drm/dvbe/dvbe.h
new file mode 100644
index 0000000..0235a95
--- /dev/null
+++ b/drivers/gpu/drm/dvbe/dvbe.h
@@ -0,0 +1,73 @@
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
+#endif /* DVBE_DRV_H */
diff --git a/drivers/gpu/drm/dvbe/dvbe_drv.c b/drivers/gpu/drm/dvbe/dvbe_drv.c
new file mode 100644
index 0000000..98d4d37
--- /dev/null
+++ b/drivers/gpu/drm/dvbe/dvbe_drv.c
@@ -0,0 +1,104 @@
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
+#include <linux/string.h>
+#include <linux/sysfb.h>
+#include <drm/drmP.h>
+#include <drm/drm_sysfb.h>
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
+static int dvbe_sysfb_probe(struct sysfb_device *sdev)
+{
+	return drm_get_sysfb_dev(sdev, &dvbe_drm_driver);
+}
+
+static void dvbe_sysfb_remove(struct sysfb_device *sdev)
+{
+	struct drm_device *ddev = dev_get_drvdata(&sdev->dev);
+
+	drm_unplug_dev(ddev);
+}
+
+static struct sysfb_driver dvbe_sysfb_driver = {
+	.type_mask = SYSFB_VBE,
+	.allow_tainted = false,
+	.driver = {
+		.name = "dvbe",
+		.owner = THIS_MODULE,
+		.mod_name = KBUILD_MODNAME,
+	},
+	.probe = dvbe_sysfb_probe,
+	.remove = dvbe_sysfb_remove,
+};
+
+static int __init dvbe_init(void)
+{
+	return drm_sysfb_init(&dvbe_drm_driver, &dvbe_sysfb_driver);
+}
+
+static void __exit dvbe_exit(void)
+{
+	drm_sysfb_exit(&dvbe_drm_driver, &dvbe_sysfb_driver);
+}
+
+module_init(dvbe_init);
+module_exit(dvbe_exit);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("David Herrmann <dh.herrmann@gmail.com>");
+MODULE_DESCRIPTION("DRM VESA BIOS Extension Driver");
diff --git a/drivers/gpu/drm/dvbe/dvbe_main.c b/drivers/gpu/drm/dvbe/dvbe_main.c
new file mode 100644
index 0000000..e73c77e
--- /dev/null
+++ b/drivers/gpu/drm/dvbe/dvbe_main.c
@@ -0,0 +1,399 @@
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
+	return 0;
+}
+
+/*
+ * Shortcut if no full mode-set is needed but only the offsets or framebuffer
+ * parameters changed. See @mode_set for details.
+ */
+static int dvbe_crtc_mode_set_base(struct drm_crtc *crtc, int x, int y,
+				   struct drm_framebuffer *fb)
+{
+	struct dvbe_framebuffer *dfb = to_dvbe_fb(crtc->fb);
+
+	if (x >= dfb->base.width || y >= dfb->base.height)
+		return -EINVAL;
+
+	return 0;
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
+	return 0;
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
+
+	if (dvbe->crtc.fb != fb)
+		return 0;
+
+	return 0;
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
+	int ret;
+
+	dvbe = kzalloc(sizeof(*dvbe), GFP_KERNEL);
+	if (!dvbe)
+		return -ENOMEM;
+
+	dvbe->ddev = ddev;
+	ddev->dev_private = dvbe;
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
+	return 0;
+
+err_cleanup:
+	drm_mode_config_cleanup(ddev);
+	kfree(dvbe);
+	return ret;
+}
+
+int dvbe_drm_unload(struct drm_device *ddev)
+{
+	struct dvbe_device *dvbe = ddev->dev_private;
+
+	drm_mode_config_cleanup(ddev);
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
-- 
1.8.1.3

