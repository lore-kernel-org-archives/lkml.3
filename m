Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab3EZP5f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 11:57:35 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:46236 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076Ab3EZP5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 11:57:17 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v3, part2 02/20] PCI, core: use hotplug-safe iterators to walk PCI buses
Date: Sun, 26 May 2013 23:52:59 +0800
Message-Id: <1369583597-3801-3-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369583597-3801-1-git-send-email-jiang.liu@huawei.com>
References: <1369583597-3801-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance PCI core to use hotplug-safe iterators to walk PCI buses.

In other words, replace pci_find_bus(), pci_find_next_bus() and
pci_root_buses with pci_bus_exists(), pci_get_bus(), pci_get_next_bus()
and pci_get_next_root_bus() etc.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Cc: virtualization@lists.linux-foundation.org
---
 drivers/pci/pci-sysfs.c    |  2 +-
 drivers/pci/pcie/pme.c     |  5 +++--
 drivers/pci/probe.c        | 15 +++++++++------
 drivers/pci/setup-bus.c    | 14 ++++++--------
 drivers/pci/xen-pcifront.c |  3 ++-
 5 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 403da60..e2da5f3 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -296,7 +296,7 @@ static ssize_t bus_rescan_store(struct bus_type *bus, const char *buf,
 
 	if (val) {
 		mutex_lock(&pci_remove_rescan_mutex);
-		while ((b = pci_find_next_bus(b)) != NULL)
+		for_each_pci_root_bus(b)
 			pci_rescan_bus(b);
 		mutex_unlock(&pci_remove_rescan_mutex);
 	}
diff --git a/drivers/pci/pcie/pme.c b/drivers/pci/pcie/pme.c
index 795db1f..1ed38a3 100644
--- a/drivers/pci/pcie/pme.c
+++ b/drivers/pci/pcie/pme.c
@@ -132,7 +132,7 @@ static bool pcie_pme_from_pci_bridge(struct pci_bus *bus, u8 devfn)
 static void pcie_pme_handle_request(struct pci_dev *port, u16 req_id)
 {
 	u8 busnr = req_id >> 8, devfn = req_id & 0xff;
-	struct pci_bus *bus;
+	struct pci_bus *bus = NULL;
 	struct pci_dev *dev;
 	bool found = false;
 
@@ -161,7 +161,7 @@ static void pcie_pme_handle_request(struct pci_dev *port, u16 req_id)
 	}
 
 	/* Second, find the bus the source device is on. */
-	bus = pci_find_bus(pci_domain_nr(port->bus), busnr);
+	bus = pci_get_bus(pci_domain_nr(port->bus), busnr);
 	if (!bus)
 		goto out;
 
@@ -206,6 +206,7 @@ static void pcie_pme_handle_request(struct pci_dev *port, u16 req_id)
 	}
 
  out:
+	pci_bus_put(bus);
 	if (!found)
 		dev_dbg(&port->dev, "Spurious native PME interrupt!\n");
 }
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 1004a05..7c34362 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -752,7 +752,7 @@ static void pci_fixup_parent_subordinate_busnr(struct pci_bus *child, int max)
  */
 int pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max, int pass)
 {
-	struct pci_bus *child;
+	struct pci_bus *child = NULL;
 	int is_cardbus = (dev->hdr_type == PCI_HEADER_TYPE_CARDBUS);
 	u32 buses, i, j = 0;
 	u16 bctl;
@@ -804,7 +804,7 @@ int pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max, int pass)
 		 * However, we continue to descend down the hierarchy and
 		 * scan remaining child buses.
 		 */
-		child = pci_find_bus(pci_domain_nr(bus), secondary);
+		child = pci_get_bus(pci_domain_nr(bus), secondary);
 		if (!child) {
 			child = pci_add_new_bus(bus, dev, secondary);
 			if (!child)
@@ -812,6 +812,7 @@ int pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max, int pass)
 			child->primary = primary;
 			pci_bus_insert_busn_res(child, secondary, subordinate);
 			child->bridge_ctl = bctl;
+			pci_bus_get(child);
 		}
 
 		cmax = pci_scan_child_bus(child);
@@ -843,12 +844,13 @@ int pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max, int pass)
 		/* Prevent assigning a bus number that already exists.
 		 * This can happen when a bridge is hot-plugged, so in
 		 * this case we only re-scan this bus. */
-		child = pci_find_bus(pci_domain_nr(bus), max+1);
+		child = pci_get_bus(pci_domain_nr(bus), max+1);
 		if (!child) {
 			child = pci_add_new_bus(bus, dev, ++max);
 			if (!child)
 				goto out;
 			pci_bus_insert_busn_res(child, max, 0xff);
+			pci_bus_get(child);
 		}
 		buses = (buses & 0xff000000)
 		      | ((unsigned int)(child->primary)     <<  0)
@@ -893,8 +895,7 @@ int pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max, int pass)
 			 */
 			for (i=0; i<CARDBUS_RESERVE_BUSNR; i++) {
 				struct pci_bus *parent = bus;
-				if (pci_find_bus(pci_domain_nr(bus),
-							max+i+1))
+				if (pci_bus_exists(pci_domain_nr(bus), max+i+1))
 					break;
 				while (parent->parent) {
 					if ((!pcibios_assign_all_busses()) &&
@@ -949,6 +950,7 @@ int pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max, int pass)
 
 out:
 	pci_write_config_word(dev, PCI_BRIDGE_CONTROL, bctl);
+	pci_bus_put(child);
 
 	return max;
 }
@@ -1710,10 +1712,11 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 	if (!b)
 		return NULL;
 
-	b2 = pci_find_bus(pci_domain_nr(b), bus);
+	b2 = pci_get_bus(pci_domain_nr(b), bus);
 	if (b2) {
 		/* If we already got to this bus through a different bridge, ignore it */
 		dev_dbg(&b2->dev, "bus already known\n");
+		pci_bus_put(b2);
 		goto err_out;
 	}
 
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 16abaaa..9a3e3f7 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -1317,12 +1317,10 @@ static int __init pci_bus_get_depth(struct pci_bus *bus)
 }
 static int __init pci_get_max_depth(void)
 {
-	int depth = 0;
+	int ret, depth = 0;
 	struct pci_bus *bus;
 
-	list_for_each_entry(bus, &pci_root_buses, node) {
-		int ret;
-
+	for_each_pci_root_bus(bus) {
 		ret = pci_bus_get_depth(bus);
 		if (ret > depth)
 			depth = ret;
@@ -1423,11 +1421,11 @@ again:
 		add_list = &realloc_head;
 	/* Depth first, calculate sizes and alignments of all
 	   subordinate buses. */
-	list_for_each_entry(bus, &pci_root_buses, node)
+	for_each_pci_root_bus(bus)
 		__pci_bus_size_bridges(bus, add_list);
 
 	/* Depth last, allocate resources and update the hardware. */
-	list_for_each_entry(bus, &pci_root_buses, node)
+	for_each_pci_root_bus(bus)
 		__pci_bus_assign_resources(bus, add_list, &fail_head);
 	if (add_list)
 		BUG_ON(!list_empty(add_list));
@@ -1480,11 +1478,11 @@ again:
 
 enable_and_dump:
 	/* Depth last, update the hardware. */
-	list_for_each_entry(bus, &pci_root_buses, node)
+	for_each_pci_root_bus(bus)
 		pci_enable_bridges(bus);
 
 	/* dump the resource on buses */
-	list_for_each_entry(bus, &pci_root_buses, node)
+	for_each_pci_root_bus(bus)
 		pci_bus_dump_resources(bus);
 }
 
diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
index 966abc6..816cf94 100644
--- a/drivers/pci/xen-pcifront.c
+++ b/drivers/pci/xen-pcifront.c
@@ -522,7 +522,7 @@ static int pcifront_rescan_root(struct pcifront_device *pdev,
 	dev_info(&pdev->xdev->dev, "Rescanning PCI Frontend Bus %04x:%02x\n",
 		 domain, bus);
 
-	b = pci_find_bus(domain, bus);
+	b = pci_get_bus(domain, bus);
 	if (!b)
 		/* If the bus is unknown, create it. */
 		return pcifront_scan_root(pdev, domain, bus);
@@ -534,6 +534,7 @@ static int pcifront_rescan_root(struct pcifront_device *pdev,
 
 	/* Create SysFS and notify udev of the devices. Aka: "going live" */
 	pci_bus_add_devices(b);
+	pci_bus_put(b);
 
 	return err;
 }
-- 
1.8.1.2

