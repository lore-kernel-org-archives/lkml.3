Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663AbbAWJbs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 04:31:48 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:42972 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbbAWJbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 04:31:45 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: Daniel Vetter <daniel@ffwll.ch>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] drm/tegra: Track active planes in CRTC state
Date: Fri, 23 Jan 2015 10:31:41 +0100
Message-Id: <1422005501-11222-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1421750935-4023-35-git-send-email-thierry.reding@gmail.com>
References: <1421750935-4023-35-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Wrap struct drm_crtc_state in a driver-specific structure and add the
planes field which keeps track of which planes are updated or disabled
during a modeset. This allows atomic updates of the the display engine
at ->atomic_flush() time.

v2: open-code getting the state of the CRTC that the plane is being
    attached to (Daniel Vetter)

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/gpu/drm/tegra/dc.c | 72 ++++++++++++++++++++++++++++------------------
 1 file changed, 44 insertions(+), 28 deletions(-)

diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index 5da1b59e7cfd..c283ea4d0095 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -54,6 +54,8 @@ struct tegra_dc_state {
 	struct clk *clk;
 	unsigned long pclk;
 	unsigned int div;
+
+	u32 planes;
 };
 
 static inline struct tegra_dc_state *to_dc_state(struct drm_crtc_state *state)
@@ -64,20 +66,6 @@ static inline struct tegra_dc_state *to_dc_state(struct drm_crtc_state *state)
 	return NULL;
 }
 
-static void tegra_dc_window_commit(struct tegra_dc *dc, unsigned int index)
-{
-	u32 value = WIN_A_ACT_REQ << index;
-
-	tegra_dc_writel(dc, value << 8, DC_CMD_STATE_CONTROL);
-	tegra_dc_writel(dc, value, DC_CMD_STATE_CONTROL);
-}
-
-static void tegra_dc_cursor_commit(struct tegra_dc *dc)
-{
-	tegra_dc_writel(dc, CURSOR_ACT_REQ << 8, DC_CMD_STATE_CONTROL);
-	tegra_dc_writel(dc, CURSOR_ACT_REQ, DC_CMD_STATE_CONTROL);
-}
-
 /*
  * Reads the active copy of a register. This takes the dc->lock spinlock to
  * prevent races with the VBLANK processing which also needs access to the
@@ -395,8 +383,6 @@ static void tegra_dc_setup_window(struct tegra_dc *dc, unsigned int index,
 		break;
 	}
 
-	tegra_dc_window_commit(dc, index);
-
 	spin_unlock_irqrestore(&dc->lock, flags);
 }
 
@@ -439,9 +425,28 @@ static void tegra_plane_cleanup_fb(struct drm_plane *plane,
 {
 }
 
+static int tegra_plane_state_add(struct tegra_plane *plane,
+				 struct drm_plane_state *state)
+{
+	struct drm_crtc_state *crtc_state;
+	struct tegra_dc_state *tegra;
+
+	/* Propagate errors from allocation or locking failures. */
+	crtc_state = drm_atomic_get_crtc_state(state->state, state->crtc);
+	if (IS_ERR(crtc_state))
+		return PTR_ERR(crtc_state);
+
+	tegra = to_dc_state(crtc_state);
+
+	tegra->planes |= WIN_A_ACT_REQ << plane->index;
+
+	return 0;
+}
+
 static int tegra_plane_atomic_check(struct drm_plane *plane,
 				    struct drm_plane_state *state)
 {
+	struct tegra_plane *tegra = to_tegra_plane(plane);
 	struct tegra_dc *dc = to_tegra_dc(state->crtc);
 	struct tegra_bo_tiling tiling;
 	int err;
@@ -472,6 +477,10 @@ static int tegra_plane_atomic_check(struct drm_plane *plane,
 		}
 	}
 
+	err = tegra_plane_state_add(tegra, state);
+	if (err < 0)
+		return err;
+
 	return 0;
 }
 
@@ -538,8 +547,6 @@ static void tegra_plane_atomic_disable(struct drm_plane *plane,
 	value &= ~WIN_ENABLE;
 	tegra_dc_writel(dc, value, DC_WIN_WIN_OPTIONS);
 
-	tegra_dc_window_commit(dc, p->index);
-
 	spin_unlock_irqrestore(&dc->lock, flags);
 }
 
@@ -599,6 +606,9 @@ static const u32 tegra_cursor_plane_formats[] = {
 static int tegra_cursor_atomic_check(struct drm_plane *plane,
 				     struct drm_plane_state *state)
 {
+	struct tegra_plane *tegra = to_tegra_plane(plane);
+	int err;
+
 	/* no need for further checks if the plane is being disabled */
 	if (!state->crtc)
 		return 0;
@@ -616,6 +626,10 @@ static int tegra_cursor_atomic_check(struct drm_plane *plane,
 	    state->crtc_w != 128 && state->crtc_w != 256)
 		return -EINVAL;
 
+	err = tegra_plane_state_add(tegra, state);
+	if (err < 0)
+		return err;
+
 	return 0;
 }
 
@@ -680,9 +694,6 @@ static void tegra_cursor_atomic_update(struct drm_plane *plane,
 	value = (state->crtc_y & 0x3fff) << 16 | (state->crtc_x & 0x3fff);
 	tegra_dc_writel(dc, value, DC_DISP_CURSOR_POSITION);
 
-	/* apply changes */
-	tegra_dc_cursor_commit(dc);
-	tegra_dc_commit(dc);
 }
 
 static void tegra_cursor_atomic_disable(struct drm_plane *plane,
@@ -700,9 +711,6 @@ static void tegra_cursor_atomic_disable(struct drm_plane *plane,
 	value = tegra_dc_readl(dc, DC_DISP_DISP_WIN_OPTIONS);
 	value &= ~CURSOR_ENABLE;
 	tegra_dc_writel(dc, value, DC_DISP_DISP_WIN_OPTIONS);
-
-	tegra_dc_cursor_commit(dc);
-	tegra_dc_commit(dc);
 }
 
 static const struct drm_plane_funcs tegra_cursor_plane_funcs = {
@@ -734,6 +742,13 @@ static struct drm_plane *tegra_dc_cursor_plane_create(struct drm_device *drm,
 	if (!plane)
 		return ERR_PTR(-ENOMEM);
 
+	/*
+	 * We'll treat the cursor as an overlay plane with index 6 here so
+	 * that the update and activation request bits in DC_CMD_STATE_CONTROL
+	 * match up.
+	 */
+	plane->index = 6;
+
 	num_formats = ARRAY_SIZE(tegra_cursor_plane_formats);
 	formats = tegra_cursor_plane_formats;
 
@@ -1029,7 +1044,6 @@ static void tegra_crtc_disable(struct drm_crtc *crtc)
 	}
 
 	drm_crtc_vblank_off(crtc);
-	tegra_dc_commit(dc);
 }
 
 static bool tegra_crtc_mode_fixup(struct drm_crtc *crtc,
@@ -1202,10 +1216,7 @@ static void tegra_crtc_prepare(struct drm_crtc *crtc)
 
 static void tegra_crtc_commit(struct drm_crtc *crtc)
 {
-	struct tegra_dc *dc = to_tegra_dc(crtc);
-
 	drm_crtc_vblank_on(crtc);
-	tegra_dc_commit(dc);
 }
 
 static int tegra_crtc_atomic_check(struct drm_crtc *crtc,
@@ -1230,6 +1241,11 @@ static void tegra_crtc_atomic_begin(struct drm_crtc *crtc)
 
 static void tegra_crtc_atomic_flush(struct drm_crtc *crtc)
 {
+	struct tegra_dc_state *state = to_dc_state(crtc->state);
+	struct tegra_dc *dc = to_tegra_dc(crtc);
+
+	tegra_dc_writel(dc, state->planes << 8, DC_CMD_STATE_CONTROL);
+	tegra_dc_writel(dc, state->planes, DC_CMD_STATE_CONTROL);
 }
 
 static const struct drm_crtc_helper_funcs tegra_crtc_helper_funcs = {
-- 
2.1.3

