Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520Ab3GLJgx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 05:36:53 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:51667 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757416Ab3GLJgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 05:36:50 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: <linux-kernel@vger.kernel.org>, Don Dutile <ddutile@redhat.com>,
        Paul Bolle <pebolle@tiscali.nl>, <linux-pci@vger.kernel.org>,
        Rafael <rjw@sisk.pl>, Hanjun Guo <guohanjun@huawei.com>,
        <jiang.liu@huawei.com>, Yijing Wang <wangyijing@huawei.com>,
        Oliver Neukum <oneukum@suse.de>, Gu Zheng <guz.fnst@cn.fujitsu.com>
Subject: [PATCH -v3 3/3] PCI,pciehp: use PCIe DSN to identify device change during suspend
Date: Fri, 12 Jul 2013 17:32:23 +0800
Message-ID: <1373621543-54836-4-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
In-Reply-To: <1373621543-54836-1-git-send-email-wangyijing@huawei.com>
References: <1373621543-54836-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If device was removed from slot and reinsert a new device during
suspend, pciehp can not identify the physical device change now.
So the old driver .resume() method will be called for the new device,
this is bad. If device support device serial number capability,
we can identify this by DSN. So the reasonable way is first remove
the old device, then enable the new device.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: Paul Bolle <pebolle@tiscali.nl>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oliver Neukum <oneukum@suse.de>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: linux-pci@vger.kernel.org
---
 drivers/pci/hotplug/pciehp_core.c |   45 +++++++++++++++++++++++++++++++++++++
 1 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
index 7fe9dbd..bc47f8e 100644
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -296,11 +296,38 @@ static int pciehp_suspend (struct pcie_device *dev)
 	return 0;
 }
 
+/*
+ * check the func 0 device serial number is changed,
+ * if device does not support device serial number,
+ * return false.
+ */
+static bool device_serial_number_changed(struct pci_bus *pbus)
+{
+	u64 old_dsn, new_dsn;
+	struct pci_dev *pdev;
+
+	pdev = pci_get_slot(pbus, PCI_DEVFN(0, 0));
+	if (!pdev)
+		return false;
+
+	old_dsn = pdev->sn;
+
+	/* get func 0 device serial number */
+	new_dsn = pci_device_serial_number(pdev);
+	pci_dev_put(pdev);
+
+	if (old_dsn != new_dsn)
+		return true;
+
+	return false;
+}
+
 static int pciehp_resume (struct pcie_device *dev)
 {
 	struct controller *ctrl;
 	struct slot *slot;
 	struct pci_bus *pbus = dev->port->subordinate;
+	int retval = 0;
 	u8 status;
 
 	ctrl = get_service_data(dev);
@@ -315,6 +342,24 @@ static int pciehp_resume (struct pcie_device *dev)
 	if (status) {
 		if (list_empty(&pbus->devices))
 			pciehp_enable_slot(slot);
+
+		if (device_serial_number_changed(pbus)) {
+			/*
+			 * first power off slot, avoid the old driver
+			 * .remove() method touch the new hardware
+			 */
+			if (POWER_CTRL(ctrl)) {
+				retval = pciehp_power_off_slot(slot);
+				if (retval) {
+					ctrl_err(ctrl,
+						"Issue of Slot Disable command failed\n");
+					return 0;
+				}
+				msleep(1000);
+				pciehp_unconfigure_device(slot);
+				pciehp_enable_slot(slot);
+			}
+		}
 	} else if (!list_empty(&pbus->devices)) {
 		pciehp_disable_slot(slot);
 	}
-- 
1.7.1


