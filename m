Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab3AUVWD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:22:03 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:38652 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab3AUVV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:21:59 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <lenb@kernel.org>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v10 11/11] PCI: Put pci dev to device tree as early as possible
Date: Mon, 21 Jan 2013 13:20:52 -0800
Message-Id: <1358803252-20639-12-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358803252-20639-1-git-send-email-yinghai@kernel.org>
References: <1358803252-20639-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to put created pci device in the device tree as soon as possible.
- just after we find it and create pci_dev struct for it.
so for_pci_dev iteration will not miss them.

But at that time, we can not load driver for them yet. Need to be after
pci_assign_unsigned_resources() etc to make sure all pci devices get
resource allocated at first.

Move out device registering out of pci_bus_add_devices, and
new pci_bus_add_devices() will do the device_attach work to load pci drivers

Also remove unattached child bus handling in pci_bus_add_devices().
Because that is not needed, child bus via pci_add_new_bus() is already
in parent bus children list.

-v2: replace pci_bus_add_child() with ->is_added directly according to
	Rafael.
     Move pci_create_sysfs_dev_files() back in pci_bus_add_dev(), as we
       need to wait assign unassigned resources done to create resource
       files in /sys.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/bus.c   |   79 ++++++++-------------------------------------------
 drivers/pci/iov.c   |    9 +-----
 drivers/pci/pci.h   |    1 -
 drivers/pci/probe.c |   33 ++++++++++++++++-----
 4 files changed, 39 insertions(+), 83 deletions(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 18c1c6d..5665c9a 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -170,69 +170,30 @@ static void pci_bus_attach_device(struct pci_dev *dev)
 }
 
 /**
- * pci_bus_add_device - add a single device
+ * pci_bus_add_device - start driver for a single device
  * @dev: device to add
  *
- * This adds a single pci device to the global
- * device list and adds sysfs and procfs entries
+ * This adds add sysfs entries and start device drivers
  */
 int pci_bus_add_device(struct pci_dev *dev)
 {
-	int retval;
-
-	pci_fixup_device(pci_fixup_final, dev);
-
-	retval = pcibios_add_device(dev);
-	if (retval)
-		return retval;
-
-	retval = device_add(&dev->dev);
-	if (retval)
-		return retval;
+	/*
+	 * Can not put in pci_device_add yet because pci resources
+	 * are not assigned yet for some pci devices.
+	 */
+	pci_create_sysfs_dev_files(dev);
 
 	pci_bus_attach_device(dev);
 	dev->is_added = 1;
-	pci_proc_attach_device(dev);
-	pci_create_sysfs_dev_files(dev);
-	return 0;
-}
-
-/**
- * pci_bus_add_child - add a child bus
- * @bus: bus to add
- *
- * This adds sysfs entries for a single bus
- */
-int pci_bus_add_child(struct pci_bus *bus)
-{
-	int retval;
-
-	if (bus->bridge)
-		bus->dev.parent = bus->bridge;
-
-	retval = device_register(&bus->dev);
-	if (retval)
-		return retval;
-
-	bus->is_added = 1;
-
-	/* Create legacy_io and legacy_mem files for this bus */
-	pci_create_legacy_files(bus);
 
-	return retval;
+	return 0;
 }
 
 /**
- * pci_bus_add_devices - insert newly discovered PCI devices
+ * pci_bus_add_devices - start driver for PCI devices
  * @bus: bus to check for new devices
  *
- * Add newly discovered PCI devices (which are on the bus->devices
- * list) to the global PCI device list, add the sysfs and procfs
- * entries.  Where a bridge is found, add the discovered bus to
- * the parents list of child buses, and recurse (breadth-first
- * to be compatible with 2.4)
- *
- * Call hotplug for each new devices.
+ * Start driver for PCI devices and add some sysfs entries.
  */
 void pci_bus_add_devices(const struct pci_bus *bus)
 {
@@ -245,36 +206,20 @@ void pci_bus_add_devices(const struct pci_bus *bus)
 		if (dev->is_added)
 			continue;
 		retval = pci_bus_add_device(dev);
-		if (retval)
-			dev_err(&dev->dev, "Error adding device, continuing\n");
 	}
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
 		BUG_ON(!dev->is_added);
 
 		child = dev->subordinate;
-		/*
-		 * If there is an unattached subordinate bus, attach
-		 * it and then scan for unattached PCI devices.
-		 */
+
 		if (!child)
 			continue;
-		if (list_empty(&child->node)) {
-			down_write(&pci_bus_sem);
-			list_add_tail(&child->node, &dev->bus->children);
-			up_write(&pci_bus_sem);
-		}
 		pci_bus_add_devices(child);
 
-		/*
-		 * register the bus with sysfs as the parent is now
-		 * properly registered.
-		 */
 		if (child->is_added)
 			continue;
-		retval = pci_bus_add_child(child);
-		if (retval)
-			dev_err(&dev->dev, "Error adding bus, continuing\n");
+		child->is_added = 1;
 	}
 }
 
diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index bafd2bb..f8720af 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -48,12 +48,7 @@ static struct pci_bus *virtfn_add_bus(struct pci_bus *bus, int busnr)
 		return NULL;
 
 	pci_bus_insert_busn_res(child, busnr, busnr);
-	child->dev.parent = bus->bridge;
-	rc = pci_bus_add_child(child);
-	if (rc) {
-		pci_remove_bus(child);
-		return NULL;
-	}
+	bus->is_added = 1;
 
 	return child;
 }
@@ -123,8 +118,6 @@ static int virtfn_add(struct pci_dev *dev, int id, int reset)
 	virtfn->is_virtfn = 1;
 
 	rc = pci_bus_add_device(virtfn);
-	if (rc)
-		goto failed1;
 	sprintf(buf, "virtfn%u", id);
 	rc = sysfs_create_link(&dev->dev.kobj, &virtfn->dev.kobj, buf);
 	if (rc)
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index adfd172..d295e7b 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -203,7 +203,6 @@ extern int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 				struct resource *res, unsigned int reg);
 extern int pci_resource_bar(struct pci_dev *dev, int resno,
 			    enum pci_bar_type *type);
-extern int pci_bus_add_child(struct pci_bus *bus);
 extern void pci_enable_ari(struct pci_dev *dev);
 /**
  * pci_ari_enabled - query ARI forwarding status
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 9588207..30cf9e3 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -623,6 +623,7 @@ static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
 {
 	struct pci_bus *child;
 	int i;
+	int ret;
 
 	/*
 	 * Allocate a new bus, and inherit stuff from the parent..
@@ -637,8 +638,7 @@ static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
 	child->bus_flags = parent->bus_flags;
 
 	/* initialize some portions of the bus device, but don't register it
-	 * now as the parent is not properly set up yet.  This device will get
-	 * registered later in pci_bus_add_devices()
+	 * now as the parent is not properly set up yet.
 	 */
 	child->dev.class = &pcibus_class;
 	dev_set_name(&child->dev, "%04x:%02x", pci_domain_nr(child), busnr);
@@ -651,11 +651,14 @@ static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
 	child->primary = parent->busn_res.start;
 	child->busn_res.end = 0xff;
 
-	if (!bridge)
-		return child;
+	if (!bridge) {
+		child->dev.parent = parent->bridge;
+		goto add_dev;
+	}
 
 	child->self = bridge;
 	child->bridge = get_device(&bridge->dev);
+	child->dev.parent = child->bridge;
 	pci_set_bus_of_node(child);
 	pci_set_bus_speed(child);
 
@@ -666,6 +669,13 @@ static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
 	}
 	bridge->subordinate = child;
 
+add_dev:
+	ret = device_register(&child->dev);
+	WARN_ON(ret < 0);
+
+	/* Create legacy_io and legacy_mem files for this bus */
+	pci_create_legacy_files(child);
+
 	return child;
 }
 
@@ -1296,6 +1306,8 @@ static void pci_init_capabilities(struct pci_dev *dev)
 
 void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
 {
+	int ret;
+
 	device_initialize(&dev->dev);
 	dev->dev.release = pci_release_dev;
 
@@ -1326,6 +1338,15 @@ void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
 	down_write(&pci_bus_sem);
 	list_add_tail(&dev->bus_list, &bus->devices);
 	up_write(&pci_bus_sem);
+
+	pci_fixup_device(pci_fixup_final, dev);
+	ret = pcibios_add_device(dev);
+	WARN_ON(ret < 0);
+	/* notifier could use pci capabilities */
+	ret = device_add(&dev->dev);
+	WARN_ON(ret < 0);
+
+	pci_proc_attach_device(dev);
 }
 
 struct pci_dev *__ref pci_scan_single_device(struct pci_bus *bus, int devfn)
@@ -1656,13 +1677,13 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 	char bus_addr[64];
 	char *fmt;
 
-
 	b = pci_alloc_bus();
 	if (!b)
 		return NULL;
 
 	b->sysdata = sysdata;
 	b->ops = ops;
+	b->number = b->busn_res.start = bus;
 	b2 = pci_find_bus(pci_domain_nr(b), bus);
 	if (b2) {
 		/* If we already got to this bus through a different bridge, ignore it */
@@ -1701,8 +1722,6 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 	/* Create legacy_io and legacy_mem files for this bus */
 	pci_create_legacy_files(b);
 
-	b->number = b->busn_res.start = bus;
-
 	if (parent)
 		dev_info(parent, "PCI host bridge to bus %s\n", dev_name(&b->dev));
 	else
-- 
1.7.10.4

