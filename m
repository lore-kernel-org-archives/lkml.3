Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbbATKt3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:49:29 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:61590 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123AbbATKtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:49:22 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 14/36] drm/tegra: rgb: Demidlayer
Date: Tue, 20 Jan 2015 11:48:33 +0100
Message-Id: <1421750935-4023-15-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
References: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Implement encoder and connector within the RGB driver itself using the
Tegra output helpers rather than using the Tegra output as midlayer. By
doing so one level of indirection is removed and output drivers become
more flexible while keeping the majority of the advantages provided by
the common output helpers.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/gpu/drm/tegra/dc.c     |  24 ++++
 drivers/gpu/drm/tegra/drm.h    |   1 -
 drivers/gpu/drm/tegra/output.c |   5 -
 drivers/gpu/drm/tegra/rgb.c    | 243 +++++++++++++++++++++++------------------
 4 files changed, 161 insertions(+), 112 deletions(-)

diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index 39e1b3b38536..c51fc4db73db 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -1001,6 +1001,7 @@ static int tegra_dc_wait_idle(struct tegra_dc *dc, unsigned long timeout)
 static void tegra_crtc_disable(struct drm_crtc *crtc)
 {
 	struct tegra_dc *dc = to_tegra_dc(crtc);
+	u32 value;
 
 	if (!tegra_dc_idle(dc)) {
 		tegra_dc_stop(dc);
@@ -1012,6 +1013,29 @@ static void tegra_crtc_disable(struct drm_crtc *crtc)
 		tegra_dc_wait_idle(dc, 100);
 	}
 
+	/*
+	 * This should really be part of the RGB encoder driver, but clearing
+	 * these bits has the side-effect of stopping the display controller.
+	 * When that happens no VBLANK interrupts will be raised. At the same
+	 * time the encoder is disabled before the display controller, so the
+	 * above code is always going to timeout waiting for the controller
+	 * to go idle.
+	 *
+	 * Given the close coupling between the RGB encoder and the display
+	 * controller doing it here is still kind of okay. None of the other
+	 * encoder drivers require these bits to be cleared.
+	 *
+	 * XXX: Perhaps given that the display controller is switched off at
+	 * this point anyway maybe clearing these bits isn't even useful for
+	 * the RGB encoder?
+	 */
+	if (dc->rgb) {
+		value = tegra_dc_readl(dc, DC_CMD_DISPLAY_POWER_CONTROL);
+		value &= ~(PW0_ENABLE | PW1_ENABLE | PW2_ENABLE | PW3_ENABLE |
+			   PW4_ENABLE | PM0_ENABLE | PM1_ENABLE);
+		tegra_dc_writel(dc, value, DC_CMD_DISPLAY_POWER_CONTROL);
+	}
+
 	drm_crtc_vblank_off(crtc);
 	tegra_dc_commit(dc);
 }
diff --git a/drivers/gpu/drm/tegra/drm.h b/drivers/gpu/drm/tegra/drm.h
index e1374ec2b76e..dbc1f83327ea 100644
--- a/drivers/gpu/drm/tegra/drm.h
+++ b/drivers/gpu/drm/tegra/drm.h
@@ -193,7 +193,6 @@ struct tegra_output_ops {
 };
 
 enum tegra_output_type {
-	TEGRA_OUTPUT_RGB,
 	TEGRA_OUTPUT_HDMI,
 	TEGRA_OUTPUT_DSI,
 	TEGRA_OUTPUT_EDP,
diff --git a/drivers/gpu/drm/tegra/output.c b/drivers/gpu/drm/tegra/output.c
index bc82743904c1..9dd3c34d47fe 100644
--- a/drivers/gpu/drm/tegra/output.c
+++ b/drivers/gpu/drm/tegra/output.c
@@ -276,11 +276,6 @@ int tegra_output_init(struct drm_device *drm, struct tegra_output *output)
 	int connector, encoder;
 
 	switch (output->type) {
-	case TEGRA_OUTPUT_RGB:
-		connector = DRM_MODE_CONNECTOR_LVDS;
-		encoder = DRM_MODE_ENCODER_LVDS;
-		break;
-
 	case TEGRA_OUTPUT_HDMI:
 		connector = DRM_MODE_CONNECTOR_HDMIA;
 		encoder = DRM_MODE_ENCODER_TMDS;
diff --git a/drivers/gpu/drm/tegra/rgb.c b/drivers/gpu/drm/tegra/rgb.c
index 39b8d5fe04b2..30d7ae02ace8 100644
--- a/drivers/gpu/drm/tegra/rgb.c
+++ b/drivers/gpu/drm/tegra/rgb.c
@@ -9,6 +9,8 @@
 
 #include <linux/clk.h>
 
+#include <drm/drm_panel.h>
+
 #include "drm.h"
 #include "dc.h"
 
@@ -85,13 +87,99 @@ static void tegra_dc_write_regs(struct tegra_dc *dc,
 		tegra_dc_writel(dc, table[i].value, table[i].offset);
 }
 
-static int tegra_output_rgb_enable(struct tegra_output *output)
+static void tegra_rgb_connector_dpms(struct drm_connector *connector,
+				     int mode)
+{
+}
+
+static const struct drm_connector_funcs tegra_rgb_connector_funcs = {
+	.dpms = tegra_rgb_connector_dpms,
+	.detect = tegra_output_connector_detect,
+	.fill_modes = drm_helper_probe_single_connector_modes,
+	.destroy = tegra_output_connector_destroy,
+};
+
+static enum drm_mode_status
+tegra_rgb_connector_mode_valid(struct drm_connector *connector,
+			       struct drm_display_mode *mode)
+{
+	/*
+	 * FIXME: For now, always assume that the mode is okay. There are
+	 * unresolved issues with clk_round_rate(), which doesn't always
+	 * reliably report whether a frequency can be set or not.
+	 */
+	return MODE_OK;
+}
+
+static const struct drm_connector_helper_funcs tegra_rgb_connector_helper_funcs = {
+	.get_modes = tegra_output_connector_get_modes,
+	.mode_valid = tegra_rgb_connector_mode_valid,
+	.best_encoder = tegra_output_connector_best_encoder,
+};
+
+static const struct drm_encoder_funcs tegra_rgb_encoder_funcs = {
+	.destroy = tegra_output_encoder_destroy,
+};
+
+static void tegra_rgb_encoder_dpms(struct drm_encoder *encoder, int mode)
+{
+}
+
+static bool tegra_rgb_encoder_mode_fixup(struct drm_encoder *encoder,
+					 const struct drm_display_mode *mode,
+					 struct drm_display_mode *adjusted)
 {
+	struct tegra_output *output = encoder_to_output(encoder);
+	unsigned long pclk = mode->clock * 1000;
 	struct tegra_rgb *rgb = to_rgb(output);
-	unsigned long value;
+	unsigned int div;
+	int err;
 
-	if (rgb->enabled)
-		return 0;
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
+
+	err = tegra_dc_setup_clock(rgb->dc, rgb->clk_parent, pclk, div);
+	if (err < 0) {
+		dev_err(output->dev, "failed to setup DC clock: %d\n", err);
+		return false;
+	}
+
+	return true;
+}
+
+static void tegra_rgb_encoder_prepare(struct drm_encoder *encoder)
+{
+}
+
+static void tegra_rgb_encoder_commit(struct drm_encoder *encoder)
+{
+}
+
+static void tegra_rgb_encoder_mode_set(struct drm_encoder *encoder,
+				       struct drm_display_mode *mode,
+				       struct drm_display_mode *adjusted)
+{
+	struct tegra_output *output = encoder_to_output(encoder);
+	struct tegra_rgb *rgb = to_rgb(output);
+	u32 value;
+
+	if (output->panel)
+		drm_panel_prepare(output->panel);
 
 	tegra_dc_write_regs(rgb->dc, rgb_enable, ARRAY_SIZE(rgb_enable));
 
@@ -125,88 +213,31 @@ static int tegra_output_rgb_enable(struct tegra_output *output)
 
 	tegra_dc_commit(rgb->dc);
 
-	rgb->enabled = true;
-
-	return 0;
+	if (output->panel)
+		drm_panel_enable(output->panel);
 }
 
-static int tegra_output_rgb_disable(struct tegra_output *output)
+static void tegra_rgb_encoder_disable(struct drm_encoder *encoder)
 {
+	struct tegra_output *output = encoder_to_output(encoder);
 	struct tegra_rgb *rgb = to_rgb(output);
-	unsigned long value;
 
-	if (!rgb->enabled)
-		return 0;
-
-	value = tegra_dc_readl(rgb->dc, DC_CMD_DISPLAY_POWER_CONTROL);
-	value &= ~(PW0_ENABLE | PW1_ENABLE | PW2_ENABLE | PW3_ENABLE |
-		   PW4_ENABLE | PM0_ENABLE | PM1_ENABLE);
-	tegra_dc_writel(rgb->dc, value, DC_CMD_DISPLAY_POWER_CONTROL);
+	if (output->panel)
+		drm_panel_disable(output->panel);
 
 	tegra_dc_write_regs(rgb->dc, rgb_disable, ARRAY_SIZE(rgb_disable));
 
-	tegra_dc_commit(rgb->dc);
-
-	rgb->enabled = false;
-
-	return 0;
+	if (output->panel)
+		drm_panel_unprepare(output->panel);
 }
 
-static int tegra_output_rgb_setup_clock(struct tegra_output *output,
-					struct clk *clk, unsigned long pclk,
-					unsigned int *div)
-{
-	struct tegra_rgb *rgb = to_rgb(output);
-	int err;
-
-	err = clk_set_parent(clk, rgb->clk_parent);
-	if (err < 0) {
-		dev_err(output->dev, "failed to set parent: %d\n", err);
-		return err;
-	}
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
-
-	*div = ((clk_get_rate(clk) * 2) / pclk) - 2;
-
-	return 0;
-}
-
-static int tegra_output_rgb_check_mode(struct tegra_output *output,
-				       struct drm_display_mode *mode,
-				       enum drm_mode_status *status)
-{
-	/*
-	 * FIXME: For now, always assume that the mode is okay. There are
-	 * unresolved issues with clk_round_rate(), which doesn't always
-	 * reliably report whether a frequency can be set or not.
-	 */
-
-	*status = MODE_OK;
-
-	return 0;
-}
-
-static const struct tegra_output_ops rgb_ops = {
-	.enable = tegra_output_rgb_enable,
-	.disable = tegra_output_rgb_disable,
-	.setup_clock = tegra_output_rgb_setup_clock,
-	.check_mode = tegra_output_rgb_check_mode,
+static const struct drm_encoder_helper_funcs tegra_rgb_encoder_helper_funcs = {
+	.dpms = tegra_rgb_encoder_dpms,
+	.mode_fixup = tegra_rgb_encoder_mode_fixup,
+	.prepare = tegra_rgb_encoder_prepare,
+	.commit = tegra_rgb_encoder_commit,
+	.mode_set = tegra_rgb_encoder_mode_set,
+	.disable = tegra_rgb_encoder_disable,
 };
 
 int tegra_dc_rgb_probe(struct tegra_dc *dc)
@@ -265,55 +296,55 @@ int tegra_dc_rgb_remove(struct tegra_dc *dc)
 	if (err < 0)
 		return err;
 
+	dc->rgb = NULL;
+
 	return 0;
 }
 
 int tegra_dc_rgb_init(struct drm_device *drm, struct tegra_dc *dc)
 {
-	struct tegra_rgb *rgb = to_rgb(dc->rgb);
+	struct tegra_output *output = dc->rgb;
 	int err;
 
 	if (!dc->rgb)
 		return -ENODEV;
 
-	rgb->output.type = TEGRA_OUTPUT_RGB;
-	rgb->output.ops = &rgb_ops;
-
-	err = tegra_output_init(dc->base.dev, &rgb->output);
-	if (err < 0) {
-		dev_err(dc->dev, "output setup failed: %d\n", err);
-		return err;
+	drm_connector_init(drm, &output->connector, &tegra_rgb_connector_funcs,
+			   DRM_MODE_CONNECTOR_LVDS);
+	drm_connector_helper_add(&output->connector,
+				 &tegra_rgb_connector_helper_funcs);
+	output->connector.dpms = DRM_MODE_DPMS_OFF;
+
+	if (output->panel) {
+		err = drm_panel_attach(output->panel, &output->connector);
+		if (err < 0)
+			dev_err(output->dev, "failed to attach panel: %d\n",
+				err);
 	}
 
+	drm_encoder_init(drm, &output->encoder, &tegra_rgb_encoder_funcs,
+			 DRM_MODE_ENCODER_LVDS);
+	drm_encoder_helper_add(&output->encoder,
+			       &tegra_rgb_encoder_helper_funcs);
+
+	drm_mode_connector_attach_encoder(&output->connector,
+					  &output->encoder);
+	drm_connector_register(&output->connector);
+
 	/*
-	 * By default, outputs can be associated with each display controller.
-	 * RGB outputs are an exception, so we make sure they can be attached
-	 * to only their parent display controller.
+	 * Other outputs can be attached to either display controller. The RGB
+	 * outputs are an exception and work only with their parent display
+	 * controller.
 	 */
-	rgb->output.encoder.possible_crtcs = drm_crtc_mask(&dc->base);
+	output->encoder.possible_crtcs = drm_crtc_mask(&dc->base);
 
 	return 0;
 }
 
 int tegra_dc_rgb_exit(struct tegra_dc *dc)
 {
-	if (dc->rgb) {
-		int err;
-
-		err = tegra_output_disable(dc->rgb);
-		if (err < 0) {
-			dev_err(dc->dev, "output failed to disable: %d\n", err);
-			return err;
-		}
-
-		err = tegra_output_exit(dc->rgb);
-		if (err < 0) {
-			dev_err(dc->dev, "output cleanup failed: %d\n", err);
-			return err;
-		}
-
-		dc->rgb = NULL;
-	}
+	if (!dc->rgb)
+		return 0;
 
-	return 0;
+	return tegra_output_exit(dc->rgb);
 }
-- 
2.1.3

