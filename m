Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751161AbbALG6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 01:58:47 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:45400 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbbALG6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 01:58:46 -0500
From: Daniel Kurtz <djkurtz@chromium.org>
To: Mark Yao <mark.yao@rock-chips.com>
Cc: Daniel Kurtz <djkurtz@chromium.org>, David Airlie <airlied@linux.ie>,
        Rob Clark <robdclark@gmail.com>, Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] drm/rockchip: Only alloc a kmap for fbdev gem object
Date: Mon, 12 Jan 2015 14:58:23 +0800
Message-Id: <1421045914-26948-1-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In general, the data in drm/rockchip GEM objects is never accessed by
the kernel.  The objects are either accessed by a GPU, by display
controller DMA, or by mmap'ing them to user space.  Thus, these
buffers need not be mapped into kernel address space.

The only exception is the fbdev framebuffer(s), which may be written
in-kernel by fbcon.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c |  2 +-
 drivers/gpu/drm/rockchip/rockchip_drm_gem.c   | 17 ++++++++++++-----
 drivers/gpu/drm/rockchip/rockchip_drm_gem.h   |  3 ++-
 3 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c b/drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c
index a5d889a8..17d1954 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c
@@ -71,7 +71,7 @@ static int rockchip_drm_fbdev_create(struct drm_fb_helper *helper,
 
 	size = mode_cmd.pitches[0] * mode_cmd.height;
 
-	rk_obj = rockchip_gem_create_object(dev, size);
+	rk_obj = rockchip_gem_create_object(dev, size, true);
 	if (IS_ERR(rk_obj))
 		return -ENOMEM;
 
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_gem.c b/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
index bc98a22..2899385 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
@@ -22,7 +22,8 @@
 #include "rockchip_drm_drv.h"
 #include "rockchip_drm_gem.h"
 
-static int rockchip_gem_alloc_buf(struct rockchip_gem_object *rk_obj)
+static int rockchip_gem_alloc_buf(struct rockchip_gem_object *rk_obj,
+				  bool alloc_kmap)
 {
 	struct drm_gem_object *obj = &rk_obj->base;
 	struct drm_device *drm = obj->dev;
@@ -30,7 +31,9 @@ static int rockchip_gem_alloc_buf(struct rockchip_gem_object *rk_obj)
 	init_dma_attrs(&rk_obj->dma_attrs);
 	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &rk_obj->dma_attrs);
 
-	/* TODO(djkurtz): Use DMA_ATTR_NO_KERNEL_MAPPING except for fbdev */
+	if (!alloc_kmap)
+		dma_set_attr(DMA_ATTR_NO_KERNEL_MAPPING, &rk_obj->dma_attrs);
+
 	rk_obj->kvaddr = dma_alloc_attrs(drm->dev, obj->size,
 					 &rk_obj->dma_addr, GFP_KERNEL,
 					 &rk_obj->dma_attrs);
@@ -106,7 +109,8 @@ int rockchip_gem_mmap(struct file *filp, struct vm_area_struct *vma)
 }
 
 struct rockchip_gem_object *
-	rockchip_gem_create_object(struct drm_device *drm, unsigned int size)
+	rockchip_gem_create_object(struct drm_device *drm, unsigned int size,
+				   bool alloc_kmap)
 {
 	struct rockchip_gem_object *rk_obj;
 	struct drm_gem_object *obj;
@@ -122,7 +126,7 @@ struct rockchip_gem_object *
 
 	drm_gem_private_object_init(drm, obj, size);
 
-	ret = rockchip_gem_alloc_buf(rk_obj);
+	ret = rockchip_gem_alloc_buf(rk_obj, alloc_kmap);
 	if (ret)
 		goto err_free_rk_obj;
 
@@ -166,7 +170,7 @@ rockchip_gem_create_with_handle(struct drm_file *file_priv,
 	struct drm_gem_object *obj;
 	int ret;
 
-	rk_obj = rockchip_gem_create_object(drm, size);
+	rk_obj = rockchip_gem_create_object(drm, size, false);
 	if (IS_ERR(rk_obj))
 		return ERR_CAST(rk_obj);
 
@@ -285,6 +289,9 @@ void *rockchip_gem_prime_vmap(struct drm_gem_object *obj)
 {
 	struct rockchip_gem_object *rk_obj = to_rockchip_obj(obj);
 
+	if (dma_get_attr(DMA_ATTR_NO_KERNEL_MAPPING, &rk_obj->dma_attrs))
+		return NULL;
+
 	return rk_obj->kvaddr;
 }
 
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_gem.h b/drivers/gpu/drm/rockchip/rockchip_drm_gem.h
index 67bcebe..ad22618 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_gem.h
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_gem.h
@@ -41,7 +41,8 @@ int rockchip_gem_mmap_buf(struct drm_gem_object *obj,
 			  struct vm_area_struct *vma);
 
 struct rockchip_gem_object *
-	rockchip_gem_create_object(struct drm_device *drm, unsigned int size);
+	rockchip_gem_create_object(struct drm_device *drm, unsigned int size,
+				   bool alloc_kmap);
 
 void rockchip_gem_free_object(struct drm_gem_object *obj);
 
-- 
2.2.0.rc0.207.ga3a616c

