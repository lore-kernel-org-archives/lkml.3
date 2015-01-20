Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbbATK4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:56:38 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:45183 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243AbbATKtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:49:42 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 26/36] drm/tegra: rgb: Implement ->atomic_check()
Date: Tue, 20 Jan 2015 11:48:45 +0100
Message-Id: <1421750935-4023-27-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
References: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

The implementation of the ->atomic_check() callback precomputes all
parameters to check if the given configuration can be applied. If so the
precomputed values are stored in the atomic state object for the encoder
and applied during modeset. In that way the modeset no longer needs to
perform any checking but simply program values into registers.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/gpu/drm/tegra/rgb.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/drivers/gpu/drm/tegra/rgb.c b/drivers/gpu/drm/tegra/rgb.c
index 78e3cb1529d0..be1b38936dbe 100644
--- a/drivers/gpu/drm/tegra/rgb.c
+++ b/drivers/gpu/drm/tegra/rgb.c
@@ -235,6 +235,47 @@ static void tegra_rgb_encoder_disable(struct drm_encoder *encoder)
 		drm_panel_unprepare(output->panel);
 }
 
+static int
+tegra_rgb_encoder_atomic_check(struct drm_encoder *encoder,
+			       struct drm_crtc_state *crtc_state,
+			       struct drm_connector_state *conn_state)
+{
+	struct tegra_output *output = encoder_to_output(encoder);
+	struct tegra_dc *dc = to_tegra_dc(conn_state->crtc);
+	unsigned long pclk = crtc_state->mode.clock * 1000;
+	struct tegra_rgb *rgb = to_rgb(output);
+	unsigned int div;
+	int err;
+
+	/*
+	 * We may not want to change the frequency of the parent clock, since
+	 * it may be a parent for other peripherals. This is due to the fact
+	 * that on Tegra20 there's only a single clock dedicated to display
+	 * (pll_d_out0), whereas later generations have a second one that can
+	 * be used to independently drive a second output (pll_d2_out0).
+	 *
+	 * As a way to support multiple outputs on Tegra20 as well, pll_p is
+	 * typically used as the parent clock for the display controllers.
+	 * But this comes at a cost: pll_p is the parent of several other
+	 * peripherals, so its frequency shouldn't change out of the blue.
+	 *
+	 * The best we can do at this point is to use the shift clock divider
+	 * and hope that the desired frequency can be matched (or at least
+	 * matched sufficiently close that the panel will still work).
+	 */
+	div = ((clk_get_rate(rgb->clk) * 2) / pclk) - 2;
+	pclk = 0;
+
+	err = tegra_dc_state_setup_clock(dc, crtc_state, rgb->clk_parent,
+					 pclk, div);
+	if (err < 0) {
+		dev_err(output->dev, "failed to setup CRTC state: %d\n", err);
+		return err;
+	}
+
+	return err;
+}
+
 static const struct drm_encoder_helper_funcs tegra_rgb_encoder_helper_funcs = {
 	.dpms = tegra_rgb_encoder_dpms,
 	.mode_fixup = tegra_rgb_encoder_mode_fixup,
@@ -242,6 +283,7 @@ static const struct drm_encoder_helper_funcs tegra_rgb_encoder_helper_funcs = {
 	.commit = tegra_rgb_encoder_commit,
 	.mode_set = tegra_rgb_encoder_mode_set,
 	.disable = tegra_rgb_encoder_disable,
+	.atomic_check = tegra_rgb_encoder_atomic_check,
 };
 
 int tegra_dc_rgb_probe(struct tegra_dc *dc)
-- 
2.1.3

