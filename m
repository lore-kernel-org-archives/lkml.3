Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966371Ab3HHUJo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 16:09:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966355Ab3HHUJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 16:09:41 -0400
Subject: [PATCH v5 3/9] pci: Implement reset_slot for pciehp
To: bhelgaas@google.com, linux-pci@vger.kernel.org
From: Alex Williamson <alex.williamson@redhat.com>
Cc: alexander.h.duyck@intel.com, ddutile@redhat.com,
        indou.takao@jp.fujitsu.com, linux-kernel@vger.kernel.org
Date: Thu, 08 Aug 2013 14:09:37 -0600
Message-ID: <20130808200937.2932.176.stgit@bling.home>
In-Reply-To: <20130808200444.2932.17381.stgit@bling.home>
References: <20130808200444.2932.17381.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCIe hotplug has a bus per slot, so we can just use a normal
secondary bus reset.  However, if a slot supports surprise removal
then a bus reset can be seen as a presence detection change triggering
a hot-remove followed by a hot-add.  Disable presence detection from
triggering an interrupt or being polled around the bus reset.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/pci/hotplug/pciehp.h      |    1 +
 drivers/pci/hotplug/pciehp_core.c |   12 ++++++++++++
 drivers/pci/hotplug/pciehp_hpc.c  |   31 +++++++++++++++++++++++++++++++
 3 files changed, 44 insertions(+)

diff --git a/drivers/pci/hotplug/pciehp.h b/drivers/pci/hotplug/pciehp.h
index 7fb3269..541bbe6 100644
--- a/drivers/pci/hotplug/pciehp.h
+++ b/drivers/pci/hotplug/pciehp.h
@@ -155,6 +155,7 @@ void pciehp_green_led_off(struct slot *slot);
 void pciehp_green_led_blink(struct slot *slot);
 int pciehp_check_link_status(struct controller *ctrl);
 void pciehp_release_ctrl(struct controller *ctrl);
+int pciehp_reset_slot(struct slot *slot, int probe);
 
 static inline const char *slot_name(struct slot *slot)
 {
diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
index 7d72c5e..f4a18f5 100644
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -69,6 +69,7 @@ static int get_power_status	(struct hotplug_slot *slot, u8 *value);
 static int get_attention_status	(struct hotplug_slot *slot, u8 *value);
 static int get_latch_status	(struct hotplug_slot *slot, u8 *value);
 static int get_adapter_status	(struct hotplug_slot *slot, u8 *value);
+static int reset_slot		(struct hotplug_slot *slot, int probe);
 
 /**
  * release_slot - free up the memory used by a slot
@@ -111,6 +112,7 @@ static int init_slot(struct controller *ctrl)
 	ops->disable_slot = disable_slot;
 	ops->get_power_status = get_power_status;
 	ops->get_adapter_status = get_adapter_status;
+	ops->reset_slot = reset_slot;
 	if (MRL_SENS(ctrl))
 		ops->get_latch_status = get_latch_status;
 	if (ATTN_LED(ctrl)) {
@@ -223,6 +225,16 @@ static int get_adapter_status(struct hotplug_slot *hotplug_slot, u8 *value)
 	return pciehp_get_adapter_status(slot, value);
 }
 
+static int reset_slot(struct hotplug_slot *hotplug_slot, int probe)
+{
+	struct slot *slot = hotplug_slot->private;
+
+	ctrl_dbg(slot->ctrl, "%s: physical_slot = %s\n",
+		 __func__, slot_name(slot));
+
+	return pciehp_reset_slot(slot, probe);
+}
+
 static int pciehp_probe(struct pcie_device *dev)
 {
 	int rc;
diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index b225573..51f56ef 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -749,6 +749,37 @@ static void pcie_disable_notification(struct controller *ctrl)
 		ctrl_warn(ctrl, "Cannot disable software notification\n");
 }
 
+/*
+ * pciehp has a 1:1 bus:slot relationship so we ultimately want a secondary
+ * bus reset of the bridge, but if the slot supports surprise removal we need
+ * to disable presence detection around the bus reset and clear any spurious
+ * events after.
+ */
+int pciehp_reset_slot(struct slot *slot, int probe)
+{
+	struct controller *ctrl = slot->ctrl;
+
+	if (probe)
+		return 0;
+
+	if (HP_SUPR_RM(ctrl)) {
+		pcie_write_cmd(ctrl, 0, PCI_EXP_SLTCTL_PDCE);
+		if (pciehp_poll_mode)
+			del_timer_sync(&ctrl->poll_timer);
+	}
+
+	pci_reset_bridge_secondary_bus(ctrl->pcie->port);
+
+	if (HP_SUPR_RM(ctrl)) {
+		pciehp_writew(ctrl, PCI_EXP_SLTSTA, PCI_EXP_SLTSTA_PDC);
+		pcie_write_cmd(ctrl, PCI_EXP_SLTCTL_PDCE, PCI_EXP_SLTCTL_PDCE);
+		if (pciehp_poll_mode)
+			int_poll_timeout(ctrl->poll_timer.data);
+	}
+
+	return 0;
+}
+
 int pcie_init_notification(struct controller *ctrl)
 {
 	if (pciehp_request_irq(ctrl))

