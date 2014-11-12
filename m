Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbaKLMF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 07:05:58 -0500
Received: from regular1.263xmail.com ([211.150.99.138]:59253 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbaKLMF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 07:05:56 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: airlied@linux.ie
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <d49faea2c303de21386becf63967710c>
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
        linux-rockchip@lists.infradead.org, jay.xu@rock-chips.com,
        Pawel Moll <pawel.moll@arm.com>, mark.yao@rock-chips.com,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH v8 9/9] drm: bridge/dw_hdmi: add rockchip rk3288 support
Date: Wed, 12 Nov 2014 20:05:35 +0800
Message-Id: <1415793935-5495-1-git-send-email-andy.yan@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415793593-5075-1-git-send-email-andy.yan@rock-chips.com>
References: <1415793593-5075-1-git-send-email-andy.yan@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rk3288 hdmi is compatible with Designware hdmi

this patch is depend on patch by Mark Yao Add drm
driver for Rockchip Socs

see https://lkml.org/lkml/2014/10/8/201

Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
Signed-off-by: Yakir Yang <ykk@rock-chips.com>

---

Changes in v8:
- add support for rockchip rk3288 hdmi

Changes in v7: None
Changes in v6: None
Changes in v5: None
Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/gpu/drm/bridge/dw_hdmi.c            |  66 ++++--
 drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c | 319 ++++++++++++++++++++++++++++
 include/drm/bridge/dw_hdmi.h                |   1 +
 3 files changed, 374 insertions(+), 12 deletions(-)
 create mode 100644 drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c

diff --git a/drivers/gpu/drm/bridge/dw_hdmi.c b/drivers/gpu/drm/bridge/dw_hdmi.c
index ed75147..a8071c1 100644
--- a/drivers/gpu/drm/bridge/dw_hdmi.c
+++ b/drivers/gpu/drm/bridge/dw_hdmi.c
@@ -668,11 +668,15 @@ static inline void hdmi_phy_test_dout(struct dw_hdmi *hdmi,
 
 static bool hdmi_phy_wait_i2c_done(struct dw_hdmi *hdmi, int msec)
 {
-	while ((hdmi_readb(hdmi, HDMI_IH_I2CMPHY_STAT0) & 0x3) == 0) {
+	u32 val;
+
+	while ((val = hdmi_readb(hdmi, HDMI_IH_I2CMPHY_STAT0) & 0x3) == 0) {
 		if (msec-- == 0)
 			return false;
 		udelay(1000);
 	}
+	hdmi_writeb(hdmi, val, HDMI_IH_I2CMPHY_STAT0);
+
 	return true;
 }
 
@@ -815,24 +819,45 @@ static int hdmi_phy_configure(struct dw_hdmi *hdmi, unsigned char prep,
 
 	hdmi_phy_i2c_write(hdmi, 0x0000, 0x13);  /* PLLPHBYCTRL */
 	hdmi_phy_i2c_write(hdmi, 0x0006, 0x17);
-	/* RESISTANCE TERM 133Ohm Cfg */
-	hdmi_phy_i2c_write(hdmi, 0x0005, 0x19);  /* TXTERM */
-	/* PREEMP Cgf 0.00 */
-	hdmi_phy_i2c_write(hdmi, 0x800d, 0x09);  /* CKSYMTXCTRL */
+
+	if (hdmi->dev_type != RK3288_HDMI) {
+		/* RESISTANCE TERM 133Ohm Cfg */
+		hdmi_phy_i2c_write(hdmi, 0x0005, 0x19);  /* TXTERM */
+		/* PREEMP Cgf 0.00 */
+		hdmi_phy_i2c_write(hdmi, 0x800d, 0x09);  /* CKSYMTXCTRL */
+	} else {
+		if (curr_ctr[i].mpixelclock <= 74250000) {
+			/* RESISTANCE TERM 100Ohm Cfg */
+			hdmi_phy_i2c_write(hdmi, 0x0004, 0x19);
+			hdmi_phy_i2c_write(hdmi, 0x8009, 0x09);
+		} else if (curr_ctr[i].mpixelclock <= 148500000) {
+			/* RESISTANCE TERM 100Ohm Cfg */
+			hdmi_phy_i2c_write(hdmi, 0x0004, 0x19);
+			hdmi_phy_i2c_write(hdmi, 0x8029, 0x09);
+		} else {
+			/* RESISTANCE TERM 133Ohm Cfg */
+			hdmi_phy_i2c_write(hdmi, 0x0005, 0x19);
+			hdmi_phy_i2c_write(hdmi, 0x8039, 0x09);
+		}
+	}
 	/* TX/CK LVL 10 */
 	hdmi_phy_i2c_write(hdmi, 0x01ad, 0x0E);  /* VLEVCTRL */
 	/* REMOVE CLK TERM */
 	hdmi_phy_i2c_write(hdmi, 0x8000, 0x05);  /* CKCALCTRL */
 
-	dw_hdmi_phy_enable_power(hdmi, 1);
+	if (hdmi->dev_type != RK3288_HDMI) {
+		dw_hdmi_phy_enable_power(hdmi, 1);
 
-	/* toggle TMDS enable */
-	dw_hdmi_phy_enable_tmds(hdmi, 0);
-	dw_hdmi_phy_enable_tmds(hdmi, 1);
+		/* toggle TMDS enable */
+		dw_hdmi_phy_enable_tmds(hdmi, 0);
+		dw_hdmi_phy_enable_tmds(hdmi, 1);
 
-	/* gen2 tx power on */
-	dw_hdmi_phy_gen2_txpwron(hdmi, 1);
-	dw_hdmi_phy_gen2_pddq(hdmi, 0);
+		/* gen2 tx power on */
+		dw_hdmi_phy_gen2_txpwron(hdmi, 1);
+		dw_hdmi_phy_gen2_pddq(hdmi, 0);
+	} else {
+		hdmi_writeb(hdmi, 0x6e, HDMI_PHY_CONF0);
+	}
 
 	/*Wait for PHY PLL lock */
 	msec = 5;
@@ -1398,6 +1423,20 @@ static int dw_hdmi_connector_get_modes(struct drm_connector *connector)
 	return 0;
 }
 
+static enum drm_mode_status
+dw_hdmi_connector_mode_valid(struct drm_connector *connector,
+			     struct drm_display_mode *mode)
+{
+	struct dw_hdmi *hdmi = container_of(connector,
+					    struct dw_hdmi, connector);
+	enum drm_mode_status mode_status = MODE_OK;
+
+	if (hdmi->plat_data->mode_valid)
+		mode_status = hdmi->plat_data->mode_valid(connector, mode);
+
+	return mode_status;
+}
+
 static struct drm_encoder *dw_hdmi_connector_best_encoder(struct drm_connector
 							   *connector)
 {
@@ -1422,6 +1461,7 @@ static struct drm_connector_funcs dw_hdmi_connector_funcs = {
 
 static struct drm_connector_helper_funcs dw_hdmi_connector_helper_funcs = {
 	.get_modes = dw_hdmi_connector_get_modes,
+	.mode_valid = dw_hdmi_connector_mode_valid,
 	.best_encoder = dw_hdmi_connector_best_encoder,
 };
 
@@ -1514,6 +1554,8 @@ static int dw_hdmi_register(struct drm_device *drm, struct dw_hdmi *hdmi)
 
 	drm_mode_connector_attach_encoder(&hdmi->connector, encoder);
 
+	drm_connector_register(&hdmi->connector);
+
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c b/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
new file mode 100644
index 0000000..e5b01fc
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
@@ -0,0 +1,319 @@
+/*
+ * Copyright (c) 2014, Fuzhou Rockchip Electronics Co., Ltd
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/syscon.h>
+#include <linux/regmap.h>
+#include <linux/clk.h>
+#include <drm/drm_of.h>
+#include <drm/drmP.h>
+#include <drm/drm_crtc_helper.h>
+#include <drm/drm_edid.h>
+#include <drm/drm_encoder_slave.h>
+#include <drm/bridge/dw_hdmi.h>
+
+#include "rockchip_drm_drv.h"
+#include "rockchip_drm_vop.h"
+
+#define GRF_SOC_CON6                    0x025c
+#define HDMI_SEL_VOP_LIT                (1 << 4)
+
+struct rockchip_hdmi {
+	struct device *dev;
+	struct clk *clk;
+	struct clk *hdcp_clk;
+	struct regmap *regmap;
+	struct drm_encoder encoder;
+};
+
+#define to_rockchip_hdmi(x)	container_of(x, struct rockchip_hdmi, x)
+
+static const struct mpll_config rockchip_mpll_cfg[] = {
+	{
+		/* 27MHz & 36MHz & 40MHz */
+		40000000, {
+			{ 0x00b3, 0x0000},
+			{ 0x2153, 0x0000},
+			{ 0x40f3, 0x0000}
+		},
+	}, {
+		/* 54MHz & 65MHz */
+		65000000, {
+			{ 0x0072, 0x0001},
+			{ 0x2142, 0x0001},
+			{ 0x40a2, 0x0001},
+		},
+	}, {
+		66000000, {
+			{ 0x013e, 0x0003},
+			{ 0x217e, 0x0002},
+			{ 0x4061, 0x0002}
+		},
+	}, {
+		74250000, {
+			{ 0x0072, 0x0001},
+			{ 0x2145, 0x0002},
+			{ 0x4061, 0x0002}
+		},
+	}, {
+		83500000, {
+			{ 0x0072, 0x0001},
+		},
+	}, {
+		/* 108MHz & 106.5MHz & 146.25MHz */
+		146250000, {
+			{ 0x0051, 0x0002},
+			{ 0x2145, 0x0002},
+			{ 0x4061, 0x0002}
+		},
+	}, {
+		148500000, {
+			{ 0x0051, 0x0003},
+			{ 0x214c, 0x0003},
+			{ 0x4064, 0x0003}
+		},
+	}, {
+		~0UL, {
+			{ 0x00a0, 0x000a },
+			{ 0x2001, 0x000f },
+			{ 0x4002, 0x000f },
+		},
+	}
+};
+
+static const struct curr_ctrl rockchip_cur_ctr[] = {
+	/*      pixelclk    bpp8    bpp10   bpp12 */
+	{
+		40000000,  { 0x0018, 0x0018, 0x0018 },
+	}, {
+		65000000,  { 0x0028, 0x0028, 0x0028 },
+	}, {
+		66000000,  { 0x0038, 0x0038, 0x0038 },
+	}, {
+		74250000,  { 0x0028, 0x0038, 0x0038 },
+	}, {
+		83500000,  { 0x0028, 0x0038, 0x0038 },
+	}, {
+		146250000, { 0x0038, 0x0038, 0x0038 },
+	}, {
+		148500000, { 0x0000, 0x0038, 0x0038 },
+	}, {
+		~0UL,      { 0x0000, 0x0000, 0x0000},
+	}
+};
+
+static int rockchip_hdmi_parse_dt(struct rockchip_hdmi *hdmi)
+{
+	struct device_node *np = hdmi->dev->of_node;
+
+	hdmi->regmap = syscon_regmap_lookup_by_phandle(np, "rockchip,grf");
+	if (IS_ERR(hdmi->regmap)) {
+		dev_err(hdmi->dev, "Unable to get rockchip,grf\n");
+		return PTR_ERR(hdmi->regmap);
+	}
+
+	hdmi->clk = devm_clk_get(hdmi->dev, "clk");
+	if (IS_ERR(hdmi->clk)) {
+		dev_err(hdmi->dev, "Unable to get HDMI clk\n");
+	       return PTR_ERR(hdmi->clk);
+	}
+
+	hdmi->hdcp_clk = devm_clk_get(hdmi->dev, "hdcp_clk");
+	if (IS_ERR(hdmi->hdcp_clk)) {
+		dev_err(hdmi->dev, "Unable to get HDMI iahb clk\n");
+		return PTR_ERR(hdmi->hdcp_clk);
+	}
+
+	return 0;
+}
+
+static enum drm_mode_status
+dw_hdmi_rockchip_mode_valid(struct drm_connector *connector,
+			    struct drm_display_mode *mode)
+{
+	const struct mpll_config *mpll_cfg = rockchip_mpll_cfg;
+	int pclk = mode->clock * 1000;
+	bool valid = false;
+	int i;
+
+	for (i = 0; mpll_cfg[i].mpixelclock != (~0UL); i++) {
+		if (pclk == mpll_cfg[i].mpixelclock) {
+			valid = true;
+			break;
+		}
+	}
+
+	return (valid) ? MODE_OK : MODE_BAD;
+}
+
+static struct drm_encoder_funcs dw_hdmi_encoder_funcs = {
+	.destroy = drm_encoder_cleanup,
+};
+
+static void dw_hdmi_rockchip_disable(struct drm_encoder *encoder)
+{
+}
+
+static bool dw_hdmi_rockchip_mode_fixup(struct drm_encoder *encoder,
+					const struct drm_display_mode *mode,
+					struct drm_display_mode *adjusted_mode)
+{
+	return true;
+}
+
+static void dw_hdmi_rockchip_mode_set(struct drm_encoder *encoder,
+				      struct drm_display_mode *mode,
+				      struct drm_display_mode *adjusted_mode)
+{
+}
+
+static void dw_hdmi_rockchip_commit(struct drm_encoder *encoder)
+{
+	struct rockchip_hdmi *hdmi = to_rockchip_hdmi(encoder);
+	u32 val;
+	int mux;
+
+	mux = rockchip_drm_encoder_get_mux_id(hdmi->dev->of_node, encoder);
+	if (mux)
+		val = HDMI_SEL_VOP_LIT | (HDMI_SEL_VOP_LIT << 16);
+	else
+		val = HDMI_SEL_VOP_LIT << 16;
+
+	regmap_write(hdmi->regmap, GRF_SOC_CON6, val);
+	dev_dbg(hdmi->dev, "vop %s output to hdmi\n",
+		(mux) ? "LIT" : "BIG");
+}
+
+static void dw_hdmi_rockchip_prepare(struct drm_encoder *encoder)
+{
+	rockchip_drm_crtc_mode_config(encoder->crtc, DRM_MODE_CONNECTOR_HDMIA,
+				      ROCKCHIP_OUT_MODE_AAAA);
+}
+
+static struct drm_encoder_helper_funcs dw_hdmi_encoder_helper_funcs = {
+	.mode_fixup = dw_hdmi_rockchip_mode_fixup,
+	.mode_set = dw_hdmi_rockchip_mode_set,
+	.prepare = dw_hdmi_rockchip_prepare,
+	.commit = dw_hdmi_rockchip_commit,
+	.disable = dw_hdmi_rockchip_disable,
+};
+
+static const struct dw_hdmi_plat_data rockchip_hdmi_drv_data = {
+	.mode_valid		= dw_hdmi_rockchip_mode_valid,
+	.mpll_cfg		= rockchip_mpll_cfg,
+	.cur_ctr		= rockchip_cur_ctr,
+	.dev_type		= RK3288_HDMI,
+};
+
+static const struct of_device_id dw_hdmi_rockchip_ids[] = {
+	{ .compatible = "rockchip,rk3288-dw-hdmi",
+	  .data = &rockchip_hdmi_drv_data
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, dw_hdmi_rockchip_dt_ids);
+
+static int dw_hdmi_rockchip_bind(struct device *dev, struct device *master,
+				 void *data)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	const struct dw_hdmi_plat_data *plat_data;
+	const struct of_device_id *match;
+	struct drm_device *drm = data;
+	struct drm_encoder *encoder;
+	struct rockchip_hdmi *hdmi;
+	int ret;
+
+	if (!pdev->dev.of_node)
+		return -ENODEV;
+
+	hdmi = devm_kzalloc(&pdev->dev, sizeof(*hdmi), GFP_KERNEL);
+	if (!hdmi)
+		return -ENOMEM;
+
+	match = of_match_node(dw_hdmi_rockchip_ids, pdev->dev.of_node);
+	plat_data = match->data;
+	hdmi->dev = &pdev->dev;
+	encoder = &hdmi->encoder;
+	platform_set_drvdata(pdev, hdmi);
+
+	ret = rockchip_hdmi_parse_dt(hdmi);
+	if (ret) {
+		dev_err(hdmi->dev, "Unable to parse OF data\n");
+		return ret;
+	}
+
+	ret = clk_prepare_enable(hdmi->clk);
+	if (ret) {
+		dev_err(hdmi->dev, "Cannot enable HDMI clock: %d\n", ret);
+		return ret;
+	}
+
+	ret = clk_prepare_enable(hdmi->hdcp_clk);
+	if (ret) {
+		dev_err(hdmi->dev, "Cannot enable HDMI hdcp clock: %d\n", ret);
+		return ret;
+	}
+
+	encoder->possible_crtcs = drm_of_find_possible_crtcs(drm, dev->of_node);
+
+	drm_encoder_helper_add(encoder, &dw_hdmi_encoder_helper_funcs);
+	drm_encoder_init(drm, encoder, &dw_hdmi_encoder_funcs,
+			 DRM_MODE_ENCODER_TMDS);
+
+	return dw_hdmi_bind(dev, master, data, encoder, plat_data);
+}
+
+static void dw_hdmi_rockchip_unbind(struct device *dev, struct device *master,
+				    void *data)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct rockchip_hdmi *hdmi = platform_get_drvdata(pdev);
+
+	clk_disable_unprepare(hdmi->clk);
+	clk_disable_unprepare(hdmi->hdcp_clk);
+
+	return dw_hdmi_unbind(dev, master, data);
+}
+
+static const struct component_ops dw_hdmi_rockchip_ops = {
+	.bind	= dw_hdmi_rockchip_bind,
+	.unbind	= dw_hdmi_rockchip_unbind,
+};
+
+static int dw_hdmi_rockchip_probe(struct platform_device *pdev)
+{
+	return component_add(&pdev->dev, &dw_hdmi_rockchip_ops);
+}
+
+static int dw_hdmi_rockchip_remove(struct platform_device *pdev)
+{
+	component_del(&pdev->dev, &dw_hdmi_rockchip_ops);
+
+	return 0;
+}
+
+static struct platform_driver dw_hdmi_rockchip_pltfm_driver = {
+	.probe  = dw_hdmi_rockchip_probe,
+	.remove = dw_hdmi_rockchip_remove,
+	.driver = {
+		.name = "dwhdmi-rockchip",
+		.owner = THIS_MODULE,
+		.of_match_table = dw_hdmi_rockchip_ids,
+	},
+};
+
+module_platform_driver(dw_hdmi_rockchip_pltfm_driver);
+
+MODULE_AUTHOR("Andy Yan <andy.yan@rock-chips.com>");
+MODULE_AUTHOR("Yakir Yang <ykk@rock-chips.com>");
+MODULE_DESCRIPTION("Rockchip Specific DW-HDMI Driver Extension");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:dwhdmi-rockchip");
diff --git a/include/drm/bridge/dw_hdmi.h b/include/drm/bridge/dw_hdmi.h
index e26e61f..f72cd10 100644
--- a/include/drm/bridge/dw_hdmi.h
+++ b/include/drm/bridge/dw_hdmi.h
@@ -22,6 +22,7 @@ enum {
 enum dw_hdmi_devtype {
 	IMX6Q_HDMI,
 	IMX6DL_HDMI,
+	RK3288_HDMI,
 };
 
 struct mpll_config {
-- 
1.9.1


