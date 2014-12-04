Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654AbaLDKEA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:04:00 -0500
Received: from lucky1.263xmail.com ([211.157.147.132]:47077 "EHLO
	lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072AbaLDKD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:03:57 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 1
X-MAIL-DELIVERY: 0
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: airlied@linux.ie
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <27b429c6498b1d462d6f55d72eae4b78>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Andy Yan <andy.yan@rock-chips.com>
To: airlied@linux.ie, Philipp Zabel <p.zabel@pengutronix.de>, heiko@sntech.de,
        fabio.estevam@freescale.com, rmk+kernel@arm.linux.org.uk
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        Josh Boyer <jwboyer@redhat.com>, Sean Paul <seanpaul@chromium.org>,
        Inki Dae <inki.dae@samsung.com>, Dave Airlie <airlied@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Lucas Stach <l.stach@pengutronix.de>,
        Zubair.Kakakhel@imgtec.com, djkurtz@google.com, ykk@rock-chips.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org, jay.xu@rock-chips.com,
        Pawel Moll <pawel.moll@arm.com>, mark.yao@rock-chips.com,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, vladimir_zapolskiy@mentor.com,
        Andy Yan <andy.yan@rock-chips.com>
Subject: [PATCH v17 03/12] drm: imx: imx-hdmi: convert imx-hdmi to drm_bridge mode
Date: Thu,  4 Dec 2014 18:03:26 +0800
Message-Id: <1417687406-13062-1-git-send-email-andy.yan@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417686826-12687-1-git-send-email-andy.yan@rock-chips.com>
References: <1417686826-12687-1-git-send-email-andy.yan@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IMX6 and Rockchip RK3288 and JZ4780 (Ingenic Xburst/MIPS)
use the interface compatible Designware HDMI IP, but they
also have some lightly differences, such as phy pll configuration,
register width, 4K support, clk useage, and the crtc mux configuration
is also platform specific.

To reuse the imx hdmi driver, convert it to drm_bridge

handle encoder in imx-hdmi_pltfm.c, as most of the encoder
operation are platform specific such as crtc select and
panel format set

This patch depends on Russell King's patch:
 drm: imx: convert imx-drm to use the generic DRM OF helper
 http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2014-July/053484.html

Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
Signed-off-by: Yakir Yang <ykk@rock-chips.com>

---

Changes in v17:
- remove platform device stuff, adviced by Russell King

Changes in v16:
- use the common binding for the clocks

Changes in v15: None
Changes in v14:
- add defer probing, adviced by Philipp Zabel

Changes in v13:
- split platform specific phy configuration

Changes in v12:
- squash patch <convert dw_hdmi to drm_bridge>

Changes in v11:
- squash patch  <split some phy configuration to platform driver>

Changes in v10:
- split generic dw_hdmi.c improvements from patch#11 (add rk3288 support)

Changes in v9: None
Changes in v8: None
Changes in v7:
- remove unused variables from structure dw_hdmi
- remove a wrong modification
- add copyrights for dw_hdmi-imx.c

Changes in v6: None
Changes in v5: None
Changes in v4: None
Changes in v3: None

 drivers/gpu/drm/imx/Makefile         |   2 +-
 drivers/gpu/drm/imx/imx-hdmi.c       | 257 +++++++++++++----------------------
 drivers/gpu/drm/imx/imx-hdmi.h       |  15 ++
 drivers/gpu/drm/imx/imx-hdmi_pltfm.c | 204 +++++++++++++++++++++++++++
 4 files changed, 316 insertions(+), 162 deletions(-)
 create mode 100644 drivers/gpu/drm/imx/imx-hdmi_pltfm.c

diff --git a/drivers/gpu/drm/imx/Makefile b/drivers/gpu/drm/imx/Makefile
index 582c438..63cf56a 100644
--- a/drivers/gpu/drm/imx/Makefile
+++ b/drivers/gpu/drm/imx/Makefile
@@ -9,4 +9,4 @@ obj-$(CONFIG_DRM_IMX_LDB) += imx-ldb.o
 
 imx-ipuv3-crtc-objs  := ipuv3-crtc.o ipuv3-plane.o
 obj-$(CONFIG_DRM_IMX_IPUV3)	+= imx-ipuv3-crtc.o
-obj-$(CONFIG_DRM_IMX_HDMI) += imx-hdmi.o
+obj-$(CONFIG_DRM_IMX_HDMI) += imx-hdmi.o imx-hdmi_pltfm.o
diff --git a/drivers/gpu/drm/imx/imx-hdmi.c b/drivers/gpu/drm/imx/imx-hdmi.c
index 7a54d20..3ea9726 100644
--- a/drivers/gpu/drm/imx/imx-hdmi.c
+++ b/drivers/gpu/drm/imx/imx-hdmi.c
@@ -12,25 +12,20 @@
  * Copyright (C) 2010, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
  */
 
-#include <linux/component.h>
 #include <linux/irq.h>
 #include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/clk.h>
 #include <linux/hdmi.h>
-#include <linux/regmap.h>
-#include <linux/mfd/syscon.h>
-#include <linux/mfd/syscon/imx6q-iomuxc-gpr.h>
 #include <linux/of_device.h>
 
+#include <drm/drm_of.h>
 #include <drm/drmP.h>
 #include <drm/drm_crtc_helper.h>
 #include <drm/drm_edid.h>
 #include <drm/drm_encoder_slave.h>
-#include <video/imx-ipu-v3.h>
 
 #include "imx-hdmi.h"
-#include "imx-drm.h"
 
 #define HDMI_EDID_LEN		512
 
@@ -54,11 +49,6 @@ enum hdmi_datamap {
 	YCbCr422_12B = 0x12,
 };
 
-enum imx_hdmi_devtype {
-	IMX6Q_HDMI,
-	IMX6DL_HDMI,
-};
-
 static const u16 csc_coeff_default[3][4] = {
 	{ 0x2000, 0x0000, 0x0000, 0x0000 },
 	{ 0x0000, 0x2000, 0x0000, 0x0000 },
@@ -113,7 +103,8 @@ struct hdmi_data_info {
 
 struct imx_hdmi {
 	struct drm_connector connector;
-	struct drm_encoder encoder;
+	struct drm_encoder *encoder;
+	struct drm_bridge *bridge;
 
 	enum imx_hdmi_devtype dev_type;
 	struct device *dev;
@@ -121,6 +112,7 @@ struct imx_hdmi {
 	struct clk *iahb_clk;
 
 	struct hdmi_data_info hdmi_data;
+	const struct imx_hdmi_plat_data *plat_data;
 	int vic;
 
 	u8 edid[HDMI_EDID_LEN];
@@ -137,13 +129,6 @@ struct imx_hdmi {
 	int ratio;
 };
 
-static void imx_hdmi_set_ipu_di_mux(struct imx_hdmi *hdmi, int ipu_di)
-{
-	regmap_update_bits(hdmi->regmap, IOMUXC_GPR3,
-			   IMX6Q_GPR3_HDMI_MUX_CTL_MASK,
-			   ipu_di << IMX6Q_GPR3_HDMI_MUX_CTL_SHIFT);
-}
-
 static inline void hdmi_writeb(struct imx_hdmi *hdmi, u8 val, int offset)
 {
 	writeb(val, hdmi->regs + offset);
@@ -1371,6 +1356,50 @@ static void imx_hdmi_poweroff(struct imx_hdmi *hdmi)
 	imx_hdmi_phy_disable(hdmi);
 }
 
+static void imx_hdmi_bridge_mode_set(struct drm_bridge *bridge,
+				     struct drm_display_mode *mode,
+				     struct drm_display_mode *adjusted_mode)
+{
+	struct imx_hdmi *hdmi = bridge->driver_private;
+
+	imx_hdmi_setup(hdmi, mode);
+
+	/* Store the display mode for plugin/DKMS poweron events */
+	memcpy(&hdmi->previous_mode, mode, sizeof(hdmi->previous_mode));
+}
+
+static bool imx_hdmi_bridge_mode_fixup(struct drm_bridge *bridge,
+				       const struct drm_display_mode *mode,
+				       struct drm_display_mode *adjusted_mode)
+{
+	return true;
+}
+
+static void imx_hdmi_bridge_disable(struct drm_bridge *bridge)
+{
+	struct imx_hdmi *hdmi = bridge->driver_private;
+
+	imx_hdmi_poweroff(hdmi);
+}
+
+static void imx_hdmi_bridge_enable(struct drm_bridge *bridge)
+{
+	struct imx_hdmi *hdmi = bridge->driver_private;
+
+	imx_hdmi_poweron(hdmi);
+}
+
+static void imx_hdmi_bridge_destroy(struct drm_bridge *bridge)
+{
+	drm_bridge_cleanup(bridge);
+	kfree(bridge);
+}
+
+static void imx_hdmi_bridge_nope(struct drm_bridge *bridge)
+{
+	/* do nothing */
+}
+
 static enum drm_connector_status imx_hdmi_connector_detect(struct drm_connector
 							*connector, bool force)
 {
@@ -1412,78 +1441,20 @@ static struct drm_encoder *imx_hdmi_connector_best_encoder(struct drm_connector
 	struct imx_hdmi *hdmi = container_of(connector, struct imx_hdmi,
 					     connector);
 
-	return &hdmi->encoder;
-}
-
-static void imx_hdmi_encoder_mode_set(struct drm_encoder *encoder,
-			struct drm_display_mode *mode,
-			struct drm_display_mode *adjusted_mode)
-{
-	struct imx_hdmi *hdmi = container_of(encoder, struct imx_hdmi, encoder);
-
-	imx_hdmi_setup(hdmi, mode);
-
-	/* Store the display mode for plugin/DKMS poweron events */
-	memcpy(&hdmi->previous_mode, mode, sizeof(hdmi->previous_mode));
-}
-
-static bool imx_hdmi_encoder_mode_fixup(struct drm_encoder *encoder,
-			const struct drm_display_mode *mode,
-			struct drm_display_mode *adjusted_mode)
-{
-	return true;
-}
-
-static void imx_hdmi_encoder_disable(struct drm_encoder *encoder)
-{
-}
-
-static void imx_hdmi_encoder_dpms(struct drm_encoder *encoder, int mode)
-{
-	struct imx_hdmi *hdmi = container_of(encoder, struct imx_hdmi, encoder);
-
-	if (mode)
-		imx_hdmi_poweroff(hdmi);
-	else
-		imx_hdmi_poweron(hdmi);
+	return hdmi->encoder;
 }
 
-static void imx_hdmi_encoder_prepare(struct drm_encoder *encoder)
+static void imx_hdmi_connector_destroy(struct drm_connector *connector)
 {
-	struct imx_hdmi *hdmi = container_of(encoder, struct imx_hdmi, encoder);
-
-	imx_hdmi_poweroff(hdmi);
-	imx_drm_panel_format(encoder, V4L2_PIX_FMT_RGB24);
+	drm_connector_unregister(connector);
+	drm_connector_cleanup(connector);
 }
 
-static void imx_hdmi_encoder_commit(struct drm_encoder *encoder)
-{
-	struct imx_hdmi *hdmi = container_of(encoder, struct imx_hdmi, encoder);
-	int mux = imx_drm_encoder_get_mux_id(hdmi->dev->of_node, encoder);
-
-	imx_hdmi_set_ipu_di_mux(hdmi, mux);
-
-	imx_hdmi_poweron(hdmi);
-}
-
-static struct drm_encoder_funcs imx_hdmi_encoder_funcs = {
-	.destroy = imx_drm_encoder_destroy,
-};
-
-static struct drm_encoder_helper_funcs imx_hdmi_encoder_helper_funcs = {
-	.dpms = imx_hdmi_encoder_dpms,
-	.prepare = imx_hdmi_encoder_prepare,
-	.commit = imx_hdmi_encoder_commit,
-	.mode_set = imx_hdmi_encoder_mode_set,
-	.mode_fixup = imx_hdmi_encoder_mode_fixup,
-	.disable = imx_hdmi_encoder_disable,
-};
-
 static struct drm_connector_funcs imx_hdmi_connector_funcs = {
 	.dpms = drm_helper_connector_dpms,
 	.fill_modes = drm_helper_probe_single_connector_modes,
 	.detect = imx_hdmi_connector_detect,
-	.destroy = imx_drm_connector_destroy,
+	.destroy = imx_hdmi_connector_destroy,
 };
 
 static struct drm_connector_helper_funcs imx_hdmi_connector_helper_funcs = {
@@ -1491,6 +1462,16 @@ static struct drm_connector_helper_funcs imx_hdmi_connector_helper_funcs = {
 	.best_encoder = imx_hdmi_connector_best_encoder,
 };
 
+struct drm_bridge_funcs imx_hdmi_bridge_funcs = {
+	.enable = imx_hdmi_bridge_enable,
+	.disable = imx_hdmi_bridge_disable,
+	.pre_enable = imx_hdmi_bridge_nope,
+	.post_disable = imx_hdmi_bridge_nope,
+	.mode_set = imx_hdmi_bridge_mode_set,
+	.mode_fixup = imx_hdmi_bridge_mode_fixup,
+	.destroy = imx_hdmi_bridge_destroy,
+};
+
 static irqreturn_t imx_hdmi_hardirq(int irq, void *dev_id)
 {
 	struct imx_hdmi *hdmi = dev_id;
@@ -1539,74 +1520,61 @@ static irqreturn_t imx_hdmi_irq(int irq, void *dev_id)
 
 static int imx_hdmi_register(struct drm_device *drm, struct imx_hdmi *hdmi)
 {
+	struct drm_encoder *encoder = hdmi->encoder;
+	struct drm_bridge *bridge;
 	int ret;
 
-	ret = imx_drm_encoder_parse_of(drm, &hdmi->encoder,
-				       hdmi->dev->of_node);
-	if (ret)
-		return ret;
+	bridge = devm_kzalloc(drm->dev, sizeof(*bridge), GFP_KERNEL);
+	if (!bridge) {
+		DRM_ERROR("Failed to allocate drm bridge\n");
+		return -ENOMEM;
+	}
 
-	hdmi->connector.polled = DRM_CONNECTOR_POLL_HPD;
+	hdmi->bridge = bridge;
+	bridge->driver_private = hdmi;
+
+	ret = drm_bridge_init(drm, bridge, &imx_hdmi_bridge_funcs);
+	if (ret) {
+		DRM_ERROR("Failed to initialize bridge with drm\n");
+		return -EINVAL;
+	}
 
-	drm_encoder_helper_add(&hdmi->encoder, &imx_hdmi_encoder_helper_funcs);
-	drm_encoder_init(drm, &hdmi->encoder, &imx_hdmi_encoder_funcs,
-			 DRM_MODE_ENCODER_TMDS);
+	encoder->bridge = bridge;
+	hdmi->connector.polled = DRM_CONNECTOR_POLL_HPD;
 
 	drm_connector_helper_add(&hdmi->connector,
 				 &imx_hdmi_connector_helper_funcs);
 	drm_connector_init(drm, &hdmi->connector, &imx_hdmi_connector_funcs,
 			   DRM_MODE_CONNECTOR_HDMIA);
 
-	hdmi->connector.encoder = &hdmi->encoder;
+	hdmi->connector.encoder = encoder;
 
-	drm_mode_connector_attach_encoder(&hdmi->connector, &hdmi->encoder);
+	drm_mode_connector_attach_encoder(&hdmi->connector, encoder);
 
 	return 0;
 }
 
-static struct platform_device_id imx_hdmi_devtype[] = {
-	{
-		.name = "imx6q-hdmi",
-		.driver_data = IMX6Q_HDMI,
-	}, {
-		.name = "imx6dl-hdmi",
-		.driver_data = IMX6DL_HDMI,
-	}, { /* sentinel */ }
-};
-MODULE_DEVICE_TABLE(platform, imx_hdmi_devtype);
-
-static const struct of_device_id imx_hdmi_dt_ids[] = {
-{ .compatible = "fsl,imx6q-hdmi", .data = &imx_hdmi_devtype[IMX6Q_HDMI], },
-{ .compatible = "fsl,imx6dl-hdmi", .data = &imx_hdmi_devtype[IMX6DL_HDMI], },
-{ /* sentinel */ }
-};
-MODULE_DEVICE_TABLE(of, imx_hdmi_dt_ids);
-
-static int imx_hdmi_bind(struct device *dev, struct device *master, void *data)
+int imx_hdmi_bind(struct device *dev, struct device *master,
+		 void *data, struct drm_encoder *encoder,
+		 struct resource *iores, int irq,
+		 const struct dw_hdmi_plat_data *plat_data)
 {
-	struct platform_device *pdev = to_platform_device(dev);
-	const struct of_device_id *of_id =
-				of_match_device(imx_hdmi_dt_ids, dev);
 	struct drm_device *drm = data;
 	struct device_node *np = dev->of_node;
 	struct device_node *ddc_node;
 	struct imx_hdmi *hdmi;
-	struct resource *iores;
-	int ret, irq;
+	int ret;
 
 	hdmi = devm_kzalloc(dev, sizeof(*hdmi), GFP_KERNEL);
 	if (!hdmi)
 		return -ENOMEM;
 
+	hdmi->plat_data = plat_data;
 	hdmi->dev = dev;
+	hdmi->dev_type = plat_data->dev_type;
 	hdmi->sample_rate = 48000;
 	hdmi->ratio = 100;
-
-	if (of_id) {
-		const struct platform_device_id *device_id = of_id->data;
-
-		hdmi->dev_type = device_id->driver_data;
-	}
+	hdmi->encoder = encoder;
 
 	ddc_node = of_parse_phandle(np, "ddc-i2c-bus", 0);
 	if (ddc_node) {
@@ -1621,9 +1589,6 @@ static int imx_hdmi_bind(struct device *dev, struct device *master, void *data)
 		dev_dbg(hdmi->dev, "no ddc property found\n");
 	}
 
-	irq = platform_get_irq(pdev, 0);
-	if (irq < 0)
-		return irq;
 
 	ret = devm_request_threaded_irq(dev, irq, imx_hdmi_hardirq,
 					imx_hdmi_irq, IRQF_SHARED,
@@ -1631,15 +1596,10 @@ static int imx_hdmi_bind(struct device *dev, struct device *master, void *data)
 	if (ret)
 		return ret;
 
-	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	hdmi->regs = devm_ioremap_resource(dev, iores);
 	if (IS_ERR(hdmi->regs))
 		return PTR_ERR(hdmi->regs);
 
-	hdmi->regmap = syscon_regmap_lookup_by_phandle(np, "gpr");
-	if (IS_ERR(hdmi->regmap))
-		return PTR_ERR(hdmi->regmap);
-
 	hdmi->isfr_clk = devm_clk_get(hdmi->dev, "isfr");
 	if (IS_ERR(hdmi->isfr_clk)) {
 		ret = PTR_ERR(hdmi->isfr_clk);
@@ -1713,9 +1673,9 @@ err_isfr:
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(imx_hdmi_bind);
 
-static void imx_hdmi_unbind(struct device *dev, struct device *master,
-	void *data)
+void imx_hdmi_unbind(struct device *dev, struct device *master, void *data)
 {
 	struct imx_hdmi *hdmi = dev_get_drvdata(dev);
 
@@ -1723,42 +1683,17 @@ static void imx_hdmi_unbind(struct device *dev, struct device *master,
 	hdmi_writeb(hdmi, ~0, HDMI_IH_MUTE_PHY_STAT0);
 
 	hdmi->connector.funcs->destroy(&hdmi->connector);
-	hdmi->encoder.funcs->destroy(&hdmi->encoder);
+	hdmi->encoder->funcs->destroy(hdmi->encoder);
 
 	clk_disable_unprepare(hdmi->iahb_clk);
 	clk_disable_unprepare(hdmi->isfr_clk);
 	i2c_put_adapter(hdmi->ddc);
 }
-
-static const struct component_ops hdmi_ops = {
-	.bind	= imx_hdmi_bind,
-	.unbind	= imx_hdmi_unbind,
-};
-
-static int imx_hdmi_platform_probe(struct platform_device *pdev)
-{
-	return component_add(&pdev->dev, &hdmi_ops);
-}
-
-static int imx_hdmi_platform_remove(struct platform_device *pdev)
-{
-	component_del(&pdev->dev, &hdmi_ops);
-	return 0;
-}
-
-static struct platform_driver imx_hdmi_driver = {
-	.probe  = imx_hdmi_platform_probe,
-	.remove = imx_hdmi_platform_remove,
-	.driver = {
-		.name = "imx-hdmi",
-		.owner = THIS_MODULE,
-		.of_match_table = imx_hdmi_dt_ids,
-	},
-};
-
-module_platform_driver(imx_hdmi_driver);
+EXPORT_SYMBOL_GPL(imx_hdmi_unbind);
 
 MODULE_AUTHOR("Sascha Hauer <s.hauer@pengutronix.de>");
+MODULE_AUTHOR("Andy Yan <andy.yan@rock-chips.com>");
+MODULE_AUTHOR("Yakir Yang <ykk@rock-chips.com>");
 MODULE_DESCRIPTION("i.MX6 HDMI transmitter driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:imx-hdmi");
diff --git a/drivers/gpu/drm/imx/imx-hdmi.h b/drivers/gpu/drm/imx/imx-hdmi.h
index 39b6776..86c6c5b 100644
--- a/drivers/gpu/drm/imx/imx-hdmi.h
+++ b/drivers/gpu/drm/imx/imx-hdmi.h
@@ -1029,4 +1029,19 @@ enum {
 	HDMI_A_VIDPOLCFG_HSYNCPOL_ACTIVE_HIGH = 0x2,
 	HDMI_A_VIDPOLCFG_HSYNCPOL_ACTIVE_LOW = 0x0,
 };
+
+enum imx_hdmi_devtype {
+	IMX6Q_HDMI,
+	IMX6DL_HDMI,
+};
+
+struct imx_hdmi_plat_data {
+	enum imx_hdmi_devtype dev_type;
+};
+
+int imx_hdmi_bind(struct device *dev, struct device *master,
+		  void *data, struct drm_encoder *encoder,
+		  struct resource *iores, int irq,
+		  const struct imx_hdmi_plat_data *plat_data);
+void imx_hdmi_unbind(struct device *dev, struct device *master, void *data);
 #endif /* __IMX_HDMI_H__ */
diff --git a/drivers/gpu/drm/imx/imx-hdmi_pltfm.c b/drivers/gpu/drm/imx/imx-hdmi_pltfm.c
new file mode 100644
index 0000000..adea848
--- /dev/null
+++ b/drivers/gpu/drm/imx/imx-hdmi_pltfm.c
@@ -0,0 +1,204 @@
+/* Copyright (C) 2011-2013 Freescale Semiconductor, Inc.
+ *
+ * derived from imx-hdmi.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/component.h>
+#include <linux/mfd/syscon.h>
+#include <linux/mfd/syscon/imx6q-iomuxc-gpr.h>
+#include <video/imx-ipu-v3.h>
+#include <linux/regmap.h>
+#include <drm/drm_of.h>
+#include <drm/drmP.h>
+#include <drm/drm_crtc_helper.h>
+#include <drm/drm_edid.h>
+#include <drm/drm_encoder_slave.h>
+
+#include "imx-drm.h"
+#include "imx-hdmi.h"
+
+struct imx_hdmi_priv {
+	struct device *dev;
+	struct drm_encoder encoder;
+	struct regmap *regmap;
+};
+
+static int imx_hdmi_parse_dt(struct imx_hdmi_priv *hdmi)
+{
+	struct device_node *np = hdmi->dev->of_node;
+
+	hdmi->regmap = syscon_regmap_lookup_by_phandle(np, "gpr");
+	if (IS_ERR(hdmi->regmap)) {
+		dev_err(hdmi->dev, "Unable to get gpr\n");
+		return PTR_ERR(hdmi->regmap);
+	}
+
+	return 0;
+}
+
+static void imx_hdmi_encoder_disable(struct drm_encoder *encoder)
+{
+}
+
+static bool imx_hdmi_encoder_mode_fixup(struct drm_encoder *encoder,
+					const struct drm_display_mode *mode,
+					struct drm_display_mode *adjusted_mode)
+{
+	return true;
+}
+
+static void imx_hdmi_encoder_mode_set(struct drm_encoder *encoder,
+				      struct drm_display_mode *mode,
+				      struct drm_display_mode *adjusted_mode)
+{
+}
+
+static void imx_hdmi_encoder_commit(struct drm_encoder *encoder)
+{
+	struct imx_hdmi_priv *hdmi = container_of(encoder,
+						  struct imx_hdmi_priv,
+						  encoder);
+	int mux = imx_drm_encoder_get_mux_id(hdmi->dev->of_node, encoder);
+
+	regmap_update_bits(hdmi->regmap, IOMUXC_GPR3,
+			   IMX6Q_GPR3_HDMI_MUX_CTL_MASK,
+			   mux << IMX6Q_GPR3_HDMI_MUX_CTL_SHIFT);
+}
+
+static void imx_hdmi_encoder_prepare(struct drm_encoder *encoder)
+{
+	imx_drm_panel_format(encoder, V4L2_PIX_FMT_RGB24);
+}
+
+static struct drm_encoder_helper_funcs imx_hdmi_encoder_helper_funcs = {
+	.mode_fixup = imx_hdmi_encoder_mode_fixup,
+	.mode_set = imx_hdmi_encoder_mode_set,
+	.prepare = imx_hdmi_encoder_prepare,
+	.commit = imx_hdmi_encoder_commit,
+	.disable = imx_hdmi_encoder_disable,
+};
+
+static struct drm_encoder_funcs imx_hdmi_encoder_funcs = {
+	.destroy = drm_encoder_cleanup,
+};
+
+static struct imx_hdmi_plat_data imx6q_hdmi_drv_data = {
+	.dev_type = IMX6Q_HDMI,
+};
+
+static struct imx_hdmi_plat_data imx6dl_hdmi_drv_data = {
+	.dev_type = IMX6DL_HDMI,
+};
+
+static const struct of_device_id imx_hdmi_dt_ids[] = {
+	{ .compatible = "fsl,imx6q-hdmi",
+	  .data = &imx6q_hdmi_drv_data
+	}, {
+	  .compatible = "fsl,imx6dl-hdmi",
+	  .data = &imx6dl_hdmi_drv_data
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, imx_hdmi_dt_ids);
+
+static int imx_hdmi_pltfm_bind(struct device *dev, struct device *master,
+			       void *data)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	const struct imx_hdmi_plat_data *plat_data;
+	const struct of_device_id *match;
+	struct drm_device *drm = data;
+	struct drm_encoder *encoder;
+	struct imx_hdmi_priv *hdmi;
+	struct resource *iores;
+	int irq;
+	int ret;
+
+	if (!pdev->dev.of_node)
+		return -ENODEV;
+
+	hdmi = devm_kzalloc(&pdev->dev, sizeof(*hdmi), GFP_KERNEL);
+	if (!hdmi)
+		return -ENOMEM;
+
+	match = of_match_node(imx_hdmi_dt_ids, pdev->dev.of_node);
+	plat_data = match->data;
+	hdmi->dev = &pdev->dev;
+	encoder = &hdmi->encoder;
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return irq;
+
+	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!iores)
+		return -ENXIO;
+
+	platform_set_drvdata(pdev, hdmi);
+
+	encoder->possible_crtcs = drm_of_find_possible_crtcs(drm, dev->of_node);
+	/*
+	 * If we failed to find the CRTC(s) which this encoder is
+	 * supposed to be connected to, it's because the CRTC has
+	 * not been registered yet.  Defer probing, and hope that
+	 * the required CRTC is added later.
+	 */
+	if (encoder->possible_crtcs == 0)
+		return -EPROBE_DEFER;
+
+	ret = imx_hdmi_parse_dt(hdmi);
+	if (ret < 0)
+		return ret;
+
+	drm_encoder_helper_add(encoder, &imx_hdmi_encoder_helper_funcs);
+	drm_encoder_init(drm, encoder, &imx_hdmi_encoder_funcs,
+			 DRM_MODE_ENCODER_TMDS);
+
+	return imx_hdmi_bind(dev, master, data, encoder, iores, irq, plat_data);
+}
+
+static void imx_hdmi_pltfm_unbind(struct device *dev, struct device *master,
+				  void *data)
+{
+	return imx_hdmi_unbind(dev, master, data);
+}
+
+static const struct component_ops imx_hdmi_ops = {
+	.bind	= imx_hdmi_pltfm_bind,
+	.unbind	= imx_hdmi_pltfm_unbind,
+};
+
+static int imx_hdmi_probe(struct platform_device *pdev)
+{
+	return component_add(&pdev->dev, &imx_hdmi_ops);
+}
+
+static int imx_hdmi_remove(struct platform_device *pdev)
+{
+	component_del(&pdev->dev, &imx_hdmi_ops);
+
+	return 0;
+}
+
+static struct platform_driver imx_hdmi_pltfm_driver = {
+	.probe  = imx_hdmi_probe,
+	.remove = imx_hdmi_remove,
+	.driver = {
+		.name = "hdmi-imx",
+		.owner = THIS_MODULE,
+		.of_match_table = imx_hdmi_dt_ids,
+	},
+};
+
+module_platform_driver(imx_hdmi_pltfm_driver);
+
+MODULE_AUTHOR("Andy Yan <andy.yan@rock-chips.com>");
+MODULE_AUTHOR("Yakir Yang <ykk@rock-chips.com>");
+MODULE_DESCRIPTION("IMX6 Specific DW-HDMI Driver Extension");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:hdmi-imx");
-- 
1.9.1


