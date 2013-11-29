Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362Ab3K2BlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 20:41:19 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:64978 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab3K2Bj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 20:39:26 -0500
From: Andreas Noever <andreas.noever@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andreas Noever <andreas.noever@gmail.com>
Subject: [PATCH 07/12] thunderbolt: Enable plug events
Date: Fri, 29 Nov 2013 02:35:44 +0100
Message-Id: <1385688949-7101-8-git-send-email-andreas.noever@gmail.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1385688949-7101-1-git-send-email-andreas.noever@gmail.com>
References: <1385688949-7101-1-git-send-email-andreas.noever@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thunderbolt switches have a plug events capability. This patch adds the
tb_plug_events_active method and uses it to activate plug events on
switch allocation.

Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
---
 drivers/thunderbolt/tb.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/thunderbolt/tb.h |  1 +
 2 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/drivers/thunderbolt/tb.c b/drivers/thunderbolt/tb.c
index 943842b..3837f1a 100644
--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -192,6 +192,41 @@ int tb_find_cap(struct tb_port *port, enum tb_cfg_space space, enum tb_cap cap)
 	return -EIO;
 }
 
+
+/* thunderbolt switch utility functions */
+
+/**
+ * tb_plug_events_active() - enable/disable plug events on a switch
+ *
+ * Also configures a sane plug_events_delay of 255ms.
+ *
+ * Return: Returns 0 on success or an error code on failure.
+ */
+static int tb_plug_events_active(struct tb_switch *sw, bool active)
+{
+	u32 data;
+	int res;
+
+	sw->config.plug_events_delay = 0xff;
+	res = tb_sw_write(sw, ((u32 *) &sw->config) + 4, TB_CFG_SWITCH, 4, 1);
+	if (res)
+		return res;
+
+	res = tb_sw_read(sw, &data, TB_CFG_SWITCH, sw->cap_plug_events + 1, 1);
+	if (res)
+		return res;
+
+	if (active) {
+		data = data & 0xFFFFFF83;
+		if (sw->config.device_id == 0x1547)
+			data |= 4;
+	} else {
+		data = data | 0x7c;
+	}
+	return tb_sw_write(sw, &data, TB_CFG_SWITCH,
+			   sw->cap_plug_events + 1, 1);
+}
+
 /* switch/port allocation & initialization */
 
 /**
@@ -236,6 +271,7 @@ static void tb_switch_free(struct tb_switch *sw)
 static struct tb_switch *tb_switch_alloc(struct tb *tb, u64 route)
 {
 	int i;
+	int cap;
 	struct tb_switch *sw;
 	int upstream_port = tb_cfg_get_upstream_port(tb->cfg, route);
 	if (upstream_port < 0)
@@ -296,6 +332,16 @@ static struct tb_switch *tb_switch_alloc(struct tb *tb, u64 route)
 
 	/* TODO: I2C, IECS, EEPROM, link controller */
 
+	cap = tb_find_cap(&sw->ports[0], TB_CFG_SWITCH, TB_CAP_PLUG_EVENTS);
+	if (cap < 0) {
+		tb_sw_WARN(sw, "cannot find TB_CAP_PLUG_EVENTS aborting\n");
+		goto err;
+	}
+	sw->cap_plug_events = cap;
+
+	if (tb_plug_events_active(sw, true))
+		goto err;
+
 	return sw;
 err:
 	kfree(sw->ports);
@@ -401,7 +447,8 @@ void thunderbolt_shutdown_and_free(struct tb *tb)
 /**
  * thunderbolt_alloc_and_start() - setup the thunderbolt bus
  *
- * Allocates a tb_cfg control channel and initializes the root switch.
+ * Allocates a tb_cfg control channel, initializes the root switch and enables
+ * plug events.
  *
  * Return: Returns NULL on error.
  */
diff --git a/drivers/thunderbolt/tb.h b/drivers/thunderbolt/tb.h
index e81c63a..2ada42a 100644
--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -22,6 +22,7 @@ struct tb_switch {
 	struct tb_regs_switch_header config;
 	struct tb_port *ports;
 	struct tb *tb;
+	int cap_plug_events; /* offset, zero if not found */
 	bool invalid; /* unplugged, will go away */
 };
 
-- 
1.8.4.2

