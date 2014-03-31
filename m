Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777AbaCaXv6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 19:51:58 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:42365 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbaCaXvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 19:51:55 -0400
Message-ID: <5339FF99.2050200@gmail.com>
Date: Mon, 31 Mar 2014 16:51:53 -0700
From: Rajat Jain <rajatxjain@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: Rajat Jain <rajatjain@juniper.net>, Guenter Roeck <groeck@juniper.net>
Subject: [PATCH] pci/pciehp: Allow polling/irq mode to be decided on a per-port
 basis
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today, there is a global pciehp_poll_mode module parameter using which
either _all_ the hot-pluggable ports are to use polling, or _all_ the
ports are to use interrupts.

In a system where a certain port has IRQ issues, today the only option
is to use the parameter that converts ALL the ports to use polling mode.
This is not good, and hence this patch intruduces a bit field that can
be set using a PCI quirk that indicates that polling should always be
used for this particular PCIe port. The remaining ports can still
hoose to continue to operate in whatever mode they wish to.

Signed-off-by: Rajat Jain <rajatxjain@gmail.com>
Signed-off-by: Rajat Jain <rajatjain@juniper.net>
Signed-off-by: Guenter Roeck <groeck@juniper.net>
---
 drivers/pci/hotplug/pciehp.h     |    1 +
 drivers/pci/hotplug/pciehp_hpc.c |   16 ++++++++++------
 include/linux/pci.h              |    1 +
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp.h b/drivers/pci/hotplug/pciehp.h
index d208791..753a3b4 100644
--- a/drivers/pci/hotplug/pciehp.h
+++ b/drivers/pci/hotplug/pciehp.h
@@ -98,6 +98,7 @@ struct controller {
 	unsigned int no_cmd_complete:1;
 	unsigned int link_active_reporting:1;
 	unsigned int notification_enabled:1;
+	unsigned int use_polling:1;	/* Always uses polling for this slot */
 	unsigned int power_fault_detected;
 };
 
diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index d7d058f..d210d23 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -82,7 +82,7 @@ static inline int pciehp_request_irq(struct controller *ctrl)
 	int retval, irq = ctrl->pcie->irq;
 
 	/* Install interrupt polling timer. Start with 10 sec delay */
-	if (pciehp_poll_mode) {
+	if (ctrl->use_polling) {
 		init_timer(&ctrl->poll_timer);
 		start_int_poll_timer(ctrl, 10);
 		return 0;
@@ -98,7 +98,7 @@ static inline int pciehp_request_irq(struct controller *ctrl)
 
 static inline void pciehp_free_irq(struct controller *ctrl)
 {
-	if (pciehp_poll_mode)
+	if (ctrl->use_polling)
 		del_timer_sync(&ctrl->poll_timer);
 	else
 		free_irq(ctrl->pcie->irq, ctrl);
@@ -131,7 +131,7 @@ static int pcie_poll_cmd(struct controller *ctrl)
 
 static void pcie_wait_cmd(struct controller *ctrl, int poll)
 {
-	unsigned int msecs = pciehp_poll_mode ? 2500 : 1000;
+	unsigned int msecs = ctrl->use_polling ? 2500 : 1000;
 	unsigned long timeout = msecs_to_jiffies(msecs);
 	int rc;
 
@@ -595,7 +595,7 @@ void pcie_enable_notification(struct controller *ctrl)
 		cmd |= PCI_EXP_SLTCTL_PDCE;
 	if (MRL_SENS(ctrl))
 		cmd |= PCI_EXP_SLTCTL_MRLSCE;
-	if (!pciehp_poll_mode)
+	if (!ctrl->use_polling)
 		cmd |= PCI_EXP_SLTCTL_HPIE | PCI_EXP_SLTCTL_CCIE;
 
 	mask = (PCI_EXP_SLTCTL_PDCE | PCI_EXP_SLTCTL_ABPE |
@@ -642,14 +642,14 @@ int pciehp_reset_slot(struct slot *slot, int probe)
 	stat_mask |= PCI_EXP_SLTSTA_DLLSC;
 
 	pcie_write_cmd(ctrl, 0, ctrl_mask);
-	if (pciehp_poll_mode)
+	if (ctrl->use_polling)
 		del_timer_sync(&ctrl->poll_timer);
 
 	pci_reset_bridge_secondary_bus(ctrl->pcie->port);
 
 	pcie_capability_write_word(pdev, PCI_EXP_SLTSTA, stat_mask);
 	pcie_write_cmd(ctrl, ctrl_mask, ctrl_mask);
-	if (pciehp_poll_mode)
+	if (ctrl->use_polling)
 		int_poll_timeout(ctrl->poll_timer.data);
 
 	return 0;
@@ -789,6 +789,10 @@ struct controller *pcie_init(struct pcie_device *dev)
                 ctrl_dbg(ctrl, "Link Active Reporting supported\n");
                 ctrl->link_active_reporting = 1;
         }
+	if (pciehp_poll_mode || dev->port->hotplug_polling) {
+		ctrl_info(ctrl, "will use polling\n");
+		ctrl->use_polling = 1;
+	}
 
 	/* Clear all remaining event bits in Slot Status register */
 	pcie_capability_write_word(pdev, PCI_EXP_SLTSTA,
diff --git a/include/linux/pci.h b/include/linux/pci.h
index a13d682..b2ec72e 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -336,6 +336,7 @@ struct pci_dev {
 	unsigned int	is_virtfn:1;
 	unsigned int	reset_fn:1;
 	unsigned int    is_hotplug_bridge:1;
+	unsigned int    hotplug_polling:1; /* Port uses polling for hotplug */
 	unsigned int    __aer_firmware_first_valid:1;
 	unsigned int	__aer_firmware_first:1;
 	unsigned int	broken_intx_masking:1;
-- 
1.7.9.5

