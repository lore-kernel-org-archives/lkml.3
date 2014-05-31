Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbaEaOa6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 10:30:58 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:53505 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756662AbaEaO27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 10:28:59 -0400
From: Andreas Noever <andreas.noever@gmail.com>
To: linux-kernel@vger.kernel.org, Matthew Garrett <matthew.garrett@nebula.com>,
        Greg KH <greg@kroah.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org
Cc: Andreas Noever <andreas.noever@gmail.com>
Subject: [PATCH v4 09/15] thunderbolt: Handle hotplug events
Date: Sat, 31 May 2014 16:27:54 +0200
Message-Id: <1401546480-2071-10-git-send-email-andreas.noever@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401546480-2071-1-git-send-email-andreas.noever@gmail.com>
References: <1401546480-2071-1-git-send-email-andreas.noever@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We receive a plug event callback whenever a thunderbolt device is added
or removed. This patch fills in the tb_handle_hotplug method and starts
reacting to these events by adding/removing switches from the hierarchy.

Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
---
 drivers/thunderbolt/switch.c | 42 +++++++++++++++++++++++++++++++++++++++-
 drivers/thunderbolt/tb.c     | 46 +++++++++++++++++++++++++++++++++++++++++++-
 drivers/thunderbolt/tb.h     |  3 +++
 3 files changed, 89 insertions(+), 2 deletions(-)

diff --git a/drivers/thunderbolt/switch.c b/drivers/thunderbolt/switch.c
index 279b9c5..c092f7c 100644
--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -195,6 +195,24 @@ static void tb_dump_switch(struct tb *tb, struct tb_regs_switch_header *sw)
 		sw->__unknown1, sw->__unknown4);
 }
 
+struct tb_switch *get_switch_at_route(struct tb_switch *sw, u64 route)
+{
+	u8 next_port = route; /*
+			       * Routes use a stride of 8 bits,
+			       * eventhough a port index has 6 bits at most.
+			       * */
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
 /**
  * tb_plug_events_active() - enable/disable plug events on a switch
  *
@@ -243,7 +261,8 @@ void tb_switch_free(struct tb_switch *sw)
 		sw->ports[i].remote = NULL;
 	}
 
-	tb_plug_events_active(sw, false);
+	if (!sw->is_unplugged)
+		tb_plug_events_active(sw, false);
 
 	kfree(sw->ports);
 	kfree(sw);
@@ -327,3 +346,24 @@ err:
 	return NULL;
 }
 
+/**
+ * tb_sw_set_unpplugged() - set is_unplugged on switch and downstream switches
+ */
+void tb_sw_set_unpplugged(struct tb_switch *sw)
+{
+	int i;
+	if (sw == sw->tb->root_switch) {
+		tb_sw_WARN(sw, "cannot unplug root switch\n");
+		return;
+	}
+	if (sw->is_unplugged) {
+		tb_sw_WARN(sw, "is_unplugged already set\n");
+		return;
+	}
+	sw->is_unplugged = true;
+	for (i = 0; i <= sw->config.max_port_number; i++) {
+		if (!tb_is_upstream_port(&sw->ports[i]) && sw->ports[i].remote)
+			tb_sw_set_unpplugged(sw->ports[i].remote->sw);
+	}
+}
+
diff --git a/drivers/thunderbolt/tb.c b/drivers/thunderbolt/tb.c
index 3b716fd..1efcacc 100644
--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -71,11 +71,55 @@ static void tb_handle_hotplug(struct work_struct *work)
 {
 	struct tb_hotplug_event *ev = container_of(work, typeof(*ev), work);
 	struct tb *tb = ev->tb;
+	struct tb_switch *sw;
+	struct tb_port *port;
 	mutex_lock(&tb->lock);
 	if (!tb->hotplug_active)
 		goto out; /* during init, suspend or shutdown */
 
-	/* do nothing for now */
+	sw = get_switch_at_route(tb->root_switch, ev->route);
+	if (!sw) {
+		tb_warn(tb,
+			"hotplug event from non existent switch %llx:%x (unplug: %d)\n",
+			ev->route, ev->port, ev->unplug);
+		goto out;
+	}
+	if (ev->port > sw->config.max_port_number) {
+		tb_warn(tb,
+			"hotplug event from non existent port %llx:%x (unplug: %d)\n",
+			ev->route, ev->port, ev->unplug);
+		goto out;
+	}
+	port = &sw->ports[ev->port];
+	if (tb_is_upstream_port(port)) {
+		tb_warn(tb,
+			"hotplug event for upstream port %llx:%x (unplug: %d)\n",
+			ev->route, ev->port, ev->unplug);
+		goto out;
+	}
+	if (ev->unplug) {
+		if (port->remote) {
+			tb_port_info(port, "unplugged\n");
+			tb_sw_set_unpplugged(port->remote->sw);
+			tb_switch_free(port->remote->sw);
+			port->remote = NULL;
+		} else {
+			tb_port_info(port,
+				     "got unplug event for disconnected port, ignoring\n");
+		}
+	} else if (port->remote) {
+		tb_port_info(port,
+			     "got plug event for connected port, ignoring\n");
+	} else {
+		tb_port_info(port, "hotplug: scanning\n");
+		tb_scan_port(port);
+		if (!port->remote) {
+			tb_port_info(port, "hotplug: no switch found\n");
+		} else if (port->remote->sw->config.depth > 1) {
+			tb_sw_warn(port->remote->sw,
+				   "hotplug: chaining not supported\n");
+		}
+	}
 out:
 	mutex_unlock(&tb->lock);
 	kfree(ev);
diff --git a/drivers/thunderbolt/tb.h b/drivers/thunderbolt/tb.h
index 70a66fe..661f182 100644
--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -20,6 +20,7 @@ struct tb_switch {
 	struct tb_port *ports;
 	struct tb *tb;
 	int cap_plug_events; /* offset, zero if not found */
+	bool is_unplugged; /* unplugged, will go away */
 };
 
 /**
@@ -160,6 +161,8 @@ void thunderbolt_shutdown_and_free(struct tb *tb);
 
 struct tb_switch *tb_switch_alloc(struct tb *tb, u64 route);
 void tb_switch_free(struct tb_switch *sw);
+void tb_sw_set_unpplugged(struct tb_switch *sw);
+struct tb_switch *get_switch_at_route(struct tb_switch *sw, u64 route);
 
 int tb_wait_for_port(struct tb_port *port, bool wait_if_unplugged);
 
-- 
1.9.3

