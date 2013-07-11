Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab3GKJpr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 05:45:47 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:1947 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755988Ab3GKJpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 05:45:43 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Rafael <rjw@sisk.pl>, Hanjun Guo <guohanjun@huawei.com>,
        <jiang.liu@huawei.com>, Yijing Wang <wangyijing@huawei.com>,
        Paul Bolle <pebolle@tiscali.nl>, Oliver Neukum <oneukum@suse.de>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>
Subject: [PATCH -v2 2/3] PCI,pciehp: avoid add a device already exist before suspend during resume
Date: Thu, 11 Jul 2013 17:43:44 +0800
Message-ID: <1373535825-49972-3-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
In-Reply-To: <1373535825-49972-1-git-send-email-wangyijing@huawei.com>
References: <1373535825-49972-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, pciehp_resume() try to hot add device if the slot adapter
status return true. But if there are already some devices exist,
namely list_empty(bus->devices) return false. We should not add the device
again, because the device add action will fail. Also print some uncomfortable
messages like this:
	pciehp 0000:00:1c.1:pcie04: Device 0000:03:00.0 already exists at 0000:03:00, cannot hot-add
	pciehp 0000:00:1c.1:pcie04: Cannot add device at 0000:03:00

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: Paul Bolle <pebolle@tiscali.nl>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oliver Neukum <oneukum@suse.de>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: linux-pci@vger.kernel.org
---
 drivers/pci/hotplug/pciehp_core.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
index 7d72c5e..1542735 100644
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -300,6 +300,7 @@ static int pciehp_resume (struct pcie_device *dev)
 {
 	struct controller *ctrl;
 	struct slot *slot;
+	struct pci_bus *pbus = dev->port->subordinate;
 	u8 status;
 
 	ctrl = get_service_data(dev);
@@ -311,10 +312,12 @@ static int pciehp_resume (struct pcie_device *dev)
 
 	/* Check if slot is occupied */
 	pciehp_get_adapter_status(slot, &status);
-	if (status)
-		pciehp_enable_slot(slot);
-	else
+	if (status) {
+		if (list_empty(&pbus->devices))
+			pciehp_enable_slot(slot);
+	} else if (!list_empty(&pbus->devices))
 		pciehp_disable_slot(slot);
+
 	return 0;
 }
 #endif /* PM */
-- 
1.7.1


