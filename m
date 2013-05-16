Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab3EPPxy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 11:53:54 -0400
Received: from mail-da0-f43.google.com ([209.85.210.43]:51053 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895Ab3EPPvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 11:51:22 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2, part3 02/11] PCI: implement state machine for PCI bus
Date: Thu, 16 May 2013 23:50:50 +0800
Message-Id: <1368719459-24800-3-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1368719459-24800-1-git-send-email-jiang.liu@huawei.com>
References: <1368719459-24800-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance the PCI core to implement the state machine for PCI buses.
It also enhances PCI bus removal logic by using the state machine.

The state machine will be used to protect PCI buses from concurrent
hotplug operations.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pci/bus.c    |   9 +++++
 drivers/pci/probe.c  |   8 ++++
 drivers/pci/remove.c | 101 ++++++++++++++++++++++++++++++---------------------
 3 files changed, 76 insertions(+), 42 deletions(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index b232775..8ea5972 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -200,6 +200,15 @@ void pci_bus_add_devices(const struct pci_bus *bus)
 	struct pci_bus *child;
 	int retval;
 
+	BUG_ON(!pci_bus_is_locked(bus));
+	/* change bus to STARTED state before adding devices */
+	if (pci_bus_get_state(bus) == PCI_BUS_STATE_REGISTERED)
+		pci_bus_change_state((struct pci_bus *)bus,
+			PCI_BUS_STATE_REGISTERED, PCI_BUS_STATE_STARTED, false);
+	/* Return if @bus is going to be removed */
+	if (pci_bus_get_state(bus) != PCI_BUS_STATE_STARTED)
+		return;
+
 	list_for_each_entry(dev, &bus->devices, bus_list) {
 		/* Skip already-added devices */
 		if (dev->is_added)
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index cc5e432..4e24d93 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -90,6 +90,7 @@ static void release_pcibus_dev(struct device *dev)
 		put_device(pci_bus->bridge);
 	pci_bus_remove_resources(pci_bus);
 	pci_release_bus_of_node(pci_bus);
+	atomic_set(&pci_bus->state, PCI_BUS_STATE_DESTROYED);
 	kfree(pci_bus);
 }
 
@@ -471,6 +472,8 @@ static struct pci_bus *pci_alloc_bus(struct pci_ops *ops, void *sd, int bus)
 		b->busn_res.end = 0xff;
 		b->busn_res.flags = IORESOURCE_BUS;
 		b->dev.class = &pcibus_class;
+		atomic_set(&b->state,
+			   PCI_BUS_STATE_INITIALIZED | PCI_BUS_STATE_LOCK);
 		dev_set_name(&b->dev, "%04x:%02x", pci_domain_nr(b), bus);
 		device_initialize(&b->dev);
 	}
@@ -688,6 +691,8 @@ add_dev:
 
 	/* Create legacy_io and legacy_mem files for this bus */
 	pci_create_legacy_files(child);
+	pci_bus_change_state(child, PCI_BUS_STATE_INITIALIZED,
+			     PCI_BUS_STATE_REGISTERED, false);
 
 	return child;
 }
@@ -1760,6 +1765,9 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 	list_add_tail(&b->node, &pci_root_buses);
 	up_write(&pci_bus_sem);
 
+	pci_bus_change_state(b, PCI_BUS_STATE_INITIALIZED,
+			     PCI_BUS_STATE_REGISTERED, false);
+
 	return b;
 
 class_dev_reg_err:
diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index b0ce875..effe4ff 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -3,6 +3,9 @@
 #include <linux/pci-aspm.h>
 #include "pci.h"
 
+static void pci_stop_bus_device(struct pci_dev *dev);
+static void pci_remove_bus_device(struct pci_dev *dev);
+
 static void pci_free_resources(struct pci_dev *dev)
 {
 	int i;
@@ -44,53 +47,75 @@ static void pci_destroy_dev(struct pci_dev *dev)
 
 void pci_remove_bus(struct pci_bus *bus)
 {
-	pci_proc_detach_bus(bus);
+	int state = pci_bus_get_state(bus);
+
+	BUG_ON(!pci_bus_is_locked(bus) || state == PCI_BUS_STATE_REMOVING);
+	if (state >= PCI_BUS_STATE_REMOVED)
+		return;
+
+	pci_bus_change_state(bus, state, PCI_BUS_STATE_REMOVING, false);
 
+	pci_proc_detach_bus(bus);
 	down_write(&pci_bus_sem);
 	list_del(&bus->node);
 	pci_bus_release_busn_res(bus);
 	up_write(&pci_bus_sem);
 	pci_remove_legacy_files(bus);
 	pcibios_remove_bus(bus);
+
 	device_del(&bus->dev);
+	pci_bus_change_state(bus, PCI_BUS_STATE_REMOVING,
+			     PCI_BUS_STATE_REMOVED, true);
 	put_device(&bus->dev);
 }
 EXPORT_SYMBOL(pci_remove_bus);
 
-static void pci_stop_bus_device(struct pci_dev *dev)
+static void pci_bus_stop_devices(struct pci_bus *bus)
 {
-	struct pci_bus *bus = dev->subordinate;
 	struct pci_dev *child, *tmp;
+	int state = pci_bus_get_state(bus);
+
+	BUG_ON(!pci_bus_is_locked(bus) || state == PCI_BUS_STATE_STOPPING);
+	if (state >= PCI_BUS_STATE_STOPPED)
+		return;
 
+	pci_bus_change_state(bus, state, PCI_BUS_STATE_STOPPING, false);
 	/*
 	 * Stopping an SR-IOV PF device removes all the associated VFs,
 	 * which will update the bus->devices list and confuse the
 	 * iterator.  Therefore, iterate in reverse so we remove the VFs
 	 * first, then the PF.
 	 */
-	if (bus) {
-		list_for_each_entry_safe_reverse(child, tmp,
-						 &bus->devices, bus_list)
-			pci_stop_bus_device(child);
-	}
-
-	pci_stop_dev(dev);
+	list_for_each_entry_safe_reverse(child, tmp, &bus->devices, bus_list)
+		pci_stop_bus_device(child);
+	pci_bus_change_state(bus, PCI_BUS_STATE_STOPPING,
+			     PCI_BUS_STATE_STOPPED, false);
 }
 
-static void pci_remove_bus_device(struct pci_dev *dev)
+static void pci_bus_remove_bus(struct pci_bus *bus)
 {
-	struct pci_bus *bus = dev->subordinate;
 	struct pci_dev *child, *tmp;
 
-	if (bus) {
-		list_for_each_entry_safe(child, tmp,
-					 &bus->devices, bus_list)
+	if (pci_bus_get_state(bus) < PCI_BUS_STATE_REMOVED) {
+		list_for_each_entry_safe(child, tmp, &bus->devices, bus_list)
 			pci_remove_bus_device(child);
-
 		pci_remove_bus(bus);
-		dev->subordinate = NULL;
 	}
+}
 
+static void pci_stop_bus_device(struct pci_dev *dev)
+{
+	if (dev->subordinate)
+		pci_bus_stop_devices(dev->subordinate);
+	pci_stop_dev(dev);
+}
+
+static void pci_remove_bus_device(struct pci_dev *dev)
+{
+	if (dev->subordinate) {
+		pci_bus_remove_bus(dev->subordinate);
+		dev->subordinate = NULL;
+	}
 	pci_destroy_dev(dev);
 }
 
@@ -108,6 +133,7 @@ static void pci_remove_bus_device(struct pci_dev *dev)
  */
 void pci_stop_and_remove_bus_device(struct pci_dev *dev)
 {
+	BUG_ON(!pci_bus_is_locked(dev->bus));
 	pci_stop_bus_device(dev);
 	pci_remove_bus_device(dev);
 }
@@ -115,36 +141,27 @@ EXPORT_SYMBOL(pci_stop_and_remove_bus_device);
 
 void pci_stop_root_bus(struct pci_bus *bus)
 {
-	struct pci_dev *child, *tmp;
-	struct pci_host_bridge *host_bridge;
-
-	if (!pci_is_root_bus(bus))
-		return;
-
-	host_bridge = to_pci_host_bridge(bus->bridge);
-	list_for_each_entry_safe_reverse(child, tmp,
-					 &bus->devices, bus_list)
-		pci_stop_bus_device(child);
-
-	/* stop the host bridge */
-	device_del(&host_bridge->dev);
+	BUG_ON(!pci_bus_is_locked(bus));
+	if (pci_is_root_bus(bus) &&
+	    pci_bus_get_state(bus) < PCI_BUS_STATE_STOPPED) {
+		pci_bus_stop_devices(bus);
+		/* stop the host bridge */
+		device_del(bus->bridge);
+	}
 }
 
 void pci_remove_root_bus(struct pci_bus *bus)
 {
-	struct pci_dev *child, *tmp;
 	struct pci_host_bridge *host_bridge;
 
-	if (!pci_is_root_bus(bus))
-		return;
-
-	host_bridge = to_pci_host_bridge(bus->bridge);
-	list_for_each_entry_safe(child, tmp,
-				 &bus->devices, bus_list)
-		pci_remove_bus_device(child);
-	pci_remove_bus(bus);
-	host_bridge->bus = NULL;
+	BUG_ON(!pci_bus_is_locked(bus));
+	if (pci_is_root_bus(bus) &&
+	    pci_bus_get_state(bus) < PCI_BUS_STATE_REMOVED) {
+		host_bridge = to_pci_host_bridge(bus->bridge);
+		pci_bus_remove_bus(bus);
+		host_bridge->bus = NULL;
+		/* remove the host bridge */
+		put_device(&host_bridge->dev);
+	}
 
-	/* remove the host bridge */
-	put_device(&host_bridge->dev);
 }
-- 
1.8.1.2

