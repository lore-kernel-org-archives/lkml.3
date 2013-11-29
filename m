Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab3K2Bjr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 20:39:47 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:52127 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab3K2Bja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 20:39:30 -0500
From: Andreas Noever <andreas.noever@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andreas Noever <andreas.noever@gmail.com>
Subject: [PATCH 12/12] thunderbolt: Scan and activate one PCI device
Date: Fri, 29 Nov 2013 02:35:49 +0100
Message-Id: <1385688949-7101-13-git-send-email-andreas.noever@gmail.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1385688949-7101-1-git-send-email-andreas.noever@gmail.com>
References: <1385688949-7101-1-git-send-email-andreas.noever@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the tb_pci_* methods introduces in the last patch to activate
a the first PCI device on every plugged in thunderbolt device.

Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
---
 drivers/thunderbolt/tb.c | 118 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 115 insertions(+), 3 deletions(-)

diff --git a/drivers/thunderbolt/tb.c b/drivers/thunderbolt/tb.c
index 9f25935..0e82afd 100644
--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -838,6 +838,109 @@ static void destroy_invalid_tunnels(struct tb *tb)
 	}
 }
 
+/**
+ * find_pci_up_port() - return the first PCIe up port on @sw
+ */
+static struct tb_port *find_pci_up_port(struct tb_switch *sw)
+{
+	int i;
+	for (i = 1; i <= sw->config.max_port_number; i++)
+		if (sw->ports[i].config.type == TB_TYPE_PCIE_UP)
+			return &sw->ports[i];
+	return NULL;
+}
+
+/**
+ * find_unused_down_port() - return the first inactive PCIe down port on @sw
+ */
+static struct tb_port *find_unused_down_port(struct tb_switch *sw)
+{
+	int i;
+	int cap;
+	int res;
+	int data;
+	for (i = 1; i <= sw->config.max_port_number; i++) {
+		if (tb_is_upstream_port(&sw->ports[i]))
+			continue;
+		if (sw->ports[i].config.type != TB_TYPE_PCIE_DOWN)
+			continue;
+		cap = tb_find_cap(&sw->ports[i], TB_CFG_PORT, TB_CAP_PCIE);
+		if (cap <= 0)
+			continue;
+		res = tb_port_read(&sw->ports[i], &data, TB_CFG_PORT, cap, 1);
+		if (res < 0)
+			continue;
+		if (data & 0x80000000)
+			continue;
+		return &sw->ports[i];
+	}
+	return NULL;
+}
+
+/**
+ * tb_activate_pcie_devices() - scan for and activate PCIe devices
+ *
+ * This method is somewhat ad hoc. For now it only supports one device
+ * per port and only devices at depth 1.
+ */
+static void tb_activate_pcie_devices(struct tb *tb)
+{
+	int i;
+	int cap;
+	u32 data;
+	struct tb_switch *sw;
+	struct tb_port *up_port;
+	struct tb_port *down_port;
+	struct tb_pci_tunnel *tunnel;
+	/* scan for pcie devices at depth 1*/
+	for (i = 1; i <= tb->root_switch->config.max_port_number; i++) {
+		if (tb_is_upstream_port(&tb->root_switch->ports[i]))
+			continue;
+		if (tb->root_switch->ports[i].config.type != TB_TYPE_PORT)
+			continue;
+		if (!tb->root_switch->ports[i].remote)
+			continue;
+		sw = tb->root_switch->ports[i].remote->sw;
+		up_port = find_pci_up_port(sw);
+		if (!up_port) {
+			tb_sw_info(sw, "no PCIe devices found, aborting\n");
+			continue;
+		}
+
+		/* check whether port is already activated */
+		cap = tb_find_cap(up_port, TB_CFG_PORT, TB_CAP_PCIE);
+		if (cap <= 0)
+			continue;
+		if (tb_port_read(up_port, &data, TB_CFG_PORT, cap, 1))
+			continue;
+		if (data & 0x80000000) {
+			tb_port_info(up_port,
+				     "PCIe port already activated, aborting\n");
+			continue;
+		}
+
+		down_port = find_unused_down_port(tb->root_switch);
+		if (!down_port) {
+			tb_port_info(up_port,
+				     "All PCIe down ports are occupied, aborting\n");
+			continue;
+		}
+		tunnel = tb_pci_alloc(tb, up_port, down_port);
+		if (!tunnel) {
+			tb_port_info(up_port,
+				     "PCIe tunnel allocation failed, aborting\n");
+			continue;
+		}
+
+		if (tb_pci_activate(tunnel)) {
+			tb_port_info(up_port,
+				     "PCIe tunnel activation failed, aborting\n");
+			tb_pci_free(tunnel);
+		}
+
+	}
+}
+
 struct tb_hotplug_event {
 	struct work_struct work;
 	struct tb *tb;
@@ -901,8 +1004,16 @@ static void tb_handle_hotplug(struct work_struct *work)
 	} else {
 		tb_port_info(port, "hotplug: scanning\n");
 		tb_scan_port(port);
-		if (!port->remote)
+		if (!port->remote) {
 			tb_port_info(port, "hotplug: no switch found\n");
+		} else if (port->remote->sw->config.depth > 1) {
+			tb_sw_warn(port->remote->sw,
+				   "hotplug: chaining not supported\n");
+		} else {
+			tb_sw_info(port->remote->sw,
+				   "hotplug: activating pcie devices\n");
+			tb_activate_pcie_devices(tb);
+		}
 	}
 out:
 	mutex_unlock(&tb->lock);
@@ -972,8 +1083,8 @@ void thunderbolt_shutdown_and_free(struct tb *tb)
 /**
  * thunderbolt_alloc_and_start() - setup the thunderbolt bus
  *
- * Allocates a tb_cfg control channel, initializes the root switch and enables
- * plug events.
+ * Allocates a tb_cfg control channel, initializes the root switch, enables
+ * plug events and activates pci devices.
  *
  * Return: Returns NULL on error.
  */
@@ -1014,6 +1125,7 @@ struct tb *thunderbolt_alloc_and_start(struct tb_nhi *nhi)
 		goto err_locked;
 
 	tb_scan_ports(tb->root_switch);
+	tb_activate_pcie_devices(tb);
 
 	mutex_unlock(&tb->lock);
 	return tb;
-- 
1.8.4.2

