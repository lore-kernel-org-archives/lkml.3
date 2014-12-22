Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266AbaLVPLr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 10:11:47 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50632 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755247AbaLVPLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 10:11:44 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Grant Likely <grant.likely@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        David Airlie <airlied@linux.ie>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kernel@pengutronix.de,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v6 1/3] of: Decrement refcount of previous endpoint in of_graph_get_next_endpoint
Date: Mon, 22 Dec 2014 16:11:29 +0100
Message-Id: <1419261091-29888-2-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419261091-29888-1-git-send-email-p.zabel@pengutronix.de>
References: <1419261091-29888-1-git-send-email-p.zabel@pengutronix.de>
X-SA-Exim-Connect-IP: 10.1.0.7
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
Acked-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
Changes since v5:
 - Rebased onto v3.19-rc1
 - Added coresight and rcar-du
---
 drivers/coresight/of_coresight.c               | 13 ++-----------
 drivers/gpu/drm/imx/imx-drm-core.c             | 13 ++-----------
 drivers/gpu/drm/rcar-du/rcar_du_kms.c          | 15 ++++-----------
 drivers/media/platform/soc_camera/soc_camera.c |  3 ++-
 drivers/of/base.c                              |  9 +--------
 5 files changed, 11 insertions(+), 42 deletions(-)

diff --git a/drivers/coresight/of_coresight.c b/drivers/coresight/of_coresight.c
index 5030c07..349c88b 100644
--- a/drivers/coresight/of_coresight.c
+++ b/drivers/coresight/of_coresight.c
@@ -52,15 +52,6 @@ of_coresight_get_endpoint_device(struct device_node *endpoint)
 			       endpoint, of_dev_node_match);
 }
 
-static struct device_node *of_get_coresight_endpoint(
-		const struct device_node *parent, struct device_node *prev)
-{
-	struct device_node *node = of_graph_get_next_endpoint(parent, prev);
-
-	of_node_put(prev);
-	return node;
-}
-
 static void of_coresight_get_ports(struct device_node *node,
 				   int *nr_inport, int *nr_outport)
 {
@@ -68,7 +59,7 @@ static void of_coresight_get_ports(struct device_node *node,
 	int in = 0, out = 0;
 
 	do {
-		ep = of_get_coresight_endpoint(node, ep);
+		ep = of_graph_get_next_endpoint(node, ep);
 		if (!ep)
 			break;
 
@@ -140,7 +131,7 @@ struct coresight_platform_data *of_get_coresight_platform_data(
 		/* Iterate through each port to discover topology */
 		do {
 			/* Get a handle on a port */
-			ep = of_get_coresight_endpoint(node, ep);
+			ep = of_graph_get_next_endpoint(node, ep);
 			if (!ep)
 				break;
 
diff --git a/drivers/gpu/drm/imx/imx-drm-core.c b/drivers/gpu/drm/imx/imx-drm-core.c
index b250130..fed627d 100644
--- a/drivers/gpu/drm/imx/imx-drm-core.c
+++ b/drivers/gpu/drm/imx/imx-drm-core.c
@@ -436,15 +436,6 @@ static uint32_t imx_drm_find_crtc_mask(struct imx_drm_device *imxdrm,
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
@@ -456,7 +447,7 @@ int imx_drm_encoder_parse_of(struct drm_device *drm,
 	for (i = 0; ; i++) {
 		u32 mask;
 
-		ep = imx_drm_of_get_next_endpoint(np, ep);
+		ep = of_graph_get_next_endpoint(np, ep);
 		if (!ep)
 			break;
 
@@ -504,7 +495,7 @@ int imx_drm_encoder_get_mux_id(struct device_node *node,
 		return -EINVAL;
 
 	do {
-		ep = imx_drm_of_get_next_endpoint(node, ep);
+		ep = of_graph_get_next_endpoint(node, ep);
 		if (!ep)
 			break;
 
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_kms.c b/drivers/gpu/drm/rcar-du/rcar_du_kms.c
index 0c5ee61..480c4d9 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_kms.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_kms.c
@@ -206,7 +206,7 @@ static int rcar_du_encoders_init_one(struct rcar_du_device *rcdu,
 	enum rcar_du_encoder_type enc_type = RCAR_DU_ENCODER_NONE;
 	struct device_node *connector = NULL;
 	struct device_node *encoder = NULL;
-	struct device_node *prev = NULL;
+	struct device_node *ep_node = NULL;
 	struct device_node *entity_ep_node;
 	struct device_node *entity;
 	int ret;
@@ -225,11 +225,7 @@ static int rcar_du_encoders_init_one(struct rcar_du_device *rcdu,
 	entity_ep_node = of_parse_phandle(ep->local_node, "remote-endpoint", 0);
 
 	while (1) {
-		struct device_node *ep_node;
-
-		ep_node = of_graph_get_next_endpoint(entity, prev);
-		of_node_put(prev);
-		prev = ep_node;
+		ep_node = of_graph_get_next_endpoint(entity, ep_node);
 
 		if (!ep_node)
 			break;
@@ -300,7 +296,7 @@ static int rcar_du_encoders_init_one(struct rcar_du_device *rcdu,
 static int rcar_du_encoders_init(struct rcar_du_device *rcdu)
 {
 	struct device_node *np = rcdu->dev->of_node;
-	struct device_node *prev = NULL;
+	struct device_node *ep_node = NULL;
 	unsigned int num_encoders = 0;
 
 	/*
@@ -308,15 +304,12 @@ static int rcar_du_encoders_init(struct rcar_du_device *rcdu)
 	 * pipeline.
 	 */
 	while (1) {
-		struct device_node *ep_node;
 		enum rcar_du_output output;
 		struct of_endpoint ep;
 		unsigned int i;
 		int ret;
 
-		ep_node = of_graph_get_next_endpoint(np, prev);
-		of_node_put(prev);
-		prev = ep_node;
+		ep_node = of_graph_get_next_endpoint(np, ep_node);
 
 		if (ep_node == NULL)
 			break;
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index b3db51c..289b637 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1710,7 +1710,6 @@ static void scan_of_host(struct soc_camera_host *ici)
 		if (!i)
 			soc_of_bind(ici, epn, ren->parent);
 
-		of_node_put(epn);
 		of_node_put(ren);
 
 		if (i) {
@@ -1718,6 +1717,8 @@ static void scan_of_host(struct soc_camera_host *ici)
 			break;
 		}
 	}
+
+	of_node_put(epn);
 }
 
 #else
diff --git a/drivers/of/base.c b/drivers/of/base.c
index 36536b6..aac66df 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -2085,8 +2085,7 @@ EXPORT_SYMBOL(of_graph_parse_endpoint);
  * @prev: previous endpoint node, or NULL to get first
  *
  * Return: An 'endpoint' node pointer with refcount incremented. Refcount
- * of the passed @prev node is not decremented, the caller have to use
- * of_node_put() on it when done.
+ * of the passed @prev node is decremented.
  */
 struct device_node *of_graph_get_next_endpoint(const struct device_node *parent,
 					struct device_node *prev)
@@ -2122,12 +2121,6 @@ struct device_node *of_graph_get_next_endpoint(const struct device_node *parent,
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
-- 
2.1.4

