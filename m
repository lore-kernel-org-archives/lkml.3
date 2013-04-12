Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038Ab3DLPra (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 11:47:30 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:51974 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab3DLPr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 11:47:27 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J . Wysocki" <rjw@sisk.pl>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH v9 10/16] PCI, ACPI: handle PCI slot devices when creating/destroying PCI busses
Date: Fri, 12 Apr 2013 23:44:24 +0800
Message-Id: <1365781470-32379-11-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365781470-32379-1-git-send-email-jiang.liu@huawei.com>
References: <1365781470-32379-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the pci_slot driver doesn't update PCI slot devices when PCI
device hotplug event happens, which may cause memory leak and returning
stale information to user.

Now the pci_slot driver has been changed as built-in driver, so invoke
PCI slot enumeration and destroy routines directly from the PCI core.
And remove ACPI PCI sub-driver related code because it isn't needed
any more.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/acpi/pci_slot.c  |  170 +++++++---------------------------------------
 drivers/acpi/scan.c      |    1 -
 drivers/pci/pci-acpi.c   |    7 +-
 include/linux/pci-acpi.h |   12 ++++
 4 files changed, 41 insertions(+), 149 deletions(-)

diff --git a/drivers/acpi/pci_slot.c b/drivers/acpi/pci_slot.c
index cd1434e..033d117 100644
--- a/drivers/acpi/pci_slot.c
+++ b/drivers/acpi/pci_slot.c
@@ -9,6 +9,9 @@
  *  Copyright (C) 2007-2008 Hewlett-Packard Development Company, L.P.
  *  	Alex Chiang <achiang@hp.com>
  *
+ *  Copyright (C) 2013 Huawei Tech. Co., Ltd.
+ *	Jiang Liu <jiang.liu@huawei.com>
+ *
  *  This program is free software; you can redistribute it and/or modify it
  *  under the terms and conditions of the GNU General Public License,
  *  version 2, as published by the Free Software Foundation.
@@ -28,10 +31,9 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/types.h>
+#include <linux/list.h>
 #include <linux/pci.h>
 #include <linux/acpi.h>
-#include <acpi/acpi_bus.h>
-#include <acpi/acpi_drivers.h>
 #include <linux/dmi.h>
 
 static bool debug;
@@ -61,20 +63,12 @@ ACPI_MODULE_NAME("pci_slot");
 #define SLOT_NAME_SIZE 21		/* Inspired by #define in acpiphp.h */
 
 struct acpi_pci_slot {
-	acpi_handle root_handle;	/* handle of the root bridge */
 	struct pci_slot *pci_slot;	/* corresponding pci_slot */
 	struct list_head list;		/* node in the list of slots */
 };
 
-static int acpi_pci_slot_add(struct acpi_pci_root *root);
-static void acpi_pci_slot_remove(struct acpi_pci_root *root);
-
 static LIST_HEAD(slot_list);
 static DEFINE_MUTEX(slot_list_lock);
-static struct acpi_pci_driver acpi_pci_slot_driver = {
-	.add = acpi_pci_slot_add,
-	.remove = acpi_pci_slot_remove,
-};
 
 static int
 check_slot(acpi_handle handle, unsigned long long *sun)
@@ -113,21 +107,8 @@ out:
 	return device;
 }
 
-struct callback_args {
-	acpi_walk_callback	user_function;	/* only for walk_p2p_bridge */
-	struct pci_bus		*pci_bus;
-	acpi_handle		root_handle;
-};
-
 /*
- * register_slot
- *
- * Called once for each SxFy object in the namespace. Don't worry about
- * calling pci_create_slot multiple times for the same pci_bus:device,
- * since each subsequent call simply bumps the refcount on the pci_slot.
- *
- * The number of calls to pci_destroy_slot from unregister_slot is
- * symmetrical.
+ * Check whether handle has an associated slot and create PCI slot if it has.
  */
 static acpi_status
 register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
@@ -137,13 +118,22 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
 	char name[SLOT_NAME_SIZE];
 	struct acpi_pci_slot *slot;
 	struct pci_slot *pci_slot;
-	struct callback_args *parent_context = context;
-	struct pci_bus *pci_bus = parent_context->pci_bus;
+	struct pci_bus *pci_bus = context;
 
 	device = check_slot(handle, &sun);
 	if (device < 0)
 		return AE_OK;
 
+	/*
+	 * There may be multiple PCI functions associated with the same slot.
+	 * Check whether PCI slot has already been created for this PCI device.
+	 */
+	list_for_each_entry(slot, &slot_list, list) {
+		pci_slot = slot->pci_slot;
+		if (pci_slot->bus == pci_bus && pci_slot->number == device)
+			return AE_OK;
+	}
+
 	slot = kmalloc(sizeof(*slot), GFP_KERNEL);
 	if (!slot) {
 		err("%s: cannot allocate memory\n", __func__);
@@ -158,12 +148,8 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
 		return AE_OK;
 	}
 
-	slot->root_handle = parent_context->root_handle;
 	slot->pci_slot = pci_slot;
-	INIT_LIST_HEAD(&slot->list);
-	mutex_lock(&slot_list_lock);
 	list_add(&slot->list, &slot_list);
-	mutex_unlock(&slot_list_lock);
 
 	get_device(&pci_bus->dev);
 
@@ -173,131 +159,24 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
 	return AE_OK;
 }
 
-/*
- * walk_p2p_bridge - discover and walk p2p bridges
- * @handle: points to an acpi_pci_root
- * @context: p2p_bridge_context pointer
- *
- * Note that when we call ourselves recursively, we pass a different
- * value of pci_bus in the child_context.
- */
-static acpi_status
-walk_p2p_bridge(acpi_handle handle, u32 lvl, void *context, void **rv)
-{
-	int device, function;
-	unsigned long long adr;
-	acpi_status status;
-	acpi_handle dummy_handle;
-	acpi_walk_callback user_function;
-
-	struct pci_dev *dev;
-	struct pci_bus *pci_bus;
-	struct callback_args child_context;
-	struct callback_args *parent_context = context;
-
-	pci_bus = parent_context->pci_bus;
-	user_function = parent_context->user_function;
-
-	status = acpi_get_handle(handle, "_ADR", &dummy_handle);
-	if (ACPI_FAILURE(status))
-		return AE_OK;
-
-	status = acpi_evaluate_integer(handle, "_ADR", NULL, &adr);
-	if (ACPI_FAILURE(status))
-		return AE_OK;
-
-	device = (adr >> 16) & 0xffff;
-	function = adr & 0xffff;
-
-	dev = pci_get_slot(pci_bus, PCI_DEVFN(device, function));
-	if (!dev || !dev->subordinate)
-		goto out;
-
-	child_context.pci_bus = dev->subordinate;
-	child_context.user_function = user_function;
-	child_context.root_handle = parent_context->root_handle;
-
-	dbg("p2p bridge walk, pci_bus = %x\n", dev->subordinate->number);
-	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, (u32)1,
-				     user_function, NULL, &child_context, NULL);
-	if (ACPI_FAILURE(status))
-		goto out;
-
-	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, (u32)1,
-				     walk_p2p_bridge, NULL, &child_context, NULL);
-out:
-	pci_dev_put(dev);
-	return AE_OK;
-}
-
-/*
- * walk_root_bridge - generic root bridge walker
- * @root: poiner of an acpi_pci_root
- * @user_function: user callback for slot objects
- *
- * Call user_function for all objects underneath this root bridge.
- * Walk p2p bridges underneath us and call user_function on those too.
- */
-static int
-walk_root_bridge(struct acpi_pci_root *root, acpi_walk_callback user_function)
-{
-	acpi_status status;
-	acpi_handle handle = root->device->handle;
-	struct pci_bus *pci_bus = root->bus;
-	struct callback_args context;
-
-	context.pci_bus = pci_bus;
-	context.user_function = user_function;
-	context.root_handle = handle;
-
-	dbg("root bridge walk, pci_bus = %x\n", pci_bus->number);
-	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, (u32)1,
-				     user_function, NULL, &context, NULL);
-	if (ACPI_FAILURE(status))
-		return status;
-
-	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, (u32)1,
-				     walk_p2p_bridge, NULL, &context, NULL);
-	if (ACPI_FAILURE(status))
-		err("%s: walk_p2p_bridge failure - %d\n", __func__, status);
-
-	return status;
-}
-
-/*
- * acpi_pci_slot_add
- * @handle: points to an acpi_pci_root
- */
-static int
-acpi_pci_slot_add(struct acpi_pci_root *root)
+void acpi_pci_slot_enumerate(struct pci_bus *bus, acpi_handle handle)
 {
-	acpi_status status;
-
-	status = walk_root_bridge(root, register_slot);
-	if (ACPI_FAILURE(status))
-		err("%s: register_slot failure - %d\n", __func__, status);
-
-	return status;
+	mutex_lock(&slot_list_lock);
+	acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, 1,
+			    register_slot, NULL, bus, NULL);
+	mutex_unlock(&slot_list_lock);
 }
 
-/*
- * acpi_pci_slot_remove
- * @handle: points to an acpi_pci_root
- */
-static void
-acpi_pci_slot_remove(struct acpi_pci_root *root)
+void acpi_pci_slot_remove(struct pci_bus *bus)
 {
 	struct acpi_pci_slot *slot, *tmp;
-	struct pci_bus *pbus;
-	acpi_handle handle = root->device->handle;
 
 	mutex_lock(&slot_list_lock);
 	list_for_each_entry_safe(slot, tmp, &slot_list, list) {
-		if (slot->root_handle == handle) {
+		if (slot->pci_slot->bus == bus) {
 			list_del(&slot->list);
-			pbus = slot->pci_slot->bus;
 			pci_destroy_slot(slot->pci_slot);
-			put_device(&pbus->dev);
+			put_device(&bus->dev);
 			kfree(slot);
 		}
 	}
@@ -332,5 +211,4 @@ static struct dmi_system_id acpi_pci_slot_dmi_table[] __initdata = {
 void __init acpi_pci_slot_init(void)
 {
 	dmi_check_system(acpi_pci_slot_dmi_table);
-	acpi_pci_register_driver(&acpi_pci_slot_driver);
 }
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 5e7e991..f54d198 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1790,7 +1790,6 @@ int __init acpi_scan_init(void)
 	acpi_platform_init();
 	acpi_csrt_init();
 	acpi_container_init();
-	acpi_pci_slot_init();
 
 	mutex_lock(&acpi_scan_lock);
 	/*
diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
index b8b8437..98e582a 100644
--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
@@ -296,7 +296,7 @@ void acpi_pci_add_bus(struct pci_bus *bus)
 	if (acpi_pci_disabled || handle == NULL)
 		return;
 
-	/* TODO: add PCI slots and acpiphp hotplug slots */
+	acpi_pci_slot_enumerate(bus, handle);
 }
 
 void acpi_pci_remove_bus(struct pci_bus *bus)
@@ -308,7 +308,7 @@ void acpi_pci_remove_bus(struct pci_bus *bus)
 	if (acpi_pci_disabled)
 		return;
 
-	/* TODO: remove PCI slots and acpiphp hotplug slots */
+	acpi_pci_slot_remove(bus);
 }
 
 /* ACPI bus type */
@@ -385,7 +385,10 @@ static int __init acpi_pci_init(void)
 	ret = register_acpi_bus_type(&acpi_pci_bus);
 	if (ret)
 		return 0;
+
 	pci_set_platform_pm(&acpi_pci_platform_pm);
+	acpi_pci_slot_init();
+
 	return 0;
 }
 arch_initcall(acpi_pci_init);
diff --git a/include/linux/pci-acpi.h b/include/linux/pci-acpi.h
index 2b1743c..1ef126f 100644
--- a/include/linux/pci-acpi.h
+++ b/include/linux/pci-acpi.h
@@ -44,6 +44,18 @@ static inline acpi_handle acpi_pci_get_bridge_handle(struct pci_bus *pbus)
 
 void acpi_pci_add_bus(struct pci_bus *bus);
 void acpi_pci_remove_bus(struct pci_bus *bus);
+
+#ifdef	CONFIG_ACPI_PCI_SLOT
+extern void acpi_pci_slot_init(void);
+extern void acpi_pci_slot_enumerate(struct pci_bus *bus, acpi_handle handle);
+extern void acpi_pci_slot_remove(struct pci_bus *bus);
+#else
+static inline void acpi_pci_slot_init(void) { }
+static inline void acpi_pci_slot_enumerate(struct pci_bus *bus,
+					   acpi_handle handle) { }
+static inline void acpi_pci_slot_remove(struct pci_bus *bus) { }
+#endif
+
 #else	/* CONFIG_ACPI */
 static inline void acpi_pci_add_bus(struct pci_bus *bus) { }
 static inline void acpi_pci_remove_bus(struct pci_bus *bus) { }
-- 
1.7.9.5

