Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab3GWCDN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 22:03:13 -0400
Received: from home.keithp.com ([63.227.221.253]:43594 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754257Ab3GWCCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 22:02:20 -0400
From: Keith Packard <keithp@keithp.com>
To: linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>
Cc: Keith Packard <keithp@keithp.com>, dri-devel@lists.freedesktop.org
Subject: [PATCH 1/5] drm: Pass page flip ioctl flags to driver
Date: Mon, 22 Jul 2013 18:49:58 -0700
Message-Id: <1374544202-15496-2-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1374544202-15496-1-git-send-email-keithp@keithp.com>
References: <1374544202-15496-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This lets drivers see the flags requested by the application

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/drm_crtc.c                |  2 +-
 drivers/gpu/drm/exynos/exynos_drm_crtc.c  |  5 +++--
 drivers/gpu/drm/i915/i915_drv.h           |  3 ++-
 drivers/gpu/drm/i915/intel_display.c      | 23 +++++++++++++++--------
 drivers/gpu/drm/nouveau/nouveau_display.c |  3 ++-
 drivers/gpu/drm/nouveau/nouveau_display.h |  3 ++-
 drivers/gpu/drm/omapdrm/omap_crtc.c       |  3 ++-
 drivers/gpu/drm/radeon/radeon_display.c   |  3 ++-
 drivers/gpu/drm/shmobile/shmob_drm_crtc.c |  3 ++-
 drivers/gpu/drm/tilcdc/tilcdc_crtc.c      |  3 ++-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c       |  3 ++-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.h       |  3 ++-
 include/drm/drm_crtc.h                    |  3 ++-
 13 files changed, 39 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index fc83bb9..989072c 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -3587,7 +3587,7 @@ int drm_mode_page_flip_ioctl(struct drm_device *dev,
 	}
 
 	old_fb = crtc->fb;
-	ret = crtc->funcs->page_flip(crtc, fb, e);
+	ret = crtc->funcs->page_flip(crtc, fb, e, page_flip->flags);
 	if (ret) {
 		if (page_flip->flags & DRM_MODE_PAGE_FLIP_EVENT) {
 			spin_lock_irqsave(&dev->event_lock, flags);
diff --git a/drivers/gpu/drm/exynos/exynos_drm_crtc.c b/drivers/gpu/drm/exynos/exynos_drm_crtc.c
index 9a35d17..14f5c1d 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_crtc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_crtc.c
@@ -184,8 +184,9 @@ static struct drm_crtc_helper_funcs exynos_crtc_helper_funcs = {
 };
 
 static int exynos_drm_crtc_page_flip(struct drm_crtc *crtc,
-				      struct drm_framebuffer *fb,
-				      struct drm_pending_vblank_event *event)
+				     struct drm_framebuffer *fb,
+				     struct drm_pending_vblank_event *event,
+				     uint32_t page_flip_flags)
 {
 	struct drm_device *dev = crtc->dev;
 	struct exynos_drm_private *dev_priv = dev->dev_private;
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index cef35d3..c7cb2de 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -380,7 +380,8 @@ struct drm_i915_display_funcs {
 	void (*init_clock_gating)(struct drm_device *dev);
 	int (*queue_flip)(struct drm_device *dev, struct drm_crtc *crtc,
 			  struct drm_framebuffer *fb,
-			  struct drm_i915_gem_object *obj);
+			  struct drm_i915_gem_object *obj,
+			  uint32_t flags);
 	int (*update_plane)(struct drm_crtc *crtc, struct drm_framebuffer *fb,
 			    int x, int y);
 	void (*hpd_irq_setup)(struct drm_device *dev);
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index ae3dc5d..bdb8854 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7320,7 +7320,8 @@ inline static void intel_mark_page_flip_active(struct intel_crtc *intel_crtc)
 static int intel_gen2_queue_flip(struct drm_device *dev,
 				 struct drm_crtc *crtc,
 				 struct drm_framebuffer *fb,
-				 struct drm_i915_gem_object *obj)
+				 struct drm_i915_gem_object *obj,
+				 uint32_t flags)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct intel_crtc *intel_crtc = to_intel_crtc(crtc);
@@ -7364,7 +7365,8 @@ err:
 static int intel_gen3_queue_flip(struct drm_device *dev,
 				 struct drm_crtc *crtc,
 				 struct drm_framebuffer *fb,
-				 struct drm_i915_gem_object *obj)
+				 struct drm_i915_gem_object *obj,
+				 uint32_t flags)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct intel_crtc *intel_crtc = to_intel_crtc(crtc);
@@ -7405,7 +7407,8 @@ err:
 static int intel_gen4_queue_flip(struct drm_device *dev,
 				 struct drm_crtc *crtc,
 				 struct drm_framebuffer *fb,
-				 struct drm_i915_gem_object *obj)
+				 struct drm_i915_gem_object *obj,
+				 uint32_t flags)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct intel_crtc *intel_crtc = to_intel_crtc(crtc);
@@ -7453,7 +7456,8 @@ err:
 static int intel_gen6_queue_flip(struct drm_device *dev,
 				 struct drm_crtc *crtc,
 				 struct drm_framebuffer *fb,
-				 struct drm_i915_gem_object *obj)
+				 struct drm_i915_gem_object *obj,
+				 uint32_t flags)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct intel_crtc *intel_crtc = to_intel_crtc(crtc);
@@ -7503,7 +7507,8 @@ err:
 static int intel_gen7_queue_flip(struct drm_device *dev,
 				 struct drm_crtc *crtc,
 				 struct drm_framebuffer *fb,
-				 struct drm_i915_gem_object *obj)
+				 struct drm_i915_gem_object *obj,
+				 uint32_t flags)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct intel_crtc *intel_crtc = to_intel_crtc(crtc);
@@ -7553,14 +7558,16 @@ err:
 static int intel_default_queue_flip(struct drm_device *dev,
 				    struct drm_crtc *crtc,
 				    struct drm_framebuffer *fb,
-				    struct drm_i915_gem_object *obj)
+				    struct drm_i915_gem_object *obj,
+				    uint32_t flags)
 {
 	return -ENODEV;
 }
 
 static int intel_crtc_page_flip(struct drm_crtc *crtc,
 				struct drm_framebuffer *fb,
-				struct drm_pending_vblank_event *event)
+				struct drm_pending_vblank_event *event,
+				uint32_t page_flip_flags)
 {
 	struct drm_device *dev = crtc->dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
@@ -7630,7 +7637,7 @@ static int intel_crtc_page_flip(struct drm_crtc *crtc,
 	atomic_inc(&intel_crtc->unpin_work_count);
 	intel_crtc->reset_counter = atomic_read(&dev_priv->gpu_error.reset_counter);
 
-	ret = dev_priv->display.queue_flip(dev, crtc, fb, obj);
+	ret = dev_priv->display.queue_flip(dev, crtc, fb, obj, page_flip_flags);
 	if (ret)
 		goto cleanup_pending;
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_display.c b/drivers/gpu/drm/nouveau/nouveau_display.c
index 708b2d1..fdb43c5 100644
--- a/drivers/gpu/drm/nouveau/nouveau_display.c
+++ b/drivers/gpu/drm/nouveau/nouveau_display.c
@@ -515,7 +515,8 @@ fail:
 
 int
 nouveau_crtc_page_flip(struct drm_crtc *crtc, struct drm_framebuffer *fb,
-		       struct drm_pending_vblank_event *event)
+		       struct drm_pending_vblank_event *event,
+		       uint32_t page_flip_flags)
 {
 	struct drm_device *dev = crtc->dev;
 	struct nouveau_drm *drm = nouveau_drm(dev);
diff --git a/drivers/gpu/drm/nouveau/nouveau_display.h b/drivers/gpu/drm/nouveau/nouveau_display.h
index 1ea3e47..12bcffe 100644
--- a/drivers/gpu/drm/nouveau/nouveau_display.h
+++ b/drivers/gpu/drm/nouveau/nouveau_display.h
@@ -60,7 +60,8 @@ int  nouveau_display_suspend(struct drm_device *dev);
 void nouveau_display_resume(struct drm_device *dev);
 
 int  nouveau_crtc_page_flip(struct drm_crtc *crtc, struct drm_framebuffer *fb,
-			    struct drm_pending_vblank_event *event);
+			    struct drm_pending_vblank_event *event,
+			    uint32_t page_flip_flags);
 int  nouveau_finish_page_flip(struct nouveau_channel *,
 			      struct nouveau_page_flip_state *);
 
diff --git a/drivers/gpu/drm/omapdrm/omap_crtc.c b/drivers/gpu/drm/omapdrm/omap_crtc.c
index 11a5263..0fd2eb1 100644
--- a/drivers/gpu/drm/omapdrm/omap_crtc.c
+++ b/drivers/gpu/drm/omapdrm/omap_crtc.c
@@ -331,7 +331,8 @@ static void page_flip_cb(void *arg)
 
 static int omap_crtc_page_flip_locked(struct drm_crtc *crtc,
 		 struct drm_framebuffer *fb,
-		 struct drm_pending_vblank_event *event)
+		 struct drm_pending_vblank_event *event,
+		 uint32_t page_flip_flags)
 {
 	struct drm_device *dev = crtc->dev;
 	struct omap_crtc *omap_crtc = to_omap_crtc(crtc);
diff --git a/drivers/gpu/drm/radeon/radeon_display.c b/drivers/gpu/drm/radeon/radeon_display.c
index c2b67b4..358bd96 100644
--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -345,7 +345,8 @@ void radeon_crtc_handle_flip(struct radeon_device *rdev, int crtc_id)
 
 static int radeon_crtc_page_flip(struct drm_crtc *crtc,
 				 struct drm_framebuffer *fb,
-				 struct drm_pending_vblank_event *event)
+				 struct drm_pending_vblank_event *event,
+				 uint32_t page_flip_flags)
 {
 	struct drm_device *dev = crtc->dev;
 	struct radeon_device *rdev = dev->dev_private;
diff --git a/drivers/gpu/drm/shmobile/shmob_drm_crtc.c b/drivers/gpu/drm/shmobile/shmob_drm_crtc.c
index 99e2034..54bad98 100644
--- a/drivers/gpu/drm/shmobile/shmob_drm_crtc.c
+++ b/drivers/gpu/drm/shmobile/shmob_drm_crtc.c
@@ -465,7 +465,8 @@ void shmob_drm_crtc_finish_page_flip(struct shmob_drm_crtc *scrtc)
 
 static int shmob_drm_crtc_page_flip(struct drm_crtc *crtc,
 				    struct drm_framebuffer *fb,
-				    struct drm_pending_vblank_event *event)
+				    struct drm_pending_vblank_event *event,
+				    uint32_t page_flip_flags)
 {
 	struct shmob_drm_crtc *scrtc = to_shmob_crtc(crtc);
 	struct drm_device *dev = scrtc->crtc.dev;
diff --git a/drivers/gpu/drm/tilcdc/tilcdc_crtc.c b/drivers/gpu/drm/tilcdc/tilcdc_crtc.c
index 7418dcd..8615773 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_crtc.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_crtc.c
@@ -156,7 +156,8 @@ static void tilcdc_crtc_destroy(struct drm_crtc *crtc)
 
 static int tilcdc_crtc_page_flip(struct drm_crtc *crtc,
 		struct drm_framebuffer *fb,
-		struct drm_pending_vblank_event *event)
+		struct drm_pending_vblank_event *event,
+		uint32_t page_flip_flags)
 {
 	struct tilcdc_crtc *tilcdc_crtc = to_tilcdc_crtc(crtc);
 	struct drm_device *dev = crtc->dev;
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
index d4607b2..fc43c06 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -1706,7 +1706,8 @@ int vmw_du_update_layout(struct vmw_private *dev_priv, unsigned num,
 
 int vmw_du_page_flip(struct drm_crtc *crtc,
 		     struct drm_framebuffer *fb,
-		     struct drm_pending_vblank_event *event)
+		     struct drm_pending_vblank_event *event,
+		     uint32_t page_flip_flags)
 {
 	struct vmw_private *dev_priv = vmw_priv(crtc->dev);
 	struct drm_framebuffer *old_fb = crtc->fb;
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.h b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.h
index 6fa89c9..8d038c3 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.h
@@ -123,7 +123,8 @@ struct vmw_display_unit {
 void vmw_display_unit_cleanup(struct vmw_display_unit *du);
 int vmw_du_page_flip(struct drm_crtc *crtc,
 		     struct drm_framebuffer *fb,
-		     struct drm_pending_vblank_event *event);
+		     struct drm_pending_vblank_event *event,
+		     uint32_t page_flip_flags);
 void vmw_du_crtc_save(struct drm_crtc *crtc);
 void vmw_du_crtc_restore(struct drm_crtc *crtc);
 void vmw_du_crtc_gamma_set(struct drm_crtc *crtc,
diff --git a/include/drm/drm_crtc.h b/include/drm/drm_crtc.h
index fa12a2f..0820ab6 100644
--- a/include/drm/drm_crtc.h
+++ b/include/drm/drm_crtc.h
@@ -363,7 +363,8 @@ struct drm_crtc_funcs {
 	 */
 	int (*page_flip)(struct drm_crtc *crtc,
 			 struct drm_framebuffer *fb,
-			 struct drm_pending_vblank_event *event);
+			 struct drm_pending_vblank_event *event,
+			 uint32_t flags);
 
 	int (*set_property)(struct drm_crtc *crtc,
 			    struct drm_property *property, uint64_t val);
-- 
1.8.3.2

