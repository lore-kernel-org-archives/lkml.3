Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158Ab3GHNZO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 09:25:14 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:34442 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743Ab3GHNZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 09:25:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 2/3] ACPI / hotplug / PCI: Hotplug context objects for bridges and functions
Date: Mon, 08 Jul 2013 15:30:16 +0200
Message-ID: <5467602.Eu9oTtT08x@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <5361579.8un1t1TCfk@vostro.rjw.lan>
References: <1468174.eo7i60DZFT@vostro.rjw.lan> <5361579.8un1t1TCfk@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

When either a new hotplug brigde or a new hotplug function is added
by the ACPI-based PCI hotplug (acpiphp) code, attach a context object
to its ACPI handle to store hotplug-related information in it.  To
start with, put the handle's bridge and function pointers into that
object.  Count references to the context objects and drop them when
they are not needed any more.

First of all, this makes it possible to find out if the given bridge
has been registered as a function already in a much more
straightforward way and acpiphp_bridge_handle_to_function() can be
dropped (Yay!).

This also will allow some more simplifications to be made going
forward.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp.h      |   10 ++
 drivers/pci/hotplug/acpiphp_glue.c |  149 ++++++++++++++++++++++++++-----------
 2 files changed, 116 insertions(+), 43 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp.h
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp.h
+++ linux-pm/drivers/pci/hotplug/acpiphp.h
@@ -49,6 +49,7 @@
 #define info(format, arg...) printk(KERN_INFO "%s: " format, MY_NAME , ## arg)
 #define warn(format, arg...) printk(KERN_WARNING "%s: " format, MY_NAME , ## arg)
 
+struct acpiphp_context;
 struct acpiphp_bridge;
 struct acpiphp_slot;
 
@@ -77,6 +78,7 @@ struct acpiphp_bridge {
 	struct kref ref;
 	acpi_handle handle;
 
+	struct acpiphp_context *context;
 	/* Ejectable PCI-to-PCI bridge (PCI bridge and PCI function) */
 	struct acpiphp_func *func;
 
@@ -119,6 +121,7 @@ struct acpiphp_slot {
  * typically 8 objects per slot (i.e. for each PCI function)
  */
 struct acpiphp_func {
+	struct acpiphp_context *context;
 	struct acpiphp_slot *slot;	/* parent */
 
 	struct list_head sibling;
@@ -129,6 +132,13 @@ struct acpiphp_func {
 	u32		flags;		/* see below */
 };
 
+struct acpiphp_context {
+	struct kref kref;
+	acpi_handle handle;
+	struct acpiphp_func *func;
+	struct acpiphp_bridge *bridge;
+};
+
 /*
  * struct acpiphp_attention_info - device specific attention registration
  *
Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -79,6 +79,61 @@ is_pci_dock_device(acpi_handle handle, u
 	}
 }
 
+static void acpiphp_context_handler(acpi_handle handle, void *context)
+{
+	/* Intentionally empty. */
+}
+
+static struct acpiphp_context *acpiphp_init_context(acpi_handle handle)
+{
+	struct acpiphp_context *context;
+	acpi_status status;
+
+	context = kzalloc(sizeof(*context), GFP_KERNEL);
+	if (!context)
+		return NULL;
+
+	context->handle = handle;
+	kref_init(&context->kref);
+	status = acpi_attach_data(handle, acpiphp_context_handler, context);
+	if (ACPI_FAILURE(status)) {
+		kfree(context);
+		return NULL;
+	}
+	return context;
+}
+
+static struct acpiphp_context *acpiphp_get_context(acpi_handle handle)
+{
+	struct acpiphp_context *context = NULL;
+	acpi_status status;
+	void *data;
+
+	status = acpi_get_data(handle, acpiphp_context_handler, &data);
+	if (ACPI_SUCCESS(status)) {
+		context = data;
+		kref_get(&context->kref);
+	} else if (status == AE_NOT_FOUND) {
+		context = acpiphp_init_context(handle);
+	}
+	return context;
+}
+
+static void acpiphp_release_context(struct kref *kref)
+{
+	struct acpiphp_context *context;
+
+	context = container_of(kref, struct acpiphp_context, kref);
+	WARN_ON(context->func || context->bridge);
+	acpi_detach_data(context->handle, acpiphp_context_handler);
+	kfree(context);
+}
+
+static void acpiphp_put_context(struct acpiphp_context *context)
+{
+	kref_put(&context->kref, acpiphp_release_context);
+}
+
 static inline void get_bridge(struct acpiphp_bridge *bridge)
 {
 	kref_get(&bridge->ref);
@@ -91,6 +146,7 @@ static inline void put_bridge(struct acp
 
 static void free_bridge(struct kref *kref)
 {
+	struct acpiphp_context *context;
 	struct acpiphp_bridge *bridge;
 	struct acpiphp_slot *slot, *next;
 	struct acpiphp_func *func, *tmp;
@@ -99,17 +155,24 @@ static void free_bridge(struct kref *kre
 
 	list_for_each_entry_safe(slot, next, &bridge->slots, node) {
 		list_for_each_entry_safe(func, tmp, &slot->funcs, sibling) {
+			context = func->context;
+			context->func = NULL;
 			kfree(func);
+			acpiphp_put_context(context);
 		}
 		kfree(slot);
 	}
 
-	/* Release reference acquired by acpiphp_bridge_handle_to_function() */
+	/* Release reference acquired by acpiphp_enumerate_slots(). */
 	if ((bridge->flags & BRIDGE_HAS_EJ0) && bridge->func)
 		put_bridge(bridge->func->slot->bridge);
+
 	put_device(&bridge->pci_bus->dev);
 	pci_dev_put(bridge->pci_dev);
+	context = bridge->context;
+	context->bridge = NULL;
 	kfree(bridge);
+	acpiphp_put_context(context);
 }
 
 /*
@@ -195,10 +258,11 @@ static void acpiphp_dock_release(void *d
 }
 
 /* callback routine to register each ACPI PCI slot object */
-static acpi_status
-register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
+static acpi_status register_slot(acpi_handle handle, u32 lvl, void *data,
+				 void **rv)
 {
-	struct acpiphp_bridge *bridge = (struct acpiphp_bridge *)context;
+	struct acpiphp_bridge *bridge = (struct acpiphp_bridge *)data;
+	struct acpiphp_context *context;
 	struct acpiphp_slot *slot;
 	struct acpiphp_func *newfunc;
 	acpi_handle tmp;
@@ -229,8 +293,18 @@ register_slot(acpi_handle handle, u32 lv
 	if (!newfunc)
 		return AE_NO_MEMORY;
 
+	context = acpiphp_get_context(newfunc->handle);
+	if (!context) {
+		acpi_handle_err(newfunc->handle,
+				"Unable to get hotplug context\n");
+		kfree(newfunc);
+		return AE_NOT_EXIST;
+	}
+
 	newfunc->handle = handle;
 	newfunc->function = function;
+	newfunc->context = context;
+	context->func = newfunc;
 
 	if (ACPI_SUCCESS(acpi_get_handle(handle, "_EJ0", &tmp)))
 		newfunc->flags = FUNC_HAS_EJ0;
@@ -268,8 +342,8 @@ register_slot(acpi_handle handle, u32 lv
 	if (!found) {
 		slot = kzalloc(sizeof(struct acpiphp_slot), GFP_KERNEL);
 		if (!slot) {
-			kfree(newfunc);
-			return AE_NO_MEMORY;
+			status = AE_NO_MEMORY;
+			goto err_out;
 		}
 
 		slot->bridge = bridge;
@@ -293,7 +367,9 @@ register_slot(acpi_handle handle, u32 lv
 			else
 				warn("acpiphp_register_hotplug_slot failed "
 					"(err code = 0x%x)\n", retval);
-			goto err_exit;
+
+			status = AE_OK;
+			goto err;
 		}
 	}
 
@@ -339,15 +415,17 @@ register_slot(acpi_handle handle, u32 lv
 
 	return AE_OK;
 
- err_exit:
+ err:
 	bridge->nr_slots--;
 	mutex_lock(&bridge_mutex);
 	list_del(&slot->node);
 	mutex_unlock(&bridge_mutex);
 	kfree(slot);
+ err_out:
+	context->func = NULL;
 	kfree(newfunc);
-
-	return AE_OK;
+	acpiphp_put_context(context);
+	return status;
 }
 
 
@@ -362,32 +440,6 @@ static int detect_ejectable_slots(acpi_h
 	return found;
 }
 
-
-/* find acpiphp_func from acpiphp_bridge */
-static struct acpiphp_func *acpiphp_bridge_handle_to_function(acpi_handle handle)
-{
-	struct acpiphp_bridge *bridge;
-	struct acpiphp_slot *slot;
-	struct acpiphp_func *func = NULL;
-
-	mutex_lock(&bridge_mutex);
-	list_for_each_entry(bridge, &bridge_list, list) {
-		list_for_each_entry(slot, &bridge->slots, node) {
-			list_for_each_entry(func, &slot->funcs, sibling) {
-				if (func->handle == handle) {
-					get_bridge(func->slot->bridge);
-					mutex_unlock(&bridge_mutex);
-					return func;
-				}
-			}
-		}
-	}
-	mutex_unlock(&bridge_mutex);
-
-	return NULL;
-}
-
-
 static struct acpiphp_bridge *acpiphp_handle_to_bridge(acpi_handle handle)
 {
 	struct acpiphp_bridge *bridge;
@@ -1130,6 +1182,7 @@ static void handle_hotplug_event_func(ac
  */
 void acpiphp_enumerate_slots(struct pci_bus *bus)
 {
+	struct acpiphp_context *context;
 	struct acpiphp_bridge *bridge;
 	acpi_handle handle;
 	acpi_status status;
@@ -1141,9 +1194,16 @@ void acpiphp_enumerate_slots(struct pci_
 	if (!handle || detect_ejectable_slots(handle) <= 0)
 		return;
 
+	context = acpiphp_get_context(handle);
+	if (!context) {
+		acpi_handle_err(handle, "Unable to get hotplug context\n");
+		return;
+	}
+
 	bridge = kzalloc(sizeof(struct acpiphp_bridge), GFP_KERNEL);
 	if (bridge == NULL) {
-		err("out of memory\n");
+		acpi_handle_err(handle, "No memory for bridge object\n");
+		acpiphp_put_context(context);
 		return;
 	}
 
@@ -1152,6 +1212,8 @@ void acpiphp_enumerate_slots(struct pci_
 	bridge->handle = handle;
 	bridge->pci_dev = pci_dev_get(bus->self);
 	bridge->pci_bus = bus;
+	bridge->context = context;
+	context->bridge = bridge;
 
 	/*
 	 * Grab a ref to the subordinate PCI bus in case the bus is
@@ -1185,20 +1247,21 @@ void acpiphp_enumerate_slots(struct pci_
 				"failed to register notify handler\n");
 		goto err;
 	}
-
 	status = acpi_get_handle(bridge->handle, "_EJ0", &handle);
 	if (ACPI_FAILURE(status))
 		return;
 
 	dbg("found ejectable p2p bridge\n");
 	bridge->flags |= BRIDGE_HAS_EJ0;
-	bridge->func = acpiphp_bridge_handle_to_function(bridge->handle);
-	if (bridge->func) {
-		status = acpi_remove_notify_handler(bridge->func->handle,
-						    ACPI_SYSTEM_NOTIFY,
+	if (context->func) {
+		get_bridge(context->func->slot->bridge);
+		bridge->func = context->func;
+		handle = context->handle;
+		WARN_ON(bridge->handle != handle);
+		status = acpi_remove_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
 						    handle_hotplug_event_func);
 		if (ACPI_FAILURE(status))
-			acpi_handle_err(bridge->func->handle,
+			acpi_handle_err(handle,
 					"failed to remove notify handler\n");
 	}
 	return;

