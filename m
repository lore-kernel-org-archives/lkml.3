Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbaLALY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:24:26 -0500
Received: from lucky1.263xmail.com ([211.157.147.130]:33720 "EHLO
	lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133AbaLALYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:24:19 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 1
X-MAIL-DELIVERY: 0
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: airlied@linux.ie
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <0d706c9c30f0a92b47b529f1fd8201a5>
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
        Kumar Gala <galak@codeaurora.org>, Andy Yan <andy.yan@rock-chips.com>
Subject: [PATCH v14 04/12] drm: imx: imx-hdmi: split phy configuration to platform driver
Date: Mon,  1 Dec 2014 19:23:52 +0800
Message-Id: <1417433032-12914-1-git-send-email-andy.yan@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417432770-12719-1-git-send-email-andy.yan@rock-chips.com>
References: <1417432770-12719-1-git-send-email-andy.yan@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hdmi phy configuration is platform specific, which can be adusted
according to the board to get the best SI

Signed-off-by: Andy Yan <andy.yan@rock-chips.com>

---

Changes in v14: None
Changes in v13:
- split phy configuration from patch#4

Changes in v12: None
Changes in v11: None
Changes in v10: None
Changes in v9: None
Changes in v8: None
Changes in v7: None
Changes in v6: None
Changes in v5: None
Changes in v4: None
Changes in v3: None

 drivers/gpu/drm/imx/imx-hdmi.c       | 85 +++++++-----------------------------
 drivers/gpu/drm/imx/imx-hdmi.h       | 29 ++++++++++++
 drivers/gpu/drm/imx/imx-hdmi_pltfm.c | 57 ++++++++++++++++++++++++
 3 files changed, 101 insertions(+), 70 deletions(-)

diff --git a/drivers/gpu/drm/imx/imx-hdmi.c b/drivers/gpu/drm/imx/imx-hdmi.c
index f05b404..99c2966 100644
--- a/drivers/gpu/drm/imx/imx-hdmi.c
+++ b/drivers/gpu/drm/imx/imx-hdmi.c
@@ -710,76 +710,14 @@ static void imx_hdmi_phy_sel_interface_control(struct imx_hdmi *hdmi, u8 enable)
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
+	const struct mpll_config *mpll_config = hdmi->plat_data->mpll_cfg;
+	const struct curr_ctrl   *curr_ctrl = hdmi->plat_data->cur_ctr;
+	const struct sym_term *sym_term =  hdmi->plat_data->sym_term;
 
 	if (prep)
 		return -EINVAL;
@@ -825,7 +763,7 @@ static int hdmi_phy_configure(struct imx_hdmi *hdmi, unsigned char prep,
 	hdmi_phy_test_clear(hdmi, 0);
 
 	/* PLL/MPLL Cfg - always match on final entry */
-	for (i = 0; i < ARRAY_SIZE(mpll_config) - 1; i++)
+	for (i = 0; mpll_config[i].mpixelclock != (~0UL); i++)
 		if (hdmi->hdmi_data.video_mode.mpixelclock <=
 		    mpll_config[i].mpixelclock)
 			break;
@@ -833,12 +771,12 @@ static int hdmi_phy_configure(struct imx_hdmi *hdmi, unsigned char prep,
 	hdmi_phy_i2c_write(hdmi, mpll_config[i].res[res_idx].cpce, 0x06);
 	hdmi_phy_i2c_write(hdmi, mpll_config[i].res[res_idx].gmp, 0x15);
 
-	for (i = 0; i < ARRAY_SIZE(curr_ctrl); i++)
+	for (i = 0; curr_ctrl[i].mpixelclock != (~0UL); i++)
 		if (hdmi->hdmi_data.video_mode.mpixelclock <=
 		    curr_ctrl[i].mpixelclock)
 			break;
 
-	if (i >= ARRAY_SIZE(curr_ctrl)) {
+	if (curr_ctrl[i].mpixelclock == (~0UL)) {
 		dev_err(hdmi->dev, "Pixel clock %d - unsupported by HDMI\n",
 			hdmi->hdmi_data.video_mode.mpixelclock);
 		return -EINVAL;
@@ -849,10 +787,17 @@ static int hdmi_phy_configure(struct imx_hdmi *hdmi, unsigned char prep,
 
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
diff --git a/drivers/gpu/drm/imx/imx-hdmi.h b/drivers/gpu/drm/imx/imx-hdmi.h
index 14e593e..bced9ef 100644
--- a/drivers/gpu/drm/imx/imx-hdmi.h
+++ b/drivers/gpu/drm/imx/imx-hdmi.h
@@ -1037,6 +1037,35 @@ enum imx_hdmi_devtype {
 
 struct imx_hdmi_plat_data {
 	enum imx_hdmi_devtype dev_type;
+	const struct mpll_config *mpll_cfg;
+	const struct curr_ctrl *cur_ctr;
+	const struct sym_term *sym_term;
+};
+
+enum {
+	RES_8,
+	RES_10,
+	RES_12,
+	RES_MAX,
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
+struct sym_term {
+	unsigned long mpixelclock;
+	u16 sym_ctr;    /*clock symbol and transmitter control*/
+	u16 term;       /*transmission termination value*/
 };
 
 int imx_hdmi_bind(struct device *dev, struct device *master,
diff --git a/drivers/gpu/drm/imx/imx-hdmi_pltfm.c b/drivers/gpu/drm/imx/imx-hdmi_pltfm.c
index 8ab70c8..da330e0 100644
--- a/drivers/gpu/drm/imx/imx-hdmi_pltfm.c
+++ b/drivers/gpu/drm/imx/imx-hdmi_pltfm.c
@@ -31,6 +31,57 @@ struct imx_hdmi_priv {
 	struct regmap *regmap;
 };
 
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
+static const struct sym_term imx_sym_term[] = {
+	/*pixelclk   symbol   term*/
+	{ 148500000, 0x800d, 0x0005 },
+	{ ~0UL,      0x0000, 0x0000 }
+};
+
 static int imx_hdmi_parse_dt(struct imx_hdmi_priv *hdmi)
 {
 	struct device_node *np = hdmi->dev->of_node;
@@ -103,10 +154,16 @@ static struct drm_encoder_funcs imx_hdmi_encoder_funcs = {
 };
 
 static struct imx_hdmi_plat_data imx6q_hdmi_drv_data = {
+	.mpll_cfg = imx_mpll_cfg,
+	.cur_ctr  = imx_cur_ctr,
+	.sym_term = imx_sym_term,
 	.dev_type = IMX6Q_HDMI,
 };
 
 static struct imx_hdmi_plat_data imx6dl_hdmi_drv_data = {
+	.mpll_cfg = imx_mpll_cfg,
+	.cur_ctr  = imx_cur_ctr,
+	.sym_term = imx_sym_term,
 	.dev_type = IMX6DL_HDMI,
 };
 
-- 
1.9.1


