Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab3K2Bkl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 20:40:41 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:61777 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405Ab3K2Bj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 20:39:27 -0500
From: Andreas Noever <andreas.noever@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andreas Noever <andreas.noever@gmail.com>
Subject: [PATCH 09/12] thunderbolt: Handle hotplug events
Date: Fri, 29 Nov 2013 02:35:46 +0100
Message-Id: <1385688949-7101-10-git-send-email-andreas.noever@gmail.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1385688949-7101-1-git-send-email-andreas.noever@gmail.com>
References: <1385688949-7101-1-git-send-email-andreas.noever@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We reveive a plug event callback whenever a thunderbolt device is added
or removed. This patch fills in the tb_handle_hotplug method and starts
reacting to these events by adding/removing switches from the hierarchy.

Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
---
 drivers/thunderbolt/tb.c | 83 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 82 insertions(+), 1 deletion(-)

diff --git a/drivers/thunderbolt/tb.c b/drivers/thunderbolt/tb.c
index 9daff7b..d9bce38 100644
--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -108,6 +108,22 @@ static int tb_route_length(u64 route)
 	return (fls64(route) + TB_ROUTE_SHIFT - 1) / TB_ROUTE_SHIFT;
 }
 
+static struct tb_switch *get_switch_at_route(struct tb_switch *sw, u64 route)
+{
+	u8 next_port = route & TB_PORT_MASK;
+	if (route == 0)
+		return sw;
+	if (next_port > sw->config.max_port_number)
+		return 0;
+	if (tb_is_upstream_port(&sw->ports[next_port]))
+		return 0;
+	if (!sw->ports[next_port].remote)
+		return 0;
+	return get_switch_at_route(sw->ports[next_port].remote->sw,
+				   route >> TB_ROUTE_SHIFT);
+}
+
+
 
 /* thunderbolt capability lookup */
 
@@ -527,6 +543,27 @@ static void tb_scan_port(struct tb_port *port)
 	tb_scan_ports(sw);
 }
 
+/**
+ * tb_invalidate_below() - recursively invalidate all ports below a given port
+ */
+static void tb_invalidate_below(struct tb_port *port)
+{
+	struct tb_switch *sw;
+	int i;
+	if (tb_is_upstream_port(port)) {
+		tb_port_WARN(port, "trying to invalidate an upstream port.\n");
+		return;
+	}
+	if (!port->remote)
+		return;
+	sw = port->remote->sw;
+	for (i = 0; i <= sw->config.max_port_number; i++) {
+		sw->ports[i].invalid = true;
+		if (!tb_is_upstream_port(&sw->ports[i]))
+			tb_invalidate_below(&sw->ports[i]);
+	}
+}
+
 struct tb_hotplug_event {
 	struct work_struct work;
 	struct tb *tb;
@@ -544,10 +581,54 @@ static void tb_handle_hotplug(struct work_struct *work)
 {
 	struct tb_hotplug_event *ev = container_of(work, typeof(*ev), work);
 	struct tb *tb = ev->tb;
+	struct tb_switch *sw;
+	struct tb_port *port;
 	mutex_lock(&tb->lock);
 	if (tb->shutdown)
 		goto out;
-	/* do nothing for now */
+
+	sw = get_switch_at_route(tb->root_switch, ev->route);
+	if (!sw) {
+		tb_WARN(tb,
+			"hotplug event for non existent switch %llx:%x (unplug: %d)\n",
+			ev->route,
+			ev->port,
+			ev->unplug)
+		goto out;
+	}
+	if (sw->config.max_port_number < ev->port) {
+		tb_WARN(tb,
+			"hotplug event for non existent port %llx:%x (unplug: %d)\n",
+			ev->route,
+			ev->port,
+			ev->unplug)
+		goto out;
+	}
+	port = &sw->ports[ev->port];
+	if (tb_is_upstream_port(port)) {
+		tb_WARN(tb,
+			"hotplug event for upstream port %llx:%x (unplug: %d)\n",
+			ev->route,
+			ev->port,
+			ev->unplug)
+		goto out;
+	}
+	if (ev->unplug) {
+		if (port->remote) {
+			tb_port_info(port, "unplugged\n");
+			tb_invalidate_below(port);
+			tb_switch_free(port->remote->sw);
+			port->remote = NULL;
+		} else {
+			tb_port_info(port,
+				     "got unplug event for disconnected port\n");
+		}
+	} else {
+		tb_port_info(port, "hotplug: scanning\n");
+		tb_scan_port(port);
+		if (!port->remote)
+			tb_port_info(port, "hotplug: no switch found\n");
+	}
 out:
 	mutex_unlock(&tb->lock);
 	kfree(ev);
-- 
1.8.4.2

