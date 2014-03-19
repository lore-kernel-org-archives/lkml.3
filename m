Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965440AbaCSPMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 11:12:17 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45266 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965037AbaCSPML (ORCPT
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
Subject: [RFC PATCH 3/3] of: Add OF graph helpers to iterate over ports
Date: Wed, 19 Mar 2014 16:12:04 +0100
Message-Id: <1395241924-9675-4-git-send-email-p.zabel@pengutronix.de>
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

This patch adds the of_graph_get_next_port function and a for_each_port_of_node
macro using it. This allows to iterate over all ports of a given device node.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/of/base.c        | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/of_graph.h | 12 ++++++++++++
 2 files changed, 59 insertions(+)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 7ecffbe..364042b 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -2128,6 +2128,53 @@ struct device_node *of_graph_get_port_by_id(struct device_node *node, int id)
 EXPORT_SYMBOL(of_graph_get_port_by_id);
 
 /**
+ * of_graph_get_next_port() - get next port node
+ *
+ * @parent: pointer to the parent device node
+ * @prev: previous port node, or NULL to get first
+ *
+ * Return: A 'port' node pointer with refcount incremented. The caller
+ * has to use of_node_put() on it when done.
+ */
+
+struct device_node *of_graph_get_next_port(const struct device_node *parent,
+					   struct device_node *prev)
+{
+	struct of_graph_entity *entity;
+	struct of_graph_port *port;
+
+	if (!parent)
+		return NULL;
+
+	entity = __of_graph_lookup_entity(parent);
+	if (WARN_ONCE(!entity || list_empty(&entity->ports),
+		      "%s(): no ports specified for %s\n",
+		      __func__, parent->full_name))
+		return NULL;
+
+	if (!prev) {
+		/* It's the first call, we have to find the first port. */
+		port = list_first_entry(&entity->ports,
+					struct of_graph_port, list);
+
+		return of_node_get(port->of_node);
+	}
+
+	of_node_put(prev);
+
+	list_for_each_entry(port, &entity->ports, list) {
+		if (port->of_node == prev &&
+		    port != list_last_entry(&entity->ports,
+					    struct of_graph_port, list)) {
+			port = list_next_entry(port, list);
+			return of_node_get(port->of_node);
+		}
+	}
+
+	return NULL;
+}
+
+/**
  * of_graph_get_next_endpoint() - get next endpoint node
  *
  * @parent: pointer to the parent device node
diff --git a/include/linux/of_graph.h b/include/linux/of_graph.h
index 2701054..7ed0bfa 100644
--- a/include/linux/of_graph.h
+++ b/include/linux/of_graph.h
@@ -26,6 +26,9 @@ struct of_endpoint {
 	const struct device_node *local_node;
 };
 
+#define for_each_port_of_node(dn, pp) \
+	for (pp = of_graph_get_next_port(dn, NULL); pp != NULL; \
+	     pp = of_graph_get_next_port(dn, pp))
 #define for_each_endpoint_of_node(dn, ep) \
 	for (ep = of_graph_get_next_endpoint(dn, NULL); ep != NULL; \
 	     ep = of_graph_get_next_endpoint(dn, ep))
@@ -34,6 +37,8 @@ struct of_endpoint {
 int of_graph_parse_endpoint(const struct device_node *node,
 				struct of_endpoint *endpoint);
 struct device_node *of_graph_get_port_by_id(struct device_node *node, int id);
+struct device_node *of_graph_get_next_port(const struct device_node *parent,
+					struct device_node *previous);
 struct device_node *of_graph_get_next_endpoint(const struct device_node *parent,
 					struct device_node *previous);
 struct device_node *of_graph_get_remote_port_parent(
@@ -56,6 +61,13 @@ static inline struct device_node *of_graph_get_port_by_id(struct device_node *no
 	return NULL;
 }
 
+static inline struct device_node *of_graph_get_next_port(
+					const struct device_node *parent,
+					struct device_node *previous)
+{
+	return NULL;
+}
+
 static inline struct device_node *of_graph_get_next_endpoint(
 					const struct device_node *parent,
 					struct device_node *previous)
-- 
1.9.0

