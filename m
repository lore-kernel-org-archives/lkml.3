Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935145AbaEaO3w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 10:29:52 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:44452 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933196AbaEaO3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 10:29:12 -0400
From: Andreas Noever <andreas.noever@gmail.com>
To: linux-kernel@vger.kernel.org, Matthew Garrett <matthew.garrett@nebula.com>,
        Greg KH <greg@kroah.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org
Cc: Andreas Noever <andreas.noever@gmail.com>
Subject: [PATCH v4 15/15] thunderbolt: Add suspend/hibernate support
Date: Sat, 31 May 2014 16:28:00 +0200
Message-Id: <1401546480-2071-16-git-send-email-andreas.noever@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401546480-2071-1-git-send-email-andreas.noever@gmail.com>
References: <1401546480-2071-1-git-send-email-andreas.noever@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use _noirq since we have to restore the pci tunnels before the pci
core wakes the tunneled devices.

Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
---
 drivers/thunderbolt/nhi.c    | 33 +++++++++++++++++
 drivers/thunderbolt/switch.c | 84 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/thunderbolt/tb.c     | 61 ++++++++++++++++++++++++++++++++
 drivers/thunderbolt/tb.h     |  5 +++
 4 files changed, 183 insertions(+)

diff --git a/drivers/thunderbolt/nhi.c b/drivers/thunderbolt/nhi.c
index f3a4ac2..6f666fa 100644
--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -7,6 +7,7 @@
  * Copyright (c) 2014 Andreas Noever <andreas.noever@gmail.com>
  */
 
+#include <linux/pm_runtime.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
 #include <linux/pci.h>
@@ -492,6 +493,22 @@ static irqreturn_t nhi_msi(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
+static int nhi_suspend_noirq(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct tb *tb = pci_get_drvdata(pdev);
+	thunderbolt_suspend(tb);
+	return 0;
+}
+
+static int nhi_resume_noirq(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct tb *tb = pci_get_drvdata(pdev);
+	thunderbolt_resume(tb);
+	return 0;
+}
+
 static void nhi_shutdown(struct tb_nhi *nhi)
 {
 	int i;
@@ -600,6 +617,21 @@ static void nhi_remove(struct pci_dev *pdev)
 	nhi_shutdown(nhi);
 }
 
+/*
+ * The tunneled pci bridges are siblings of us. Use resume_noirq to reenable
+ * the tunnels asap. A corresponding pci quirk blocks the downstream bridges
+ * resume_noirq until we are done.
+ */
+static const struct dev_pm_ops nhi_pm_ops = {
+	.suspend_noirq = nhi_suspend_noirq,
+	.resume_noirq = nhi_resume_noirq,
+	.freeze_noirq = nhi_suspend_noirq, /*
+					    * we just disable hotplug, the
+					    * pci-tunnels stay alive.
+					    */
+	.restore_noirq = nhi_resume_noirq,
+};
+
 struct pci_device_id nhi_ids[] = {
 	{
 		/*
@@ -621,6 +653,7 @@ static struct pci_driver nhi_driver = {
 	.id_table = nhi_ids,
 	.probe = nhi_probe,
 	.remove = nhi_remove,
+	.driver.pm = &nhi_pm_ops,
 };
 
 static int __init nhi_init(void)
diff --git a/drivers/thunderbolt/switch.c b/drivers/thunderbolt/switch.c
index eef5f1c..2e19045 100644
--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -229,6 +229,30 @@ static void tb_dump_switch(struct tb *tb, struct tb_regs_switch_header *sw)
 		sw->__unknown1, sw->__unknown4);
 }
 
+/**
+ * reset_switch() - reconfigure route, enable and send TB_CFG_PKG_RESET
+ *
+ * Return: Returns 0 on success or an error code on failure.
+ */
+int tb_switch_reset(struct tb *tb, u64 route)
+{
+	struct tb_cfg_result res;
+	struct tb_regs_switch_header header = {
+		header.route_hi = route >> 32,
+		header.route_lo = route,
+		header.enabled = true,
+	};
+	tb_info(tb, "resetting switch at %llx\n", route);
+	res.err = tb_cfg_write(tb->ctl, ((u32 *) &header) + 2, route,
+			0, 2, 2, 2);
+	if (res.err)
+		return res.err;
+	res = tb_cfg_reset(tb->ctl, route, TB_CFG_DEFAULT_TIMEOUT);
+	if (res.err > 0)
+		return -EIO;
+	return res.err;
+}
+
 struct tb_switch *get_switch_at_route(struct tb_switch *sw, u64 route)
 {
 	u8 next_port = route; /*
@@ -406,3 +430,63 @@ void tb_sw_set_unpplugged(struct tb_switch *sw)
 	}
 }
 
+int tb_switch_resume(struct tb_switch *sw)
+{
+	int i, err;
+	u64 uid;
+	tb_sw_info(sw, "resuming switch\n");
+
+	err = tb_eeprom_read_uid(sw, &uid);
+	if (err) {
+		tb_sw_warn(sw, "uid read failed\n");
+		return err;
+	}
+	if (sw->uid != uid) {
+		tb_sw_info(sw,
+			"changed while suspended (uid %#llx -> %#llx)\n",
+			sw->uid, uid);
+		return -ENODEV;
+	}
+
+	/* upload configuration */
+	err = tb_sw_write(sw, 1 + (u32 *) &sw->config, TB_CFG_SWITCH, 1, 3);
+	if (err)
+		return err;
+
+	err = tb_plug_events_active(sw, true);
+	if (err)
+		return err;
+
+	/* check for surviving downstream switches */
+	for (i = 1; i <= sw->config.max_port_number; i++) {
+		struct tb_port *port = &sw->ports[i];
+		if (tb_is_upstream_port(port))
+			continue;
+		if (!port->remote)
+			continue;
+		if (tb_wait_for_port(port, true) <= 0
+			|| tb_switch_resume(port->remote->sw)) {
+			tb_port_warn(port,
+				     "lost during suspend, disconnecting\n");
+			tb_sw_set_unpplugged(port->remote->sw);
+		}
+	}
+	return 0;
+}
+
+void tb_switch_suspend(struct tb_switch *sw)
+{
+	int i, err;
+	err = tb_plug_events_active(sw, false);
+	if (err)
+		return;
+
+	for (i = 1; i <= sw->config.max_port_number; i++) {
+		if (!tb_is_upstream_port(&sw->ports[i]) && sw->ports[i].remote)
+			tb_switch_suspend(sw->ports[i].remote->sw);
+	}
+	/*
+	 * TODO: invoke tb_cfg_prepare_to_sleep here? does not seem to have any
+	 * effect?
+	 */
+}
diff --git a/drivers/thunderbolt/tb.c b/drivers/thunderbolt/tb.c
index 177f61d..1aa6dd7 100644
--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -69,6 +69,28 @@ static void tb_free_invalid_tunnels(struct tb *tb)
 }
 
 /**
+ * tb_free_unplugged_children() - traverse hierarchy and free unplugged switches
+ */
+static void tb_free_unplugged_children(struct tb_switch *sw)
+{
+	int i;
+	for (i = 1; i <= sw->config.max_port_number; i++) {
+		struct tb_port *port = &sw->ports[i];
+		if (tb_is_upstream_port(port))
+			continue;
+		if (!port->remote)
+			continue;
+		if (port->remote->sw->is_unplugged) {
+			tb_switch_free(port->remote->sw);
+			port->remote = NULL;
+		} else {
+			tb_free_unplugged_children(port->remote->sw);
+		}
+	}
+}
+
+
+/**
  * find_pci_up_port() - return the first PCIe up port on @sw or NULL
  */
 static struct tb_port *tb_find_pci_up_port(struct tb_switch *sw)
@@ -368,3 +390,42 @@ err_locked:
 	return NULL;
 }
 
+void thunderbolt_suspend(struct tb *tb)
+{
+	tb_info(tb, "suspending...\n");
+	mutex_lock(&tb->lock);
+	tb_switch_suspend(tb->root_switch);
+	tb_ctl_stop(tb->ctl);
+	tb->hotplug_active = false; /* signal tb_handle_hotplug to quit */
+	mutex_unlock(&tb->lock);
+	tb_info(tb, "suspend finished\n");
+}
+
+void thunderbolt_resume(struct tb *tb)
+{
+	struct tb_pci_tunnel *tunnel, *n;
+	tb_info(tb, "resuming...\n");
+	mutex_lock(&tb->lock);
+	tb_ctl_start(tb->ctl);
+
+	/* remove any pci devices the firmware might have setup */
+	tb_switch_reset(tb, 0);
+
+	tb_switch_resume(tb->root_switch);
+	tb_free_invalid_tunnels(tb);
+	tb_free_unplugged_children(tb->root_switch);
+	list_for_each_entry_safe(tunnel, n, &tb->tunnel_list, list)
+		tb_pci_restart(tunnel);
+	if (!list_empty(&tb->tunnel_list)) {
+		/*
+		 * the pcie links need some time to get going.
+		 * 100ms works for me...
+		 */
+		tb_info(tb, "tunnels restarted, sleeping for 100ms\n");
+		msleep(100);
+	}
+	 /* Allow tb_handle_hotplug to progress events */
+	tb->hotplug_active = true;
+	mutex_unlock(&tb->lock);
+	tb_info(tb, "resume finished\n");
+}
diff --git a/drivers/thunderbolt/tb.h b/drivers/thunderbolt/tb.h
index a89087f..63e89d0 100644
--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -214,9 +214,14 @@ static inline int tb_port_write(struct tb_port *port, void *buffer,
 
 struct tb *thunderbolt_alloc_and_start(struct tb_nhi *nhi);
 void thunderbolt_shutdown_and_free(struct tb *tb);
+void thunderbolt_suspend(struct tb *tb);
+void thunderbolt_resume(struct tb *tb);
 
 struct tb_switch *tb_switch_alloc(struct tb *tb, u64 route);
 void tb_switch_free(struct tb_switch *sw);
+void tb_switch_suspend(struct tb_switch *sw);
+int tb_switch_resume(struct tb_switch *sw);
+int tb_switch_reset(struct tb *tb, u64 route);
 void tb_sw_set_unpplugged(struct tb_switch *sw);
 struct tb_switch *get_switch_at_route(struct tb_switch *sw, u64 route);
 
-- 
1.9.3

