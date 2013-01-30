Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab3A3DDD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 22:03:03 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13672 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab3A3DCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 22:02:55 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 29 Jan 2013 19:02:27 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Stephen Warren <swarren@wwwdotorg.org>, Mark Zhang <markz@nvidia.com>
CC: <linux-kernel@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [RFC 3/4] drm: tegra: use the Common Display Framework
Date: Wed, 30 Jan 2013 12:02:18 +0900
Message-ID: <1359514939-15653-4-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1359514939-15653-1-git-send-email-acourbot@nvidia.com>
References: <1359514939-15653-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the tegra-drm driver use the Common Display Framework, letting it
control the panel state according to the DPMS status.

A "nvidia,panel" property is added to the output node of the Tegra DC
that references the panel connected to a given output.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 .../bindings/gpu/nvidia,tegra20-host1x.txt         |   2 +
 drivers/gpu/drm/tegra/drm.h                        |  16 +++
 drivers/gpu/drm/tegra/output.c                     | 118 ++++++++++++++++++++-
 3 files changed, 134 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/gpu/nvidia,tegra20-host1x.txt b/Documentation/devicetree/bindings/gpu/nvidia,tegra20-host1x.txt
index b4fa934..9c65e8e 100644
--- a/Documentation/devicetree/bindings/gpu/nvidia,tegra20-host1x.txt
+++ b/Documentation/devicetree/bindings/gpu/nvidia,tegra20-host1x.txt
@@ -67,6 +67,7 @@ of the following host1x client modules:
   - nvidia,ddc-i2c-bus: phandle of an I2C controller used for DDC EDID probing
   - nvidia,hpd-gpio: specifies a GPIO used for hotplug detection
   - nvidia,edid: supplies a binary EDID blob
+  - nvidia,panel: phandle of a display entity connected to this output
 
 - hdmi: High Definition Multimedia Interface
 
@@ -81,6 +82,7 @@ of the following host1x client modules:
   - nvidia,ddc-i2c-bus: phandle of an I2C controller used for DDC EDID probing
   - nvidia,hpd-gpio: specifies a GPIO used for hotplug detection
   - nvidia,edid: supplies a binary EDID blob
+  - nvidia,panel: phandle of a display entity connected to this output
 
 - tvo: TV encoder output
 
diff --git a/drivers/gpu/drm/tegra/drm.h b/drivers/gpu/drm/tegra/drm.h
index 741b5dc..5e63c56 100644
--- a/drivers/gpu/drm/tegra/drm.h
+++ b/drivers/gpu/drm/tegra/drm.h
@@ -17,6 +17,7 @@
 #include <drm/drm_gem_cma_helper.h>
 #include <drm/drm_fb_cma_helper.h>
 #include <drm/drm_fixed.h>
+#include <video/display.h>
 
 struct tegra_framebuffer {
 	struct drm_framebuffer base;
@@ -147,6 +148,9 @@ struct tegra_output {
 
 	struct drm_encoder encoder;
 	struct drm_connector connector;
+	struct display_entity this;
+	struct display_entity *output;
+	struct display_entity_notifier display_notifier;
 };
 
 static inline struct tegra_output *encoder_to_output(struct drm_encoder *e)
@@ -159,6 +163,18 @@ static inline struct tegra_output *connector_to_output(struct drm_connector *c)
 	return container_of(c, struct tegra_output, connector);
 }
 
+static inline
+struct tegra_output *display_entity_to_output(struct display_entity *e)
+{
+	return container_of(e, struct tegra_output, this);
+}
+
+static inline struct tegra_output *
+display_notifier_to_output(struct display_entity_notifier *n)
+{
+	return container_of(n, struct tegra_output, display_notifier);
+}
+
 static inline int tegra_output_enable(struct tegra_output *output)
 {
 	if (output && output->ops && output->ops->enable)
diff --git a/drivers/gpu/drm/tegra/output.c b/drivers/gpu/drm/tegra/output.c
index 8140fc6..d5bf37a 100644
--- a/drivers/gpu/drm/tegra/output.c
+++ b/drivers/gpu/drm/tegra/output.c
@@ -105,6 +105,29 @@ static const struct drm_encoder_funcs encoder_funcs = {
 
 static void tegra_encoder_dpms(struct drm_encoder *encoder, int mode)
 {
+	struct tegra_output *output = encoder_to_output(encoder);
+	enum display_entity_state state;
+
+	if (!output->output)
+		return;
+
+	switch (mode) {
+	case DRM_MODE_DPMS_ON:
+		state = DISPLAY_ENTITY_STATE_ON;
+		break;
+	case DRM_MODE_DPMS_STANDBY:
+	case DRM_MODE_DPMS_SUSPEND:
+		state = DISPLAY_ENTITY_STATE_STANDBY;
+		break;
+	case DRM_MODE_DPMS_OFF:
+		state = DISPLAY_ENTITY_STATE_OFF;
+		break;
+	default:
+		dev_warn(output->dev, "unknown DPMS state, ignoring\n");
+		return;
+	}
+
+	display_entity_set_state(output->output, state);
 }
 
 static bool tegra_encoder_mode_fixup(struct drm_encoder *encoder,
@@ -129,9 +152,14 @@ static void tegra_encoder_mode_set(struct drm_encoder *encoder,
 	struct tegra_output *output = encoder_to_output(encoder);
 	int err;
 
-	err = tegra_output_enable(output);
+	if (output->output)
+		err = display_entity_set_state(output->output,
+					       DISPLAY_ENTITY_STATE_ON);
+	else
+		err = tegra_output_enable(output);
+
 	if (err < 0)
-		dev_err(encoder->dev->dev, "tegra_output_enable(): %d\n", err);
+		dev_err(encoder->dev->dev, "cannot enable output: %d\n", err);
 }
 
 static const struct drm_encoder_helper_funcs encoder_helper_funcs = {
@@ -185,6 +213,69 @@ int tegra_output_parse_dt(struct tegra_output *output)
 	return 0;
 }
 
+static int display_notify_callback(struct display_entity_notifier *notifier,
+				   struct display_entity *entity, int event)
+{
+	struct tegra_output *output = display_notifier_to_output(notifier);
+	struct device_node *pnode;
+
+	switch (event) {
+	case DISPLAY_ENTITY_NOTIFIER_CONNECT:
+		if (output->output)
+			break;
+
+		pnode = of_parse_phandle(output->of_node, "nvidia,panel", 0);
+		if (!pnode)
+			break;
+
+		if (entity->dev && entity->dev->of_node == pnode) {
+			dev_dbg(output->dev, "connecting panel\n");
+			output->output = display_entity_get(entity);
+			display_entity_connect(&output->this, output->output);
+		}
+		of_node_put(pnode);
+
+		break;
+
+	case DISPLAY_ENTITY_NOTIFIER_DISCONNECT:
+		if (!output->output || output->output != entity)
+			break;
+
+		dev_dbg(output->dev, "disconnecting panel\n");
+		display_entity_disconnect(&output->this, output->output);
+		output->output = NULL;
+		display_entity_put(&output->this);
+
+		break;
+
+	default:
+		dev_dbg(output->dev, "unhandled display event\n");
+		break;
+	}
+
+	return 0;
+}
+
+static int tegra_output_set_stream(struct display_entity *entity,
+				   enum display_entity_stream_state state)
+{
+	struct tegra_output *output = display_entity_to_output(entity);
+
+	switch (state) {
+	case DISPLAY_ENTITY_STATE_OFF:
+	case DISPLAY_ENTITY_STATE_STANDBY:
+		return output->ops->disable(output);
+	case DISPLAY_ENTITY_STATE_ON:
+		return output->ops->enable(output);
+	}
+
+	return 0;
+}
+
+static struct display_entity_video_ops tegra_output_video_ops = {
+	.set_stream = tegra_output_set_stream,
+};
+
 int tegra_output_init(struct drm_device *drm, struct tegra_output *output)
 {
 	int connector, encoder, err;
@@ -250,6 +341,23 @@ int tegra_output_init(struct drm_device *drm, struct tegra_output *output)
 
 	output->encoder.possible_crtcs = 0x3;
 
+	/* register display entity */
+	memset(&output->this, 0, sizeof(output->this));
+	output->this.dev = drm->dev;
+	output->this.ops.video = &tegra_output_video_ops;
+	err = display_entity_register(&output->this);
+	if (err) {
+		dev_err(output->dev, "cannot register display entity\n");
+		return err;
+	}
+
+	/* register display notifier */
+	output->display_notifier.dev = NULL;
+	output->display_notifier.notify = display_notify_callback;
+	err = display_entity_register_notifier(&output->display_notifier);
+	if (err)
+		return err;
+
 	return 0;
 
 free_hpd:
@@ -260,6 +368,12 @@ free_hpd:
 
 int tegra_output_exit(struct tegra_output *output)
 {
+	if (output->output)
+		display_entity_put(output->output);
+
+	display_entity_unregister_notifier(&output->display_notifier);
+	display_entity_unregister(&output->this);
+
 	if (gpio_is_valid(output->hpd_gpio)) {
 		free_irq(output->hpd_irq, output);
 		gpio_free(output->hpd_gpio);
-- 
1.8.1.1

