Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbaKHF3G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 00:29:06 -0500
Received: from va-smtp01.263.net ([54.88.144.211]:41654 "EHLO
	va-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbaKHF3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 00:29:03 -0500
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: airlied@linux.ie
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <39896fd6ffcee5c78abde7d072dfd222>
X-DNS-TYPE: 1
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
Subject: [PATCH V5 1/7] imx-drm: imx-hdmi: split imx soc specific code from imx-hdmi
Date: Sat,  8 Nov 2014 13:28:43 +0800
Message-Id: <1415424523-7440-1-git-send-email-andy.yan@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415424410-7364-1-git-send-email-andy.yan@rock-chips.com>
References: <1415424410-7364-1-git-send-email-andy.yan@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

imx6 and rockchip rk3288 and JZ4780 (Ingenic Xburst/MIPS)
use the interface compatible Designware HDMI IP, but they
also have some lightly difference, such as phy pll configuration,
register width, 4K support, clk useage, and the crtc mux configuration
is also platform specific.

To reuse the imx hdmi driver, split the platform specific code out
to dw_hdmi-imx.c.

Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
---
 drivers/staging/imx-drm/Makefile      |   2 +-
 drivers/staging/imx-drm/dw_hdmi-imx.c | 214 ++++++++++++++++++++++++++++
 drivers/staging/imx-drm/imx-hdmi.c    | 257 ++++++++--------------------------
 drivers/staging/imx-drm/imx-hdmi.h    |  43 ++++++
 4 files changed, 320 insertions(+), 196 deletions(-)
 create mode 100644 drivers/staging/imx-drm/dw_hdmi-imx.c

diff --git a/drivers/staging/imx-drm/Makefile b/drivers/staging/imx-drm/Makefile
index 582c438..809027d 100644
--- a/drivers/staging/imx-drm/Makefile
+++ b/drivers/staging/imx-drm/Makefile
@@ -9,4 +9,4 @@ obj-$(CONFIG_DRM_IMX_LDB) += imx-ldb.o
 
 imx-ipuv3-crtc-objs  := ipuv3-crtc.o ipuv3-plane.o
 obj-$(CONFIG_DRM_IMX_IPUV3)	+= imx-ipuv3-crtc.o
-obj-$(CONFIG_DRM_IMX_HDMI) += imx-hdmi.o
+obj-$(CONFIG_DRM_IMX_HDMI) += imx-hdmi.o dw_hdmi-imx.o
diff --git a/drivers/staging/imx-drm/dw_hdmi-imx.c b/drivers/staging/imx-drm/dw_hdmi-imx.c
new file mode 100644
index 0000000..5422679
--- /dev/null
+++ b/drivers/staging/imx-drm/dw_hdmi-imx.c
@@ -0,0 +1,214 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/syscon.h>
+#include <linux/mfd/syscon/imx6q-iomuxc-gpr.h>
+#include <video/imx-ipu-v3.h>
+#include <linux/regmap.h>
+#include <linux/clk.h>
+
+#include "imx-drm.h"
+#include "imx-hdmi.h"
+
+struct imx_hdmi_priv {
+	struct device *dev;
+	struct clk *isfr_clk;
+	struct clk *iahb_clk;
+	struct regmap *regmap;
+};
+
+static const struct mpll_config imx_mpll_cfg[] = {
+	{
+		45250000, {
+			{ 0x01e0, 0x0000 },
+			{ 0x21e1, 0x0000 },
+			{ 0x41e2, 0x0000 }
+		},
+	}, {
+		92500000, {
+			{ 0x0140, 0x0005 },
+			{ 0x2141, 0x0005 },
+			{ 0x4142, 0x0005 },
+	},
+	}, {
+		148500000, {
+			{ 0x00a0, 0x000a },
+			{ 0x20a1, 0x000a },
+			{ 0x40a2, 0x000a },
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
+static const struct curr_ctrl imx_cur_ctr[] = {
+	/*      pixelclk     bpp8    bpp10   bpp12 */
+	{
+		54000000, { 0x091c, 0x091c, 0x06dc },
+	}, {
+		58400000, { 0x091c, 0x06dc, 0x06dc },
+	}, {
+		72000000, { 0x06dc, 0x06dc, 0x091c },
+	}, {
+		74250000, { 0x06dc, 0x0b5c, 0x091c },
+	}, {
+		118800000, { 0x091c, 0x091c, 0x06dc },
+	}, {
+		216000000, { 0x06dc, 0x0b5c, 0x091c },
+	}
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
+	hdmi->isfr_clk = devm_clk_get(hdmi->dev, "isfr");
+	if (IS_ERR(hdmi->isfr_clk)) {
+		dev_err(hdmi->dev, "Unable to get HDMI isfr clk\n");
+		return PTR_ERR(hdmi->isfr_clk);
+	}
+
+	hdmi->iahb_clk = devm_clk_get(hdmi->dev, "iahb");
+	if (IS_ERR(hdmi->iahb_clk)) {
+		dev_err(hdmi->dev, "Unable to get HDMI iahb clk\n");
+		return PTR_ERR(hdmi->iahb_clk);
+	}
+
+	return 0;
+}
+
+static void *imx_hdmi_imx_setup(struct platform_device *pdev)
+{
+	struct imx_hdmi_priv *hdmi;
+	int ret;
+
+	hdmi = devm_kzalloc(&pdev->dev, sizeof(*hdmi), GFP_KERNEL);
+	if (!hdmi)
+		return ERR_PTR(-ENOMEM);
+	hdmi->dev = &pdev->dev;
+
+	ret = imx_hdmi_parse_dt(hdmi);
+	if (ret < 0)
+		return ERR_PTR(ret);
+	ret = clk_prepare_enable(hdmi->isfr_clk);
+	if (ret) {
+		dev_err(hdmi->dev,
+			"Cannot enable HDMI isfr clock: %d\n", ret);
+		return ERR_PTR(ret);
+	}
+
+	ret = clk_prepare_enable(hdmi->iahb_clk);
+	if (ret) {
+		dev_err(hdmi->dev,
+			"Cannot enable HDMI iahb clock: %d\n", ret);
+		return ERR_PTR(ret);
+	}
+
+	return hdmi;
+}
+
+static void imx_hdmi_imx_exit(void *priv)
+{
+	struct imx_hdmi_priv *hdmi = (struct imx_hdmi_priv *)priv;
+
+	clk_disable_unprepare(hdmi->isfr_clk);
+
+	clk_disable_unprepare(hdmi->iahb_clk);
+}
+
+static void imx_hdmi_imx_encoder_commit(void *priv, struct drm_encoder *encoder)
+{
+	struct imx_hdmi_priv *hdmi = (struct imx_hdmi_priv *)priv;
+	int mux = imx_drm_encoder_get_mux_id(hdmi->dev->of_node, encoder);
+
+	regmap_update_bits(hdmi->regmap, IOMUXC_GPR3,
+			   IMX6Q_GPR3_HDMI_MUX_CTL_MASK,
+			   mux << IMX6Q_GPR3_HDMI_MUX_CTL_SHIFT);
+}
+
+static void imx_hdmi_imx_encoder_prepare(struct drm_connector *connector,
+					 struct drm_encoder *encoder)
+{
+	imx_drm_panel_format(encoder, V4L2_PIX_FMT_RGB24);
+}
+
+static struct imx_hdmi_plat_data imx6q_hdmi_drv_data = {
+	.setup			= imx_hdmi_imx_setup,
+	.exit			= imx_hdmi_imx_exit,
+	.encoder_commit		= imx_hdmi_imx_encoder_commit,
+	.encoder_prepare	= imx_hdmi_imx_encoder_prepare,
+	.mpll_cfg		= imx_mpll_cfg,
+	.cur_ctr		= imx_cur_ctr,
+	.dev_type		= IMX6Q_HDMI,
+};
+
+static struct imx_hdmi_plat_data imx6dl_hdmi_drv_data = {
+	.setup			= imx_hdmi_imx_setup,
+	.exit			= imx_hdmi_imx_exit,
+	.encoder_commit		= imx_hdmi_imx_encoder_commit,
+	.encoder_prepare	= imx_hdmi_imx_encoder_prepare,
+	.mpll_cfg		= imx_mpll_cfg,
+	.cur_ctr		= imx_cur_ctr,
+	.dev_type		= IMX6DL_HDMI,
+};
+
+static const struct of_device_id imx_hdmi_imx_ids[] = {
+	{ .compatible = "fsl,imx6q-hdmi",
+	  .data = &imx6q_hdmi_drv_data
+	}, {
+	  .compatible = "fsl,imx6dl-hdmi",
+	  .data = &imx6dl_hdmi_drv_data
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, imx_hdmi_imx_dt_ids);
+
+static int imx_hdmi_imx_probe(struct platform_device *pdev)
+{
+	const struct imx_hdmi_plat_data *plat_data;
+	const struct of_device_id *match;
+
+	if (!pdev->dev.of_node)
+		return -ENODEV;
+
+	match = of_match_node(imx_hdmi_imx_ids, pdev->dev.of_node);
+	plat_data = match->data;
+
+	return imx_hdmi_platform_register(pdev, plat_data);
+}
+
+static int imx_hdmi_imx_remove(struct platform_device *pdev)
+{
+	return imx_hdmi_platform_unregister(pdev);
+}
+
+static struct platform_driver imx_hdmi_imx_platform_driver = {
+	.probe  = imx_hdmi_imx_probe,
+	.remove = imx_hdmi_imx_remove,
+	.driver = {
+		.name = "dwhdmi-imx",
+		.owner = THIS_MODULE,
+		.of_match_table = imx_hdmi_imx_ids,
+	},
+};
+
+module_platform_driver(imx_hdmi_imx_platform_driver);
+
+MODULE_AUTHOR("Andy Yan <andy.yan@rock-chips.com>");
+MODULE_DESCRIPTION("IMX6 Specific DW-HDMI Driver Extension");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:dwhdmi-imx");
diff --git a/drivers/staging/imx-drm/imx-hdmi.c b/drivers/staging/imx-drm/imx-hdmi.c
index aaec6b2..cd9cf86 100644
--- a/drivers/staging/imx-drm/imx-hdmi.c
+++ b/drivers/staging/imx-drm/imx-hdmi.c
@@ -16,23 +16,17 @@
 #include <linux/irq.h>
 #include <linux/delay.h>
 #include <linux/err.h>
-#include <linux/clk.h>
 #include <linux/hdmi.h>
-#include <linux/regmap.h>
-#include <linux/mfd/syscon.h>
-#include <linux/mfd/syscon/imx6q-iomuxc-gpr.h>
 #include <linux/of_device.h>
-
+#include <drm/drm_of.h>
 #include <drm/drmP.h>
 #include <drm/drm_crtc_helper.h>
 #include <drm/drm_edid.h>
 #include <drm/drm_encoder_slave.h>
-#include <video/imx-ipu-v3.h>
 
 #include "imx-hdmi.h"
-#include "imx-drm.h"
 
-#define HDMI_EDID_LEN		512
+#define HDMI_EDID_LEN          512
 
 #define RGB			0
 #define YCBCR444		1
@@ -54,11 +48,6 @@ enum hdmi_datamap {
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
@@ -121,6 +110,8 @@ struct imx_hdmi {
 	struct clk *iahb_clk;
 
 	struct hdmi_data_info hdmi_data;
+	const struct imx_hdmi_plat_data *plat_data;
+	void *priv;
 	int vic;
 
 	u8 edid[HDMI_EDID_LEN];
@@ -137,13 +128,6 @@ struct imx_hdmi {
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
@@ -728,76 +712,13 @@ static void imx_hdmi_phy_sel_interface_control(struct imx_hdmi *hdmi, u8 enable)
 			 HDMI_PHY_CONF0_SELDIPIF_MASK);
 }
 
-enum {
-	RES_8,
-	RES_10,
-	RES_12,
-	RES_MAX,
-};
-
-struct mpll_config {
-	unsigned long mpixelclock;
-	struct {
-		u16 cpce;
-		u16 gmp;
-	} res[RES_MAX];
-};
-
-static const struct mpll_config mpll_config[] = {
-	{
-		45250000, {
-			{ 0x01e0, 0x0000 },
-			{ 0x21e1, 0x0000 },
-			{ 0x41e2, 0x0000 }
-		},
-	}, {
-		92500000, {
-			{ 0x0140, 0x0005 },
-			{ 0x2141, 0x0005 },
-			{ 0x4142, 0x0005 },
-		},
-	}, {
-		148500000, {
-			{ 0x00a0, 0x000a },
-			{ 0x20a1, 0x000a },
-			{ 0x40a2, 0x000a },
-		},
-	}, {
-		~0UL, {
-			{ 0x00a0, 0x000a },
-			{ 0x2001, 0x000f },
-			{ 0x4002, 0x000f },
-		},
-	}
-};
-
-struct curr_ctrl {
-	unsigned long mpixelclock;
-	u16 curr[RES_MAX];
-};
-
-static const struct curr_ctrl curr_ctrl[] = {
-	/*	pixelclk     bpp8    bpp10   bpp12 */
-	{
-		 54000000, { 0x091c, 0x091c, 0x06dc },
-	}, {
-		 58400000, { 0x091c, 0x06dc, 0x06dc },
-	}, {
-		 72000000, { 0x06dc, 0x06dc, 0x091c },
-	}, {
-		 74250000, { 0x06dc, 0x0b5c, 0x091c },
-	}, {
-		118800000, { 0x091c, 0x091c, 0x06dc },
-	}, {
-		216000000, { 0x06dc, 0x0b5c, 0x091c },
-	}
-};
-
 static int hdmi_phy_configure(struct imx_hdmi *hdmi, unsigned char prep,
 			      unsigned char res, int cscon)
 {
 	unsigned res_idx, i;
 	u8 val, msec;
+	const struct mpll_config *mpll_cfg = hdmi->plat_data->mpll_cfg;
+	const struct curr_ctrl   *curr_ctr = hdmi->plat_data->cur_ctr;
 
 	if (prep)
 		return -EINVAL;
@@ -843,20 +764,19 @@ static int hdmi_phy_configure(struct imx_hdmi *hdmi, unsigned char prep,
 	hdmi_phy_test_clear(hdmi, 0);
 
 	/* PLL/MPLL Cfg - always match on final entry */
-	for (i = 0; i < ARRAY_SIZE(mpll_config) - 1; i++)
+	for (i = 0; mpll_cfg[i].mpixelclock != (~0UL); i++)
 		if (hdmi->hdmi_data.video_mode.mpixelclock <=
-		    mpll_config[i].mpixelclock)
+		    mpll_cfg[i].mpixelclock)
 			break;
+	hdmi_phy_i2c_write(hdmi, mpll_cfg[i].res[res_idx].cpce, 0x06);
+	hdmi_phy_i2c_write(hdmi, mpll_cfg[i].res[res_idx].gmp, 0x15);
 
-	hdmi_phy_i2c_write(hdmi, mpll_config[i].res[res_idx].cpce, 0x06);
-	hdmi_phy_i2c_write(hdmi, mpll_config[i].res[res_idx].gmp, 0x15);
-
-	for (i = 0; i < ARRAY_SIZE(curr_ctrl); i++)
+	for (i = 0; curr_ctr[i].mpixelclock != (~0UL); i++)
 		if (hdmi->hdmi_data.video_mode.mpixelclock <=
-		    curr_ctrl[i].mpixelclock)
+		    curr_ctr[i].mpixelclock)
 			break;
 
-	if (i >= ARRAY_SIZE(curr_ctrl)) {
+	if (curr_ctr[i].mpixelclock == (~0UL)) {
 		dev_err(hdmi->dev,
 				"Pixel clock %d - unsupported by HDMI\n",
 				hdmi->hdmi_data.video_mode.mpixelclock);
@@ -864,7 +784,7 @@ static int hdmi_phy_configure(struct imx_hdmi *hdmi, unsigned char prep,
 	}
 
 	/* CURRCTRL */
-	hdmi_phy_i2c_write(hdmi, curr_ctrl[i].curr[res_idx], 0x10);
+	hdmi_phy_i2c_write(hdmi, curr_ctr[i].curr[res_idx], 0x10);
 
 	hdmi_phy_i2c_write(hdmi, 0x0000, 0x13);  /* PLLPHBYCTRL */
 	hdmi_phy_i2c_write(hdmi, 0x0006, 0x17);
@@ -1454,21 +1374,29 @@ static void imx_hdmi_encoder_prepare(struct drm_encoder *encoder)
 	struct imx_hdmi *hdmi = container_of(encoder, struct imx_hdmi, encoder);
 
 	imx_hdmi_poweroff(hdmi);
-	imx_drm_panel_format(encoder, V4L2_PIX_FMT_RGB24);
+
+	if (hdmi->plat_data->encoder_prepare)
+		hdmi->plat_data->encoder_prepare(&hdmi->connector, encoder);
 }
 
 static void imx_hdmi_encoder_commit(struct drm_encoder *encoder)
 {
 	struct imx_hdmi *hdmi = container_of(encoder, struct imx_hdmi, encoder);
-	int mux = imx_drm_encoder_get_mux_id(hdmi->dev->of_node, encoder);
 
-	imx_hdmi_set_ipu_di_mux(hdmi, mux);
+	if (hdmi->plat_data->encoder_commit)
+		hdmi->plat_data->encoder_commit(hdmi->priv, encoder);
 
 	imx_hdmi_poweron(hdmi);
 }
 
+void imx_hdmi_connector_destroy(struct drm_connector *connector)
+{
+	drm_connector_unregister(connector);
+	drm_connector_cleanup(connector);
+}
+
 static struct drm_encoder_funcs imx_hdmi_encoder_funcs = {
-	.destroy = imx_drm_encoder_destroy,
+	.destroy = drm_encoder_cleanup,
 };
 
 static struct drm_encoder_helper_funcs imx_hdmi_encoder_helper_funcs = {
@@ -1484,7 +1412,7 @@ static struct drm_connector_funcs imx_hdmi_connector_funcs = {
 	.dpms = drm_helper_connector_dpms,
 	.fill_modes = drm_helper_probe_single_connector_modes,
 	.detect = imx_hdmi_connector_detect,
-	.destroy = imx_drm_connector_destroy,
+	.destroy = imx_hdmi_connector_destroy,
 };
 
 static struct drm_connector_helper_funcs imx_hdmi_connector_helper_funcs = {
@@ -1540,12 +1468,10 @@ static irqreturn_t imx_hdmi_irq(int irq, void *dev_id)
 
 static int imx_hdmi_register(struct drm_device *drm, struct imx_hdmi *hdmi)
 {
-	int ret;
+	struct drm_encoder *encoder = &hdmi->encoder;
+	struct device *dev = hdmi->dev;
 
-	ret = imx_drm_encoder_parse_of(drm, &hdmi->encoder,
-				       hdmi->dev->of_node);
-	if (ret)
-		return ret;
+	encoder->possible_crtcs = drm_of_find_possible_crtcs(drm, dev->of_node);
 
 	hdmi->connector.polled = DRM_CONNECTOR_POLL_HPD;
 
@@ -1565,50 +1491,16 @@ static int imx_hdmi_register(struct drm_device *drm, struct imx_hdmi *hdmi)
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
 static int imx_hdmi_bind(struct device *dev, struct device *master, void *data)
 {
 	struct platform_device *pdev = to_platform_device(dev);
-	const struct of_device_id *of_id =
-				of_match_device(imx_hdmi_dt_ids, dev);
+	struct imx_hdmi *hdmi = platform_get_drvdata(pdev);
 	struct drm_device *drm = data;
 	struct device_node *np = dev->of_node;
 	struct device_node *ddc_node;
-	struct imx_hdmi *hdmi;
 	struct resource *iores;
 	int ret, irq;
 
-	hdmi = devm_kzalloc(dev, sizeof(*hdmi), GFP_KERNEL);
-	if (!hdmi)
-		return -ENOMEM;
-
-	hdmi->dev = dev;
-	hdmi->sample_rate = 48000;
-	hdmi->ratio = 100;
-
-	if (of_id) {
-		const struct platform_device_id *device_id = of_id->data;
-
-		hdmi->dev_type = device_id->driver_data;
-	}
-
 	ddc_node = of_parse_phandle(np, "ddc-i2c-bus", 0);
 	if (ddc_node) {
 		hdmi->ddc = of_find_i2c_adapter_by_node(ddc_node);
@@ -1635,40 +1527,8 @@ static int imx_hdmi_bind(struct device *dev, struct device *master, void *data)
 	if (IS_ERR(hdmi->regs))
 		return PTR_ERR(hdmi->regs);
 
-	hdmi->regmap = syscon_regmap_lookup_by_phandle(np, "gpr");
-	if (IS_ERR(hdmi->regmap))
-		return PTR_ERR(hdmi->regmap);
-
-	hdmi->isfr_clk = devm_clk_get(hdmi->dev, "isfr");
-	if (IS_ERR(hdmi->isfr_clk)) {
-		ret = PTR_ERR(hdmi->isfr_clk);
-		dev_err(hdmi->dev,
-			"Unable to get HDMI isfr clk: %d\n", ret);
-		return ret;
-	}
-
-	ret = clk_prepare_enable(hdmi->isfr_clk);
-	if (ret) {
-		dev_err(hdmi->dev,
-			"Cannot enable HDMI isfr clock: %d\n", ret);
-		return ret;
-	}
-
-	hdmi->iahb_clk = devm_clk_get(hdmi->dev, "iahb");
-	if (IS_ERR(hdmi->iahb_clk)) {
-		ret = PTR_ERR(hdmi->iahb_clk);
-		dev_err(hdmi->dev,
-			"Unable to get HDMI iahb clk: %d\n", ret);
-		goto err_isfr;
-	}
-
-	ret = clk_prepare_enable(hdmi->iahb_clk);
-	if (ret) {
-		dev_err(hdmi->dev,
-			"Cannot enable HDMI iahb clock: %d\n", ret);
-		goto err_isfr;
-	}
-
+	if (hdmi->plat_data->setup)
+		hdmi->priv = hdmi->plat_data->setup(pdev);
 	/* Product and revision IDs */
 	dev_info(dev,
 		"Detected HDMI controller 0x%x:0x%x:0x%x:0x%x\n",
@@ -1696,11 +1556,11 @@ static int imx_hdmi_bind(struct device *dev, struct device *master, void *data)
 
 	ret = imx_hdmi_fb_registered(hdmi);
 	if (ret)
-		goto err_iahb;
+		return ret;
 
 	ret = imx_hdmi_register(drm, hdmi);
 	if (ret)
-		goto err_iahb;
+		return ret;
 
 	/* Unmute interrupts */
 	hdmi_writeb(hdmi, ~HDMI_IH_PHY_STAT0_HPD, HDMI_IH_MUTE_PHY_STAT0);
@@ -1708,13 +1568,6 @@ static int imx_hdmi_bind(struct device *dev, struct device *master, void *data)
 	dev_set_drvdata(dev, hdmi);
 
 	return 0;
-
-err_iahb:
-	clk_disable_unprepare(hdmi->iahb_clk);
-err_isfr:
-	clk_disable_unprepare(hdmi->isfr_clk);
-
-	return ret;
 }
 
 static void imx_hdmi_unbind(struct device *dev, struct device *master,
@@ -1727,9 +1580,8 @@ static void imx_hdmi_unbind(struct device *dev, struct device *master,
 
 	hdmi->connector.funcs->destroy(&hdmi->connector);
 	hdmi->encoder.funcs->destroy(&hdmi->encoder);
-
-	clk_disable_unprepare(hdmi->iahb_clk);
-	clk_disable_unprepare(hdmi->isfr_clk);
+	if (hdmi->plat_data->exit)
+		hdmi->plat_data->exit(hdmi->priv);
 	i2c_put_adapter(hdmi->ddc);
 }
 
@@ -1749,17 +1601,32 @@ static int imx_hdmi_platform_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static struct platform_driver imx_hdmi_driver = {
-	.probe  = imx_hdmi_platform_probe,
-	.remove = imx_hdmi_platform_remove,
-	.driver = {
-		.name = "imx-hdmi",
-		.owner = THIS_MODULE,
-		.of_match_table = imx_hdmi_dt_ids,
-	},
-};
+int imx_hdmi_platform_register(struct platform_device *pdev,
+			       const struct imx_hdmi_plat_data *plat_data)
+{
+	struct imx_hdmi *hdmi;
+
+	hdmi = devm_kzalloc(&pdev->dev, sizeof(*hdmi), GFP_KERNEL);
+	if (!hdmi)
+		return -ENOMEM;
+
+	hdmi->plat_data = plat_data;
+	hdmi->dev = &pdev->dev;
+	hdmi->dev_type = plat_data->dev_type;
+	hdmi->sample_rate = 48000;
+	hdmi->ratio = 100;
+
+	platform_set_drvdata(pdev, hdmi);
 
-module_platform_driver(imx_hdmi_driver);
+	return imx_hdmi_platform_probe(pdev);
+}
+EXPORT_SYMBOL_GPL(imx_hdmi_platform_register);
+
+int imx_hdmi_platform_unregister(struct platform_device *pdev)
+{
+	return imx_hdmi_platform_remove(pdev);
+}
+EXPORT_SYMBOL_GPL(imx_hdmi_platform_unregister);
 
 MODULE_AUTHOR("Sascha Hauer <s.hauer@pengutronix.de>");
 MODULE_DESCRIPTION("i.MX6 HDMI transmitter driver");
diff --git a/drivers/staging/imx-drm/imx-hdmi.h b/drivers/staging/imx-drm/imx-hdmi.h
index 39b6776..e67d60d 100644
--- a/drivers/staging/imx-drm/imx-hdmi.h
+++ b/drivers/staging/imx-drm/imx-hdmi.h
@@ -1029,4 +1029,47 @@ enum {
 	HDMI_A_VIDPOLCFG_HSYNCPOL_ACTIVE_HIGH = 0x2,
 	HDMI_A_VIDPOLCFG_HSYNCPOL_ACTIVE_LOW = 0x0,
 };
+
+enum {
+	RES_8,
+	RES_10,
+	RES_12,
+	RES_MAX,
+};
+
+enum imx_hdmi_devtype {
+	IMX6Q_HDMI,
+	IMX6DL_HDMI,
+};
+
+struct mpll_config {
+	unsigned long mpixelclock;
+	struct {
+		u16 cpce;
+		u16 gmp;
+	} res[RES_MAX];
+};
+
+struct curr_ctrl {
+	unsigned long mpixelclock;
+	u16 curr[RES_MAX];
+};
+
+struct imx_hdmi_plat_data {
+	void * (*setup)(struct platform_device *pdev);
+	void (*exit)(void *priv);
+	void (*encoder_commit)(void *priv, struct drm_encoder *encoder);
+	void (*encoder_prepare)(struct drm_connector *connector,
+				struct drm_encoder *encoder);
+	enum drm_mode_status (*mode_valid)(struct drm_connector *connector,
+					   struct drm_display_mode *mode);
+	const struct mpll_config *mpll_cfg;
+	const struct curr_ctrl *cur_ctr;
+	enum imx_hdmi_devtype dev_type;
+
+};
+
+int imx_hdmi_platform_register(struct platform_device *pdev,
+			       const struct imx_hdmi_plat_data *plat_data);
+int imx_hdmi_platform_unregister(struct platform_device *pdev);
 #endif /* __IMX_HDMI_H__ */
-- 
1.9.1

