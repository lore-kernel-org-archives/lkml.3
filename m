Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759434AbaDKAa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 20:30:27 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:63451 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422758AbaDKAZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 20:25:49 -0400
From: Andreas Noever <andreas.noever@gmail.com>
To: linux-kernel@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Daniel J Blueman <daniel@quora.org>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org, Andreas Noever <andreas.noever@gmail.com>
Subject: [PATCH v2 07/14] thunderbolt: Enable plug events
Date: Fri, 11 Apr 2014 02:24:54 +0200
Message-Id: <1397175901-4023-8-git-send-email-andreas.noever@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1397175901-4023-1-git-send-email-andreas.noever@gmail.com>
References: <1397175901-4023-1-git-send-email-andreas.noever@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thunderbolt switches have a plug events capability. This patch adds the
tb_plug_events_active method and uses it to activate plug events during
switch allocation.

Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
---
 drivers/thunderbolt/switch.c | 46 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/thunderbolt/tb.h     |  1 +
 2 files changed, 47 insertions(+)

diff --git a/drivers/thunderbolt/switch.c b/drivers/thunderbolt/switch.c
index e89121f..21457cc 100644
--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -99,6 +99,39 @@ static void tb_dump_switch(struct tb *tb, struct tb_regs_switch_header *sw)
 }
 
 /**
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
+
+/**
  * tb_switch_free() - free a tb_switch and all downstream switches
  */
 void tb_switch_free(struct tb_switch *sw)
@@ -113,6 +146,8 @@ void tb_switch_free(struct tb_switch *sw)
 		sw->ports[i].remote = NULL;
 	}
 
+	tb_plug_events_active(sw, false);
+
 	kfree(sw->ports);
 	kfree(sw);
 }
@@ -125,6 +160,7 @@ void tb_switch_free(struct tb_switch *sw)
 struct tb_switch *tb_switch_alloc(struct tb *tb, u64 route)
 {
 	int i;
+	int cap;
 	struct tb_switch *sw;
 	int upstream_port = tb_cfg_get_upstream_port(tb->ctl, route);
 	if (upstream_port < 0)
@@ -177,6 +213,16 @@ struct tb_switch *tb_switch_alloc(struct tb *tb, u64 route)
 
 	/* TODO: I2C, IECS, EEPROM, link controller */
 
+	cap = tb_find_cap(&sw->ports[0], TB_CFG_SWITCH, TB_CAP_PLUG_EVENTS);
+	if (cap < 0) {
+		tb_sw_warn(sw, "cannot find TB_CAP_PLUG_EVENTS aborting\n");
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
diff --git a/drivers/thunderbolt/tb.h b/drivers/thunderbolt/tb.h
index e620f1b..feb6c7a 100644
--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -19,6 +19,7 @@ struct tb_switch {
 	struct tb_regs_switch_header config;
 	struct tb_port *ports;
 	struct tb *tb;
+	int cap_plug_events; /* offset, zero if not found */
 };
 
 /**
-- 
1.9.2

