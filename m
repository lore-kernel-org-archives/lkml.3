Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbbATKtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:49:18 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:50019 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123AbbATKtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:49:14 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 09/36] drm/tegra: Move tegra_drm_mode_funcs to the core
Date: Tue, 20 Jan 2015 11:48:28 +0100
Message-Id: <1421750935-4023-10-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
References: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

This structure will be extended using non-framebuffer related callbacks
in subsequent patches, so it should move to a more central location.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/gpu/drm/tegra/drm.c | 15 +++++++++++++++
 drivers/gpu/drm/tegra/drm.h |  4 ++++
 drivers/gpu/drm/tegra/fb.c  | 25 ++++---------------------
 3 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/tegra/drm.c b/drivers/gpu/drm/tegra/drm.c
index 362fcb785f70..121e022bdab0 100644
--- a/drivers/gpu/drm/tegra/drm.c
+++ b/drivers/gpu/drm/tegra/drm.c
@@ -24,6 +24,13 @@ struct tegra_drm_file {
 	struct list_head contexts;
 };
 
+static const struct drm_mode_config_funcs tegra_drm_mode_funcs = {
+	.fb_create = tegra_fb_create,
+#ifdef CONFIG_DRM_TEGRA_FBDEV
+	.output_poll_changed = tegra_fb_output_poll_changed,
+#endif
+};
+
 static int tegra_drm_load(struct drm_device *drm, unsigned long flags)
 {
 	struct host1x_device *device = to_host1x_device(drm->dev);
@@ -52,6 +59,14 @@ static int tegra_drm_load(struct drm_device *drm, unsigned long flags)
 
 	drm_mode_config_init(drm);
 
+	drm->mode_config.min_width = 0;
+	drm->mode_config.min_height = 0;
+
+	drm->mode_config.max_width = 4096;
+	drm->mode_config.max_height = 4096;
+
+	drm->mode_config.funcs = &tegra_drm_mode_funcs;
+
 	err = tegra_drm_fb_prepare(drm);
 	if (err < 0)
 		goto config;
diff --git a/drivers/gpu/drm/tegra/drm.h b/drivers/gpu/drm/tegra/drm.h
index 5a0e96debcb1..286a970a4432 100644
--- a/drivers/gpu/drm/tegra/drm.h
+++ b/drivers/gpu/drm/tegra/drm.h
@@ -292,12 +292,16 @@ struct tegra_bo *tegra_fb_get_plane(struct drm_framebuffer *framebuffer,
 bool tegra_fb_is_bottom_up(struct drm_framebuffer *framebuffer);
 int tegra_fb_get_tiling(struct drm_framebuffer *framebuffer,
 			struct tegra_bo_tiling *tiling);
+struct drm_framebuffer *tegra_fb_create(struct drm_device *drm,
+					struct drm_file *file,
+					struct drm_mode_fb_cmd2 *cmd);
 int tegra_drm_fb_prepare(struct drm_device *drm);
 void tegra_drm_fb_free(struct drm_device *drm);
 int tegra_drm_fb_init(struct drm_device *drm);
 void tegra_drm_fb_exit(struct drm_device *drm);
 #ifdef CONFIG_DRM_TEGRA_FBDEV
 void tegra_fbdev_restore_mode(struct tegra_fbdev *fbdev);
+void tegra_fb_output_poll_changed(struct drm_device *drm);
 #endif
 
 extern struct platform_driver tegra_dc_driver;
diff --git a/drivers/gpu/drm/tegra/fb.c b/drivers/gpu/drm/tegra/fb.c
index e9c715d89261..397fb34d5d5b 100644
--- a/drivers/gpu/drm/tegra/fb.c
+++ b/drivers/gpu/drm/tegra/fb.c
@@ -129,9 +129,9 @@ static struct tegra_fb *tegra_fb_alloc(struct drm_device *drm,
 	return fb;
 }
 
-static struct drm_framebuffer *tegra_fb_create(struct drm_device *drm,
-					       struct drm_file *file,
-					       struct drm_mode_fb_cmd2 *cmd)
+struct drm_framebuffer *tegra_fb_create(struct drm_device *drm,
+					struct drm_file *file,
+					struct drm_mode_fb_cmd2 *cmd)
 {
 	unsigned int hsub, vsub, i;
 	struct tegra_bo *planes[4];
@@ -377,7 +377,7 @@ void tegra_fbdev_restore_mode(struct tegra_fbdev *fbdev)
 		drm_fb_helper_restore_fbdev_mode_unlocked(&fbdev->base);
 }
 
-static void tegra_fb_output_poll_changed(struct drm_device *drm)
+void tegra_fb_output_poll_changed(struct drm_device *drm)
 {
 	struct tegra_drm *tegra = drm->dev_private;
 
@@ -386,28 +386,11 @@ static void tegra_fb_output_poll_changed(struct drm_device *drm)
 }
 #endif
 
-static const struct drm_mode_config_funcs tegra_drm_mode_funcs = {
-	.fb_create = tegra_fb_create,
-#ifdef CONFIG_DRM_TEGRA_FBDEV
-	.output_poll_changed = tegra_fb_output_poll_changed,
-#endif
-};
-
 int tegra_drm_fb_prepare(struct drm_device *drm)
 {
 #ifdef CONFIG_DRM_TEGRA_FBDEV
 	struct tegra_drm *tegra = drm->dev_private;
-#endif
 
-	drm->mode_config.min_width = 0;
-	drm->mode_config.min_height = 0;
-
-	drm->mode_config.max_width = 4096;
-	drm->mode_config.max_height = 4096;
-
-	drm->mode_config.funcs = &tegra_drm_mode_funcs;
-
-#ifdef CONFIG_DRM_TEGRA_FBDEV
 	tegra->fbdev = tegra_fbdev_create(drm);
 	if (IS_ERR(tegra->fbdev))
 		return PTR_ERR(tegra->fbdev);
-- 
2.1.3

