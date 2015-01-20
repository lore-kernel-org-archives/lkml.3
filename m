Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbbATLAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:00:23 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:37243 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbbATKtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:49:24 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 15/36] drm/tegra: hdmi: Demidlayer
Date: Tue, 20 Jan 2015 11:48:34 +0100
Message-Id: <1421750935-4023-16-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
References: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Implement encoder and connector within the HDMI driver itself using the
Tegra output helpers rather than using the Tegra output as midlayer. By
doing so one level of indirection is removed and output drivers become
more flexible while keeping the majority of the advantages provided by
the common output helpers.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/gpu/drm/tegra/drm.h    |   1 -
 drivers/gpu/drm/tegra/hdmi.c   | 280 +++++++++++++++++++++--------------------
 drivers/gpu/drm/tegra/output.c |   5 -
 3 files changed, 147 insertions(+), 139 deletions(-)

diff --git a/drivers/gpu/drm/tegra/drm.h b/drivers/gpu/drm/tegra/drm.h
index dbc1f83327ea..95b6aebfaf00 100644
--- a/drivers/gpu/drm/tegra/drm.h
+++ b/drivers/gpu/drm/tegra/drm.h
@@ -193,7 +193,6 @@ struct tegra_output_ops {
 };
 
 enum tegra_output_type {
-	TEGRA_OUTPUT_HDMI,
 	TEGRA_OUTPUT_DSI,
 	TEGRA_OUTPUT_EDP,
 };
diff --git a/drivers/gpu/drm/tegra/hdmi.c b/drivers/gpu/drm/tegra/hdmi.c
index d4c635148cc7..056bb2c1c426 100644
--- a/drivers/gpu/drm/tegra/hdmi.c
+++ b/drivers/gpu/drm/tegra/hdmi.c
@@ -9,10 +9,14 @@
 
 #include <linux/clk.h>
 #include <linux/debugfs.h>
+#include <linux/gpio.h>
 #include <linux/hdmi.h>
 #include <linux/regulator/consumer.h>
 #include <linux/reset.h>
 
+#include <drm/drm_crtc.h>
+#include <drm/drm_crtc_helper.h>
+
 #include "hdmi.h"
 #include "drm.h"
 #include "dc.h"
@@ -40,7 +44,6 @@ struct tegra_hdmi {
 	struct host1x_client client;
 	struct tegra_output output;
 	struct device *dev;
-	bool enabled;
 
 	struct regulator *hdmi;
 	struct regulator *pll;
@@ -768,53 +771,107 @@ static bool tegra_output_is_hdmi(struct tegra_output *output)
 	return drm_detect_hdmi_monitor(edid);
 }
 
-static int tegra_output_hdmi_enable(struct tegra_output *output)
+static void tegra_hdmi_connector_dpms(struct drm_connector *connector,
+				      int mode)
 {
-	unsigned int h_sync_width, h_front_porch, h_back_porch, i, rekey;
-	struct tegra_dc *dc = to_tegra_dc(output->encoder.crtc);
-	struct drm_display_mode *mode = &dc->base.mode;
+}
+
+static const struct drm_connector_funcs tegra_hdmi_connector_funcs = {
+	.dpms = tegra_hdmi_connector_dpms,
+	.detect = tegra_output_connector_detect,
+	.fill_modes = drm_helper_probe_single_connector_modes,
+	.destroy = tegra_output_connector_destroy,
+};
+
+static enum drm_mode_status
+tegra_hdmi_connector_mode_valid(struct drm_connector *connector,
+				struct drm_display_mode *mode)
+{
+	struct tegra_output *output = connector_to_output(connector);
 	struct tegra_hdmi *hdmi = to_hdmi(output);
-	struct device_node *node = hdmi->dev->of_node;
-	unsigned int pulse_start, div82, pclk;
-	int retries = 1000;
-	u32 value;
-	int err;
+	unsigned long pclk = mode->clock * 1000;
+	enum drm_mode_status status = MODE_OK;
+	struct clk *parent;
+	long err;
 
-	if (hdmi->enabled)
-		return 0;
+	parent = clk_get_parent(hdmi->clk_parent);
 
-	hdmi->dvi = !tegra_output_is_hdmi(output);
+	err = clk_round_rate(parent, pclk * 4);
+	if (err <= 0)
+		status = MODE_NOCLOCK;
 
-	pclk = mode->clock * 1000;
-	h_sync_width = mode->hsync_end - mode->hsync_start;
-	h_back_porch = mode->htotal - mode->hsync_end;
-	h_front_porch = mode->hsync_start - mode->hdisplay;
+	return status;
+}
 
-	err = regulator_enable(hdmi->pll);
+static const struct drm_connector_helper_funcs
+tegra_hdmi_connector_helper_funcs = {
+	.get_modes = tegra_output_connector_get_modes,
+	.mode_valid = tegra_hdmi_connector_mode_valid,
+	.best_encoder = tegra_output_connector_best_encoder,
+};
+
+static const struct drm_encoder_funcs tegra_hdmi_encoder_funcs = {
+	.destroy = tegra_output_encoder_destroy,
+};
+
+static void tegra_hdmi_encoder_dpms(struct drm_encoder *encoder, int mode)
+{
+}
+
+static bool tegra_hdmi_encoder_mode_fixup(struct drm_encoder *encoder,
+					  const struct drm_display_mode *mode,
+					  struct drm_display_mode *adjusted)
+{
+	struct tegra_output *output = encoder_to_output(encoder);
+	struct tegra_dc *dc = to_tegra_dc(encoder->crtc);
+	struct tegra_hdmi *hdmi = to_hdmi(output);
+	unsigned long pclk = mode->clock * 1000;
+	int err;
+
+	err = tegra_dc_setup_clock(dc, hdmi->clk_parent, pclk, 0);
 	if (err < 0) {
-		dev_err(hdmi->dev, "failed to enable PLL regulator: %d\n", err);
-		return err;
+		dev_err(output->dev, "failed to setup DC clock: %d\n", err);
+		return false;
 	}
 
-	err = regulator_enable(hdmi->vdd);
+	err = clk_set_rate(hdmi->clk_parent, pclk);
 	if (err < 0) {
-		dev_err(hdmi->dev, "failed to enable VDD regulator: %d\n", err);
-		return err;
+		dev_err(output->dev, "failed to set clock rate to %lu Hz\n",
+			pclk);
+		return false;
 	}
 
-	err = clk_set_rate(hdmi->clk, pclk);
-	if (err < 0)
-		return err;
+	return true;
+}
 
-	err = clk_prepare_enable(hdmi->clk);
-	if (err < 0) {
-		dev_err(hdmi->dev, "failed to enable clock: %d\n", err);
-		return err;
-	}
+static void tegra_hdmi_encoder_prepare(struct drm_encoder *encoder)
+{
+}
 
-	reset_control_assert(hdmi->rst);
-	usleep_range(1000, 2000);
-	reset_control_deassert(hdmi->rst);
+static void tegra_hdmi_encoder_commit(struct drm_encoder *encoder)
+{
+}
+
+static void tegra_hdmi_encoder_mode_set(struct drm_encoder *encoder,
+					struct drm_display_mode *mode,
+					struct drm_display_mode *adjusted)
+{
+	unsigned int h_sync_width, h_front_porch, h_back_porch, i, rekey;
+	struct tegra_output *output = encoder_to_output(encoder);
+	struct tegra_dc *dc = to_tegra_dc(encoder->crtc);
+	struct device_node *node = output->dev->of_node;
+	struct tegra_hdmi *hdmi = to_hdmi(output);
+	unsigned int pulse_start, div82, pclk;
+	int retries = 1000;
+	u32 value;
+	int err;
+
+	hdmi->dvi = !tegra_output_is_hdmi(output);
+
+	pclk = mode->clock * 1000;
+	h_sync_width = mode->hsync_end - mode->hsync_start;
+	h_back_porch = mode->htotal - mode->hsync_end;
+	h_front_porch = mode->hsync_start - mode->hdisplay;
 
 	/* power up sequence */
 	value = tegra_hdmi_readl(hdmi, HDMI_NV_PDISP_SOR_PLL0);
@@ -1000,104 +1057,33 @@ static int tegra_output_hdmi_enable(struct tegra_output *output)
 	tegra_dc_commit(dc);
 
 	/* TODO: add HDCP support */
-
-	hdmi->enabled = true;
-
-	return 0;
 }
 
-static int tegra_output_hdmi_disable(struct tegra_output *output)
+static void tegra_hdmi_encoder_disable(struct drm_encoder *encoder)
 {
-	struct tegra_dc *dc = to_tegra_dc(output->encoder.crtc);
-	struct tegra_hdmi *hdmi = to_hdmi(output);
+	struct tegra_dc *dc = to_tegra_dc(encoder->crtc);
 	u32 value;
 
-	if (!hdmi->enabled)
-		return 0;
-
 	/*
 	 * The following accesses registers of the display controller, so make
 	 * sure it's only executed when the output is attached to one.
 	 */
 	if (dc) {
-		/*
-		 * XXX: We can't do this here because it causes HDMI to go
-		 * into an erroneous state with the result that HDMI won't
-		 * properly work once disabled. See also a similar symptom
-		 * for the SOR output.
-		 */
-		/*
-		value = tegra_dc_readl(dc, DC_CMD_DISPLAY_POWER_CONTROL);
-		value &= ~(PW0_ENABLE | PW1_ENABLE | PW2_ENABLE | PW3_ENABLE |
-			   PW4_ENABLE | PM0_ENABLE | PM1_ENABLE);
-		tegra_dc_writel(dc, value, DC_CMD_DISPLAY_POWER_CONTROL);
-		*/
-
 		value = tegra_dc_readl(dc, DC_DISP_DISP_WIN_OPTIONS);
 		value &= ~HDMI_ENABLE;
 		tegra_dc_writel(dc, value, DC_DISP_DISP_WIN_OPTIONS);
 
 		tegra_dc_commit(dc);
 	}
-
-	clk_disable_unprepare(hdmi->clk);
-	reset_control_assert(hdmi->rst);
-	regulator_disable(hdmi->vdd);
-	regulator_disable(hdmi->pll);
-
-	hdmi->enabled = false;
-
-	return 0;
-}
-
-static int tegra_output_hdmi_setup_clock(struct tegra_output *output,
-					 struct clk *clk, unsigned long pclk,
-					 unsigned int *div)
-{
-	struct tegra_hdmi *hdmi = to_hdmi(output);
-	int err;
-
-	err = clk_set_parent(clk, hdmi->clk_parent);
-	if (err < 0) {
-		dev_err(output->dev, "failed to set parent: %d\n", err);
-		return err;
-	}
-
-	err = clk_set_rate(hdmi->clk_parent, pclk);
-	if (err < 0)
-		dev_err(output->dev, "failed to set clock rate to %lu Hz\n",
-			pclk);
-
-	*div = 0;
-
-	return 0;
-}
-
-static int tegra_output_hdmi_check_mode(struct tegra_output *output,
-					struct drm_display_mode *mode,
-					enum drm_mode_status *status)
-{
-	struct tegra_hdmi *hdmi = to_hdmi(output);
-	unsigned long pclk = mode->clock * 1000;
-	struct clk *parent;
-	long err;
-
-	parent = clk_get_parent(hdmi->clk_parent);
-
-	err = clk_round_rate(parent, pclk * 4);
-	if (err <= 0)
-		*status = MODE_NOCLOCK;
-	else
-		*status = MODE_OK;
-
-	return 0;
 }
 
-static const struct tegra_output_ops hdmi_ops = {
-	.enable = tegra_output_hdmi_enable,
-	.disable = tegra_output_hdmi_disable,
-	.setup_clock = tegra_output_hdmi_setup_clock,
-	.check_mode = tegra_output_hdmi_check_mode,
+static const struct drm_encoder_helper_funcs tegra_hdmi_encoder_helper_funcs = {
+	.dpms = tegra_hdmi_encoder_dpms,
+	.mode_fixup = tegra_hdmi_encoder_mode_fixup,
+	.prepare = tegra_hdmi_encoder_prepare,
+	.commit = tegra_hdmi_encoder_commit,
+	.mode_set = tegra_hdmi_encoder_mode_set,
+	.disable = tegra_hdmi_encoder_disable,
 };
 
 static int tegra_hdmi_show_regs(struct seq_file *s, void *data)
@@ -1345,15 +1331,28 @@ static int tegra_hdmi_init(struct host1x_client *client)
 	struct tegra_hdmi *hdmi = host1x_client_to_hdmi(client);
 	int err;
 
-	hdmi->output.type = TEGRA_OUTPUT_HDMI;
 	hdmi->output.dev = client->dev;
-	hdmi->output.ops = &hdmi_ops;
 
-	err = tegra_output_init(drm, &hdmi->output);
-	if (err < 0) {
-		dev_err(client->dev, "output setup failed: %d\n", err);
-		return err;
-	}
+	drm_connector_init(drm, &hdmi->output.connector,
+			   &tegra_hdmi_connector_funcs,
+			   DRM_MODE_CONNECTOR_HDMIA);
+	drm_connector_helper_add(&hdmi->output.connector,
+				 &tegra_hdmi_connector_helper_funcs);
+	hdmi->output.connector.dpms = DRM_MODE_DPMS_OFF;
+
+	drm_encoder_init(drm, &hdmi->output.encoder, &tegra_hdmi_encoder_funcs,
+			 DRM_MODE_ENCODER_TMDS);
+	drm_encoder_helper_add(&hdmi->output.encoder,
+			       &tegra_hdmi_encoder_helper_funcs);
+
+	drm_mode_connector_attach_encoder(&hdmi->output.connector,
+					  &hdmi->output.encoder);
+	drm_connector_register(&hdmi->output.connector);
+
+	hdmi->output.encoder.possible_crtcs = 0x3;
+
+	if (gpio_is_valid(hdmi->output.hpd_gpio))
+		enable_irq(hdmi->output.hpd_irq);
 
 	if (IS_ENABLED(CONFIG_DEBUG_FS)) {
 		err = tegra_hdmi_debugfs_init(hdmi, drm->primary);
@@ -1368,6 +1367,26 @@ static int tegra_hdmi_init(struct host1x_client *client)
 		return err;
 	}
 
+	err = regulator_enable(hdmi->pll);
+	if (err < 0) {
+		dev_err(hdmi->dev, "failed to enable PLL regulator: %d\n", err);
+		return err;
+	}
+
+	err = regulator_enable(hdmi->vdd);
+	if (err < 0) {
+		dev_err(hdmi->dev, "failed to enable VDD regulator: %d\n", err);
+		return err;
+	}
+
+	err = clk_prepare_enable(hdmi->clk);
+	if (err < 0) {
+		dev_err(hdmi->dev, "failed to enable clock: %d\n", err);
+		return err;
+	}
+
+	reset_control_deassert(hdmi->rst);
+
 	return 0;
 }
 
@@ -1376,6 +1395,13 @@ static int tegra_hdmi_exit(struct host1x_client *client)
 	struct tegra_hdmi *hdmi = host1x_client_to_hdmi(client);
 	int err;
 
+	tegra_output_exit(&hdmi->output);
+
+	clk_disable_unprepare(hdmi->clk);
+	reset_control_assert(hdmi->rst);
+
+	regulator_disable(hdmi->vdd);
+	regulator_disable(hdmi->pll);
 	regulator_disable(hdmi->hdmi);
 
 	if (IS_ENABLED(CONFIG_DEBUG_FS)) {
@@ -1385,18 +1411,6 @@ static int tegra_hdmi_exit(struct host1x_client *client)
 				err);
 	}
 
-	err = tegra_output_disable(&hdmi->output);
-	if (err < 0) {
-		dev_err(client->dev, "output failed to disable: %d\n", err);
-		return err;
-	}
-
-	err = tegra_output_exit(&hdmi->output);
-	if (err < 0) {
-		dev_err(client->dev, "output cleanup failed: %d\n", err);
-		return err;
-	}
-
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/tegra/output.c b/drivers/gpu/drm/tegra/output.c
index 9dd3c34d47fe..9cf851bf414b 100644
--- a/drivers/gpu/drm/tegra/output.c
+++ b/drivers/gpu/drm/tegra/output.c
@@ -276,11 +276,6 @@ int tegra_output_init(struct drm_device *drm, struct tegra_output *output)
 	int connector, encoder;
 
 	switch (output->type) {
-	case TEGRA_OUTPUT_HDMI:
-		connector = DRM_MODE_CONNECTOR_HDMIA;
-		encoder = DRM_MODE_ENCODER_TMDS;
-		break;
-
 	case TEGRA_OUTPUT_DSI:
 		connector = DRM_MODE_CONNECTOR_DSI;
 		encoder = DRM_MODE_ENCODER_DSI;
-- 
2.1.3

