Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbaBNJS5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 04:18:57 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58672 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbaBNJSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 04:18:53 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v3] [media] of: move graph helpers from drivers/media/v4l2-core to drivers/media
Date: Fri, 14 Feb 2014 10:18:28 +0100
Message-Id: <1392369508-5767-1-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.9.0.rc3
X-SA-Exim-Connect-IP: 10.1.0.104
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philipp Zabel <philipp.zabel@gmail.com>

This patch moves the parsing helpers used to parse connected graphs
in the device tree, like the video interface bindings documented in
Documentation/devicetree/bindings/media/video-interfaces.txt, from
drivers/media/v4l2-core to drivers/media.

This allows to reuse the same parser code from outside the V4L2
framework, most importantly from display drivers.
The functions v4l2_of_get_next_endpoint, v4l2_of_get_remote_port,
and v4l2_of_get_remote_port_parent are moved. They are renamed to
of_graph_get_next_endpoint, of_graph_get_remote_port, and
of_graph_get_remote_port_parent, respectively.
Since there are not that many current users yet, switch all of
them to the new functions right away.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Acked-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
Changes since v2:
 - Removed CONFIG_OF_GRAPH option, helpers are compiled in when
   CONFIG_OF is enabled.
---
 drivers/media/Makefile                        |   2 +
 drivers/media/i2c/adv7343.c                   |   4 +-
 drivers/media/i2c/mt9p031.c                   |   4 +-
 drivers/media/i2c/s5k5baf.c                   |   3 +-
 drivers/media/i2c/tvp514x.c                   |   3 +-
 drivers/media/i2c/tvp7002.c                   |   3 +-
 drivers/media/of_graph.c                      | 133 ++++++++++++++++++++++++++
 drivers/media/platform/exynos4-is/fimc-is.c   |   6 +-
 drivers/media/platform/exynos4-is/media-dev.c |   3 +-
 drivers/media/platform/exynos4-is/mipi-csis.c |   3 +-
 drivers/media/v4l2-core/v4l2-of.c             | 117 ----------------------
 include/media/of_graph.h                      |  46 +++++++++
 include/media/v4l2-of.h                       |  24 -----
 13 files changed, 198 insertions(+), 153 deletions(-)
 create mode 100644 drivers/media/of_graph.c
 create mode 100644 include/media/of_graph.h

diff --git a/drivers/media/Makefile b/drivers/media/Makefile
index 620f275..0341472 100644
--- a/drivers/media/Makefile
+++ b/drivers/media/Makefile
@@ -18,6 +18,8 @@ ifeq ($(CONFIG_MEDIA_CONTROLLER),y)
   obj-$(CONFIG_MEDIA_SUPPORT) += media.o
 endif
 
+obj-$(CONFIG_OF) += of_graph.o
+
 obj-$(CONFIG_VIDEO_DEV) += v4l2-core/
 obj-$(CONFIG_DVB_CORE)  += dvb-core/
 
diff --git a/drivers/media/i2c/adv7343.c b/drivers/media/i2c/adv7343.c
index d4e15a6..74a1507 100644
--- a/drivers/media/i2c/adv7343.c
+++ b/drivers/media/i2c/adv7343.c
@@ -28,10 +28,10 @@
 #include <linux/of.h>
 
 #include <media/adv7343.h>
+#include <media/of_graph.h>
 #include <media/v4l2-async.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
-#include <media/v4l2-of.h>
 
 #include "adv7343_regs.h"
 
@@ -410,7 +410,7 @@ adv7343_get_pdata(struct i2c_client *client)
 	if (!IS_ENABLED(CONFIG_OF) || !client->dev.of_node)
 		return client->dev.platform_data;
 
-	np = v4l2_of_get_next_endpoint(client->dev.of_node, NULL);
+	np = of_graph_get_next_endpoint(client->dev.of_node, NULL);
 	if (!np)
 		return NULL;
 
diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
index e5ddf47..60f36dc 100644
--- a/drivers/media/i2c/mt9p031.c
+++ b/drivers/media/i2c/mt9p031.c
@@ -27,9 +27,9 @@
 #include <linux/videodev2.h>
 
 #include <media/mt9p031.h>
+#include <media/of_graph.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-of.h>
 #include <media/v4l2-subdev.h>
 
 #include "aptina-pll.h"
@@ -943,7 +943,7 @@ mt9p031_get_pdata(struct i2c_client *client)
 	if (!IS_ENABLED(CONFIG_OF) || !client->dev.of_node)
 		return client->dev.platform_data;
 
-	np = v4l2_of_get_next_endpoint(client->dev.of_node, NULL);
+	np = of_graph_get_next_endpoint(client->dev.of_node, NULL);
 	if (!np)
 		return NULL;
 
diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
index 77e10e0..06261ee 100644
--- a/drivers/media/i2c/s5k5baf.c
+++ b/drivers/media/i2c/s5k5baf.c
@@ -25,6 +25,7 @@
 #include <linux/slab.h>
 
 #include <media/media-entity.h>
+#include <media/of_graph.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-subdev.h>
@@ -1855,7 +1856,7 @@ static int s5k5baf_parse_device_node(struct s5k5baf *state, struct device *dev)
 	if (ret < 0)
 		return ret;
 
-	node_ep = v4l2_of_get_next_endpoint(node, NULL);
+	node_ep = of_graph_get_next_endpoint(node, NULL);
 	if (!node_ep) {
 		dev_err(dev, "no endpoint defined at node %s\n",
 			node->full_name);
diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
index 83d85df..50062d2 100644
--- a/drivers/media/i2c/tvp514x.c
+++ b/drivers/media/i2c/tvp514x.c
@@ -37,6 +37,7 @@
 #include <linux/v4l2-mediabus.h>
 #include <linux/of.h>
 
+#include <media/of_graph.h>
 #include <media/v4l2-async.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-common.h>
@@ -1068,7 +1069,7 @@ tvp514x_get_pdata(struct i2c_client *client)
 	if (!IS_ENABLED(CONFIG_OF) || !client->dev.of_node)
 		return client->dev.platform_data;
 
-	endpoint = v4l2_of_get_next_endpoint(client->dev.of_node, NULL);
+	endpoint = of_graph_get_next_endpoint(client->dev.of_node, NULL);
 	if (!endpoint)
 		return NULL;
 
diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
index 912e1cc..7b3201b 100644
--- a/drivers/media/i2c/tvp7002.c
+++ b/drivers/media/i2c/tvp7002.c
@@ -31,6 +31,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/v4l2-dv-timings.h>
+#include <media/of_graph.h>
 #include <media/tvp7002.h>
 #include <media/v4l2-async.h>
 #include <media/v4l2-device.h>
@@ -957,7 +958,7 @@ tvp7002_get_pdata(struct i2c_client *client)
 	if (!IS_ENABLED(CONFIG_OF) || !client->dev.of_node)
 		return client->dev.platform_data;
 
-	endpoint = v4l2_of_get_next_endpoint(client->dev.of_node, NULL);
+	endpoint = of_graph_get_next_endpoint(client->dev.of_node, NULL);
 	if (!endpoint)
 		return NULL;
 
diff --git a/drivers/media/of_graph.c b/drivers/media/of_graph.c
new file mode 100644
index 0000000..aa526d7
--- /dev/null
+++ b/drivers/media/of_graph.c
@@ -0,0 +1,133 @@
+/*
+ * OF graph binding parsing library
+ *
+ * Copyright (C) 2012 - 2013 Samsung Electronics Co., Ltd.
+ * Author: Sylwester Nawrocki <s.nawrocki@samsung.com>
+ *
+ * Copyright (C) 2012 Renesas Electronics Corp.
+ * Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ */
+#include <linux/kernel.h>
+#include <linux/of.h>
+#include <linux/types.h>
+
+/**
+ * of_graph_get_next_endpoint() - get next endpoint node
+ * @parent: pointer to the parent device node
+ * @prev: previous endpoint node, or NULL to get first
+ *
+ * Return: An 'endpoint' node pointer with refcount incremented. Refcount
+ * of the passed @prev node is not decremented, the caller have to use
+ * of_node_put() on it when done.
+ */
+struct device_node *of_graph_get_next_endpoint(const struct device_node *parent,
+					struct device_node *prev)
+{
+	struct device_node *endpoint;
+	struct device_node *port = NULL;
+
+	if (!parent)
+		return NULL;
+
+	if (!prev) {
+		struct device_node *node;
+		/*
+		 * It's the first call, we have to find a port subnode
+		 * within this node or within an optional 'ports' node.
+		 */
+		node = of_get_child_by_name(parent, "ports");
+		if (node)
+			parent = node;
+
+		port = of_get_child_by_name(parent, "port");
+
+		if (port) {
+			/* Found a port, get an endpoint. */
+			endpoint = of_get_next_child(port, NULL);
+			of_node_put(port);
+		} else {
+			endpoint = NULL;
+		}
+
+		if (!endpoint)
+			pr_err("%s(): no endpoint nodes specified for %s\n",
+			       __func__, parent->full_name);
+		of_node_put(node);
+	} else {
+		port = of_get_parent(prev);
+		if (!port)
+			/* Hm, has someone given us the root node ?... */
+			return NULL;
+
+		/* Avoid dropping prev node refcount to 0. */
+		of_node_get(prev);
+		endpoint = of_get_next_child(port, prev);
+		if (endpoint) {
+			of_node_put(port);
+			return endpoint;
+		}
+
+		/* No more endpoints under this port, try the next one. */
+		do {
+			port = of_get_next_child(parent, port);
+			if (!port)
+				return NULL;
+		} while (of_node_cmp(port->name, "port"));
+
+		/* Pick up the first endpoint in this port. */
+		endpoint = of_get_next_child(port, NULL);
+		of_node_put(port);
+	}
+
+	return endpoint;
+}
+EXPORT_SYMBOL(of_graph_get_next_endpoint);
+
+/**
+ * of_graph_get_remote_port_parent() - get remote port's parent node
+ * @node: pointer to a local endpoint device_node
+ *
+ * Return: Remote device node associated with remote endpoint node linked
+ *	   to @node. Use of_node_put() on it when done.
+ */
+struct device_node *of_graph_get_remote_port_parent(
+			       const struct device_node *node)
+{
+	struct device_node *np;
+	unsigned int depth;
+
+	/* Get remote endpoint node. */
+	np = of_parse_phandle(node, "remote-endpoint", 0);
+
+	/* Walk 3 levels up only if there is 'ports' node. */
+	for (depth = 3; depth && np; depth--) {
+		np = of_get_next_parent(np);
+		if (depth == 2 && of_node_cmp(np->name, "ports"))
+			break;
+	}
+	return np;
+}
+EXPORT_SYMBOL(of_graph_get_remote_port_parent);
+
+/**
+ * of_graph_get_remote_port() - get remote port node
+ * @node: pointer to a local endpoint device_node
+ *
+ * Return: Remote port node associated with remote endpoint node linked
+ *	   to @node. Use of_node_put() on it when done.
+ */
+struct device_node *of_graph_get_remote_port(const struct device_node *node)
+{
+	struct device_node *np;
+
+	/* Get remote endpoint node. */
+	np = of_parse_phandle(node, "remote-endpoint", 0);
+	if (!np)
+		return NULL;
+	return of_get_next_parent(np);
+}
+EXPORT_SYMBOL(of_graph_get_remote_port);
diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index 13a4228..6405268 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -30,7 +30,7 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/videodev2.h>
-#include <media/v4l2-of.h>
+#include <media/of_graph.h>
 #include <media/videobuf2-dma-contig.h>
 
 #include "media-dev.h"
@@ -167,10 +167,10 @@ static int fimc_is_parse_sensor_config(struct fimc_is_sensor *sensor,
 	u32 tmp = 0;
 	int ret;
 
-	np = v4l2_of_get_next_endpoint(np, NULL);
+	np = of_graph_get_next_endpoint(np, NULL);
 	if (!np)
 		return -ENXIO;
-	np = v4l2_of_get_remote_port(np);
+	np = of_graph_get_remote_port(np);
 	if (!np)
 		return -ENXIO;
 
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index c1bce17..11219e2 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -24,6 +24,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/types.h>
 #include <linux/slab.h>
+#include <media/of_graph.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-of.h>
 #include <media/media-device.h>
@@ -473,7 +474,7 @@ static int fimc_md_parse_port_node(struct fimc_md *fmd,
 
 	pd->mux_id = (endpoint.port - 1) & 0x1;
 
-	rem = v4l2_of_get_remote_port_parent(ep);
+	rem = of_graph_get_remote_port_parent(ep);
 	of_node_put(ep);
 	if (rem == NULL) {
 		v4l2_info(&fmd->v4l2_dev, "Remote device at %s not found\n",
diff --git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platform/exynos4-is/mipi-csis.c
index f3c3591..7211523 100644
--- a/drivers/media/platform/exynos4-is/mipi-csis.c
+++ b/drivers/media/platform/exynos4-is/mipi-csis.c
@@ -28,6 +28,7 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/videodev2.h>
+#include <media/of_graph.h>
 #include <media/s5p_fimc.h>
 #include <media/v4l2-of.h>
 #include <media/v4l2-subdev.h>
@@ -762,7 +763,7 @@ static int s5pcsis_parse_dt(struct platform_device *pdev,
 				 &state->max_num_lanes))
 		return -EINVAL;
 
-	node = v4l2_of_get_next_endpoint(node, NULL);
+	node = of_graph_get_next_endpoint(node, NULL);
 	if (!node) {
 		dev_err(&pdev->dev, "No port node at %s\n",
 				pdev->dev.of_node->full_name);
diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
index 42e3e8a..f919db3 100644
--- a/drivers/media/v4l2-core/v4l2-of.c
+++ b/drivers/media/v4l2-core/v4l2-of.c
@@ -152,120 +152,3 @@ int v4l2_of_parse_endpoint(const struct device_node *node,
 	return 0;
 }
 EXPORT_SYMBOL(v4l2_of_parse_endpoint);
-
-/**
- * v4l2_of_get_next_endpoint() - get next endpoint node
- * @parent: pointer to the parent device node
- * @prev: previous endpoint node, or NULL to get first
- *
- * Return: An 'endpoint' node pointer with refcount incremented. Refcount
- * of the passed @prev node is not decremented, the caller have to use
- * of_node_put() on it when done.
- */
-struct device_node *v4l2_of_get_next_endpoint(const struct device_node *parent,
-					struct device_node *prev)
-{
-	struct device_node *endpoint;
-	struct device_node *port = NULL;
-
-	if (!parent)
-		return NULL;
-
-	if (!prev) {
-		struct device_node *node;
-		/*
-		 * It's the first call, we have to find a port subnode
-		 * within this node or within an optional 'ports' node.
-		 */
-		node = of_get_child_by_name(parent, "ports");
-		if (node)
-			parent = node;
-
-		port = of_get_child_by_name(parent, "port");
-
-		if (port) {
-			/* Found a port, get an endpoint. */
-			endpoint = of_get_next_child(port, NULL);
-			of_node_put(port);
-		} else {
-			endpoint = NULL;
-		}
-
-		if (!endpoint)
-			pr_err("%s(): no endpoint nodes specified for %s\n",
-			       __func__, parent->full_name);
-		of_node_put(node);
-	} else {
-		port = of_get_parent(prev);
-		if (!port)
-			/* Hm, has someone given us the root node ?... */
-			return NULL;
-
-		/* Avoid dropping prev node refcount to 0. */
-		of_node_get(prev);
-		endpoint = of_get_next_child(port, prev);
-		if (endpoint) {
-			of_node_put(port);
-			return endpoint;
-		}
-
-		/* No more endpoints under this port, try the next one. */
-		do {
-			port = of_get_next_child(parent, port);
-			if (!port)
-				return NULL;
-		} while (of_node_cmp(port->name, "port"));
-
-		/* Pick up the first endpoint in this port. */
-		endpoint = of_get_next_child(port, NULL);
-		of_node_put(port);
-	}
-
-	return endpoint;
-}
-EXPORT_SYMBOL(v4l2_of_get_next_endpoint);
-
-/**
- * v4l2_of_get_remote_port_parent() - get remote port's parent node
- * @node: pointer to a local endpoint device_node
- *
- * Return: Remote device node associated with remote endpoint node linked
- *	   to @node. Use of_node_put() on it when done.
- */
-struct device_node *v4l2_of_get_remote_port_parent(
-			       const struct device_node *node)
-{
-	struct device_node *np;
-	unsigned int depth;
-
-	/* Get remote endpoint node. */
-	np = of_parse_phandle(node, "remote-endpoint", 0);
-
-	/* Walk 3 levels up only if there is 'ports' node. */
-	for (depth = 3; depth && np; depth--) {
-		np = of_get_next_parent(np);
-		if (depth == 2 && of_node_cmp(np->name, "ports"))
-			break;
-	}
-	return np;
-}
-EXPORT_SYMBOL(v4l2_of_get_remote_port_parent);
-
-/**
- * v4l2_of_get_remote_port() - get remote port node
- * @node: pointer to a local endpoint device_node
- *
- * Return: Remote port node associated with remote endpoint node linked
- *	   to @node. Use of_node_put() on it when done.
- */
-struct device_node *v4l2_of_get_remote_port(const struct device_node *node)
-{
-	struct device_node *np;
-
-	/* Get remote endpoint node. */
-	np = of_parse_phandle(node, "remote-endpoint", 0);
-	if (!np)
-		return NULL;
-	return of_get_next_parent(np);
-}
-EXPORT_SYMBOL(v4l2_of_get_remote_port);
diff --git a/include/media/of_graph.h b/include/media/of_graph.h
new file mode 100644
index 0000000..3bbeb60
--- /dev/null
+++ b/include/media/of_graph.h
@@ -0,0 +1,46 @@
+/*
+ * OF graph binding parsing helpers
+ *
+ * Copyright (C) 2012 - 2013 Samsung Electronics Co., Ltd.
+ * Author: Sylwester Nawrocki <s.nawrocki@samsung.com>
+ *
+ * Copyright (C) 2012 Renesas Electronics Corp.
+ * Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ */
+#ifndef __LINUX_OF_GRAPH_H
+#define __LINUX_OF_GRAPH_H
+
+#ifdef CONFIG_OF
+struct device_node *of_graph_get_next_endpoint(const struct device_node *parent,
+					struct device_node *previous);
+struct device_node *of_graph_get_remote_port_parent(
+					const struct device_node *node);
+struct device_node *of_graph_get_remote_port(const struct device_node *node);
+#else
+
+static inline struct device_node *of_graph_get_next_endpoint(
+					const struct device_node *parent,
+					struct device_node *previous)
+{
+	return NULL;
+}
+
+static inline struct device_node *of_graph_get_remote_port_parent(
+					const struct device_node *node)
+{
+	return NULL;
+}
+
+static inline struct device_node *of_graph_get_remote_port(
+					const struct device_node *node)
+{
+	return NULL;
+}
+
+#endif /* CONFIG_OF */
+
+#endif /* __LINUX_OF_GRAPH_H */
diff --git a/include/media/v4l2-of.h b/include/media/v4l2-of.h
index 541cea4..8174282 100644
--- a/include/media/v4l2-of.h
+++ b/include/media/v4l2-of.h
@@ -72,11 +72,6 @@ struct v4l2_of_endpoint {
 #ifdef CONFIG_OF
 int v4l2_of_parse_endpoint(const struct device_node *node,
 			   struct v4l2_of_endpoint *endpoint);
-struct device_node *v4l2_of_get_next_endpoint(const struct device_node *parent,
-					struct device_node *previous);
-struct device_node *v4l2_of_get_remote_port_parent(
-					const struct device_node *node);
-struct device_node *v4l2_of_get_remote_port(const struct device_node *node);
 #else /* CONFIG_OF */
 
 static inline int v4l2_of_parse_endpoint(const struct device_node *node,
@@ -85,25 +80,6 @@ static inline int v4l2_of_parse_endpoint(const struct device_node *node,
 	return -ENOSYS;
 }
 
-static inline struct device_node *v4l2_of_get_next_endpoint(
-					const struct device_node *parent,
-					struct device_node *previous)
-{
-	return NULL;
-}
-
-static inline struct device_node *v4l2_of_get_remote_port_parent(
-					const struct device_node *node)
-{
-	return NULL;
-}
-
-static inline struct device_node *v4l2_of_get_remote_port(
-					const struct device_node *node)
-{
-	return NULL;
-}
-
 #endif /* CONFIG_OF */
 
 #endif /* _V4L2_OF_H */
-- 
1.9.0.rc3

