Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273AbaBBRHQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 12:07:16 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:64459 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751912AbaBBRGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 12:06:24 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Robert Moore <robert.moore@intel.com>
Subject: [PATCH v3 4/7] ACPI / hotplug / PCI: Consolidate ACPIPHP with ACPI core hotplug
Date: Sun, 02 Feb 2014 18:17:52 +0100
Message-ID: <1441263.4NcvkvWEG5@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <5157096.hCmU2aoKCT@vostro.rjw.lan>
References: <2217793.001RY6hKlo@vostro.rjw.lan> <1519631.YS65c9Af2C@vostro.rjw.lan> <5157096.hCmU2aoKCT@vostro.rjw.lan>
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
Moreover, it's vulnerable to a theoretical issue that the ACPI
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
device objects associated with PCI devices and use the generic
ACPI device hotplug code for device objects with scan handlers
attached to them.

This allows the existing code duplication between ACPIPHP and the
ACPI core to be reduced too and makes further ACPI-based device
hotplug consolidation possible.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c                |  106 +++++++++++++++++++++-------
 drivers/pci/hotplug/acpiphp.h      |    9 +-
 drivers/pci/hotplug/acpiphp_glue.c |  136 +++++++------------------------------
 include/acpi/acpi_bus.h            |   22 +++++
 4 files changed, 136 insertions(+), 137 deletions(-)

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
+	if (adev->handler) {
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
 
@@ -503,25 +521,48 @@ static void acpi_hotplug_notify_cb(acpi_
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
 	if (acpi_bus_get_acpi_device(handle, &adev))
-		goto err_out;
+		goto out;
 
 	status = acpi_hotplug_execute(acpi_device_hotplug, adev, type);
 	if (ACPI_SUCCESS(status))
@@ -529,10 +570,22 @@ static void acpi_hotplug_notify_cb(acpi_
 
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
@@ -1991,8 +2044,7 @@ static void acpi_scan_init_hotplug(acpi_
 	list_for_each_entry(hwid, &pnp.ids, list) {
 		handler = acpi_scan_match_handler(hwid->id, NULL);
 		if (handler) {
-			acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
-					acpi_hotplug_notify_cb, handler);
+			acpi_install_hotplug_notify_handler(handle, handler);
 			break;
 		}
 	}
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
 static void hotplug_event(u32 type, void *data);
 static void free_bridge(struct kref *kref);
 
-static void acpiphp_context_handler(acpi_handle handle, void *context)
-{
-	/* Intentionally empty. */
-}
-
 /**
  * acpiphp_init_context - Create hotplug context and grab a reference to it.
  * @adev: ACPI device object to create the context for.
@@ -79,39 +74,27 @@ static void acpiphp_context_handler(acpi
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
+	struct acpiphp_context *context = to_acpiphp_context(adev->hp);
 
-	status = acpi_get_data(handle, acpiphp_context_handler, &data);
-	if (ACPI_SUCCESS(status)) {
-		context = data;
-		context->refcount++;
-	}
+	context->refcount++;
 	return context;
 }
 
@@ -129,7 +112,7 @@ static void acpiphp_put_context(struct a
 		return;
 
 	WARN_ON(context->bridge);
-	acpi_detach_data(context->adev->handle, acpiphp_context_handler);
+	context->hp.self->hp = NULL;
 	kfree(context);
 }
 
@@ -378,14 +361,8 @@ static acpi_status register_slot(acpi_ha
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
@@ -394,9 +371,13 @@ static struct acpiphp_bridge *acpiphp_ha
 {
 	struct acpiphp_context *context;
 	struct acpiphp_bridge *bridge = NULL;
+	struct acpi_device *adev;
+
+	if (acpi_bus_get_device(handle, &adev))
+		return NULL;
 
 	acpi_lock_hp_context();
-	context = acpiphp_get_context(handle);
+	context = acpiphp_get_context(adev);
 	if (context) {
 		bridge = context->bridge;
 		if (bridge)
@@ -412,7 +393,6 @@ static void cleanup_bridge(struct acpiph
 {
 	struct acpiphp_slot *slot;
 	struct acpiphp_func *func;
-	acpi_status status;
 
 	list_for_each_entry(slot, &bridge->slots, node) {
 		list_for_each_entry(func, &slot->funcs, sibling) {
@@ -421,13 +401,8 @@ static void cleanup_bridge(struct acpiph
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
@@ -792,7 +767,7 @@ static void hotplug_event(u32 type, void
 	struct acpiphp_context *context = data;
 	struct acpiphp_func *func = &context->func;
 	struct acpiphp_slot *slot = func->slot;
-	acpi_handle handle = context->adev->handle;
+	acpi_handle handle = context->hp.self->handle;
 	struct acpiphp_bridge *bridge;
 
 	acpi_lock_hp_context();
@@ -842,79 +817,24 @@ static void hotplug_event(u32 type, void
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
-	if (context && !WARN_ON(context->adev->handle != handle)) {
-		get_bridge(context->func.parent);
-		acpiphp_put_context(context);
-		acpi_hotplug_execute(hotplug_event_work, context, type);
+	context = acpiphp_get_context(adev);
+	if (!context) {
 		acpi_unlock_hp_context();
-		return;
+		return -ENODATA;
 	}
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
@@ -967,7 +887,7 @@ void acpiphp_enumerate_slots(struct pci_
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
@@ -329,6 +339,7 @@ struct acpi_device {
 	struct acpi_device_perf performance;
 	struct acpi_device_dir dir;
 	struct acpi_scan_handler *handler;
+	struct acpi_hotplug_context *hp;
 	struct acpi_driver *driver;
 	void *driver_data;
 	struct device dev;
@@ -351,6 +362,15 @@ static inline void acpi_set_device_statu
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
 
@@ -423,6 +443,8 @@ static inline bool acpi_device_enumerate
 typedef void (*acpi_hp_callback)(void *data, u32 src);
 
 acpi_status acpi_hotplug_execute(acpi_hp_callback func, void *data, u32 src);
+void acpi_install_hotplug_notify_handler(acpi_handle handle, void *data);
+void acpi_remove_hotplug_notify_handler(acpi_handle handle);
 
 /**
  * module_acpi_driver(acpi_driver) - Helper macro for registering an ACPI driver

