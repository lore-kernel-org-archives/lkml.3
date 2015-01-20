Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbbATKto (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:49:44 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:57837 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237AbbATKtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:49:41 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 25/36] drm/tegra: dc: Store clock setup in atomic state
Date: Tue, 20 Jan 2015 11:48:44 +0100
Message-Id: <1421750935-4023-26-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
References: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

This allows the clock setup to be separated from the clock programming
and better matches the expectations of the atomic modesetting where no
code paths must fail during modeset.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/gpu/drm/tegra/dc.c  | 76 +++++++++++++++++++++++++++++++++++++++++++--
 drivers/gpu/drm/tegra/drm.h |  4 +++
 2 files changed, 77 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index 469bfa0fe096..1d8052a8d4c3 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -48,6 +48,22 @@ static inline struct tegra_plane *to_tegra_plane(struct drm_plane *plane)
 	return container_of(plane, struct tegra_plane, base);
 }
 
+struct tegra_dc_state {
+	struct drm_crtc_state base;
+
+	struct clk *clk;
+	unsigned long pclk;
+	unsigned int div;
+};
+
+static inline struct tegra_dc_state *to_dc_state(struct drm_crtc_state *state)
+{
+	if (state)
+		return container_of(state, struct tegra_dc_state, base);
+
+	return NULL;
+}
+
 static void tegra_dc_window_commit(struct tegra_dc *dc, unsigned int index)
 {
 	u32 value = WIN_A_ACT_REQ << index;
@@ -1011,13 +1027,48 @@ static void tegra_dc_destroy(struct drm_crtc *crtc)
 	drm_crtc_cleanup(crtc);
 }
 
+static void tegra_crtc_reset(struct drm_crtc *crtc)
+{
+	struct tegra_dc_state *state;
+
+	kfree(crtc->state);
+	crtc->state = NULL;
+
+	state = kzalloc(sizeof(*state), GFP_KERNEL);
+	if (state)
+		crtc->state = &state->base;
+}
+
+static struct drm_crtc_state *
+tegra_crtc_atomic_duplicate_state(struct drm_crtc *crtc)
+{
+	struct tegra_dc_state *state = to_dc_state(crtc->state);
+	struct tegra_dc_state *copy;
+
+	copy = kmemdup(state, sizeof(*state), GFP_KERNEL);
+	if (!copy)
+		return NULL;
+
+	copy->base.mode_changed = false;
+	copy->base.planes_changed = false;
+	copy->base.event = NULL;
+
+	return &copy->base;
+}
+
+static void tegra_crtc_atomic_destroy_state(struct drm_crtc *crtc,
+					    struct drm_crtc_state *state)
+{
+	kfree(state);
+}
+
 static const struct drm_crtc_funcs tegra_crtc_funcs = {
 	.page_flip = tegra_dc_page_flip,
 	.set_config = drm_crtc_helper_set_config,
 	.destroy = tegra_dc_destroy,
-	.reset = drm_atomic_helper_crtc_reset,
-	.atomic_duplicate_state = drm_atomic_helper_crtc_duplicate_state,
-	.atomic_destroy_state = drm_atomic_helper_crtc_destroy_state,
+	.reset = tegra_crtc_reset,
+	.atomic_duplicate_state = tegra_crtc_atomic_duplicate_state,
+	.atomic_destroy_state = tegra_crtc_atomic_destroy_state,
 };
 
 static void tegra_dc_stop(struct tegra_dc *dc)
@@ -1155,6 +1206,25 @@ int tegra_dc_setup_clock(struct tegra_dc *dc, struct clk *parent,
 	return 0;
 }
 
+int tegra_dc_state_setup_clock(struct tegra_dc *dc,
+			       struct drm_crtc_state *crtc_state,
+			       struct clk *clk, unsigned long pclk,
+			       unsigned int div)
+{
+	struct tegra_dc_state *state = to_dc_state(crtc_state);
+	int err;
+
+	err = clk_try_parent(dc->clk, clk);
+	if (err < 0)
+		return err;
+
+	state->clk = clk;
+	state->pclk = pclk;
+	state->div = div;
+
+	return 0;
+}
+
 static void tegra_crtc_mode_set_nofb(struct drm_crtc *crtc)
 {
 	struct drm_display_mode *mode = &crtc->state->adjusted_mode;
diff --git a/drivers/gpu/drm/tegra/drm.h b/drivers/gpu/drm/tegra/drm.h
index bf1c47ec46b6..3db719de312f 100644
--- a/drivers/gpu/drm/tegra/drm.h
+++ b/drivers/gpu/drm/tegra/drm.h
@@ -180,6 +180,10 @@ void tegra_dc_cancel_page_flip(struct drm_crtc *crtc, struct drm_file *file);
 void tegra_dc_commit(struct tegra_dc *dc);
 int tegra_dc_setup_clock(struct tegra_dc *dc, struct clk *parent,
 			 unsigned long pclk, unsigned int div);
+int tegra_dc_state_setup_clock(struct tegra_dc *dc,
+			       struct drm_crtc_state *crtc_state,
+			       struct clk *clk, unsigned long pclk,
+			       unsigned int div);
 
 struct tegra_output {
 	struct device_node *of_node;
-- 
2.1.3

