Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbaIKPd1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 11:33:27 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55913 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756339AbaIKPdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 11:33:17 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, kernel@pengutronix.de,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v3 8/8] imx-drm: use for_each_endpoint_of_node macro in imx_drm_encoder_parse_of
Date: Thu, 11 Sep 2014 17:33:07 +0200
Message-Id: <1410449587-1677-9-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1410449587-1677-1-git-send-email-p.zabel@pengutronix.de>
References: <1410449587-1677-1-git-send-email-p.zabel@pengutronix.de>
X-SA-Exim-Connect-IP: 10.1.0.120
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the for_each_... macro should make the code bit shorter and
easier to read.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/staging/imx-drm/imx-drm-core.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/imx-drm/imx-drm-core.c b/drivers/staging/imx-drm/imx-drm-core.c
index 9b5222c..460d785 100644
--- a/drivers/staging/imx-drm/imx-drm-core.c
+++ b/drivers/staging/imx-drm/imx-drm-core.c
@@ -438,17 +438,13 @@ int imx_drm_encoder_parse_of(struct drm_device *drm,
 	struct drm_encoder *encoder, struct device_node *np)
 {
 	struct imx_drm_device *imxdrm = drm->dev_private;
-	struct device_node *ep = NULL;
+	struct device_node *ep;
 	uint32_t crtc_mask = 0;
-	int i;
+	int i = 0;
 
-	for (i = 0; ; i++) {
+	for_each_endpoint_of_node(np, ep) {
 		u32 mask;
 
-		ep = of_graph_get_next_endpoint(np, ep);
-		if (!ep)
-			break;
-
 		mask = imx_drm_find_crtc_mask(imxdrm, ep);
 
 		/*
@@ -457,14 +453,15 @@ int imx_drm_encoder_parse_of(struct drm_device *drm,
 		 * not been registered yet.  Defer probing, and hope that
 		 * the required CRTC is added later.
 		 */
-		if (mask == 0)
+		if (mask == 0) {
+			of_node_put(ep);
 			return -EPROBE_DEFER;
+		}
 
 		crtc_mask |= mask;
+		i++;
 	}
 
-	if (ep)
-		of_node_put(ep);
 	if (i == 0)
 		return -ENOENT;
 
-- 
2.1.0

