Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbaHSNDE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 09:03:04 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51130 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbaHSNC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 09:02:58 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, kernel@pengutronix.de,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 5/8] of: Add of_graph_get_port_by_id function
Date: Tue, 19 Aug 2014 15:02:43 +0200
Message-Id: <1408453366-1366-6-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 2.1.0.rc1
In-Reply-To: <1408453366-1366-1-git-send-email-p.zabel@pengutronix.de>
References: <1408453366-1366-1-git-send-email-p.zabel@pengutronix.de>
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
---
 drivers/of/base.c        | 30 ++++++++++++++++++++++++++++++
 include/linux/of_graph.h |  7 +++++++
 2 files changed, 37 insertions(+)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index a49b5628..6044c15 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -2053,6 +2053,36 @@ int of_graph_parse_endpoint(const struct device_node *node,
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
+	struct device_node *port = NULL;
+	int port_id;
+
+	while (true) {
+		port = of_get_next_child(node, port);
+		if (!port)
+			return NULL;
+		if (of_node_cmp(port->name, "port") != 0)
+			continue;
+		if (of_property_read_u32(port, "reg", &port_id)) {
+			if (!id)
+				return port;
+		} else {
+			if (id == port_id)
+				return port;
+		}
+	}
+}
+EXPORT_SYMBOL(of_graph_get_port_by_id);
+
+/**
  * of_graph_get_next_endpoint() - get next endpoint node
  * @parent: pointer to the parent device node
  * @prev: previous endpoint node, or NULL to get first
diff --git a/include/linux/of_graph.h b/include/linux/of_graph.h
index 2890a4c..24ceb4b 100644
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
@@ -46,6 +47,12 @@ static inline int of_graph_parse_endpoint(const struct device_node *node,
 	return -ENOSYS;
 }
 
+static inline struct device_node *of_graph_get_port_by_id(
+					struct device_node *node, int id)
+{
+	return NULL;
+}
+
 static inline struct device_node *of_graph_get_next_endpoint(
 					const struct device_node *parent,
 					struct device_node *previous)
-- 
2.1.0.rc1

