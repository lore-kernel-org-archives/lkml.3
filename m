Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759696Ab3BZPal (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 10:30:41 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:52247 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759664Ab3BZPah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 10:30:37 -0500
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J . Wysocki" <rjw@sisk.pl>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH v8 01/13] PCI: do not check is_added flag in pci_remove_bus()
Date: Tue, 26 Feb 2013 23:25:41 +0800
Message-Id: <1361892353-14786-2-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361892353-14786-1-git-send-email-jiang.liu@huawei.com>
References: <1361892353-14786-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The is_added flag in struct pci_bus is always set after invoking
device_register() and pci_create_legacy_files(). The related code
paths are:
1) pci_create_root_bus() and pci_add_new_bus()
	bus = pci_alloc_bus()
	device_register(&bus->dev)
	pci_create_legacy_file(bus)
2.a) pci_scan_child_bus(bus)
	set is_added flag for PCI root buses
2.b) pci_bus_add_devices(bus)
	set is_added flag for normal PCI buses

So pci_remove_bus() shouldn't use is_added flag to guard invoking of
pci_remove_lagecy_files() and device_unregister().

One more step further, now bus->is_added is only used to guard invoking
of pcibios_fixup_bus(), so cleaup the code.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pci/bus.c    |   11 ++---------
 drivers/pci/probe.c  |    3 +--
 drivers/pci/remove.c |    3 ---
 3 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 8647dc6..bdc1e8b 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -206,16 +206,9 @@ void pci_bus_add_devices(const struct pci_bus *bus)
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
 		BUG_ON(!dev->is_added);
-
 		child = dev->subordinate;
-
-		if (!child)
-			continue;
-		pci_bus_add_devices(child);
-
-		if (child->is_added)
-			continue;
-		child->is_added = 1;
+		if (child)
+			pci_bus_add_devices(child);
 	}
 }
 
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index b494066..45c93b3 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1627,8 +1627,7 @@ unsigned int pci_scan_child_bus(struct pci_bus *bus)
 	if (!bus->is_added) {
 		dev_dbg(&bus->dev, "fixups for bus\n");
 		pcibios_fixup_bus(bus);
-		if (pci_is_root_bus(bus))
-			bus->is_added = 1;
+		bus->is_added = 1;
 	}
 
 	for (pass=0; pass < 2; pass++)
diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index fc38c48..66967e5 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -48,9 +48,6 @@ void pci_remove_bus(struct pci_bus *bus)
 	list_del(&bus->node);
 	pci_bus_release_busn_res(bus);
 	up_write(&pci_bus_sem);
-	if (!bus->is_added)
-		return;
-
 	pci_remove_legacy_files(bus);
 	device_unregister(&bus->dev);
 }
-- 
1.7.9.5

