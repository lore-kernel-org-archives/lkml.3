Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbaFRU4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 16:56:16 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:49466 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755968AbaFRU4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 16:56:14 -0400
From: Hai Li <hali@codeaurora.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        robdclark@gmail.com, Hai Li <hali@codeaurora.org>,
        Stephane Viau <sviau@codeaurora.org>
Subject: [PATCH] drm/msm: Implement msm drm fb_mmap callback function
Date: Wed, 18 Jun 2014 16:55:27 -0400
Message-Id: <1403124927-21514-1-git-send-email-hali@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change implements msm drm specific fb_mmap function for fb device
to properly map the fb address to userspace.

Signed-off-by: Hai Li <hali@codeaurora.org>
Signed-off-by: Stephane Viau <sviau@codeaurora.org>
---
 drivers/gpu/drm/msm/msm_fbdev.c | 37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/msm_fbdev.c b/drivers/gpu/drm/msm/msm_fbdev.c
index 4f4e7b4..2522f51 100644
--- a/drivers/gpu/drm/msm/msm_fbdev.c
+++ b/drivers/gpu/drm/msm/msm_fbdev.c
@@ -19,6 +19,11 @@
 
 #include "drm_crtc.h"
 #include "drm_fb_helper.h"
+#include "msm_gem.h"
+
+extern int msm_gem_mmap_obj(struct drm_gem_object *obj,
+					struct vm_area_struct *vma);
+static int msm_fbdev_mmap(struct fb_info *info, struct vm_area_struct *vma);
 
 /*
  * fbdev funcs, to implement legacy fbdev interface on top of drm driver
@@ -43,6 +48,7 @@ static struct fb_ops msm_fb_ops = {
 	.fb_fillrect = sys_fillrect,
 	.fb_copyarea = sys_copyarea,
 	.fb_imageblit = sys_imageblit,
+	.fb_mmap = msm_fbdev_mmap,
 
 	.fb_check_var = drm_fb_helper_check_var,
 	.fb_set_par = drm_fb_helper_set_par,
@@ -51,6 +57,31 @@ static struct fb_ops msm_fb_ops = {
 	.fb_setcmap = drm_fb_helper_setcmap,
 };
 
+static int msm_fbdev_mmap(struct fb_info *info, struct vm_area_struct *vma)
+{
+	struct drm_fb_helper *helper = (struct drm_fb_helper *)info->par;
+	struct msm_fbdev *fbdev = to_msm_fbdev(helper);
+	struct drm_gem_object *drm_obj = fbdev->bo;
+	struct drm_device *dev = helper->dev;
+	int ret = 0;
+
+	if (drm_device_is_unplugged(dev))
+		return -ENODEV;
+
+	mutex_lock(&dev->struct_mutex);
+
+	ret = drm_gem_mmap_obj(drm_obj, drm_obj->size, vma);
+
+	mutex_unlock(&dev->struct_mutex);
+
+	if (ret) {
+		pr_err("%s:drm_gem_mmap_obj fail\n", __func__);
+		return ret;
+	}
+
+	return msm_gem_mmap_obj(drm_obj, vma);
+}
+
 static int msm_fbdev_create(struct drm_fb_helper *helper,
 		struct drm_fb_helper_surface_size *sizes)
 {
@@ -108,7 +139,11 @@ static int msm_fbdev_create(struct drm_fb_helper *helper,
 	mutex_lock(&dev->struct_mutex);
 
 	/* TODO implement our own fb_mmap so we don't need this: */
-	msm_gem_get_iova_locked(fbdev->bo, 0, &paddr);
+	ret = msm_gem_get_iova_locked(fbdev->bo, 0, &paddr);
+	if (ret) {
+		dev_err(dev->dev, "failed to get buffer obj iova: %d\n", ret);
+		goto fail;
+	}
 
 	fbi = framebuffer_alloc(0, dev->dev);
 	if (!fbi) {
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

