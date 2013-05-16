Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab3EPPvz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 11:51:55 -0400
Received: from mail-da0-f54.google.com ([209.85.210.54]:33738 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769Ab3EPPvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 11:51:50 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Subject: [RFC PATCH v2, part3 08/11] PCI, xen-pcifront: use PCI bus lock to protect PCI device hotplug
Date: Thu, 16 May 2013 23:50:56 +0800
Message-Id: <1368719459-24800-9-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1368719459-24800-1-git-send-email-jiang.liu@huawei.com>
References: <1368719459-24800-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use PCI bus lock to protect concurrent PCI device hotplug operations.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: xen-devel@lists.xensource.com
Cc: virtualization@lists.linux-foundation.org
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pci/xen-pcifront.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
index 6aa2c0f..2b213b3 100644
--- a/drivers/pci/xen-pcifront.c
+++ b/drivers/pci/xen-pcifront.c
@@ -505,6 +505,7 @@ static int pcifront_scan_root(struct pcifront_device *pdev,
 
 	/* Create SysFS and notify udev of the devices. Aka: "going live" */
 	pci_bus_add_devices(b);
+	pci_bus_unlock(b, true);
 
 	return err;
 
@@ -538,6 +539,11 @@ static int pcifront_rescan_root(struct pcifront_device *pdev,
 		/* If the bus is unknown, create it. */
 		return pcifront_scan_root(pdev, domain, bus);
 
+	if (pci_bus_lock(b, PCI_BUS_STATE_STOPPING - 1, true) < 0) {
+		err = -EBUSY;
+		goto out;
+	}
+
 	err = pcifront_scan_bus(pdev, domain, bus, b);
 
 	/* Claim resources before going "live" with our devices */
@@ -545,6 +551,9 @@ static int pcifront_rescan_root(struct pcifront_device *pdev,
 
 	/* Create SysFS and notify udev of the devices. Aka: "going live" */
 	pci_bus_add_devices(b);
+	pci_bus_unlock(b, true);
+
+out:
 	pci_bus_put(b);
 
 	return err;
@@ -559,8 +568,11 @@ static void pcifront_free_roots(struct pcifront_device *pdev)
 
 	for_each_pci_root_bus(bus) {
 		sd = bus->sysdata;
-		if (sd->pdev == pdev) {
+		if (sd->pdev != pdev)
+			continue;
+		if (pci_bus_lock(bus, PCI_BUS_STATE_REMOVED - 1, true) == 0) {
 			pci_stop_root_bus(bus);
+			/* it also unlocks PCI buses */
 			pci_remove_root_bus(bus);
 		}
 	}
@@ -1042,7 +1054,7 @@ static int pcifront_detach_devices(struct pcifront_device *pdev)
 				domain, bus, slot, func);
 			continue;
 		}
-		pci_stop_and_remove_bus_device(pci_dev);
+		pci_stop_and_remove_device(pci_dev);
 		pci_dev_put(pci_dev);
 
 		dev_dbg(&pdev->xdev->dev,
-- 
1.8.1.2

