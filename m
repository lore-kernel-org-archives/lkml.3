Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758581Ab3DAJWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 05:22:40 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:5061 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758528Ab3DAJWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 05:22:39 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
CC: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Rafael <rjw@sisk.pl>, Hanjun Guo <guohanjun@huawei.com>,
        <jiang.liu@huawei.com>, Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 1/3] PCI,acpiphp: use generic pci_hp_add_bridge()
Date: Mon, 1 Apr 2013 17:22:06 +0800
Message-ID: <1364808128-12792-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use pci_hp_add_bridge() like most other hotplug drivers
rather than call pci_scan_bridge() directly.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |   24 ++++++++++--------------
 1 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 270fdba..7d7ed3f 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -811,7 +811,7 @@ static int __ref enable_device(struct acpiphp_slot *slot)
 	struct pci_bus *bus = slot->bridge->pci_bus;
 	struct acpiphp_func *func;
 	int retval = 0;
-	int num, max, pass;
+	int num;
 	acpi_status status;
 
 	if (slot->flags & SLOT_ENABLED)
@@ -827,22 +827,18 @@ static int __ref enable_device(struct acpiphp_slot *slot)
 		goto err_exit;
 	}
 
-	max = acpiphp_max_busnr(bus);
-	for (pass = 0; pass < 2; pass++) {
-		list_for_each_entry(dev, &bus->devices, bus_list) {
-			if (PCI_SLOT(dev->devfn) != slot->device)
+	list_for_each_entry(dev, &bus->devices, bus_list) {
+		if (PCI_SLOT(dev->devfn) != slot->device)
 				continue;
-			if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE ||
-			    dev->hdr_type == PCI_HEADER_TYPE_CARDBUS) {
-				max = pci_scan_bridge(bus, dev, max, pass);
-				if (pass && dev->subordinate) {
-					check_hotplug_bridge(slot, dev);
-					pci_bus_size_bridges(dev->subordinate);
-				}
-			}
+		if ((dev->hdr_type == PCI_HEADER_TYPE_BRIDGE) ||
+				(dev->hdr_type == PCI_HEADER_TYPE_CARDBUS))
+			pci_hp_add_bridge(dev);
+		if (dev->subordinate) {
+			check_hotplug_bridge(slot, dev);
+			pci_bus_size_bridges(dev->subordinate);
 		}
 	}
-
+
 	pci_bus_assign_resources(bus);
 	acpiphp_sanitize_bus(bus);
 	acpiphp_set_hpp_values(bus);
-- 
1.7.1


