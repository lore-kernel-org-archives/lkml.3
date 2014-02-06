Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469AbaBFXUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 18:20:47 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:57062 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751019AbaBFXUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 18:20:45 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Subject: [Update 2x][PATCH 20/24] ACPI / hotplug / PCI: Consolidate ACPIPHP with ACPI core hotplug
Date: Fri, 07 Feb 2014 00:35:16 +0100
Message-ID: <3316063.ub14YzB1Fc@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <3772462.OJNsJ8z97v@vostro.rjw.lan>
References: <2217793.001RY6hKlo@vostro.rjw.lan> <1909816.XoV9dQJqaS@vostro.rjw.lan> <3772462.OJNsJ8z97v@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The ACPI-based PCI hotplug (ACPIPHP) code currently attaches its
hotplug context objects directly to ACPI namespace nodes representing
hotplug devices.  However, after recent changes causing struct
acpi_device to be created for every namespace node representing a
device (regardless of its status), that is not necessary any more.
Moreover, it's vulnerable to the theoretical issue that the ACPI
handle passed in the context between handle_hotplug_event() and
hotplug_event_work() may become invalid in the meantime (as a
result of a concurrent table unload).

In principle, this issue might be addressed by adding a non-empty
release handler for ACPIPHP hotplug context objects analogous to
acpi_scan_drop_device(), but that would duplicate the code in that
function and in acpi_device_del_work_fn().  For this reason, it's
better to modify ACPIPHP to attach its device hotplug contexts to
struct device objects representing hotplug devices and make it
use acpi_hotplug_notify_cb() as its notify handler.  At the same
time, acpi_device_hotplug() can be modified to dispatch the new
.hp.event() callback pointing to acpiphp_hotplug_event() from ACPI
device objects associated with PCI devices or use the generic
ACPI device hotplug code for device objects with matching scan
handlers.

This allows the existing code duplication between ACPIPHP and the
ACPI core to be reduced too and makes further ACPI-based device
hotplug consolidation possible.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

This update fixes the bug reported here: https://lkml.org/lkml/2014/2/6/212

None of the other patches in the series need to be updated because of that.

Thanks!

---
 drivers/acpi/scan.c                |  137 +++++++++++++++++++-----------
 drivers/pci/hotplug/acpiphp.h      |    9 +
 drivers/pci/hotplug/acpiphp_glue.c |  168 ++++++++-----------------------------
 include/acpi/acpi_bus.h            |   25 +++++
 4 files changed, 158 insertions(+), 181 deletions(-)

Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -450,43 +450,61 @@ static int acpi_scan_bus_check(struct ac
 	return 0;
 }
 
+static int acpi_generic_hotplug_event(struct acpi_device *adev, u32 type)
+{
+	switch (type) {
+	case ACPI_NOTIFY_BUS_CHECK:
+		return acpi_scan_bus_check(adev);
+	case ACPI_NOTIFY_DEVICE_CHECK:
+		return acpi_scan_device_check(adev);
+	case ACPI_NOTIFY_EJECT_REQUEST:
+	case ACPI_OST_EC_OSPM_EJECT:
+		return acpi_scan_hot_remove(adev);
+	}
+	return -EINVAL;
+}
+
 static void acpi_device_hotplug(void *data, u32 src)
 {
 	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
 	struct acpi_device *adev = data;
-	int error;
+	int error = -ENODEV;
 
 	lock_device_hotplug();
 	mutex_lock(&acpi_scan_lock);
 
 	/*
 	 * The device object's ACPI handle cannot become invalid as long as we
-	 * are holding acpi_scan_lock, but it may have become invalid before
+	 * are holding acpi_scan_lock, but it might have become invalid before
 	 * that lock was acquired.
 	 */
 	if (adev->handle == INVALID_ACPI_HANDLE)
-		goto out;
+		goto err_out;
 
-	switch (src) {
-	case ACPI_NOTIFY_BUS_CHECK:
-		error = acpi_scan_bus_check(adev);
-		break;
-	case ACPI_NOTIFY_DEVICE_CHECK:
-		error = acpi_scan_device_check(adev);
-		break;
-	case ACPI_NOTIFY_EJECT_REQUEST:
-	case ACPI_OST_EC_OSPM_EJECT:
-		error = acpi_scan_hot_remove(adev);
-		break;
-	default:
-		error = -EINVAL;
-		break;
+	if (adev->flags.hotplug_notify) {
+		error = acpi_generic_hotplug_event(adev, src);
+	} else {
+		int (*event)(struct acpi_device *, u32);
+
+		acpi_lock_hp_context();
+		event = adev->hp ? adev->hp->event : NULL;
+		acpi_unlock_hp_context();
+		/*
+		 * There may be additional notify handlers for device objects
+		 * without the .event() callback, so ignore them here.
+		 */
+		if (event)
+			error = event(adev, src);
+		else
+			goto out;
 	}
 	if (!error)
 		ost_code = ACPI_OST_SC_SUCCESS;
 
- out:
+ err_out:
 	acpi_evaluate_hotplug_ost(adev->handle, src, ost_code, NULL);
+
+ out:
 	acpi_bus_put_acpi_device(adev);
 	mutex_unlock(&acpi_scan_lock);
 	unlock_device_hotplug();
@@ -494,8 +512,8 @@ static void acpi_device_hotplug(void *da
 
 static void acpi_hotplug_notify_cb(acpi_handle handle, u32 type, void *data)
 {
-	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
 	struct acpi_scan_handler *handler = data;
+	u32 ost_code = ACPI_OST_SC_SUCCESS;
 	struct acpi_device *adev;
 	acpi_status status;
 
@@ -503,26 +521,49 @@ static void acpi_hotplug_notify_cb(acpi_
 	case ACPI_NOTIFY_BUS_CHECK:
 		acpi_handle_debug(handle, "ACPI_NOTIFY_BUS_CHECK event\n");
 		break;
+
 	case ACPI_NOTIFY_DEVICE_CHECK:
 		acpi_handle_debug(handle, "ACPI_NOTIFY_DEVICE_CHECK event\n");
 		break;
+
 	case ACPI_NOTIFY_EJECT_REQUEST:
 		acpi_handle_debug(handle, "ACPI_NOTIFY_EJECT_REQUEST event\n");
-		if (!handler->hotplug.enabled) {
+		if (handler && !handler->hotplug.enabled) {
 			acpi_handle_err(handle, "Eject disabled\n");
 			ost_code = ACPI_OST_SC_EJECT_NOT_SUPPORTED;
-			goto err_out;
+			goto out;
 		}
 		acpi_evaluate_hotplug_ost(handle, ACPI_NOTIFY_EJECT_REQUEST,
 					  ACPI_OST_SC_EJECT_IN_PROGRESS, NULL);
 		break;
-	default:
-		/* non-hotplug event; possibly handled by other handler */
+
+	case ACPI_NOTIFY_DEVICE_WAKE:
 		return;
+
+	case ACPI_NOTIFY_FREQUENCY_MISMATCH:
+		acpi_handle_err(handle, "Device cannot be configured due "
+				"to a frequency mismatch\n");
+		goto out;
+
+	case ACPI_NOTIFY_BUS_MODE_MISMATCH:
+		acpi_handle_err(handle, "Device cannot be configured due "
+				"to a bus mode mismatch\n");
+		goto out;
+
+	case ACPI_NOTIFY_POWER_FAULT:
+		acpi_handle_err(handle, "Device has suffered a power fault\n");
+		goto out;
+
+	default:
+		acpi_handle_warn(handle, "Unsupported event type 0x%x\n", type);
+		ost_code = ACPI_OST_SC_UNRECOGNIZED_NOTIFY;
+		goto out;
 	}
+
+	ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
 	adev = acpi_bus_get_acpi_device(handle);
 	if (!adev)
-		goto err_out;
+		goto out;
 
 	status = acpi_hotplug_execute(acpi_device_hotplug, adev, type);
 	if (ACPI_SUCCESS(status))
@@ -530,10 +571,22 @@ static void acpi_hotplug_notify_cb(acpi_
 
 	acpi_bus_put_acpi_device(adev);
 
- err_out:
+ out:
 	acpi_evaluate_hotplug_ost(handle, type, ost_code, NULL);
 }
 
+void acpi_install_hotplug_notify_handler(acpi_handle handle, void *data)
+{
+	acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
+				    acpi_hotplug_notify_cb, data);
+}
+
+void acpi_remove_hotplug_notify_handler(acpi_handle handle)
+{
+	acpi_remove_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
+				   acpi_hotplug_notify_cb);
+}
+
 static ssize_t real_power_state_show(struct device *dev,
 				     struct device_attribute *attr, char *buf)
 {
@@ -1976,33 +2029,21 @@ void acpi_scan_hotplug_enabled(struct ac
 	mutex_unlock(&acpi_scan_lock);
 }
 
-static void acpi_scan_init_hotplug(acpi_handle handle, int type)
+static void acpi_scan_init_hotplug(struct acpi_device *adev)
 {
-	struct acpi_device_pnp pnp = {};
 	struct acpi_hardware_id *hwid;
-	struct acpi_scan_handler *handler;
-
-	INIT_LIST_HEAD(&pnp.ids);
-	acpi_set_pnp_ids(handle, &pnp, type);
 
-	if (!pnp.type.hardware_id)
-		goto out;
+	list_for_each_entry(hwid, &adev->pnp.ids, list) {
+		struct acpi_scan_handler *handler;
 
-	/*
-	 * This relies on the fact that acpi_install_notify_handler() will not
-	 * install the same notify handler routine twice for the same handle.
-	 */
-	list_for_each_entry(hwid, &pnp.ids, list) {
 		handler = acpi_scan_match_handler(hwid->id, NULL);
-		if (handler) {
-			acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
-					acpi_hotplug_notify_cb, handler);
-			break;
-		}
-	}
+		if (!handler)
+			continue;
 
-out:
-	acpi_free_pnp_ids(&pnp);
+		acpi_install_hotplug_notify_handler(adev->handle, handler);
+		adev->flags.hotplug_notify = true;
+		break;
+	}
 }
 
 static acpi_status acpi_bus_check_add(acpi_handle handle, u32 lvl_not_used,
@@ -2026,12 +2067,12 @@ static acpi_status acpi_bus_check_add(ac
 		return AE_OK;
 	}
 
-	acpi_scan_init_hotplug(handle, type);
-
 	acpi_add_single_object(&device, handle, type, sta);
 	if (!device)
 		return AE_CTRL_DEPTH;
 
+	acpi_scan_init_hotplug(device);
+
  out:
 	if (!*return_value)
 		*return_value = device;
Index: linux-pm/drivers/pci/hotplug/acpiphp.h
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp.h
+++ linux-pm/drivers/pci/hotplug/acpiphp.h
@@ -116,12 +116,17 @@ struct acpiphp_func {
 };
 
 struct acpiphp_context {
+	struct acpi_hotplug_context hp;
 	struct acpiphp_func func;
-	struct acpi_device *adev;
 	struct acpiphp_bridge *bridge;
 	unsigned int refcount;
 };
 
+static inline struct acpiphp_context *to_acpiphp_context(struct acpi_hotplug_context *hp)
+{
+	return container_of(hp, struct acpiphp_context, hp);
+}
+
 static inline struct acpiphp_context *func_to_context(struct acpiphp_func *func)
 {
 	return container_of(func, struct acpiphp_context, func);
@@ -129,7 +134,7 @@ static inline struct acpiphp_context *fu
 
 static inline struct acpi_device *func_to_acpi_device(struct acpiphp_func *func)
 {
-	return func_to_context(func)->adev;
+	return func_to_context(func)->hp.self;
 }
 
 static inline acpi_handle func_to_handle(struct acpiphp_func *func)
Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -59,17 +59,12 @@
 static LIST_HEAD(bridge_list);
 static DEFINE_MUTEX(bridge_mutex);
 
-static void handle_hotplug_event(acpi_handle handle, u32 type, void *data);
+static int acpiphp_hotplug_event(struct acpi_device *adev, u32 type);
 static void acpiphp_sanitize_bus(struct pci_bus *bus);
 static void acpiphp_set_hpp_values(struct pci_bus *bus);
 static void hotplug_event(u32 type, struct acpiphp_context *context);
 static void free_bridge(struct kref *kref);
 
-static void acpiphp_context_handler(acpi_handle handle, void *context)
-{
-	/* Intentionally empty. */
-}
-
 /**
  * acpiphp_init_context - Create hotplug context and grab a reference to it.
  * @adev: ACPI device object to create the context for.
@@ -79,39 +74,31 @@ static void acpiphp_context_handler(acpi
 static struct acpiphp_context *acpiphp_init_context(struct acpi_device *adev)
 {
 	struct acpiphp_context *context;
-	acpi_status status;
 
 	context = kzalloc(sizeof(*context), GFP_KERNEL);
 	if (!context)
 		return NULL;
 
-	context->adev = adev;
 	context->refcount = 1;
-	status = acpi_attach_data(adev->handle, acpiphp_context_handler, context);
-	if (ACPI_FAILURE(status)) {
-		kfree(context);
-		return NULL;
-	}
+	acpi_set_hp_context(adev, &context->hp, acpiphp_hotplug_event);
 	return context;
 }
 
 /**
  * acpiphp_get_context - Get hotplug context and grab a reference to it.
- * @handle: ACPI object handle to get the context for.
+ * @adev: ACPI device object to get the context for.
  *
  * Call under acpi_hp_context_lock.
  */
-static struct acpiphp_context *acpiphp_get_context(acpi_handle handle)
+static struct acpiphp_context *acpiphp_get_context(struct acpi_device *adev)
 {
-	struct acpiphp_context *context = NULL;
-	acpi_status status;
-	void *data;
+	struct acpiphp_context *context;
 
-	status = acpi_get_data(handle, acpiphp_context_handler, &data);
-	if (ACPI_SUCCESS(status)) {
-		context = data;
-		context->refcount++;
-	}
+	if (!adev->hp)
+		return NULL;
+
+	context = to_acpiphp_context(adev->hp);
+	context->refcount++;
 	return context;
 }
 
@@ -129,7 +116,7 @@ static void acpiphp_put_context(struct a
 		return;
 
 	WARN_ON(context->bridge);
-	acpi_detach_data(context->adev->handle, acpiphp_context_handler);
+	context->hp.self->hp = NULL;
 	kfree(context);
 }
 
@@ -211,22 +198,13 @@ static void post_dock_fixups(acpi_handle
 
 static void dock_event(acpi_handle handle, u32 type, void *data)
 {
-	struct acpiphp_context *context;
+	struct acpi_device *adev;
 
-	acpi_lock_hp_context();
-	context = acpiphp_get_context(handle);
-	if (!context || WARN_ON(context->adev->handle != handle)
-	    || context->func.parent->is_going_away) {
-		acpi_unlock_hp_context();
-		return;
+	adev = acpi_bus_get_acpi_device(handle);
+	if (adev) {
+		acpiphp_hotplug_event(adev, type);
+		acpi_bus_put_acpi_device(adev);
 	}
-	get_bridge(context->func.parent);
-	acpiphp_put_context(context);
-	acpi_unlock_hp_context();
-
-	hotplug_event(type, context);
-
-	put_bridge(context->func.parent);
 }
 
 static const struct acpi_dock_ops acpiphp_dock_ops = {
@@ -397,25 +375,23 @@ static acpi_status register_slot(acpi_ha
 	}
 
 	/* install notify handler */
-	if (!(newfunc->flags & FUNC_HAS_DCK)) {
-		status = acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
-						     handle_hotplug_event,
-						     context);
-		if (ACPI_FAILURE(status))
-			acpi_handle_err(handle,
-					"failed to install notify handler\n");
-	}
+	if (!(newfunc->flags & FUNC_HAS_DCK))
+		acpi_install_hotplug_notify_handler(handle, NULL);
 
 	return AE_OK;
 }
 
 static struct acpiphp_bridge *acpiphp_handle_to_bridge(acpi_handle handle)
 {
+	struct acpi_device *adev = acpi_bus_get_acpi_device(handle);
 	struct acpiphp_context *context;
 	struct acpiphp_bridge *bridge = NULL;
 
+	if (!adev)
+		return NULL;
+
 	acpi_lock_hp_context();
-	context = acpiphp_get_context(handle);
+	context = acpiphp_get_context(adev);
 	if (context) {
 		bridge = context->bridge;
 		if (bridge)
@@ -424,6 +400,7 @@ static struct acpiphp_bridge *acpiphp_ha
 		acpiphp_put_context(context);
 	}
 	acpi_unlock_hp_context();
+	acpi_bus_put_acpi_device(adev);
 	return bridge;
 }
 
@@ -431,7 +408,6 @@ static void cleanup_bridge(struct acpiph
 {
 	struct acpiphp_slot *slot;
 	struct acpiphp_func *func;
-	acpi_status status;
 
 	list_for_each_entry(slot, &bridge->slots, node) {
 		list_for_each_entry(func, &slot->funcs, sibling) {
@@ -440,13 +416,8 @@ static void cleanup_bridge(struct acpiph
 			if (is_dock_device(handle))
 				unregister_hotplug_dock_device(handle);
 
-			if (!(func->flags & FUNC_HAS_DCK)) {
-				status = acpi_remove_notify_handler(handle,
-							ACPI_SYSTEM_NOTIFY,
-							handle_hotplug_event);
-				if (ACPI_FAILURE(status))
-					pr_err("failed to remove notify handler\n");
-			}
+			if (!(func->flags & FUNC_HAS_DCK))
+				acpi_remove_hotplug_notify_handler(handle);
 		}
 		slot->flags |= SLOT_IS_GOING_AWAY;
 		if (slot->slot)
@@ -814,7 +785,7 @@ static int acpiphp_disable_and_eject_slo
 
 static void hotplug_event(u32 type, struct acpiphp_context *context)
 {
-	acpi_handle handle = context->adev->handle;
+	acpi_handle handle = context->hp.self->handle;
 	struct acpiphp_func *func = &context->func;
 	struct acpiphp_slot *slot = func->slot;
 	struct acpiphp_bridge *bridge;
@@ -866,87 +837,24 @@ static void hotplug_event(u32 type, stru
 		put_bridge(bridge);
 }
 
-static void hotplug_event_work(void *data, u32 type)
-{
-	struct acpiphp_context *context = data;
-
-	acpi_scan_lock_acquire();
-
-	hotplug_event(type, context);
-
-	acpi_scan_lock_release();
-	acpi_evaluate_hotplug_ost(context->adev->handle, type,
-				  ACPI_OST_SC_SUCCESS, NULL);
-	put_bridge(context->func.parent);
-}
-
-/**
- * handle_hotplug_event - handle ACPI hotplug event
- * @handle: Notify()'ed acpi_handle
- * @type: Notify code
- * @data: pointer to acpiphp_context structure
- *
- * Handles ACPI event notification on slots.
- */
-static void handle_hotplug_event(acpi_handle handle, u32 type, void *data)
+static int acpiphp_hotplug_event(struct acpi_device *adev, u32 type)
 {
 	struct acpiphp_context *context;
-	u32 ost_code = ACPI_OST_SC_SUCCESS;
-	acpi_status status;
-
-	switch (type) {
-	case ACPI_NOTIFY_BUS_CHECK:
-	case ACPI_NOTIFY_DEVICE_CHECK:
-		break;
-	case ACPI_NOTIFY_EJECT_REQUEST:
-		ost_code = ACPI_OST_SC_EJECT_IN_PROGRESS;
-		acpi_evaluate_hotplug_ost(handle, type, ost_code, NULL);
-		break;
-
-	case ACPI_NOTIFY_DEVICE_WAKE:
-		return;
-
-	case ACPI_NOTIFY_FREQUENCY_MISMATCH:
-		acpi_handle_err(handle, "Device cannot be configured due "
-				"to a frequency mismatch\n");
-		goto out;
-
-	case ACPI_NOTIFY_BUS_MODE_MISMATCH:
-		acpi_handle_err(handle, "Device cannot be configured due "
-				"to a bus mode mismatch\n");
-		goto out;
-
-	case ACPI_NOTIFY_POWER_FAULT:
-		acpi_handle_err(handle, "Device has suffered a power fault\n");
-		goto out;
-
-	default:
-		acpi_handle_warn(handle, "Unsupported event type 0x%x\n", type);
-		ost_code = ACPI_OST_SC_UNRECOGNIZED_NOTIFY;
-		goto out;
-	}
 
 	acpi_lock_hp_context();
-	context = acpiphp_get_context(handle);
-	if (!context || WARN_ON(context->adev->handle != handle)
-	    || context->func.parent->is_going_away)
-		goto err_out;
-
-	get_bridge(context->func.parent);
-	acpiphp_put_context(context);
-	status = acpi_hotplug_execute(hotplug_event_work, context, type);
-	if (ACPI_SUCCESS(status)) {
+	context = acpiphp_get_context(adev);
+	if (!context || context->func.parent->is_going_away) {
 		acpi_unlock_hp_context();
-		return;
+		return -ENODATA;
 	}
-	put_bridge(context->func.parent);
-
- err_out:
+	get_bridge(context->func.parent);
+	acpiphp_put_context(context);
 	acpi_unlock_hp_context();
-	ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
 
- out:
-	acpi_evaluate_hotplug_ost(handle, type, ost_code, NULL);
+	hotplug_event(type, context);
+
+	put_bridge(context->func.parent);
+	return 0;
 }
 
 /**
@@ -999,7 +907,7 @@ void acpiphp_enumerate_slots(struct pci_
 		 * bridge is not interesting to us either.
 		 */
 		acpi_lock_hp_context();
-		context = acpiphp_get_context(handle);
+		context = acpiphp_get_context(adev);
 		if (!context) {
 			acpi_unlock_hp_context();
 			put_device(&bus->dev);
Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -137,6 +137,16 @@ struct acpi_scan_handler {
 };
 
 /*
+ * ACPI Hotplug Context
+ * --------------------
+ */
+
+struct acpi_hotplug_context {
+	struct acpi_device *self;
+	int (*event)(struct acpi_device *, u32);
+};
+
+/*
  * ACPI Driver
  * -----------
  */
@@ -190,7 +200,8 @@ struct acpi_device_flags {
 	u32 initialized:1;
 	u32 visited:1;
 	u32 no_hotplug:1;
-	u32 reserved:24;
+	u32 hotplug_notify:1;
+	u32 reserved:23;
 };
 
 /* File System */
@@ -329,6 +340,7 @@ struct acpi_device {
 	struct acpi_device_perf performance;
 	struct acpi_device_dir dir;
 	struct acpi_scan_handler *handler;
+	struct acpi_hotplug_context *hp;
 	struct acpi_driver *driver;
 	void *driver_data;
 	struct device dev;
@@ -351,6 +363,15 @@ static inline void acpi_set_device_statu
 	*((u32 *)&adev->status) = sta;
 }
 
+static inline void acpi_set_hp_context(struct acpi_device *adev,
+				       struct acpi_hotplug_context *hp,
+				       int (*event)(struct acpi_device *, u32))
+{
+	hp->self = adev;
+	hp->event = event;
+	adev->hp = hp;
+}
+
 /* acpi_device.dev.bus == &acpi_bus_type */
 extern struct bus_type acpi_bus_type;
 
@@ -425,6 +446,8 @@ static inline bool acpi_device_enumerate
 typedef void (*acpi_hp_callback)(void *data, u32 src);
 
 acpi_status acpi_hotplug_execute(acpi_hp_callback func, void *data, u32 src);
+void acpi_install_hotplug_notify_handler(acpi_handle handle, void *data);
+void acpi_remove_hotplug_notify_handler(acpi_handle handle);
 
 /**
  * module_acpi_driver(acpi_driver) - Helper macro for registering an ACPI driver

