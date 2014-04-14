Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582AbaDNVxl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:53:41 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54424 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569AbaDNVxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:53:34 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: devel@driverdev.osuosl.org, Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 8/8] imx-drm: ipu-dc: Disable DC module when not in use
Date: Mon, 14 Apr 2014 23:53:23 +0200
Message-Id: <1397512403-19622-9-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397512403-19622-1-git-send-email-p.zabel@pengutronix.de>
References: <1397512403-19622-1-git-send-email-p.zabel@pengutronix.de>
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h |  2 ++
 drivers/staging/imx-drm/ipu-v3/ipu-dc.c     | 14 ++++++++++++--
 drivers/staging/imx-drm/ipuv3-crtc.c        |  8 ++++++--
 3 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h b/drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h
index 8678ad1..c2c6fab 100644
--- a/drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h
+++ b/drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h
@@ -115,8 +115,10 @@ struct ipu_dc *ipu_dc_get(struct ipu_soc *ipu, int channel);
 void ipu_dc_put(struct ipu_dc *dc);
 int ipu_dc_init_sync(struct ipu_dc *dc, struct ipu_di *di, bool interlaced,
 		u32 pixel_fmt, u32 width);
+void ipu_dc_enable(struct ipu_soc *ipu);
 void ipu_dc_enable_channel(struct ipu_dc *dc);
 void ipu_dc_disable_channel(struct ipu_dc *dc);
+void ipu_dc_disable(struct ipu_soc *ipu);
 
 /*
  * IPU Display Interface (di) functions
diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-dc.c b/drivers/staging/imx-drm/ipu-v3/ipu-dc.c
index 280e494..93b2709 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-dc.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-dc.c
@@ -224,12 +224,16 @@ int ipu_dc_init_sync(struct ipu_dc *dc, struct ipu_di *di, bool interlaced,
 	writel(0x0, dc->base + DC_WR_CH_ADDR);
 	writel(width, priv->dc_reg + DC_DISP_CONF2(dc->di));
 
-	ipu_module_enable(priv->ipu, IPU_CONF_DC_EN);
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ipu_dc_init_sync);
 
+void ipu_dc_enable(struct ipu_soc *ipu)
+{
+	ipu_module_enable(ipu, IPU_CONF_DC_EN);
+}
+EXPORT_SYMBOL_GPL(ipu_dc_enable);
+
 void ipu_dc_enable_channel(struct ipu_dc *dc)
 {
 	int di;
@@ -286,6 +290,12 @@ void ipu_dc_disable_channel(struct ipu_dc *dc)
 }
 EXPORT_SYMBOL_GPL(ipu_dc_disable_channel);
 
+void ipu_dc_disable(struct ipu_soc *ipu)
+{
+	ipu_module_disable(ipu, IPU_CONF_DC_EN);
+}
+EXPORT_SYMBOL_GPL(ipu_dc_disable);
+
 static void ipu_dc_map_config(struct ipu_dc_priv *priv, enum ipu_dc_map map,
 		int byte_num, int offset, int mask)
 {
diff --git a/drivers/staging/imx-drm/ipuv3-crtc.c b/drivers/staging/imx-drm/ipuv3-crtc.c
index c771ac1..4c6262f 100644
--- a/drivers/staging/imx-drm/ipuv3-crtc.c
+++ b/drivers/staging/imx-drm/ipuv3-crtc.c
@@ -60,10 +60,12 @@ struct ipu_crtc {
 
 static void ipu_fb_enable(struct ipu_crtc *ipu_crtc)
 {
+	struct ipu_soc *ipu = dev_get_drvdata(ipu_crtc->dev->parent);
+
 	if (ipu_crtc->enabled)
 		return;
 
-	/* TODO: Enable DC module here, right now it is never disabled */
+	ipu_dc_enable(ipu);
 	ipu_plane_enable(ipu_crtc->plane[0]);
 	/* Start DC channel and DI after IDMAC */
 	ipu_dc_enable_channel(ipu_crtc->dc);
@@ -74,6 +76,8 @@ static void ipu_fb_enable(struct ipu_crtc *ipu_crtc)
 
 static void ipu_fb_disable(struct ipu_crtc *ipu_crtc)
 {
+	struct ipu_soc *ipu = dev_get_drvdata(ipu_crtc->dev->parent);
+
 	if (!ipu_crtc->enabled)
 		return;
 
@@ -81,7 +85,7 @@ static void ipu_fb_disable(struct ipu_crtc *ipu_crtc)
 	ipu_dc_disable_channel(ipu_crtc->dc);
 	ipu_di_disable(ipu_crtc->di);
 	ipu_plane_disable(ipu_crtc->plane[0]);
-	/* TODO: Disable DC module here */
+	ipu_dc_disable(ipu);
 
 	ipu_crtc->enabled = 0;
 }
-- 
1.9.1

