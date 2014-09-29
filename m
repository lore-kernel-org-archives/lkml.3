Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbaI2IQ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 04:16:57 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48377 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbaI2IQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 04:16:54 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, kernel@pengutronix.de,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v4 8/8] imx-drm: use for_each_endpoint_of_node macro in imx_drm_encoder_parse_of
Date: Mon, 29 Sep 2014 10:15:51 +0200
Message-Id: <1411978551-30480-9-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1411978551-30480-1-git-send-email-p.zabel@pengutronix.de>
References: <1411978551-30480-1-git-send-email-p.zabel@pengutronix.de>
X-SA-Exim-Connect-IP: 10.1.0.120
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the for_each_... macro should make the code bit shorter and
easier to read. Since we can break out of the loop, we keep the
call to of_node_put after the loop.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v3:
 - Kept of_node_put after the loop, as in the earlier soc_camera patch.
   This reduces the line count and is safe to do since of_node_put(NULL)
   is a no-op.
---
 drivers/staging/imx-drm/imx-drm-core.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/imx-drm/imx-drm-core.c b/drivers/staging/imx-drm/imx-drm-core.c
index 69e7194..43285dc 100644
--- a/drivers/staging/imx-drm/imx-drm-core.c
+++ b/drivers/staging/imx-drm/imx-drm-core.c
@@ -439,17 +439,13 @@ int imx_drm_encoder_parse_of(struct drm_device *drm,
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
@@ -462,6 +458,7 @@ int imx_drm_encoder_parse_of(struct drm_device *drm,
 			return -EPROBE_DEFER;
 
 		crtc_mask |= mask;
+		i++;
 	}
 
 	of_node_put(ep);
-- 
2.1.0

