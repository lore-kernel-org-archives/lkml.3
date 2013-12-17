Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab3LQUGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 15:06:55 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:54811 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab3LQUGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 15:06:53 -0500
Message-ID: <52B0AED9.6090402@gmail.com>
Date: Tue, 17 Dec 2013 12:06:49 -0800
From: Rajat Jain <rajatjain.linux@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
CC: Guenter Roeck <groeck@juniper.net>, Rajat Jain <rajatjain@juniper.net>,
        Rajat Jain <rajatxjain@gmail.com>
Subject: [PATCH v3 6/8] pciehp: Disabling the link notification across slot
 reset
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disable the link notification (in addition to presence detect
notifications) across the slot reset since it could potentialy flap
the link and we don't want to treat it as hot unplug followed by a
hotplug.

Signed-off-by: Rajat Jain <rajatjain@juniper.net>
Signed-off-by: Guenter Roeck <groeck@juniper.net>
---
v3: * created by splitting the patch v2 [2/4]
    * Add the ATTN BTN condition
v2: (non existent)
v1: (non existent)

 drivers/pci/hotplug/pciehp_hpc.c |   29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index ab12555..c2f3e37 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -746,31 +746,36 @@ static void pcie_disable_notification(struct controller *ctrl)
 
 /*
  * pciehp has a 1:1 bus:slot relationship so we ultimately want a secondary
- * bus reset of the bridge, but if the slot supports surprise removal we need
- * to disable presence detection around the bus reset and clear any spurious
+ * bus reset of the bridge, but if the slot supports surprise removal (or
+ * link state change based hotplug), we need to disable presence detection
+ * (or link state notifications) around the bus reset and clear any spurious
  * events after.
  */
 int pciehp_reset_slot(struct slot *slot, int probe)
 {
 	struct controller *ctrl = slot->ctrl;
+	u16 stat_mask = 0, ctrl_mask = 0;
 
 	if (probe)
 		return 0;
 
-	if (HP_SUPR_RM(ctrl)) {
-		pcie_write_cmd(ctrl, 0, PCI_EXP_SLTCTL_PDCE);
-		if (pciehp_poll_mode)
-			del_timer_sync(&ctrl->poll_timer);
+	if (HP_SUPR_RM(ctrl) && !ATTN_BUTTN(ctrl)) {
+		ctrl_mask |= PCI_EXP_SLTCTL_PDCE;
+		stat_mask |= PCI_EXP_SLTSTA_PDC;
 	}
+	ctrl_mask |= PCI_EXP_SLTCTL_DLLSCE;
+	stat_mask |= PCI_EXP_SLTSTA_DLLSC;
+
+	pcie_write_cmd(ctrl, 0, ctrl_mask);
+	if (pciehp_poll_mode)
+		del_timer_sync(&ctrl->poll_timer);
 
 	pci_reset_bridge_secondary_bus(ctrl->pcie->port);
 
-	if (HP_SUPR_RM(ctrl)) {
-		pciehp_writew(ctrl, PCI_EXP_SLTSTA, PCI_EXP_SLTSTA_PDC);
-		pcie_write_cmd(ctrl, PCI_EXP_SLTCTL_PDCE, PCI_EXP_SLTCTL_PDCE);
-		if (pciehp_poll_mode)
-			int_poll_timeout(ctrl->poll_timer.data);
-	}
+	pciehp_writew(ctrl, PCI_EXP_SLTSTA, stat_mask);
+	pcie_write_cmd(ctrl, ctrl_mask, ctrl_mask);
+	if (pciehp_poll_mode)
+		int_poll_timeout(ctrl->poll_timer.data);
 
 	return 0;
 }
-- 
1.7.9.5

