Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423314Ab3FUQNR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 12:13:17 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:57710 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423275Ab3FUQNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 12:13:11 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Cc: liuj97@gmail.com, Jiang Liu <jiang.liu@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] PCI, xen-pcifront: use new PCI interfaces to simplify implementation
Date: Sat, 22 Jun 2013 00:12:47 +0800
Message-Id: <1371831169-17291-3-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371831169-17291-1-git-send-email-liuj97@gmail.com>
References: <1371831169-17291-1-git-send-email-liuj97@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Use new PCI interfaces to simplify xen-pcifront implementation:
1) Use pci_create_root_bus() instead of pci_scan_bus_parented()
   because pci_scan_bus_parented() is marked as __deprecated.This
   also gets rid of a duplicated call of pci_bus_start_devices().
2) Use pci_stop_and_remove_root_bus() instead of open-coded private
   implementation.
3) Use pci_set_host_bridge_release() to release data structures
   associated with PCI root buses.
4) Use pci_bus_get()/pci_bus_put() to manage PCI root bus reference
   count.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: xen-devel@lists.xensource.com
Cc: virtualization@lists.linux-foundation.org
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pci/xen-pcifront.c | 76 +++++++++++++++++++++-------------------------
 1 file changed, 34 insertions(+), 42 deletions(-)

diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
index 966abc6..a323287 100644
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
@@ -480,12 +490,13 @@ static int pcifront_scan_root(struct pcifront_device *pdev,
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
+	 * The pcifront_scan_bus enumerates all devfn, no matter function 0
+	 * exists or not.
+	 */
 	err = pcifront_scan_bus(pdev, domain, bus, b);
 
 	/* Claim resources before going "live" with our devices */
@@ -497,7 +508,6 @@ static int pcifront_scan_root(struct pcifront_device *pdev,
 	return err;
 
 err_out:
-	kfree(bus_entry);
 	kfree(sd);
 
 	return err;
@@ -538,35 +548,17 @@ static int pcifront_rescan_root(struct pcifront_device *pdev,
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
+	struct pci_bus *bus, *temp;
 
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
+	list_for_each_entry_safe(bus, temp, &pci_root_buses, node) {
+		sd = bus->sysdata;
+		if (sd->pdev == pdev)
+			pci_stop_and_remove_root_bus(bus);
 	}
 }
 
-- 
1.8.1.2

