Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab3EPPvb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 11:51:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60388 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab3EPPv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 11:51:27 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [RFC PATCH v2, part3 03/11] PCI: introduce a state machine to manage PCI device lifecycle
Date: Thu, 16 May 2013 23:50:51 +0800
Message-Id: <1368719459-24800-4-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1368719459-24800-1-git-send-email-jiang.liu@huawei.com>
References: <1368719459-24800-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct pci_dev has a one bit flag (is_added) to store PCI device state,
but it's not enough to protect PCI devices from concurrent PCI hotplug
operations. So extend the one bit is_added flag as a three bits
dev_state field and introduce a simple state machine for PCI device
objects as:
	INITIALIZED -> STARTED -> STOPPING -> STOPPED -> REMOVED

The state machine is used to protect PCI devices from multiple invokes
of pci_stop_dev() and pci_destroy_dev() for the same PCI device object.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Yijing Wang <wangyijing@huawei.com>
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pci/bus.c                  | 14 ++++++++------
 drivers/pci/hotplug/acpiphp_glue.c |  2 +-
 drivers/pci/probe.c                |  7 +++----
 drivers/pci/remove.c               | 31 ++++++++++++++++++++-----------
 include/linux/pci.h                | 15 ++++++++++++++-
 5 files changed, 46 insertions(+), 23 deletions(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 8ea5972..913608e 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -183,7 +183,7 @@ int pci_bus_add_device(struct pci_dev *dev)
 	retval = device_attach(&dev->dev);
 	WARN_ON(retval < 0);
 
-	dev->is_added = 1;
+	dev->dev_state = PCI_DEV_STATE_STARTED;
 
 	return 0;
 }
@@ -211,7 +211,7 @@ void pci_bus_add_devices(const struct pci_bus *bus)
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
 		/* Skip already-added devices */
-		if (dev->is_added)
+		if (dev->dev_state >= PCI_DEV_STATE_STARTED)
 			continue;
 		retval = pci_bus_add_device(dev);
 		if (retval)
@@ -220,10 +220,12 @@ void pci_bus_add_devices(const struct pci_bus *bus)
 	}
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
-		BUG_ON(!dev->is_added);
-		child = dev->subordinate;
-		if (child)
-			pci_bus_add_devices(child);
+		BUG_ON(dev->dev_state < PCI_DEV_STATE_STARTED);
+		if (dev->dev_state == PCI_DEV_STATE_STARTED) {
+			child = dev->subordinate;
+			if (child)
+				pci_bus_add_devices(child);
+		}
 	}
 }
 
diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 96fed19..e330331 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -708,7 +708,7 @@ static int __ref enable_device(struct acpiphp_slot *slot)
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
 		/* Assume that newly added devices are powered on already. */
-		if (!dev->is_added)
+		if (dev->dev_state == PCI_DEV_STATE_INITIALIZED)
 			dev->current_state = PCI_D0;
 	}
 
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 4e24d93..9fcf3a3 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1433,8 +1433,7 @@ static int only_one_child(struct pci_bus *bus)
  * @devfn: slot number to scan (must have zero function.)
  *
  * Scan a PCI slot on the specified PCI bus for devices, adding
- * discovered devices to the @bus->devices list.  New devices
- * will not have is_added set.
+ * discovered devices to the @bus->devices list.
  *
  * Returns the number of new devices found.
  */
@@ -1449,13 +1448,13 @@ int pci_scan_slot(struct pci_bus *bus, int devfn)
 	dev = pci_scan_single_device(bus, devfn);
 	if (!dev)
 		return 0;
-	if (!dev->is_added)
+	if (dev->dev_state == PCI_DEV_STATE_INITIALIZED)
 		nr++;
 
 	for (fn = next_fn(bus, dev, 0); fn > 0; fn = next_fn(bus, dev, fn)) {
 		dev = pci_scan_single_device(bus, devfn + fn);
 		if (dev) {
-			if (!dev->is_added)
+			if (dev->dev_state == PCI_DEV_STATE_INITIALIZED)
 				nr++;
 			dev->multifunction = 1;
 		}
diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index effe4ff..2f01f72 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -10,7 +10,7 @@ static void pci_free_resources(struct pci_dev *dev)
 {
 	int i;
 
- 	msi_remove_pci_irq_vectors(dev);
+	msi_remove_pci_irq_vectors(dev);
 
 	pci_cleanup_rom(dev);
 	for (i = 0; i < PCI_NUM_RESOURCES; i++) {
@@ -22,27 +22,36 @@ static void pci_free_resources(struct pci_dev *dev)
 
 static void pci_stop_dev(struct pci_dev *dev)
 {
-	pci_pme_active(dev, false);
+	bool started;
+
+	BUG_ON(dev->dev_state == PCI_DEV_STATE_STOPPING);
+	if (dev->dev_state >= PCI_DEV_STATE_STOPPED)
+		return;
 
-	if (dev->is_added) {
+	started = dev->dev_state == PCI_DEV_STATE_STARTED;
+	dev->dev_state = PCI_DEV_STATE_STOPPING;
+	pci_pme_active(dev, false);
+	if (started) {
 		pci_proc_detach_device(dev);
 		pci_remove_sysfs_dev_files(dev);
 		device_del(&dev->dev);
-		dev->is_added = 0;
 	}
-
 	if (dev->bus->self)
 		pcie_aspm_exit_link_state(dev);
+
+	dev->dev_state = PCI_DEV_STATE_STOPPED;
 }
 
 static void pci_destroy_dev(struct pci_dev *dev)
 {
-	down_write(&pci_bus_sem);
-	list_del(&dev->bus_list);
-	up_write(&pci_bus_sem);
-
-	pci_free_resources(dev);
-	put_device(&dev->dev);
+	if (dev->dev_state < PCI_DEV_STATE_REMOVED) {
+		down_write(&pci_bus_sem);
+		list_del(&dev->bus_list);
+		up_write(&pci_bus_sem);
+		pci_free_resources(dev);
+		put_device(&dev->dev);
+		dev->dev_state = PCI_DEV_STATE_REMOVED;
+	}
 }
 
 void pci_remove_bus(struct pci_bus *bus)
diff --git a/include/linux/pci.h b/include/linux/pci.h
index cfe075c..d3f61f8 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -210,6 +210,14 @@ enum pci_bus_speed {
 	PCI_SPEED_UNKNOWN		= 0xff,
 };
 
+enum pci_dev_state {
+	PCI_DEV_STATE_INITIALIZED = 0,
+	PCI_DEV_STATE_STARTED = 1,
+	PCI_DEV_STATE_STOPPING = 2,
+	PCI_DEV_STATE_STOPPED = 3,
+	PCI_DEV_STATE_REMOVED = 4,
+};
+
 struct pci_cap_saved_data {
 	char cap_nr;
 	unsigned int size;
@@ -307,7 +315,7 @@ struct pci_dev {
 	unsigned int	transparent:1;	/* Transparent PCI bridge */
 	unsigned int	multifunction:1;/* Part of multi-function device */
 	/* keep track of device state */
-	unsigned int	is_added:1;
+	unsigned int	dev_state:3;
 	unsigned int	is_busmaster:1; /* device is busmaster */
 	unsigned int	no_msi:1;	/* device may not use msi */
 	unsigned int	block_cfg_access:1;	/* config space access is blocked */
@@ -367,6 +375,11 @@ static inline struct pci_dev *pci_physfn(struct pci_dev *dev)
 struct pci_dev *pci_alloc_dev(struct pci_bus *bus);
 struct pci_dev * __deprecated alloc_pci_dev(void);
 
+static inline int pci_dev_get_state(struct pci_dev *pdev)
+{
+	return (volatile int)pdev->dev_state;
+}
+
 #define	to_pci_dev(n) container_of(n, struct pci_dev, dev)
 #define for_each_pci_dev(d) while ((d = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, d)) != NULL)
 
-- 
1.8.1.2

