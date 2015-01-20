Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278AbbATKtq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:49:46 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:50292 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623AbbATKto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:49:44 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 27/36] drm/tegra: dsi: Implement ->atomic_check()
Date: Tue, 20 Jan 2015 11:48:46 +0100
Message-Id: <1421750935-4023-28-git-send-email-thierry.reding@gmail.com>
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
 drivers/gpu/drm/tegra/dsi.c | 269 ++++++++++++++++++++++++++++++++------------
 1 file changed, 196 insertions(+), 73 deletions(-)

diff --git a/drivers/gpu/drm/tegra/dsi.c b/drivers/gpu/drm/tegra/dsi.c
index 9799f3edc3f8..55a6a95bda84 100644
--- a/drivers/gpu/drm/tegra/dsi.c
+++ b/drivers/gpu/drm/tegra/dsi.c
@@ -28,6 +28,28 @@
 #include "dsi.h"
 #include "mipi-phy.h"
 
+struct tegra_dsi_state {
+	struct drm_connector_state base;
+
+	struct mipi_dphy_timing timing;
+	unsigned long period;
+
+	unsigned int vrefresh;
+	unsigned int lanes;
+	unsigned long pclk;
+	unsigned long bclk;
+
+	enum tegra_dsi_format format;
+	unsigned int mul;
+	unsigned int div;
+};
+
+static inline struct tegra_dsi_state *
+to_dsi_state(struct drm_connector_state *state)
+{
+	return container_of(state, struct tegra_dsi_state, base);
+}
+
 struct tegra_dsi {
 	struct host1x_client client;
 	struct tegra_output output;
@@ -77,6 +99,11 @@ static inline struct tegra_dsi *to_dsi(struct tegra_output *output)
 	return container_of(output, struct tegra_dsi, output);
 }
 
+static struct tegra_dsi_state *tegra_dsi_get_state(struct tegra_dsi *dsi)
+{
+	return to_dsi_state(dsi->output.connector.state);
+}
+
 static inline u32 tegra_dsi_readl(struct tegra_dsi *dsi, unsigned long reg)
 {
 	return readl(dsi->regs + (reg << 2));
@@ -335,62 +362,36 @@ static const u32 pkt_seq_command_mode[NUM_PKT_SEQ] = {
 	[11] = 0,
 };
 
-static int tegra_dsi_set_phy_timing(struct tegra_dsi *dsi)
+static void tegra_dsi_set_phy_timing(struct tegra_dsi *dsi,
+				     unsigned long period,
+				     const struct mipi_dphy_timing *timing)
 {
-	struct mipi_dphy_timing timing;
-	unsigned long period;
 	u32 value;
-	long rate;
-	int err;
-
-	rate = clk_get_rate(dsi->clk);
-	if (rate < 0)
-		return rate;
-
-	period = DIV_ROUND_CLOSEST(NSEC_PER_SEC, rate * 2);
 
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
-	 * The D-PHY timing fields below are expressed in byte-clock cycles,
-	 * so multiply the period by 8.
-	 */
-	period *= 8;
-
-	value = DSI_TIMING_FIELD(timing.hsexit, period, 1) << 24 |
-		DSI_TIMING_FIELD(timing.hstrail, period, 0) << 16 |
-		DSI_TIMING_FIELD(timing.hszero, period, 3) << 8 |
-		DSI_TIMING_FIELD(timing.hsprepare, period, 1);
+	value = DSI_TIMING_FIELD(timing->hsexit, period, 1) << 24 |
+		DSI_TIMING_FIELD(timing->hstrail, period, 0) << 16 |
+		DSI_TIMING_FIELD(timing->hszero, period, 3) << 8 |
+		DSI_TIMING_FIELD(timing->hsprepare, period, 1);
 	tegra_dsi_writel(dsi, value, DSI_PHY_TIMING_0);
 
-	value = DSI_TIMING_FIELD(timing.clktrail, period, 1) << 24 |
-		DSI_TIMING_FIELD(timing.clkpost, period, 1) << 16 |
-		DSI_TIMING_FIELD(timing.clkzero, period, 1) << 8 |
-		DSI_TIMING_FIELD(timing.lpx, period, 1);
+	value = DSI_TIMING_FIELD(timing->clktrail, period, 1) << 24 |
+		DSI_TIMING_FIELD(timing->clkpost, period, 1) << 16 |
+		DSI_TIMING_FIELD(timing->clkzero, period, 1) << 8 |
+		DSI_TIMING_FIELD(timing->lpx, period, 1);
 	tegra_dsi_writel(dsi, value, DSI_PHY_TIMING_1);
 
-	value = DSI_TIMING_FIELD(timing.clkprepare, period, 1) << 16 |
-		DSI_TIMING_FIELD(timing.clkpre, period, 1) << 8 |
+	value = DSI_TIMING_FIELD(timing->clkprepare, period, 1) << 16 |
+		DSI_TIMING_FIELD(timing->clkpre, period, 1) << 8 |
 		DSI_TIMING_FIELD(0xff * period, period, 0) << 0;
 	tegra_dsi_writel(dsi, value, DSI_PHY_TIMING_2);
 
-	value = DSI_TIMING_FIELD(timing.taget, period, 1) << 16 |
-		DSI_TIMING_FIELD(timing.tasure, period, 1) << 8 |
-		DSI_TIMING_FIELD(timing.tago, period, 1);
+	value = DSI_TIMING_FIELD(timing->taget, period, 1) << 16 |
+		DSI_TIMING_FIELD(timing->tasure, period, 1) << 8 |
+		DSI_TIMING_FIELD(timing->tago, period, 1);
 	tegra_dsi_writel(dsi, value, DSI_BTA_TIMING);
 
 	if (dsi->slave)
-		return tegra_dsi_set_phy_timing(dsi->slave);
-
-	return 0;
+		tegra_dsi_set_phy_timing(dsi->slave, period, timing);
 }
 
 static int tegra_dsi_get_muldiv(enum mipi_dsi_pixel_format format,
@@ -482,14 +483,22 @@ static unsigned int tegra_dsi_get_lanes(struct tegra_dsi *dsi)
 	return dsi->lanes;
 }
 
-static int tegra_dsi_configure(struct tegra_dsi *dsi, unsigned int pipe,
-			       const struct drm_display_mode *mode)
+static void tegra_dsi_configure(struct tegra_dsi *dsi, unsigned int pipe,
+				const struct drm_display_mode *mode)
 {
 	unsigned int hact, hsw, hbp, hfp, i, mul, div;
-	enum tegra_dsi_format format;
+	struct tegra_dsi_state *state;
 	const u32 *pkt_seq;
 	u32 value;
-	int err;
+
+	/* XXX: pass in state into this function? */
+	if (dsi->master)
+		state = tegra_dsi_get_state(dsi->master);
+	else
+		state = tegra_dsi_get_state(dsi);
+
+	mul = state->mul;
+	div = state->div;
 
 	if (dsi->flags & MIPI_DSI_MODE_VIDEO_SYNC_PULSE) {
 		DRM_DEBUG_KMS("Non-burst video mode with sync pulses\n");
@@ -502,15 +511,8 @@ static int tegra_dsi_configure(struct tegra_dsi *dsi, unsigned int pipe,
 		pkt_seq = pkt_seq_command_mode;
 	}
 
-	err = tegra_dsi_get_muldiv(dsi->format, &mul, &div);
-	if (err < 0)
-		return err;
-
-	err = tegra_dsi_get_format(dsi->format, &format);
-	if (err < 0)
-		return err;
-
-	value = DSI_CONTROL_CHANNEL(0) | DSI_CONTROL_FORMAT(format) |
+	value = DSI_CONTROL_CHANNEL(0) |
+		DSI_CONTROL_FORMAT(state->format) |
 		DSI_CONTROL_LANES(dsi->lanes - 1) |
 		DSI_CONTROL_SOURCE(pipe);
 	tegra_dsi_writel(dsi, value, DSI_CONTROL);
@@ -589,8 +591,8 @@ static int tegra_dsi_configure(struct tegra_dsi *dsi, unsigned int pipe,
 
 		/* set SOL delay */
 		if (dsi->master || dsi->slave) {
-			unsigned int lanes = tegra_dsi_get_lanes(dsi);
 			unsigned long delay, bclk, bclk_ganged;
+			unsigned int lanes = state->lanes;
 
 			/* SOL to valid, valid to FIFO and FIFO write delay */
 			delay = 4 + 4 + 2;
@@ -610,9 +612,7 @@ static int tegra_dsi_configure(struct tegra_dsi *dsi, unsigned int pipe,
 	}
 
 	if (dsi->slave) {
-		err = tegra_dsi_configure(dsi->slave, pipe, mode);
-		if (err < 0)
-			return err;
+		tegra_dsi_configure(dsi->slave, pipe, mode);
 
 		/*
 		 * TODO: Support modes other than symmetrical left-right
@@ -622,8 +622,6 @@ static int tegra_dsi_configure(struct tegra_dsi *dsi, unsigned int pipe,
 		tegra_dsi_ganged_enable(dsi->slave, mode->hdisplay / 2,
 					mode->hdisplay / 2);
 	}
-
-	return 0;
 }
 
 static int tegra_dsi_wait_idle(struct tegra_dsi *dsi, unsigned long timeout)
@@ -732,13 +730,38 @@ static void tegra_dsi_connector_dpms(struct drm_connector *connector, int mode)
 {
 }
 
+static void tegra_dsi_connector_reset(struct drm_connector *connector)
+{
+	struct tegra_dsi_state *state;
+
+	kfree(connector->state);
+	connector->state = NULL;
+
+	state = kzalloc(sizeof(*state), GFP_KERNEL);
+	if (state)
+		connector->state = &state->base;
+}
+
+static struct drm_connector_state *
+tegra_dsi_connector_duplicate_state(struct drm_connector *connector)
+{
+	struct tegra_dsi_state *state = to_dsi_state(connector->state);
+	struct tegra_dsi_state *copy;
+
+	copy = kmemdup(state, sizeof(*state), GFP_KERNEL);
+	if (!copy)
+		return NULL;
+
+	return &copy->base;
+}
+
 static const struct drm_connector_funcs tegra_dsi_connector_funcs = {
 	.dpms = tegra_dsi_connector_dpms,
-	.reset = drm_atomic_helper_connector_reset,
+	.reset = tegra_dsi_connector_reset,
 	.detect = tegra_output_connector_detect,
 	.fill_modes = drm_helper_probe_single_connector_modes,
 	.destroy = tegra_output_connector_destroy,
-	.atomic_duplicate_state = drm_atomic_helper_connector_duplicate_state,
+	.atomic_duplicate_state = tegra_dsi_connector_duplicate_state,
 	.atomic_destroy_state = drm_atomic_helper_connector_destroy_state,
 };
 
@@ -771,7 +794,9 @@ static bool tegra_dsi_encoder_mode_fixup(struct drm_encoder *encoder,
 	struct tegra_dc *dc = to_tegra_dc(encoder->crtc);
 	unsigned int mul, div, scdiv, vrefresh, lanes;
 	struct tegra_dsi *dsi = to_dsi(output);
+	struct mipi_dphy_timing timing;
 	unsigned long pclk, bclk, plld;
+	unsigned long period;
 	int err;
 
 	lanes = tegra_dsi_get_lanes(dsi);
@@ -792,6 +817,7 @@ static bool tegra_dsi_encoder_mode_fixup(struct drm_encoder *encoder,
 	 * Compute bit clock and round up to the next MHz.
 	 */
 	plld = DIV_ROUND_UP(bclk * 8, USEC_PER_SEC) * USEC_PER_SEC;
+	period = DIV_ROUND_CLOSEST(NSEC_PER_SEC, plld);
 
 	/*
 	 * We divide the frequency by two here, but we make up for that by
@@ -827,12 +853,22 @@ static bool tegra_dsi_encoder_mode_fixup(struct drm_encoder *encoder,
 
 	tegra_dsi_set_timeout(dsi, bclk, vrefresh);
 
-	err = tegra_dsi_set_phy_timing(dsi);
+	err = mipi_dphy_timing_get_default(&timing, period);
+	if (err < 0)
+		return err;
+
+	err = mipi_dphy_timing_validate(&timing, period);
 	if (err < 0) {
-		dev_err(dsi->dev, "failed to setup D-PHY timing: %d\n", err);
-		return false;
+		dev_err(dsi->dev, "failed to validate D-PHY timing: %d\n", err);
+		return err;
 	}
 
+	/*
+	 * The D-PHY timing fields are expressed in byte-clock cycles, so
+	 * multiply the period by 8.
+	 */
+	tegra_dsi_set_phy_timing(dsi, period * 8, &timing);
+
 	return true;
 }
 
@@ -851,19 +887,24 @@ static void tegra_dsi_encoder_mode_set(struct drm_encoder *encoder,
 	struct tegra_output *output = encoder_to_output(encoder);
 	struct tegra_dc *dc = to_tegra_dc(encoder->crtc);
 	struct tegra_dsi *dsi = to_dsi(output);
+	struct tegra_dsi_state *state;
 	u32 value;
-	int err;
 
+	state = tegra_dsi_get_state(dsi);
 
-	err = tegra_dsi_configure(dsi, dc->pipe, mode);
-	if (err < 0) {
-		dev_err(dsi->dev, "failed to configure DSI: %d\n", err);
-		return;
-	}
+	tegra_dsi_set_timeout(dsi, state->bclk, state->vrefresh);
+
+	/*
+	 * The D-PHY timing fields are expressed in byte-clock cycles, so
+	 * multiply the period by 8.
+	 */
+	tegra_dsi_set_phy_timing(dsi, state->period * 8, &state->timing);
 
 	if (output->panel)
 		drm_panel_prepare(output->panel);
 
+	tegra_dsi_configure(dsi, dc->pipe, mode);
+
 	/* enable display controller */
 	value = tegra_dc_readl(dc, DC_DISP_DISP_WIN_OPTIONS);
 	value |= DSI_ENABLE;
@@ -929,6 +970,87 @@ static void tegra_dsi_encoder_disable(struct drm_encoder *encoder)
 	return;
 }
 
+static int
+tegra_dsi_encoder_atomic_check(struct drm_encoder *encoder,
+			       struct drm_crtc_state *crtc_state,
+			       struct drm_connector_state *conn_state)
+{
+	struct tegra_output *output = encoder_to_output(encoder);
+	struct tegra_dsi_state *state = to_dsi_state(conn_state);
+	struct tegra_dc *dc = to_tegra_dc(conn_state->crtc);
+	struct tegra_dsi *dsi = to_dsi(output);
+	unsigned int scdiv;
+	unsigned long plld;
+	int err;
+
+	state->pclk = crtc_state->mode.clock * 1000;
+
+	err = tegra_dsi_get_muldiv(dsi->format, &state->mul, &state->div);
+	if (err < 0)
+		return err;
+
+	state->lanes = tegra_dsi_get_lanes(dsi);
+
+	err = tegra_dsi_get_format(dsi->format, &state->format);
+	if (err < 0)
+		return err;
+
+	state->vrefresh = drm_mode_vrefresh(&crtc_state->mode);
+
+	/* compute byte clock */
+	state->bclk = (state->pclk * state->mul) / (state->div * state->lanes);
+
+	DRM_DEBUG_KMS("mul: %u, div: %u, lanes: %u\n", state->mul, state->div,
+		      state->lanes);
+	DRM_DEBUG_KMS("format: %u, vrefresh: %u\n", state->format,
+		      state->vrefresh);
+	DRM_DEBUG_KMS("bclk: %lu\n", state->bclk);
+
+	/*
+	 * Compute bit clock and round up to the next MHz.
+	 */
+	plld = DIV_ROUND_UP(state->bclk * 8, USEC_PER_SEC) * USEC_PER_SEC;
+	state->period = DIV_ROUND_CLOSEST(NSEC_PER_SEC, plld);
+
+	err = mipi_dphy_timing_get_default(&state->timing, state->period);
+	if (err < 0)
+		return err;
+
+	err = mipi_dphy_timing_validate(&state->timing, state->period);
+	if (err < 0) {
+		dev_err(dsi->dev, "failed to validate D-PHY timing: %d\n", err);
+		return err;
+	}
+
+	/*
+	 * We divide the frequency by two here, but we make up for that by
+	 * setting the shift clock divider (further below) to half of the
+	 * correct value.
+	 */
+	plld /= 2;
+
+	/*
+	 * Derive pixel clock from bit clock using the shift clock divider.
+	 * Note that this is only half of what we would expect, but we need
+	 * that to make up for the fact that we divided the bit clock by a
+	 * factor of two above.
+	 *
+	 * It's not clear exactly why this is necessary, but the display is
+	 * not working properly otherwise. Perhaps the PLLs cannot generate
+	 * frequencies sufficiently high.
+	 */
+	scdiv = ((8 * state->mul) / (state->div * state->lanes)) - 2;
+
+	err = tegra_dc_state_setup_clock(dc, crtc_state, dsi->clk_parent,
+					 plld, scdiv);
+	if (err < 0) {
+		dev_err(output->dev, "failed to setup CRTC state: %d\n", err);
+		return err;
+	}
+
+	return err;
+}
+
 static const struct drm_encoder_helper_funcs tegra_dsi_encoder_helper_funcs = {
 	.dpms = tegra_dsi_encoder_dpms,
 	.mode_fixup = tegra_dsi_encoder_mode_fixup,
@@ -936,6 +1058,7 @@ static const struct drm_encoder_helper_funcs tegra_dsi_encoder_helper_funcs = {
 	.commit = tegra_dsi_encoder_commit,
 	.mode_set = tegra_dsi_encoder_mode_set,
 	.disable = tegra_dsi_encoder_disable,
+	.atomic_check = tegra_dsi_encoder_atomic_check,
 };
 
 static int tegra_dsi_pad_enable(struct tegra_dsi *dsi)
-- 
2.1.3

