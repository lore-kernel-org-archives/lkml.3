Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbbATKxU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:53:20 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:58934 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289AbbATKtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:49:52 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 32/36] drm/tegra: Atomic conversion, phase 3, step 3
Date: Tue, 20 Jan 2015 11:48:51 +0100
Message-Id: <1421750935-4023-33-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
References: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Provide a custom ->atomic_commit() implementation which supports async
commits. The generic atomic page-flip helper can use this to implement
page-flipping.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/gpu/drm/tegra/dc.c  | 129 ++++----------------------------------------
 drivers/gpu/drm/tegra/drm.c |  84 ++++++++++++++++++++++++++++-
 drivers/gpu/drm/tegra/drm.h |   6 +++
 3 files changed, 100 insertions(+), 119 deletions(-)

diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index 9a934a6077a6..52ae563cb531 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -827,99 +827,6 @@ static int tegra_dc_add_planes(struct drm_device *drm, struct tegra_dc *dc)
 	return 0;
 }
 
-static int tegra_dc_set_base(struct tegra_dc *dc, int x, int y,
-			     struct drm_framebuffer *fb)
-{
-	struct tegra_bo *bo = tegra_fb_get_plane(fb, 0);
-	unsigned int h_offset = 0, v_offset = 0;
-	struct tegra_bo_tiling tiling;
-	unsigned long value, flags;
-	unsigned int format, swap;
-	int err;
-
-	err = tegra_fb_get_tiling(fb, &tiling);
-	if (err < 0)
-		return err;
-
-	spin_lock_irqsave(&dc->lock, flags);
-
-	tegra_dc_writel(dc, WINDOW_A_SELECT, DC_CMD_DISPLAY_WINDOW_HEADER);
-
-	value = fb->offsets[0] + y * fb->pitches[0] +
-		x * fb->bits_per_pixel / 8;
-
-	tegra_dc_writel(dc, bo->paddr + value, DC_WINBUF_START_ADDR);
-	tegra_dc_writel(dc, fb->pitches[0], DC_WIN_LINE_STRIDE);
-
-	format = tegra_dc_format(fb->pixel_format, &swap);
-	tegra_dc_writel(dc, format, DC_WIN_COLOR_DEPTH);
-	tegra_dc_writel(dc, swap, DC_WIN_BYTE_SWAP);
-
-	if (dc->soc->supports_block_linear) {
-		unsigned long height = tiling.value;
-
-		switch (tiling.mode) {
-		case TEGRA_BO_TILING_MODE_PITCH:
-			value = DC_WINBUF_SURFACE_KIND_PITCH;
-			break;
-
-		case TEGRA_BO_TILING_MODE_TILED:
-			value = DC_WINBUF_SURFACE_KIND_TILED;
-			break;
-
-		case TEGRA_BO_TILING_MODE_BLOCK:
-			value = DC_WINBUF_SURFACE_KIND_BLOCK_HEIGHT(height) |
-				DC_WINBUF_SURFACE_KIND_BLOCK;
-			break;
-		}
-
-		tegra_dc_writel(dc, value, DC_WINBUF_SURFACE_KIND);
-	} else {
-		switch (tiling.mode) {
-		case TEGRA_BO_TILING_MODE_PITCH:
-			value = DC_WIN_BUFFER_ADDR_MODE_LINEAR_UV |
-				DC_WIN_BUFFER_ADDR_MODE_LINEAR;
-			break;
-
-		case TEGRA_BO_TILING_MODE_TILED:
-			value = DC_WIN_BUFFER_ADDR_MODE_TILE_UV |
-				DC_WIN_BUFFER_ADDR_MODE_TILE;
-			break;
-
-		case TEGRA_BO_TILING_MODE_BLOCK:
-			DRM_ERROR("hardware doesn't support block linear mode\n");
-			spin_unlock_irqrestore(&dc->lock, flags);
-			return -EINVAL;
-		}
-
-		tegra_dc_writel(dc, value, DC_WIN_BUFFER_ADDR_MODE);
-	}
-
-	/* make sure bottom-up buffers are properly displayed */
-	if (tegra_fb_is_bottom_up(fb)) {
-		value = tegra_dc_readl(dc, DC_WIN_WIN_OPTIONS);
-		value |= V_DIRECTION;
-		tegra_dc_writel(dc, value, DC_WIN_WIN_OPTIONS);
-
-		v_offset += fb->height - 1;
-	} else {
-		value = tegra_dc_readl(dc, DC_WIN_WIN_OPTIONS);
-		value &= ~V_DIRECTION;
-		tegra_dc_writel(dc, value, DC_WIN_WIN_OPTIONS);
-	}
-
-	tegra_dc_writel(dc, h_offset, DC_WINBUF_ADDR_H_OFFSET);
-	tegra_dc_writel(dc, v_offset, DC_WINBUF_ADDR_V_OFFSET);
-
-	value = GENERAL_ACT_REQ | WIN_A_ACT_REQ;
-	tegra_dc_writel(dc, value << 8, DC_CMD_STATE_CONTROL);
-	tegra_dc_writel(dc, value, DC_CMD_STATE_CONTROL);
-
-	spin_unlock_irqrestore(&dc->lock, flags);
-
-	return 0;
-}
-
 void tegra_dc_enable_vblank(struct tegra_dc *dc)
 {
 	unsigned long value, flags;
@@ -998,30 +905,6 @@ void tegra_dc_cancel_page_flip(struct drm_crtc *crtc, struct drm_file *file)
 	spin_unlock_irqrestore(&drm->event_lock, flags);
 }
 
-static int tegra_dc_page_flip(struct drm_crtc *crtc, struct drm_framebuffer *fb,
-			      struct drm_pending_vblank_event *event, uint32_t page_flip_flags)
-{
-	unsigned int pipe = drm_crtc_index(crtc);
-	struct tegra_dc *dc = to_tegra_dc(crtc);
-
-	if (dc->event)
-		return -EBUSY;
-
-	if (event) {
-		event->pipe = pipe;
-		dc->event = event;
-		drm_crtc_vblank_get(crtc);
-	}
-
-	if (crtc->primary->state)
-		drm_atomic_set_fb_for_plane(crtc->primary->state, fb);
-
-	tegra_dc_set_base(dc, 0, 0, fb);
-	crtc->primary->fb = fb;
-
-	return 0;
-}
-
 static void tegra_dc_destroy(struct drm_crtc *crtc)
 {
 	drm_crtc_cleanup(crtc);
@@ -1063,7 +946,7 @@ static void tegra_crtc_atomic_destroy_state(struct drm_crtc *crtc,
 }
 
 static const struct drm_crtc_funcs tegra_crtc_funcs = {
-	.page_flip = tegra_dc_page_flip,
+	.page_flip = drm_atomic_helper_page_flip,
 	.set_config = drm_atomic_helper_set_config,
 	.destroy = tegra_dc_destroy,
 	.reset = tegra_crtc_reset,
@@ -1338,6 +1221,16 @@ static int tegra_crtc_atomic_check(struct drm_crtc *crtc,
 
 static void tegra_crtc_atomic_begin(struct drm_crtc *crtc)
 {
+	struct tegra_dc *dc = to_tegra_dc(crtc);
+
+	if (crtc->state->event) {
+		crtc->state->event->pipe = drm_crtc_index(crtc);
+
+		WARN_ON(drm_crtc_vblank_get(crtc) != 0);
+
+		dc->event = crtc->state->event;
+		crtc->state->event = NULL;
+	}
 }
 
 static void tegra_crtc_atomic_flush(struct drm_crtc *crtc)
diff --git a/drivers/gpu/drm/tegra/drm.c b/drivers/gpu/drm/tegra/drm.c
index 0dd81d050ccb..5b81b44af9e4 100644
--- a/drivers/gpu/drm/tegra/drm.c
+++ b/drivers/gpu/drm/tegra/drm.c
@@ -10,6 +10,7 @@
 #include <linux/host1x.h>
 #include <linux/iommu.h>
 
+#include <drm/drm_atomic.h>
 #include <drm/drm_atomic_helper.h>
 
 #include "drm.h"
@@ -26,13 +27,90 @@ struct tegra_drm_file {
 	struct list_head contexts;
 };
 
+static void tegra_atomic_schedule(struct tegra_drm *tegra,
+				  struct drm_atomic_state *state)
+{
+	tegra->commit.state = state;
+	schedule_work(&tegra->commit.work);
+}
+
+static void tegra_atomic_complete(struct tegra_drm *tegra,
+				  struct drm_atomic_state *state)
+{
+	struct drm_device *drm = tegra->drm;
+
+	/*
+	 * Everything below can be run asynchronously without the need to grab
+	 * any modeset locks at all under one condition: It must be guaranteed
+	 * that the asynchronous work has either been cancelled (if the driver
+	 * supports it, which at least requires that the framebuffers get
+	 * cleaned up with drm_atomic_helper_cleanup_planes()) or completed
+	 * before the new state gets committed on the software side with
+	 * drm_atomic_helper_swap_state().
+	 *
+	 * This scheme allows new atomic state updates to be prepared and
+	 * checked in parallel to the asynchronous completion of the previous
+	 * update. Which is important since compositors need to figure out the
+	 * composition of the next frame right after having submitted the
+	 * current layout.
+	 */
+
+	drm_atomic_helper_commit_pre_planes(drm, state);
+	drm_atomic_helper_commit_planes(drm, state);
+	drm_atomic_helper_commit_post_planes(drm, state);
+
+	drm_atomic_helper_wait_for_vblanks(drm, state);
+
+	drm_atomic_helper_cleanup_planes(drm, state);
+	drm_atomic_state_free(state);
+}
+
+static void tegra_atomic_work(struct work_struct *work)
+{
+	struct tegra_drm *tegra = container_of(work, struct tegra_drm,
+					       commit.work);
+
+	tegra_atomic_complete(tegra, tegra->commit.state);
+}
+
+static int tegra_atomic_commit(struct drm_device *drm,
+			       struct drm_atomic_state *state, bool async)
+{
+	struct tegra_drm *tegra = drm->dev_private;
+	int err;
+
+	err = drm_atomic_helper_prepare_planes(drm, state);
+	if (err)
+		return err;
+
+	/* serialize outstanding asynchronous commits */
+	mutex_lock(&tegra->commit.lock);
+	flush_work(&tegra->commit.work);
+
+	/*
+	 * This is the point of no return - everything below never fails except
+	 * when the hw goes bonghits. Which means we can commit the new state on
+	 * the software side now.
+	 */
+
+	drm_atomic_helper_swap_state(drm, state);
+
+	if (async)
+		tegra_atomic_schedule(tegra, state);
+	else
+		tegra_atomic_complete(tegra, state);
+
+	mutex_unlock(&tegra->commit.lock);
+	return 0;
+}
+
 static const struct drm_mode_config_funcs tegra_drm_mode_funcs = {
 	.fb_create = tegra_fb_create,
 #ifdef CONFIG_DRM_TEGRA_FBDEV
 	.output_poll_changed = tegra_fb_output_poll_changed,
 #endif
 	.atomic_check = drm_atomic_helper_check,
-	.atomic_commit = drm_atomic_helper_commit,
+	.atomic_commit = tegra_atomic_commit,
 };
 
 static int tegra_drm_load(struct drm_device *drm, unsigned long flags)
@@ -58,6 +136,10 @@ static int tegra_drm_load(struct drm_device *drm, unsigned long flags)
 
 	mutex_init(&tegra->clients_lock);
 	INIT_LIST_HEAD(&tegra->clients);
+
+	mutex_init(&tegra->commit.lock);
+	INIT_WORK(&tegra->commit.work, tegra_atomic_work);
+
 	drm->dev_private = tegra;
 	tegra->drm = drm;
 
diff --git a/drivers/gpu/drm/tegra/drm.h b/drivers/gpu/drm/tegra/drm.h
index 3db719de312f..b1c7027b26e7 100644
--- a/drivers/gpu/drm/tegra/drm.h
+++ b/drivers/gpu/drm/tegra/drm.h
@@ -50,6 +50,12 @@ struct tegra_drm {
 #endif
 
 	unsigned int pitch_align;
+
+	struct {
+		struct drm_atomic_state *state;
+		struct work_struct work;
+		struct mutex lock;
+	} commit;
 };
 
 struct tegra_drm_client;
-- 
2.1.3

