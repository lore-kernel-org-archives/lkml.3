Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbbATKuI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:50:08 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:36628 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358AbbATKuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:50:03 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 35/36] drm/tegra: Track tiling and format in plane state
Date: Tue, 20 Jan 2015 11:48:54 +0100
Message-Id: <1421750935-4023-36-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
References: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Tracking these in the plane state allows them to be computed in the
->atomic_check() callback and reused when applying the configuration in
->atomic_update().

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/gpu/drm/tegra/dc.c  | 127 ++++++++++++++++++++++++++++++++++----------
 drivers/gpu/drm/tegra/drm.h |   4 +-
 2 files changed, 101 insertions(+), 30 deletions(-)

diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index 835de4398c8f..1280b886481d 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -66,6 +66,23 @@ static inline struct tegra_dc_state *to_dc_state(struct drm_crtc_state *state)
 	return NULL;
 }
 
+struct tegra_plane_state {
+	struct drm_plane_state base;
+
+	struct tegra_bo_tiling tiling;
+	u32 format;
+	u32 swap;
+};
+
+static inline struct tegra_plane_state *
+to_tegra_plane_state(struct drm_plane_state *state)
+{
+	if (state)
+		return container_of(state, struct tegra_plane_state, base);
+
+	return NULL;
+}
+
 /*
  * Reads the active copy of a register. This takes the dc->lock spinlock to
  * prevent races with the VBLANK processing which also needs access to the
@@ -104,43 +121,49 @@ void tegra_dc_commit(struct tegra_dc *dc)
 	tegra_dc_writel(dc, GENERAL_ACT_REQ, DC_CMD_STATE_CONTROL);
 }
 
-static unsigned int tegra_dc_format(uint32_t format, uint32_t *swap)
+static int tegra_dc_format(u32 fourcc, u32 *format, u32 *swap)
 {
 	/* assume no swapping of fetched data */
 	if (swap)
 		*swap = BYTE_SWAP_NOSWAP;
 
-	switch (format) {
+	switch (fourcc) {
 	case DRM_FORMAT_XBGR8888:
-		return WIN_COLOR_DEPTH_R8G8B8A8;
+		*format = WIN_COLOR_DEPTH_R8G8B8A8;
+		break;
 
 	case DRM_FORMAT_XRGB8888:
-		return WIN_COLOR_DEPTH_B8G8R8A8;
+		*format = WIN_COLOR_DEPTH_B8G8R8A8;
+		break;
 
 	case DRM_FORMAT_RGB565:
-		return WIN_COLOR_DEPTH_B5G6R5;
+		*format = WIN_COLOR_DEPTH_B5G6R5;
+		break;
 
 	case DRM_FORMAT_UYVY:
-		return WIN_COLOR_DEPTH_YCbCr422;
+		*format = WIN_COLOR_DEPTH_YCbCr422;
+		break;
 
 	case DRM_FORMAT_YUYV:
 		if (swap)
 			*swap = BYTE_SWAP_SWAP2;
 
-		return WIN_COLOR_DEPTH_YCbCr422;
+		*format = WIN_COLOR_DEPTH_YCbCr422;
+		break;
 
 	case DRM_FORMAT_YUV420:
-		return WIN_COLOR_DEPTH_YCbCr420P;
+		*format = WIN_COLOR_DEPTH_YCbCr420P;
+		break;
 
 	case DRM_FORMAT_YUV422:
-		return WIN_COLOR_DEPTH_YCbCr422P;
+		*format = WIN_COLOR_DEPTH_YCbCr422P;
+		break;
 
 	default:
-		break;
+		return -EINVAL;
 	}
 
-	WARN(1, "unsupported pixel format %u, using default\n", format);
-	return WIN_COLOR_DEPTH_B8G8R8A8;
+	return 0;
 }
 
 static bool tegra_dc_format_is_yuv(unsigned int format, bool *planar)
@@ -405,13 +428,54 @@ static void tegra_primary_plane_destroy(struct drm_plane *plane)
 	tegra_plane_destroy(plane);
 }
 
+static void tegra_plane_reset(struct drm_plane *plane)
+{
+	struct tegra_plane_state *state;
+
+	if (plane->state && plane->state->fb)
+		drm_framebuffer_unreference(plane->state->fb);
+
+	kfree(plane->state);
+	plane->state = NULL;
+
+	state = kzalloc(sizeof(*state), GFP_KERNEL);
+	if (state) {
+		plane->state = &state->base;
+		plane->state->plane = plane;
+	}
+}
+
+static struct drm_plane_state *tegra_plane_atomic_duplicate_state(struct drm_plane *plane)
+{
+	struct tegra_plane_state *state = to_tegra_plane_state(plane->state);
+	struct tegra_plane_state *copy;
+
+	copy = kmemdup(state, sizeof(*state), GFP_KERNEL);
+	if (!copy)
+		return NULL;
+
+	if (copy->base.fb)
+		drm_framebuffer_reference(copy->base.fb);
+
+	return &copy->base;
+}
+
+static void tegra_plane_atomic_destroy_state(struct drm_plane *plane,
+					     struct drm_plane_state *state)
+{
+	if (state->fb)
+		drm_framebuffer_unreference(state->fb);
+
+	kfree(state);
+}
+
 static const struct drm_plane_funcs tegra_primary_plane_funcs = {
 	.update_plane = drm_atomic_helper_update_plane,
 	.disable_plane = drm_atomic_helper_disable_plane,
 	.destroy = tegra_primary_plane_destroy,
-	.reset = drm_atomic_helper_plane_reset,
-	.atomic_duplicate_state = drm_atomic_helper_plane_duplicate_state,
-	.atomic_destroy_state = drm_atomic_helper_plane_destroy_state,
+	.reset = tegra_plane_reset,
+	.atomic_duplicate_state = tegra_plane_atomic_duplicate_state,
+	.atomic_destroy_state = tegra_plane_atomic_destroy_state,
 };
 
 static int tegra_plane_prepare_fb(struct drm_plane *plane,
@@ -446,20 +510,26 @@ static int tegra_plane_state_add(struct tegra_plane *plane,
 static int tegra_plane_atomic_check(struct drm_plane *plane,
 				    struct drm_plane_state *state)
 {
+	struct tegra_plane_state *plane_state = to_tegra_plane_state(state);
+	struct tegra_bo_tiling *tiling = &plane_state->tiling;
 	struct tegra_plane *tegra = to_tegra_plane(plane);
 	struct tegra_dc *dc = to_tegra_dc(state->crtc);
-	struct tegra_bo_tiling tiling;
 	int err;
 
 	/* no need for further checks if the plane is being disabled */
 	if (!state->crtc)
 		return 0;
 
-	err = tegra_fb_get_tiling(state->fb, &tiling);
+	err = tegra_dc_format(state->fb->pixel_format, &plane_state->format,
+			      &plane_state->swap);
+	if (err < 0)
+		return err;
+
+	err = tegra_fb_get_tiling(state->fb, tiling);
 	if (err < 0)
 		return err;
 
-	if (tiling.mode == TEGRA_BO_TILING_MODE_BLOCK &&
+	if (tiling->mode == TEGRA_BO_TILING_MODE_BLOCK &&
 	    !dc->soc->supports_block_linear) {
 		DRM_ERROR("hardware doesn't support block linear mode\n");
 		return -EINVAL;
@@ -487,12 +557,12 @@ static int tegra_plane_atomic_check(struct drm_plane *plane,
 static void tegra_plane_atomic_update(struct drm_plane *plane,
 				      struct drm_plane_state *old_state)
 {
+	struct tegra_plane_state *state = to_tegra_plane_state(plane->state);
 	struct tegra_dc *dc = to_tegra_dc(plane->state->crtc);
 	struct drm_framebuffer *fb = plane->state->fb;
 	struct tegra_plane *p = to_tegra_plane(plane);
 	struct tegra_dc_window window;
 	unsigned int i;
-	int err;
 
 	/* rien ne va plus */
 	if (!plane->state->crtc || !plane->state->fb)
@@ -507,12 +577,13 @@ static void tegra_plane_atomic_update(struct drm_plane *plane,
 	window.dst.y = plane->state->crtc_y;
 	window.dst.w = plane->state->crtc_w;
 	window.dst.h = plane->state->crtc_h;
-	window.format = tegra_dc_format(fb->pixel_format, &window.swap);
 	window.bits_per_pixel = fb->bits_per_pixel;
 	window.bottom_up = tegra_fb_is_bottom_up(fb);
 
-	err = tegra_fb_get_tiling(fb, &window.tiling);
-	WARN_ON(err < 0);
+	/* copy from state */
+	window.tiling = state->tiling;
+	window.format = state->format;
+	window.swap = state->swap;
 
 	for (i = 0; i < drm_format_num_planes(fb->pixel_format); i++) {
 		struct tegra_bo *bo = tegra_fb_get_plane(fb, i);
@@ -717,9 +788,9 @@ static const struct drm_plane_funcs tegra_cursor_plane_funcs = {
 	.update_plane = drm_atomic_helper_update_plane,
 	.disable_plane = drm_atomic_helper_disable_plane,
 	.destroy = tegra_plane_destroy,
-	.reset = drm_atomic_helper_plane_reset,
-	.atomic_duplicate_state = drm_atomic_helper_plane_duplicate_state,
-	.atomic_destroy_state = drm_atomic_helper_plane_destroy_state,
+	.reset = tegra_plane_reset,
+	.atomic_duplicate_state = tegra_plane_atomic_duplicate_state,
+	.atomic_destroy_state = tegra_plane_atomic_destroy_state,
 };
 
 static const struct drm_plane_helper_funcs tegra_cursor_plane_helper_funcs = {
@@ -774,9 +845,9 @@ static const struct drm_plane_funcs tegra_overlay_plane_funcs = {
 	.update_plane = drm_atomic_helper_update_plane,
 	.disable_plane = drm_atomic_helper_disable_plane,
 	.destroy = tegra_overlay_plane_destroy,
-	.reset = drm_atomic_helper_plane_reset,
-	.atomic_duplicate_state = drm_atomic_helper_plane_duplicate_state,
-	.atomic_destroy_state = drm_atomic_helper_plane_destroy_state,
+	.reset = tegra_plane_reset,
+	.atomic_duplicate_state = tegra_plane_atomic_duplicate_state,
+	.atomic_destroy_state = tegra_plane_atomic_destroy_state,
 };
 
 static const uint32_t tegra_overlay_plane_formats[] = {
diff --git a/drivers/gpu/drm/tegra/drm.h b/drivers/gpu/drm/tegra/drm.h
index b1c7027b26e7..8cb2dfeaa957 100644
--- a/drivers/gpu/drm/tegra/drm.h
+++ b/drivers/gpu/drm/tegra/drm.h
@@ -170,13 +170,13 @@ struct tegra_dc_window {
 		unsigned int h;
 	} dst;
 	unsigned int bits_per_pixel;
-	unsigned int format;
-	unsigned int swap;
 	unsigned int stride[2];
 	unsigned long base[3];
 	bool bottom_up;
 
 	struct tegra_bo_tiling tiling;
+	u32 format;
+	u32 swap;
 };
 
 /* from dc.c */
-- 
2.1.3

