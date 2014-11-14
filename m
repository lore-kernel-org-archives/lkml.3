Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935089AbaKND1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 22:27:43 -0500
Received: from va-smtp01.263.net ([54.88.144.211]:35034 "EHLO
	va-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934097AbaKND1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 22:27:41 -0500
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: airlied@linux.ie
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <802c8321ca21cf9b29fe5c16c1e4c65d>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Andy Yan <andy.yan@rock-chips.com>
To: airlied@linux.ie, heiko@sntech.de, fabio.estevam@freescale.com,
        rmk+kernel@arm.linux.org.uk
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, Josh Boyer <jwboyer@redhat.com>,
        Sean Paul <seanpaul@chromium.org>, Inki Dae <inki.dae@samsung.com>,
        Dave Airlie <airlied@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Lucas Stach <l.stach@pengutronix.de>, Zubair.Kakakhel@imgtec.com,
        djkurtz@google.com, ykk@rock-chips.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org, linux-rockchip@lists.infradead.org,
        jay.xu@rock-chips.com, Pawel Moll <pawel.moll@arm.com>,
        mark.yao@rock-chips.com, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Andy Yan <andy.yan@rock-chips.com>
Subject: [PATCH v10 05/11] drm: bridge/dw_hdmi:split some phy configuration to platform driver
Date: Fri, 14 Nov 2014 11:27:11 +0800
Message-Id: <1415935631-16826-1-git-send-email-andy.yan@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415934583-16290-1-git-send-email-andy.yan@rock-chips.com>
References: <1415934583-16290-1-git-send-email-andy.yan@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hdmi phy clock symbol and transmission termination value
can adjust platform specific to get the best SI

also add mode_valid interface for some platform may not support
all the display mode

Signed-off-by: Andy Yan <andy.yan@rock-chips.com>

---

Changes in v10:
- split generic dw_hdmi.c improvements from patch#11 (add rk3288 support)

Changes in v9: None
Changes in v8: None
Changes in v7: None
Changes in v6: None
Changes in v5: None
Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/gpu/drm/bridge/dw_hdmi.c      | 29 +++++++++++++++++++++++++++--
 drivers/staging/imx-drm/dw_hdmi-imx.c | 10 +++++++++-
 include/drm/bridge/dw_hdmi.h          |  7 +++++++
 3 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/bridge/dw_hdmi.c b/drivers/gpu/drm/bridge/dw_hdmi.c
index e9f0dfe..05e7156 100644
--- a/drivers/gpu/drm/bridge/dw_hdmi.c
+++ b/drivers/gpu/drm/bridge/dw_hdmi.c
@@ -718,6 +718,7 @@ static int hdmi_phy_configure(struct dw_hdmi *hdmi, unsigned char prep,
 	u8 val, msec;
 	const struct mpll_config *mpll_cfg = hdmi->plat_data->mpll_cfg;
 	const struct curr_ctrl   *curr_ctr = hdmi->plat_data->cur_ctr;
+	const struct sym_term *sym_term =  hdmi->plat_data->sym_term;
 
 	if (prep)
 		return -EINVAL;
@@ -787,10 +788,17 @@ static int hdmi_phy_configure(struct dw_hdmi *hdmi, unsigned char prep,
 
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
@@ -1326,6 +1334,20 @@ static int dw_hdmi_connector_get_modes(struct drm_connector *connector)
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
@@ -1416,6 +1438,7 @@ static struct drm_connector_funcs dw_hdmi_connector_funcs = {
 
 static struct drm_connector_helper_funcs dw_hdmi_connector_helper_funcs = {
 	.get_modes = dw_hdmi_connector_get_modes,
+	.mode_valid = dw_hdmi_connector_mode_valid,
 	.best_encoder = dw_hdmi_connector_best_encoder,
 };
 
@@ -1487,6 +1510,8 @@ static int dw_hdmi_register(struct drm_device *drm, struct dw_hdmi *hdmi)
 
 	drm_mode_connector_attach_encoder(&hdmi->connector, &hdmi->encoder);
 
+	drm_connector_register(&hdmi->connector);
+
 	return 0;
 }
 
diff --git a/drivers/staging/imx-drm/dw_hdmi-imx.c b/drivers/staging/imx-drm/dw_hdmi-imx.c
index 4b48ea6..d693051 100644
--- a/drivers/staging/imx-drm/dw_hdmi-imx.c
+++ b/drivers/staging/imx-drm/dw_hdmi-imx.c
@@ -69,7 +69,13 @@ static const struct curr_ctrl imx_cur_ctr[] = {
 	}
 };
 
-static int dw_hdmi_parse_dt(struct imx_hdmi *hdmi)
+static const struct sym_term imx_sym_term[] = {
+	/*pixelclk   symbol   term*/
+	{ 148500000, 0x800d, 0x0005 },
+	{ ~0UL,      0x0000, 0x0000 }
+};
+
+static int dw_hdmi_imx_parse_dt(struct imx_hdmi *hdmi)
 {
 	struct device_node *np = hdmi->dev->of_node;
 
@@ -156,6 +162,7 @@ static struct dw_hdmi_plat_data imx6q_hdmi_drv_data = {
 	.encoder_prepare	= dw_hdmi_imx_encoder_prepare,
 	.mpll_cfg		= imx_mpll_cfg,
 	.cur_ctr		= imx_cur_ctr,
+	.sym_term		= imx_sym_term,
 	.dev_type		= IMX6Q_HDMI,
 };
 
@@ -166,6 +173,7 @@ static struct dw_hdmi_plat_data imx6dl_hdmi_drv_data = {
 	.encoder_prepare	= dw_hdmi_imx_encoder_prepare,
 	.mpll_cfg		= imx_mpll_cfg,
 	.cur_ctr		= imx_cur_ctr,
+	.sym_term		= imx_sym_term,
 	.dev_type		= IMX6DL_HDMI,
 };
 
diff --git a/include/drm/bridge/dw_hdmi.h b/include/drm/bridge/dw_hdmi.h
index 6683b63..1688ec9 100644
--- a/include/drm/bridge/dw_hdmi.h
+++ b/include/drm/bridge/dw_hdmi.h
@@ -37,6 +37,12 @@ struct curr_ctrl {
 	u16 curr[RES_MAX];
 };
 
+struct sym_term {
+	unsigned long mpixelclock;
+	u16 sym_ctr;	/*clock symbol and transmitter control*/
+	u16 term;	/*transmission termination value*/
+};
+
 struct dw_hdmi_plat_data {
 	void * (*setup)(struct platform_device *pdev);
 	void (*exit)(void *priv);
@@ -47,6 +53,7 @@ struct dw_hdmi_plat_data {
 					   struct drm_display_mode *mode);
 	const struct mpll_config *mpll_cfg;
 	const struct curr_ctrl *cur_ctr;
+	const struct sym_term *sym_term;
 	enum dw_hdmi_devtype dev_type;
 
 };
-- 
1.9.1

