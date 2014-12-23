Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273AbaLWNJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 08:09:59 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42062 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755711AbaLWNJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 08:09:25 -0500
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
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v7 3/3] of: Add of_graph_get_port_by_id function
Date: Tue, 23 Dec 2014 14:09:18 +0100
Message-Id: <1419340158-20567-4-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419340158-20567-1-git-send-email-p.zabel@pengutronix.de>
References: <1419340158-20567-1-git-send-email-p.zabel@pengutronix.de>
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a function to get a port device tree node by port id,
or reg property value.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
Changes since v6:
 - Fixed of_graph_get_port_by_id to handle the optional 'ports' node
   and synchronize documentation and parameter names in the process,
   spotted by Andrzej Hajda.
---
 drivers/of/base.c        | 32 ++++++++++++++++++++++++++++++++
 include/linux/of_graph.h |  7 +++++++
 2 files changed, 39 insertions(+)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index aac66df..8389215 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -2080,6 +2080,38 @@ int of_graph_parse_endpoint(const struct device_node *node,
 EXPORT_SYMBOL(of_graph_parse_endpoint);
 
 /**
+ * of_graph_get_port_by_id() - get the port matching a given id
+ * @parent: pointer to the parent device node
+ * @id: id of the port
+ *
+ * Return: A 'port' node pointer with refcount incremented. The caller
+ * has to use of_node_put() on it when done.
+ */
+struct device_node *of_graph_get_port_by_id(struct device_node *parent, u32 id)
+{
+	struct device_node *node, *port;
+
+	node = of_get_child_by_name(parent, "ports");
+	if (node)
+		parent = node;
+
+	for_each_child_of_node(parent, port) {
+		u32 port_id = 0;
+
+		if (of_node_cmp(port->name, "port") != 0)
+			continue;
+		of_property_read_u32(port, "reg", &port_id);
+		if (id == port_id)
+			break;
+	}
+
+	of_node_put(node);
+
+	return port;
+}
+EXPORT_SYMBOL(of_graph_get_port_by_id);
+
+/**
  * of_graph_get_next_endpoint() - get next endpoint node
  * @parent: pointer to the parent device node
  * @prev: previous endpoint node, or NULL to get first
diff --git a/include/linux/of_graph.h b/include/linux/of_graph.h
index e43442e..3c1c95a 100644
--- a/include/linux/of_graph.h
+++ b/include/linux/of_graph.h
@@ -40,6 +40,7 @@ struct of_endpoint {
 #ifdef CONFIG_OF
 int of_graph_parse_endpoint(const struct device_node *node,
 				struct of_endpoint *endpoint);
+struct device_node *of_graph_get_port_by_id(struct device_node *node, u32 id);
 struct device_node *of_graph_get_next_endpoint(const struct device_node *parent,
 					struct device_node *previous);
 struct device_node *of_graph_get_remote_port_parent(
@@ -53,6 +54,12 @@ static inline int of_graph_parse_endpoint(const struct device_node *node,
 	return -ENOSYS;
 }
 
+static inline struct device_node *of_graph_get_port_by_id(
+					struct device_node *node, u32 id)
+{
+	return NULL;
+}
+
 static inline struct device_node *of_graph_get_next_endpoint(
 					const struct device_node *parent,
 					struct device_node *previous)
-- 
2.1.4

