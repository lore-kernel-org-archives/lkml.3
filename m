Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbaB0RZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 12:25:56 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60490 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364AbaB0RWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 12:22:24 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Grant Likely <grant.likely@linaro.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v5 6/7] of: Implement simplified graph binding for single port devices
Date: Thu, 27 Feb 2014 18:35:39 +0100
Message-Id: <1393522540-22887-7-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.9.0.rc3
In-Reply-To: <1393522540-22887-1-git-send-email-p.zabel@pengutronix.de>
References: <1393522540-22887-1-git-send-email-p.zabel@pengutronix.de>
X-SA-Exim-Connect-IP: 10.1.0.120
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For simple devices with only one port, it can be made implicit.
The endpoint node can be a direct child of the device node.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/of/base.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index ba3cfca..7d9c62b 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -2037,8 +2037,13 @@ struct device_node *of_graph_get_next_endpoint(const struct device_node *parent,
 		struct device_node *node;
 		/*
 		 * It's the first call, we have to find a port subnode
-		 * within this node or within an optional 'ports' node.
+		 * within this node or within an optional 'ports' node,
+		 * or at least a single endpoint.
 		 */
+		endpoint = of_get_child_by_name(parent, "endpoint");
+		if (endpoint)
+			return endpoint;
+
 		node = of_get_child_by_name(parent, "ports");
 		if (node)
 			parent = node;
@@ -2049,8 +2054,6 @@ struct device_node *of_graph_get_next_endpoint(const struct device_node *parent,
 			/* Found a port, get an endpoint. */
 			endpoint = of_get_next_child(port, NULL);
 			of_node_put(port);
-		} else {
-			endpoint = NULL;
 		}
 
 		if (!endpoint)
@@ -2065,6 +2068,10 @@ struct device_node *of_graph_get_next_endpoint(const struct device_node *parent,
 	if (WARN_ONCE(!port, "%s(): endpoint has no parent node\n",
 		      __func__))
 		return NULL;
+	if (port == parent) {
+		of_node_put(port);
+		return NULL;
+	}
 
 	/* Avoid dropping prev node refcount to 0. */
 	of_node_get(prev);
@@ -2105,9 +2112,11 @@ struct device_node *of_graph_get_remote_port_parent(
 	/* Get remote endpoint node. */
 	np = of_parse_phandle(node, "remote-endpoint", 0);
 
-	/* Walk 3 levels up only if there is 'ports' node. */
+	/* Walk 3 levels up only if there is 'ports' node */
 	for (depth = 3; depth && np; depth--) {
 		np = of_get_next_parent(np);
+		if (depth == 3 && of_node_cmp(np->name, "port"))
+			break;
 		if (depth == 2 && of_node_cmp(np->name, "ports"))
 			break;
 	}
@@ -2130,6 +2139,11 @@ struct device_node *of_graph_get_remote_port(const struct device_node *node)
 	np = of_parse_phandle(node, "remote-endpoint", 0);
 	if (!np)
 		return NULL;
-	return of_get_next_parent(np);
+	np = of_get_next_parent(np);
+	if (of_node_cmp(np->name, "port")) {
+		of_node_put(np);
+		return NULL;
+	}
+	return np;
 }
 EXPORT_SYMBOL(of_graph_get_remote_port);
-- 
1.8.5.3

