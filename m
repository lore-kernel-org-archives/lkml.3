Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbbATKtw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:49:52 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:58943 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281AbbATKtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:49:49 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 30/36] drm/tegra: dc: Use atomic clock state in modeset
Date: Tue, 20 Jan 2015 11:48:49 +0100
Message-Id: <1421750935-4023-31-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
References: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

All clock state is now stored in the display controller's atomic state,
so the output drivers no longer need to call back into the display
controller driver to set up the clock. This is also required to make
sure no hardware changes are made before validating a configuration.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/gpu/drm/tegra/dc.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index 1d8052a8d4c3..b4a2a17caf05 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -1225,12 +1225,49 @@ int tegra_dc_state_setup_clock(struct tegra_dc *dc,
 	return 0;
 }
 
+static void tegra_dc_commit_state(struct tegra_dc *dc,
+				  struct tegra_dc_state *state)
+{
+	u32 value;
+	int err;
+
+	err = clk_set_parent(dc->clk, state->clk);
+	if (err < 0)
+		dev_err(dc->dev, "failed to set parent clock: %d\n", err);
+
+	/*
+	 * Outputs may not want to change the parent clock rate. This is only
+	 * relevant to Tegra20 where only a single display PLL is available.
+	 * Since that PLL would typically be used for HDMI, an internal LVDS
+	 * panel would need to be driven by some other clock such as PLL_P
+	 * which is shared with other peripherals. Changing the clock rate
+	 * should therefore be avoided.
+	 */
+	if (state->pclk > 0) {
+		err = clk_set_rate(state->clk, state->pclk);
+		if (err < 0)
+			dev_err(dc->dev,
+				"failed to set clock rate to %lu Hz\n",
+				state->pclk);
+	}
+
+	DRM_DEBUG_KMS("rate: %lu, div: %u\n", clk_get_rate(dc->clk),
+		      state->div);
+	DRM_DEBUG_KMS("pclk: %lu\n", state->pclk);
+
+	value = SHIFT_CLK_DIVIDER(state->div) | PIXEL_CLK_DIVIDER_PCD1;
+	tegra_dc_writel(dc, value, DC_DISP_DISP_CLOCK_CONTROL);
+}
+
 static void tegra_crtc_mode_set_nofb(struct drm_crtc *crtc)
 {
 	struct drm_display_mode *mode = &crtc->state->adjusted_mode;
+	struct tegra_dc_state *state = to_dc_state(crtc->state);
 	struct tegra_dc *dc = to_tegra_dc(crtc);
 	u32 value;
 
+	tegra_dc_commit_state(dc, state);
+
 	/* program display mode */
 	tegra_dc_set_timings(dc, mode);
 
-- 
2.1.3

