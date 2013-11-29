Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab3K2Bko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 20:40:44 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:40674 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab3K2Bj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 20:39:27 -0500
From: Andreas Noever <andreas.noever@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andreas Noever <andreas.noever@gmail.com>
Subject: [PATCH 08/12] thunderbolt: Scan for downstream switches
Date: Fri, 29 Nov 2013 02:35:45 +0100
Message-Id: <1385688949-7101-9-git-send-email-andreas.noever@gmail.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1385688949-7101-1-git-send-email-andreas.noever@gmail.com>
References: <1385688949-7101-1-git-send-email-andreas.noever@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add utility methods tb_port_state and tb_wait_for_port. Add tb_scan_port
which checks whether a port is connected and if so allocates a
downstream switch.

Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
---
 drivers/thunderbolt/tb.c | 160 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/thunderbolt/tb.h |  17 +++++
 2 files changed, 177 insertions(+)

diff --git a/drivers/thunderbolt/tb.c b/drivers/thunderbolt/tb.c
index 3837f1a..9daff7b 100644
--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -84,6 +84,25 @@ static void tb_dump_port(struct tb *tb, struct tb_regs_port_header *port)
 		port->nfc_credits);
 }
 
+
+/**
+ * tb_downstream_route() - get route to downstream switch
+ *
+ * Port must not be the upstream port (otherwise a loop is created).
+ *
+ * Return: Returns a route to the switch behind @port.
+ */
+static u64 tb_downstream_route(struct tb_port *port)
+{
+	return tb_route(port->sw)
+	       | ((u64) port->port << (port->sw->config.depth * 8));
+}
+
+static bool tb_is_upstream_port(struct tb_port *port)
+{
+	return port == tb_upstream_port(port->sw);
+}
+
 static int tb_route_length(u64 route)
 {
 	return (fls64(route) + TB_ROUTE_SHIFT - 1) / TB_ROUTE_SHIFT;
@@ -192,6 +211,84 @@ int tb_find_cap(struct tb_port *port, enum tb_cfg_space space, enum tb_cap cap)
 	return -EIO;
 }
 
+/* thunderbolt port utility functions */
+
+/**
+ * tb_port_state() - get connectedness state of a port
+ *
+ * The port must have a TB_CAP_PHY (i.e. it should be a real port).
+ *
+ * Return: Returns a tb_port_state on success or an error code on failure.
+ */
+static enum tb_port_state tb_port_state(struct tb_port *port)
+{
+	struct tb_cap_phy phy;
+	int res;
+	if (port->cap_phy == 0) {
+		tb_port_WARN(port, "does not have a PHY\n");
+		return -EINVAL;
+	}
+	res = tb_port_read(port, &phy, TB_CFG_PORT, port->cap_phy, 2);
+	if (res)
+		return res;
+	return phy.state;
+}
+
+/**
+ * tb_wait_for_port() - wait for a port to become ready
+ *
+ * Check if the port is connected but not up. If so we wait for some
+ * time to see whether it comes up.
+ *
+ * Return: Returns an error code on failure. Returns 0 if the port is not
+ * connected or failed to reach state TB_PORT_UP within one second. Returns 1
+ * if the port is connected and in state TB_PORT_UP.
+ */
+static int tb_wait_for_port(struct tb_port *port)
+{
+	int retries = 10;
+	enum tb_port_state state;
+	if (!port->cap_phy) {
+		tb_port_WARN(port, "does not have PHY\n");
+		return -EINVAL;
+	}
+	if (tb_is_upstream_port(port)) {
+		tb_port_WARN(port, "is the upstream port\n");
+		return -EINVAL;
+	}
+
+	while (retries--) {
+		state = tb_port_state(port);
+		if (state < 0)
+			return state;
+		if (state == TB_PORT_DISABLED) {
+			tb_port_info(port, "is disabled (state: 0)\n");
+			return 0;
+		}
+		if (state == TB_PORT_UNPLUGGED) {
+			tb_port_info(port, "is unplugged (state: 7)\n");
+			return 0;
+		}
+		if (state == TB_PORT_UP) {
+			tb_port_info(port,
+				     "is connected, link is up (state: 2)\n");
+			return 1;
+		}
+
+		/*
+		 * After plug-in the state is TB_PORT_CONNECTING. Give it some
+		 * time.
+		 */
+		tb_port_info(port,
+			     "is connected, link is not up (state: %d), retrying...\n",
+			     state);
+		msleep(100);
+	}
+	tb_port_WARN(port,
+		     "failed to reach state TB_PORT_UP. Ignoring port...\n");
+	return 0;
+}
+
 
 /* thunderbolt switch utility functions */
 
@@ -240,13 +337,25 @@ static int tb_plug_events_active(struct tb_switch *sw, bool active)
 static int tb_init_port(struct tb_switch *sw, u8 port_nr)
 {
 	int res;
+	int cap;
 	struct tb_port *port = &sw->ports[port_nr];
 	port->sw = sw;
 	port->port = port_nr;
+	port->remote = NULL;
 	res = tb_port_read(port, &port->config, TB_CFG_PORT, 0, 8);
 	if (res)
 		return res;
 
+	/* Port 0 is the switch itself and has no PHY. */
+	if (port->config.type == TB_TYPE_PORT && port_nr != 0) {
+		cap = tb_find_cap(port, TB_CFG_PORT, TB_CAP_PHY);
+
+		if (cap > 0)
+			port->cap_phy = cap;
+		else
+			tb_port_WARN(port, "non switch port without a PHY\n");
+	}
+
 	tb_dump_port(sw->tb, &port->config);
 
 	/* TODO: Read dual link port, DP port and more from EEPROM. */
@@ -259,6 +368,14 @@ static int tb_init_port(struct tb_switch *sw, u8 port_nr)
  */
 static void tb_switch_free(struct tb_switch *sw)
 {
+	int i;
+	/* port 0 is the switch itself and never has a remote */
+	for (i = 1; i <= sw->config.max_port_number; i++) {
+		if (tb_is_upstream_port(&sw->ports[i]))
+			continue;
+		if (sw->ports[i].remote)
+			tb_switch_free(sw->ports[i].remote->sw);
+	}
 	kfree(sw->ports);
 	kfree(sw);
 }
@@ -349,6 +466,9 @@ err:
 	return NULL;
 }
 
+
+/* startup, enumeration, hot plug handling and shutdown */
+
 /**
  * reset_switch() - send TB_CFG_PKG_RESET and enable switch
  *
@@ -369,6 +489,44 @@ static int tb_switch_reset(struct tb *tb, u64 route)
 	return tb_cfg_write(tb->cfg, ((u32 *) &header) + 2, route, 0, 2, 2, 2);
 }
 
+static void tb_link_ports(struct tb_port *down, struct tb_port *up)
+{
+	down->remote = up;
+	up->remote = down;
+}
+
+static void tb_scan_port(struct tb_port *port);
+
+static void tb_scan_ports(struct tb_switch *sw)
+{
+	int i;
+	for (i = 1; i <= sw->config.max_port_number; i++)
+		tb_scan_port(&sw->ports[i]);
+}
+
+/**
+ * tb_scan_port() - check for switches below port
+ *
+ * Checks whether port is connected. If so then we try to create a downstream
+ * switch and recursively scan its ports
+ */
+static void tb_scan_port(struct tb_port *port)
+{
+	struct tb_switch *sw;
+	if (tb_is_upstream_port(port))
+		return;
+	if (port->config.type != TB_TYPE_PORT)
+		return;
+	if (tb_wait_for_port(port) <= 0)
+		return;
+
+	sw = tb_switch_alloc(port->sw->tb, tb_downstream_route(port));
+	if (!sw)
+		return;
+	tb_link_ports(port, tb_upstream_port(sw));
+	tb_scan_ports(sw);
+}
+
 struct tb_hotplug_event {
 	struct work_struct work;
 	struct tb *tb;
@@ -487,6 +645,8 @@ struct tb *thunderbolt_alloc_and_start(struct tb_nhi *nhi)
 	if (!tb->root_switch)
 		goto err_locked;
 
+	tb_scan_ports(tb->root_switch);
+
 	mutex_unlock(&tb->lock);
 	return tb;
 
diff --git a/drivers/thunderbolt/tb.h b/drivers/thunderbolt/tb.h
index 2ada42a..fe35d4d 100644
--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -32,6 +32,8 @@ struct tb_switch {
 struct tb_port {
 	struct tb_regs_port_header config;
 	struct tb_switch *sw;
+	struct tb_port *remote; /* remote port, NULL if not connected */
+	int cap_phy; /* offset, zero if not found */
 	u8 port; /* port number on switch */
 	bool invalid; /* unplugged, will go away */
 };
@@ -54,6 +56,21 @@ struct tb {
 			 */
 };
 
+/**
+ * tb_upstream_port() - return the upstream port of a switch
+ *
+ * Every switch has an upstream port (for the root switch it is the NHI).
+ *
+ * During switch alloc/init tb_upstream_port()->remote may be NULL, even for
+ * non root switches (on the NHI port remote is always NULL).
+ *
+ * Return: Returns the upstream port of the switch.
+ */
+static inline struct tb_port *tb_upstream_port(struct tb_switch *sw)
+{
+	return &sw->ports[sw->config.upstream_port_number];
+}
+
 static inline u64 tb_route(struct tb_switch *sw)
 {
 	return ((u64) sw->config.route_hi) << 32 | sw->config.route_lo;
-- 
1.8.4.2

