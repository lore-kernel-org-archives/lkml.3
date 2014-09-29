Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbaI2SE0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 14:04:26 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45766 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168AbaI2SEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 14:04:20 -0400
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
Subject: [PATCH v5 1/6] of: Decrement refcount of previous endpoint in of_graph_get_next_endpoint
Date: Mon, 29 Sep 2014 20:03:34 +0200
Message-Id: <1412013819-29181-2-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1412013819-29181-1-git-send-email-p.zabel@pengutronix.de>
References: <1412013819-29181-1-git-send-email-p.zabel@pengutronix.de>
X-SA-Exim-Connect-IP: 10.1.0.120
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Decrementing the reference count of the previous endpoint node allows to
use the of_graph_get_next_endpoint function in a for_each_... style macro.
All current users of this function that pass a non-NULL prev parameter
(that is, soc_camera and imx-drm) are changed to not decrement the passed
prev argument's refcount themselves.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v4:
 - Folded patches 1-3 into this one
---
 drivers/media/platform/soc_camera/soc_camera.c |  3 ++-
 drivers/of/base.c                              |  9 +--------
 drivers/staging/imx-drm/imx-drm-core.c         | 12 ++----------
 3 files changed, 5 insertions(+), 19 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index f4308fe..619b2d4 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1696,7 +1696,6 @@ static void scan_of_host(struct soc_camera_host *ici)
 		if (!i)
 			soc_of_bind(ici, epn, ren->parent);
 
-		of_node_put(epn);
 		of_node_put(ren);
 
 		if (i) {
@@ -1704,6 +1703,8 @@ static void scan_of_host(struct soc_camera_host *ici)
 			break;
 		}
 	}
+
+	of_node_put(epn);
 }
 
 #else
diff --git a/drivers/of/base.c b/drivers/of/base.c
index 293ed4b..f7a9aa8 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -2070,8 +2070,7 @@ EXPORT_SYMBOL(of_graph_parse_endpoint);
  * @prev: previous endpoint node, or NULL to get first
  *
  * Return: An 'endpoint' node pointer with refcount incremented. Refcount
- * of the passed @prev node is not decremented, the caller have to use
- * of_node_put() on it when done.
+ * of the passed @prev node is decremented.
  */
 struct device_node *of_graph_get_next_endpoint(const struct device_node *parent,
 					struct device_node *prev)
@@ -2107,12 +2106,6 @@ struct device_node *of_graph_get_next_endpoint(const struct device_node *parent,
 		if (WARN_ONCE(!port, "%s(): endpoint %s has no parent node\n",
 			      __func__, prev->full_name))
 			return NULL;
-
-		/*
-		 * Avoid dropping prev node refcount to 0 when getting the next
-		 * child below.
-		 */
-		of_node_get(prev);
 	}
 
 	while (1) {
diff --git a/drivers/staging/imx-drm/imx-drm-core.c b/drivers/staging/imx-drm/imx-drm-core.c
index 6b22106..12303b3 100644
--- a/drivers/staging/imx-drm/imx-drm-core.c
+++ b/drivers/staging/imx-drm/imx-drm-core.c
@@ -434,14 +434,6 @@ static uint32_t imx_drm_find_crtc_mask(struct imx_drm_device *imxdrm,
 	return 0;
 }
 
-static struct device_node *imx_drm_of_get_next_endpoint(
-		const struct device_node *parent, struct device_node *prev)
-{
-	struct device_node *node = of_graph_get_next_endpoint(parent, prev);
-	of_node_put(prev);
-	return node;
-}
-
 int imx_drm_encoder_parse_of(struct drm_device *drm,
 	struct drm_encoder *encoder, struct device_node *np)
 {
@@ -453,7 +445,7 @@ int imx_drm_encoder_parse_of(struct drm_device *drm,
 	for (i = 0; ; i++) {
 		u32 mask;
 
-		ep = imx_drm_of_get_next_endpoint(np, ep);
+		ep = of_graph_get_next_endpoint(np, ep);
 		if (!ep)
 			break;
 
@@ -502,7 +494,7 @@ int imx_drm_encoder_get_mux_id(struct device_node *node,
 		return -EINVAL;
 
 	do {
-		ep = imx_drm_of_get_next_endpoint(node, ep);
+		ep = of_graph_get_next_endpoint(node, ep);
 		if (!ep)
 			break;
 
-- 
2.1.0

