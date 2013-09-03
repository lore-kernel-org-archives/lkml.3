Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760210Ab3ICQb2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 12:31:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46637 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757058Ab3ICQ2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 12:28:52 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, Ben Widawsky <ben@bwidawsk.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 39/58] drm/i915: Move num_pipes to intel info
Date: Tue,  3 Sep 2013 09:23:43 -0700
Message-Id: <1378225442-20654-40-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378225442-20654-1-git-send-email-kamal@canonical.com>
References: <1378225442-20654-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Widawsky <ben@bwidawsk.net>

commit 7eb552aeae058a88eece91b902dd51fde45b1f41 upstream.

Requested by Daniel.

v2: Fix incorrect num_pipe settings. (Chris)

Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Ben Widawsky <ben@bwidawsk.net>
Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[ kamal: backport to 3.8 (context); 3.8.y-stable prereq for:
  63b66e5 drm/i915: Don't deref pipe->cpu_transcoder in the hangcheck code ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/i915_dma.c      |  9 +------
 drivers/gpu/drm/i915/i915_drv.c      | 48 ++++++++++++++++++------------------
 drivers/gpu/drm/i915/i915_drv.h      |  4 +--
 drivers/gpu/drm/i915/i915_irq.c      |  3 +--
 drivers/gpu/drm/i915/intel_display.c | 19 +++++++-------
 drivers/gpu/drm/i915/intel_fb.c      |  2 +-
 drivers/gpu/drm/i915/intel_panel.c   |  2 +-
 7 files changed, 40 insertions(+), 47 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 7e5f232..ef781e7 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1588,14 +1588,7 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
 	if (!IS_I945G(dev) && !IS_I945GM(dev))
 		pci_enable_msi(dev->pdev);
 
-	if (IS_IVYBRIDGE(dev) || IS_HASWELL(dev))
-		dev_priv->num_pipe = 3;
-	else if (IS_MOBILE(dev) || !IS_GEN2(dev))
-		dev_priv->num_pipe = 2;
-	else
-		dev_priv->num_pipe = 1;
-
-	ret = drm_vblank_init(dev, dev_priv->num_pipe);
+	ret = drm_vblank_init(dev, INTEL_INFO(dev)->num_pipes);
 	if (ret)
 		goto out_gem_unload;
 
diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index be9ddec..a749aca 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -138,74 +138,74 @@ extern int intel_agp_enabled;
 	.driver_data = (unsigned long) info }
 
 static const struct intel_device_info intel_i830_info = {
-	.gen = 2, .is_mobile = 1, .cursor_needs_physical = 1,
+	.gen = 2, .is_mobile = 1, .cursor_needs_physical = 1, .num_pipes = 2,
 	.has_overlay = 1, .overlay_needs_physical = 1,
 };
 
 static const struct intel_device_info intel_845g_info = {
-	.gen = 2,
+	.gen = 2, .num_pipes = 1,
 	.has_overlay = 1, .overlay_needs_physical = 1,
 };
 
 static const struct intel_device_info intel_i85x_info = {
-	.gen = 2, .is_i85x = 1, .is_mobile = 1,
+	.gen = 2, .is_i85x = 1, .is_mobile = 1, .num_pipes = 2,
 	.cursor_needs_physical = 1,
 	.has_overlay = 1, .overlay_needs_physical = 1,
 };
 
 static const struct intel_device_info intel_i865g_info = {
-	.gen = 2,
+	.gen = 2, .num_pipes = 1,
 	.has_overlay = 1, .overlay_needs_physical = 1,
 };
 
 static const struct intel_device_info intel_i915g_info = {
-	.gen = 3, .is_i915g = 1, .cursor_needs_physical = 1,
+	.gen = 3, .is_i915g = 1, .cursor_needs_physical = 1, .num_pipes = 2,
 	.has_overlay = 1, .overlay_needs_physical = 1,
 };
 static const struct intel_device_info intel_i915gm_info = {
-	.gen = 3, .is_mobile = 1,
+	.gen = 3, .is_mobile = 1, .num_pipes = 2,
 	.cursor_needs_physical = 1,
 	.has_overlay = 1, .overlay_needs_physical = 1,
 	.supports_tv = 1,
 };
 static const struct intel_device_info intel_i945g_info = {
-	.gen = 3, .has_hotplug = 1, .cursor_needs_physical = 1,
+	.gen = 3, .has_hotplug = 1, .cursor_needs_physical = 1, .num_pipes = 2,
 	.has_overlay = 1, .overlay_needs_physical = 1,
 };
 static const struct intel_device_info intel_i945gm_info = {
-	.gen = 3, .is_i945gm = 1, .is_mobile = 1,
+	.gen = 3, .is_i945gm = 1, .is_mobile = 1, .num_pipes = 2,
 	.has_hotplug = 1, .cursor_needs_physical = 1,
 	.has_overlay = 1, .overlay_needs_physical = 1,
 	.supports_tv = 1,
 };
 
 static const struct intel_device_info intel_i965g_info = {
-	.gen = 4, .is_broadwater = 1,
+	.gen = 4, .is_broadwater = 1, .num_pipes = 2,
 	.has_hotplug = 1,
 	.has_overlay = 1,
 };
 
 static const struct intel_device_info intel_i965gm_info = {
-	.gen = 4, .is_crestline = 1,
+	.gen = 4, .is_crestline = 1, .num_pipes = 2,
 	.is_mobile = 1, .has_fbc = 1, .has_hotplug = 1,
 	.has_overlay = 1,
 	.supports_tv = 1,
 };
 
 static const struct intel_device_info intel_g33_info = {
-	.gen = 3, .is_g33 = 1,
+	.gen = 3, .is_g33 = 1, .num_pipes = 2,
 	.need_gfx_hws = 1, .has_hotplug = 1,
 	.has_overlay = 1,
 };
 
 static const struct intel_device_info intel_g45_info = {
-	.gen = 4, .is_g4x = 1, .need_gfx_hws = 1,
+	.gen = 4, .is_g4x = 1, .need_gfx_hws = 1, .num_pipes = 2,
 	.has_pipe_cxsr = 1, .has_hotplug = 1,
 	.has_bsd_ring = 1,
 };
 
 static const struct intel_device_info intel_gm45_info = {
-	.gen = 4, .is_g4x = 1,
+	.gen = 4, .is_g4x = 1, .num_pipes = 2,
 	.is_mobile = 1, .need_gfx_hws = 1, .has_fbc = 1,
 	.has_pipe_cxsr = 1, .has_hotplug = 1,
 	.supports_tv = 1,
@@ -213,26 +213,26 @@ static const struct intel_device_info intel_gm45_info = {
 };
 
 static const struct intel_device_info intel_pineview_info = {
-	.gen = 3, .is_g33 = 1, .is_pineview = 1, .is_mobile = 1,
+	.gen = 3, .is_g33 = 1, .is_pineview = 1, .is_mobile = 1, .num_pipes = 2,
 	.need_gfx_hws = 1, .has_hotplug = 1,
 	.has_overlay = 1,
 };
 
 static const struct intel_device_info intel_ironlake_d_info = {
-	.gen = 5,
+	.gen = 5, .num_pipes = 2,
 	.need_gfx_hws = 1, .has_hotplug = 1,
 	.has_bsd_ring = 1,
 };
 
 static const struct intel_device_info intel_ironlake_m_info = {
-	.gen = 5, .is_mobile = 1,
+	.gen = 5, .is_mobile = 1, .num_pipes = 2,
 	.need_gfx_hws = 1, .has_hotplug = 1,
 	.has_fbc = 1,
 	.has_bsd_ring = 1,
 };
 
 static const struct intel_device_info intel_sandybridge_d_info = {
-	.gen = 6,
+	.gen = 6, .num_pipes = 2,
 	.need_gfx_hws = 1, .has_hotplug = 1,
 	.has_bsd_ring = 1,
 	.has_blt_ring = 1,
@@ -241,7 +241,7 @@ static const struct intel_device_info intel_sandybridge_d_info = {
 };
 
 static const struct intel_device_info intel_sandybridge_m_info = {
-	.gen = 6, .is_mobile = 1,
+	.gen = 6, .is_mobile = 1, .num_pipes = 2,
 	.need_gfx_hws = 1, .has_hotplug = 1,
 	.has_fbc = 1,
 	.has_bsd_ring = 1,
@@ -251,7 +251,7 @@ static const struct intel_device_info intel_sandybridge_m_info = {
 };
 
 static const struct intel_device_info intel_ivybridge_d_info = {
-	.is_ivybridge = 1, .gen = 7,
+	.is_ivybridge = 1, .gen = 7, .num_pipes = 3,
 	.need_gfx_hws = 1, .has_hotplug = 1,
 	.has_bsd_ring = 1,
 	.has_blt_ring = 1,
@@ -260,7 +260,7 @@ static const struct intel_device_info intel_ivybridge_d_info = {
 };
 
 static const struct intel_device_info intel_ivybridge_m_info = {
-	.is_ivybridge = 1, .gen = 7, .is_mobile = 1,
+	.is_ivybridge = 1, .gen = 7, .is_mobile = 1, .num_pipes = 3,
 	.need_gfx_hws = 1, .has_hotplug = 1,
 	.has_fbc = 0,	/* FBC is not enabled on Ivybridge mobile yet */
 	.has_bsd_ring = 1,
@@ -270,7 +270,7 @@ static const struct intel_device_info intel_ivybridge_m_info = {
 };
 
 static const struct intel_device_info intel_valleyview_m_info = {
-	.gen = 7, .is_mobile = 1,
+	.gen = 7, .is_mobile = 1, .num_pipes = 2,
 	.need_gfx_hws = 1, .has_hotplug = 1,
 	.has_fbc = 0,
 	.has_bsd_ring = 1,
@@ -279,7 +279,7 @@ static const struct intel_device_info intel_valleyview_m_info = {
 };
 
 static const struct intel_device_info intel_valleyview_d_info = {
-	.gen = 7,
+	.gen = 7, .num_pipes = 2,
 	.need_gfx_hws = 1, .has_hotplug = 1,
 	.has_fbc = 0,
 	.has_bsd_ring = 1,
@@ -288,7 +288,7 @@ static const struct intel_device_info intel_valleyview_d_info = {
 };
 
 static const struct intel_device_info intel_haswell_d_info = {
-	.is_haswell = 1, .gen = 7,
+	.is_haswell = 1, .gen = 7, .num_pipes = 3,
 	.need_gfx_hws = 1, .has_hotplug = 1,
 	.has_bsd_ring = 1,
 	.has_blt_ring = 1,
@@ -297,7 +297,7 @@ static const struct intel_device_info intel_haswell_d_info = {
 };
 
 static const struct intel_device_info intel_haswell_m_info = {
-	.is_haswell = 1, .gen = 7, .is_mobile = 1,
+	.is_haswell = 1, .gen = 7, .is_mobile = 1, .num_pipes = 3,
 	.need_gfx_hws = 1, .has_hotplug = 1,
 	.has_bsd_ring = 1,
 	.has_blt_ring = 1,
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index d47283d..8b8c4cf 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -85,7 +85,7 @@ enum port {
 
 #define I915_GEM_GPU_DOMAINS	(~(I915_GEM_DOMAIN_CPU | I915_GEM_DOMAIN_GTT))
 
-#define for_each_pipe(p) for ((p) = 0; (p) < dev_priv->num_pipe; (p)++)
+#define for_each_pipe(p) for ((p) = 0; (p) < INTEL_INFO(dev)->num_pipes; (p)++)
 
 #define for_each_encoder_on_crtc(dev, __crtc, intel_encoder) \
 	list_for_each_entry((intel_encoder), &(dev)->mode_config.encoder_list, base.head) \
@@ -318,6 +318,7 @@ struct drm_i915_gt_funcs {
 	DEV_INFO_FLAG(has_llc)
 
 struct intel_device_info {
+	u8 num_pipes:3;
 	u8 gen;
 	u8 is_mobile:1;
 	u8 is_i85x:1;
@@ -674,7 +675,6 @@ typedef struct drm_i915_private {
 	u32 hotplug_supported_mask;
 	struct work_struct hotplug_work;
 
-	int num_pipe;
 	int num_pch_pll;
 
 	/* For hangcheck timer */
diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index fe84338..7edcb6c 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -250,10 +250,9 @@ static int i915_get_vblank_timestamp(struct drm_device *dev, int pipe,
 			      struct timeval *vblank_time,
 			      unsigned flags)
 {
-	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct drm_crtc *crtc;
 
-	if (pipe < 0 || pipe >= dev_priv->num_pipe) {
+	if (pipe < 0 || pipe >= INTEL_INFO(dev)->num_pipes) {
 		DRM_ERROR("Invalid crtc %d\n", pipe);
 		return -EINVAL;
 	}
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 1f20ac5..b101a02 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -2315,10 +2315,10 @@ intel_pipe_set_base(struct drm_crtc *crtc, int x, int y,
 		return 0;
 	}
 
-	if(intel_crtc->plane > dev_priv->num_pipe) {
+	if (intel_crtc->plane > INTEL_INFO(dev)->num_pipes) {
 		DRM_ERROR("no plane for crtc: plane %d, num_pipes %d\n",
 				intel_crtc->plane,
-				dev_priv->num_pipe);
+				INTEL_INFO(dev)->num_pipes);
 		return -EINVAL;
 	}
 
@@ -5360,7 +5360,7 @@ static bool ironlake_check_fdi_lanes(struct intel_crtc *intel_crtc)
 		return false;
 	}
 
-	if (dev_priv->num_pipe == 2)
+	if (INTEL_INFO(dev)->num_pipes == 2)
 		return true;
 
 	switch (intel_crtc->pipe) {
@@ -9034,9 +9034,10 @@ void intel_modeset_init(struct drm_device *dev)
 	dev->mode_config.fb_base = dev_priv->mm.gtt_base_addr;
 
 	DRM_DEBUG_KMS("%d display pipe%s available.\n",
-		      dev_priv->num_pipe, dev_priv->num_pipe > 1 ? "s" : "");
+		      INTEL_INFO(dev)->num_pipes,
+		      INTEL_INFO(dev)->num_pipes > 1 ? "s" : "");
 
-	for (i = 0; i < dev_priv->num_pipe; i++) {
+	for (i = 0; i < INTEL_INFO(dev)->num_pipes; i++) {
 		intel_crtc_init(dev, i);
 		ret = intel_plane_init(dev, i);
 		if (ret)
@@ -9090,10 +9091,11 @@ static void intel_enable_pipe_a(struct drm_device *dev)
 static bool
 intel_check_plane_mapping(struct intel_crtc *crtc)
 {
-	struct drm_i915_private *dev_priv = crtc->base.dev->dev_private;
+	struct drm_device *dev = crtc->base.dev;
+	struct drm_i915_private *dev_priv = dev->dev_private;
 	u32 reg, val;
 
-	if (dev_priv->num_pipe == 1)
+	if (INTEL_INFO(dev)->num_pipes == 1)
 		return true;
 
 	reg = DSPCNTR(!crtc->plane);
@@ -9536,10 +9538,9 @@ intel_display_print_error_state(struct seq_file *m,
 				struct drm_device *dev,
 				struct intel_display_error_state *error)
 {
-	drm_i915_private_t *dev_priv = dev->dev_private;
 	int i;
 
-	seq_printf(m, "Num Pipes: %d\n", dev_priv->num_pipe);
+	seq_printf(m, "Num Pipes: %d\n", INTEL_INFO(dev)->num_pipes);
 	for_each_pipe(i) {
 		seq_printf(m, "Pipe [%d]:\n", i);
 		seq_printf(m, "  CONF: %08x\n", error->pipe[i].conf);
diff --git a/drivers/gpu/drm/i915/intel_fb.c b/drivers/gpu/drm/i915/intel_fb.c
index 7b30b5c..c692458 100644
--- a/drivers/gpu/drm/i915/intel_fb.c
+++ b/drivers/gpu/drm/i915/intel_fb.c
@@ -233,7 +233,7 @@ int intel_fbdev_init(struct drm_device *dev)
 	ifbdev->helper.funcs = &intel_fb_helper_funcs;
 
 	ret = drm_fb_helper_init(dev, &ifbdev->helper,
-				 dev_priv->num_pipe,
+				 INTEL_INFO(dev)->num_pipes,
 				 INTELFB_CONN_LIMIT);
 	if (ret) {
 		kfree(ifbdev);
diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
index 8df501a..56abfc1 100644
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -346,7 +346,7 @@ void intel_panel_enable_backlight(struct drm_device *dev,
 		if (tmp & BLM_PWM_ENABLE)
 			goto set_level;
 
-		if (dev_priv->num_pipe == 3)
+		if (INTEL_INFO(dev)->num_pipes == 3)
 			tmp &= ~BLM_PIPE_SELECT_IVB;
 		else
 			tmp &= ~BLM_PIPE_SELECT;
-- 
1.8.1.2

