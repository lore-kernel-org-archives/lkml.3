Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239AbbATKtk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:49:40 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:61288 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211AbbATKtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:49:36 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 22/36] drm/tegra: Atomic conversion, phase 1
Date: Tue, 20 Jan 2015 11:48:41 +0100
Message-Id: <1421750935-4023-23-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
References: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Implement initial atomic state handling. Hook up the CRTCs, planes' and
connectors' ->atomic_destroy_state() callback to ensure that the atomic
state objects don't leak.

Furthermore the CRTC now implements the ->mode_set_nofb() callback that
is used by new helpers to implement ->mode_set() and ->mode_set_base().
These new helpers also make use of the new plane helper functions which
the driver now provides.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/gpu/drm/tegra/dc.c     | 397 ++++++++++++++++++++++-------------------
 drivers/gpu/drm/tegra/drm.c    |   2 +-
 drivers/gpu/drm/tegra/dsi.c    |   2 +
 drivers/gpu/drm/tegra/hdmi.c   |   2 +
 drivers/gpu/drm/tegra/output.c |   1 +
 drivers/gpu/drm/tegra/rgb.c    |   2 +
 drivers/gpu/drm/tegra/sor.c    |   2 +
 7 files changed, 223 insertions(+), 185 deletions(-)

diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index 846daf48cf61..e7efb6ca127c 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -25,6 +25,7 @@
 #include "drm.h"
 #include "gem.h"
 
+#include <drm/drm_atomic_helper.h>
 #include <drm/drm_plane_helper.h>
 
 struct tegra_dc_soc_info {
@@ -207,8 +208,8 @@ static inline u32 compute_initial_dda(unsigned int in)
 	return dfixed_frac(inf);
 }
 
-static int tegra_dc_setup_window(struct tegra_dc *dc, unsigned int index,
-				 const struct tegra_dc_window *window)
+static void tegra_dc_setup_window(struct tegra_dc *dc, unsigned int index,
+				  const struct tegra_dc_window *window)
 {
 	unsigned h_offset, v_offset, h_size, v_size, h_dda, v_dda, bpp;
 	unsigned long value, flags;
@@ -317,9 +318,11 @@ static int tegra_dc_setup_window(struct tegra_dc *dc, unsigned int index,
 			break;
 
 		case TEGRA_BO_TILING_MODE_BLOCK:
-			DRM_ERROR("hardware doesn't support block linear mode\n");
-			spin_unlock_irqrestore(&dc->lock, flags);
-			return -EINVAL;
+			/*
+			 * No need to handle this here because ->atomic_check
+			 * will already have filtered it out.
+			 */
+			break;
 		}
 
 		tegra_dc_writel(dc, value, DC_WIN_BUFFER_ADDR_MODE);
@@ -378,34 +381,6 @@ static int tegra_dc_setup_window(struct tegra_dc *dc, unsigned int index,
 	tegra_dc_window_commit(dc, index);
 
 	spin_unlock_irqrestore(&dc->lock, flags);
-
-	return 0;
-}
-
-static int tegra_window_plane_disable(struct drm_plane *plane)
-{
-	struct tegra_dc *dc = to_tegra_dc(plane->crtc);
-	struct tegra_plane *p = to_tegra_plane(plane);
-	unsigned long flags;
-	u32 value;
-
-	if (!plane->crtc)
-		return 0;
-
-	spin_lock_irqsave(&dc->lock, flags);
-
-	value = WINDOW_A_SELECT << p->index;
-	tegra_dc_writel(dc, value, DC_CMD_DISPLAY_WINDOW_HEADER);
-
-	value = tegra_dc_readl(dc, DC_WIN_WIN_OPTIONS);
-	value &= ~WIN_ENABLE;
-	tegra_dc_writel(dc, value, DC_WIN_WIN_OPTIONS);
-
-	tegra_dc_window_commit(dc, p->index);
-
-	spin_unlock_irqrestore(&dc->lock, flags);
-
-	return 0;
 }
 
 static void tegra_plane_destroy(struct drm_plane *plane)
@@ -422,57 +397,139 @@ static const u32 tegra_primary_plane_formats[] = {
 	DRM_FORMAT_RGB565,
 };
 
-static int tegra_primary_plane_update(struct drm_plane *plane,
-				      struct drm_crtc *crtc,
-				      struct drm_framebuffer *fb, int crtc_x,
-				      int crtc_y, unsigned int crtc_w,
-				      unsigned int crtc_h, uint32_t src_x,
-				      uint32_t src_y, uint32_t src_w,
-				      uint32_t src_h)
+static void tegra_primary_plane_destroy(struct drm_plane *plane)
 {
-	struct tegra_bo *bo = tegra_fb_get_plane(fb, 0);
+	tegra_plane_destroy(plane);
+}
+
+static const struct drm_plane_funcs tegra_primary_plane_funcs = {
+	.update_plane = drm_plane_helper_update,
+	.disable_plane = drm_plane_helper_disable,
+	.destroy = tegra_primary_plane_destroy,
+	.atomic_destroy_state = drm_atomic_helper_plane_destroy_state,
+};
+
+static int tegra_plane_prepare_fb(struct drm_plane *plane,
+				  struct drm_framebuffer *fb)
+{
+	return 0;
+}
+
+static void tegra_plane_cleanup_fb(struct drm_plane *plane,
+				   struct drm_framebuffer *fb)
+{
+}
+
+static int tegra_plane_atomic_check(struct drm_plane *plane,
+				    struct drm_plane_state *state)
+{
+	struct tegra_dc *dc = to_tegra_dc(state->crtc);
+	struct tegra_bo_tiling tiling;
+	int err;
+
+	/* no need for further checks if the plane is being disabled */
+	if (!state->crtc)
+		return 0;
+
+	err = tegra_fb_get_tiling(state->fb, &tiling);
+	if (err < 0)
+		return err;
+
+	if (tiling.mode == TEGRA_BO_TILING_MODE_BLOCK &&
+	    !dc->soc->supports_block_linear) {
+		DRM_ERROR("hardware doesn't support block linear mode\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * Tegra doesn't support different strides for U and V planes so we
+	 * error out if the user tries to display a framebuffer with such a
+	 * configuration.
+	 */
+	if (drm_format_num_planes(state->fb->pixel_format) > 2) {
+		if (state->fb->pitches[2] != state->fb->pitches[1]) {
+			DRM_ERROR("unsupported UV-plane configuration\n");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static void tegra_plane_atomic_update(struct drm_plane *plane,
+				      struct drm_plane_state *old_state)
+{
+	struct tegra_dc *dc = to_tegra_dc(plane->state->crtc);
+	struct drm_framebuffer *fb = plane->state->fb;
 	struct tegra_plane *p = to_tegra_plane(plane);
-	struct tegra_dc *dc = to_tegra_dc(crtc);
 	struct tegra_dc_window window;
+	unsigned int i;
 	int err;
 
+	/* rien ne va plus */
+	if (!plane->state->crtc || !plane->state->fb)
+		return;
+
 	memset(&window, 0, sizeof(window));
-	window.src.x = src_x >> 16;
-	window.src.y = src_y >> 16;
-	window.src.w = src_w >> 16;
-	window.src.h = src_h >> 16;
-	window.dst.x = crtc_x;
-	window.dst.y = crtc_y;
-	window.dst.w = crtc_w;
-	window.dst.h = crtc_h;
+	window.src.x = plane->state->src_x >> 16;
+	window.src.y = plane->state->src_y >> 16;
+	window.src.w = plane->state->src_w >> 16;
+	window.src.h = plane->state->src_h >> 16;
+	window.dst.x = plane->state->crtc_x;
+	window.dst.y = plane->state->crtc_y;
+	window.dst.w = plane->state->crtc_w;
+	window.dst.h = plane->state->crtc_h;
 	window.format = tegra_dc_format(fb->pixel_format, &window.swap);
 	window.bits_per_pixel = fb->bits_per_pixel;
 	window.bottom_up = tegra_fb_is_bottom_up(fb);
 
 	err = tegra_fb_get_tiling(fb, &window.tiling);
-	if (err < 0)
-		return err;
+	WARN_ON(err < 0);
 
-	window.base[0] = bo->paddr + fb->offsets[0];
-	window.stride[0] = fb->pitches[0];
+	for (i = 0; i < drm_format_num_planes(fb->pixel_format); i++) {
+		struct tegra_bo *bo = tegra_fb_get_plane(fb, i);
 
-	err = tegra_dc_setup_window(dc, p->index, &window);
-	if (err < 0)
-		return err;
+		window.base[i] = bo->paddr + fb->offsets[i];
+		window.stride[i] = fb->pitches[i];
+	}
 
-	return 0;
+	tegra_dc_setup_window(dc, p->index, &window);
 }
 
-static void tegra_primary_plane_destroy(struct drm_plane *plane)
+static void tegra_plane_atomic_disable(struct drm_plane *plane,
+				       struct drm_plane_state *old_state)
 {
-	tegra_window_plane_disable(plane);
-	tegra_plane_destroy(plane);
+	struct tegra_plane *p = to_tegra_plane(plane);
+	struct tegra_dc *dc;
+	unsigned long flags;
+	u32 value;
+
+	/* rien ne va plus */
+	if (!old_state || !old_state->crtc)
+		return;
+
+	dc = to_tegra_dc(old_state->crtc);
+
+	spin_lock_irqsave(&dc->lock, flags);
+
+	value = WINDOW_A_SELECT << p->index;
+	tegra_dc_writel(dc, value, DC_CMD_DISPLAY_WINDOW_HEADER);
+
+	value = tegra_dc_readl(dc, DC_WIN_WIN_OPTIONS);
+	value &= ~WIN_ENABLE;
+	tegra_dc_writel(dc, value, DC_WIN_WIN_OPTIONS);
+
+	tegra_dc_window_commit(dc, p->index);
+
+	spin_unlock_irqrestore(&dc->lock, flags);
 }
 
-static const struct drm_plane_funcs tegra_primary_plane_funcs = {
-	.update_plane = tegra_primary_plane_update,
-	.disable_plane = tegra_window_plane_disable,
-	.destroy = tegra_primary_plane_destroy,
+static const struct drm_plane_helper_funcs tegra_primary_plane_helper_funcs = {
+	.prepare_fb = tegra_plane_prepare_fb,
+	.cleanup_fb = tegra_plane_cleanup_fb,
+	.atomic_check = tegra_plane_atomic_check,
+	.atomic_update = tegra_plane_atomic_update,
+	.atomic_disable = tegra_plane_atomic_disable,
 };
 
 static struct drm_plane *tegra_dc_primary_plane_create(struct drm_device *drm,
@@ -511,6 +568,8 @@ static struct drm_plane *tegra_dc_primary_plane_create(struct drm_device *drm,
 		return ERR_PTR(err);
 	}
 
+	drm_plane_helper_add(&plane->base, &tegra_primary_plane_helper_funcs);
+
 	return &plane->base;
 }
 
@@ -518,27 +577,42 @@ static const u32 tegra_cursor_plane_formats[] = {
 	DRM_FORMAT_RGBA8888,
 };
 
-static int tegra_cursor_plane_update(struct drm_plane *plane,
-				     struct drm_crtc *crtc,
-				     struct drm_framebuffer *fb, int crtc_x,
-				     int crtc_y, unsigned int crtc_w,
-				     unsigned int crtc_h, uint32_t src_x,
-				     uint32_t src_y, uint32_t src_w,
-				     uint32_t src_h)
+static int tegra_cursor_atomic_check(struct drm_plane *plane,
+				     struct drm_plane_state *state)
 {
-	struct tegra_bo *bo = tegra_fb_get_plane(fb, 0);
-	struct tegra_dc *dc = to_tegra_dc(crtc);
-	u32 value = CURSOR_CLIP_DISPLAY;
+	/* no need for further checks if the plane is being disabled */
+	if (!state->crtc)
+		return 0;
 
 	/* scaling not supported for cursor */
-	if ((src_w >> 16 != crtc_w) || (src_h >> 16 != crtc_h))
+	if ((state->src_w >> 16 != state->crtc_w) ||
+	    (state->src_h >> 16 != state->crtc_h))
 		return -EINVAL;
 
 	/* only square cursors supported */
-	if (src_w != src_h)
+	if (state->src_w != state->src_h)
+		return -EINVAL;
+
+	if (state->crtc_w != 32 && state->crtc_w != 64 &&
+	    state->crtc_w != 128 && state->crtc_w != 256)
 		return -EINVAL;
 
-	switch (crtc_w) {
+	return 0;
+}
+
+static void tegra_cursor_atomic_update(struct drm_plane *plane,
+				       struct drm_plane_state *old_state)
+{
+	struct tegra_bo *bo = tegra_fb_get_plane(plane->state->fb, 0);
+	struct tegra_dc *dc = to_tegra_dc(plane->state->crtc);
+	struct drm_plane_state *state = plane->state;
+	u32 value = CURSOR_CLIP_DISPLAY;
+
+	/* rien ne va plus */
+	if (!plane->state->crtc || !plane->state->fb)
+		return;
+
+	switch (state->crtc_w) {
 	case 32:
 		value |= CURSOR_SIZE_32x32;
 		break;
@@ -556,7 +630,9 @@ static int tegra_cursor_plane_update(struct drm_plane *plane,
 		break;
 
 	default:
-		return -EINVAL;
+		WARN(1, "cursor size %ux%u not supported\n", state->crtc_w,
+		     state->crtc_h);
+		return;
 	}
 
 	value |= (bo->paddr >> 10) & 0x3fffff;
@@ -582,23 +658,25 @@ static int tegra_cursor_plane_update(struct drm_plane *plane,
 	tegra_dc_writel(dc, value, DC_DISP_BLEND_CURSOR_CONTROL);
 
 	/* position the cursor */
-	value = (crtc_y & 0x3fff) << 16 | (crtc_x & 0x3fff);
+	value = (state->crtc_y & 0x3fff) << 16 | (state->crtc_x & 0x3fff);
 	tegra_dc_writel(dc, value, DC_DISP_CURSOR_POSITION);
 
 	/* apply changes */
 	tegra_dc_cursor_commit(dc);
 	tegra_dc_commit(dc);
-
-	return 0;
 }
 
-static int tegra_cursor_plane_disable(struct drm_plane *plane)
+static void tegra_cursor_atomic_disable(struct drm_plane *plane,
+					struct drm_plane_state *old_state)
 {
-	struct tegra_dc *dc = to_tegra_dc(plane->crtc);
+	struct tegra_dc *dc;
 	u32 value;
 
-	if (!plane->crtc)
-		return 0;
+	/* rien ne va plus */
+	if (!old_state || !old_state->crtc)
+		return;
+
+	dc = to_tegra_dc(old_state->crtc);
 
 	value = tegra_dc_readl(dc, DC_DISP_DISP_WIN_OPTIONS);
 	value &= ~CURSOR_ENABLE;
@@ -606,14 +684,21 @@ static int tegra_cursor_plane_disable(struct drm_plane *plane)
 
 	tegra_dc_cursor_commit(dc);
 	tegra_dc_commit(dc);
-
-	return 0;
 }
 
 static const struct drm_plane_funcs tegra_cursor_plane_funcs = {
-	.update_plane = tegra_cursor_plane_update,
-	.disable_plane = tegra_cursor_plane_disable,
+	.update_plane = drm_plane_helper_update,
+	.disable_plane = drm_plane_helper_disable,
 	.destroy = tegra_plane_destroy,
+	.atomic_destroy_state = drm_atomic_helper_plane_destroy_state,
+};
+
+static const struct drm_plane_helper_funcs tegra_cursor_plane_helper_funcs = {
+	.prepare_fb = tegra_plane_prepare_fb,
+	.cleanup_fb = tegra_plane_cleanup_fb,
+	.atomic_check = tegra_cursor_atomic_check,
+	.atomic_update = tegra_cursor_atomic_update,
+	.atomic_disable = tegra_cursor_atomic_disable,
 };
 
 static struct drm_plane *tegra_dc_cursor_plane_create(struct drm_device *drm,
@@ -639,71 +724,21 @@ static struct drm_plane *tegra_dc_cursor_plane_create(struct drm_device *drm,
 		return ERR_PTR(err);
 	}
 
-	return &plane->base;
-}
-
-static int tegra_overlay_plane_update(struct drm_plane *plane,
-				      struct drm_crtc *crtc,
-				      struct drm_framebuffer *fb, int crtc_x,
-				      int crtc_y, unsigned int crtc_w,
-				      unsigned int crtc_h, uint32_t src_x,
-				      uint32_t src_y, uint32_t src_w,
-				      uint32_t src_h)
-{
-	struct tegra_plane *p = to_tegra_plane(plane);
-	struct tegra_dc *dc = to_tegra_dc(crtc);
-	struct tegra_dc_window window;
-	unsigned int i;
-	int err;
-
-	memset(&window, 0, sizeof(window));
-	window.src.x = src_x >> 16;
-	window.src.y = src_y >> 16;
-	window.src.w = src_w >> 16;
-	window.src.h = src_h >> 16;
-	window.dst.x = crtc_x;
-	window.dst.y = crtc_y;
-	window.dst.w = crtc_w;
-	window.dst.h = crtc_h;
-	window.format = tegra_dc_format(fb->pixel_format, &window.swap);
-	window.bits_per_pixel = fb->bits_per_pixel;
-	window.bottom_up = tegra_fb_is_bottom_up(fb);
-
-	err = tegra_fb_get_tiling(fb, &window.tiling);
-	if (err < 0)
-		return err;
+	drm_plane_helper_add(&plane->base, &tegra_cursor_plane_helper_funcs);
 
-	for (i = 0; i < drm_format_num_planes(fb->pixel_format); i++) {
-		struct tegra_bo *bo = tegra_fb_get_plane(fb, i);
-
-		window.base[i] = bo->paddr + fb->offsets[i];
-
-		/*
-		 * Tegra doesn't support different strides for U and V planes
-		 * so we display a warning if the user tries to display a
-		 * framebuffer with such a configuration.
-		 */
-		if (i >= 2) {
-			if (fb->pitches[i] != window.stride[1])
-				DRM_ERROR("unsupported UV-plane configuration\n");
-		} else {
-			window.stride[i] = fb->pitches[i];
-		}
-	}
-
-	return tegra_dc_setup_window(dc, p->index, &window);
+	return &plane->base;
 }
 
 static void tegra_overlay_plane_destroy(struct drm_plane *plane)
 {
-	tegra_window_plane_disable(plane);
 	tegra_plane_destroy(plane);
 }
 
 static const struct drm_plane_funcs tegra_overlay_plane_funcs = {
-	.update_plane = tegra_overlay_plane_update,
-	.disable_plane = tegra_window_plane_disable,
+	.update_plane = drm_plane_helper_update,
+	.disable_plane = drm_plane_helper_disable,
 	.destroy = tegra_overlay_plane_destroy,
+	.atomic_destroy_state = drm_atomic_helper_plane_destroy_state,
 };
 
 static const uint32_t tegra_overlay_plane_formats[] = {
@@ -716,6 +751,14 @@ static const uint32_t tegra_overlay_plane_formats[] = {
 	DRM_FORMAT_YUV422,
 };
 
+static const struct drm_plane_helper_funcs tegra_overlay_plane_helper_funcs = {
+	.prepare_fb = tegra_plane_prepare_fb,
+	.cleanup_fb = tegra_plane_cleanup_fb,
+	.atomic_check = tegra_plane_atomic_check,
+	.atomic_update = tegra_plane_atomic_update,
+	.atomic_disable = tegra_plane_atomic_disable,
+};
+
 static struct drm_plane *tegra_dc_overlay_plane_create(struct drm_device *drm,
 						       struct tegra_dc *dc,
 						       unsigned int index)
@@ -742,6 +785,8 @@ static struct drm_plane *tegra_dc_overlay_plane_create(struct drm_device *drm,
 		return ERR_PTR(err);
 	}
 
+	drm_plane_helper_add(&plane->base, &tegra_overlay_plane_helper_funcs);
+
 	return &plane->base;
 }
 
@@ -960,6 +1005,7 @@ static const struct drm_crtc_funcs tegra_crtc_funcs = {
 	.page_flip = tegra_dc_page_flip,
 	.set_config = drm_crtc_helper_set_config,
 	.destroy = tegra_dc_destroy,
+	.atomic_destroy_state = drm_atomic_helper_crtc_destroy_state,
 };
 
 static void tegra_dc_stop(struct tegra_dc *dc)
@@ -1097,16 +1143,11 @@ int tegra_dc_setup_clock(struct tegra_dc *dc, struct clk *parent,
 	return 0;
 }
 
-static int tegra_crtc_mode_set(struct drm_crtc *crtc,
-			       struct drm_display_mode *mode,
-			       struct drm_display_mode *adjusted,
-			       int x, int y, struct drm_framebuffer *old_fb)
+static void tegra_crtc_mode_set_nofb(struct drm_crtc *crtc)
 {
-	struct tegra_bo *bo = tegra_fb_get_plane(crtc->primary->fb, 0);
+	struct drm_display_mode *mode = &crtc->state->adjusted_mode;
 	struct tegra_dc *dc = to_tegra_dc(crtc);
-	struct tegra_dc_window window;
 	u32 value;
-	int err;
 
 	/* program display mode */
 	tegra_dc_set_timings(dc, mode);
@@ -1120,36 +1161,6 @@ static int tegra_crtc_mode_set(struct drm_crtc *crtc,
 		value &= ~INTERLACE_ENABLE;
 		tegra_dc_writel(dc, value, DC_DISP_INTERLACE_CONTROL);
 	}
-
-	/* setup window parameters */
-	memset(&window, 0, sizeof(window));
-	window.src.x = 0;
-	window.src.y = 0;
-	window.src.w = mode->hdisplay;
-	window.src.h = mode->vdisplay;
-	window.dst.x = 0;
-	window.dst.y = 0;
-	window.dst.w = mode->hdisplay;
-	window.dst.h = mode->vdisplay;
-	window.format = tegra_dc_format(crtc->primary->fb->pixel_format,
-					&window.swap);
-	window.bits_per_pixel = crtc->primary->fb->bits_per_pixel;
-	window.stride[0] = crtc->primary->fb->pitches[0];
-	window.base[0] = bo->paddr;
-
-	err = tegra_dc_setup_window(dc, 0, &window);
-	if (err < 0)
-		dev_err(dc->dev, "failed to enable root plane\n");
-
-	return 0;
-}
-
-static int tegra_crtc_mode_set_base(struct drm_crtc *crtc, int x, int y,
-				    struct drm_framebuffer *old_fb)
-{
-	struct tegra_dc *dc = to_tegra_dc(crtc);
-
-	return tegra_dc_set_base(dc, x, y, crtc->primary->fb);
 }
 
 static void tegra_crtc_prepare(struct drm_crtc *crtc)
@@ -1200,13 +1211,31 @@ static void tegra_crtc_commit(struct drm_crtc *crtc)
 	tegra_dc_commit(dc);
 }
 
+static int tegra_crtc_atomic_check(struct drm_crtc *crtc,
+				   struct drm_crtc_state *state)
+{
+	return 0;
+}
+
+static void tegra_crtc_atomic_begin(struct drm_crtc *crtc)
+{
+}
+
+static void tegra_crtc_atomic_flush(struct drm_crtc *crtc)
+{
+}
+
 static const struct drm_crtc_helper_funcs tegra_crtc_helper_funcs = {
 	.disable = tegra_crtc_disable,
 	.mode_fixup = tegra_crtc_mode_fixup,
-	.mode_set = tegra_crtc_mode_set,
-	.mode_set_base = tegra_crtc_mode_set_base,
+	.mode_set = drm_helper_crtc_mode_set,
+	.mode_set_nofb = tegra_crtc_mode_set_nofb,
+	.mode_set_base = drm_helper_crtc_mode_set_base,
 	.prepare = tegra_crtc_prepare,
 	.commit = tegra_crtc_commit,
+	.atomic_check = tegra_crtc_atomic_check,
+	.atomic_begin = tegra_crtc_atomic_begin,
+	.atomic_flush = tegra_crtc_atomic_flush,
 };
 
 static irqreturn_t tegra_dc_irq(int irq, void *data)
diff --git a/drivers/gpu/drm/tegra/drm.c b/drivers/gpu/drm/tegra/drm.c
index 121e022bdab0..3326df252c52 100644
--- a/drivers/gpu/drm/tegra/drm.c
+++ b/drivers/gpu/drm/tegra/drm.c
@@ -121,8 +121,8 @@ static int tegra_drm_unload(struct drm_device *drm)
 
 	drm_kms_helper_poll_fini(drm);
 	tegra_drm_fb_exit(drm);
-	drm_vblank_cleanup(drm);
 	drm_mode_config_cleanup(drm);
+	drm_vblank_cleanup(drm);
 
 	err = host1x_device_exit(device);
 	if (err < 0)
diff --git a/drivers/gpu/drm/tegra/dsi.c b/drivers/gpu/drm/tegra/dsi.c
index f8bfb45587d8..4bb06c119a18 100644
--- a/drivers/gpu/drm/tegra/dsi.c
+++ b/drivers/gpu/drm/tegra/dsi.c
@@ -17,6 +17,7 @@
 
 #include <linux/regulator/consumer.h>
 
+#include <drm/drm_atomic_helper.h>
 #include <drm/drm_mipi_dsi.h>
 #include <drm/drm_panel.h>
 
@@ -736,6 +737,7 @@ static const struct drm_connector_funcs tegra_dsi_connector_funcs = {
 	.detect = tegra_output_connector_detect,
 	.fill_modes = drm_helper_probe_single_connector_modes,
 	.destroy = tegra_output_connector_destroy,
+	.atomic_destroy_state = drm_atomic_helper_connector_destroy_state,
 };
 
 static enum drm_mode_status
diff --git a/drivers/gpu/drm/tegra/hdmi.c b/drivers/gpu/drm/tegra/hdmi.c
index d41530f1097c..bf868d54ef7e 100644
--- a/drivers/gpu/drm/tegra/hdmi.c
+++ b/drivers/gpu/drm/tegra/hdmi.c
@@ -14,6 +14,7 @@
 #include <linux/regulator/consumer.h>
 #include <linux/reset.h>
 
+#include <drm/drm_atomic_helper.h>
 #include <drm/drm_crtc.h>
 #include <drm/drm_crtc_helper.h>
 
@@ -781,6 +782,7 @@ static const struct drm_connector_funcs tegra_hdmi_connector_funcs = {
 	.detect = tegra_output_connector_detect,
 	.fill_modes = drm_helper_probe_single_connector_modes,
 	.destroy = tegra_output_connector_destroy,
+	.atomic_destroy_state = drm_atomic_helper_connector_destroy_state,
 };
 
 static enum drm_mode_status
diff --git a/drivers/gpu/drm/tegra/output.c b/drivers/gpu/drm/tegra/output.c
index d027e3079c17..79530c23790b 100644
--- a/drivers/gpu/drm/tegra/output.c
+++ b/drivers/gpu/drm/tegra/output.c
@@ -9,6 +9,7 @@
 
 #include <linux/of_gpio.h>
 
+#include <drm/drm_atomic_helper.h>
 #include <drm/drm_panel.h>
 #include "drm.h"
 
diff --git a/drivers/gpu/drm/tegra/rgb.c b/drivers/gpu/drm/tegra/rgb.c
index 0c932f9dc12d..23ba40370eb2 100644
--- a/drivers/gpu/drm/tegra/rgb.c
+++ b/drivers/gpu/drm/tegra/rgb.c
@@ -9,6 +9,7 @@
 
 #include <linux/clk.h>
 
+#include <drm/drm_atomic_helper.h>
 #include <drm/drm_panel.h>
 
 #include "drm.h"
@@ -97,6 +98,7 @@ static const struct drm_connector_funcs tegra_rgb_connector_funcs = {
 	.detect = tegra_output_connector_detect,
 	.fill_modes = drm_helper_probe_single_connector_modes,
 	.destroy = tegra_output_connector_destroy,
+	.atomic_destroy_state = drm_atomic_helper_connector_destroy_state,
 };
 
 static enum drm_mode_status
diff --git a/drivers/gpu/drm/tegra/sor.c b/drivers/gpu/drm/tegra/sor.c
index 9e67838c1562..e2f399363f09 100644
--- a/drivers/gpu/drm/tegra/sor.c
+++ b/drivers/gpu/drm/tegra/sor.c
@@ -15,6 +15,7 @@
 
 #include <soc/tegra/pmc.h>
 
+#include <drm/drm_atomic_helper.h>
 #include <drm/drm_dp_helper.h>
 #include <drm/drm_panel.h>
 
@@ -737,6 +738,7 @@ static const struct drm_connector_funcs tegra_sor_connector_funcs = {
 	.detect = tegra_sor_connector_detect,
 	.fill_modes = drm_helper_probe_single_connector_modes,
 	.destroy = tegra_output_connector_destroy,
+	.atomic_destroy_state = drm_atomic_helper_connector_destroy_state,
 };
 
 static int tegra_sor_connector_get_modes(struct drm_connector *connector)
-- 
2.1.3

