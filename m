Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650Ab3ENQw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 12:52:29 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:62951 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757437Ab3ENQw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 12:52:26 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, Masanari Iida <standby24x7@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [RFC PATCH v2, part 2 03/18] PCI, hotplug: use hotplug-safe iterators to walk PCI buses
Date: Wed, 15 May 2013 00:51:47 +0800
Message-Id: <1368550322-1045-3-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1368550322-1045-1-git-send-email-jiang.liu@huawei.com>
References: <1368550322-1045-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance PCI hotplug drivers to use hotplug-safe iterators to walk
PCI buses.

In other words, replace pci_find_bus(), pci_find_next_bus() and
pci_root_buses with pci_bus_exists(), pci_get_bus(), pci_get_next_bus()
and pci_get_next_root_bus() etc.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Masanari Iida <standby24x7@gmail.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pci/hotplug-pci.c          | 2 +-
 drivers/pci/hotplug/ibmphp_core.c  | 8 +++++---
 drivers/pci/hotplug/ibmphp_ebda.c  | 8 ++++++--
 drivers/pci/hotplug/sgi_hotplug.c  | 3 ++-
 drivers/pci/hotplug/shpchp_sysfs.c | 2 +-
 5 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/hotplug-pci.c b/drivers/pci/hotplug-pci.c
index 6258dc2..18533ed 100644
--- a/drivers/pci/hotplug-pci.c
+++ b/drivers/pci/hotplug-pci.c
@@ -11,7 +11,7 @@ int __ref pci_hp_add_bridge(struct pci_dev *dev)
 	int end = parent->busn_res.end;
 
 	for (busnr = start; busnr <= end; busnr++) {
-		if (!pci_find_bus(pci_domain_nr(parent), busnr))
+		if (!pci_bus_exists(pci_domain_nr(parent), busnr))
 			break;
 	}
 	if (busnr-- > end) {
diff --git a/drivers/pci/hotplug/ibmphp_core.c b/drivers/pci/hotplug/ibmphp_core.c
index cbd72d8..fb47695 100644
--- a/drivers/pci/hotplug/ibmphp_core.c
+++ b/drivers/pci/hotplug/ibmphp_core.c
@@ -739,7 +739,7 @@ static u8 bus_structure_fixup(u8 busno)
 	struct pci_dev *dev;
 	u16 l;
 
-	if (pci_find_bus(0, busno) || !(ibmphp_find_same_bus_num(busno)))
+	if (pci_bus_exists(0, busno) || !(ibmphp_find_same_bus_num(busno)))
 		return 1;
 
 	bus = kmalloc(sizeof(*bus), GFP_KERNEL);
@@ -787,7 +787,7 @@ static int ibm_configure_device(struct pci_func *func)
 				PCI_DEVFN(func->device, func->function));
 
 	if (func->dev == NULL) {
-		struct pci_bus *bus = pci_find_bus(0, func->busno);
+		struct pci_bus *bus = pci_get_bus(0, func->busno);
 		if (!bus)
 			return 0;
 
@@ -795,6 +795,7 @@ static int ibm_configure_device(struct pci_func *func)
 				PCI_DEVFN(func->device, func->function));
 		if (num)
 			pci_bus_add_devices(bus);
+		pci_bus_put(bus);
 
 		func->dev = pci_get_bus_and_slot(func->busno,
 				PCI_DEVFN(func->device, func->function));
@@ -1315,13 +1316,14 @@ static int __init ibmphp_init(void)
 		goto exit;
 	}
 
-	bus = pci_find_bus(0, 0);
+	bus = pci_get_bus(0, 0);
 	if (!bus) {
 		err("Can't find the root pci bus, can not continue\n");
 		rc = -ENODEV;
 		goto error;
 	}
 	memcpy(ibmphp_pci_bus, bus, sizeof(*ibmphp_pci_bus));
+	pci_bus_put(bus);
 
 	ibmphp_debug = debug;
 
diff --git a/drivers/pci/hotplug/ibmphp_ebda.c b/drivers/pci/hotplug/ibmphp_ebda.c
index 9df78bc..e17f271 100644
--- a/drivers/pci/hotplug/ibmphp_ebda.c
+++ b/drivers/pci/hotplug/ibmphp_ebda.c
@@ -978,9 +978,13 @@ static int __init ebda_rsrc_controller (void)
 	}			/* each hpc  */
 
 	list_for_each_entry(tmp_slot, &ibmphp_slot_head, ibm_slot_list) {
+		struct pci_bus *bus = pci_get_bus(0, tmp_slot->bus);
+
+		BUG_ON(!bus);
 		snprintf(name, SLOT_NAME_SIZE, "%s", create_file_name(tmp_slot));
-		pci_hp_register(tmp_slot->hotplug_slot,
-			pci_find_bus(0, tmp_slot->bus), tmp_slot->device, name);
+		pci_hp_register(tmp_slot->hotplug_slot, bus, tmp_slot->device,
+				name);
+		pci_bus_put(bus);
 	}
 
 	print_ebda_hpc ();
diff --git a/drivers/pci/hotplug/sgi_hotplug.c b/drivers/pci/hotplug/sgi_hotplug.c
index b2781df..5c69bda 100644
--- a/drivers/pci/hotplug/sgi_hotplug.c
+++ b/drivers/pci/hotplug/sgi_hotplug.c
@@ -684,7 +684,7 @@ static int __init sn_pci_hotplug_init(void)
 
 	INIT_LIST_HEAD(&sn_hp_list);
 
-	while ((pci_bus = pci_find_next_bus(pci_bus))) {
+	for_each_pci_root_bus(pci_bus) {
 		if (!pci_bus->sysdata)
 			continue;
 
@@ -703,6 +703,7 @@ static int __init sn_pci_hotplug_init(void)
 			break;
 		}
 	}
+	pci_bus_put(pci_bus);
 
 	return registered == 1 ? 0 : -ENODEV;
 }
diff --git a/drivers/pci/hotplug/shpchp_sysfs.c b/drivers/pci/hotplug/shpchp_sysfs.c
index e8c31fe..e7a5dd2 100644
--- a/drivers/pci/hotplug/shpchp_sysfs.c
+++ b/drivers/pci/hotplug/shpchp_sysfs.c
@@ -74,7 +74,7 @@ static ssize_t show_ctrl (struct device *dev, struct device_attribute *attr, cha
 	}
 	out += sprintf(out, "Free resources: bus numbers\n");
 	for (busnr = bus->busn_res.start; busnr <= bus->busn_res.end; busnr++) {
-		if (!pci_find_bus(pci_domain_nr(bus), busnr))
+		if (!pci_bus_exists(pci_domain_nr(bus), busnr))
 			break;
 	}
 	if (busnr < bus->busn_res.end)
-- 
1.8.1.2

