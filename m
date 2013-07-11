Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843Ab3GKX7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 19:59:09 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:39053 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756655Ab3GKX7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 19:59:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [RFC][PATCH 11/30] ACPI / hotplug / PCI: Register all devices under the given bridge
Date: Fri, 12 Jul 2013 01:50:29 +0200
Message-ID: <1910839.UjS2m1ckUq@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <3718119.FLASu5DBx8@vostro.rjw.lan>
References: <26431283.HJCKsss0rt@vostro.rjw.lan> <3718119.FLASu5DBx8@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Rework register_slot() to create a struct acpiphp_func object for
every function it is called for and to create acpiphp slots for all
of them.  Although acpiphp_register_hotplug_slot() is only called for
the slots whose functions are identified as "ejectable", so that user
space can manipulate them, the ACPIPHP notify handler,
handle_hotplug_event(), is now installed for all of the registered
functions (that aren't dock stations) and hotplug events may be
handled for all of them.

As a result, essentially, all PCI bridges represented by objects in
the ACPI namespace are now going to be "hotplug" bridges and that may
affect resources allocation in general, although it shouldn't lead to
problems.

This allows the code to be simplified substantially and addresses
the problem where bus check or device check notifications for some
PCI bridges or devices are not handled, because those devices are
not recognized as "ejectable" or there appear to be no "ejectable"
devices under those bridges.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp.h      |    1 
 drivers/pci/hotplug/acpiphp_glue.c |  231 ++++++++++++-------------------------
 2 files changed, 75 insertions(+), 157 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -65,20 +65,6 @@ static void acpiphp_set_hpp_values(struc
 static void hotplug_event(acpi_handle handle, u32 type, void *data);
 static void free_bridge(struct kref *kref);
 
-/* callback routine to check for the existence of a pci dock device */
-static acpi_status
-is_pci_dock_device(acpi_handle handle, u32 lvl, void *context, void **rv)
-{
-	int *count = (int *)context;
-
-	if (is_dock_device(handle)) {
-		(*count)++;
-		return AE_CTRL_TERMINATE;
-	} else {
-		return AE_OK;
-	}
-}
-
 static void acpiphp_context_handler(acpi_handle handle, void *context)
 {
 	/* Intentionally empty. */
@@ -179,14 +165,16 @@ static void free_bridge(struct kref *kre
 	}
 
 	context = bridge->context;
-	/* Release the reference acquired by acpiphp_enumerate_slots(). */
-	if (context->handler_for_func)
+	/* Root bridges will not have hotplug context. */
+	if (context) {
+		/* Release the reference taken by acpiphp_enumerate_slots(). */
 		put_bridge(context->func->slot->bridge);
+		context->bridge = NULL;
+		acpiphp_put_context(context);
+	}
 
 	put_device(&bridge->pci_bus->dev);
 	pci_dev_put(bridge->pci_dev);
-	context->bridge = NULL;
-	acpiphp_put_context(context);
 	kfree(bridge);
 
 	mutex_unlock(&acpiphp_context_lock);
@@ -284,28 +272,24 @@ static acpi_status register_slot(acpi_ha
 	struct acpiphp_func *newfunc;
 	acpi_handle tmp;
 	acpi_status status = AE_OK;
-	unsigned long long adr, sun;
-	int device, function, retval;
+	unsigned long long adr;
+	int device, function;
 	struct pci_bus *pbus = bridge->pci_bus;
-	struct pci_dev *pdev;
+	struct pci_dev *pdev = bridge->pci_dev;
 	u32 val;
 
-	if (!acpi_pci_check_ejectable(pbus, handle) && !is_dock_device(handle))
+	if (pdev && device_is_managed_by_native_pciehp(pdev))
 		return AE_OK;
 
 	status = acpi_evaluate_integer(handle, "_ADR", NULL, &adr);
 	if (ACPI_FAILURE(status)) {
-		warn("can't evaluate _ADR (%#x)\n", status);
+		acpi_handle_warn(handle, "can't evaluate _ADR (%#x)\n", status);
 		return AE_OK;
 	}
 
 	device = (adr >> 16) & 0xffff;
 	function = adr & 0xffff;
 
-	pdev = bridge->pci_dev;
-	if (pdev && device_is_managed_by_native_pciehp(pdev))
-		return AE_OK;
-
 	newfunc = kzalloc(sizeof(struct acpiphp_func), GFP_KERNEL);
 	if (!newfunc)
 		return AE_NO_MEMORY;
@@ -340,23 +324,10 @@ static acpi_status register_slot(acpi_ha
 	if (ACPI_SUCCESS(acpi_get_handle(handle, "_DCK", &tmp)))
 		newfunc->flags |= FUNC_HAS_DCK;
 
-	status = acpi_evaluate_integer(handle, "_SUN", NULL, &sun);
-	if (ACPI_FAILURE(status)) {
-		/*
-		 * use the count of the number of slots we've found
-		 * for the number of the slot
-		 */
-		sun = bridge->nr_slots+1;
-	}
-
 	/* search for objects that share the same slot */
 	list_for_each_entry(slot, &bridge->slots, node)
-		if (slot->device == device) {
-			if (slot->sun != sun)
-				warn("sibling found, but _SUN doesn't match!\n");
-
+		if (slot->device == device)
 			goto slot_found;
-		}
 
 	slot = kzalloc(sizeof(struct acpiphp_slot), GFP_KERNEL);
 	if (!slot) {
@@ -366,34 +337,38 @@ static acpi_status register_slot(acpi_ha
 
 	slot->bridge = bridge;
 	slot->device = device;
-	slot->sun = sun;
 	INIT_LIST_HEAD(&slot->funcs);
 	mutex_init(&slot->crit_sect);
 
 	mutex_lock(&bridge_mutex);
 	list_add_tail(&slot->node, &bridge->slots);
 	mutex_unlock(&bridge_mutex);
-	bridge->nr_slots++;
 
-	dbg("found ACPI PCI Hotplug slot %llu at PCI %04x:%02x:%02x\n",
-	    slot->sun, pci_domain_nr(pbus), pbus->number, device);
+	/* Register slots for ejectable funtions only. */
+	if (acpi_pci_check_ejectable(pbus, handle)  || is_dock_device(handle)) {
+		unsigned long long sun;
+		int retval;
 
-	retval = acpiphp_register_hotplug_slot(slot);
-	if (retval) {
-		if (retval == -EBUSY)
-			warn("Slot %llu already registered by another "
-				"hotplug driver\n", slot->sun);
-		else
-			warn("acpiphp_register_hotplug_slot failed "
-				"(err code = 0x%x)\n", retval);
+		bridge->nr_slots++;
+		status = acpi_evaluate_integer(handle, "_SUN", NULL, &sun);
+		if (ACPI_FAILURE(status))
+			sun = bridge->nr_slots;
 
-		bridge->nr_slots--;
-		mutex_lock(&bridge_mutex);
-		list_del(&slot->node);
-		mutex_unlock(&bridge_mutex);
-		kfree(slot);
-		status = AE_OK;
-		goto err;
+		slot->sun = sun;
+		dbg("found ACPI PCI Hotplug slot %llu at PCI %04x:%02x:%02x\n",
+		    slot->sun, pci_domain_nr(pbus), pbus->number, device);
+
+		retval = acpiphp_register_hotplug_slot(slot);
+		if (retval) {
+			bridge->nr_slots--;
+			if (retval == -EBUSY)
+				warn("Slot %llu already registered by another "
+					"hotplug driver\n", slot->sun);
+			else
+				warn("acpiphp_register_hotplug_slot failed "
+					"(err code = 0x%x)\n", retval);
+		}
+		/* Even if the slot registration fails, we can still use it. */
 	}
 
  slot_found:
@@ -431,10 +406,9 @@ static acpi_status register_slot(acpi_ha
 		status = acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
 						     handle_hotplug_event,
 						     context);
-		if (ACPI_SUCCESS(status))
-			context->handler_for_func = true;
-		else
-			err("failed to register interrupt notify handler\n");
+		if (ACPI_FAILURE(status))
+			acpi_handle_err(handle,
+					"failed to install notify handler\n");
 	}
 
 	return AE_OK;
@@ -448,18 +422,6 @@ static acpi_status register_slot(acpi_ha
 	return status;
 }
 
-
-/* see if it's worth looking at this bridge */
-static int detect_ejectable_slots(acpi_handle handle)
-{
-	int found = acpi_pci_detect_ejectable(handle);
-	if (!found) {
-		acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, (u32)1,
-				    is_pci_dock_device, NULL, (void *)&found, NULL);
-	}
-	return found;
-}
-
 static struct acpiphp_bridge *acpiphp_handle_to_bridge(acpi_handle handle)
 {
 	struct acpiphp_context *context;
@@ -483,14 +445,6 @@ static void cleanup_bridge(struct acpiph
 	struct acpiphp_slot *slot;
 	struct acpiphp_func *func;
 	acpi_status status;
-	acpi_handle handle = bridge->handle;
-
-	if (!bridge->context->handler_for_func) {
-		status = acpi_remove_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
-						    handle_hotplug_event);
-		if (ACPI_FAILURE(status))
-			err("failed to remove notify handler\n");
-	}
 
 	list_for_each_entry(slot, &bridge->slots, node) {
 		list_for_each_entry(func, &slot->funcs, sibling) {
@@ -499,7 +453,6 @@ static void cleanup_bridge(struct acpiph
 				unregister_dock_notifier(&func->nb);
 			}
 			if (!(func->flags & FUNC_HAS_DCK)) {
-				func->context->handler_for_func = false;
 				status = acpi_remove_notify_handler(func->handle,
 							ACPI_SYSTEM_NOTIFY,
 							handle_hotplug_event);
@@ -689,9 +642,7 @@ static void check_hotplug_bridge(struct
 
 	list_for_each_entry(func, &slot->funcs, sibling) {
 		if (PCI_FUNC(dev->devfn) == func->function) {
-			/* check if this bridge has ejectable slots */
-			if ((detect_ejectable_slots(func->handle) > 0))
-				dev->is_hotplug_bridge = 1;
+			dev->is_hotplug_bridge = 1;
 			break;
 		}
 	}
@@ -1010,8 +961,8 @@ void acpiphp_check_host_bridge(acpi_hand
 static void hotplug_event(acpi_handle handle, u32 type, void *data)
 {
 	struct acpiphp_context *context = data;
+	struct acpiphp_func *func = context->func;
 	struct acpiphp_bridge *bridge;
-	struct acpiphp_func *func;
 	char objname[64];
 	struct acpi_buffer buffer = { .length = sizeof(objname),
 				      .pointer = objname };
@@ -1021,11 +972,6 @@ static void hotplug_event(acpi_handle ha
 	if (bridge)
 		get_bridge(bridge);
 
-	/*
-	 * If context->func is not NULL, we are holding a reference to its
-	 * parent bridge, so it won't go away until we drop that reference.
-	 */
-	func = context->func;
 	mutex_unlock(&acpiphp_context_lock);
 
 	acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
@@ -1063,9 +1009,6 @@ static void hotplug_event(acpi_handle ha
 	case ACPI_NOTIFY_EJECT_REQUEST:
 		/* request device eject */
 		dbg("%s: Device eject notify on %s\n", __func__, objname);
-		if (!func)
-			break;
-
 		if (bridge && !(bridge->flags & BRIDGE_HAS_EJ0))
 			break;
 
@@ -1112,14 +1055,7 @@ static void hotplug_event_work(struct wo
 
 	acpi_scan_lock_release();
 	kfree(hp_work); /* allocated in handle_hotplug_event() */
-
-	mutex_lock(&acpiphp_context_lock);
-	if (context->func)
-		put_bridge(context->func->slot->bridge);
-	else
-		acpiphp_put_context(context);
-
-	mutex_unlock(&acpiphp_context_lock);
+	put_bridge(context->func->slot->bridge);
 }
 
 /**
@@ -1137,13 +1073,8 @@ static void handle_hotplug_event(acpi_ha
 	mutex_lock(&acpiphp_context_lock);
 	context = acpiphp_get_context(handle);
 	if (context) {
-		if (context->func) {
-			get_bridge(context->func->slot->bridge);
-			acpiphp_put_context(context);
-		} else if (!context->bridge) {
-			acpiphp_put_context(context);
-			context = NULL;
-		}
+		get_bridge(context->func->slot->bridge);
+		acpiphp_put_context(context);
 	}
 	mutex_unlock(&acpiphp_context_lock);
 	/*
@@ -1164,7 +1095,6 @@ static void handle_hotplug_event(acpi_ha
  */
 void acpiphp_enumerate_slots(struct pci_bus *bus)
 {
-	struct acpiphp_context *context;
 	struct acpiphp_bridge *bridge;
 	acpi_handle handle;
 	acpi_status status;
@@ -1173,7 +1103,7 @@ void acpiphp_enumerate_slots(struct pci_
 		return;
 
 	handle = ACPI_HANDLE(bus->bridge);
-	if (!handle || detect_ejectable_slots(handle) <= 0)
+	if (!handle)
 		return;
 
 	bridge = kzalloc(sizeof(struct acpiphp_bridge), GFP_KERNEL);
@@ -1188,21 +1118,6 @@ void acpiphp_enumerate_slots(struct pci_
 	bridge->pci_dev = pci_dev_get(bus->self);
 	bridge->pci_bus = bus;
 
-	mutex_lock(&acpiphp_context_lock);
-	context = acpiphp_get_context(handle);
-	if (!context) {
-		context = acpiphp_init_context(handle);
-		if (!context) {
-			mutex_unlock(&acpiphp_context_lock);
-			acpi_handle_err(handle, "No hotplug context\n");
-			kfree(bridge);
-			return;
-		}
-	}
-	bridge->context = context;
-	context->bridge = bridge;
-	mutex_unlock(&acpiphp_context_lock);
-
 	/*
 	 * Grab a ref to the subordinate PCI bus in case the bus is
 	 * removed via PCI core logical hotplug. The ref pins the bus
@@ -1210,6 +1125,35 @@ void acpiphp_enumerate_slots(struct pci_
 	 */
 	get_device(&bus->dev);
 
+	if (!pci_is_root_bus(bridge->pci_bus)) {
+		struct acpiphp_context *context;
+
+		/*
+		 * This bridge should have been registered as a hotplug function
+		 * under its parent, so the context has to be there.  If not, we
+		 * are in deep goo.
+		 */
+		mutex_lock(&acpiphp_context_lock);
+		context = acpiphp_get_context(handle);
+		if (WARN_ON(!context || !context->func)) {
+			mutex_unlock(&acpiphp_context_lock);
+			put_device(&bus->dev);
+			kfree(bridge);
+			return;
+		}
+		bridge->context = context;
+		context->bridge = bridge;
+		/* Get a reference to the parent bridge. */
+		get_bridge(context->func->slot->bridge);
+		mutex_unlock(&acpiphp_context_lock);
+	}
+
+	status = acpi_get_handle(bridge->handle, "_EJ0", &handle);
+	if (ACPI_SUCCESS(status)) {
+		dbg("found ejectable p2p bridge\n");
+		bridge->flags |= BRIDGE_HAS_EJ0;
+	}
+
 	/* must be added to the list prior to calling register_slot */
 	mutex_lock(&bridge_mutex);
 	list_add(&bridge->list, &bridge_list);
@@ -1220,34 +1164,9 @@ void acpiphp_enumerate_slots(struct pci_
 				     register_slot, NULL, bridge, NULL);
 	if (ACPI_FAILURE(status)) {
 		acpi_handle_err(bridge->handle, "failed to register slots\n");
-		goto err;
-	}
-
-	if (pci_is_root_bus(bridge->pci_bus))
-		return;
-
-	status = acpi_get_handle(bridge->handle, "_EJ0", &handle);
-	if (ACPI_SUCCESS(status)) {
-		dbg("found ejectable p2p bridge\n");
-		bridge->flags |= BRIDGE_HAS_EJ0;
-	}
-	if (context->handler_for_func) {
-		/* Notify handler already installed. */
-		get_bridge(context->func->slot->bridge);
-		return;
+		cleanup_bridge(bridge);
+		put_bridge(bridge);
 	}
-
-	/* install notify handler for P2P bridges */
-	status = acpi_install_notify_handler(bridge->handle, ACPI_SYSTEM_NOTIFY,
-					     handle_hotplug_event, NULL);
-	if (ACPI_SUCCESS(status))
-		return;
-
-	acpi_handle_err(bridge->handle, "failed to register notify handler\n");
-
- err:
-	cleanup_bridge(bridge);
-	put_bridge(bridge);
 }
 
 /* Destroy hotplug slots associated with the PCI bus */
Index: linux-pm/drivers/pci/hotplug/acpiphp.h
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp.h
+++ linux-pm/drivers/pci/hotplug/acpiphp.h
@@ -135,7 +135,6 @@ struct acpiphp_context {
 	struct acpiphp_func *func;
 	struct acpiphp_bridge *bridge;
 	unsigned int refcount;
-	bool handler_for_func;
 };
 
 /*

