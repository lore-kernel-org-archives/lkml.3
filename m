Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751058AbaFZS6m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 14:58:42 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:44717 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbaFZS6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 14:58:40 -0400
Message-ID: <53AC6D6F.5000308@gmail.com>
Date: Thu, 26 Jun 2014 11:58:55 -0700
From: Rajat Jain <rajatxjain@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: Guenter Roeck <groeck@juniper.net>, Rajat Jain <rajatjain@juniper.net>,
        rajatjain.linux@gmail.com
Subject: [PATCH] pciehp: Remove the field controller->no_cmd_completed
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After following recent cleanups by Bjorn:

http://git.kernel.org/cgit/linux/kernel/git/helgaas/pci.git/log/?h=pci/hotplug

2cc56f3 PCI: pciehp: Remove assumptions about which commands cause
40b9608 PCI: pciehp: Compute timeout from hotplug command start time
3461a06 PCI: pciehp: Wait for hotplug command completion lazily
4283c70 PCI: pciehp: Make pcie_wait_cmd() self-contained

the bitfield no_cmd_complete is not really needed anymore, as there is
only a single occurance of its use. Hence remove the unnecessary bit
field, and use existing macro NO_CMD_CMPL() instead.

Signed-off-by: Rajat Jain <rajatxjain@gmail.com>
Signed-off-by: Rajat Jain <rajatjain@juniper.net>
Signed-off-by: Guenter Roeck <groeck@juniper.net>
---
(This is rebased on top of Bjorn's pci/hotplug branch mentioned above)

 drivers/pci/hotplug/pciehp.h     |    1 -
 drivers/pci/hotplug/pciehp_hpc.c |   11 +----------
 2 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp.h b/drivers/pci/hotplug/pciehp.h
index c496258..9e5a9fb 100644
--- a/drivers/pci/hotplug/pciehp.h
+++ b/drivers/pci/hotplug/pciehp.h
@@ -96,7 +96,6 @@ struct controller {
 	struct timer_list poll_timer;
 	unsigned long cmd_started;	/* jiffies */
 	unsigned int cmd_busy:1;
-	unsigned int no_cmd_complete:1;
 	unsigned int link_active_reporting:1;
 	unsigned int notification_enabled:1;
 	unsigned int power_fault_detected;
diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index a3a5c65..f7c3709 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -140,7 +140,7 @@ static void pcie_wait_cmd(struct controller *ctrl)
 	 * If the controller does not generate notifications for command
 	 * completions, we never need to wait between writes.
 	 */
-	if (ctrl->no_cmd_complete)
+	if (NO_CMD_CMPL(ctrl))
 		return;
 
 	if (!ctrl->cmd_busy)
@@ -772,15 +772,6 @@ struct controller *pcie_init(struct pcie_device *dev)
 	init_waitqueue_head(&ctrl->queue);
 	dbg_ctrl(ctrl);
 
-	/*
-	 * Controller doesn't notify of command completion if the "No
-	 * Command Completed Support" bit is set in Slot Capabilities.
-	 * If set, it means the controller can accept hotplug commands
-	 * with no delay between them.
-	 */
-	if (NO_CMD_CMPL(ctrl))
-		ctrl->no_cmd_complete = 1;
-
 	/* Check if Data Link Layer Link Active Reporting is implemented */
 	pcie_capability_read_dword(pdev, PCI_EXP_LNKCAP, &link_cap);
 	if (link_cap & PCI_EXP_LNKCAP_DLLLARC) {
-- 
1.7.9.5

