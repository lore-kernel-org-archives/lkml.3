Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608Ab3DLPr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 11:47:59 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:65003 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123Ab3DLPr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 11:47:56 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J . Wysocki" <rjw@sisk.pl>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH v9 14/16] PCI/acpiphp: protect acpiphp data structures from concurrent updating
Date: Fri, 12 Apr 2013 23:44:28 +0800
Message-Id: <1365781470-32379-15-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365781470-32379-1-git-send-email-jiang.liu@huawei.com>
References: <1365781470-32379-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now acpiphp_enumerate_slots() and acpiphp_remove_slots() may be invoked
concurrently by the PCI core, so add a bridge_mutex and reference count
mechanism to protect acpiphp bridge/slot/function data structures.

To avoid deadlock, handle_hotplug_event_bridge() will requeue the
hotplug event onto the kacpi_hotplug_wq by calling alloc_acpi_hp_work().
But the workaround has introduced a minor race window because the
'bridge' passed to _handle_hotplug_event_bridge() may have already been
destroyed when _handle_hotplug_event_bridge() is actually executed by
the kacpi_hotplug_wq. So hold a reference count on the passed 'bridge'.
Fix the same issue for handle_hotplug_event_func() too.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pci/hotplug/acpiphp.h      |    1 +
 drivers/pci/hotplug/acpiphp_glue.c |   95 +++++++++++++++++++++++++++++-------
 2 files changed, 78 insertions(+), 18 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp.h b/drivers/pci/hotplug/acpiphp.h
index 0b30045..7577bb3 100644
--- a/drivers/pci/hotplug/acpiphp.h
+++ b/drivers/pci/hotplug/acpiphp.h
@@ -74,6 +74,7 @@ static inline const char *slot_name(struct slot *slot)
 struct acpiphp_bridge {
 	struct list_head list;
 	struct list_head slots;
+	struct kref ref;
 	acpi_handle handle;
 
 	/* Ejectable PCI-to-PCI bridge (PCI bridge and PCI function) */
diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 6bfd5a0..896d680 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -54,6 +54,7 @@
 #include "acpiphp.h"
 
 static LIST_HEAD(bridge_list);
+static DEFINE_MUTEX(bridge_mutex);
 
 #define MY_NAME "acpiphp_glue"
 
@@ -61,6 +62,7 @@ static void handle_hotplug_event_bridge (acpi_handle, u32, void *);
 static void acpiphp_sanitize_bus(struct pci_bus *bus);
 static void acpiphp_set_hpp_values(struct pci_bus *bus);
 static void handle_hotplug_event_func(acpi_handle handle, u32 type, void *context);
+static void free_bridge(struct kref *kref);
 
 /* callback routine to check for the existence of a pci dock device */
 static acpi_status
@@ -76,6 +78,39 @@ is_pci_dock_device(acpi_handle handle, u32 lvl, void *context, void **rv)
 	}
 }
 
+static inline void get_bridge(struct acpiphp_bridge *bridge)
+{
+	kref_get(&bridge->ref);
+}
+
+static inline void put_bridge(struct acpiphp_bridge *bridge)
+{
+	kref_put(&bridge->ref, free_bridge);
+}
+
+static void free_bridge(struct kref *kref)
+{
+	struct acpiphp_bridge *bridge;
+	struct acpiphp_slot *slot, *next;
+	struct acpiphp_func *func, *tmp;
+
+	bridge = container_of(kref, struct acpiphp_bridge, ref);
+
+	list_for_each_entry_safe(slot, next, &bridge->slots, node) {
+		list_for_each_entry_safe(func, tmp, &slot->funcs, sibling) {
+			kfree(func);
+		}
+		kfree(slot);
+	}
+
+	/* Release reference acquired by acpiphp_bridge_handle_to_function() */
+	if ((bridge->flags & BRIDGE_HAS_EJ0) && bridge->func)
+		put_bridge(bridge->func->slot->bridge);
+	put_device(&bridge->pci_bus->dev);
+	pci_dev_put(bridge->pci_dev);
+	kfree(bridge);
+}
+
 /*
  * the _DCK method can do funny things... and sometimes not
  * hah-hah funny.
@@ -171,7 +206,7 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
 	device = (adr >> 16) & 0xffff;
 	function = adr & 0xffff;
 
-	pdev = pbus->self;
+	pdev = bridge->pci_dev;
 	if (pdev && device_is_managed_by_native_pciehp(pdev))
 		return AE_OK;
 
@@ -179,7 +214,6 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
 	if (!newfunc)
 		return AE_NO_MEMORY;
 
-	INIT_LIST_HEAD(&newfunc->sibling);
 	newfunc->handle = handle;
 	newfunc->function = function;
 
@@ -229,7 +263,9 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
 		INIT_LIST_HEAD(&slot->funcs);
 		mutex_init(&slot->crit_sect);
 
+		mutex_lock(&bridge_mutex);
 		list_add_tail(&slot->node, &bridge->slots);
+		mutex_unlock(&bridge_mutex);
 		bridge->nr_slots++;
 
 		dbg("found ACPI PCI Hotplug slot %llu at PCI %04x:%02x:%02x\n",
@@ -247,7 +283,9 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
 	}
 
 	newfunc->slot = slot;
+	mutex_lock(&bridge_mutex);
 	list_add_tail(&newfunc->sibling, &slot->funcs);
+	mutex_unlock(&bridge_mutex);
 
 	if (pci_bus_read_dev_vendor_id(pbus, PCI_DEVFN(device, function),
 				       &val, 60*1000))
@@ -288,7 +326,9 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
 
  err_exit:
 	bridge->nr_slots--;
+	mutex_lock(&bridge_mutex);
 	list_del(&slot->node);
+	mutex_unlock(&bridge_mutex);
 	kfree(slot);
 	kfree(newfunc);
 
@@ -313,13 +353,17 @@ static void init_bridge_misc(struct acpiphp_bridge *bridge)
 	acpi_status status;
 
 	/* must be added to the list prior to calling register_slot */
+	mutex_lock(&bridge_mutex);
 	list_add(&bridge->list, &bridge_list);
+	mutex_unlock(&bridge_mutex);
 
 	/* register all slot objects under this bridge */
 	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, bridge->handle, (u32)1,
 				     register_slot, NULL, bridge, NULL);
 	if (ACPI_FAILURE(status)) {
+		mutex_lock(&bridge_mutex);
 		list_del(&bridge->list);
+		mutex_unlock(&bridge_mutex);
 		return;
 	}
 
@@ -349,16 +393,21 @@ static struct acpiphp_func *acpiphp_bridge_handle_to_function(acpi_handle handle
 {
 	struct acpiphp_bridge *bridge;
 	struct acpiphp_slot *slot;
-	struct acpiphp_func *func;
+	struct acpiphp_func *func = NULL;
 
+	mutex_lock(&bridge_mutex);
 	list_for_each_entry(bridge, &bridge_list, list) {
 		list_for_each_entry(slot, &bridge->slots, node) {
 			list_for_each_entry(func, &slot->funcs, sibling) {
-				if (func->handle == handle)
+				if (func->handle == handle) {
+					get_bridge(func->slot->bridge);
+					mutex_unlock(&bridge_mutex);
 					return func;
+				}
 			}
 		}
 	}
+	mutex_unlock(&bridge_mutex);
 
 	return NULL;
 }
@@ -368,17 +417,22 @@ static struct acpiphp_bridge *acpiphp_handle_to_bridge(acpi_handle handle)
 {
 	struct acpiphp_bridge *bridge;
 
+	mutex_lock(&bridge_mutex);
 	list_for_each_entry(bridge, &bridge_list, list)
-		if (bridge->handle == handle)
+		if (bridge->handle == handle) {
+			get_bridge(bridge);
+			mutex_unlock(&bridge_mutex);
 			return bridge;
+		}
+	mutex_unlock(&bridge_mutex);
 
 	return NULL;
 }
 
 static void cleanup_bridge(struct acpiphp_bridge *bridge)
 {
-	struct acpiphp_slot *slot, *next;
-	struct acpiphp_func *func, *tmp;
+	struct acpiphp_slot *slot;
+	struct acpiphp_func *func;
 	acpi_status status;
 	acpi_handle handle = bridge->handle;
 
@@ -399,8 +453,8 @@ static void cleanup_bridge(struct acpiphp_bridge *bridge)
 			err("failed to install interrupt notify handler\n");
 	}
 
-	list_for_each_entry_safe(slot, next, &bridge->slots, node) {
-		list_for_each_entry_safe(func, tmp, &slot->funcs, sibling) {
+	list_for_each_entry(slot, &bridge->slots, node) {
+		list_for_each_entry(func, &slot->funcs, sibling) {
 			if (is_dock_device(func->handle)) {
 				unregister_hotplug_dock_device(func->handle);
 				unregister_dock_notifier(&func->nb);
@@ -412,18 +466,13 @@ static void cleanup_bridge(struct acpiphp_bridge *bridge)
 				if (ACPI_FAILURE(status))
 					err("failed to remove notify handler\n");
 			}
-			list_del(&func->sibling);
-			kfree(func);
 		}
 		acpiphp_unregister_hotplug_slot(slot);
-		list_del(&slot->funcs);
-		kfree(slot);
 	}
 
-	put_device(&bridge->pci_bus->dev);
-	pci_dev_put(bridge->pci_dev);
+	mutex_lock(&bridge_mutex);
 	list_del(&bridge->list);
-	kfree(bridge);
+	mutex_unlock(&bridge_mutex);
 }
 
 static int power_on_slot(struct acpiphp_slot *slot)
@@ -620,7 +669,6 @@ static int __ref enable_device(struct acpiphp_slot *slot)
 	struct pci_dev *dev;
 	struct pci_bus *bus = slot->bridge->pci_bus;
 	struct acpiphp_func *func;
-	int retval = 0;
 	int num, max, pass;
 
 	if (slot->flags & SLOT_ENABLED)
@@ -680,7 +728,7 @@ static int __ref enable_device(struct acpiphp_slot *slot)
 
 
  err_exit:
-	return retval;
+	return 0;
 }
 
 /* return first device in slot, acquiring a reference on it */
@@ -897,6 +945,7 @@ check_sub_bridges(acpi_handle handle, u32 lvl, void *context, void **rv)
 		dbg("%s: re-enumerating slots under %s\n",
 			__func__, objname);
 		acpiphp_check_bridge(bridge);
+		put_bridge(bridge);
 	}
 	return AE_OK ;
 }
@@ -974,6 +1023,7 @@ static void _handle_hotplug_event_bridge(struct work_struct *work)
 
 	acpi_scan_lock_release();
 	kfree(hp_work); /* allocated in handle_hotplug_event_bridge */
+	put_bridge(bridge);
 }
 
 /**
@@ -987,6 +1037,8 @@ static void _handle_hotplug_event_bridge(struct work_struct *work)
 static void handle_hotplug_event_bridge(acpi_handle handle, u32 type,
 					void *context)
 {
+	struct acpiphp_bridge *bridge = context;
+
 	/*
 	 * Currently the code adds all hotplug events to the kacpid_wq
 	 * queue when it should add hotplug events to the kacpi_hotplug_wq.
@@ -995,6 +1047,7 @@ static void handle_hotplug_event_bridge(acpi_handle handle, u32 type,
 	 * For now just re-add this work to the kacpi_hotplug_wq so we
 	 * don't deadlock on hotplug actions.
 	 */
+	get_bridge(bridge);
 	alloc_acpi_hp_work(handle, type, context, _handle_hotplug_event_bridge);
 }
 
@@ -1049,6 +1102,7 @@ static void _handle_hotplug_event_func(struct work_struct *work)
 
 	acpi_scan_lock_release();
 	kfree(hp_work); /* allocated in handle_hotplug_event_func */
+	put_bridge(func->slot->bridge);
 }
 
 /**
@@ -1062,6 +1116,8 @@ static void _handle_hotplug_event_func(struct work_struct *work)
 static void handle_hotplug_event_func(acpi_handle handle, u32 type,
 				      void *context)
 {
+	struct acpiphp_func *func = context;
+
 	/*
 	 * Currently the code adds all hotplug events to the kacpid_wq
 	 * queue when it should add hotplug events to the kacpi_hotplug_wq.
@@ -1070,6 +1126,7 @@ static void handle_hotplug_event_func(acpi_handle handle, u32 type,
 	 * For now just re-add this work to the kacpi_hotplug_wq so we
 	 * don't deadlock on hotplug actions.
 	 */
+	get_bridge(func->slot->bridge);
 	alloc_acpi_hp_work(handle, type, context, _handle_hotplug_event_func);
 }
 
@@ -1092,6 +1149,7 @@ void acpiphp_enumerate_slots(struct pci_bus *bus, acpi_handle handle)
 	}
 
 	INIT_LIST_HEAD(&bridge->slots);
+	kref_init(&bridge->ref);
 	bridge->handle = handle;
 	bridge->pci_dev = pci_dev_get(bus->self);
 	bridge->pci_bus = bus;
@@ -1122,6 +1180,7 @@ void acpiphp_remove_slots(struct pci_bus *bus)
 	list_for_each_entry_safe(bridge, tmp, &bridge_list, list)
 		if (bridge->pci_bus == bus) {
 			cleanup_bridge(bridge);
+			put_bridge(bridge);
 			break;
 		}
 }
-- 
1.7.9.5

