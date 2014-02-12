Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbaBLCx0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 21:53:26 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:12635 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbaBLCxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 21:53:24 -0500
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH part1 v6 6/7] PCI: Check pci device serial number when scan device
Date: Wed, 12 Feb 2014 10:52:52 +0800
Message-ID: <1392173573-59844-7-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
In-Reply-To: <1392173573-59844-1-git-send-email-wangyijing@huawei.com>
References: <1392173573-59844-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes pci device will be removed and reinsert
while suspended. In this case system can not identify
the device has been changed. Now PCIe support Device
Serial Number Capability which has the unique number.
So make system check pci device DSN during scanning
device if support.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/pci/probe.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 27d3e6f..370b25c 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1383,11 +1383,22 @@ void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
 struct pci_dev *__ref pci_scan_single_device(struct pci_bus *bus, int devfn)
 {
 	struct pci_dev *dev;
+	int rescan = 0;
 
 	dev = pci_get_slot(bus, devfn);
 	if (dev) {
+		/* only check func 0 device */
+		if (PCI_FUNC(devfn) == 0) {
+			if (pci_serial_number_changed(dev)) {
+				pci_bus_freeze_device(bus);
+				pci_stop_and_remove_bus_device(dev);
+				pci_bus_unfreeze_device(bus);
+				rescan = 1;
+			}
+		}
 		pci_dev_put(dev);
-		return dev;
+		if (!rescan)
+			return dev;
 	}
 
 	dev = pci_scan_device(bus, devfn);
-- 
1.7.1


