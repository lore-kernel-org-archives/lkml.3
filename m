Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbbATK7B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:59:01 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:38262 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123AbbATKtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:49:31 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 19/36] drm/tegra: Remove remnants of the output midlayer
Date: Tue, 20 Jan 2015 11:48:38 +0100
Message-Id: <1421750935-4023-20-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
References: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

The tegra_output midlayer is now completely gone and output drivers use
it purely as a helper library.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/gpu/drm/tegra/dc.c     |  52 --------------------
 drivers/gpu/drm/tegra/drm.h    |  39 ---------------
 drivers/gpu/drm/tegra/dsi.c    |  12 +++--
 drivers/gpu/drm/tegra/hdmi.c   |   9 ++--
 drivers/gpu/drm/tegra/output.c | 107 +++--------------------------------------
 drivers/gpu/drm/tegra/rgb.c    |  13 +++--
 drivers/gpu/drm/tegra/sor.c    |  12 ++---
 7 files changed, 32 insertions(+), 212 deletions(-)

diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index c51fc4db73db..462945abded2 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -1077,52 +1077,6 @@ static int tegra_dc_set_timings(struct tegra_dc *dc,
 	return 0;
 }
 
-static int tegra_crtc_setup_clk(struct drm_crtc *crtc,
-				struct drm_display_mode *mode)
-{
-	unsigned long pclk = mode->clock * 1000;
-	struct tegra_dc *dc = to_tegra_dc(crtc);
-	struct tegra_output *output = NULL;
-	struct drm_encoder *encoder;
-	unsigned int div;
-	u32 value;
-	long err;
-
-	list_for_each_entry(encoder, &crtc->dev->mode_config.encoder_list, head)
-		if (encoder->crtc == crtc) {
-			output = encoder_to_output(encoder);
-			break;
-		}
-
-	if (!output)
-		return -ENODEV;
-
-	/*
-	 * The ->setup_clock() callback is optional, but if encoders don't
-	 * implement it they most likely need to do the equivalent within the
-	 * ->mode_fixup() callback.
-	 */
-	if (!output->ops || !output->ops->setup_clock)
-		return 0;
-
-	/*
-	 * This assumes that the parent clock is pll_d_out0 or pll_d2_out
-	 * respectively, each of which divides the base pll_d by 2.
-	 */
-	err = output->ops->setup_clock(output, dc->clk, pclk, &div);
-	if (err < 0) {
-		dev_err(dc->dev, "failed to setup clock: %ld\n", err);
-		return err;
-	}
-
-	DRM_DEBUG_KMS("rate: %lu, div: %u\n", clk_get_rate(dc->clk), div);
-
-	value = SHIFT_CLK_DIVIDER(div) | PIXEL_CLK_DIVIDER_PCD1;
-	tegra_dc_writel(dc, value, DC_DISP_DISP_CLOCK_CONTROL);
-
-	return 0;
-}
-
 int tegra_dc_setup_clock(struct tegra_dc *dc, struct clk *parent,
 			 unsigned long pclk, unsigned int div)
 {
@@ -1154,12 +1108,6 @@ static int tegra_crtc_mode_set(struct drm_crtc *crtc,
 	u32 value;
 	int err;
 
-	err = tegra_crtc_setup_clk(crtc, mode);
-	if (err) {
-		dev_err(dc->dev, "failed to setup clock for CRTC: %d\n", err);
-		return err;
-	}
-
 	/* program display mode */
 	tegra_dc_set_timings(dc, mode);
 
diff --git a/drivers/gpu/drm/tegra/drm.h b/drivers/gpu/drm/tegra/drm.h
index c74d5db47537..699211a89a2e 100644
--- a/drivers/gpu/drm/tegra/drm.h
+++ b/drivers/gpu/drm/tegra/drm.h
@@ -181,23 +181,10 @@ void tegra_dc_commit(struct tegra_dc *dc);
 int tegra_dc_setup_clock(struct tegra_dc *dc, struct clk *parent,
 			 unsigned long pclk, unsigned int div);
 
-struct tegra_output_ops {
-	int (*enable)(struct tegra_output *output);
-	int (*disable)(struct tegra_output *output);
-	int (*setup_clock)(struct tegra_output *output, struct clk *clk,
-			   unsigned long pclk, unsigned int *div);
-	int (*check_mode)(struct tegra_output *output,
-			  struct drm_display_mode *mode,
-			  enum drm_mode_status *status);
-	enum drm_connector_status (*detect)(struct tegra_output *output);
-};
-
 struct tegra_output {
 	struct device_node *of_node;
 	struct device *dev;
 
-	const struct tegra_output_ops *ops;
-
 	struct drm_panel *panel;
 	struct i2c_adapter *ddc;
 	const struct edid *edid;
@@ -218,32 +205,6 @@ static inline struct tegra_output *connector_to_output(struct drm_connector *c)
 	return container_of(c, struct tegra_output, connector);
 }
 
-static inline int tegra_output_enable(struct tegra_output *output)
-{
-	if (output && output->ops && output->ops->enable)
-		return output->ops->enable(output);
-
-	return output ? -ENOSYS : -EINVAL;
-}
-
-static inline int tegra_output_disable(struct tegra_output *output)
-{
-	if (output && output->ops && output->ops->disable)
-		return output->ops->disable(output);
-
-	return output ? -ENOSYS : -EINVAL;
-}
-
-static inline int tegra_output_check_mode(struct tegra_output *output,
-					  struct drm_display_mode *mode,
-					  enum drm_mode_status *status)
-{
-	if (output && output->ops && output->ops->check_mode)
-		return output->ops->check_mode(output, mode, status);
-
-	return output ? -ENOSYS : -EINVAL;
-}
-
 /* from rgb.c */
 int tegra_dc_rgb_probe(struct tegra_dc *dc);
 int tegra_dc_rgb_remove(struct tegra_dc *dc);
diff --git a/drivers/gpu/drm/tegra/dsi.c b/drivers/gpu/drm/tegra/dsi.c
index 4cdfd471aef7..8568e1b44397 100644
--- a/drivers/gpu/drm/tegra/dsi.c
+++ b/drivers/gpu/drm/tegra/dsi.c
@@ -990,10 +990,6 @@ static int tegra_dsi_init(struct host1x_client *client)
 					 &tegra_dsi_connector_helper_funcs);
 		dsi->output.connector.dpms = DRM_MODE_DPMS_OFF;
 
-		if (dsi->output.panel)
-			drm_panel_attach(dsi->output.panel,
-					 &dsi->output.connector);
-
 		drm_encoder_init(drm, &dsi->output.encoder,
 				 &tegra_dsi_encoder_funcs,
 				 DRM_MODE_ENCODER_DSI);
@@ -1004,6 +1000,14 @@ static int tegra_dsi_init(struct host1x_client *client)
 						  &dsi->output.encoder);
 		drm_connector_register(&dsi->output.connector);
 
+		err = tegra_output_init(drm, &dsi->output);
+		if (err < 0) {
+			dev_err(client->dev,
+				"failed to initialize output: %d\n",
+				err);
+			goto reset;
+		}
+
 		dsi->output.encoder.possible_crtcs = 0x3;
 	}
 
diff --git a/drivers/gpu/drm/tegra/hdmi.c b/drivers/gpu/drm/tegra/hdmi.c
index b4fe90949f27..03ceb50b1dc9 100644
--- a/drivers/gpu/drm/tegra/hdmi.c
+++ b/drivers/gpu/drm/tegra/hdmi.c
@@ -1347,10 +1347,13 @@ static int tegra_hdmi_init(struct host1x_client *client)
 					  &hdmi->output.encoder);
 	drm_connector_register(&hdmi->output.connector);
 
-	hdmi->output.encoder.possible_crtcs = 0x3;
+	err = tegra_output_init(drm, &hdmi->output);
+	if (err < 0) {
+		dev_err(client->dev, "failed to initialize output: %d\n", err);
+		return err;
+	}
 
-	if (gpio_is_valid(hdmi->output.hpd_gpio))
-		enable_irq(hdmi->output.hpd_irq);
+	hdmi->output.encoder.possible_crtcs = 0x3;
 
 	if (IS_ENABLED(CONFIG_DEBUG_FS)) {
 		err = tegra_hdmi_debugfs_init(hdmi, drm->primary);
diff --git a/drivers/gpu/drm/tegra/output.c b/drivers/gpu/drm/tegra/output.c
index 042b421416a8..c6d70d774494 100644
--- a/drivers/gpu/drm/tegra/output.c
+++ b/drivers/gpu/drm/tegra/output.c
@@ -43,20 +43,6 @@ int tegra_output_connector_get_modes(struct drm_connector *connector)
 	return err;
 }
 
-static int tegra_connector_mode_valid(struct drm_connector *connector,
-				      struct drm_display_mode *mode)
-{
-	struct tegra_output *output = connector_to_output(connector);
-	enum drm_mode_status status = MODE_OK;
-	int err;
-
-	err = tegra_output_check_mode(output, mode, &status);
-	if (err < 0)
-		return MODE_ERROR;
-
-	return status;
-}
-
 struct drm_encoder *
 tegra_output_connector_best_encoder(struct drm_connector *connector)
 {
@@ -65,21 +51,12 @@ tegra_output_connector_best_encoder(struct drm_connector *connector)
 	return &output->encoder;
 }
 
-static const struct drm_connector_helper_funcs connector_helper_funcs = {
-	.get_modes = tegra_output_connector_get_modes,
-	.mode_valid = tegra_connector_mode_valid,
-	.best_encoder = tegra_output_connector_best_encoder,
-};
-
 enum drm_connector_status
 tegra_output_connector_detect(struct drm_connector *connector, bool force)
 {
 	struct tegra_output *output = connector_to_output(connector);
 	enum drm_connector_status status = connector_status_unknown;
 
-	if (output->ops->detect)
-		return output->ops->detect(output);
-
 	if (gpio_is_valid(output->hpd_gpio)) {
 		if (gpio_get_value(output->hpd_gpio) == 0)
 			status = connector_status_disconnected;
@@ -90,9 +67,6 @@ tegra_output_connector_detect(struct drm_connector *connector, bool force)
 			status = connector_status_disconnected;
 		else
 			status = connector_status_connected;
-
-		if (connector->connector_type == DRM_MODE_CONNECTOR_LVDS)
-			status = connector_status_connected;
 	}
 
 	return status;
@@ -104,69 +78,11 @@ void tegra_output_connector_destroy(struct drm_connector *connector)
 	drm_connector_cleanup(connector);
 }
 
-static const struct drm_connector_funcs connector_funcs = {
-	.dpms = drm_helper_connector_dpms,
-	.detect = tegra_output_connector_detect,
-	.fill_modes = drm_helper_probe_single_connector_modes,
-	.destroy = tegra_output_connector_destroy,
-};
-
 void tegra_output_encoder_destroy(struct drm_encoder *encoder)
 {
 	drm_encoder_cleanup(encoder);
 }
 
-static const struct drm_encoder_funcs encoder_funcs = {
-	.destroy = tegra_output_encoder_destroy,
-};
-
-static void tegra_encoder_dpms(struct drm_encoder *encoder, int mode)
-{
-	struct tegra_output *output = encoder_to_output(encoder);
-	struct drm_panel *panel = output->panel;
-
-	if (mode != DRM_MODE_DPMS_ON) {
-		drm_panel_disable(panel);
-		tegra_output_disable(output);
-		drm_panel_unprepare(panel);
-	} else {
-		drm_panel_prepare(panel);
-		tegra_output_enable(output);
-		drm_panel_enable(panel);
-	}
-}
-
-static bool tegra_encoder_mode_fixup(struct drm_encoder *encoder,
-				     const struct drm_display_mode *mode,
-				     struct drm_display_mode *adjusted)
-{
-	return true;
-}
-
-static void tegra_encoder_prepare(struct drm_encoder *encoder)
-{
-	tegra_encoder_dpms(encoder, DRM_MODE_DPMS_OFF);
-}
-
-static void tegra_encoder_commit(struct drm_encoder *encoder)
-{
-	tegra_encoder_dpms(encoder, DRM_MODE_DPMS_ON);
-}
-
-static void tegra_encoder_mode_set(struct drm_encoder *encoder,
-				   struct drm_display_mode *mode,
-				   struct drm_display_mode *adjusted)
-{
-}
-
-static const struct drm_encoder_helper_funcs encoder_helper_funcs = {
-	.dpms = tegra_encoder_dpms,
-	.mode_fixup = tegra_encoder_mode_fixup,
-	.prepare = tegra_encoder_prepare,
-	.commit = tegra_encoder_commit,
-	.mode_set = tegra_encoder_mode_set,
-};
-
 static irqreturn_t hpd_irq(int irq, void *data)
 {
 	struct tegra_output *output = data;
@@ -273,24 +189,13 @@ int tegra_output_remove(struct tegra_output *output)
 
 int tegra_output_init(struct drm_device *drm, struct tegra_output *output)
 {
-	int connector = DRM_MODE_CONNECTOR_Unknown;
-	int encoder = DRM_MODE_ENCODER_NONE;
-
-	drm_connector_init(drm, &output->connector, &connector_funcs,
-			   connector);
-	drm_connector_helper_add(&output->connector, &connector_helper_funcs);
-	output->connector.dpms = DRM_MODE_DPMS_OFF;
-
-	if (output->panel)
-		drm_panel_attach(output->panel, &output->connector);
-
-	drm_encoder_init(drm, &output->encoder, &encoder_funcs, encoder);
-	drm_encoder_helper_add(&output->encoder, &encoder_helper_funcs);
-
-	drm_mode_connector_attach_encoder(&output->connector, &output->encoder);
-	drm_connector_register(&output->connector);
+	int err;
 
-	output->encoder.possible_crtcs = 0x3;
+	if (output->panel) {
+		err = drm_panel_attach(output->panel, &output->connector);
+		if (err < 0)
+			return err;
+	}
 
 	/*
 	 * The connector is now registered and ready to receive hotplug events
diff --git a/drivers/gpu/drm/tegra/rgb.c b/drivers/gpu/drm/tegra/rgb.c
index 30d7ae02ace8..ab6093889be8 100644
--- a/drivers/gpu/drm/tegra/rgb.c
+++ b/drivers/gpu/drm/tegra/rgb.c
@@ -315,13 +315,6 @@ int tegra_dc_rgb_init(struct drm_device *drm, struct tegra_dc *dc)
 				 &tegra_rgb_connector_helper_funcs);
 	output->connector.dpms = DRM_MODE_DPMS_OFF;
 
-	if (output->panel) {
-		err = drm_panel_attach(output->panel, &output->connector);
-		if (err < 0)
-			dev_err(output->dev, "failed to attach panel: %d\n",
-				err);
-	}
-
 	drm_encoder_init(drm, &output->encoder, &tegra_rgb_encoder_funcs,
 			 DRM_MODE_ENCODER_LVDS);
 	drm_encoder_helper_add(&output->encoder,
@@ -331,6 +324,12 @@ int tegra_dc_rgb_init(struct drm_device *drm, struct tegra_dc *dc)
 					  &output->encoder);
 	drm_connector_register(&output->connector);
 
+	err = tegra_output_init(drm, output);
+	if (err < 0) {
+		dev_err(output->dev, "failed to initialize output: %d\n", err);
+		return err;
+	}
+
 	/*
 	 * Other outputs can be attached to either display controller. The RGB
 	 * outputs are an exception and work only with their parent display
diff --git a/drivers/gpu/drm/tegra/sor.c b/drivers/gpu/drm/tegra/sor.c
index a1c16c5c0cf6..ee18adf7f653 100644
--- a/drivers/gpu/drm/tegra/sor.c
+++ b/drivers/gpu/drm/tegra/sor.c
@@ -1343,9 +1343,6 @@ static int tegra_sor_init(struct host1x_client *client)
 				 &tegra_sor_connector_helper_funcs);
 	sor->output.connector.dpms = DRM_MODE_DPMS_OFF;
 
-	if (sor->output.panel)
-		drm_panel_attach(sor->output.panel, &sor->output.connector);
-
 	drm_encoder_init(drm, &sor->output.encoder, &tegra_sor_encoder_funcs,
 			 DRM_MODE_ENCODER_TMDS);
 	drm_encoder_helper_add(&sor->output.encoder,
@@ -1355,10 +1352,13 @@ static int tegra_sor_init(struct host1x_client *client)
 					  &sor->output.encoder);
 	drm_connector_register(&sor->output.connector);
 
-	sor->output.encoder.possible_crtcs = 0x3;
+	err = tegra_output_init(drm, &sor->output);
+	if (err < 0) {
+		dev_err(client->dev, "failed to initialize output: %d\n", err);
+		return err;
+	}
 
-	if (gpio_is_valid(sor->output.hpd_gpio))
-		enable_irq(sor->output.hpd_irq);
+	sor->output.encoder.possible_crtcs = 0x3;
 
 	if (IS_ENABLED(CONFIG_DEBUG_FS)) {
 		err = tegra_sor_debugfs_init(sor, drm->primary);
-- 
2.1.3

