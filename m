Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553Ab3FXPsa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 11:48:30 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:22257 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab3FXPsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 11:48:09 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: dri-devel@lists.freedesktop.org, chris@chris-wilson.co.uk,
        imre.deak@intel.com, daniel.vetter@ffwll.ch, airlied@linux.ie,
        airlied@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Bootup regression of v3.10-rc6 + SWIOTLB + Intel 4000. 
Date: Mon, 24 Jun 2013 11:47:47 -0400
Message-Id: <1372088868-23477-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.1.4
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Dave, Chris, Imre, 

Attached is a fix that makes v3.10-rc6 boot on Intel HD 4000 when SWIOTLB
bounce buffer is in usage. The SWIOTLB can only handle up to 512KB swath
of memory to create bounce buffers for and Imre's patch made it possible
to provide more than to the DMA API which caused it to fail with dma_map_sg.

Since this is rc7 time I did the less risky way of fixing it - by just
doing what said code did before 90797e6d1ec0dfde6ba62a48b9ee3803887d6ed4
 ("drm/i915: create compact dma scatter lists for gem objects") was
introduced by using a check to see if SWIOTLB is enabled.

It is not the best fix but I figured the less risky.

 drivers/gpu/drm/i915/i915_gem.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)


I think that a better approach (in v3.11?) would be to do some form of
retry mechanism: (not compile tested, not run at all):

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index b9d00dc..0f9079d 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1110,8 +1110,12 @@ struct drm_i915_gem_object_ops {
 	 * will therefore most likely be called when the object itself is
 	 * being released or under memory pressure (where we attempt to
 	 * reap pages for the shrinker).
+	 *
+	 * max is the maximum size an sg entry can be. Usually it is
+	 * PAGE_SIZE but if the backend (IOMMU) can deal with larger
+	 * then a larger value might be used as well.
 	 */
-	int (*get_pages)(struct drm_i915_gem_object *);
+	int (*get_pages)(struct drm_i915_gem_object *, unsigned long max);
 	void (*put_pages)(struct drm_i915_gem_object *);
 };
 
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 7045f45..a29e7db 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1738,7 +1738,7 @@ i915_gem_shrink_all(struct drm_i915_private *dev_priv)
 }
 
 static int
-i915_gem_object_get_pages_gtt(struct drm_i915_gem_object *obj)
+i915_gem_object_get_pages_gtt(struct drm_i915_gem_object *obj, unsigned long max)
 {
 	struct drm_i915_private *dev_priv = obj->base.dev->dev_private;
 	int page_count, i;
@@ -1809,7 +1809,7 @@ i915_gem_object_get_pages_gtt(struct drm_i915_gem_object *obj)
 			continue;
 		}
 #endif
-		if (!i || page_to_pfn(page) != last_pfn + 1) {
+		if ((!i || (page_to_pfn(page) != last_pfn + 1)) && (sg->length < max)) {
 			if (i)
 				sg = sg_next(sg);
 			st->nents++;
@@ -1847,7 +1847,7 @@ err_pages:
  * or as the object is itself released.
  */
 int
-i915_gem_object_get_pages(struct drm_i915_gem_object *obj)
+i915_gem_object_get_pages(struct drm_i915_gem_object *obj, unsigned int max)
 {
 	struct drm_i915_private *dev_priv = obj->base.dev->dev_private;
 	const struct drm_i915_gem_object_ops *ops = obj->ops;
@@ -1863,7 +1863,7 @@ i915_gem_object_get_pages(struct drm_i915_gem_object *obj)
 
 	BUG_ON(obj->pages_pin_count);
 
-	ret = ops->get_pages(obj);
+	ret = ops->get_pages(obj, max);
 	if (ret)
 		return ret;
 
@@ -2942,7 +2942,12 @@ i915_gem_object_bind_to_gtt(struct drm_i915_gem_object *obj,
 	u32 size, fence_size, fence_alignment, unfenced_alignment;
 	bool mappable, fenceable;
 	int ret;
+	static unsigned int max_size = 4 * 1024 * 1024; /* 4MB */
 
+#ifdef CONFIG_SWIOTLB
+	if (swiotlb_nr_tbl())
+		max_size = PAGE_SIZE;
+#endif
 	fence_size = i915_gem_get_gtt_size(dev,
 					   obj->base.size,
 					   obj->tiling_mode);
@@ -2972,8 +2977,8 @@ i915_gem_object_bind_to_gtt(struct drm_i915_gem_object *obj,
 		DRM_ERROR("Attempting to bind an object larger than the aperture\n");
 		return -E2BIG;
 	}
-
-	ret = i915_gem_object_get_pages(obj);
+ retry:
+	ret = i915_gem_object_get_pages(obj, max_size);
 	if (ret)
 		return ret;
 
@@ -3015,6 +3020,10 @@ i915_gem_object_bind_to_gtt(struct drm_i915_gem_object *obj,
 	if (ret) {
 		i915_gem_object_unpin_pages(obj);
 		drm_mm_put_block(node);
+		if (max_size > PAGE_SIZE) {
+			max_size >> 1;
+			goto retry;
+		}
 		return ret;
 	}
 
diff --git a/drivers/gpu/drm/i915/i915_gem_dmabuf.c b/drivers/gpu/drm/i915/i915_gem_dmabuf.c
index dc53a52..8101387 100644
--- a/drivers/gpu/drm/i915/i915_gem_dmabuf.c
+++ b/drivers/gpu/drm/i915/i915_gem_dmabuf.c
@@ -230,7 +230,8 @@ struct dma_buf *i915_gem_prime_export(struct drm_device *dev,
 	return dma_buf_export(obj, &i915_dmabuf_ops, obj->base.size, flags);
 }
 
-static int i915_gem_object_get_pages_dmabuf(struct drm_i915_gem_object *obj)
+static int i915_gem_object_get_pages_dmabuf(struct drm_i915_gem_object *obj,
+					   unsigned long max)
 {
 	struct sg_table *sg;
 
diff --git a/drivers/gpu/drm/i915/i915_gem_stolen.c b/drivers/gpu/drm/i915/i915_gem_stolen.c
index 130d1db..9077ea9 100644
--- a/drivers/gpu/drm/i915/i915_gem_stolen.c
+++ b/drivers/gpu/drm/i915/i915_gem_stolen.c
@@ -231,7 +231,8 @@ i915_pages_create_for_stolen(struct drm_device *dev,
 	return st;
 }
 
-static int i915_gem_object_get_pages_stolen(struct drm_i915_gem_object *obj)
+static int i915_gem_object_get_pages_stolen(struct drm_i915_gem_object *obj,
+					    unsigned long max)
 {
 	BUG();
 	return -EINVAL;
