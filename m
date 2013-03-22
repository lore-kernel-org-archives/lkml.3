Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933614Ab3CVOfx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 10:35:53 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7230 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933416Ab3CVOeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 10:34:22 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 22 Mar 2013 07:34:11 -0700
From: Terje Bergstrom <tbergstrom@nvidia.com>
To: <airlied@linux.ie>, <thierry.reding@avionic-design.de>,
        <linux-tegra@vger.kernel.org>, <dri-devel@lists.freedesktop.org>
CC: <linux-kernel@vger.kernel.org>, <amerilainen@nvidia.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>
Subject: [PATCHv9 8/9] gpu: host1x: drm: Add memory manager and fb
Date: Fri, 22 Mar 2013 16:34:08 +0200
Message-ID: <1363962849-19872-9-git-send-email-tbergstrom@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363962849-19872-1-git-send-email-tbergstrom@nvidia.com>
References: <1363962849-19872-1-git-send-email-tbergstrom@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arto Merilainen <amerilainen@nvidia.com>

This patch introduces a memory manager for tegra drm and moves
existing parts to use it. As cma framebuffer helpers can no more
be used, this patch adds also a separate framebuffer driver for
tegra.

Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
Signed-off-by: Terje Bergstrom <tbergstrom@nvidia.com>
---
 drivers/gpu/host1x/Makefile    |    1 +
 drivers/gpu/host1x/drm/Kconfig |    8 +-
 drivers/gpu/host1x/drm/dc.c    |   23 +--
 drivers/gpu/host1x/drm/drm.c   |   17 +-
 drivers/gpu/host1x/drm/drm.h   |   18 ++-
 drivers/gpu/host1x/drm/fb.c    |  336 +++++++++++++++++++++++++++++++++++++++-
 drivers/gpu/host1x/drm/gem.c   |  270 ++++++++++++++++++++++++++++++++
 drivers/gpu/host1x/drm/gem.h   |   59 +++++++
 8 files changed, 698 insertions(+), 34 deletions(-)
 create mode 100644 drivers/gpu/host1x/drm/gem.c
 create mode 100644 drivers/gpu/host1x/drm/gem.h

diff --git a/drivers/gpu/host1x/Makefile b/drivers/gpu/host1x/Makefile
index 9a6fc76..3768dbc 100644
--- a/drivers/gpu/host1x/Makefile
+++ b/drivers/gpu/host1x/Makefile
@@ -15,4 +15,5 @@ ccflags-$(CONFIG_DRM_TEGRA_DEBUG) += -DDEBUG
 
 host1x-$(CONFIG_DRM_TEGRA) += drm/drm.o drm/fb.o drm/dc.o
 host1x-$(CONFIG_DRM_TEGRA) += drm/output.o drm/rgb.o drm/hdmi.o
+host1x-$(CONFIG_DRM_TEGRA) += drm/gem.o
 obj-$(CONFIG_TEGRA_HOST1X) += host1x.o
diff --git a/drivers/gpu/host1x/drm/Kconfig b/drivers/gpu/host1x/drm/Kconfig
index 7db9b3a..f743540 100644
--- a/drivers/gpu/host1x/drm/Kconfig
+++ b/drivers/gpu/host1x/drm/Kconfig
@@ -2,11 +2,9 @@ config DRM_TEGRA
 	bool "NVIDIA Tegra DRM"
 	depends on DRM && OF && ARCH_TEGRA
 	select DRM_KMS_HELPER
-	select DRM_GEM_CMA_HELPER
-	select DRM_KMS_CMA_HELPER
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
+	select FB_SYS_FILLRECT
+	select FB_SYS_COPYAREA
+	select FB_SYS_IMAGEBLIT
 	help
 	  Choose this option if you have an NVIDIA Tegra SoC.
 
diff --git a/drivers/gpu/host1x/drm/dc.c b/drivers/gpu/host1x/drm/dc.c
index 29a79b6..85ea616 100644
--- a/drivers/gpu/host1x/drm/dc.c
+++ b/drivers/gpu/host1x/drm/dc.c
@@ -14,9 +14,10 @@
 #include <linux/platform_device.h>
 #include <linux/clk/tegra.h>
 
-#include "drm.h"
-#include "dc.h"
 #include "host1x_client.h"
+#include "dc.h"
+#include "drm.h"
+#include "gem.h"
 
 struct tegra_plane {
 	struct drm_plane base;
@@ -52,9 +53,9 @@ static int tegra_plane_update(struct drm_plane *plane, struct drm_crtc *crtc,
 	window.bits_per_pixel = fb->bits_per_pixel;
 
 	for (i = 0; i < drm_format_num_planes(fb->pixel_format); i++) {
-		struct drm_gem_cma_object *gem = drm_fb_cma_get_gem_obj(fb, i);
+		struct tegra_bo *bo = tegra_fb_get_plane(fb, i);
 
-		window.base[i] = gem->paddr + fb->offsets[i];
+		window.base[i] = bo->paddr + fb->offsets[i];
 
 		/*
 		 * Tegra doesn't support different strides for U and V planes
@@ -137,7 +138,7 @@ static int tegra_dc_add_planes(struct drm_device *drm, struct tegra_dc *dc)
 static int tegra_dc_set_base(struct tegra_dc *dc, int x, int y,
 			     struct drm_framebuffer *fb)
 {
-	struct drm_gem_cma_object *gem = drm_fb_cma_get_gem_obj(fb, 0);
+	struct tegra_bo *bo = tegra_fb_get_plane(fb, 0);
 	unsigned long value;
 
 	tegra_dc_writel(dc, WINDOW_A_SELECT, DC_CMD_DISPLAY_WINDOW_HEADER);
@@ -145,7 +146,7 @@ static int tegra_dc_set_base(struct tegra_dc *dc, int x, int y,
 	value = fb->offsets[0] + y * fb->pitches[0] +
 		x * fb->bits_per_pixel / 8;
 
-	tegra_dc_writel(dc, gem->paddr + value, DC_WINBUF_START_ADDR);
+	tegra_dc_writel(dc, bo->paddr + value, DC_WINBUF_START_ADDR);
 	tegra_dc_writel(dc, fb->pitches[0], DC_WIN_LINE_STRIDE);
 
 	value = GENERAL_UPDATE | WIN_A_UPDATE;
@@ -187,20 +188,20 @@ static void tegra_dc_finish_page_flip(struct tegra_dc *dc)
 {
 	struct drm_device *drm = dc->base.dev;
 	struct drm_crtc *crtc = &dc->base;
-	struct drm_gem_cma_object *gem;
 	unsigned long flags, base;
+	struct tegra_bo *bo;
 
 	if (!dc->event)
 		return;
 
-	gem = drm_fb_cma_get_gem_obj(crtc->fb, 0);
+	bo = tegra_fb_get_plane(crtc->fb, 0);
 
 	/* check if new start address has been latched */
 	tegra_dc_writel(dc, READ_MUX, DC_CMD_STATE_ACCESS);
 	base = tegra_dc_readl(dc, DC_WINBUF_START_ADDR);
 	tegra_dc_writel(dc, 0, DC_CMD_STATE_ACCESS);
 
-	if (base == gem->paddr + crtc->fb->offsets[0]) {
+	if (base == bo->paddr + crtc->fb->offsets[0]) {
 		spin_lock_irqsave(&drm->event_lock, flags);
 		drm_send_vblank_event(drm, dc->pipe, dc->event);
 		drm_vblank_put(drm, dc->pipe);
@@ -570,7 +571,7 @@ static int tegra_crtc_mode_set(struct drm_crtc *crtc,
 			       struct drm_display_mode *adjusted,
 			       int x, int y, struct drm_framebuffer *old_fb)
 {
-	struct drm_gem_cma_object *gem = drm_fb_cma_get_gem_obj(crtc->fb, 0);
+	struct tegra_bo *bo = tegra_fb_get_plane(crtc->fb, 0);
 	struct tegra_dc *dc = to_tegra_dc(crtc);
 	struct tegra_dc_window window;
 	unsigned long div, value;
@@ -617,7 +618,7 @@ static int tegra_crtc_mode_set(struct drm_crtc *crtc,
 	window.format = tegra_dc_format(crtc->fb->pixel_format);
 	window.bits_per_pixel = crtc->fb->bits_per_pixel;
 	window.stride[0] = crtc->fb->pitches[0];
-	window.base[0] = gem->paddr;
+	window.base[0] = bo->paddr;
 
 	err = tegra_dc_setup_window(dc, 0, &window);
 	if (err < 0)
diff --git a/drivers/gpu/host1x/drm/drm.c b/drivers/gpu/host1x/drm/drm.c
index 901f0b4..c4e45c1 100644
--- a/drivers/gpu/host1x/drm/drm.c
+++ b/drivers/gpu/host1x/drm/drm.c
@@ -15,7 +15,10 @@
 #include <asm/dma-iommu.h>
 
 #include "host1x_client.h"
+#include "dev.h"
 #include "drm.h"
+#include "gem.h"
+#include "syncpt.h"
 
 #define DRIVER_NAME "tegra"
 #define DRIVER_DESC "NVIDIA Tegra graphics"
@@ -281,7 +284,7 @@ static void tegra_drm_lastclose(struct drm_device *drm)
 {
 	struct host1x_drm *host1x = drm->dev_private;
 
-	drm_fbdev_cma_restore_mode(host1x->fbdev);
+	tegra_fbdev_restore_mode(host1x->fbdev);
 }
 
 static struct drm_ioctl_desc tegra_drm_ioctls[] = {
@@ -292,7 +295,7 @@ static const struct file_operations tegra_drm_fops = {
 	.open = drm_open,
 	.release = drm_release,
 	.unlocked_ioctl = drm_ioctl,
-	.mmap = drm_gem_cma_mmap,
+	.mmap = tegra_drm_mmap,
 	.poll = drm_poll,
 	.fasync = drm_fasync,
 	.read = drm_read,
@@ -408,11 +411,11 @@ struct drm_driver tegra_drm_driver = {
 	.debugfs_cleanup = tegra_debugfs_cleanup,
 #endif
 
-	.gem_free_object = drm_gem_cma_free_object,
-	.gem_vm_ops = &drm_gem_cma_vm_ops,
-	.dumb_create = drm_gem_cma_dumb_create,
-	.dumb_map_offset = drm_gem_cma_dumb_map_offset,
-	.dumb_destroy = drm_gem_cma_dumb_destroy,
+	.gem_free_object = tegra_bo_free_object,
+	.gem_vm_ops = &tegra_bo_vm_ops,
+	.dumb_create = tegra_bo_dumb_create,
+	.dumb_map_offset = tegra_bo_dumb_map_offset,
+	.dumb_destroy = tegra_bo_dumb_destroy,
 
 	.ioctls = tegra_drm_ioctls,
 	.num_ioctls = ARRAY_SIZE(tegra_drm_ioctls),
diff --git a/drivers/gpu/host1x/drm/drm.h b/drivers/gpu/host1x/drm/drm.h
index 0b8738f..3864a39 100644
--- a/drivers/gpu/host1x/drm/drm.h
+++ b/drivers/gpu/host1x/drm/drm.h
@@ -14,10 +14,19 @@
 #include <drm/drm_crtc_helper.h>
 #include <drm/drm_edid.h>
 #include <drm/drm_fb_helper.h>
-#include <drm/drm_gem_cma_helper.h>
-#include <drm/drm_fb_cma_helper.h>
 #include <drm/drm_fixed.h>
 
+struct tegra_fb {
+	struct drm_framebuffer base;
+	struct tegra_bo **planes;
+	unsigned int num_planes;
+};
+
+struct tegra_fbdev {
+	struct drm_fb_helper base;
+	struct tegra_fb *fb;
+};
+
 struct host1x_drm {
 	struct drm_device *drm;
 	struct device *dev;
@@ -33,7 +42,7 @@ struct host1x_drm {
 	struct mutex clients_lock;
 	struct list_head clients;
 
-	struct drm_fbdev_cma *fbdev;
+	struct tegra_fbdev *fbdev;
 };
 
 struct host1x_client;
@@ -226,8 +235,11 @@ extern int tegra_output_init(struct drm_device *drm, struct tegra_output *output
 extern int tegra_output_exit(struct tegra_output *output);
 
 /* from fb.c */
+struct tegra_bo *tegra_fb_get_plane(struct drm_framebuffer *framebuffer,
+				    unsigned int index);
 extern int tegra_drm_fb_init(struct drm_device *drm);
 extern void tegra_drm_fb_exit(struct drm_device *drm);
+extern void tegra_fbdev_restore_mode(struct tegra_fbdev *fbdev);
 
 extern struct drm_driver tegra_drm_driver;
 
diff --git a/drivers/gpu/host1x/drm/fb.c b/drivers/gpu/host1x/drm/fb.c
index 6ed885a..953e418 100644
--- a/drivers/gpu/host1x/drm/fb.c
+++ b/drivers/gpu/host1x/drm/fb.c
@@ -1,30 +1,341 @@
 /*
- * Copyright (C) 2012 Avionic Design GmbH
+ * Copyright (C) 2012-2013 Avionic Design GmbH
  * Copyright (C) 2012 NVIDIA CORPORATION.  All rights reserved.
  *
+ * Based on the KMS/FB CMA helpers
+ *   Copyright (C) 2012 Analog Device Inc.
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
 
 #include "drm.h"
+#include "gem.h"
+
+static inline struct tegra_fb *to_tegra_fb(struct drm_framebuffer *fb)
+{
+	return container_of(fb, struct tegra_fb, base);
+}
+
+static inline struct tegra_fbdev *to_tegra_fbdev(struct drm_fb_helper *helper)
+{
+	return container_of(helper, struct tegra_fbdev, base);
+}
+
+struct tegra_bo *tegra_fb_get_plane(struct drm_framebuffer *framebuffer,
+				    unsigned int index)
+{
+	struct tegra_fb *fb = to_tegra_fb(framebuffer);
+
+	if (index >= drm_format_num_planes(framebuffer->pixel_format))
+		return NULL;
+
+	return fb->planes[index];
+}
+
+static void tegra_fb_destroy(struct drm_framebuffer *framebuffer)
+{
+	struct tegra_fb *fb = to_tegra_fb(framebuffer);
+	unsigned int i;
+
+	for (i = 0; i < fb->num_planes; i++) {
+		struct tegra_bo *bo = fb->planes[i];
+
+		if (bo)
+			drm_gem_object_unreference_unlocked(&bo->gem);
+	}
+
+	drm_framebuffer_cleanup(framebuffer);
+	kfree(fb->planes);
+	kfree(fb);
+}
+
+static int tegra_fb_create_handle(struct drm_framebuffer *framebuffer,
+				  struct drm_file *file, unsigned int *handle)
+{
+	struct tegra_fb *fb = to_tegra_fb(framebuffer);
+
+	return drm_gem_handle_create(file, &fb->planes[0]->gem, handle);
+}
+
+static struct drm_framebuffer_funcs tegra_fb_funcs = {
+	.destroy = tegra_fb_destroy,
+	.create_handle = tegra_fb_create_handle,
+};
 
-static void tegra_drm_fb_output_poll_changed(struct drm_device *drm)
+static struct tegra_fb *tegra_fb_alloc(struct drm_device *drm,
+				       struct drm_mode_fb_cmd2 *mode_cmd,
+				       struct tegra_bo **planes,
+				       unsigned int num_planes)
+{
+	struct tegra_fb *fb;
+	unsigned int i;
+	int err;
+
+	fb = kzalloc(sizeof(*fb), GFP_KERNEL);
+	if (!fb)
+		return ERR_PTR(-ENOMEM);
+
+	fb->planes = kzalloc(num_planes * sizeof(*planes), GFP_KERNEL);
+	if (!fb->planes)
+		return ERR_PTR(-ENOMEM);
+
+	fb->num_planes = num_planes;
+
+	drm_helper_mode_fill_fb_struct(&fb->base, mode_cmd);
+
+	for (i = 0; i < fb->num_planes; i++)
+		fb->planes[i] = planes[i];
+
+	err = drm_framebuffer_init(drm, &fb->base, &tegra_fb_funcs);
+	if (err < 0) {
+		dev_err(drm->dev, "failed to initialize framebuffer: %d\n",
+			err);
+		kfree(fb->planes);
+		kfree(fb);
+		return ERR_PTR(err);
+	}
+
+	return fb;
+}
+
+static struct drm_framebuffer *tegra_fb_create(struct drm_device *drm,
+					       struct drm_file *file,
+					       struct drm_mode_fb_cmd2 *cmd)
+{
+	unsigned int hsub, vsub, i;
+	struct tegra_bo *planes[4];
+	struct drm_gem_object *gem;
+	struct tegra_fb *fb;
+	int err;
+
+	hsub = drm_format_horz_chroma_subsampling(cmd->pixel_format);
+	vsub = drm_format_vert_chroma_subsampling(cmd->pixel_format);
+
+	for (i = 0; i < drm_format_num_planes(cmd->pixel_format); i++) {
+		unsigned int width = cmd->width / (i ? hsub : 1);
+		unsigned int height = cmd->height / (i ? vsub : 1);
+		unsigned int size, bpp;
+
+		gem = drm_gem_object_lookup(drm, file, cmd->handles[i]);
+		if (!gem) {
+			err = -ENXIO;
+			goto unreference;
+		}
+
+		bpp = drm_format_plane_cpp(cmd->pixel_format, i);
+
+		size = (height - 1) * cmd->pitches[i] +
+		       width * bpp + cmd->offsets[i];
+
+		if (gem->size < size) {
+			err = -EINVAL;
+			goto unreference;
+		}
+
+		planes[i] = to_tegra_bo(gem);
+	}
+
+	fb = tegra_fb_alloc(drm, cmd, planes, i);
+	if (IS_ERR(fb)) {
+		err = PTR_ERR(fb);
+		goto unreference;
+	}
+
+	return &fb->base;
+
+unreference:
+	while (i--)
+		drm_gem_object_unreference_unlocked(&planes[i]->gem);
+
+	return ERR_PTR(err);
+}
+
+static struct fb_ops tegra_fb_ops = {
+	.owner = THIS_MODULE,
+	.fb_fillrect = sys_fillrect,
+	.fb_copyarea = sys_copyarea,
+	.fb_imageblit = sys_imageblit,
+	.fb_check_var = drm_fb_helper_check_var,
+	.fb_set_par = drm_fb_helper_set_par,
+	.fb_blank = drm_fb_helper_blank,
+	.fb_pan_display = drm_fb_helper_pan_display,
+	.fb_setcmap = drm_fb_helper_setcmap,
+};
+
+static int tegra_fbdev_probe(struct drm_fb_helper *helper,
+			     struct drm_fb_helper_surface_size *sizes)
+{
+	struct tegra_fbdev *fbdev = to_tegra_fbdev(helper);
+	struct drm_device *drm = helper->dev;
+	struct drm_mode_fb_cmd2 cmd = { 0 };
+	unsigned int bytes_per_pixel;
+	struct drm_framebuffer *fb;
+	unsigned long offset;
+	struct fb_info *info;
+	struct tegra_bo *bo;
+	size_t size;
+	int err;
+
+	bytes_per_pixel = DIV_ROUND_UP(sizes->surface_bpp, 8);
+
+	cmd.width = sizes->surface_width;
+	cmd.height = sizes->surface_height;
+	cmd.pitches[0] = sizes->surface_width * bytes_per_pixel;
+	cmd.pixel_format = drm_mode_legacy_fb_format(sizes->surface_bpp,
+						     sizes->surface_depth);
+
+	size = cmd.pitches[0] * cmd.height;
+
+	bo = tegra_bo_create(drm, size);
+	if (IS_ERR(bo))
+		return PTR_ERR(bo);
+
+	info = framebuffer_alloc(0, drm->dev);
+	if (!info) {
+		dev_err(drm->dev, "failed to allocate framebuffer info\n");
+		tegra_bo_free_object(&bo->gem);
+		return -ENOMEM;
+	}
+
+	fbdev->fb = tegra_fb_alloc(drm, &cmd, &bo, 1);
+	if (IS_ERR(fbdev->fb)) {
+		dev_err(drm->dev, "failed to allocate DRM framebuffer\n");
+		err = PTR_ERR(fbdev->fb);
+		goto release;
+	}
+
+	fb = &fbdev->fb->base;
+	helper->fb = fb;
+	helper->fbdev = info;
+
+	info->par = helper;
+	info->flags = FBINFO_FLAG_DEFAULT;
+	info->fbops = &tegra_fb_ops;
+
+	err = fb_alloc_cmap(&info->cmap, 256, 0);
+	if (err < 0) {
+		dev_err(drm->dev, "failed to allocate color map: %d\n", err);
+		goto destroy;
+	}
+
+	drm_fb_helper_fill_fix(info, fb->pitches[0], fb->depth);
+	drm_fb_helper_fill_var(info, helper, fb->width, fb->height);
+
+	offset = info->var.xoffset * bytes_per_pixel +
+		 info->var.yoffset * fb->pitches[0];
+
+	drm->mode_config.fb_base = (resource_size_t)bo->paddr;
+	info->screen_base = bo->vaddr + offset;
+	info->screen_size = size;
+	info->fix.smem_start = (unsigned long)(bo->paddr + offset);
+	info->fix.smem_len = size;
+
+	return 0;
+
+destroy:
+	drm_framebuffer_unregister_private(fb);
+	tegra_fb_destroy(fb);
+release:
+	framebuffer_release(info);
+	return err;
+}
+
+static struct drm_fb_helper_funcs tegra_fb_helper_funcs = {
+	.fb_probe = tegra_fbdev_probe,
+};
+
+static struct tegra_fbdev *tegra_fbdev_create(struct drm_device *drm,
+					      unsigned int preferred_bpp,
+					      unsigned int num_crtc,
+					      unsigned int max_connectors)
+{
+	struct drm_fb_helper *helper;
+	struct tegra_fbdev *fbdev;
+	int err;
+
+	fbdev = kzalloc(sizeof(*fbdev), GFP_KERNEL);
+	if (!fbdev) {
+		dev_err(drm->dev, "failed to allocate DRM fbdev\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	fbdev->base.funcs = &tegra_fb_helper_funcs;
+	helper = &fbdev->base;
+
+	err = drm_fb_helper_init(drm, &fbdev->base, num_crtc, max_connectors);
+	if (err < 0) {
+		dev_err(drm->dev, "failed to initialize DRM FB helper\n");
+		goto free;
+	}
+
+	err = drm_fb_helper_single_add_all_connectors(&fbdev->base);
+	if (err < 0) {
+		dev_err(drm->dev, "failed to add connectors\n");
+		goto fini;
+	}
+
+	drm_helper_disable_unused_functions(drm);
+
+	err = drm_fb_helper_initial_config(&fbdev->base, preferred_bpp);
+	if (err < 0) {
+		dev_err(drm->dev, "failed to set initial configuration\n");
+		goto fini;
+	}
+
+	return fbdev;
+
+fini:
+	drm_fb_helper_fini(&fbdev->base);
+free:
+	kfree(fbdev);
+	return ERR_PTR(err);
+}
+
+static void tegra_fbdev_free(struct tegra_fbdev *fbdev)
+{
+	struct fb_info *info = fbdev->base.fbdev;
+
+	if (info) {
+		int err;
+
+		err = unregister_framebuffer(info);
+		if (err < 0)
+			DRM_DEBUG_KMS("failed to unregister framebuffer\n");
+
+		if (info->cmap.len)
+			fb_dealloc_cmap(&info->cmap);
+
+		framebuffer_release(info);
+	}
+
+	if (fbdev->fb) {
+		drm_framebuffer_unregister_private(&fbdev->fb->base);
+		tegra_fb_destroy(&fbdev->fb->base);
+	}
+
+	drm_fb_helper_fini(&fbdev->base);
+	kfree(fbdev);
+}
+
+static void tegra_fb_output_poll_changed(struct drm_device *drm)
 {
 	struct host1x_drm *host1x = drm->dev_private;
 
-	drm_fbdev_cma_hotplug_event(host1x->fbdev);
+	if (host1x->fbdev)
+		drm_fb_helper_hotplug_event(&host1x->fbdev->base);
 }
 
 static const struct drm_mode_config_funcs tegra_drm_mode_funcs = {
-	.fb_create = drm_fb_cma_create,
-	.output_poll_changed = tegra_drm_fb_output_poll_changed,
+	.fb_create = tegra_fb_create,
+	.output_poll_changed = tegra_fb_output_poll_changed,
 };
 
 int tegra_drm_fb_init(struct drm_device *drm)
 {
 	struct host1x_drm *host1x = drm->dev_private;
-	struct drm_fbdev_cma *fbdev;
+	struct tegra_fbdev *fbdev;
 
 	drm->mode_config.min_width = 0;
 	drm->mode_config.min_height = 0;
@@ -34,7 +345,7 @@ int tegra_drm_fb_init(struct drm_device *drm)
 
 	drm->mode_config.funcs = &tegra_drm_mode_funcs;
 
-	fbdev = drm_fbdev_cma_init(drm, 32, drm->mode_config.num_crtc,
+	fbdev = tegra_fbdev_create(drm, 32, drm->mode_config.num_crtc,
 				   drm->mode_config.num_connector);
 	if (IS_ERR(fbdev))
 		return PTR_ERR(fbdev);
@@ -48,5 +359,14 @@ void tegra_drm_fb_exit(struct drm_device *drm)
 {
 	struct host1x_drm *host1x = drm->dev_private;
 
-	drm_fbdev_cma_fini(host1x->fbdev);
+	tegra_fbdev_free(host1x->fbdev);
+}
+
+void tegra_fbdev_restore_mode(struct tegra_fbdev *fbdev)
+{
+	if (fbdev) {
+		drm_modeset_lock_all(fbdev->base.dev);
+		drm_fb_helper_restore_fbdev_mode(&fbdev->base);
+		drm_modeset_unlock_all(fbdev->base.dev);
+	}
 }
diff --git a/drivers/gpu/host1x/drm/gem.c b/drivers/gpu/host1x/drm/gem.c
new file mode 100644
index 0000000..c5e9a9b
--- /dev/null
+++ b/drivers/gpu/host1x/drm/gem.c
@@ -0,0 +1,270 @@
+/*
+ * NVIDIA Tegra DRM GEM helper functions
+ *
+ * Copyright (C) 2012 Sascha Hauer, Pengutronix
+ * Copyright (C) 2013 NVIDIA CORPORATION, All rights reserved.
+ *
+ * Based on the GEM/CMA helpers
+ *
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/mutex.h>
+#include <linux/export.h>
+#include <linux/dma-mapping.h>
+
+#include <drm/drmP.h>
+#include <drm/drm.h>
+
+#include "gem.h"
+
+static inline struct tegra_bo *host1x_to_drm_bo(struct host1x_bo *bo)
+{
+	return container_of(bo, struct tegra_bo, base);
+}
+
+static void tegra_bo_put(struct host1x_bo *bo)
+{
+	struct tegra_bo *obj = host1x_to_drm_bo(bo);
+	struct drm_device *drm = obj->gem.dev;
+
+	mutex_lock(&drm->struct_mutex);
+	drm_gem_object_unreference(&obj->gem);
+	mutex_unlock(&drm->struct_mutex);
+}
+
+static dma_addr_t tegra_bo_pin(struct host1x_bo *bo, struct sg_table **sgt)
+{
+	struct tegra_bo *obj = host1x_to_drm_bo(bo);
+
+	return obj->paddr;
+}
+
+static void tegra_bo_unpin(struct host1x_bo *bo, struct sg_table *sgt)
+{
+}
+
+static void *tegra_bo_mmap(struct host1x_bo *bo)
+{
+	struct tegra_bo *obj = host1x_to_drm_bo(bo);
+
+	return obj->vaddr;
+}
+
+static void tegra_bo_munmap(struct host1x_bo *bo, void *addr)
+{
+}
+
+static void *tegra_bo_kmap(struct host1x_bo *bo, unsigned int page)
+{
+	struct tegra_bo *obj = host1x_to_drm_bo(bo);
+
+	return obj->vaddr + page * PAGE_SIZE;
+}
+
+static void tegra_bo_kunmap(struct host1x_bo *bo, unsigned int page,
+			    void *addr)
+{
+}
+
+static struct host1x_bo *tegra_bo_get(struct host1x_bo *bo)
+{
+	struct tegra_bo *obj = host1x_to_drm_bo(bo);
+	struct drm_device *drm = obj->gem.dev;
+
+	mutex_lock(&drm->struct_mutex);
+	drm_gem_object_reference(&obj->gem);
+	mutex_unlock(&drm->struct_mutex);
+
+	return bo;
+}
+
+const struct host1x_bo_ops tegra_bo_ops = {
+	.get = tegra_bo_get,
+	.put = tegra_bo_put,
+	.pin = tegra_bo_pin,
+	.unpin = tegra_bo_unpin,
+	.mmap = tegra_bo_mmap,
+	.munmap = tegra_bo_munmap,
+	.kmap = tegra_bo_kmap,
+	.kunmap = tegra_bo_kunmap,
+};
+
+static void tegra_bo_destroy(struct drm_device *drm, struct tegra_bo *bo)
+{
+	dma_free_writecombine(drm->dev, bo->gem.size, bo->vaddr, bo->paddr);
+}
+
+unsigned int tegra_bo_get_mmap_offset(struct tegra_bo *bo)
+{
+	return (unsigned int)bo->gem.map_list.hash.key << PAGE_SHIFT;
+}
+
+struct tegra_bo *tegra_bo_create(struct drm_device *drm, unsigned int size)
+{
+	struct tegra_bo *bo;
+	int err;
+
+	bo = kzalloc(sizeof(*bo), GFP_KERNEL);
+	if (!bo)
+		return ERR_PTR(-ENOMEM);
+
+	host1x_bo_init(&bo->base, &tegra_bo_ops);
+	size = round_up(size, PAGE_SIZE);
+
+	bo->vaddr = dma_alloc_writecombine(drm->dev, size, &bo->paddr,
+					   GFP_KERNEL | __GFP_NOWARN);
+	if (!bo->vaddr) {
+		dev_err(drm->dev, "failed to allocate buffer with size %u\n",
+			size);
+		err = -ENOMEM;
+		goto err_dma;
+	}
+
+	err = drm_gem_object_init(drm, &bo->gem, size);
+	if (err)
+		goto err_init;
+
+	err = drm_gem_create_mmap_offset(&bo->gem);
+	if (err)
+		goto err_mmap;
+
+	return bo;
+
+err_mmap:
+	drm_gem_object_release(&bo->gem);
+err_init:
+	tegra_bo_destroy(drm, bo);
+err_dma:
+	kfree(bo);
+
+	return ERR_PTR(err);
+
+}
+
+struct tegra_bo *tegra_bo_create_with_handle(struct drm_file *file,
+					    struct drm_device *drm,
+					    unsigned int size,
+					    unsigned int *handle)
+{
+	struct tegra_bo *bo;
+	int ret;
+
+	bo = tegra_bo_create(drm, size);
+	if (IS_ERR(bo))
+		return bo;
+
+	ret = drm_gem_handle_create(file, &bo->gem, handle);
+	if (ret)
+		goto err;
+
+	drm_gem_object_unreference_unlocked(&bo->gem);
+
+	return bo;
+
+err:
+	tegra_bo_free_object(&bo->gem);
+	return ERR_PTR(ret);
+}
+
+void tegra_bo_free_object(struct drm_gem_object *gem)
+{
+	struct tegra_bo *bo = to_tegra_bo(gem);
+
+	if (gem->map_list.map)
+		drm_gem_free_mmap_offset(gem);
+
+	drm_gem_object_release(gem);
+	tegra_bo_destroy(gem->dev, bo);
+
+	kfree(bo);
+}
+
+int tegra_bo_dumb_create(struct drm_file *file, struct drm_device *drm,
+			 struct drm_mode_create_dumb *args)
+{
+	int min_pitch = DIV_ROUND_UP(args->width * args->bpp, 8);
+	struct tegra_bo *bo;
+
+	if (args->pitch < min_pitch)
+		args->pitch = min_pitch;
+
+	if (args->size < args->pitch * args->height)
+		args->size = args->pitch * args->height;
+
+	bo = tegra_bo_create_with_handle(file, drm, args->size,
+					    &args->handle);
+	if (IS_ERR(bo))
+		return PTR_ERR(bo);
+
+	return 0;
+}
+
+int tegra_bo_dumb_map_offset(struct drm_file *file, struct drm_device *drm,
+			     uint32_t handle, uint64_t *offset)
+{
+	struct drm_gem_object *gem;
+	struct tegra_bo *bo;
+
+	mutex_lock(&drm->struct_mutex);
+
+	gem = drm_gem_object_lookup(drm, file, handle);
+	if (!gem) {
+		dev_err(drm->dev, "failed to lookup GEM object\n");
+		mutex_unlock(&drm->struct_mutex);
+		return -EINVAL;
+	}
+
+	bo = to_tegra_bo(gem);
+
+	*offset = tegra_bo_get_mmap_offset(bo);
+
+	drm_gem_object_unreference(gem);
+
+	mutex_unlock(&drm->struct_mutex);
+
+	return 0;
+}
+
+const struct vm_operations_struct tegra_bo_vm_ops = {
+	.open = drm_gem_vm_open,
+	.close = drm_gem_vm_close,
+};
+
+int tegra_drm_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct drm_gem_object *gem;
+	struct tegra_bo *bo;
+	int ret;
+
+	ret = drm_gem_mmap(file, vma);
+	if (ret)
+		return ret;
+
+	gem = vma->vm_private_data;
+	bo = to_tegra_bo(gem);
+
+	ret = remap_pfn_range(vma, vma->vm_start, bo->paddr >> PAGE_SHIFT,
+			      vma->vm_end - vma->vm_start, vma->vm_page_prot);
+	if (ret)
+		drm_gem_vm_close(vma);
+
+	return ret;
+}
+
+int tegra_bo_dumb_destroy(struct drm_file *file, struct drm_device *drm,
+			  unsigned int handle)
+{
+	return drm_gem_handle_delete(file, handle);
+}
diff --git a/drivers/gpu/host1x/drm/gem.h b/drivers/gpu/host1x/drm/gem.h
new file mode 100644
index 0000000..34de2b4
--- /dev/null
+++ b/drivers/gpu/host1x/drm/gem.h
@@ -0,0 +1,59 @@
+/*
+ * Tegra host1x GEM implementation
+ *
+ * Copyright (c) 2012-2013, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __HOST1X_GEM_H
+#define __HOST1X_GEM_H
+
+#include <drm/drm.h>
+#include <drm/drmP.h>
+
+#include "host1x_bo.h"
+
+struct tegra_bo {
+	struct drm_gem_object gem;
+	struct host1x_bo base;
+	dma_addr_t paddr;
+	void *vaddr;
+};
+
+static inline struct tegra_bo *to_tegra_bo(struct drm_gem_object *gem)
+{
+	return container_of(gem, struct tegra_bo, gem);
+}
+
+extern const struct host1x_bo_ops tegra_bo_ops;
+
+struct tegra_bo *tegra_bo_create(struct drm_device *drm, unsigned int size);
+struct tegra_bo *tegra_bo_create_with_handle(struct drm_file *file,
+					    struct drm_device *drm,
+					    unsigned int size,
+					    unsigned int *handle);
+void tegra_bo_free_object(struct drm_gem_object *gem);
+unsigned int tegra_bo_get_mmap_offset(struct tegra_bo *bo);
+int tegra_bo_dumb_create(struct drm_file *file, struct drm_device *drm,
+			 struct drm_mode_create_dumb *args);
+int tegra_bo_dumb_map_offset(struct drm_file *file, struct drm_device *drm,
+			     uint32_t handle, uint64_t *offset);
+int tegra_bo_dumb_destroy(struct drm_file *file, struct drm_device *drm,
+			  unsigned int handle);
+
+int tegra_drm_mmap(struct file *file, struct vm_area_struct *vma);
+
+extern const struct vm_operations_struct tegra_bo_vm_ops;
+
+#endif
-- 
1.7.9.5

