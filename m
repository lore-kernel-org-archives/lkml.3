Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727AbaLCPhc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 10:37:32 -0500
Received: from lucky1.263xmail.com ([211.157.147.130]:49449 "EHLO
	lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaLCPha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 10:37:30 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 1
X-MAIL-DELIVERY: 0
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: airlied@linux.ie
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <2ed7ed4c6faa6259378ea553ae6e7247>
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
        vladimir_zapolskiy@mentor.com, Kumar Gala <galak@codeaurora.org>,
        Andy Yan <andy.yan@rock-chips.com>
Subject: [PATCH v16 12/12] drm: bridge/dw_hdmi: add rockchip rk3288 support
Date: Wed,  3 Dec 2014 23:37:02 +0800
Message-Id: <1417621022-30922-1-git-send-email-andy.yan@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417620408-30354-1-git-send-email-andy.yan@rock-chips.com>
References: <1417620408-30354-1-git-send-email-andy.yan@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rockchip RK3288 hdmi is compatible with dw_hdmi

this patch is depend on patch by Mark Yao
see https://lkml.org/lkml/2014/12/2/161
drm: rockchip: Add basic drm driver

Signed-off-by: Andy Yan <andy.yan@rock-chips.com>

---

Changes in v16: None
Changes in v15:
- remove THIS_MODULE in platform driver

Changes in v14: None
Changes in v13: None
Changes in v12:
- add comment for the depend on patch

Changes in v11: None
Changes in v10:
- add more display mode support mpll configuration for rk3288

Changes in v9:
- move some phy configuration to platform driver

Changes in v8: None
Changes in v7: None
Changes in v6: None
Changes in v5: None
Changes in v4: None
Changes in v3: None

 drivers/gpu/drm/bridge/dw_hdmi.c            |   3 +
 drivers/gpu/drm/rockchip/Kconfig            |  10 +
 drivers/gpu/drm/rockchip/Makefile           |   2 +
 drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c | 321 ++++++++++++++++++++++++++++
 include/drm/bridge/dw_hdmi.h                |   1 +
 5 files changed, 337 insertions(+)
 create mode 100644 drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c

diff --git a/drivers/gpu/drm/bridge/dw_hdmi.c b/drivers/gpu/drm/bridge/dw_hdmi.c
index efc3b6f..1d5a6b3 100644
--- a/drivers/gpu/drm/bridge/dw_hdmi.c
+++ b/drivers/gpu/drm/bridge/dw_hdmi.c
@@ -852,6 +852,9 @@ static int hdmi_phy_configure(struct dw_hdmi *hdmi, unsigned char prep,
 	dw_hdmi_phy_gen2_txpwron(hdmi, 1);
 	dw_hdmi_phy_gen2_pddq(hdmi, 0);
 
+	if (hdmi->dev_type == RK3288_HDMI)
+		dw_hdmi_phy_enable_spare(hdmi, 1);
+
 	/*Wait for PHY PLL lock */
 	msec = 5;
 	do {
diff --git a/drivers/gpu/drm/rockchip/Kconfig b/drivers/gpu/drm/rockchip/Kconfig
index ca9f085..6ebebe8 100644
--- a/drivers/gpu/drm/rockchip/Kconfig
+++ b/drivers/gpu/drm/rockchip/Kconfig
@@ -15,3 +15,13 @@ config DRM_ROCKCHIP
 	  management to userspace. This driver does not provide
 	  2D or 3D acceleration; acceleration is performed by other
 	  IP found on the SoC.
+
+config ROCKCHIP_DW_HDMI
+        bool "Rockchip specific extensions for Synopsys DW HDMI"
+        depends on DRM_ROCKCHIP
+        select DRM_DW_HDMI
+        help
+	  This selects support for Rockchip SoC specific extensions
+	  for the Synopsys DesignWare HDMI driver. If you want to
+	  enable HDMI on RK3288 based SoC, you should selet this
+	  option.
diff --git a/drivers/gpu/drm/rockchip/Makefile b/drivers/gpu/drm/rockchip/Makefile
index 2cb0672..beed7df 100644
--- a/drivers/gpu/drm/rockchip/Makefile
+++ b/drivers/gpu/drm/rockchip/Makefile
@@ -5,4 +5,6 @@
 rockchipdrm-y := rockchip_drm_drv.o rockchip_drm_fb.o rockchip_drm_fbdev.o \
 		rockchip_drm_gem.o
 
+rockchipdrm-$(CONFIG_ROCKCHIP_DW_HDMI) += dw_hdmi-rockchip.o
+
 obj-$(CONFIG_DRM_ROCKCHIP) += rockchipdrm.o rockchip_drm_vop.o
diff --git a/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c b/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
new file mode 100644
index 0000000..3369a7e
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
@@ -0,0 +1,321 @@
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
+	struct regmap *regmap;
+	struct drm_encoder encoder;
+};
+
+#define to_rockchip_hdmi(x)	container_of(x, struct rockchip_hdmi, x)
+
+static const struct dw_hdmi_mpll_config rockchip_mpll_cfg[] = {
+	{
+		27000000, {
+			{ 0x00b3, 0x0000},
+			{ 0x2153, 0x0000},
+			{ 0x40f3, 0x0000}
+		},
+	}, {
+		36000000, {
+			{ 0x00b3, 0x0000},
+			{ 0x2153, 0x0000},
+			{ 0x40f3, 0x0000}
+		},
+	}, {
+		40000000, {
+			{ 0x00b3, 0x0000},
+			{ 0x2153, 0x0000},
+			{ 0x40f3, 0x0000}
+		},
+	}, {
+		54000000, {
+			{ 0x0072, 0x0001},
+			{ 0x2142, 0x0001},
+			{ 0x40a2, 0x0001},
+		},
+	}, {
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
+		108000000, {
+			{ 0x0051, 0x0002},
+			{ 0x2145, 0x0002},
+			{ 0x4061, 0x0002}
+		},
+	}, {
+		106500000, {
+			{ 0x0051, 0x0002},
+			{ 0x2145, 0x0002},
+			{ 0x4061, 0x0002}
+		},
+	}, {
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
+static const struct dw_hdmi_curr_ctrl rockchip_cur_ctr[] = {
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
+static const struct dw_hdmi_sym_term rockchip_sym_term[] = {
+	/*pixelclk   symbol   term*/
+	{ 74250000,  0x8009, 0x0004 },
+	{ 148500000, 0x8029, 0x0004 },
+	{ 297000000, 0x8039, 0x0005 },
+	{ ~0UL,	     0x0000, 0x0000 }
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
+	return 0;
+}
+
+static enum drm_mode_status
+dw_hdmi_rockchip_mode_valid(struct drm_connector *connector,
+			    struct drm_display_mode *mode)
+{
+	const struct dw_hdmi_mpll_config *mpll_cfg = rockchip_mpll_cfg;
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
+	.sym_term		= rockchip_sym_term,
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
index fff6ae6..ca98ee0 100644
--- a/include/drm/bridge/dw_hdmi.h
+++ b/include/drm/bridge/dw_hdmi.h
@@ -22,6 +22,7 @@ enum {
 enum dw_hdmi_devtype {
 	IMX6Q_HDMI,
 	IMX6DL_HDMI,
+	RK3288_HDMI,
 };
 
 struct dw_hdmi_mpll_config {
-- 
1.9.1


