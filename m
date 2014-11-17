Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433AbaKQK4L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 05:56:11 -0500
Received: from regular1.263xmail.com ([211.150.99.139]:54469 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaKQK4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 05:56:09 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: airlied@linux.ie
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <708809be8ac44caf9eaf800e93fe157d>
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
Subject: [PATCH v12 03/11] staging: imx-drm: imx-hdmi: convert imx-hdmi to drm_bridge mode
Date: Mon, 17 Nov 2014 18:55:48 +0800
Message-Id: <1416221748-12938-1-git-send-email-andy.yan@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415793593-5075-1-git-send-email-andy.yan@rock-chips.com>
References: <1415793593-5075-1-git-send-email-andy.yan@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IMX6 and Rockchip RK3288 and JZ4780 (Ingenic Xburst/MIPS)
use the interface compatible Designware HDMI IP, but they
also have some lightly differences, such as phy pll configuration,
register width, 4K support, clk useage, and the crtc mux configuration
is also platform specific.

To reuse the imx hdmi driver, convert it to drm_bridge

Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
Signed-off-by: Yakir Yang <ykk@rock-chips.com>

---

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
Changes in v2: None

 drivers/staging/imx-drm/imx-hdmi.c | 498 +++++++++++++++++++++++--------------
 1 file changed, 314 insertions(+), 184 deletions(-)

diff --git a/drivers/staging/imx-drm/imx-hdmi.c b/drivers/staging/imx-drm/imx-hdmi.c
index 8029a07..c42da29 100644
--- a/drivers/staging/imx-drm/imx-hdmi.c
+++ b/drivers/staging/imx-drm/imx-hdmi.c
@@ -23,6 +23,7 @@
 #include <linux/mfd/syscon/imx6q-iomuxc-gpr.h>
 #include <linux/of_device.h>
 
+#include <drm/drm_of.h>
 #include <drm/drmP.h>
 #include <drm/drm_crtc_helper.h>
 #include <drm/drm_edid.h>
@@ -111,16 +112,24 @@ struct hdmi_data_info {
 	struct hdmi_vmode video_mode;
 };
 
+struct imx_hdmi_plat_data {
+	const struct mpll_config *mpll_cfg;
+	const struct curr_ctrl *cur_ctr;
+	const struct sym_term *sym_term;
+	enum imx_hdmi_devtype dev_type;
+};
+
 struct imx_hdmi {
 	struct drm_connector connector;
-	struct drm_encoder encoder;
+	struct drm_encoder *encoder;
+	struct drm_bridge *bridge;
 
 	enum imx_hdmi_devtype dev_type;
 	struct device *dev;
-	struct clk *isfr_clk;
-	struct clk *iahb_clk;
 
 	struct hdmi_data_info hdmi_data;
+	const struct imx_hdmi_plat_data *plat_data;
+	void *priv;
 	int vic;
 
 	u8 edid[HDMI_EDID_LEN];
@@ -137,12 +146,13 @@ struct imx_hdmi {
 	int ratio;
 };
 
-static void imx_hdmi_set_ipu_di_mux(struct imx_hdmi *hdmi, int ipu_di)
-{
-	regmap_update_bits(hdmi->regmap, IOMUXC_GPR3,
-			   IMX6Q_GPR3_HDMI_MUX_CTL_MASK,
-			   ipu_di << IMX6Q_GPR3_HDMI_MUX_CTL_SHIFT);
-}
+struct imx_hdmi_priv {
+	struct device *dev;
+	struct clk *isfr_clk;
+	struct clk *iahb_clk;
+	struct regmap *regmap;
+	struct drm_encoder encoder;
+};
 
 static inline void hdmi_writeb(struct imx_hdmi *hdmi, u8 val, int offset)
 {
@@ -743,7 +753,7 @@ struct mpll_config {
 	} res[RES_MAX];
 };
 
-static const struct mpll_config mpll_config[] = {
+static const struct mpll_config imx_mpll_cfg[] = {
 	{
 		45250000, {
 			{ 0x01e0, 0x0000 },
@@ -776,7 +786,7 @@ struct curr_ctrl {
 	u16 curr[RES_MAX];
 };
 
-static const struct curr_ctrl curr_ctrl[] = {
+static const struct curr_ctrl imx_cur_ctr[] = {
 	/*	pixelclk     bpp8    bpp10   bpp12 */
 	{
 		 54000000, { 0x091c, 0x091c, 0x06dc },
@@ -793,11 +803,26 @@ static const struct curr_ctrl curr_ctrl[] = {
 	}
 };
 
+struct sym_term {
+	unsigned long mpixelclock;
+	u16 sym_ctr;    /*clock symbol and transmitter control*/
+	u16 term;       /*transmission termination value*/
+};
+
+static const struct sym_term imx_sym_term[] = {
+	/*pixelclk   symbol   term*/
+	{ 148500000, 0x800d, 0x0005 },
+	{ ~0UL,      0x0000, 0x0000 }
+};
+
 static int hdmi_phy_configure(struct imx_hdmi *hdmi, unsigned char prep,
 			      unsigned char res, int cscon)
 {
 	unsigned res_idx, i;
 	u8 val, msec;
+	const struct mpll_config *mpll_cfg = hdmi->plat_data->mpll_cfg;
+	const struct curr_ctrl   *curr_ctr = hdmi->plat_data->cur_ctr;
+	const struct sym_term *sym_term =  hdmi->plat_data->sym_term;
 
 	if (prep)
 		return -EINVAL;
@@ -843,34 +868,41 @@ static int hdmi_phy_configure(struct imx_hdmi *hdmi, unsigned char prep,
 	hdmi_phy_test_clear(hdmi, 0);
 
 	/* PLL/MPLL Cfg - always match on final entry */
-	for (i = 0; i < ARRAY_SIZE(mpll_config) - 1; i++)
+	for (i = 0; mpll_cfg[i].mpixelclock != (~0UL); i++)
 		if (hdmi->hdmi_data.video_mode.mpixelclock <=
-		    mpll_config[i].mpixelclock)
+		    mpll_cfg[i].mpixelclock)
 			break;
 
-	hdmi_phy_i2c_write(hdmi, mpll_config[i].res[res_idx].cpce, 0x06);
-	hdmi_phy_i2c_write(hdmi, mpll_config[i].res[res_idx].gmp, 0x15);
+	hdmi_phy_i2c_write(hdmi, mpll_cfg[i].res[res_idx].cpce, 0x06);
+	hdmi_phy_i2c_write(hdmi, mpll_cfg[i].res[res_idx].gmp, 0x15);
 
-	for (i = 0; i < ARRAY_SIZE(curr_ctrl); i++)
+	for (i = 0; curr_ctr[i].mpixelclock != (~0UL); i++)
 		if (hdmi->hdmi_data.video_mode.mpixelclock <=
-		    curr_ctrl[i].mpixelclock)
+		    curr_ctr[i].mpixelclock)
 			break;
 
-	if (i >= ARRAY_SIZE(curr_ctrl)) {
+	if (curr_ctr[i].mpixelclock == (~0UL)) {
 		dev_err(hdmi->dev, "Pixel clock %d - unsupported by HDMI\n",
 			hdmi->hdmi_data.video_mode.mpixelclock);
 		return -EINVAL;
 	}
 
 	/* CURRCTRL */
-	hdmi_phy_i2c_write(hdmi, curr_ctrl[i].curr[res_idx], 0x10);
+	hdmi_phy_i2c_write(hdmi, curr_ctr[i].curr[res_idx], 0x10);
 
 	hdmi_phy_i2c_write(hdmi, 0x0000, 0x13);  /* PLLPHBYCTRL */
 	hdmi_phy_i2c_write(hdmi, 0x0006, 0x17);
+
+	for (i = 0; sym_term[i].mpixelclock != (~0UL); i++)
+		if (hdmi->hdmi_data.video_mode.mpixelclock <=
+		    sym_term[i].mpixelclock)
+			break;
+
 	/* RESISTANCE TERM 133Ohm Cfg */
-	hdmi_phy_i2c_write(hdmi, 0x0005, 0x19);  /* TXTERM */
+	hdmi_phy_i2c_write(hdmi, sym_term[i].term, 0x19);  /* TXTERM */
 	/* PREEMP Cgf 0.00 */
-	hdmi_phy_i2c_write(hdmi, 0x800d, 0x09);  /* CKSYMTXCTRL */
+	hdmi_phy_i2c_write(hdmi, sym_term[i].sym_ctr, 0x09);  /* CKSYMTXCTRL */
+
 	/* TX/CK LVL 10 */
 	hdmi_phy_i2c_write(hdmi, 0x01ad, 0x0E);  /* VLEVCTRL */
 	/* REMOVE CLK TERM */
@@ -1371,6 +1403,50 @@ static void imx_hdmi_poweroff(struct imx_hdmi *hdmi)
 	imx_hdmi_phy_disable(hdmi);
 }
 
+static void imx_hdmi_bridge_mode_set(struct drm_bridge *bridge,
+				    struct drm_display_mode *mode,
+				    struct drm_display_mode *adjusted_mode)
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
+				      const struct drm_display_mode *mode,
+				      struct drm_display_mode *adjusted_mode)
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
@@ -1412,78 +1488,20 @@ static struct drm_encoder *imx_hdmi_connector_best_encoder(struct drm_connector
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
-}
-
-static void imx_hdmi_encoder_prepare(struct drm_encoder *encoder)
-{
-	struct imx_hdmi *hdmi = container_of(encoder, struct imx_hdmi, encoder);
-
-	imx_hdmi_poweroff(hdmi);
-	imx_drm_panel_format(encoder, V4L2_PIX_FMT_RGB24);
+	return hdmi->encoder;
 }
 
-static void imx_hdmi_encoder_commit(struct drm_encoder *encoder)
+static void imx_hdmi_connector_destroy(struct drm_connector *connector)
 {
-	struct imx_hdmi *hdmi = container_of(encoder, struct imx_hdmi, encoder);
-	int mux = imx_drm_encoder_get_mux_id(hdmi->dev->of_node, encoder);
-
-	imx_hdmi_set_ipu_di_mux(hdmi, mux);
-
-	imx_hdmi_poweron(hdmi);
+	drm_connector_unregister(connector);
+	drm_connector_cleanup(connector);
 }
 
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
@@ -1491,6 +1509,16 @@ static struct drm_connector_helper_funcs imx_hdmi_connector_helper_funcs = {
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
@@ -1539,74 +1567,62 @@ static irqreturn_t imx_hdmi_irq(int irq, void *dev_id)
 
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
 
-	drm_encoder_helper_add(&hdmi->encoder, &imx_hdmi_encoder_helper_funcs);
-	drm_encoder_init(drm, &hdmi->encoder, &imx_hdmi_encoder_funcs,
-			 DRM_MODE_ENCODER_TMDS);
+	ret = drm_bridge_init(drm, bridge, &imx_hdmi_bridge_funcs);
+	if (ret) {
+		DRM_ERROR("Failed to initialize bridge with drm\n");
+		return -EINVAL;
+	}
+
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
+int _imx_hdmi_bind(struct device *dev, struct device *master,
+		 void *data, struct drm_encoder *encoder,
+		 const struct imx_hdmi_plat_data *plat_data)
 {
 	struct platform_device *pdev = to_platform_device(dev);
-	const struct of_device_id *of_id =
-				of_match_device(imx_hdmi_dt_ids, dev);
 	struct drm_device *drm = data;
 	struct device_node *np = dev->of_node;
 	struct device_node *ddc_node;
-	struct imx_hdmi *hdmi;
 	struct resource *iores;
+	struct imx_hdmi *hdmi;
 	int ret, irq;
 
-	hdmi = devm_kzalloc(dev, sizeof(*hdmi), GFP_KERNEL);
+	hdmi = devm_kzalloc(&pdev->dev, sizeof(*hdmi), GFP_KERNEL);
 	if (!hdmi)
 		return -ENOMEM;
 
-	hdmi->dev = dev;
+	hdmi->plat_data = plat_data;
+	hdmi->dev = &pdev->dev;
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
@@ -1636,40 +1652,6 @@ static int imx_hdmi_bind(struct device *dev, struct device *master, void *data)
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
 	/* Product and revision IDs */
 	dev_info(dev,
 		 "Detected HDMI controller 0x%x:0x%x:0x%x:0x%x\n",
@@ -1697,11 +1679,11 @@ static int imx_hdmi_bind(struct device *dev, struct device *master, void *data)
 
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
@@ -1709,17 +1691,10 @@ static int imx_hdmi_bind(struct device *dev, struct device *master, void *data)
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
+EXPORT_SYMBOL_GPL(_imx_hdmi_bind);
 
-static void imx_hdmi_unbind(struct device *dev, struct device *master,
-	void *data)
+void _imx_hdmi_unbind(struct device *dev, struct device *master, void *data)
 {
 	struct imx_hdmi *hdmi = dev_get_drvdata(dev);
 
@@ -1727,42 +1702,197 @@ static void imx_hdmi_unbind(struct device *dev, struct device *master,
 	hdmi_writeb(hdmi, ~0, HDMI_IH_MUTE_PHY_STAT0);
 
 	hdmi->connector.funcs->destroy(&hdmi->connector);
-	hdmi->encoder.funcs->destroy(&hdmi->encoder);
+	hdmi->encoder->funcs->destroy(hdmi->encoder);
 
-	clk_disable_unprepare(hdmi->iahb_clk);
-	clk_disable_unprepare(hdmi->isfr_clk);
 	i2c_put_adapter(hdmi->ddc);
 }
+EXPORT_SYMBOL_GPL(_imx_hdmi_unbind);
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
+static void imx_hdmi_disable(struct drm_encoder *encoder)
+{
+
+}
+
+static bool imx_hdmi_mode_fixup(struct drm_encoder *encoder,
+				const struct drm_display_mode *mode,
+				struct drm_display_mode *adjusted_mode)
+{
+	return true;
+}
 
-static const struct component_ops hdmi_ops = {
-	.bind	= imx_hdmi_bind,
-	.unbind	= imx_hdmi_unbind,
+static void imx_hdmi_mode_set(struct drm_encoder *encoder,
+			      struct drm_display_mode *mode,
+			      struct drm_display_mode *adjusted_mode)
+{
+
+}
+
+static void imx_hdmi_commit(struct drm_encoder *encoder)
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
+static void imx_hdmi_prepare(struct drm_encoder *encoder)
+{
+	imx_drm_panel_format(encoder, V4L2_PIX_FMT_RGB24);
+}
+
+static struct drm_encoder_helper_funcs imx_hdmi_encoder_helper_funcs = {
+	.mode_fixup = imx_hdmi_mode_fixup,
+	.mode_set = imx_hdmi_mode_set,
+	.prepare = imx_hdmi_prepare,
+	.commit = imx_hdmi_commit,
+	.disable = imx_hdmi_disable,
+};
+
+static struct drm_encoder_funcs imx_hdmi_encoder_funcs = {
+	.destroy = drm_encoder_cleanup,
+};
+
+static struct imx_hdmi_plat_data imx6q_hdmi_drv_data = {
+	.mpll_cfg               = imx_mpll_cfg,
+	.cur_ctr                = imx_cur_ctr,
+	.sym_term               = imx_sym_term,
+	.dev_type               = IMX6Q_HDMI,
+};
+
+static struct imx_hdmi_plat_data imx6dl_hdmi_drv_data = {
+	.mpll_cfg               = imx_mpll_cfg,
+	.cur_ctr                = imx_cur_ctr,
+	.sym_term               = imx_sym_term,
+	.dev_type               = IMX6DL_HDMI,
 };
 
-static int imx_hdmi_platform_probe(struct platform_device *pdev)
+static const struct of_device_id imx_hdmi_dt_ids[] = {
+{ .compatible = "fsl,imx6q-hdmi", .data = &imx6q_hdmi_drv_data},
+{ .compatible = "fsl,imx6dl-hdmi", .data = &imx6dl_hdmi_drv_data, },
+{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, imx_hdmi_dt_ids);
+
+static int imx_hdmi_bind(struct device *dev, struct device *master,
+			 void *data)
 {
-	return component_add(&pdev->dev, &hdmi_ops);
+	struct platform_device *pdev = to_platform_device(dev);
+	const struct imx_hdmi_plat_data *plat_data;
+	const struct of_device_id *match;
+	struct drm_device *drm = data;
+	struct drm_encoder *encoder;
+	struct imx_hdmi_priv *hdmi;
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
+	platform_set_drvdata(pdev, hdmi);
+
+	ret = imx_hdmi_parse_dt(hdmi);
+	if (ret < 0)
+		return ret;
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
+
+	return _imx_hdmi_bind(dev, master, data, encoder, plat_data);
 }
 
-static int imx_hdmi_platform_remove(struct platform_device *pdev)
+static void imx_hdmi_unbind(struct device *dev, struct device *master,
+			    void *data)
 {
-	component_del(&pdev->dev, &hdmi_ops);
+	struct platform_device *pdev = to_platform_device(dev);
+	struct imx_hdmi_priv *hdmi = platform_get_drvdata(pdev);
+
+	clk_disable_unprepare(hdmi->isfr_clk);
+	clk_disable_unprepare(hdmi->iahb_clk);
+
+	return _imx_hdmi_unbind(dev, master, data);
+}
+
+static const struct component_ops imx_hdmi_ops = {
+	.bind   = imx_hdmi_bind,
+	.unbind = imx_hdmi_unbind,
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
 	return 0;
 }
 
-static struct platform_driver imx_hdmi_driver = {
-	.probe  = imx_hdmi_platform_probe,
-	.remove = imx_hdmi_platform_remove,
+static struct platform_driver imx_hdmi_platform_driver = {
+	.probe  = imx_hdmi_probe,
+	.remove = imx_hdmi_remove,
 	.driver = {
 		.name = "imx-hdmi",
 		.owner = THIS_MODULE,
 		.of_match_table = imx_hdmi_dt_ids,
 	},
 };
-
-module_platform_driver(imx_hdmi_driver);
+module_platform_driver(imx_hdmi_platform_driver);
 
 MODULE_AUTHOR("Sascha Hauer <s.hauer@pengutronix.de>");
+MODULE_AUTHOR("Andy Yan <andy.yan@rock-chips.com>");
+MODULE_AUTHOR("Yakir Yang <ykk@rock-chips.com>");
 MODULE_DESCRIPTION("i.MX6 HDMI transmitter driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:imx-hdmi");
-- 
1.9.1


