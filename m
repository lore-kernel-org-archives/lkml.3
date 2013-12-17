Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766Ab3LQUG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 15:06:29 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:58059 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab3LQUG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 15:06:26 -0500
Message-ID: <52B0AEAD.6050604@gmail.com>
Date: Tue, 17 Dec 2013 12:06:05 -0800
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
Subject: [PATCH v3 4/8] pciehp: Don't disable the link permanently, during
 removal
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need future link up events for hot-add, thus don't disable
the link permanently during device removal. Also, remove the static
functions that are now left unused.

Signed-off-by: Rajat Jain <rajatjain@juniper.net>
Signed-off-by: Guenter Roeck <groeck@juniper.net>
---
v3: no change, created by splitting the patch v2 [2/4]
v2: (non existent)
v1: (non existent)

 drivers/pci/hotplug/pciehp_hpc.c |   18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index b45b568..ab12555 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -278,11 +278,6 @@ static void pcie_wait_link_active(struct controller *ctrl)
 	__pcie_wait_link_active(ctrl, true);
 }
 
-static void pcie_wait_link_not_active(struct controller *ctrl)
-{
-	__pcie_wait_link_active(ctrl, false);
-}
-
 static bool pci_bus_check_dev(struct pci_bus *bus, int devfn)
 {
 	u32 l;
@@ -383,11 +378,6 @@ static int pciehp_link_enable(struct controller *ctrl)
 	return __pciehp_link_set(ctrl, true);
 }
 
-static int pciehp_link_disable(struct controller *ctrl)
-{
-	return __pciehp_link_set(ctrl, false);
-}
-
 int pciehp_get_attention_status(struct slot *slot, u8 *status)
 {
 	struct controller *ctrl = slot->ctrl;
@@ -620,14 +610,6 @@ int pciehp_power_off_slot(struct slot * slot)
 	u16 cmd_mask;
 	int retval;
 
-	/* Disable the link at first */
-	pciehp_link_disable(ctrl);
-	/* wait the link is down */
-	if (ctrl->link_active_reporting)
-		pcie_wait_link_not_active(ctrl);
-	else
-		msleep(1000);
-
 	slot_cmd = POWER_OFF;
 	cmd_mask = PCI_EXP_SLTCTL_PCC;
 	retval = pcie_write_cmd(ctrl, slot_cmd, cmd_mask);
-- 
1.7.9.5

