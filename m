Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab3GIH50 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 03:57:26 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:6980 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582Ab3GIH5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 03:57:23 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Rafael <rjw@sisk.pl>, Hanjun Guo <guohanjun@huawei.com>,
        <jiang.liu@huawei.com>, Yijing Wang <wangyijing@huawei.com>,
        Paul Bolle <pebolle@tiscali.nl>, Oliver Neukum <oneukum@suse.de>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>
Subject: [PATCH 2/2] PCI,pciehp: avoid add a device already exist during pciehp_resume
Date: Tue, 9 Jul 2013 15:56:04 +0800
Message-ID: <1373356564-21668-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, pciehp_resume will call pciehp_enable_slot() to add
device if there is a device in the slot. But if the device was
present before suspend, it's no necessary to add again. Now in
such case, there is some uncomfortable message like

    pciehp 0000:00:1c.1:pcie04: Device 0000:03:00.0 already exists at 0000:03:00, cannot hot-add
	pciehp 0000:00:1c.1:pcie04: Cannot add device at 0000:03:00

This problem was reported by Paul Bolle <pebolle@tiscali.nl>
The discussion link: http://comments.gmane.org/gmane.linux.kernel.pci/19876

We can use PCIe Device Serial Number to identify the device if
device support DSN.

currently:
1. slot is empty before suspend, insert card during suspend.
	In this case, is safe, pciehp will add device by check adapter
status register in pciehp_resume.

2. slot is non empty before suspend, remove card during suspend.
	Also be safe, pciehp will remove device by check adapter
status register in pciehp_resume.

3. slot is non empty before suspend, remove card during suspend
and insert a new card.
	Now pciehp just call pciehp_enable_slot() roughly. We should
remove the old card firstly, then add the new card.

4. slot is non empty before suspend, no action during suspend.
	We should do nothing in pciehp_resume, but we call
pciehp_enable_slot(), so some uncomfortable messages show like above.
In this case, we can improve it a little by add a guard
if (!list_empty(bus->devices)).

Reported-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: Paul Bolle <pebolle@tiscali.nl>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oliver Neukum <oneukum@suse.de>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: linux-pci@vger.kernel.org
---
 drivers/pci/hotplug/pciehp_core.c |   38 +++++++++++++++++++++++++++++++++---
 1 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
index 7d72c5e..d01e093 100644
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -291,6 +291,28 @@ static void pciehp_remove(struct pcie_device *dev)
 }
 
 #ifdef CONFIG_PM
+
+/* If device support Device Serial Numner, use DSN
+ * to identify the device
+ */
+static bool device_in_slot_is_changed(struct pci_bus *pbus)
+{
+	u64 old_dsn, new_dsn;
+	struct pci_dev *pdev;
+
+	pdev = pci_get_slot(pbus, PCI_DEVFN(0, 0));
+	old_dsn = pdev->sn;
+
+	/* get func 0 device serial number */
+	pci_get_dsn(pdev, &new_dsn);
+	pci_dev_put(pdev);
+
+	if (old_dsn != new_dsn)
+		return true;
+
+	return false;
+}
+
 static int pciehp_suspend (struct pcie_device *dev)
 {
 	return 0;
@@ -300,6 +322,7 @@ static int pciehp_resume (struct pcie_device *dev)
 {
 	struct controller *ctrl;
 	struct slot *slot;
+	struct pci_bus *pbus = dev->port->subordinate;
 	u8 status;
 
 	ctrl = get_service_data(dev);
@@ -311,10 +334,17 @@ static int pciehp_resume (struct pcie_device *dev)
 
 	/* Check if slot is occupied */
 	pciehp_get_adapter_status(slot, &status);
-	if (status)
-		pciehp_enable_slot(slot);
-	else
-		pciehp_disable_slot(slot);
+	if (status) {
+		if (list_empty(&pbus->devices))
+			pciehp_enable_slot(slot);
+		else if (device_in_slot_is_changed(pbus)) {
+			pciehp_disable_slot(slot);
+			pciehp_enable_slot(slot);
+		}
+	} else {
+		if (!list_empty(&pbus->devices))
+			pciehp_disable_slot(slot);
+	}
 	return 0;
 }
 #endif /* PM */
-- 
1.7.1


