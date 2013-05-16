Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab3EPPvi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 11:51:38 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:51082 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704Ab3EPPvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 11:51:35 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2, part3 05/11] PCI: enhance PCI core logic to support PCI bus lock
Date: Thu, 16 May 2013 23:50:53 +0800
Message-Id: <1368719459-24800-6-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1368719459-24800-1-git-send-email-jiang.liu@huawei.com>
References: <1368719459-24800-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every new PCI bus will be created with the PCI_BUS_STATE_LOCK bit set,
so a typical PCI device hot-add flow is:
	pci_bus_lock(parent, PCI_BUS_STATE_STARTED, true);
	pci_scan_slot(parent, PCI_DEVFN(0, 0));
	pci_bus_add_devices(parent);
	pci_bus_unlock(parent, true);	// recursively unlock all PCI
					// buses, including new PCI buses

This patch also changes behaviors of interfaces to create PCI root buses:
	pci_create_root_bus(): return with new PCI root bus locked
	pci_scan_bus_parented(): return with new PCI root bus locked
	pci_scan_root_bus(): return with new PCI root bus unlocked
	pci_scan_bus(): return with new PCI root bus unlocked

pci_scan_bus_parented() has already been marked as __deprecated and
all in-tree callers have been converted to use other interfaces.
So following-on patches will enhance callers of pci_create_root_bus()
to unlock returned root buses.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pci/hotplug-pci.c |  4 ++++
 drivers/pci/probe.c       | 18 ++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/drivers/pci/hotplug-pci.c b/drivers/pci/hotplug-pci.c
index 18533ed..8faa3c2 100644
--- a/drivers/pci/hotplug-pci.c
+++ b/drivers/pci/hotplug-pci.c
@@ -10,6 +10,10 @@ int __ref pci_hp_add_bridge(struct pci_dev *dev)
 	int pass, busnr, start = parent->busn_res.start;
 	int end = parent->busn_res.end;
 
+	BUG_ON(!pci_bus_is_locked(parent));
+	if (pci_bus_get_state(parent) > PCI_BUS_STATE_STARTED)
+		return 0;
+
 	for (busnr = start; busnr <= end; busnr++) {
 		if (!pci_bus_exists(pci_domain_nr(parent), busnr))
 			break;
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 9fcf3a3..0ddf5b8 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -745,6 +745,10 @@ int pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max, int pass)
 	u8 primary, secondary, subordinate;
 	int broken = 0;
 
+	BUG_ON(!pci_bus_is_locked(bus));
+	if (pci_bus_get_state(bus) > PCI_BUS_STATE_STARTED)
+		return max;
+
 	pci_read_config_dword(dev, PCI_PRIMARY_BUS, &buses);
 	primary = buses & 0xFF;
 	secondary = (buses >> 8) & 0xFF;
@@ -799,6 +803,8 @@ int pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max, int pass)
 			pci_bus_insert_busn_res(child, secondary, subordinate);
 			child->bridge_ctl = bctl;
 			pci_bus_get(child);
+		} else {
+			BUG_ON(!pci_bus_is_locked(child));
 		}
 
 		cmax = pci_scan_child_bus(child);
@@ -837,6 +843,8 @@ int pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max, int pass)
 				goto out;
 			pci_bus_insert_busn_res(child, max, 0xff);
 			pci_bus_get(child);
+		} else {
+			BUG_ON(!pci_bus_is_locked(child));
 		}
 		buses = (buses & 0xff000000)
 		      | ((unsigned int)(child->primary)     <<  0)
@@ -1322,6 +1330,7 @@ void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
 {
 	int ret;
 
+	BUG_ON(!pci_bus_is_locked(bus));
 	device_initialize(&dev->dev);
 	dev->dev.release = pci_release_dev;
 
@@ -1369,6 +1378,10 @@ struct pci_dev *__ref pci_scan_single_device(struct pci_bus *bus, int devfn)
 {
 	struct pci_dev *dev;
 
+	BUG_ON(!pci_bus_is_locked(bus));
+	if (pci_bus_get_state(bus) > PCI_BUS_STATE_STARTED)
+		return NULL;
+
 	dev = pci_get_slot(bus, devfn);
 	if (dev) {
 		pci_dev_put(dev);
@@ -1624,6 +1637,8 @@ unsigned int pci_scan_child_bus(struct pci_bus *bus)
 	unsigned int devfn, pass, max = bus->busn_res.start;
 	struct pci_dev *dev;
 
+	BUG_ON(!pci_bus_is_locked(bus));
+	BUG_ON(pci_bus_get_state(bus) > PCI_BUS_STATE_STARTED);
 	dev_dbg(&bus->dev, "scanning bus\n");
 
 	/* Go find them, Rover! */
@@ -1872,6 +1887,8 @@ struct pci_bus *pci_scan_root_bus(struct device *parent, int bus,
 		pci_bus_update_busn_res_end(b, max);
 
 	pci_bus_add_devices(b);
+	pci_bus_unlock(b, true);
+
 	return b;
 }
 EXPORT_SYMBOL(pci_scan_root_bus);
@@ -1908,6 +1925,7 @@ struct pci_bus *pci_scan_bus(int bus, struct pci_ops *ops,
 	if (b) {
 		pci_scan_child_bus(b);
 		pci_bus_add_devices(b);
+		pci_bus_unlock(b, true);
 	} else {
 		pci_free_resource_list(&resources);
 	}
-- 
1.8.1.2

