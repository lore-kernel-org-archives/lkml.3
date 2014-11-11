Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbaKKMyo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 07:54:44 -0500
Received: from regular1.263xmail.com ([211.150.99.130]:43393 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbaKKMyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 07:54:41 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: airlied@linux.ie
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <501d8ac2cf7ba40a107354cdca7e2d4f>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Andy Yan <andy.yan@rock-chips.com>
To: airlied@linux.ie, heiko@sntech.de, fabio.estevam@freescale.com,
        rmk+kernel@arm.linux.org.uk
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, Andy yan <andy.yan@rock-chips.com>,
        Josh Boyer <jwboyer@redhat.com>, Sean Paul <seanpaul@chromium.org>,
        Inki Dae <inki.dae@samsung.com>, Dave Airlie <airlied@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Lucas Stach <l.stach@pengutronix.de>,
        Zubair.Kakakhel@imgtec.com, djkurtz@google.com, ykk@rock-chips.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org, jay.xu@rock-chips.com
Subject: [PATCH v7 6/7] drm: bridge/dw-hdmi: convert dw-hdmi to drm_bridge mode
Date: Tue, 11 Nov 2014 20:54:29 +0800
Message-Id: <1415710469-12213-1-git-send-email-andy.yan@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415710229-11935-1-git-send-email-andy.yan@rock-chips.com>
References: <1415710229-11935-1-git-send-email-andy.yan@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yakir Yang <ykk@rock-chips.com>

keep the connector & birdge in dw_hdmi.c, handle encoder in dw_hdmi-imx.c

Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
Signed-off-by: Yakir Yang <ykk@rock-chips.com>

---

Changes in v7: None
Changes in v6:
- move some modification from patch#5

Changes in v5: None
Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/gpu/drm/bridge/dw_hdmi.c      | 228 +++++++++++++++-------------------
 drivers/staging/imx-drm/dw_hdmi-imx.c | 145 ++++++++++++++-------
 include/drm/bridge/dw_hdmi.h          |  13 +-
 3 files changed, 199 insertions(+), 187 deletions(-)

diff --git a/drivers/gpu/drm/bridge/dw_hdmi.c b/drivers/gpu/drm/bridge/dw_hdmi.c
index 978c709..ed75147 100644
--- a/drivers/gpu/drm/bridge/dw_hdmi.c
+++ b/drivers/gpu/drm/bridge/dw_hdmi.c
@@ -11,7 +11,6 @@
  * Copyright (C) 2010, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
  */
 
-#include <linux/component.h>
 #include <linux/irq.h>
 #include <linux/delay.h>
 #include <linux/err.h>
@@ -108,7 +107,8 @@ union dw_reg_ptr {
 
 struct dw_hdmi {
 	struct drm_connector connector;
-	struct drm_encoder encoder;
+	struct drm_encoder *encoder;
+	struct drm_bridge *bridge;
 
 	enum dw_hdmi_devtype dev_type;
 	struct device *dev;
@@ -1319,6 +1319,50 @@ static void dw_hdmi_poweroff(struct dw_hdmi *hdmi)
 	dw_hdmi_phy_disable(hdmi);
 }
 
+static void dw_hdmi_bridge_mode_set(struct drm_bridge *bridge,
+				    struct drm_display_mode *mode,
+				    struct drm_display_mode *adjusted_mode)
+{
+	struct dw_hdmi *hdmi = bridge->driver_private;
+
+	dw_hdmi_setup(hdmi, mode);
+
+	/* Store the display mode for plugin/DKMS poweron events */
+	memcpy(&hdmi->previous_mode, mode, sizeof(hdmi->previous_mode));
+}
+
+static bool dw_hdmi_bridge_mode_fixup(struct drm_bridge *bridge,
+				      const struct drm_display_mode *mode,
+				      struct drm_display_mode *adjusted_mode)
+{
+	return true;
+}
+
+static void dw_hdmi_bridge_disable(struct drm_bridge *bridge)
+{
+	struct dw_hdmi *hdmi = bridge->driver_private;
+
+	dw_hdmi_poweroff(hdmi);
+}
+
+static void dw_hdmi_bridge_enable(struct drm_bridge *bridge)
+{
+	struct dw_hdmi *hdmi = bridge->driver_private;
+
+	dw_hdmi_poweron(hdmi);
+}
+
+static void dw_hdmi_bridge_destroy(struct drm_bridge *bridge)
+{
+	drm_bridge_cleanup(bridge);
+	kfree(bridge);
+}
+
+static void dw_hdmi_bridge_nope(struct drm_bridge *bridge)
+{
+	/* do nothing */
+}
+
 static enum drm_connector_status dw_hdmi_connector_detect(struct drm_connector
 							*connector, bool force)
 {
@@ -1360,60 +1404,7 @@ static struct drm_encoder *dw_hdmi_connector_best_encoder(struct drm_connector
 	struct dw_hdmi *hdmi = container_of(connector, struct dw_hdmi,
 					     connector);
 
-	return &hdmi->encoder;
-}
-
-static void dw_hdmi_encoder_mode_set(struct drm_encoder *encoder,
-			struct drm_display_mode *mode,
-			struct drm_display_mode *adjusted_mode)
-{
-	struct dw_hdmi *hdmi = container_of(encoder, struct dw_hdmi, encoder);
-
-	dw_hdmi_setup(hdmi, mode);
-
-	/* Store the display mode for plugin/DKMS poweron events */
-	memcpy(&hdmi->previous_mode, mode, sizeof(hdmi->previous_mode));
-}
-
-static bool dw_hdmi_encoder_mode_fixup(struct drm_encoder *encoder,
-			const struct drm_display_mode *mode,
-			struct drm_display_mode *adjusted_mode)
-{
-	return true;
-}
-
-static void dw_hdmi_encoder_disable(struct drm_encoder *encoder)
-{
-}
-
-static void dw_hdmi_encoder_dpms(struct drm_encoder *encoder, int mode)
-{
-	struct dw_hdmi *hdmi = container_of(encoder, struct dw_hdmi, encoder);
-
-	if (mode)
-		dw_hdmi_poweroff(hdmi);
-	else
-		dw_hdmi_poweron(hdmi);
-}
-
-static void dw_hdmi_encoder_prepare(struct drm_encoder *encoder)
-{
-	struct dw_hdmi *hdmi = container_of(encoder, struct dw_hdmi, encoder);
-
-	dw_hdmi_poweroff(hdmi);
-
-	if (hdmi->plat_data->encoder_prepare)
-		hdmi->plat_data->encoder_prepare(&hdmi->connector, encoder);
-}
-
-static void dw_hdmi_encoder_commit(struct drm_encoder *encoder)
-{
-	struct dw_hdmi *hdmi = container_of(encoder, struct dw_hdmi, encoder);
-
-	if (hdmi->plat_data->encoder_commit)
-		hdmi->plat_data->encoder_commit(hdmi->priv, encoder);
-
-	dw_hdmi_poweron(hdmi);
+	return hdmi->encoder;
 }
 
 void dw_hdmi_connector_destroy(struct drm_connector *connector)
@@ -1422,19 +1413,6 @@ void dw_hdmi_connector_destroy(struct drm_connector *connector)
 	drm_connector_cleanup(connector);
 }
 
-static struct drm_encoder_funcs dw_hdmi_encoder_funcs = {
-	.destroy = drm_encoder_cleanup,
-};
-
-static struct drm_encoder_helper_funcs dw_hdmi_encoder_helper_funcs = {
-	.dpms = dw_hdmi_encoder_dpms,
-	.prepare = dw_hdmi_encoder_prepare,
-	.commit = dw_hdmi_encoder_commit,
-	.mode_set = dw_hdmi_encoder_mode_set,
-	.mode_fixup = dw_hdmi_encoder_mode_fixup,
-	.disable = dw_hdmi_encoder_disable,
-};
-
 static struct drm_connector_funcs dw_hdmi_connector_funcs = {
 	.dpms = drm_helper_connector_dpms,
 	.fill_modes = drm_helper_probe_single_connector_modes,
@@ -1447,6 +1425,16 @@ static struct drm_connector_helper_funcs dw_hdmi_connector_helper_funcs = {
 	.best_encoder = dw_hdmi_connector_best_encoder,
 };
 
+struct drm_bridge_funcs dw_hdmi_bridge_funcs = {
+	.enable = dw_hdmi_bridge_enable,
+	.disable = dw_hdmi_bridge_disable,
+	.pre_enable = dw_hdmi_bridge_nope,
+	.post_disable = dw_hdmi_bridge_nope,
+	.mode_set = dw_hdmi_bridge_mode_set,
+	.mode_fixup = dw_hdmi_bridge_mode_fixup,
+	.destroy = dw_hdmi_bridge_destroy,
+};
+
 static irqreturn_t dw_hdmi_hardirq(int irq, void *dev_id)
 {
 	struct dw_hdmi *hdmi = dev_id;
@@ -1495,40 +1483,64 @@ static irqreturn_t dw_hdmi_irq(int irq, void *dev_id)
 
 static int dw_hdmi_register(struct drm_device *drm, struct dw_hdmi *hdmi)
 {
-	struct drm_encoder *encoder = &hdmi->encoder;
-	struct device *dev = hdmi->dev;
+	struct drm_encoder *encoder = hdmi->encoder;
+	struct drm_bridge *bridge;
+	int ret;
 
-	encoder->possible_crtcs = drm_of_find_possible_crtcs(drm, dev->of_node);
+	bridge = devm_kzalloc(drm->dev, sizeof(*bridge), GFP_KERNEL);
+	if (!bridge) {
+		DRM_ERROR("Failed to allocate drm bridge\n");
+		return -ENOMEM;
+	}
 
-	hdmi->connector.polled = DRM_CONNECTOR_POLL_HPD;
+	hdmi->bridge = bridge;
+	bridge->driver_private = hdmi;
 
-	drm_encoder_helper_add(&hdmi->encoder, &dw_hdmi_encoder_helper_funcs);
-	drm_encoder_init(drm, &hdmi->encoder, &dw_hdmi_encoder_funcs,
-			 DRM_MODE_ENCODER_TMDS);
+	ret = drm_bridge_init(drm, bridge, &dw_hdmi_bridge_funcs);
+	if (ret) {
+		DRM_ERROR("Failed to initialize bridge with drm\n");
+		return -EINVAL;
+	}
+
+	encoder->bridge = bridge;
+	hdmi->connector.polled = DRM_CONNECTOR_POLL_HPD;
 
 	drm_connector_helper_add(&hdmi->connector,
 				 &dw_hdmi_connector_helper_funcs);
 	drm_connector_init(drm, &hdmi->connector, &dw_hdmi_connector_funcs,
 			   DRM_MODE_CONNECTOR_HDMIA);
 
-	hdmi->connector.encoder = &hdmi->encoder;
+	hdmi->connector.encoder = encoder;
 
-	drm_mode_connector_attach_encoder(&hdmi->connector, &hdmi->encoder);
+	drm_mode_connector_attach_encoder(&hdmi->connector, encoder);
 
 	return 0;
 }
 
-static int dw_hdmi_bind(struct device *dev, struct device *master, void *data)
+int dw_hdmi_bind(struct device *dev, struct device *master,
+		 void *data, struct drm_encoder *encoder,
+		 const struct dw_hdmi_plat_data *plat_data)
 {
 	struct platform_device *pdev = to_platform_device(dev);
-	struct dw_hdmi *hdmi = platform_get_drvdata(pdev);
 	struct drm_device *drm = data;
 	struct device_node *np = dev->of_node;
 	struct device_node *ddc_node;
 	struct resource *iores;
+	struct dw_hdmi *hdmi;
 	int ret, irq;
 	u32 val = 1;
 
+	hdmi = devm_kzalloc(&pdev->dev, sizeof(*hdmi), GFP_KERNEL);
+	if (!hdmi)
+		return -ENOMEM;
+
+	hdmi->plat_data = plat_data;
+	hdmi->dev = &pdev->dev;
+	hdmi->dev_type = plat_data->dev_type;
+	hdmi->sample_rate = 48000;
+	hdmi->ratio = 100;
+	hdmi->encoder = encoder;
+
 	of_property_read_u32(np, "reg-io-width", &val);
 
 	switch (val) {
@@ -1574,8 +1586,6 @@ static int dw_hdmi_bind(struct device *dev, struct device *master, void *data)
 	if (IS_ERR(hdmi->regs.p32))
 		return PTR_ERR(hdmi->regs.p32);
 
-	if (hdmi->plat_data->setup)
-		hdmi->priv = hdmi->plat_data->setup(pdev);
 	/* Product and revision IDs */
 	dev_info(dev,
 		 "Detected HDMI controller 0x%x:0x%x:0x%x:0x%x\n",
@@ -1616,9 +1626,9 @@ static int dw_hdmi_bind(struct device *dev, struct device *master, void *data)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(dw_hdmi_bind);
 
-static void dw_hdmi_unbind(struct device *dev, struct device *master,
-	void *data)
+void dw_hdmi_unbind(struct device *dev, struct device *master, void *data)
 {
 	struct dw_hdmi *hdmi = dev_get_drvdata(dev);
 
@@ -1626,57 +1636,15 @@ static void dw_hdmi_unbind(struct device *dev, struct device *master,
 	hdmi_writeb(hdmi, ~0, HDMI_IH_MUTE_PHY_STAT0);
 
 	hdmi->connector.funcs->destroy(&hdmi->connector);
-	hdmi->encoder.funcs->destroy(&hdmi->encoder);
-	if (hdmi->plat_data->exit)
-		hdmi->plat_data->exit(hdmi->priv);
-	i2c_put_adapter(hdmi->ddc);
-}
-
-static const struct component_ops hdmi_ops = {
-	.bind	= dw_hdmi_bind,
-	.unbind	= dw_hdmi_unbind,
-};
-
-static int dw_hdmi_platform_probe(struct platform_device *pdev)
-{
-	return component_add(&pdev->dev, &hdmi_ops);
-}
-
-static int dw_hdmi_platform_remove(struct platform_device *pdev)
-{
-	component_del(&pdev->dev, &hdmi_ops);
-	return 0;
-}
-
-int dw_hdmi_platform_register(struct platform_device *pdev,
-			      const struct dw_hdmi_plat_data *plat_data)
-{
-	struct dw_hdmi *hdmi;
-
-	hdmi = devm_kzalloc(&pdev->dev, sizeof(*hdmi), GFP_KERNEL);
-	if (!hdmi)
-		return -ENOMEM;
-
-	hdmi->plat_data = plat_data;
-	hdmi->dev = &pdev->dev;
-	hdmi->dev_type = plat_data->dev_type;
-	hdmi->sample_rate = 48000;
-	hdmi->ratio = 100;
+	hdmi->encoder->funcs->destroy(hdmi->encoder);
 
-	platform_set_drvdata(pdev, hdmi);
-
-	return dw_hdmi_platform_probe(pdev);
-}
-EXPORT_SYMBOL_GPL(dw_hdmi_platform_register);
-
-int dw_hdmi_platform_unregister(struct platform_device *pdev)
-{
-	return dw_hdmi_platform_remove(pdev);
+	i2c_put_adapter(hdmi->ddc);
 }
-EXPORT_SYMBOL_GPL(dw_hdmi_platform_unregister);
+EXPORT_SYMBOL_GPL(dw_hdmi_unbind);
 
 MODULE_AUTHOR("Sascha Hauer <s.hauer@pengutronix.de>");
 MODULE_AUTHOR("Andy Yan <andy.yan@rock-chips.com>");
+MODULE_AUTHOR("Yakir Yang <ykk@rock-chips.com>");
 MODULE_DESCRIPTION("DW HDMI transmitter driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:dw-hdmi");
diff --git a/drivers/staging/imx-drm/dw_hdmi-imx.c b/drivers/staging/imx-drm/dw_hdmi-imx.c
index 4b48ea6..ad71c8e 100644
--- a/drivers/staging/imx-drm/dw_hdmi-imx.c
+++ b/drivers/staging/imx-drm/dw_hdmi-imx.c
@@ -8,12 +8,19 @@
  */
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/component.h>
 #include <linux/mfd/syscon.h>
 #include <linux/mfd/syscon/imx6q-iomuxc-gpr.h>
 #include <drm/bridge/dw_hdmi.h>
 #include <video/imx-ipu-v3.h>
 #include <linux/regmap.h>
 #include <linux/clk.h>
+#include <drm/drm_of.h>
+#include <drm/drmP.h>
+#include <drm/drm_crtc_helper.h>
+#include <drm/drm_edid.h>
+#include <drm/drm_encoder_slave.h>
+#include <drm/bridge/dw_hdmi.h>
 
 #include "imx-drm.h"
 
@@ -22,6 +29,7 @@ struct imx_hdmi {
 	struct clk *isfr_clk;
 	struct clk *iahb_clk;
 	struct regmap *regmap;
+	struct drm_encoder encoder;
 };
 
 static const struct mpll_config imx_mpll_cfg[] = {
@@ -69,7 +77,7 @@ static const struct curr_ctrl imx_cur_ctr[] = {
 	}
 };
 
-static int dw_hdmi_parse_dt(struct imx_hdmi *hdmi)
+static int dw_hdmi_imx_parse_dt(struct imx_hdmi *hdmi)
 {
 	struct device_node *np = hdmi->dev->of_node;
 
@@ -94,48 +102,26 @@ static int dw_hdmi_parse_dt(struct imx_hdmi *hdmi)
 	return 0;
 }
 
-static void *dw_hdmi_imx_setup(struct platform_device *pdev)
+static void dw_hdmi_imx_disable(struct drm_encoder *encoder)
 {
-	struct imx_hdmi *hdmi;
-	int ret;
-
-	hdmi = devm_kzalloc(&pdev->dev, sizeof(*hdmi), GFP_KERNEL);
-	if (!hdmi)
-		return ERR_PTR(-ENOMEM);
-	hdmi->dev = &pdev->dev;
-
-	ret = dw_hdmi_parse_dt(hdmi);
-	if (ret < 0)
-		return ERR_PTR(ret);
-	ret = clk_prepare_enable(hdmi->isfr_clk);
-	if (ret) {
-		dev_err(hdmi->dev,
-			"Cannot enable HDMI isfr clock: %d\n", ret);
-		return ERR_PTR(ret);
-	}
-
-	ret = clk_prepare_enable(hdmi->iahb_clk);
-	if (ret) {
-		dev_err(hdmi->dev,
-			"Cannot enable HDMI iahb clock: %d\n", ret);
-		return ERR_PTR(ret);
-	}
-
-	return hdmi;
 }
 
-static void dw_hdmi_imx_exit(void *priv)
+static bool dw_hdmi_imx_mode_fixup(struct drm_encoder *encoder,
+				   const struct drm_display_mode *mode,
+				   struct drm_display_mode *adjusted_mode)
 {
-	struct imx_hdmi *hdmi = (struct imx_hdmi *)priv;
-
-	clk_disable_unprepare(hdmi->isfr_clk);
+	return true;
+}
 
-	clk_disable_unprepare(hdmi->iahb_clk);
+static void dw_hdmi_imx_mode_set(struct drm_encoder *encoder,
+				 struct drm_display_mode *mode,
+				 struct drm_display_mode *adjusted_mode)
+{
 }
 
-static void dw_hdmi_imx_encoder_commit(void *priv, struct drm_encoder *encoder)
+static void dw_hdmi_imx_commit(struct drm_encoder *encoder)
 {
-	struct imx_hdmi *hdmi = (struct imx_hdmi *)priv;
+	struct imx_hdmi *hdmi = container_of(encoder, struct imx_hdmi, encoder);
 	int mux = imx_drm_encoder_get_mux_id(hdmi->dev->of_node, encoder);
 
 	regmap_update_bits(hdmi->regmap, IOMUXC_GPR3,
@@ -143,27 +129,30 @@ static void dw_hdmi_imx_encoder_commit(void *priv, struct drm_encoder *encoder)
 			   mux << IMX6Q_GPR3_HDMI_MUX_CTL_SHIFT);
 }
 
-static void dw_hdmi_imx_encoder_prepare(struct drm_connector *connector,
-					struct drm_encoder *encoder)
+static void dw_hdmi_imx_prepare(struct drm_encoder *encoder)
 {
 	imx_drm_panel_format(encoder, V4L2_PIX_FMT_RGB24);
 }
 
+static struct drm_encoder_helper_funcs imx_hdmi_encoder_helper_funcs = {
+	.mode_fixup = dw_hdmi_imx_mode_fixup,
+	.mode_set = dw_hdmi_imx_mode_set,
+	.prepare = dw_hdmi_imx_prepare,
+	.commit = dw_hdmi_imx_commit,
+	.disable = dw_hdmi_imx_disable,
+};
+
+static struct drm_encoder_funcs imx_hdmi_encoder_funcs = {
+	.destroy = drm_encoder_cleanup,
+};
+
 static struct dw_hdmi_plat_data imx6q_hdmi_drv_data = {
-	.setup			= dw_hdmi_imx_setup,
-	.exit			= dw_hdmi_imx_exit,
-	.encoder_commit		= dw_hdmi_imx_encoder_commit,
-	.encoder_prepare	= dw_hdmi_imx_encoder_prepare,
 	.mpll_cfg		= imx_mpll_cfg,
 	.cur_ctr		= imx_cur_ctr,
 	.dev_type		= IMX6Q_HDMI,
 };
 
 static struct dw_hdmi_plat_data imx6dl_hdmi_drv_data = {
-	.setup			= dw_hdmi_imx_setup,
-	.exit			= dw_hdmi_imx_exit,
-	.encoder_commit		= dw_hdmi_imx_encoder_commit,
-	.encoder_prepare	= dw_hdmi_imx_encoder_prepare,
 	.mpll_cfg		= imx_mpll_cfg,
 	.cur_ctr		= imx_cur_ctr,
 	.dev_type		= IMX6DL_HDMI,
@@ -180,23 +169,82 @@ static const struct of_device_id dw_hdmi_imx_ids[] = {
 };
 MODULE_DEVICE_TABLE(of, dw_hdmi_imx_dt_ids);
 
-static int dw_hdmi_imx_probe(struct platform_device *pdev)
+static int dw_hdmi_imx_bind(struct device *dev, struct device *master,
+			    void *data)
 {
+	struct platform_device *pdev = to_platform_device(dev);
 	const struct dw_hdmi_plat_data *plat_data;
 	const struct of_device_id *match;
+	struct drm_device *drm = data;
+	struct drm_encoder *encoder;
+	struct imx_hdmi *hdmi;
+	int ret;
 
 	if (!pdev->dev.of_node)
 		return -ENODEV;
 
+	hdmi = devm_kzalloc(&pdev->dev, sizeof(*hdmi), GFP_KERNEL);
+	if (!hdmi)
+		return -ENOMEM;
+
 	match = of_match_node(dw_hdmi_imx_ids, pdev->dev.of_node);
 	plat_data = match->data;
+	hdmi->dev = &pdev->dev;
+	encoder = &hdmi->encoder;
+	platform_set_drvdata(pdev, hdmi);
+
+	ret = dw_hdmi_imx_parse_dt(hdmi);
+	if (ret < 0)
+		return ret;
+
+	ret = clk_prepare_enable(hdmi->isfr_clk);
+	if (ret) {
+		dev_err(dev, "Cannot enable HDMI isfr clock: %d\n", ret);
+		return ret;
+	}
+
+	ret = clk_prepare_enable(hdmi->iahb_clk);
+	if (ret) {
+		dev_err(dev, "Cannot enable HDMI iahb clock: %d\n", ret);
+		return ret;
+	}
+
+	encoder->possible_crtcs = drm_of_find_possible_crtcs(drm, dev->of_node);
+
+	drm_encoder_helper_add(encoder, &imx_hdmi_encoder_helper_funcs);
+	drm_encoder_init(drm, encoder, &imx_hdmi_encoder_funcs,
+			 DRM_MODE_ENCODER_TMDS);
 
-	return dw_hdmi_platform_register(pdev, plat_data);
+	return dw_hdmi_bind(dev, master, data, encoder, plat_data);
+}
+
+static void dw_hdmi_imx_unbind(struct device *dev, struct device *master,
+			       void *data)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct imx_hdmi *hdmi = platform_get_drvdata(pdev);
+
+	clk_disable_unprepare(hdmi->isfr_clk);
+	clk_disable_unprepare(hdmi->iahb_clk);
+
+	return dw_hdmi_unbind(dev, master, data);
+}
+
+static const struct component_ops dw_hdmi_imx_ops = {
+	.bind	= dw_hdmi_imx_bind,
+	.unbind	= dw_hdmi_imx_unbind,
+};
+
+static int dw_hdmi_imx_probe(struct platform_device *pdev)
+{
+	return component_add(&pdev->dev, &dw_hdmi_imx_ops);
 }
 
 static int dw_hdmi_imx_remove(struct platform_device *pdev)
 {
-	return dw_hdmi_platform_unregister(pdev);
+	component_del(&pdev->dev, &dw_hdmi_imx_ops);
+
+	return 0;
 }
 
 static struct platform_driver dw_hdmi_imx_platform_driver = {
@@ -212,6 +260,7 @@ static struct platform_driver dw_hdmi_imx_platform_driver = {
 module_platform_driver(dw_hdmi_imx_platform_driver);
 
 MODULE_AUTHOR("Andy Yan <andy.yan@rock-chips.com>");
+MODULE_AUTHOR("Yakir Yang <ykk@rock-chips.com>");
 MODULE_DESCRIPTION("IMX6 Specific DW-HDMI Driver Extension");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:dwhdmi-imx");
diff --git a/include/drm/bridge/dw_hdmi.h b/include/drm/bridge/dw_hdmi.h
index 6683b63..e26e61f 100644
--- a/include/drm/bridge/dw_hdmi.h
+++ b/include/drm/bridge/dw_hdmi.h
@@ -38,20 +38,15 @@ struct curr_ctrl {
 };
 
 struct dw_hdmi_plat_data {
-	void * (*setup)(struct platform_device *pdev);
-	void (*exit)(void *priv);
-	void (*encoder_commit)(void *priv, struct drm_encoder *encoder);
-	void (*encoder_prepare)(struct drm_connector *connector,
-				struct drm_encoder *encoder);
 	enum drm_mode_status (*mode_valid)(struct drm_connector *connector,
 					   struct drm_display_mode *mode);
 	const struct mpll_config *mpll_cfg;
 	const struct curr_ctrl *cur_ctr;
 	enum dw_hdmi_devtype dev_type;
-
 };
 
-int dw_hdmi_platform_register(struct platform_device *pdev,
-			      const struct dw_hdmi_plat_data *plat_data);
-int dw_hdmi_platform_unregister(struct platform_device *pdev);
+void dw_hdmi_unbind(struct device *dev, struct device *master, void *data);
+int dw_hdmi_bind(struct device *dev, struct device *master,
+		 void *data, struct drm_encoder *encoder,
+		 const struct dw_hdmi_plat_data *plat_data);
 #endif /* __IMX_HDMI_H__ */
-- 
1.9.1


