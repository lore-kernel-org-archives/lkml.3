Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab3K2Bjx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 20:39:53 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:50725 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab3K2Bj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 20:39:29 -0500
From: Andreas Noever <andreas.noever@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andreas Noever <andreas.noever@gmail.com>
Subject: [PATCH 11/12] thunderbolt: Add support for simple pci tunnels.
Date: Fri, 29 Nov 2013 02:35:48 +0100
Message-Id: <1385688949-7101-12-git-send-email-andreas.noever@gmail.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1385688949-7101-1-git-send-email-andreas.noever@gmail.com>
References: <1385688949-7101-1-git-send-email-andreas.noever@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A pci downstream and pci upstream port can be connected through a
tunnel. To establish the tunnel we have to setup two unidirectional
paths between the two ports.

Right now we only support paths with two hops (i.e. no chaining) and at
most one pci device per thunderbolt device.

Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
---
 drivers/thunderbolt/Makefile |   2 +-
 drivers/thunderbolt/tb.c     |  27 ++++++
 drivers/thunderbolt/tb.h     |   2 +
 drivers/thunderbolt/tb_pci.c | 215 +++++++++++++++++++++++++++++++++++++++++++
 drivers/thunderbolt/tb_pci.h |  29 ++++++
 5 files changed, 274 insertions(+), 1 deletion(-)
 create mode 100644 drivers/thunderbolt/tb_pci.c
 create mode 100644 drivers/thunderbolt/tb_pci.h

diff --git a/drivers/thunderbolt/Makefile b/drivers/thunderbolt/Makefile
index 7c5b811..35f2147 100644
--- a/drivers/thunderbolt/Makefile
+++ b/drivers/thunderbolt/Makefile
@@ -1,3 +1,3 @@
 obj-${CONFIG_THUNDERBOLT} := thunderbolt.o
-thunderbolt-objs := dsl3510.o tb_cfg.o tb.o
+thunderbolt-objs := dsl3510.o tb_cfg.o tb.o tb_pci.o
 
diff --git a/drivers/thunderbolt/tb.c b/drivers/thunderbolt/tb.c
index 0fea997..9f25935 100644
--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -11,6 +11,7 @@
 #include "dsl3510.h"
 #include "tb.h"
 #include "tb_regs.h"
+#include "tb_pci.h"
 
 /* utility functions */
 
@@ -824,6 +825,19 @@ static void tb_invalidate_below(struct tb_port *port)
 	}
 }
 
+static void destroy_invalid_tunnels(struct tb *tb)
+{
+	struct tb_pci_tunnel *tunnel;
+	struct tb_pci_tunnel *n;
+	list_for_each_entry_safe(tunnel, n, &tb->tunnel_list, list)
+	{
+		if (tb_pci_is_invalid(tunnel)) {
+			tb_pci_deactivate(tunnel);
+			tb_pci_free(tunnel);
+		}
+	}
+}
+
 struct tb_hotplug_event {
 	struct work_struct work;
 	struct tb *tb;
@@ -877,6 +891,7 @@ static void tb_handle_hotplug(struct work_struct *work)
 		if (port->remote) {
 			tb_port_info(port, "unplugged\n");
 			tb_invalidate_below(port);
+			destroy_invalid_tunnels(tb);
 			tb_switch_free(port->remote->sw);
 			port->remote = NULL;
 		} else {
@@ -918,12 +933,23 @@ static void tb_schedule_hotplug_handler(void *data, u64 route, u8 port,
  * thunderbolt_shutdown_and_free() - shutdown everything
  *
  * Free all switches and the config channel.
+ *
+ * Only tb->lock and tb->tunnel_list must be initialized. If tb->tunnel_list
+ * is populated then we assume that tb->cfg is setup.
  */
 void thunderbolt_shutdown_and_free(struct tb *tb)
 {
+	struct tb_pci_tunnel *tunnel;
+	struct tb_pci_tunnel *n;
+
 	mutex_lock(&tb->lock);
 	tb->shutdown = true; /* signal tb_handle_hotplug to quit */
 
+	list_for_each_entry_safe(tunnel, n, &tb->tunnel_list, list) {
+		tb_pci_deactivate(tunnel);
+		tb_pci_free(tunnel);
+	}
+
 	if (tb->root_switch)
 		tb_switch_free(tb->root_switch);
 	tb->root_switch = NULL;
@@ -966,6 +992,7 @@ struct tb *thunderbolt_alloc_and_start(struct tb_nhi *nhi)
 	tb->nhi = nhi;
 	mutex_init(&tb->lock);
 	mutex_lock(&tb->lock);
+	INIT_LIST_HEAD(&tb->tunnel_list);
 
 	tb->wq = alloc_ordered_workqueue("thunderbolt", 0);
 	if (!tb->wq)
diff --git a/drivers/thunderbolt/tb.h b/drivers/thunderbolt/tb.h
index cc1f079..bb9a9de 100644
--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -104,10 +104,12 @@ struct tb {
 	struct tb_cfg *cfg;
 	struct workqueue_struct *wq; /* ordered workqueue for plug events */
 	struct tb_switch *root_switch;
+	struct list_head tunnel_list; /* list of active PCIe tunnels */
 	bool shutdown;	/*
 			 * Once this is set tb_handle_hotplug will exit (once it
 			 * can aquire lock at least once). Used to drain wq.
 			 */
+
 };
 
 /**
diff --git a/drivers/thunderbolt/tb_pci.c b/drivers/thunderbolt/tb_pci.c
new file mode 100644
index 0000000..42a173b
--- /dev/null
+++ b/drivers/thunderbolt/tb_pci.c
@@ -0,0 +1,215 @@
+/*
+ * Thunderbolt PCIe tunnel
+ *
+ * Copyright (c) 2013 Andreas Noever <andreas.noever@gmail.com>
+ */
+
+#include <linux/slab.h>
+#include <linux/list.h>
+
+#include "tb_pci.h"
+#include "tb.h"
+
+#define __TB_TUNNEL_PRINT(level, tunnel, fmt, arg...)                   \
+	do {                                                            \
+		struct tb_pci_tunnel *__tunnel = (tunnel);              \
+		level(__tunnel->tb, "%llx:%x <-> %llx:%x (PCI): " fmt,  \
+		      tb_route(__tunnel->down_port->sw),                \
+		      __tunnel->down_port->port,                        \
+		      tb_route(__tunnel->up_port->sw),                  \
+		      __tunnel->up_port->port,                          \
+		      ## arg);                                          \
+	} while (0)
+
+#define tb_tunnel_WARN(tunnel, fmt, arg...) \
+	__TB_TUNNEL_PRINT(tb_WARN, tunnel, fmt, ##arg)
+#define tb_tunnel_warn(tunnel, fmt, arg...) \
+	__TB_TUNNEL_PRINT(tb_warn, tunnel, fmt, ##arg)
+#define tb_tunnel_info(tunnel, fmt, arg...) \
+	__TB_TUNNEL_PRINT(tb_info, tunnel, fmt, ##arg)
+
+static void tb_pci_init_path(struct tb_path *path)
+{
+	path->egress_fc_enable = TB_PATH_SOURCE | TB_PATH_INTERNAL;
+	path->egress_shared_buffer = TB_PATH_NONE;
+	path->ingress_fc_enable = TB_PATH_ALL;
+	path->ingress_shared_buffer = TB_PATH_NONE;
+	path->priority = 3;
+	path->weight = 1;
+	path->drop_packages = 0;
+	path->nfc_credits = 0;
+}
+
+/**
+ * tb_pci_alloc() - allocate a pci tunnel
+ *
+ * Allocates a PCI tunnel. The ports must be of type TB_TYPE_PCIE_UP and
+ * TB_TYPE_PCIE_DOWN.
+ *
+ * Currently only paths of consisting of two hops are supported (that is the
+ * ports must be on "adjacent" switches).
+ *
+ * The paths are hard-coded to use hop 8 (the only working hop id available on
+ * my thunderbolt devices). Therefore at most ONE path per device may be
+ * activated.
+ *
+ * Return: Returns a tb_pci_tunnel on success or NULL on failure.
+ */
+struct tb_pci_tunnel *tb_pci_alloc(struct tb *tb, struct tb_port *up,
+				   struct tb_port *down)
+{
+	struct tb_pci_tunnel *tunnel = kzalloc(sizeof(*tunnel), GFP_KERNEL);
+	if (!tunnel)
+		goto err;
+	tunnel->tb = tb;
+	tunnel->down_port = down;
+	tunnel->up_port = up;
+	INIT_LIST_HEAD(&tunnel->list);
+	tunnel->path_to_up = tb_path_alloc(up->sw->tb, 2);
+	if (!tunnel->path_to_up)
+		goto err;
+	tunnel->path_to_down = tb_path_alloc(up->sw->tb, 2);
+	if (!tunnel->path_to_down)
+		goto err;
+	tb_pci_init_path(tunnel->path_to_up);
+	tb_pci_init_path(tunnel->path_to_down);
+
+	tunnel->path_to_up->hops[0].in_port = down;
+	tunnel->path_to_up->hops[0].in_hop_index = 8;
+	tunnel->path_to_up->hops[0].in_counter_index = -1;
+	tunnel->path_to_up->hops[0].out_port = tb_upstream_port(up->sw)->remote;
+	tunnel->path_to_up->hops[0].next_hop_index = 8;
+
+	tunnel->path_to_up->hops[1].in_port = tb_upstream_port(up->sw);
+	tunnel->path_to_up->hops[1].in_hop_index = 8;
+	tunnel->path_to_up->hops[1].in_counter_index = -1;
+	tunnel->path_to_up->hops[1].out_port = up;
+	tunnel->path_to_up->hops[1].next_hop_index = 8;
+
+	tunnel->path_to_down->hops[0].in_port = up;
+	tunnel->path_to_down->hops[0].in_hop_index = 8;
+	tunnel->path_to_down->hops[0].in_counter_index = -1;
+	tunnel->path_to_down->hops[0].out_port = tb_upstream_port(up->sw);
+	tunnel->path_to_down->hops[0].next_hop_index = 8;
+
+	tunnel->path_to_down->hops[1].in_port =
+		tb_upstream_port(up->sw)->remote;
+	tunnel->path_to_down->hops[1].in_hop_index = 8;
+	tunnel->path_to_down->hops[1].in_counter_index = -1;
+	tunnel->path_to_down->hops[1].out_port = down;
+	tunnel->path_to_down->hops[1].next_hop_index = 8;
+	return tunnel;
+
+err:
+	if (tunnel) {
+		if (tunnel->path_to_down)
+			tb_path_free(tunnel->path_to_down);
+		if (tunnel->path_to_up)
+			tb_path_free(tunnel->path_to_up);
+		kfree(tunnel);
+	}
+	return NULL;
+}
+
+/**
+ * tb_pci_free() - free a tunnel
+ *
+ * The tunnel must have been deactivated.
+ */
+void tb_pci_free(struct tb_pci_tunnel *tunnel)
+{
+	if (tunnel->path_to_up->activated || tunnel->path_to_down->activated) {
+		tb_tunnel_WARN(tunnel, "trying to free an activated tunnel\n");
+		return;
+	}
+	tb_path_free(tunnel->path_to_up);
+	tb_path_free(tunnel->path_to_down);
+	kfree(tunnel);
+}
+
+/**
+ * tb_pci_is_invalid - check whether an activated path is still valid
+ */
+bool tb_pci_is_invalid(struct tb_pci_tunnel *tunnel)
+{
+	WARN_ON(!tunnel->path_to_up->activated);
+	WARN_ON(!tunnel->path_to_down->activated);
+
+	return tb_path_is_invalid(tunnel->path_to_up)
+	       || tb_path_is_invalid(tunnel->path_to_down);
+}
+
+/**
+ * tb_pci_port_active() - activate/deactivate PCI capability
+ *
+ * Return: Returns 0 on success or an error code on failure.
+ */
+static int tb_pci_port_active(struct tb_port *port, bool active)
+{
+	u32 word = active ? 0x80000000 : 0x0;
+	int cap = tb_find_cap(port, TB_CFG_PORT, TB_CAP_PCIE);
+	if (cap <= 0) {
+		tb_port_warn(port, "TB_CAP_PCIE not found: %d\n", cap);
+		return cap ? cap : -ENXIO;
+	}
+	return tb_port_write(port, &word, TB_CFG_PORT, cap, 1);
+}
+
+/**
+ * tb_pci_activate() - activate a tunnel
+ *
+ * Return: Returns 0 on success or an error code on failure.
+ */
+int tb_pci_activate(struct tb_pci_tunnel *tunnel)
+{
+	int res;
+	if (tunnel->path_to_up->activated || tunnel->path_to_down->activated) {
+		tb_tunnel_WARN(tunnel,
+			       "trying to activate an already activated tunnel\n");
+		return -EINVAL;
+	}
+	tb_tunnel_info(tunnel, "activating\n");
+
+	res = tb_path_activate(tunnel->path_to_up);
+	if (res)
+		goto err;
+	res = tb_path_activate(tunnel->path_to_down);
+	if (res)
+		goto err;
+
+	res = tb_pci_port_active(tunnel->down_port, true);
+	if (res)
+		goto err;
+
+	res = tb_pci_port_active(tunnel->up_port, true);
+	if (res)
+		goto err;
+
+	list_add(&tunnel->list, &tunnel->tb->tunnel_list);
+	return 0;
+err:
+	tb_tunnel_warn(tunnel, "activation failed\n");
+	tb_pci_deactivate(tunnel);
+	return res;
+}
+
+/**
+ * tb_pci_deactivate() - deactivate a tunnel
+ */
+void tb_pci_deactivate(struct tb_pci_tunnel *tunnel)
+{
+	tb_tunnel_info(tunnel, "deactivating\n");
+	/*
+	 * TODO: enable reset by writing 0x04000000 to TB_CAP_PCIE + 1 on up
+	 * port. Seems to have no effect?
+	 */
+	tb_pci_port_active(tunnel->up_port, false);
+	tb_pci_port_active(tunnel->down_port, false);
+	if (tunnel->path_to_down->activated)
+		tb_path_deactivate(tunnel->path_to_down);
+	if (tunnel->path_to_up->activated)
+		tb_path_deactivate(tunnel->path_to_up);
+
+	list_del_init(&tunnel->list);
+}
+
diff --git a/drivers/thunderbolt/tb_pci.h b/drivers/thunderbolt/tb_pci.h
new file mode 100644
index 0000000..5ffa6bc
--- /dev/null
+++ b/drivers/thunderbolt/tb_pci.h
@@ -0,0 +1,29 @@
+/*
+ * Thunderbolt PCIe tunnel
+ *
+ * Copyright (c) 2013 Andreas Noever <andreas.noever@gmail.com>
+ */
+
+#ifndef TB_PCI_H_
+#define TB_PCI_H_
+
+#include "tb.h"
+
+struct tb_pci_tunnel {
+	struct tb *tb;
+	struct tb_port *up_port;
+	struct tb_port *down_port;
+	struct tb_path *path_to_up;
+	struct tb_path *path_to_down;
+	struct list_head list;
+};
+
+struct tb_pci_tunnel *tb_pci_alloc(struct tb *tb, struct tb_port *up,
+				   struct tb_port *down);
+void tb_pci_free(struct tb_pci_tunnel *tunnel);
+int tb_pci_activate(struct tb_pci_tunnel *tunnel);
+void tb_pci_deactivate(struct tb_pci_tunnel *tunnel);
+bool tb_pci_is_invalid(struct tb_pci_tunnel *tunnel);
+
+#endif
+
-- 
1.8.4.2

