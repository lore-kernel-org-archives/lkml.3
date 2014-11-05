Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbaKENA0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 08:00:26 -0500
Received: from regular1.263xmail.com ([211.150.99.139]:57303 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701AbaKENAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 08:00:24 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: airlied@linux.ie
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <5f14fe0d4b6a4f1c3fe5104f15a5a8a3>
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
        linux-rockchip@lists.infradead.org
Subject: [PATCH V2 1/2] imx-drm: imx-hdmi: split imx soc specific code from imx-hdmi
Date: Wed,  5 Nov 2014 20:59:45 +0800
Message-Id: <1415192385-6572-1-git-send-email-andy.yan@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

imx6 and rockchip rk3288 and JZ4780 (Ingenic Xburst/MIPS)
use the interface compatible Designware HDMI IP, but they
also have some lightly difference, such as phy pll configuration,
register width(imx hdmi register is one byte, but rk3288 is 4
bytes width), 4K support(imx6 doesn't support 4k, but rk3288 does),
clk useage,and the crtc mux configuration is also platform specific.

To reuse the imx hdmi driver, split the platform specific code out
to dw_hdmi-imx.c.

Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
---
 drivers/staging/imx-drm/Makefile      |   2 +-
 drivers/staging/imx-drm/dw_hdmi-imx.c | 214 ++++++++++
 drivers/staging/imx-drm/imx-hdmi.c    | 726 ++++++++++++++--------------------
 include/drm/bridge/dw_hdmi.h          | 114 ++++++
 4 files changed, 634 insertions(+), 422 deletions(-)
 create mode 100644 drivers/staging/imx-drm/dw_hdmi-imx.c
 create mode 100644 include/drm/bridge/dw_hdmi.h

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
index 0000000..71ac859
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
+#include <drm/bridge/dw_hdmi.h>
+#include <video/imx-ipu-v3.h>
+#include <linux/regmap.h>
+#include <linux/clk.h>
+
+#include "imx-drm.h"
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
+static void imx_hdmi_imx_set_crtc_mux(void *priv, struct drm_encoder *encoder)
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
+					struct drm_encoder *encoder)
+{
+	imx_drm_panel_format(encoder, V4L2_PIX_FMT_RGB24);
+}
+
+static struct imx_hdmi_plat_data imx6q_hdmi_drv_data = {
+	.setup			= imx_hdmi_imx_setup,
+	.exit			= imx_hdmi_imx_exit,
+	.set_crtc_mux		= imx_hdmi_imx_set_crtc_mux,
+	.encoder_prepare	= imx_hdmi_imx_encoder_prepare,
+	.mpll_cfg		= imx_mpll_cfg,
+	.cur_ctr		= imx_cur_ctr,
+	.dev_type		= IMX6Q_HDMI,
+};
+
+static struct imx_hdmi_plat_data imx6dl_hdmi_drv_data = {
+	.setup			= imx_hdmi_imx_setup,
+	.exit			= imx_hdmi_imx_exit,
+	.set_crtc_mux		= imx_hdmi_imx_set_crtc_mux,
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
+	return imx_hdmi_pltfm_register(pdev, plat_data);
+}
+
+static int imx_hdmi_imx_remove(struct platform_device *pdev)
+{
+	return imx_hdmi_pltfm_unregister(pdev);
+}
+
+static struct platform_driver imx_hdmi_imx_pltfm_driver = {
+	.probe  = imx_hdmi_imx_probe,
+	.remove = imx_hdmi_imx_remove,
+	.driver = {
+		.name = "dwhdmi-imx",
+		.owner = THIS_MODULE,
+		.of_match_table = imx_hdmi_imx_ids,
+	},
+};
+
+module_platform_driver(imx_hdmi_imx_pltfm_driver);
+
+MODULE_AUTHOR("Andy Yan <andy.yan@rock-chips.com>");
+MODULE_DESCRIPTION("IMX6 Specific DW-HDMI Driver Extension");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:dwhdmi-imx");
diff --git a/drivers/staging/imx-drm/imx-hdmi.c b/drivers/staging/imx-drm/imx-hdmi.c
index aaec6b2..138706c 100644
--- a/drivers/staging/imx-drm/imx-hdmi.c
+++ b/drivers/staging/imx-drm/imx-hdmi.c
@@ -16,23 +16,16 @@
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
+#include <drm/bridge/dw_hdmi.h>
 
 #include "imx-hdmi.h"
-#include "imx-drm.h"
-
-#define HDMI_EDID_LEN		512
 
 #define RGB			0
 #define YCBCR444		1
@@ -54,11 +47,6 @@ enum hdmi_datamap {
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
@@ -89,72 +77,44 @@ static const u16 csc_coeff_rgb_in_eitu709[3][4] = {
 	{ 0x6756, 0x78ab, 0x2000, 0x0200 }
 };
 
-struct hdmi_vmode {
-	bool mdvi;
-	bool mhsyncpolarity;
-	bool mvsyncpolarity;
-	bool minterlaced;
-	bool mdataenablepolarity;
-
-	unsigned int mpixelclock;
-	unsigned int mpixelrepetitioninput;
-	unsigned int mpixelrepetitionoutput;
-};
-
-struct hdmi_data_info {
-	unsigned int enc_in_format;
-	unsigned int enc_out_format;
-	unsigned int enc_color_depth;
-	unsigned int colorimetry;
-	unsigned int pix_repet_factor;
-	unsigned int hdcp_enable;
-	struct hdmi_vmode video_mode;
-};
-
-struct imx_hdmi {
-	struct drm_connector connector;
-	struct drm_encoder encoder;
-
-	enum imx_hdmi_devtype dev_type;
-	struct device *dev;
-	struct clk *isfr_clk;
-	struct clk *iahb_clk;
-
-	struct hdmi_data_info hdmi_data;
-	int vic;
-
-	u8 edid[HDMI_EDID_LEN];
-	bool cable_plugin;
+/*On rockchip platform, no-word access to the hdmi
+ * register will causes an imprecise external abort
+ */
+static inline void hdmi_writel(struct imx_hdmi *hdmi, u32 val, int offset)
+{
+	writel(val, hdmi->regs + (offset << 2));
+}
 
-	bool phy_enabled;
-	struct drm_display_mode previous_mode;
+static inline u32 hdmi_readl(struct imx_hdmi *hdmi, int offset)
+{
+	return readl(hdmi->regs + (offset << 2));
+}
 
-	struct regmap *regmap;
-	struct i2c_adapter *ddc;
-	void __iomem *regs;
+static void hdmi_modl(struct imx_hdmi *hdmi, u32 data, u32 mask, unsigned reg)
+{
+	u32 val = hdmi_readl(hdmi, reg) & ~mask;
 
-	unsigned int sample_rate;
-	int ratio;
-};
+	val |= data & mask;
+	hdmi_writel(hdmi, val, reg);
+}
 
-static void imx_hdmi_set_ipu_di_mux(struct imx_hdmi *hdmi, int ipu_di)
+static void hdmi_mask_writel(struct imx_hdmi *hdmi, u32 data, unsigned int reg,
+			     u32 shift, u32 mask)
 {
-	regmap_update_bits(hdmi->regmap, IOMUXC_GPR3,
-			   IMX6Q_GPR3_HDMI_MUX_CTL_MASK,
-			   ipu_di << IMX6Q_GPR3_HDMI_MUX_CTL_SHIFT);
+	hdmi_modl(hdmi, data << shift, mask, reg);
 }
 
-static inline void hdmi_writeb(struct imx_hdmi *hdmi, u8 val, int offset)
+static inline void hdmi_writeb(struct imx_hdmi *hdmi, u32 val, int offset)
 {
 	writeb(val, hdmi->regs + offset);
 }
 
-static inline u8 hdmi_readb(struct imx_hdmi *hdmi, int offset)
+static inline u32 hdmi_readb(struct imx_hdmi *hdmi, int offset)
 {
 	return readb(hdmi->regs + offset);
 }
 
-static void hdmi_modb(struct imx_hdmi *hdmi, u8 data, u8 mask, unsigned reg)
+static void hdmi_modb(struct imx_hdmi *hdmi, u32 data, u32 mask, unsigned reg)
 {
 	u8 val = hdmi_readb(hdmi, reg) & ~mask;
 
@@ -162,8 +122,8 @@ static void hdmi_modb(struct imx_hdmi *hdmi, u8 data, u8 mask, unsigned reg)
 	hdmi_writeb(hdmi, val, reg);
 }
 
-static void hdmi_mask_writeb(struct imx_hdmi *hdmi, u8 data, unsigned int reg,
-		      u8 shift, u8 mask)
+static void hdmi_mask_writeb(struct imx_hdmi *hdmi, u32 data, unsigned int reg,
+		      u32 shift, u32 mask)
 {
 	hdmi_modb(hdmi, data << shift, mask, reg);
 }
@@ -171,22 +131,22 @@ static void hdmi_mask_writeb(struct imx_hdmi *hdmi, u8 data, unsigned int reg,
 static void hdmi_set_clock_regenerator_n(struct imx_hdmi *hdmi,
 					 unsigned int value)
 {
-	hdmi_writeb(hdmi, value & 0xff, HDMI_AUD_N1);
-	hdmi_writeb(hdmi, (value >> 8) & 0xff, HDMI_AUD_N2);
-	hdmi_writeb(hdmi, (value >> 16) & 0x0f, HDMI_AUD_N3);
+	hdmi->write(hdmi, value & 0xff, HDMI_AUD_N1);
+	hdmi->write(hdmi, (value >> 8) & 0xff, HDMI_AUD_N2);
+	hdmi->write(hdmi, (value >> 16) & 0x0f, HDMI_AUD_N3);
 
 	/* nshift factor = 0 */
-	hdmi_modb(hdmi, 0, HDMI_AUD_CTS3_N_SHIFT_MASK, HDMI_AUD_CTS3);
+	hdmi->mod(hdmi, 0, HDMI_AUD_CTS3_N_SHIFT_MASK, HDMI_AUD_CTS3);
 }
 
 static void hdmi_regenerate_cts(struct imx_hdmi *hdmi, unsigned int cts)
 {
 	/* Must be set/cleared first */
-	hdmi_modb(hdmi, 0, HDMI_AUD_CTS3_CTS_MANUAL, HDMI_AUD_CTS3);
+	hdmi->mod(hdmi, 0, HDMI_AUD_CTS3_CTS_MANUAL, HDMI_AUD_CTS3);
 
-	hdmi_writeb(hdmi, cts & 0xff, HDMI_AUD_CTS1);
-	hdmi_writeb(hdmi, (cts >> 8) & 0xff, HDMI_AUD_CTS2);
-	hdmi_writeb(hdmi, ((cts >> 16) & HDMI_AUD_CTS3_AUDCTS19_16_MASK) |
+	hdmi->write(hdmi, cts & 0xff, HDMI_AUD_CTS1);
+	hdmi->write(hdmi, (cts >> 8) & 0xff, HDMI_AUD_CTS2);
+	hdmi->write(hdmi, ((cts >> 16) & HDMI_AUD_CTS3_AUDCTS19_16_MASK) |
 		    HDMI_AUD_CTS3_CTS_MANUAL, HDMI_AUD_CTS3);
 }
 
@@ -323,6 +283,7 @@ static unsigned int hdmi_compute_cts(unsigned int freq, unsigned long pixel_clk,
 	}
 	if (ratio == 100)
 		return cts;
+
 	return (cts * ratio) / 100;
 }
 
@@ -338,7 +299,7 @@ static void hdmi_set_clk_regenerator(struct imx_hdmi *hdmi,
 
 	if (!clk_cts) {
 		dev_dbg(hdmi->dev, "%s: pixel clock not supported: %lu\n",
-			 __func__, pixel_clk);
+			__func__, pixel_clk);
 		return;
 	}
 
@@ -408,19 +369,19 @@ static void hdmi_video_sample(struct imx_hdmi *hdmi)
 	val = HDMI_TX_INVID0_INTERNAL_DE_GENERATOR_DISABLE |
 		((color_format << HDMI_TX_INVID0_VIDEO_MAPPING_OFFSET) &
 		HDMI_TX_INVID0_VIDEO_MAPPING_MASK);
-	hdmi_writeb(hdmi, val, HDMI_TX_INVID0);
+	hdmi->write(hdmi, val, HDMI_TX_INVID0);
 
 	/* Enable TX stuffing: When DE is inactive, fix the output data to 0 */
 	val = HDMI_TX_INSTUFFING_BDBDATA_STUFFING_ENABLE |
 		HDMI_TX_INSTUFFING_RCRDATA_STUFFING_ENABLE |
 		HDMI_TX_INSTUFFING_GYDATA_STUFFING_ENABLE;
-	hdmi_writeb(hdmi, val, HDMI_TX_INSTUFFING);
-	hdmi_writeb(hdmi, 0x0, HDMI_TX_GYDATA0);
-	hdmi_writeb(hdmi, 0x0, HDMI_TX_GYDATA1);
-	hdmi_writeb(hdmi, 0x0, HDMI_TX_RCRDATA0);
-	hdmi_writeb(hdmi, 0x0, HDMI_TX_RCRDATA1);
-	hdmi_writeb(hdmi, 0x0, HDMI_TX_BCBDATA0);
-	hdmi_writeb(hdmi, 0x0, HDMI_TX_BCBDATA1);
+	hdmi->write(hdmi, val, HDMI_TX_INSTUFFING);
+	hdmi->write(hdmi, 0x0, HDMI_TX_GYDATA0);
+	hdmi->write(hdmi, 0x0, HDMI_TX_GYDATA1);
+	hdmi->write(hdmi, 0x0, HDMI_TX_RCRDATA0);
+	hdmi->write(hdmi, 0x0, HDMI_TX_RCRDATA1);
+	hdmi->write(hdmi, 0x0, HDMI_TX_BCBDATA0);
+	hdmi->write(hdmi, 0x0, HDMI_TX_BCBDATA1);
 }
 
 static int is_color_space_conversion(struct imx_hdmi *hdmi)
@@ -477,17 +438,17 @@ static void imx_hdmi_update_csc_coeffs(struct imx_hdmi *hdmi)
 		u16 coeff_b = (*csc_coeff)[1][i];
 		u16 coeff_c = (*csc_coeff)[2][i];
 
-		hdmi_writeb(hdmi, coeff_a & 0xff,
+		hdmi->write(hdmi, coeff_a & 0xff,
 			HDMI_CSC_COEF_A1_LSB + i * 2);
-		hdmi_writeb(hdmi, coeff_a >> 8, HDMI_CSC_COEF_A1_MSB + i * 2);
-		hdmi_writeb(hdmi, coeff_b & 0xff, HDMI_CSC_COEF_B1_LSB + i * 2);
-		hdmi_writeb(hdmi, coeff_b >> 8, HDMI_CSC_COEF_B1_MSB + i * 2);
-		hdmi_writeb(hdmi, coeff_c & 0xff,
+		hdmi->write(hdmi, coeff_a >> 8, HDMI_CSC_COEF_A1_MSB + i * 2);
+		hdmi->write(hdmi, coeff_b & 0xff, HDMI_CSC_COEF_B1_LSB + i * 2);
+		hdmi->write(hdmi, coeff_b >> 8, HDMI_CSC_COEF_B1_MSB + i * 2);
+		hdmi->write(hdmi, coeff_c & 0xff,
 			HDMI_CSC_COEF_C1_LSB + i * 2);
-		hdmi_writeb(hdmi, coeff_c >> 8, HDMI_CSC_COEF_C1_MSB + i * 2);
+		hdmi->write(hdmi, coeff_c >> 8, HDMI_CSC_COEF_C1_MSB + i * 2);
 	}
 
-	hdmi_modb(hdmi, csc_scale, HDMI_CSC_SCALE_CSCSCALE_MASK,
+	hdmi->mod(hdmi, csc_scale, HDMI_CSC_SCALE_CSCSCALE_MASK,
 		  HDMI_CSC_SCALE);
 }
 
@@ -515,8 +476,8 @@ static void hdmi_video_csc(struct imx_hdmi *hdmi)
 		return;
 
 	/* Configure the CSC registers */
-	hdmi_writeb(hdmi, interpolation | decimation, HDMI_CSC_CFG);
-	hdmi_modb(hdmi, color_depth, HDMI_CSC_SCALE_CSC_COLORDE_PTH_MASK,
+	hdmi->write(hdmi, interpolation | decimation, HDMI_CSC_CFG);
+	hdmi->mod(hdmi, color_depth, HDMI_CSC_SCALE_CSC_COLORDE_PTH_MASK,
 		  HDMI_CSC_SCALE);
 
 	imx_hdmi_update_csc_coeffs(hdmi);
@@ -535,21 +496,22 @@ static void hdmi_video_packetize(struct imx_hdmi *hdmi)
 	struct hdmi_data_info *hdmi_data = &hdmi->hdmi_data;
 	u8 val, vp_conf;
 
-	if (hdmi_data->enc_out_format == RGB
-		|| hdmi_data->enc_out_format == YCBCR444) {
-		if (!hdmi_data->enc_color_depth)
+	if (hdmi_data->enc_out_format == RGB ||
+	    hdmi_data->enc_out_format == YCBCR444) {
+		if (!hdmi_data->enc_color_depth) {
 			output_select = HDMI_VP_CONF_OUTPUT_SELECTOR_BYPASS;
-		else if (hdmi_data->enc_color_depth == 8) {
+		} else if (hdmi_data->enc_color_depth == 8) {
 			color_depth = 4;
 			output_select = HDMI_VP_CONF_OUTPUT_SELECTOR_BYPASS;
-		} else if (hdmi_data->enc_color_depth == 10)
+		} else if (hdmi_data->enc_color_depth == 10) {
 			color_depth = 5;
-		else if (hdmi_data->enc_color_depth == 12)
+		} else if (hdmi_data->enc_color_depth == 12) {
 			color_depth = 6;
-		else if (hdmi_data->enc_color_depth == 16)
+		} else if (hdmi_data->enc_color_depth == 16) {
 			color_depth = 7;
-		else
+		} else {
 			return;
+		}
 	} else if (hdmi_data->enc_out_format == YCBCR422_8BITS) {
 		if (!hdmi_data->enc_color_depth ||
 		    hdmi_data->enc_color_depth == 8)
@@ -561,8 +523,9 @@ static void hdmi_video_packetize(struct imx_hdmi *hdmi)
 		else
 			return;
 		output_select = HDMI_VP_CONF_OUTPUT_SELECTOR_YCC422;
-	} else
+	} else {
 		return;
+	}
 
 	/* set the packetizer registers */
 	val = ((color_depth << HDMI_VP_PR_CD_COLOR_DEPTH_OFFSET) &
@@ -570,9 +533,9 @@ static void hdmi_video_packetize(struct imx_hdmi *hdmi)
 		((hdmi_data->pix_repet_factor <<
 		HDMI_VP_PR_CD_DESIRED_PR_FACTOR_OFFSET) &
 		HDMI_VP_PR_CD_DESIRED_PR_FACTOR_MASK);
-	hdmi_writeb(hdmi, val, HDMI_VP_PR_CD);
+	hdmi->write(hdmi, val, HDMI_VP_PR_CD);
 
-	hdmi_modb(hdmi, HDMI_VP_STUFF_PR_STUFFING_STUFFING_MODE,
+	hdmi->mod(hdmi, HDMI_VP_STUFF_PR_STUFFING_STUFFING_MODE,
 		  HDMI_VP_STUFF_PR_STUFFING_MASK, HDMI_VP_STUFF);
 
 	/* Data from pixel repeater block */
@@ -584,14 +547,14 @@ static void hdmi_video_packetize(struct imx_hdmi *hdmi)
 			  HDMI_VP_CONF_BYPASS_SELECT_VID_PACKETIZER;
 	}
 
-	hdmi_modb(hdmi, vp_conf,
+	hdmi->mod(hdmi, vp_conf,
 		  HDMI_VP_CONF_PR_EN_MASK |
 		  HDMI_VP_CONF_BYPASS_SELECT_MASK, HDMI_VP_CONF);
 
-	hdmi_modb(hdmi, 1 << HDMI_VP_STUFF_IDEFAULT_PHASE_OFFSET,
+	hdmi->mod(hdmi, 1 << HDMI_VP_STUFF_IDEFAULT_PHASE_OFFSET,
 		  HDMI_VP_STUFF_IDEFAULT_PHASE_MASK, HDMI_VP_STUFF);
 
-	hdmi_writeb(hdmi, remap_size, HDMI_VP_REMAP);
+	hdmi->write(hdmi, remap_size, HDMI_VP_REMAP);
 
 	if (output_select == HDMI_VP_CONF_OUTPUT_SELECTOR_PP) {
 		vp_conf = HDMI_VP_CONF_BYPASS_EN_DISABLE |
@@ -609,55 +572,55 @@ static void hdmi_video_packetize(struct imx_hdmi *hdmi)
 		return;
 	}
 
-	hdmi_modb(hdmi, vp_conf,
+	hdmi->mod(hdmi, vp_conf,
 		  HDMI_VP_CONF_BYPASS_EN_MASK | HDMI_VP_CONF_PP_EN_ENMASK |
 		  HDMI_VP_CONF_YCC422_EN_MASK, HDMI_VP_CONF);
 
-	hdmi_modb(hdmi, HDMI_VP_STUFF_PP_STUFFING_STUFFING_MODE |
+	hdmi->mod(hdmi, HDMI_VP_STUFF_PP_STUFFING_STUFFING_MODE |
 			HDMI_VP_STUFF_YCC422_STUFFING_STUFFING_MODE,
 		  HDMI_VP_STUFF_PP_STUFFING_MASK |
 		  HDMI_VP_STUFF_YCC422_STUFFING_MASK, HDMI_VP_STUFF);
 
-	hdmi_modb(hdmi, output_select, HDMI_VP_CONF_OUTPUT_SELECTOR_MASK,
+	hdmi->mod(hdmi, output_select, HDMI_VP_CONF_OUTPUT_SELECTOR_MASK,
 		  HDMI_VP_CONF);
 }
 
 static inline void hdmi_phy_test_clear(struct imx_hdmi *hdmi,
 						unsigned char bit)
 {
-	hdmi_modb(hdmi, bit << HDMI_PHY_TST0_TSTCLR_OFFSET,
+	hdmi->mod(hdmi, bit << HDMI_PHY_TST0_TSTCLR_OFFSET,
 		  HDMI_PHY_TST0_TSTCLR_MASK, HDMI_PHY_TST0);
 }
 
 static inline void hdmi_phy_test_enable(struct imx_hdmi *hdmi,
 						unsigned char bit)
 {
-	hdmi_modb(hdmi, bit << HDMI_PHY_TST0_TSTEN_OFFSET,
+	hdmi->mod(hdmi, bit << HDMI_PHY_TST0_TSTEN_OFFSET,
 		  HDMI_PHY_TST0_TSTEN_MASK, HDMI_PHY_TST0);
 }
 
 static inline void hdmi_phy_test_clock(struct imx_hdmi *hdmi,
 						unsigned char bit)
 {
-	hdmi_modb(hdmi, bit << HDMI_PHY_TST0_TSTCLK_OFFSET,
+	hdmi->mod(hdmi, bit << HDMI_PHY_TST0_TSTCLK_OFFSET,
 		  HDMI_PHY_TST0_TSTCLK_MASK, HDMI_PHY_TST0);
 }
 
 static inline void hdmi_phy_test_din(struct imx_hdmi *hdmi,
 						unsigned char bit)
 {
-	hdmi_writeb(hdmi, bit, HDMI_PHY_TST1);
+	hdmi->write(hdmi, bit, HDMI_PHY_TST1);
 }
 
 static inline void hdmi_phy_test_dout(struct imx_hdmi *hdmi,
 						unsigned char bit)
 {
-	hdmi_writeb(hdmi, bit, HDMI_PHY_TST2);
+	hdmi->write(hdmi, bit, HDMI_PHY_TST2);
 }
 
 static bool hdmi_phy_wait_i2c_done(struct imx_hdmi *hdmi, int msec)
 {
-	while ((hdmi_readb(hdmi, HDMI_IH_I2CMPHY_STAT0) & 0x3) == 0) {
+	while ((hdmi->read(hdmi, HDMI_IH_I2CMPHY_STAT0) & 0x3) == 0) {
 		if (msec-- == 0)
 			return false;
 		udelay(1000);
@@ -668,13 +631,13 @@ static bool hdmi_phy_wait_i2c_done(struct imx_hdmi *hdmi, int msec)
 static void __hdmi_phy_i2c_write(struct imx_hdmi *hdmi, unsigned short data,
 			      unsigned char addr)
 {
-	hdmi_writeb(hdmi, 0xFF, HDMI_IH_I2CMPHY_STAT0);
-	hdmi_writeb(hdmi, addr, HDMI_PHY_I2CM_ADDRESS_ADDR);
-	hdmi_writeb(hdmi, (unsigned char)(data >> 8),
+	hdmi->write(hdmi, 0xFF, HDMI_IH_I2CMPHY_STAT0);
+	hdmi->write(hdmi, addr, HDMI_PHY_I2CM_ADDRESS_ADDR);
+	hdmi->write(hdmi, (unsigned char)(data >> 8),
 		HDMI_PHY_I2CM_DATAO_1_ADDR);
-	hdmi_writeb(hdmi, (unsigned char)(data >> 0),
+	hdmi->write(hdmi, (unsigned char)(data >> 0),
 		HDMI_PHY_I2CM_DATAO_0_ADDR);
-	hdmi_writeb(hdmi, HDMI_PHY_I2CM_OPERATION_ADDR_WRITE,
+	hdmi->write(hdmi, HDMI_PHY_I2CM_OPERATION_ADDR_WRITE,
 		HDMI_PHY_I2CM_OPERATION_ADDR);
 	hdmi_phy_wait_i2c_done(hdmi, 1000);
 }
@@ -688,116 +651,53 @@ static int hdmi_phy_i2c_write(struct imx_hdmi *hdmi, unsigned short data,
 
 static void imx_hdmi_phy_enable_power(struct imx_hdmi *hdmi, u8 enable)
 {
-	hdmi_mask_writeb(hdmi, enable, HDMI_PHY_CONF0,
+	hdmi->mask_write(hdmi, enable, HDMI_PHY_CONF0,
 			 HDMI_PHY_CONF0_PDZ_OFFSET,
 			 HDMI_PHY_CONF0_PDZ_MASK);
 }
 
 static void imx_hdmi_phy_enable_tmds(struct imx_hdmi *hdmi, u8 enable)
 {
-	hdmi_mask_writeb(hdmi, enable, HDMI_PHY_CONF0,
+	hdmi->mask_write(hdmi, enable, HDMI_PHY_CONF0,
 			 HDMI_PHY_CONF0_ENTMDS_OFFSET,
 			 HDMI_PHY_CONF0_ENTMDS_MASK);
 }
 
 static void imx_hdmi_phy_gen2_pddq(struct imx_hdmi *hdmi, u8 enable)
 {
-	hdmi_mask_writeb(hdmi, enable, HDMI_PHY_CONF0,
+	hdmi->mask_write(hdmi, enable, HDMI_PHY_CONF0,
 			 HDMI_PHY_CONF0_GEN2_PDDQ_OFFSET,
 			 HDMI_PHY_CONF0_GEN2_PDDQ_MASK);
 }
 
 static void imx_hdmi_phy_gen2_txpwron(struct imx_hdmi *hdmi, u8 enable)
 {
-	hdmi_mask_writeb(hdmi, enable, HDMI_PHY_CONF0,
+	hdmi->mask_write(hdmi, enable, HDMI_PHY_CONF0,
 			 HDMI_PHY_CONF0_GEN2_TXPWRON_OFFSET,
 			 HDMI_PHY_CONF0_GEN2_TXPWRON_MASK);
 }
 
 static void imx_hdmi_phy_sel_data_en_pol(struct imx_hdmi *hdmi, u8 enable)
 {
-	hdmi_mask_writeb(hdmi, enable, HDMI_PHY_CONF0,
+	hdmi->mask_write(hdmi, enable, HDMI_PHY_CONF0,
 			 HDMI_PHY_CONF0_SELDATAENPOL_OFFSET,
 			 HDMI_PHY_CONF0_SELDATAENPOL_MASK);
 }
 
 static void imx_hdmi_phy_sel_interface_control(struct imx_hdmi *hdmi, u8 enable)
 {
-	hdmi_mask_writeb(hdmi, enable, HDMI_PHY_CONF0,
+	hdmi->mask_write(hdmi, enable, HDMI_PHY_CONF0,
 			 HDMI_PHY_CONF0_SELDIPIF_OFFSET,
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
@@ -823,7 +723,7 @@ static int hdmi_phy_configure(struct imx_hdmi *hdmi, unsigned char prep,
 	else
 		val = HDMI_MC_FLOWCTRL_FEED_THROUGH_OFF_CSC_BYPASS;
 
-	hdmi_writeb(hdmi, val, HDMI_MC_FLOWCTRL);
+	hdmi->write(hdmi, val, HDMI_MC_FLOWCTRL);
 
 	/* gen2 tx power off */
 	imx_hdmi_phy_gen2_txpwron(hdmi, 0);
@@ -832,39 +732,38 @@ static int hdmi_phy_configure(struct imx_hdmi *hdmi, unsigned char prep,
 	imx_hdmi_phy_gen2_pddq(hdmi, 1);
 
 	/* PHY reset */
-	hdmi_writeb(hdmi, HDMI_MC_PHYRSTZ_DEASSERT, HDMI_MC_PHYRSTZ);
-	hdmi_writeb(hdmi, HDMI_MC_PHYRSTZ_ASSERT, HDMI_MC_PHYRSTZ);
+	hdmi->write(hdmi, HDMI_MC_PHYRSTZ_DEASSERT, HDMI_MC_PHYRSTZ);
+	hdmi->write(hdmi, HDMI_MC_PHYRSTZ_ASSERT, HDMI_MC_PHYRSTZ);
 
-	hdmi_writeb(hdmi, HDMI_MC_HEACPHY_RST_ASSERT, HDMI_MC_HEACPHY_RST);
+	hdmi->write(hdmi, HDMI_MC_HEACPHY_RST_ASSERT, HDMI_MC_HEACPHY_RST);
 
 	hdmi_phy_test_clear(hdmi, 1);
-	hdmi_writeb(hdmi, HDMI_PHY_I2CM_SLAVE_ADDR_PHY_GEN2,
+	hdmi->write(hdmi, HDMI_PHY_I2CM_SLAVE_ADDR_PHY_GEN2,
 			HDMI_PHY_I2CM_SLAVE_ADDR);
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
-				"Pixel clock %d - unsupported by HDMI\n",
-				hdmi->hdmi_data.video_mode.mpixelclock);
+			"Pixel clock %d - unsupported by HDMI\n",
+			hdmi->hdmi_data.video_mode.mpixelclock);
 		return -EINVAL;
 	}
 
 	/* CURRCTRL */
-	hdmi_phy_i2c_write(hdmi, curr_ctrl[i].curr[res_idx], 0x10);
+	hdmi_phy_i2c_write(hdmi, curr_ctr[i].curr[res_idx], 0x10);
 
 	hdmi_phy_i2c_write(hdmi, 0x0000, 0x13);  /* PLLPHBYCTRL */
 	hdmi_phy_i2c_write(hdmi, 0x0006, 0x17);
@@ -890,7 +789,7 @@ static int hdmi_phy_configure(struct imx_hdmi *hdmi, unsigned char prep,
 	/*Wait for PHY PLL lock */
 	msec = 5;
 	do {
-		val = hdmi_readb(hdmi, HDMI_PHY_STAT0) & HDMI_PHY_TX_PHY_LOCK;
+		val = hdmi->read(hdmi, HDMI_PHY_STAT0) & HDMI_PHY_TX_PHY_LOCK;
 		if (!val)
 			break;
 
@@ -942,12 +841,12 @@ static void hdmi_tx_hdcp_config(struct imx_hdmi *hdmi)
 		de = HDMI_A_VIDPOLCFG_DATAENPOL_ACTIVE_LOW;
 
 	/* disable rx detect */
-	hdmi_modb(hdmi, HDMI_A_HDCPCFG0_RXDETECT_DISABLE,
+	hdmi->mod(hdmi, HDMI_A_HDCPCFG0_RXDETECT_DISABLE,
 		  HDMI_A_HDCPCFG0_RXDETECT_MASK, HDMI_A_HDCPCFG0);
 
-	hdmi_modb(hdmi, de, HDMI_A_VIDPOLCFG_DATAENPOL_MASK, HDMI_A_VIDPOLCFG);
+	hdmi->mod(hdmi, de, HDMI_A_VIDPOLCFG_DATAENPOL_MASK, HDMI_A_VIDPOLCFG);
 
-	hdmi_modb(hdmi, HDMI_A_HDCPCFG1_ENCRYPTIONDISABLE_DISABLE,
+	hdmi->mod(hdmi, HDMI_A_HDCPCFG1_ENCRYPTIONDISABLE_DISABLE,
 		  HDMI_A_HDCPCFG1_ENCRYPTIONDISABLE_MASK, HDMI_A_HDCPCFG1);
 }
 
@@ -977,7 +876,7 @@ static void hdmi_config_AVI(struct imx_hdmi *hdmi)
 		HDMI_FC_AVICONF0_ACTIVE_FMT_INFO_PRESENT |
 		HDMI_FC_AVICONF0_BAR_DATA_NO_DATA;
 
-	hdmi_writeb(hdmi, val, HDMI_FC_AVICONF0);
+	hdmi->write(hdmi, val, HDMI_FC_AVICONF0);
 
 	/* AVI Data Byte 2 -Set the Aspect Ratio */
 	if (aspect_16_9) {
@@ -1009,16 +908,16 @@ static void hdmi_config_AVI(struct imx_hdmi *hdmi)
 	}
 
 	val = colorimetry | coded_ratio | act_ratio;
-	hdmi_writeb(hdmi, val, HDMI_FC_AVICONF1);
+	hdmi->write(hdmi, val, HDMI_FC_AVICONF1);
 
 	/* AVI Data Byte 3 */
 	val = HDMI_FC_AVICONF2_IT_CONTENT_NO_DATA | ext_colorimetry |
 		HDMI_FC_AVICONF2_RGB_QUANT_DEFAULT |
 		HDMI_FC_AVICONF2_SCALING_NONE;
-	hdmi_writeb(hdmi, val, HDMI_FC_AVICONF2);
+	hdmi->write(hdmi, val, HDMI_FC_AVICONF2);
 
 	/* AVI Data Byte 4 */
-	hdmi_writeb(hdmi, hdmi->vic, HDMI_FC_AVIVID);
+	hdmi->write(hdmi, hdmi->vic, HDMI_FC_AVIVID);
 
 	/* AVI Data Byte 5- set up input and output pixel repetition */
 	val = (((hdmi->hdmi_data.video_mode.mpixelrepetitioninput + 1) <<
@@ -1027,22 +926,22 @@ static void hdmi_config_AVI(struct imx_hdmi *hdmi)
 		((hdmi->hdmi_data.video_mode.mpixelrepetitionoutput <<
 		HDMI_FC_PRCONF_OUTPUT_PR_FACTOR_OFFSET) &
 		HDMI_FC_PRCONF_OUTPUT_PR_FACTOR_MASK);
-	hdmi_writeb(hdmi, val, HDMI_FC_PRCONF);
+	hdmi->write(hdmi, val, HDMI_FC_PRCONF);
 
 	/* IT Content and quantization range = don't care */
 	val = HDMI_FC_AVICONF3_IT_CONTENT_TYPE_GRAPHICS |
 		HDMI_FC_AVICONF3_QUANT_RANGE_LIMITED;
-	hdmi_writeb(hdmi, val, HDMI_FC_AVICONF3);
+	hdmi->write(hdmi, val, HDMI_FC_AVICONF3);
 
 	/* AVI Data Bytes 6-13 */
-	hdmi_writeb(hdmi, 0, HDMI_FC_AVIETB0);
-	hdmi_writeb(hdmi, 0, HDMI_FC_AVIETB1);
-	hdmi_writeb(hdmi, 0, HDMI_FC_AVISBB0);
-	hdmi_writeb(hdmi, 0, HDMI_FC_AVISBB1);
-	hdmi_writeb(hdmi, 0, HDMI_FC_AVIELB0);
-	hdmi_writeb(hdmi, 0, HDMI_FC_AVIELB1);
-	hdmi_writeb(hdmi, 0, HDMI_FC_AVISRB0);
-	hdmi_writeb(hdmi, 0, HDMI_FC_AVISRB1);
+	hdmi->write(hdmi, 0, HDMI_FC_AVIETB0);
+	hdmi->write(hdmi, 0, HDMI_FC_AVIETB1);
+	hdmi->write(hdmi, 0, HDMI_FC_AVISBB0);
+	hdmi->write(hdmi, 0, HDMI_FC_AVISBB1);
+	hdmi->write(hdmi, 0, HDMI_FC_AVIELB0);
+	hdmi->write(hdmi, 0, HDMI_FC_AVIELB1);
+	hdmi->write(hdmi, 0, HDMI_FC_AVISRB0);
+	hdmi->write(hdmi, 0, HDMI_FC_AVISRB1);
 }
 
 static void hdmi_av_composer(struct imx_hdmi *hdmi,
@@ -1091,42 +990,42 @@ static void hdmi_av_composer(struct imx_hdmi *hdmi,
 		HDMI_FC_INVIDCONF_DVI_MODEZ_DVI_MODE :
 		HDMI_FC_INVIDCONF_DVI_MODEZ_HDMI_MODE);
 
-	hdmi_writeb(hdmi, inv_val, HDMI_FC_INVIDCONF);
+	hdmi->write(hdmi, inv_val, HDMI_FC_INVIDCONF);
 
 	/* Set up horizontal active pixel width */
-	hdmi_writeb(hdmi, mode->hdisplay >> 8, HDMI_FC_INHACTV1);
-	hdmi_writeb(hdmi, mode->hdisplay, HDMI_FC_INHACTV0);
+	hdmi->write(hdmi, mode->hdisplay >> 8, HDMI_FC_INHACTV1);
+	hdmi->write(hdmi, mode->hdisplay, HDMI_FC_INHACTV0);
 
 	/* Set up vertical active lines */
-	hdmi_writeb(hdmi, mode->vdisplay >> 8, HDMI_FC_INVACTV1);
-	hdmi_writeb(hdmi, mode->vdisplay, HDMI_FC_INVACTV0);
+	hdmi->write(hdmi, mode->vdisplay >> 8, HDMI_FC_INVACTV1);
+	hdmi->write(hdmi, mode->vdisplay, HDMI_FC_INVACTV0);
 
 	/* Set up horizontal blanking pixel region width */
 	hblank = mode->htotal - mode->hdisplay;
-	hdmi_writeb(hdmi, hblank >> 8, HDMI_FC_INHBLANK1);
-	hdmi_writeb(hdmi, hblank, HDMI_FC_INHBLANK0);
+	hdmi->write(hdmi, hblank >> 8, HDMI_FC_INHBLANK1);
+	hdmi->write(hdmi, hblank, HDMI_FC_INHBLANK0);
 
 	/* Set up vertical blanking pixel region width */
 	vblank = mode->vtotal - mode->vdisplay;
-	hdmi_writeb(hdmi, vblank, HDMI_FC_INVBLANK);
+	hdmi->write(hdmi, vblank, HDMI_FC_INVBLANK);
 
 	/* Set up HSYNC active edge delay width (in pixel clks) */
 	h_de_hs = mode->hsync_start - mode->hdisplay;
-	hdmi_writeb(hdmi, h_de_hs >> 8, HDMI_FC_HSYNCINDELAY1);
-	hdmi_writeb(hdmi, h_de_hs, HDMI_FC_HSYNCINDELAY0);
+	hdmi->write(hdmi, h_de_hs >> 8, HDMI_FC_HSYNCINDELAY1);
+	hdmi->write(hdmi, h_de_hs, HDMI_FC_HSYNCINDELAY0);
 
 	/* Set up VSYNC active edge delay (in lines) */
 	v_de_vs = mode->vsync_start - mode->vdisplay;
-	hdmi_writeb(hdmi, v_de_vs, HDMI_FC_VSYNCINDELAY);
+	hdmi->write(hdmi, v_de_vs, HDMI_FC_VSYNCINDELAY);
 
 	/* Set up HSYNC active pulse width (in pixel clks) */
 	hsync_len = mode->hsync_end - mode->hsync_start;
-	hdmi_writeb(hdmi, hsync_len >> 8, HDMI_FC_HSYNCINWIDTH1);
-	hdmi_writeb(hdmi, hsync_len, HDMI_FC_HSYNCINWIDTH0);
+	hdmi->write(hdmi, hsync_len >> 8, HDMI_FC_HSYNCINWIDTH1);
+	hdmi->write(hdmi, hsync_len, HDMI_FC_HSYNCINWIDTH0);
 
 	/* Set up VSYNC active edge delay (in lines) */
 	vsync_len = mode->vsync_end - mode->vsync_start;
-	hdmi_writeb(hdmi, vsync_len, HDMI_FC_VSYNCINWIDTH);
+	hdmi->write(hdmi, vsync_len, HDMI_FC_VSYNCINWIDTH);
 }
 
 static void imx_hdmi_phy_disable(struct imx_hdmi *hdmi)
@@ -1146,33 +1045,33 @@ static void imx_hdmi_enable_video_path(struct imx_hdmi *hdmi)
 	u8 clkdis;
 
 	/* control period minimum duration */
-	hdmi_writeb(hdmi, 12, HDMI_FC_CTRLDUR);
-	hdmi_writeb(hdmi, 32, HDMI_FC_EXCTRLDUR);
-	hdmi_writeb(hdmi, 1, HDMI_FC_EXCTRLSPAC);
+	hdmi->write(hdmi, 12, HDMI_FC_CTRLDUR);
+	hdmi->write(hdmi, 32, HDMI_FC_EXCTRLDUR);
+	hdmi->write(hdmi, 1, HDMI_FC_EXCTRLSPAC);
 
 	/* Set to fill TMDS data channels */
-	hdmi_writeb(hdmi, 0x0B, HDMI_FC_CH0PREAM);
-	hdmi_writeb(hdmi, 0x16, HDMI_FC_CH1PREAM);
-	hdmi_writeb(hdmi, 0x21, HDMI_FC_CH2PREAM);
+	hdmi->write(hdmi, 0x0B, HDMI_FC_CH0PREAM);
+	hdmi->write(hdmi, 0x16, HDMI_FC_CH1PREAM);
+	hdmi->write(hdmi, 0x21, HDMI_FC_CH2PREAM);
 
 	/* Enable pixel clock and tmds data path */
 	clkdis = 0x7F;
 	clkdis &= ~HDMI_MC_CLKDIS_PIXELCLK_DISABLE;
-	hdmi_writeb(hdmi, clkdis, HDMI_MC_CLKDIS);
+	hdmi->write(hdmi, clkdis, HDMI_MC_CLKDIS);
 
 	clkdis &= ~HDMI_MC_CLKDIS_TMDSCLK_DISABLE;
-	hdmi_writeb(hdmi, clkdis, HDMI_MC_CLKDIS);
+	hdmi->write(hdmi, clkdis, HDMI_MC_CLKDIS);
 
 	/* Enable csc path */
 	if (is_color_space_conversion(hdmi)) {
 		clkdis &= ~HDMI_MC_CLKDIS_CSCCLK_DISABLE;
-		hdmi_writeb(hdmi, clkdis, HDMI_MC_CLKDIS);
+		hdmi->write(hdmi, clkdis, HDMI_MC_CLKDIS);
 	}
 }
 
 static void hdmi_enable_audio_clk(struct imx_hdmi *hdmi)
 {
-	hdmi_modb(hdmi, 0, HDMI_MC_CLKDIS_AUDCLK_DISABLE, HDMI_MC_CLKDIS);
+	hdmi->mod(hdmi, 0, HDMI_MC_CLKDIS_AUDCLK_DISABLE, HDMI_MC_CLKDIS);
 }
 
 /* Workaround to clear the overflow condition */
@@ -1182,27 +1081,27 @@ static void imx_hdmi_clear_overflow(struct imx_hdmi *hdmi)
 	u8 val;
 
 	/* TMDS software reset */
-	hdmi_writeb(hdmi, (u8)~HDMI_MC_SWRSTZ_TMDSSWRST_REQ, HDMI_MC_SWRSTZ);
+	hdmi->write(hdmi, (u8)~HDMI_MC_SWRSTZ_TMDSSWRST_REQ, HDMI_MC_SWRSTZ);
 
-	val = hdmi_readb(hdmi, HDMI_FC_INVIDCONF);
+	val = hdmi->read(hdmi, HDMI_FC_INVIDCONF);
 	if (hdmi->dev_type == IMX6DL_HDMI) {
-		hdmi_writeb(hdmi, val, HDMI_FC_INVIDCONF);
+		hdmi->write(hdmi, val, HDMI_FC_INVIDCONF);
 		return;
 	}
 
 	for (count = 0; count < 4; count++)
-		hdmi_writeb(hdmi, val, HDMI_FC_INVIDCONF);
+		hdmi->write(hdmi, val, HDMI_FC_INVIDCONF);
 }
 
 static void hdmi_enable_overflow_interrupts(struct imx_hdmi *hdmi)
 {
-	hdmi_writeb(hdmi, 0, HDMI_FC_MASK2);
-	hdmi_writeb(hdmi, 0, HDMI_IH_MUTE_FC_STAT2);
+	hdmi->write(hdmi, 0, HDMI_FC_MASK2);
+	hdmi->write(hdmi, 0, HDMI_IH_MUTE_FC_STAT2);
 }
 
 static void hdmi_disable_overflow_interrupts(struct imx_hdmi *hdmi)
 {
-	hdmi_writeb(hdmi, HDMI_IH_MUTE_FC_STAT2_OVERFLOW_MASK,
+	hdmi->write(hdmi, HDMI_IH_MUTE_FC_STAT2_OVERFLOW_MASK,
 		    HDMI_IH_MUTE_FC_STAT2);
 }
 
@@ -1223,21 +1122,21 @@ static int imx_hdmi_setup(struct imx_hdmi *hdmi, struct drm_display_mode *mode)
 	}
 
 	if ((hdmi->vic == 6) || (hdmi->vic == 7) ||
-		(hdmi->vic == 21) || (hdmi->vic == 22) ||
-		(hdmi->vic == 2) || (hdmi->vic == 3) ||
-		(hdmi->vic == 17) || (hdmi->vic == 18))
+	    (hdmi->vic == 21) || (hdmi->vic == 22) ||
+	    (hdmi->vic == 2) || (hdmi->vic == 3) ||
+	    (hdmi->vic == 17) || (hdmi->vic == 18))
 		hdmi->hdmi_data.colorimetry = HDMI_COLORIMETRY_ITU_601;
 	else
 		hdmi->hdmi_data.colorimetry = HDMI_COLORIMETRY_ITU_709;
 
 	if ((hdmi->vic == 10) || (hdmi->vic == 11) ||
-		(hdmi->vic == 12) || (hdmi->vic == 13) ||
-		(hdmi->vic == 14) || (hdmi->vic == 15) ||
-		(hdmi->vic == 25) || (hdmi->vic == 26) ||
-		(hdmi->vic == 27) || (hdmi->vic == 28) ||
-		(hdmi->vic == 29) || (hdmi->vic == 30) ||
-		(hdmi->vic == 35) || (hdmi->vic == 36) ||
-		(hdmi->vic == 37) || (hdmi->vic == 38))
+	    (hdmi->vic == 12) || (hdmi->vic == 13) ||
+	    (hdmi->vic == 14) || (hdmi->vic == 15) ||
+	    (hdmi->vic == 25) || (hdmi->vic == 26) ||
+	    (hdmi->vic == 27) || (hdmi->vic == 28) ||
+	    (hdmi->vic == 29) || (hdmi->vic == 30) ||
+	    (hdmi->vic == 35) || (hdmi->vic == 36) ||
+	    (hdmi->vic == 37) || (hdmi->vic == 38))
 		hdmi->hdmi_data.video_mode.mpixelrepetitionoutput = 1;
 	else
 		hdmi->hdmi_data.video_mode.mpixelrepetitionoutput = 0;
@@ -1266,9 +1165,9 @@ static int imx_hdmi_setup(struct imx_hdmi *hdmi, struct drm_display_mode *mode)
 	imx_hdmi_enable_video_path(hdmi);
 
 	/* not for DVI mode */
-	if (hdmi->hdmi_data.video_mode.mdvi)
+	if (hdmi->hdmi_data.video_mode.mdvi) {
 		dev_dbg(hdmi->dev, "%s DVI mode\n", __func__);
-	else {
+	} else {
 		dev_dbg(hdmi->dev, "%s CEA mode\n", __func__);
 
 		/* HDMI Initialization Step E - Configure audio */
@@ -1294,18 +1193,18 @@ static int imx_hdmi_setup(struct imx_hdmi *hdmi, struct drm_display_mode *mode)
 /* Wait until we are registered to enable interrupts */
 static int imx_hdmi_fb_registered(struct imx_hdmi *hdmi)
 {
-	hdmi_writeb(hdmi, HDMI_PHY_I2CM_INT_ADDR_DONE_POL,
+	hdmi->write(hdmi, HDMI_PHY_I2CM_INT_ADDR_DONE_POL,
 		    HDMI_PHY_I2CM_INT_ADDR);
 
-	hdmi_writeb(hdmi, HDMI_PHY_I2CM_CTLINT_ADDR_NAC_POL |
+	hdmi->write(hdmi, HDMI_PHY_I2CM_CTLINT_ADDR_NAC_POL |
 		    HDMI_PHY_I2CM_CTLINT_ADDR_ARBITRATION_POL,
 		    HDMI_PHY_I2CM_CTLINT_ADDR);
 
 	/* enable cable hot plug irq */
-	hdmi_writeb(hdmi, (u8)~HDMI_PHY_HPD, HDMI_PHY_MASK0);
+	hdmi->write(hdmi, (u8)~HDMI_PHY_HPD, HDMI_PHY_MASK0);
 
 	/* Clear Hotplug interrupts */
-	hdmi_writeb(hdmi, HDMI_IH_PHY_STAT0_HPD, HDMI_IH_PHY_STAT0);
+	hdmi->write(hdmi, HDMI_IH_PHY_STAT0_HPD, HDMI_IH_PHY_STAT0);
 
 	return 0;
 }
@@ -1321,45 +1220,45 @@ static void initialize_hdmi_ih_mutes(struct imx_hdmi *hdmi)
 	 *
 	 * Disable top level interrupt bits in HDMI block
 	 */
-	ih_mute = hdmi_readb(hdmi, HDMI_IH_MUTE) |
+	ih_mute = hdmi->read(hdmi, HDMI_IH_MUTE) |
 		  HDMI_IH_MUTE_MUTE_WAKEUP_INTERRUPT |
 		  HDMI_IH_MUTE_MUTE_ALL_INTERRUPT;
 
-	hdmi_writeb(hdmi, ih_mute, HDMI_IH_MUTE);
+	hdmi->write(hdmi, ih_mute, HDMI_IH_MUTE);
 
 	/* by default mask all interrupts */
-	hdmi_writeb(hdmi, 0xff, HDMI_VP_MASK);
-	hdmi_writeb(hdmi, 0xff, HDMI_FC_MASK0);
-	hdmi_writeb(hdmi, 0xff, HDMI_FC_MASK1);
-	hdmi_writeb(hdmi, 0xff, HDMI_FC_MASK2);
-	hdmi_writeb(hdmi, 0xff, HDMI_PHY_MASK0);
-	hdmi_writeb(hdmi, 0xff, HDMI_PHY_I2CM_INT_ADDR);
-	hdmi_writeb(hdmi, 0xff, HDMI_PHY_I2CM_CTLINT_ADDR);
-	hdmi_writeb(hdmi, 0xff, HDMI_AUD_INT);
-	hdmi_writeb(hdmi, 0xff, HDMI_AUD_SPDIFINT);
-	hdmi_writeb(hdmi, 0xff, HDMI_AUD_HBR_MASK);
-	hdmi_writeb(hdmi, 0xff, HDMI_GP_MASK);
-	hdmi_writeb(hdmi, 0xff, HDMI_A_APIINTMSK);
-	hdmi_writeb(hdmi, 0xff, HDMI_CEC_MASK);
-	hdmi_writeb(hdmi, 0xff, HDMI_I2CM_INT);
-	hdmi_writeb(hdmi, 0xff, HDMI_I2CM_CTLINT);
+	hdmi->write(hdmi, 0xff, HDMI_VP_MASK);
+	hdmi->write(hdmi, 0xff, HDMI_FC_MASK0);
+	hdmi->write(hdmi, 0xff, HDMI_FC_MASK1);
+	hdmi->write(hdmi, 0xff, HDMI_FC_MASK2);
+	hdmi->write(hdmi, 0xff, HDMI_PHY_MASK0);
+	hdmi->write(hdmi, 0xff, HDMI_PHY_I2CM_INT_ADDR);
+	hdmi->write(hdmi, 0xff, HDMI_PHY_I2CM_CTLINT_ADDR);
+	hdmi->write(hdmi, 0xff, HDMI_AUD_INT);
+	hdmi->write(hdmi, 0xff, HDMI_AUD_SPDIFINT);
+	hdmi->write(hdmi, 0xff, HDMI_AUD_HBR_MASK);
+	hdmi->write(hdmi, 0xff, HDMI_GP_MASK);
+	hdmi->write(hdmi, 0xff, HDMI_A_APIINTMSK);
+	hdmi->write(hdmi, 0xff, HDMI_CEC_MASK);
+	hdmi->write(hdmi, 0xff, HDMI_I2CM_INT);
+	hdmi->write(hdmi, 0xff, HDMI_I2CM_CTLINT);
 
 	/* Disable interrupts in the IH_MUTE_* registers */
-	hdmi_writeb(hdmi, 0xff, HDMI_IH_MUTE_FC_STAT0);
-	hdmi_writeb(hdmi, 0xff, HDMI_IH_MUTE_FC_STAT1);
-	hdmi_writeb(hdmi, 0xff, HDMI_IH_MUTE_FC_STAT2);
-	hdmi_writeb(hdmi, 0xff, HDMI_IH_MUTE_AS_STAT0);
-	hdmi_writeb(hdmi, 0xff, HDMI_IH_MUTE_PHY_STAT0);
-	hdmi_writeb(hdmi, 0xff, HDMI_IH_MUTE_I2CM_STAT0);
-	hdmi_writeb(hdmi, 0xff, HDMI_IH_MUTE_CEC_STAT0);
-	hdmi_writeb(hdmi, 0xff, HDMI_IH_MUTE_VP_STAT0);
-	hdmi_writeb(hdmi, 0xff, HDMI_IH_MUTE_I2CMPHY_STAT0);
-	hdmi_writeb(hdmi, 0xff, HDMI_IH_MUTE_AHBDMAAUD_STAT0);
+	hdmi->write(hdmi, 0xff, HDMI_IH_MUTE_FC_STAT0);
+	hdmi->write(hdmi, 0xff, HDMI_IH_MUTE_FC_STAT1);
+	hdmi->write(hdmi, 0xff, HDMI_IH_MUTE_FC_STAT2);
+	hdmi->write(hdmi, 0xff, HDMI_IH_MUTE_AS_STAT0);
+	hdmi->write(hdmi, 0xff, HDMI_IH_MUTE_PHY_STAT0);
+	hdmi->write(hdmi, 0xff, HDMI_IH_MUTE_I2CM_STAT0);
+	hdmi->write(hdmi, 0xff, HDMI_IH_MUTE_CEC_STAT0);
+	hdmi->write(hdmi, 0xff, HDMI_IH_MUTE_VP_STAT0);
+	hdmi->write(hdmi, 0xff, HDMI_IH_MUTE_I2CMPHY_STAT0);
+	hdmi->write(hdmi, 0xff, HDMI_IH_MUTE_AHBDMAAUD_STAT0);
 
 	/* Enable top level interrupt bits in HDMI block */
 	ih_mute &= ~(HDMI_IH_MUTE_MUTE_WAKEUP_INTERRUPT |
 		    HDMI_IH_MUTE_MUTE_ALL_INTERRUPT);
-	hdmi_writeb(hdmi, ih_mute, HDMI_IH_MUTE);
+	hdmi->write(hdmi, ih_mute, HDMI_IH_MUTE);
 }
 
 static void imx_hdmi_poweron(struct imx_hdmi *hdmi)
@@ -1378,7 +1277,7 @@ static enum drm_connector_status imx_hdmi_connector_detect(struct drm_connector
 	struct imx_hdmi *hdmi = container_of(connector, struct imx_hdmi,
 					     connector);
 
-	return hdmi_readb(hdmi, HDMI_PHY_STAT0) & HDMI_PHY_HPD ?
+	return hdmi->read(hdmi, HDMI_PHY_STAT0) & HDMI_PHY_HPD ?
 		connector_status_connected : connector_status_disconnected;
 }
 
@@ -1454,21 +1353,40 @@ static void imx_hdmi_encoder_prepare(struct drm_encoder *encoder)
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
+	if (hdmi->plat_data->set_crtc_mux)
+		hdmi->plat_data->set_crtc_mux(hdmi->priv, encoder);
 
 	imx_hdmi_poweron(hdmi);
 }
 
+void imx_hdmi_connector_destroy(struct drm_connector *connector)
+{
+	drm_connector_unregister(connector);
+	drm_connector_cleanup(connector);
+}
+
+static int imx_hdmi_connector_mode_valid(struct drm_connector *connector,
+					 struct drm_display_mode *mode)
+{
+	struct imx_hdmi *hdmi = container_of(connector, struct imx_hdmi,
+					     connector);
+	if (hdmi->plat_data->mode_valid)
+		return hdmi->plat_data->mode_valid(connector, mode);
+
+	return MODE_OK;
+}
+
 static struct drm_encoder_funcs imx_hdmi_encoder_funcs = {
-	.destroy = imx_drm_encoder_destroy,
+	.destroy = drm_encoder_cleanup,
 };
 
 static struct drm_encoder_helper_funcs imx_hdmi_encoder_helper_funcs = {
@@ -1484,11 +1402,12 @@ static struct drm_connector_funcs imx_hdmi_connector_funcs = {
 	.dpms = drm_helper_connector_dpms,
 	.fill_modes = drm_helper_probe_single_connector_modes,
 	.detect = imx_hdmi_connector_detect,
-	.destroy = imx_drm_connector_destroy,
+	.destroy = imx_hdmi_connector_destroy,
 };
 
 static struct drm_connector_helper_funcs imx_hdmi_connector_helper_funcs = {
 	.get_modes = imx_hdmi_connector_get_modes,
+	.mode_valid = imx_hdmi_connector_mode_valid,
 	.best_encoder = imx_hdmi_connector_best_encoder,
 };
 
@@ -1497,9 +1416,9 @@ static irqreturn_t imx_hdmi_hardirq(int irq, void *dev_id)
 	struct imx_hdmi *hdmi = dev_id;
 	u8 intr_stat;
 
-	intr_stat = hdmi_readb(hdmi, HDMI_IH_PHY_STAT0);
+	intr_stat = hdmi->read(hdmi, HDMI_IH_PHY_STAT0);
 	if (intr_stat)
-		hdmi_writeb(hdmi, ~0, HDMI_IH_MUTE_PHY_STAT0);
+		hdmi->write(hdmi, ~0, HDMI_IH_MUTE_PHY_STAT0);
 
 	return intr_stat ? IRQ_WAKE_THREAD : IRQ_NONE;
 }
@@ -1510,21 +1429,21 @@ static irqreturn_t imx_hdmi_irq(int irq, void *dev_id)
 	u8 intr_stat;
 	u8 phy_int_pol;
 
-	intr_stat = hdmi_readb(hdmi, HDMI_IH_PHY_STAT0);
+	intr_stat = hdmi->read(hdmi, HDMI_IH_PHY_STAT0);
 
-	phy_int_pol = hdmi_readb(hdmi, HDMI_PHY_POL0);
+	phy_int_pol = hdmi->read(hdmi, HDMI_PHY_POL0);
 
 	if (intr_stat & HDMI_IH_PHY_STAT0_HPD) {
 		if (phy_int_pol & HDMI_PHY_HPD) {
 			dev_dbg(hdmi->dev, "EVENT=plugin\n");
 
-			hdmi_modb(hdmi, 0, HDMI_PHY_HPD, HDMI_PHY_POL0);
+			hdmi->mod(hdmi, 0, HDMI_PHY_HPD, HDMI_PHY_POL0);
 
 			imx_hdmi_poweron(hdmi);
 		} else {
 			dev_dbg(hdmi->dev, "EVENT=plugout\n");
 
-			hdmi_modb(hdmi, HDMI_PHY_HPD, HDMI_PHY_HPD,
+			hdmi->mod(hdmi, HDMI_PHY_HPD, HDMI_PHY_HPD,
 				HDMI_PHY_POL0);
 
 			imx_hdmi_poweroff(hdmi);
@@ -1532,20 +1451,18 @@ static irqreturn_t imx_hdmi_irq(int irq, void *dev_id)
 		drm_helper_hpd_irq_event(hdmi->connector.dev);
 	}
 
-	hdmi_writeb(hdmi, intr_stat, HDMI_IH_PHY_STAT0);
-	hdmi_writeb(hdmi, ~HDMI_IH_PHY_STAT0_HPD, HDMI_IH_MUTE_PHY_STAT0);
+	hdmi->write(hdmi, intr_stat, HDMI_IH_PHY_STAT0);
+	hdmi->write(hdmi, ~HDMI_IH_PHY_STAT0_HPD, HDMI_IH_MUTE_PHY_STAT0);
 
 	return IRQ_HANDLED;
 }
 
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
 
@@ -1554,7 +1471,7 @@ static int imx_hdmi_register(struct drm_device *drm, struct imx_hdmi *hdmi)
 			 DRM_MODE_ENCODER_TMDS);
 
 	drm_connector_helper_add(&hdmi->connector,
-			&imx_hdmi_connector_helper_funcs);
+				 &imx_hdmi_connector_helper_funcs);
 	drm_connector_init(drm, &hdmi->connector, &imx_hdmi_connector_funcs,
 			   DRM_MODE_CONNECTOR_HDMIA);
 
@@ -1565,55 +1482,47 @@ static int imx_hdmi_register(struct drm_device *drm, struct imx_hdmi *hdmi)
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
-
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
+	u32 val;
+
+	if (!of_property_read_u32(np, "reg-io-width", &val)) {
+		switch (val) {
+		case 4:
+			hdmi->write = hdmi_writel;
+			hdmi->read = hdmi_readl;
+			hdmi->mod = hdmi_modl;
+			hdmi->mask_write = hdmi_mask_writel;
+			break;
+		default:
+			hdmi->write = hdmi_writeb;
+			hdmi->read = hdmi_readb;
+			hdmi->mod = hdmi_modb;
+			hdmi->mask_write = hdmi_mask_writeb;
+			break;
+		}
+	} else {
+		hdmi->write = hdmi_writeb;
+		hdmi->read = hdmi_readb;
+		hdmi->mod = hdmi_modb;
+		hdmi->mask_write = hdmi_mask_writeb;
 	}
 
 	ddc_node = of_parse_phandle(np, "ddc-i2c-bus", 0);
 	if (ddc_node) {
 		hdmi->ddc = of_find_i2c_adapter_by_node(ddc_node);
-		if (!hdmi->ddc)
+		if (!hdmi->ddc) {
 			dev_dbg(hdmi->dev, "failed to read ddc node\n");
+			of_node_put(ddc_node);
+			return -EPROBE_DEFER;
+		}
 
 		of_node_put(ddc_node);
 	} else {
@@ -1635,47 +1544,15 @@ static int imx_hdmi_bind(struct device *dev, struct device *master, void *data)
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
-		"Detected HDMI controller 0x%x:0x%x:0x%x:0x%x\n",
-		hdmi_readb(hdmi, HDMI_DESIGN_ID),
-		hdmi_readb(hdmi, HDMI_REVISION_ID),
-		hdmi_readb(hdmi, HDMI_PRODUCT_ID0),
-		hdmi_readb(hdmi, HDMI_PRODUCT_ID1));
+		 "Detected HDMI controller 0x%x:0x%x:0x%x:0x%x\n",
+		 hdmi->read(hdmi, HDMI_DESIGN_ID),
+		 hdmi->read(hdmi, HDMI_REVISION_ID),
+		 hdmi->read(hdmi, HDMI_PRODUCT_ID0),
+		 hdmi->read(hdmi, HDMI_PRODUCT_ID1));
 
 	initialize_hdmi_ih_mutes(hdmi);
 
@@ -1689,32 +1566,25 @@ static int imx_hdmi_bind(struct device *dev, struct device *master, void *data)
 	 * Configure registers related to HDMI interrupt
 	 * generation before registering IRQ.
 	 */
-	hdmi_writeb(hdmi, HDMI_PHY_HPD, HDMI_PHY_POL0);
+	hdmi->write(hdmi, HDMI_PHY_HPD, HDMI_PHY_POL0);
 
 	/* Clear Hotplug interrupts */
-	hdmi_writeb(hdmi, HDMI_IH_PHY_STAT0_HPD, HDMI_IH_PHY_STAT0);
+	hdmi->write(hdmi, HDMI_IH_PHY_STAT0_HPD, HDMI_IH_PHY_STAT0);
 
 	ret = imx_hdmi_fb_registered(hdmi);
 	if (ret)
-		goto err_iahb;
+		return ret;
 
 	ret = imx_hdmi_register(drm, hdmi);
 	if (ret)
-		goto err_iahb;
+		return ret;
 
 	/* Unmute interrupts */
-	hdmi_writeb(hdmi, ~HDMI_IH_PHY_STAT0_HPD, HDMI_IH_MUTE_PHY_STAT0);
+	hdmi->write(hdmi, ~HDMI_IH_PHY_STAT0_HPD, HDMI_IH_MUTE_PHY_STAT0);
 
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
@@ -1723,13 +1593,12 @@ static void imx_hdmi_unbind(struct device *dev, struct device *master,
 	struct imx_hdmi *hdmi = dev_get_drvdata(dev);
 
 	/* Disable all interrupts */
-	hdmi_writeb(hdmi, ~0, HDMI_IH_MUTE_PHY_STAT0);
+	hdmi->write(hdmi, ~0, HDMI_IH_MUTE_PHY_STAT0);
 
 	hdmi->connector.funcs->destroy(&hdmi->connector);
 	hdmi->encoder.funcs->destroy(&hdmi->encoder);
-
-	clk_disable_unprepare(hdmi->iahb_clk);
-	clk_disable_unprepare(hdmi->isfr_clk);
+	if (hdmi->plat_data->exit)
+		hdmi->plat_data->exit(hdmi->priv);
 	i2c_put_adapter(hdmi->ddc);
 }
 
@@ -1749,17 +1618,32 @@ static int imx_hdmi_platform_remove(struct platform_device *pdev)
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
+int imx_hdmi_pltfm_register(struct platform_device *pdev,
+			    const struct imx_hdmi_plat_data *plat_data)
+{
+	struct imx_hdmi *hdmi;
 
-module_platform_driver(imx_hdmi_driver);
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
+
+	return imx_hdmi_platform_probe(pdev);
+}
+EXPORT_SYMBOL_GPL(imx_hdmi_pltfm_register);
+
+int imx_hdmi_pltfm_unregister(struct platform_device *pdev)
+{
+	return imx_hdmi_platform_remove(pdev);
+}
+EXPORT_SYMBOL_GPL(imx_hdmi_pltfm_unregister);
 
 MODULE_AUTHOR("Sascha Hauer <s.hauer@pengutronix.de>");
 MODULE_DESCRIPTION("i.MX6 HDMI transmitter driver");
diff --git a/include/drm/bridge/dw_hdmi.h b/include/drm/bridge/dw_hdmi.h
new file mode 100644
index 0000000..e7e8285
--- /dev/null
+++ b/include/drm/bridge/dw_hdmi.h
@@ -0,0 +1,114 @@
+/*
+ * Copyright (C) 2011 Freescale Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __DW_HDMI_H__
+#define __DW_HDMI_H__
+
+#include <drm/drmP.h>
+
+#define HDMI_EDID_LEN           512
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
+struct hdmi_vmode {
+	bool mdvi;
+	bool mhsyncpolarity;
+	bool mvsyncpolarity;
+	bool minterlaced;
+	bool mdataenablepolarity;
+
+	unsigned int mpixelclock;
+	unsigned int mpixelrepetitioninput;
+	unsigned int mpixelrepetitionoutput;
+};
+
+struct hdmi_data_info {
+	unsigned int enc_in_format;
+	unsigned int enc_out_format;
+	unsigned int enc_color_depth;
+	unsigned int colorimetry;
+	unsigned int pix_repet_factor;
+	unsigned int hdcp_enable;
+	struct hdmi_vmode video_mode;
+};
+
+
+struct imx_hdmi {
+	struct drm_connector connector;
+	struct drm_encoder encoder;
+
+	enum imx_hdmi_devtype dev_type;
+	struct device *dev;
+
+	struct hdmi_data_info hdmi_data;
+	const struct imx_hdmi_plat_data *plat_data;
+	void *priv;
+
+	int vic;
+
+	u8 edid[HDMI_EDID_LEN];
+	bool cable_plugin;
+
+	bool phy_enabled;
+	struct drm_display_mode previous_mode;
+
+	struct i2c_adapter *ddc;
+	void __iomem *regs;
+
+	unsigned int sample_rate;
+	int ratio;
+
+	void (*write)(struct imx_hdmi *hdmi, u32 val, int offset);
+	u32 (*read)(struct imx_hdmi *hdmi, int offset);
+	void (*mod)(struct imx_hdmi *hdmi, u32 data, u32 mask, unsigned reg);
+	void (*mask_write)(struct imx_hdmi *hdmi, u32 data, unsigned int reg,
+			      u32 shift, u32 mask);
+};
+
+struct imx_hdmi_plat_data {
+	void * (*setup)(struct platform_device *pdev);
+	void (*exit)(void *priv);
+	void (*set_crtc_mux)(void *priv, struct drm_encoder *encoder);
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
+int imx_hdmi_pltfm_register(struct platform_device *pdev,
+			    const struct imx_hdmi_plat_data *plat_data);
+int imx_hdmi_pltfm_unregister(struct platform_device *pdev);
+#endif /* __IMX_HDMI_H__ */
-- 
1.9.1


