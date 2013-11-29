Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab3K2Bj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 20:39:29 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:36023 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab3K2BjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 20:39:25 -0500
From: Andreas Noever <andreas.noever@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andreas Noever <andreas.noever@gmail.com>
Subject: [PATCH 05/12] thunderbolt: Initialize root switch and ports
Date: Fri, 29 Nov 2013 02:35:42 +0100
Message-Id: <1385688949-7101-6-git-send-email-andreas.noever@gmail.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1385688949-7101-1-git-send-email-andreas.noever@gmail.com>
References: <1385688949-7101-1-git-send-email-andreas.noever@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the structures tb_switch and tb_port as well as code to
reset and configure the root switch.

Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
---
 drivers/thunderbolt/tb.c | 229 ++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/thunderbolt/tb.h | 113 +++++++++++++++++++++++
 2 files changed, 340 insertions(+), 2 deletions(-)

diff --git a/drivers/thunderbolt/tb.c b/drivers/thunderbolt/tb.c
index 64deb7b..d2df3be 100644
--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -8,7 +8,217 @@
 #include <linux/errno.h>
 #include <linux/delay.h>
 
+#include "dsl3510.h"
 #include "tb.h"
+#include "tb_regs.h"
+
+/* utility functions */
+
+static void tb_dump_switch(struct tb *tb, struct tb_regs_switch_header *sw)
+{
+	tb_info(tb,
+		" Switch: %x:%x (Revision: %d, TB Version: %d)\n",
+		sw->vendor_id,
+		sw->device_id,
+		sw->revision,
+		sw->thunderbolt_version);
+	tb_info(tb, "  Max Port Number: %d\n", sw->max_port_number);
+	tb_info(tb, "  Config:\n");
+	tb_info(tb,
+		"   Upstream Port Number: %d Depth: %d Route String: %#llx Enabled: %d, PlugEventsDelay: %dms\n",
+		sw->upstream_port_number,
+		sw->depth,
+		(((u64) sw->route_hi) << 32) | sw->route_lo,
+		sw->enabled,
+		sw->plug_events_delay);
+	tb_info(tb,
+		"   unknown1: %#x unknown4: %#x\n",
+		sw->__unknown1,
+		sw->__unknown4);
+}
+
+static char *tb_port_type(struct tb_regs_port_header *port)
+{
+	switch (port->type >> 16) {
+	case 0:
+		switch ((u8) port->type) {
+		case 0:
+			return "Inactive";
+		case 1:
+			return "Port";
+		case 2:
+			return "NHI";
+		default:
+			return "unknown";
+		}
+	case 0x2:
+		return "Ethernet";
+	case 0x8:
+		return "SATA";
+	case 0xe:
+		return "DP/HDMI";
+	case 0x10:
+		return "PCIe";
+	case 0x20:
+		return "USB";
+	default:
+		return "unknown";
+	}
+}
+
+static void tb_dump_port(struct tb *tb, struct tb_regs_port_header *port)
+{
+	tb_info(tb,
+		" Port %d: %x:%x (Revision: %d, TB Version: %d, Type: %s (%#x))\n",
+		port->port_number,
+		port->vendor_id,
+		port->device_id,
+		port->revision,
+		port->thunderbolt_version,
+		tb_port_type(port),
+		port->type);
+	tb_info(tb,
+		"  Max hop id (in/out): %d/%d, NFC Credits: %#x\n",
+		port->max_in_hop_id,
+		port->max_out_hop_id,
+		port->nfc_credits);
+}
+
+static int tb_route_length(u64 route)
+{
+	return (fls64(route) + TB_ROUTE_SHIFT - 1) / TB_ROUTE_SHIFT;
+}
+
+/* switch/port allocation & initialization */
+
+/**
+ * tb_init_port() - initialize a port
+ *
+ * This is a helper method for tb_switch_alloc. Does not check or initialize
+ * any downstream switches.
+ *
+ * Return: Returns 0 on success or an error code on failure.
+ */
+static int tb_init_port(struct tb_switch *sw, u8 port_nr)
+{
+	int res;
+	struct tb_port *port = &sw->ports[port_nr];
+	port->sw = sw;
+	port->port = port_nr;
+	res = tb_port_read(port, &port->config, TB_CFG_PORT, 0, 8);
+	if (res)
+		return res;
+
+	tb_dump_port(sw->tb, &port->config);
+
+	/* TODO: Read dual link port, DP port and more from EEPROM. */
+	return 0;
+
+}
+
+/**
+ * tb_switch_free() - free a tb_switch and all downstream switches
+ */
+static void tb_switch_free(struct tb_switch *sw)
+{
+	kfree(sw->ports);
+	kfree(sw);
+}
+
+/**
+ * tb_switch_alloc() - allocate and initialize a switch
+ *
+ * Return: Returns a NULL on failure.
+ */
+static struct tb_switch *tb_switch_alloc(struct tb *tb, u64 route)
+{
+	int i;
+	struct tb_switch *sw;
+	int upstream_port = tb_cfg_get_upstream_port(tb->cfg, route);
+	if (upstream_port < 0)
+		return NULL;
+
+	sw = kzalloc(sizeof(*sw), GFP_KERNEL);
+	if (!sw)
+		return NULL;
+
+	sw->tb = tb;
+	if (tb_cfg_read(tb->cfg, &sw->config, route, 0, 2, 0, 5))
+		goto err;
+	tb_info(tb,
+		"initializing Switch at %#llx (depth: %d, up port: %d)\n",
+		route,
+		tb_route_length(route),
+		upstream_port);
+	tb_info(tb, "old switch config:\n");
+	tb_dump_switch(tb, &sw->config);
+
+	/* configure switch */
+	sw->config.upstream_port_number = upstream_port;
+	sw->config.depth = tb_route_length(route);
+	sw->config.route_lo = route;
+	sw->config.route_hi = route >> 32;
+	sw->config.enabled = 1;
+	/* from here on we may use the tb_sw_* functions & macros */
+
+	if (sw->config.vendor_id != 0x8086) {
+		tb_sw_WARN(sw,
+			   "unsupported switch vendor id %#x, aborting\n",
+			   sw->config.vendor_id);
+		goto err;
+	}
+	if (sw->config.device_id != 0x1547 && sw->config.device_id != 0x1549) {
+
+		tb_sw_WARN(sw,
+			   "unsupported switch device id %#x, aborting\n",
+			   sw->config.device_id);
+		goto err;
+	}
+
+	/* upload configuration */
+	if (tb_sw_write(sw, 1 + (u32 *) &sw->config, TB_CFG_SWITCH, 1, 3))
+		goto err;
+
+	/* initialize ports */
+	sw->ports = kcalloc(sw->config.max_port_number + 1, sizeof(*sw->ports),
+	GFP_KERNEL);
+	if (!sw->ports)
+		goto err;
+
+	for (i = 0; i <= sw->config.max_port_number; i++) {
+		if (tb_init_port(sw, i))
+			goto err;
+		/* TODO: check if port is disabled (EEPROM) */
+	}
+
+	/* TODO: I2C, IECS, EEPROM, link controller */
+
+	return sw;
+err:
+	kfree(sw->ports);
+	kfree(sw);
+	return NULL;
+}
+
+/**
+ * reset_switch() - send TB_CFG_PKG_RESET and enable switch
+ *
+ * Return: Returns 0 on success or an error code on failure.
+ */
+static int tb_switch_reset(struct tb *tb, u64 route)
+{
+	int res;
+	struct tb_regs_switch_header header = {
+		header.route_hi = route >> 32,
+		header.route_lo = route,
+		header.enabled = true,
+	};
+	tb_info(tb, "resetting switch at %llx\n", route);
+	res = tb_cfg_reset(tb->cfg, route);
+	if (res)
+		return res;
+	return tb_cfg_write(tb->cfg, ((u32 *) &header) + 2, route, 0, 2, 2, 2);
+}
 
 struct tb_hotplug_event {
 	struct work_struct work;
@@ -59,13 +269,17 @@ static void tb_schedule_hotplug_handler(void *data, u64 route, u8 port,
 /**
  * thunderbolt_shutdown_and_free() - shutdown everything
  *
- * Free the config channel.
+ * Free all switches and the config channel.
  */
 void thunderbolt_shutdown_and_free(struct tb *tb)
 {
 	mutex_lock(&tb->lock);
 	tb->shutdown = true; /* signal tb_handle_hotplug to quit */
 
+	if (tb->root_switch)
+		tb_switch_free(tb->root_switch);
+	tb->root_switch = NULL;
+
 	if (tb->cfg)
 		tb_cfg_free(tb->cfg);
 	tb->cfg = NULL;
@@ -84,7 +298,7 @@ void thunderbolt_shutdown_and_free(struct tb *tb)
 /**
  * thunderbolt_alloc_and_start() - setup the thunderbolt bus
  *
- * Allocates a tb_cfg control channel.
+ * Allocates a tb_cfg control channel and initializes the root switch.
  *
  * Return: Returns NULL on error.
  */
@@ -92,6 +306,10 @@ struct tb *thunderbolt_alloc_and_start(struct tb_nhi *nhi)
 {
 	struct tb *tb;
 
+	BUILD_BUG_ON(sizeof(struct tb_regs_switch_header) != 5 * 4);
+	BUILD_BUG_ON(sizeof(struct tb_regs_port_header) != 8 * 4);
+	BUILD_BUG_ON(sizeof(struct tb_regs_hop) != 2 * 4);
+
 	tb = kzalloc(sizeof(*tb), GFP_KERNEL);
 	if (!tb)
 		return NULL;
@@ -112,6 +330,13 @@ struct tb *thunderbolt_alloc_and_start(struct tb_nhi *nhi)
 	if (!tb->cfg)
 		goto err_locked;
 
+	if (tb_switch_reset(tb, 0))
+		goto err_locked;
+
+	tb->root_switch = tb_switch_alloc(tb, 0);
+	if (!tb->root_switch)
+		goto err_locked;
+
 	mutex_unlock(&tb->lock);
 	return tb;
 
diff --git a/drivers/thunderbolt/tb.h b/drivers/thunderbolt/tb.h
index a3378dc..4000f2b 100644
--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -9,8 +9,32 @@
 
 #include <linux/pci.h>
 
+#include "tb_regs.h"
 #include "tb_cfg.h"
 
+#define TB_PORT_MASK 0x3f
+#define TB_ROUTE_SHIFT 8
+
+/**
+ * struct tb_switch - a thunderbolt switch
+ */
+struct tb_switch {
+	struct tb_regs_switch_header config;
+	struct tb_port *ports;
+	struct tb *tb;
+	bool invalid; /* unplugged, will go away */
+};
+
+/**
+ * struct tb_port - a thunderbolt port, part of a tb_switch
+ */
+struct tb_port {
+	struct tb_regs_port_header config;
+	struct tb_switch *sw;
+	u8 port; /* port number on switch */
+	bool invalid; /* unplugged, will go away */
+};
+
 /**
  * struct tb - main thunderbolt bus structure
  */
@@ -22,12 +46,101 @@ struct tb {
 	struct tb_nhi *nhi;
 	struct tb_cfg *cfg;
 	struct workqueue_struct *wq; /* ordered workqueue for plug events */
+	struct tb_switch *root_switch;
 	bool shutdown;	/*
 			 * Once this is set tb_handle_hotplug will exit (once it
 			 * can aquire lock at least once). Used to drain wq.
 			 */
 };
 
+static inline u64 tb_route(struct tb_switch *sw)
+{
+	return ((u64) sw->config.route_hi) << 32 | sw->config.route_lo;
+}
+
+/* helper functions & macros */
+
+static inline int tb_sw_read(struct tb_switch *sw, void *buffer,
+			     enum tb_cfg_space space, uint32_t offset,
+			     uint32_t length)
+{
+	return tb_cfg_read(sw->tb->cfg,
+			   buffer,
+			   tb_route(sw),
+			   0,
+			   space,
+			   offset,
+			   length);
+}
+
+static inline int tb_sw_write(struct tb_switch *sw, void *buffer,
+			      enum tb_cfg_space space, uint32_t offset,
+			      uint32_t length)
+{
+	return tb_cfg_write(sw->tb->cfg,
+			    buffer,
+			    tb_route(sw),
+			    0,
+			    space,
+			    offset,
+			    length);
+}
+
+static inline int tb_port_read(struct tb_port *port, void *buffer,
+			       enum tb_cfg_space space, uint32_t offset,
+			       uint32_t length)
+{
+	return tb_cfg_read(port->sw->tb->cfg,
+			   buffer,
+			   tb_route(port->sw),
+			   port->port,
+			   space,
+			   offset,
+			   length);
+}
+
+static inline int tb_port_write(struct tb_port *port, void *buffer,
+				enum tb_cfg_space space, uint32_t offset,
+				uint32_t length)
+{
+	return tb_cfg_write(port->sw->tb->cfg,
+			    buffer,
+			    tb_route(port->sw),
+			    port->port,
+			    space,
+			    offset,
+			    length);
+}
+
+#define tb_WARN(tb, fmt, arg...) dev_WARN(&(tb)->nhi->pdev->dev, fmt, ## arg)
+#define tb_warn(tb, fmt, arg...) dev_warn(&(tb)->nhi->pdev->dev, fmt, ## arg)
+#define tb_info(tb, fmt, arg...) dev_info(&(tb)->nhi->pdev->dev, fmt, ## arg)
+
+
+#define __TB_SW_PRINT(level, sw, fmt, arg...)           \
+	do {                                            \
+		struct tb_switch *__sw = (sw);          \
+		level(__sw->tb, "%llx: " fmt,           \
+		      tb_route(__sw), ## arg);          \
+	} while (0)
+#define tb_sw_WARN(sw, fmt, arg...) __TB_SW_PRINT(tb_WARN, sw, fmt, ##arg)
+#define tb_sw_warn(sw, fmt, arg...) __TB_SW_PRINT(tb_warn, sw, fmt, ##arg)
+#define tb_sw_info(sw, fmt, arg...) __TB_SW_PRINT(tb_info, sw, fmt, ##arg)
+
+
+#define __TB_PORT_PRINT(level, _port, fmt, arg...)                      \
+	do {                                                            \
+		struct tb_port *__port = (_port);                       \
+		level(__port->sw->tb, "%llx:%x: " fmt,                  \
+		      tb_route(__port->sw), __port->port, ## arg);      \
+	} while (0)
+#define tb_port_WARN(port, fmt, arg...) \
+	__TB_PORT_PRINT(tb_WARN, port, fmt, ##arg)
+#define tb_port_warn(port, fmt, arg...) \
+	__TB_PORT_PRINT(tb_warn, port, fmt, ##arg)
+#define tb_port_info(port, fmt, arg...) \
+	__TB_PORT_PRINT(tb_info, port, fmt, ##arg)
+
 struct tb *thunderbolt_alloc_and_start(struct tb_nhi *nhi);
 void thunderbolt_shutdown_and_free(struct tb *tb);
 
-- 
1.8.4.2

