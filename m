Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbaBYO7E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 09:59:04 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59494 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbaBYO6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 09:58:49 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v4 2/3] [media] of: move common endpoint parsing to drivers/of
Date: Tue, 25 Feb 2014 15:58:23 +0100
Message-Id: <1393340304-19005-3-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.9.0.rc3
In-Reply-To: <1393340304-19005-1-git-send-email-p.zabel@pengutronix.de>
References: <1393340304-19005-1-git-send-email-p.zabel@pengutronix.de>
X-SA-Exim-Connect-IP: 10.1.0.104
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new struct of_endpoint which is then embedded in struct
v4l2_of_endpoint and contains the endpoint properties that are not V4L2
specific, or in fact not even media specific: port number, endpoint id,
local device tree node and remote endpoint phandle.
of_graph_parse_endpoint parses those properties and is used by
v4l2_of_parse_endpoint, which just adds the V4L2 MBUS information
to the containing v4l2_of_endpoint structure.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/v4l2-core/v4l2-of.c | 16 +++-------------
 drivers/of/of_graph.c             | 32 ++++++++++++++++++++++++++++++++
 include/linux/of_graph.h          | 20 ++++++++++++++++++++
 include/media/v4l2-of.h           |  9 +++------
 4 files changed, 58 insertions(+), 19 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
index f919db3..222ed58 100644
--- a/drivers/media/v4l2-core/v4l2-of.c
+++ b/drivers/media/v4l2-core/v4l2-of.c
@@ -127,17 +127,9 @@ static void v4l2_of_parse_parallel_bus(const struct device_node *node,
 int v4l2_of_parse_endpoint(const struct device_node *node,
 			   struct v4l2_of_endpoint *endpoint)
 {
-	struct device_node *port_node = of_get_parent(node);
-
-	memset(endpoint, 0, offsetof(struct v4l2_of_endpoint, head));
-
-	endpoint->local_node = node;
-	/*
-	 * It doesn't matter whether the two calls below succeed.
-	 * If they don't then the default value 0 is used.
-	 */
-	of_property_read_u32(port_node, "reg", &endpoint->port);
-	of_property_read_u32(node, "reg", &endpoint->id);
+	of_graph_parse_endpoint(node, &endpoint->ep);
+	endpoint->bus_type = 0;
+	memset(&endpoint->bus, 0, sizeof(endpoint->bus));
 
 	v4l2_of_parse_csi_bus(node, endpoint);
 	/*
@@ -147,8 +139,6 @@ int v4l2_of_parse_endpoint(const struct device_node *node,
 	if (endpoint->bus.mipi_csi2.flags == 0)
 		v4l2_of_parse_parallel_bus(node, endpoint);
 
-	of_node_put(port_node);
-
 	return 0;
 }
 EXPORT_SYMBOL(v4l2_of_parse_endpoint);
diff --git a/drivers/of/of_graph.c b/drivers/of/of_graph.c
index 267d8f7..d0f1683 100644
--- a/drivers/of/of_graph.c
+++ b/drivers/of/of_graph.c
@@ -15,6 +15,38 @@
 #include <linux/of.h>
 #include <linux/of_graph.h>
 #include <linux/types.h>
+#include <media/of_graph.h>
+
+/**
+ * of_graph_parse_endpoint() - parse common endpoint node properties
+ * @node: pointer to endpoint device_node
+ * @endpoint: pointer to the OF endpoint data structure
+ *
+ * All properties are optional. If none are found, we don't set any flags.
+ * This means the port has a static configuration and no properties have
+ * to be specified explicitly.
+ * The caller should hold a reference to @node.
+ */
+int of_graph_parse_endpoint(const struct device_node *node,
+			    struct of_endpoint *endpoint)
+{
+	struct device_node *port_node = of_get_parent(node);
+
+	memset(endpoint, 0, sizeof(*endpoint));
+
+	endpoint->local_node = node;
+	/*
+	 * It doesn't matter whether the two calls below succeed.
+	 * If they don't then the default value 0 is used.
+	 */
+	of_property_read_u32(port_node, "reg", &endpoint->port);
+	of_property_read_u32(node, "reg", &endpoint->id);
+
+	of_node_put(port_node);
+
+	return 0;
+}
+EXPORT_SYMBOL(of_graph_parse_endpoint);
 
 /**
  * of_graph_get_next_endpoint() - get next endpoint node
diff --git a/include/linux/of_graph.h b/include/linux/of_graph.h
index 3bbeb60..2b233db 100644
--- a/include/linux/of_graph.h
+++ b/include/linux/of_graph.h
@@ -14,7 +14,21 @@
 #ifndef __LINUX_OF_GRAPH_H
 #define __LINUX_OF_GRAPH_H
 
+/**
+ * struct of_endpoint - the OF graph endpoint data structure
+ * @port: identifier (value of reg property) of a port this endpoint belongs to
+ * @id: identifier (value of reg property) of this endpoint
+ * @local_node: pointer to device_node of this endpoint
+ */
+struct of_endpoint {
+	unsigned int port;
+	unsigned int id;
+	const struct device_node *local_node;
+};
+
 #ifdef CONFIG_OF
+int of_graph_parse_endpoint(const struct device_node *node,
+				struct of_endpoint *endpoint);
 struct device_node *of_graph_get_next_endpoint(const struct device_node *parent,
 					struct device_node *previous);
 struct device_node *of_graph_get_remote_port_parent(
@@ -22,6 +36,12 @@ struct device_node *of_graph_get_remote_port_parent(
 struct device_node *of_graph_get_remote_port(const struct device_node *node);
 #else
 
+static inline int of_graph_parse_endpoint(const struct device_node *node,
+					struct of_endpoint *endpoint);
+{
+	return -ENOSYS;
+}
+
 static inline struct device_node *of_graph_get_next_endpoint(
 					const struct device_node *parent,
 					struct device_node *previous)
diff --git a/include/media/v4l2-of.h b/include/media/v4l2-of.h
index 3a49735..2229a0e 100644
--- a/include/media/v4l2-of.h
+++ b/include/media/v4l2-of.h
@@ -19,6 +19,7 @@
 #include <linux/errno.h>
 #include <linux/of_graph.h>
 
+#include <media/of_graph.h>
 #include <media/v4l2-mediabus.h>
 
 struct device_node;
@@ -51,17 +52,13 @@ struct v4l2_of_bus_parallel {
 
 /**
  * struct v4l2_of_endpoint - the endpoint data structure
- * @port: identifier (value of reg property) of a port this endpoint belongs to
- * @id: identifier (value of reg property) of this endpoint
- * @local_node: pointer to device_node of this endpoint
+ * @ep: struct of_endpoint containing port, id, and local of_node
  * @bus_type: bus type
  * @bus: bus configuration data structure
  * @head: list head for this structure
  */
 struct v4l2_of_endpoint {
-	unsigned int port;
-	unsigned int id;
-	const struct device_node *local_node;
+	struct of_endpoint ep;
 	enum v4l2_mbus_type bus_type;
 	union {
 		struct v4l2_of_bus_parallel parallel;
-- 
1.8.5.3

