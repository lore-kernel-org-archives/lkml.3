Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965425AbaCSPMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 11:12:15 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45265 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965031AbaCSPML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 11:12:11 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org, kernel@pengutronix.de
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg KH <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Rob Herring <robh+dt@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, devicetree@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [RFC PATCH 2/3] of: Add OF graph helper to get a specific port by id
Date: Wed, 19 Mar 2014 16:12:03 +0100
Message-Id: <1395241924-9675-3-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1395241924-9675-1-git-send-email-p.zabel@pengutronix.de>
References: <1395241924-9675-1-git-send-email-p.zabel@pengutronix.de>
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the of_graph_get_port_by_id function to get a port device
tree node by port id.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/of/base.c        | 28 ++++++++++++++++++++++++++++
 include/linux/of_graph.h |  7 +++++++
 2 files changed, 35 insertions(+)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index abfc462..7ecffbe 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -2100,6 +2100,34 @@ int of_graph_parse_endpoint(const struct device_node *node,
 EXPORT_SYMBOL(of_graph_parse_endpoint);
 
 /**
+ * of_graph_get_port_by_id() - get the port matching a given id
+ * @parent: pointer to the parent device node
+ * @id: id of the port
+ *
+ * Return: A 'port' node pointer with refcount incremented.The caller
+ * has to use of_node_put() on it when done.
+ */
+struct device_node *of_graph_get_port_by_id(struct device_node *node, int id)
+{
+	struct of_graph_entity *entity;
+	struct of_graph_port *port;
+
+	entity = __of_graph_lookup_entity(node);
+	if (WARN_ONCE(!entity || list_empty(&entity->ports),
+		      "%s(): no ports specified for %s\n", __func__,
+		      node->full_name))
+		return NULL;
+
+	list_for_each_entry(port, &entity->ports, list) {
+		if (port->id == id)
+			return of_node_get(port->of_node);
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL(of_graph_get_port_by_id);
+
+/**
  * of_graph_get_next_endpoint() - get next endpoint node
  *
  * @parent: pointer to the parent device node
diff --git a/include/linux/of_graph.h b/include/linux/of_graph.h
index b6dd55b..2701054 100644
--- a/include/linux/of_graph.h
+++ b/include/linux/of_graph.h
@@ -33,6 +33,7 @@ struct of_endpoint {
 #ifdef CONFIG_OF
 int of_graph_parse_endpoint(const struct device_node *node,
 				struct of_endpoint *endpoint);
+struct device_node *of_graph_get_port_by_id(struct device_node *node, int id);
 struct device_node *of_graph_get_next_endpoint(const struct device_node *parent,
 					struct device_node *previous);
 struct device_node *of_graph_get_remote_port_parent(
@@ -49,6 +50,12 @@ static inline int of_graph_parse_endpoint(const struct device_node *node,
 	return -ENOSYS;
 }
 
+static inline struct device_node *of_graph_get_port_by_id(struct device_node *node,
+					int id)
+{
+	return NULL;
+}
+
 static inline struct device_node *of_graph_get_next_endpoint(
 					const struct device_node *parent,
 					struct device_node *previous)
-- 
1.9.0

