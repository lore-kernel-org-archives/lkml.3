Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851AbaBKLpe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 06:45:34 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42172 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbaBKLpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 06:45:30 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, Philipp Zabel <philipp.zabel@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [RFC PATCH] [media]: of: move graph helpers from drivers/media/v4l2-core to drivers/of
Date: Tue, 11 Feb 2014 12:45:05 +0100
Message-Id: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.8.5.3
X-SA-Exim-Connect-IP: 10.1.0.7
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
drivers/media/v4l2-core to drivers/of.

This allows to reuse the same parser code from outside the V4L2 framework,
most importantly from display drivers. There have been patches that duplicate
the code (and I am going to send one of my own), such as
http://lists.freedesktop.org/archives/dri-devel/2013-August/043308.html
and others that parse the same binding in a different way:
https://www.mail-archive.com/linux-omap@vger.kernel.org/msg100761.html

I think that all common video interface parsing helpers should be moved to a
single place, outside of the specific subsystems, so that it can be reused
by all drivers.

I moved v4l2_of_get_next_endpoint, v4l2_of_get_remote_port,
and v4l2_of_get_remote_port_parent. They are renamed to
of_graph_get_next_endpoint, of_graph_get_remote_port, and
of_graph_get_remote_port_parent, respectively.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/Kconfig             |   1 +
 drivers/media/v4l2-core/v4l2-of.c | 117 ---------------------------------
 drivers/of/Kconfig                |   3 +
 drivers/of/Makefile               |   1 +
 drivers/of/of_graph.c             | 133 ++++++++++++++++++++++++++++++++++++++
 include/linux/of_graph.h          |  23 +++++++
 include/media/v4l2-of.h           |  16 ++---
 7 files changed, 167 insertions(+), 127 deletions(-)
 create mode 100644 drivers/of/of_graph.c
 create mode 100644 include/linux/of_graph.h

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 1d0758a..882faeb 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -96,6 +96,7 @@ config VIDEO_DEV
 	tristate
 	depends on MEDIA_SUPPORT
 	depends on MEDIA_CAMERA_SUPPORT || MEDIA_ANALOG_TV_SUPPORT || MEDIA_RADIO_SUPPORT
+	select OF_GRAPH if OF
 	default y
 
 config VIDEO_V4L2_SUBDEV_API
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
diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index c6973f1..1bfbb0e 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -75,4 +75,7 @@ config OF_MTD
 	depends on MTD
 	def_bool y
 
+config OF_GRAPH
+	bool
+
 endmenu # OF
diff --git a/drivers/of/Makefile b/drivers/of/Makefile
index efd0510..7ee8ab3 100644
--- a/drivers/of/Makefile
+++ b/drivers/of/Makefile
@@ -9,3 +9,4 @@ obj-$(CONFIG_OF_MDIO)	+= of_mdio.o
 obj-$(CONFIG_OF_PCI)	+= of_pci.o
 obj-$(CONFIG_OF_PCI_IRQ)  += of_pci_irq.o
 obj-$(CONFIG_OF_MTD)	+= of_mtd.o
+obj-$(CONFIG_OF_GRAPH)	+= of_graph.o
diff --git a/drivers/of/of_graph.c b/drivers/of/of_graph.c
new file mode 100644
index 0000000..aa526d7
--- /dev/null
+++ b/drivers/of/of_graph.c
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
diff --git a/include/linux/of_graph.h b/include/linux/of_graph.h
new file mode 100644
index 0000000..352306a
--- /dev/null
+++ b/include/linux/of_graph.h
@@ -0,0 +1,23 @@
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
+struct device_node *of_graph_get_next_endpoint(const struct device_node *parent,
+					struct device_node *previous);
+struct device_node *of_graph_get_remote_port_parent(
+					const struct device_node *node);
+struct device_node *of_graph_get_remote_port(const struct device_node *node);
+
+#endif /* __LINUX_OF_GRAPH_H */
diff --git a/include/media/v4l2-of.h b/include/media/v4l2-of.h
index 541cea4..404a493 100644
--- a/include/media/v4l2-of.h
+++ b/include/media/v4l2-of.h
@@ -17,6 +17,7 @@
 #include <linux/list.h>
 #include <linux/types.h>
 #include <linux/errno.h>
+#include <linux/of_graph.h>
 
 #include <media/v4l2-mediabus.h>
 
@@ -72,11 +73,6 @@ struct v4l2_of_endpoint {
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
@@ -85,25 +81,25 @@ static inline int v4l2_of_parse_endpoint(const struct device_node *node,
 	return -ENOSYS;
 }
 
+#endif /* CONFIG_OF */
+
 static inline struct device_node *v4l2_of_get_next_endpoint(
 					const struct device_node *parent,
 					struct device_node *previous)
 {
-	return NULL;
+	return of_graph_get_next_endpoint(parent, previous);
 }
 
 static inline struct device_node *v4l2_of_get_remote_port_parent(
 					const struct device_node *node)
 {
-	return NULL;
+	return of_graph_get_remote_port_parent(node);
 }
 
 static inline struct device_node *v4l2_of_get_remote_port(
 					const struct device_node *node)
 {
-	return NULL;
+	return of_graph_get_remote_port(node);
 }
 
-#endif /* CONFIG_OF */
-
 #endif /* _V4L2_OF_H */
-- 
1.8.5.3

