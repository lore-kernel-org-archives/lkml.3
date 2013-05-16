Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab3EPPvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 11:51:49 -0400
Received: from mail-da0-f42.google.com ([209.85.210.42]:60023 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769Ab3EPPvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 11:51:45 -0400
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
Subject: [RFC PATCH v2, part3 07/11] PCI, xen-pcifront: use new PCI interfaces to simplify implementation
Date: Thu, 16 May 2013 23:50:55 +0800
Message-Id: <1368719459-24800-8-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1368719459-24800-1-git-send-email-jiang.liu@huawei.com>
References: <1368719459-24800-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use new PCI interfaces to simplify xen-pcifront implementation:
1) Use pci_create_root_bus() instead of pci_scan_bus_parented()
   because pci_scan_bus_parented() is marked as __deprecated.This
   also gets rid of a duplicated call of pci_bus_start_devices().
2) Use pci_stop_root_bus() and pci_remove_root_bus() instead of
   open-coded private implementation.
3) Use pci_set_host_bridge_release() to release data structures
   associated with PCI root buses.
4) Use pci_bus_get()/pci_bus_put() to manage PCI root bus reference
   count.

This is also a preparation for coming PCI bus lock enhancement.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: xen-devel@lists.xensource.com
Cc: virtualization@lists.linux-foundation.org
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pci/xen-pcifront.c | 81 ++++++++++++++++++++++------------------------
 1 file changed, 39 insertions(+), 42 deletions(-)

diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
index 816cf94..6aa2c0f 100644
--- a/drivers/pci/xen-pcifront.c
+++ b/drivers/pci/xen-pcifront.c
@@ -25,11 +25,6 @@
 #define INVALID_GRANT_REF (0)
 #define INVALID_EVTCHN    (-1)
 
-struct pci_bus_entry {
-	struct list_head list;
-	struct pci_bus *bus;
-};
-
 #define _PDEVB_op_active		(0)
 #define PDEVB_op_active			(1 << (_PDEVB_op_active))
 
@@ -47,12 +42,12 @@ struct pcifront_device {
 	struct xen_pci_sharedinfo *sh_info;
 	struct work_struct op_work;
 	unsigned long flags;
-
 };
 
 struct pcifront_sd {
 	int domain;
 	struct pcifront_device *pdev;
+	struct resource busn_res;
 };
 
 static inline struct pcifront_device *
@@ -67,6 +62,12 @@ static inline void pcifront_init_sd(struct pcifront_sd *sd,
 {
 	sd->domain = domain;
 	sd->pdev = pdev;
+
+	/* Xen pci-backend doesn't export P2P bridges */
+	sd->busn_res.start = bus;
+	sd->busn_res.end = bus;
+	sd->busn_res.flags = IORESOURCE_BUS;
+	sd->busn_res.name = "PCI busn";
 }
 
 static DEFINE_SPINLOCK(pcifront_dev_lock);
@@ -441,12 +442,19 @@ static int pcifront_scan_bus(struct pcifront_device *pdev,
 	return 0;
 }
 
+static void pcifront_release_sd(struct pci_host_bridge *bridge)
+{
+	struct pcifront_sd *sd = bridge->release_data;
+
+	kfree(sd);
+}
+
 static int pcifront_scan_root(struct pcifront_device *pdev,
 				 unsigned int domain, unsigned int bus)
 {
 	struct pci_bus *b;
 	struct pcifront_sd *sd = NULL;
-	struct pci_bus_entry *bus_entry = NULL;
+	LIST_HEAD(resources);
 	int err = 0;
 
 #ifndef CONFIG_PCI_DOMAINS
@@ -463,16 +471,18 @@ static int pcifront_scan_root(struct pcifront_device *pdev,
 	dev_info(&pdev->xdev->dev, "Creating PCI Frontend Bus %04x:%02x\n",
 		 domain, bus);
 
-	bus_entry = kmalloc(sizeof(*bus_entry), GFP_KERNEL);
-	sd = kmalloc(sizeof(*sd), GFP_KERNEL);
-	if (!bus_entry || !sd) {
+	sd = kzalloc(sizeof(*sd), GFP_KERNEL);
+	if (!sd) {
 		err = -ENOMEM;
 		goto err_out;
 	}
 	pcifront_init_sd(sd, domain, bus, pdev);
 
-	b = pci_scan_bus_parented(&pdev->xdev->dev, bus,
-				  &pcifront_bus_ops, sd);
+	pci_add_resource(&resources, &ioport_resource);
+	pci_add_resource(&resources, &iomem_resource);
+	pci_add_resource(&resources, &sd->busn_res);
+	b = pci_create_root_bus(&pdev->xdev->dev, bus, &pcifront_bus_ops,
+				sd, &resources);
 	if (!b) {
 		dev_err(&pdev->xdev->dev,
 			"Error creating PCI Frontend Bus!\n");
@@ -480,12 +490,14 @@ static int pcifront_scan_root(struct pcifront_device *pdev,
 		goto err_out;
 	}
 
-	bus_entry->bus = b;
+	pci_set_host_bridge_release(to_pci_host_bridge(b->bridge),
+				    pcifront_release_sd, sd);
 
-	list_add(&bus_entry->list, &pdev->root_buses);
-
-	/* pci_scan_bus_parented skips devices which do not have a have
-	* devfn==0. The pcifront_scan_bus enumerates all devfn. */
+	/*
+	 * Every PCI physical device should have function 0, but that's not
+	 * true for xen.
+	 * So use pcifront_scan_bus() instead of pci_scan_child_bus().
+	 */
 	err = pcifront_scan_bus(pdev, domain, bus, b);
 
 	/* Claim resources before going "live" with our devices */
@@ -497,7 +509,6 @@ static int pcifront_scan_root(struct pcifront_device *pdev,
 	return err;
 
 err_out:
-	kfree(bus_entry);
 	kfree(sd);
 
 	return err;
@@ -539,35 +550,19 @@ static int pcifront_rescan_root(struct pcifront_device *pdev,
 	return err;
 }
 
-static void free_root_bus_devs(struct pci_bus *bus)
-{
-	struct pci_dev *dev;
-
-	while (!list_empty(&bus->devices)) {
-		dev = container_of(bus->devices.next, struct pci_dev,
-				   bus_list);
-		dev_dbg(&dev->dev, "removing device\n");
-		pci_stop_and_remove_bus_device(dev);
-	}
-}
-
 static void pcifront_free_roots(struct pcifront_device *pdev)
 {
-	struct pci_bus_entry *bus_entry, *t;
+	struct pcifront_sd *sd;
+	struct pci_bus *bus;
 
 	dev_dbg(&pdev->xdev->dev, "cleaning up root buses\n");
 
-	list_for_each_entry_safe(bus_entry, t, &pdev->root_buses, list) {
-		list_del(&bus_entry->list);
-
-		free_root_bus_devs(bus_entry->bus);
-
-		kfree(bus_entry->bus->sysdata);
-
-		device_unregister(bus_entry->bus->bridge);
-		pci_remove_bus(bus_entry->bus);
-
-		kfree(bus_entry);
+	for_each_pci_root_bus(bus) {
+		sd = bus->sysdata;
+		if (sd->pdev == pdev) {
+			pci_stop_root_bus(bus);
+			pci_remove_root_bus(bus);
+		}
 	}
 }
 
@@ -670,6 +665,7 @@ static irqreturn_t pcifront_handler_aer(int irq, void *dev)
 	schedule_pcifront_aer_op(pdev);
 	return IRQ_HANDLED;
 }
+
 static int pcifront_connect_and_init_dma(struct pcifront_device *pdev)
 {
 	int err = 0;
@@ -705,6 +701,7 @@ static void pcifront_disconnect(struct pcifront_device *pdev)
 
 	spin_unlock(&pcifront_dev_lock);
 }
+
 static struct pcifront_device *alloc_pdev(struct xenbus_device *xdev)
 {
 	struct pcifront_device *pdev;
-- 
1.8.1.2

