Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbaLAL1H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:27:07 -0500
Received: from lucky1.263xmail.com ([211.157.147.132]:55686 "EHLO
	lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105AbaLAL1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:27:06 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 1
X-MAIL-DELIVERY: 0
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: airlied@linux.ie
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <ee895dff71c6a2672cef3b5c66d2e1d0>
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
Subject: [PATCH v14 08/12] drm: bridge/dw_hdmi: add mode_valid support
Date: Mon,  1 Dec 2014 19:26:37 +0800
Message-Id: <1417433197-13115-1-git-send-email-andy.yan@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417432770-12719-1-git-send-email-andy.yan@rock-chips.com>
References: <1417432770-12719-1-git-send-email-andy.yan@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

some platform may not support all the display mode,
add mode_valid interface check it

Signed-off-by: Andy Yan <andy.yan@rock-chips.com>

---

Changes in v14:
- remove drm_connector_register, because imx-drm core has registered
connector

Changes in v13: None
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

 drivers/gpu/drm/bridge/dw_hdmi.c | 15 +++++++++++++++
 include/drm/bridge/dw_hdmi.h     |  2 ++
 2 files changed, 17 insertions(+)

diff --git a/drivers/gpu/drm/bridge/dw_hdmi.c b/drivers/gpu/drm/bridge/dw_hdmi.c
index 5e88c8d..a95a553 100644
--- a/drivers/gpu/drm/bridge/dw_hdmi.c
+++ b/drivers/gpu/drm/bridge/dw_hdmi.c
@@ -1406,6 +1406,20 @@ static int dw_hdmi_connector_get_modes(struct drm_connector *connector)
 	return 0;
 }
 
+static enum drm_mode_status
+dw_hdmi_connector_mode_valid(struct drm_connector *connector,
+			     struct drm_display_mode *mode)
+{
+	struct dw_hdmi *hdmi = container_of(connector,
+					   struct dw_hdmi, connector);
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
@@ -1430,6 +1444,7 @@ static struct drm_connector_funcs dw_hdmi_connector_funcs = {
 
 static struct drm_connector_helper_funcs dw_hdmi_connector_helper_funcs = {
 	.get_modes = dw_hdmi_connector_get_modes,
+	.mode_valid = dw_hdmi_connector_mode_valid,
 	.best_encoder = dw_hdmi_connector_best_encoder,
 };
 
diff --git a/include/drm/bridge/dw_hdmi.h b/include/drm/bridge/dw_hdmi.h
index 1bbf3ca..1777ab4 100644
--- a/include/drm/bridge/dw_hdmi.h
+++ b/include/drm/bridge/dw_hdmi.h
@@ -48,6 +48,8 @@ struct dw_hdmi_plat_data {
 	const struct mpll_config *mpll_cfg;
 	const struct curr_ctrl *cur_ctr;
 	const struct sym_term *sym_term;
+	enum drm_mode_status (*mode_valid)(struct drm_connector *connector,
+			      struct drm_display_mode *mode);
 };
 
 void dw_hdmi_unbind(struct device *dev, struct device *master, void *data);
-- 
1.9.1


