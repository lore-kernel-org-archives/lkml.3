Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbaI2IQs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 04:16:48 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48365 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbaI2IQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 04:16:46 -0400
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
Subject: [PATCH v4 2/8] imx-drm: Do not decrement endpoint node refcount in the loop
Date: Mon, 29 Sep 2014 10:15:45 +0200
Message-Id: <1411978551-30480-3-git-send-email-p.zabel@pengutronix.de>
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

In preparation for the following patch, stop decrementing the endpoint node
refcount in the loop. This temporarily leaks a reference to the endpoint node,
which will be fixed by having of_graph_get_next_endpoint decrement the refcount
of its prev argument instead.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v3:
 - Rebased on top of 30e94a564d079f71f53368733720caa0c7c413c8
   (staging: imx-drm: Lines over 80 characters fixed.), which
   added a blank line in imx_drm_of_get_next_endpoint.
---
 drivers/staging/imx-drm/imx-drm-core.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/imx-drm/imx-drm-core.c b/drivers/staging/imx-drm/imx-drm-core.c
index 4289cc8..fab79ad 100644
--- a/drivers/staging/imx-drm/imx-drm-core.c
+++ b/drivers/staging/imx-drm/imx-drm-core.c
@@ -435,15 +435,6 @@ static uint32_t imx_drm_find_crtc_mask(struct imx_drm_device *imxdrm,
 	return 0;
 }
 
-static struct device_node *imx_drm_of_get_next_endpoint(
-		const struct device_node *parent, struct device_node *prev)
-{
-	struct device_node *node = of_graph_get_next_endpoint(parent, prev);
-
-	of_node_put(prev);
-	return node;
-}
-
 int imx_drm_encoder_parse_of(struct drm_device *drm,
 	struct drm_encoder *encoder, struct device_node *np)
 {
@@ -455,7 +446,7 @@ int imx_drm_encoder_parse_of(struct drm_device *drm,
 	for (i = 0; ; i++) {
 		u32 mask;
 
-		ep = imx_drm_of_get_next_endpoint(np, ep);
+		ep = of_graph_get_next_endpoint(np, ep);
 		if (!ep)
 			break;
 
@@ -503,7 +494,7 @@ int imx_drm_encoder_get_mux_id(struct device_node *node,
 		return -EINVAL;
 
 	do {
-		ep = imx_drm_of_get_next_endpoint(node, ep);
+		ep = of_graph_get_next_endpoint(node, ep);
 		if (!ep)
 			break;
 
-- 
2.1.0

