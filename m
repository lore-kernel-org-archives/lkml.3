Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbbATKwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:52:39 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:62340 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306AbbATKtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:49:53 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 33/36] drm/tegra: Remove unused ->mode_fixup() callbacks
Date: Tue, 20 Jan 2015 11:48:52 +0100
Message-Id: <1421750935-4023-34-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
References: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

All output drivers have now been converted to use the ->atomic_check()
callback, so the ->mode_fixup() callbacks are no longer used.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/gpu/drm/tegra/dsi.c  | 87 --------------------------------------------
 drivers/gpu/drm/tegra/hdmi.c | 27 --------------
 drivers/gpu/drm/tegra/rgb.c  | 38 -------------------
 drivers/gpu/drm/tegra/sor.c  | 27 --------------
 4 files changed, 179 deletions(-)

diff --git a/drivers/gpu/drm/tegra/dsi.c b/drivers/gpu/drm/tegra/dsi.c
index 55a6a95bda84..39c79a65b4f3 100644
--- a/drivers/gpu/drm/tegra/dsi.c
+++ b/drivers/gpu/drm/tegra/dsi.c
@@ -786,92 +786,6 @@ static void tegra_dsi_encoder_dpms(struct drm_encoder *encoder, int mode)
 {
 }
 
-static bool tegra_dsi_encoder_mode_fixup(struct drm_encoder *encoder,
-					 const struct drm_display_mode *mode,
-					 struct drm_display_mode *adjusted)
-{
-	struct tegra_output *output = encoder_to_output(encoder);
-	struct tegra_dc *dc = to_tegra_dc(encoder->crtc);
-	unsigned int mul, div, scdiv, vrefresh, lanes;
-	struct tegra_dsi *dsi = to_dsi(output);
-	struct mipi_dphy_timing timing;
-	unsigned long pclk, bclk, plld;
-	unsigned long period;
-	int err;
-
-	lanes = tegra_dsi_get_lanes(dsi);
-	pclk = mode->clock * 1000;
-
-	err = tegra_dsi_get_muldiv(dsi->format, &mul, &div);
-	if (err < 0)
-		return err;
-
-	DRM_DEBUG_KMS("mul: %u, div: %u, lanes: %u\n", mul, div, lanes);
-	vrefresh = drm_mode_vrefresh(mode);
-	DRM_DEBUG_KMS("vrefresh: %u\n", vrefresh);
-
-	/* compute byte clock */
-	bclk = (pclk * mul) / (div * lanes);
-
-	/*
-	 * Compute bit clock and round up to the next MHz.
-	 */
-	plld = DIV_ROUND_UP(bclk * 8, USEC_PER_SEC) * USEC_PER_SEC;
-	period = DIV_ROUND_CLOSEST(NSEC_PER_SEC, plld);
-
-	/*
-	 * We divide the frequency by two here, but we make up for that by
-	 * setting the shift clock divider (further below) to half of the
-	 * correct value.
-	 */
-	plld /= 2;
-
-	/*
-	 * Derive pixel clock from bit clock using the shift clock divider.
-	 * Note that this is only half of what we would expect, but we need
-	 * that to make up for the fact that we divided the bit clock by a
-	 * factor of two above.
-	 *
-	 * It's not clear exactly why this is necessary, but the display is
-	 * not working properly otherwise. Perhaps the PLLs cannot generate
-	 * frequencies sufficiently high.
-	 */
-	scdiv = ((8 * mul) / (div * lanes)) - 2;
-
-	err = tegra_dc_setup_clock(dc, dsi->clk_parent, plld, scdiv);
-	if (err < 0) {
-		dev_err(output->dev, "failed to setup DC clock: %d\n", err);
-		return false;
-	}
-
-	err = clk_set_rate(dsi->clk_parent, plld);
-	if (err < 0) {
-		dev_err(dsi->dev, "failed to set clock rate to %lu Hz\n",
-			plld);
-		return false;
-	}
-
-	tegra_dsi_set_timeout(dsi, bclk, vrefresh);
-
-	err = mipi_dphy_timing_get_default(&timing, period);
-	if (err < 0)
-		return err;
-
-	err = mipi_dphy_timing_validate(&timing, period);
-	if (err < 0) {
-		dev_err(dsi->dev, "failed to validate D-PHY timing: %d\n", err);
-		return err;
-	}
-
-	/*
-	 * The D-PHY timing fields are expressed in byte-clock cycles, so
-	 * multiply the period by 8.
-	 */
-	tegra_dsi_set_phy_timing(dsi, period * 8, &timing);
-
-	return true;
-}
-
 static void tegra_dsi_encoder_prepare(struct drm_encoder *encoder)
 {
 }
@@ -1053,7 +967,6 @@ tegra_dsi_encoder_atomic_check(struct drm_encoder *encoder,
 
 static const struct drm_encoder_helper_funcs tegra_dsi_encoder_helper_funcs = {
 	.dpms = tegra_dsi_encoder_dpms,
-	.mode_fixup = tegra_dsi_encoder_mode_fixup,
 	.prepare = tegra_dsi_encoder_prepare,
 	.commit = tegra_dsi_encoder_commit,
 	.mode_set = tegra_dsi_encoder_mode_set,
diff --git a/drivers/gpu/drm/tegra/hdmi.c b/drivers/gpu/drm/tegra/hdmi.c
index abb1ea0385ec..07771956cc94 100644
--- a/drivers/gpu/drm/tegra/hdmi.c
+++ b/drivers/gpu/drm/tegra/hdmi.c
@@ -822,32 +822,6 @@ static void tegra_hdmi_encoder_dpms(struct drm_encoder *encoder, int mode)
 {
 }
 
-static bool tegra_hdmi_encoder_mode_fixup(struct drm_encoder *encoder,
-					  const struct drm_display_mode *mode,
-					  struct drm_display_mode *adjusted)
-{
-	struct tegra_output *output = encoder_to_output(encoder);
-	struct tegra_dc *dc = to_tegra_dc(encoder->crtc);
-	struct tegra_hdmi *hdmi = to_hdmi(output);
-	unsigned long pclk = mode->clock * 1000;
-	int err;
-
-	err = tegra_dc_setup_clock(dc, hdmi->clk_parent, pclk, 0);
-	if (err < 0) {
-		dev_err(output->dev, "failed to setup DC clock: %d\n", err);
-		return false;
-	}
-
-	err = clk_set_rate(hdmi->clk_parent, pclk);
-	if (err < 0) {
-		dev_err(output->dev, "failed to set clock rate to %lu Hz\n",
-			pclk);
-		return false;
-	}
-
-	return true;
-}
-
 static void tegra_hdmi_encoder_prepare(struct drm_encoder *encoder)
 {
 }
@@ -1104,7 +1078,6 @@ tegra_hdmi_encoder_atomic_check(struct drm_encoder *encoder,
 
 static const struct drm_encoder_helper_funcs tegra_hdmi_encoder_helper_funcs = {
 	.dpms = tegra_hdmi_encoder_dpms,
-	.mode_fixup = tegra_hdmi_encoder_mode_fixup,
 	.prepare = tegra_hdmi_encoder_prepare,
 	.commit = tegra_hdmi_encoder_commit,
 	.mode_set = tegra_hdmi_encoder_mode_set,
diff --git a/drivers/gpu/drm/tegra/rgb.c b/drivers/gpu/drm/tegra/rgb.c
index be1b38936dbe..0c8b458b2364 100644
--- a/drivers/gpu/drm/tegra/rgb.c
+++ b/drivers/gpu/drm/tegra/rgb.c
@@ -129,43 +129,6 @@ static void tegra_rgb_encoder_dpms(struct drm_encoder *encoder, int mode)
 {
 }
 
-static bool tegra_rgb_encoder_mode_fixup(struct drm_encoder *encoder,
-					 const struct drm_display_mode *mode,
-					 struct drm_display_mode *adjusted)
-{
-	struct tegra_output *output = encoder_to_output(encoder);
-	unsigned long pclk = mode->clock * 1000;
-	struct tegra_rgb *rgb = to_rgb(output);
-	unsigned int div;
-	int err;
-
-	/*
-	 * We may not want to change the frequency of the parent clock, since
-	 * it may be a parent for other peripherals. This is due to the fact
-	 * that on Tegra20 there's only a single clock dedicated to display
-	 * (pll_d_out0), whereas later generations have a second one that can
-	 * be used to independently drive a second output (pll_d2_out0).
-	 *
-	 * As a way to support multiple outputs on Tegra20 as well, pll_p is
-	 * typically used as the parent clock for the display controllers.
-	 * But this comes at a cost: pll_p is the parent of several other
-	 * peripherals, so its frequency shouldn't change out of the blue.
-	 *
-	 * The best we can do at this point is to use the shift clock divider
-	 * and hope that the desired frequency can be matched (or at least
-	 * matched sufficiently close that the panel will still work).
-	 */
-	div = ((clk_get_rate(rgb->clk) * 2) / pclk) - 2;
-
-	err = tegra_dc_setup_clock(rgb->dc, rgb->clk_parent, pclk, div);
-	if (err < 0) {
-		dev_err(output->dev, "failed to setup DC clock: %d\n", err);
-		return false;
-	}
-
-	return true;
-}
-
 static void tegra_rgb_encoder_prepare(struct drm_encoder *encoder)
 {
 }
@@ -278,7 +241,6 @@ tegra_rgb_encoder_atomic_check(struct drm_encoder *encoder,
 
 static const struct drm_encoder_helper_funcs tegra_rgb_encoder_helper_funcs = {
 	.dpms = tegra_rgb_encoder_dpms,
-	.mode_fixup = tegra_rgb_encoder_mode_fixup,
 	.prepare = tegra_rgb_encoder_prepare,
 	.commit = tegra_rgb_encoder_commit,
 	.mode_set = tegra_rgb_encoder_mode_set,
diff --git a/drivers/gpu/drm/tegra/sor.c b/drivers/gpu/drm/tegra/sor.c
index 7463ea02a083..e813df71e30c 100644
--- a/drivers/gpu/drm/tegra/sor.c
+++ b/drivers/gpu/drm/tegra/sor.c
@@ -781,32 +781,6 @@ static void tegra_sor_encoder_dpms(struct drm_encoder *encoder, int mode)
 {
 }
 
-static bool tegra_sor_encoder_mode_fixup(struct drm_encoder *encoder,
-					 const struct drm_display_mode *mode,
-					 struct drm_display_mode *adjusted)
-{
-	struct tegra_output *output = encoder_to_output(encoder);
-	struct tegra_dc *dc = to_tegra_dc(encoder->crtc);
-	unsigned long pclk = mode->clock * 1000;
-	struct tegra_sor *sor = to_sor(output);
-	int err;
-
-	err = tegra_dc_setup_clock(dc, sor->clk_parent, pclk, 0);
-	if (err < 0) {
-		dev_err(output->dev, "failed to setup DC clock: %d\n", err);
-		return false;
-	}
-
-	err = clk_set_rate(sor->clk_parent, pclk);
-	if (err < 0) {
-		dev_err(output->dev, "failed to set clock rate to %lu Hz\n",
-			pclk);
-		return false;
-	}
-
-	return true;
-}
-
 static void tegra_sor_encoder_prepare(struct drm_encoder *encoder)
 {
 }
@@ -1343,7 +1317,6 @@ tegra_sor_encoder_atomic_check(struct drm_encoder *encoder,
 
 static const struct drm_encoder_helper_funcs tegra_sor_encoder_helper_funcs = {
 	.dpms = tegra_sor_encoder_dpms,
-	.mode_fixup = tegra_sor_encoder_mode_fixup,
 	.prepare = tegra_sor_encoder_prepare,
 	.commit = tegra_sor_encoder_commit,
 	.mode_set = tegra_sor_encoder_mode_set,
-- 
2.1.3

