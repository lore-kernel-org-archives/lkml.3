Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbaBSBUC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 20:20:02 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:64082 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752128AbaBSBSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 20:18:33 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux PCI <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Tejun Heo <tj@kernel.org>,
        Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH 4/9] ACPI / dock: Use callback pointers from devices' ACPI hotplug contexts
Date: Wed, 19 Feb 2014 02:29:23 +0100
Message-ID: <1472780.lDZ1hkyq2L@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <3011875.q18rCmXyYX@vostro.rjw.lan>
References: <3011875.q18rCmXyYX@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Instead of requiring a set of special dock operations to be registered
via register_hotplug_dock_device() for each ACPI dock device, it is
much more straightforward to use callback pointers from the devices'
hotplug contexts if available.

For this reason, modify dock_hotplug_event() to use callback pointers
from the hotplug contexts of ACPI devices and fall back to using the
special dock operarions only if those callbacks are missing.  Also
make the ACPI-based PCI hotplug (ACPIPHP) subsystem set the .fixup
callback pointer in the hotplug contexts of devices handled by it to
a new function, acpiphp_post_dock_fixup(), so that the dock station
driver can use the callbacks from those contexts instead of special
dock operations registered via register_hotplug_dock_device().

Along with the above changes drop the ACPIPHP's dock operations that
are not necessary any more.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/dock.c                |   29 +++++++++
 drivers/pci/hotplug/acpiphp_glue.c |  119 +++++++++++++++----------------------
 2 files changed, 78 insertions(+), 70 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -60,6 +60,7 @@ static LIST_HEAD(bridge_list);
 static DEFINE_MUTEX(bridge_mutex);
 
 static int acpiphp_hotplug_event(struct acpi_device *adev, u32 type);
+static void acpiphp_post_dock_fixup(struct acpi_device *adev);
 static void acpiphp_sanitize_bus(struct pci_bus *bus);
 static void acpiphp_set_hpp_values(struct pci_bus *bus);
 static void hotplug_event(u32 type, struct acpiphp_context *context);
@@ -80,7 +81,8 @@ static struct acpiphp_context *acpiphp_i
 		return NULL;
 
 	context->refcount = 1;
-	acpi_set_hp_context(adev, &context->hp, acpiphp_hotplug_event, NULL);
+	acpi_set_hp_context(adev, &context->hp, acpiphp_hotplug_event,
+			    acpiphp_post_dock_fixup);
 	return context;
 }
 
@@ -130,6 +132,27 @@ static inline void put_bridge(struct acp
 	kref_put(&bridge->ref, free_bridge);
 }
 
+static struct acpiphp_context *acpiphp_grab_context(struct acpi_device *adev)
+{
+	struct acpiphp_context *context;
+
+	acpi_lock_hp_context();
+	context = acpiphp_get_context(adev);
+	if (!context || context->func.parent->is_going_away) {
+		acpi_unlock_hp_context();
+		return NULL;
+	}
+	get_bridge(context->func.parent);
+	acpiphp_put_context(context);
+	acpi_unlock_hp_context();
+	return context;
+}
+
+static void acpiphp_let_context_go(struct acpiphp_context *context)
+{
+	put_bridge(context->func.parent);
+}
+
 static void free_bridge(struct kref *kref)
 {
 	struct acpiphp_context *context;
@@ -164,28 +187,29 @@ static void free_bridge(struct kref *kre
 	acpi_unlock_hp_context();
 }
 
-/*
- * the _DCK method can do funny things... and sometimes not
- * hah-hah funny.
+/**
+ * acpiphp_post_dock_fixup - Post-dock fixups for PCI devices.
+ * @adev: ACPI device object corresponding to a PCI device.
  *
- * TBD - figure out a way to only call fixups for
- * systems that require them.
+ * TBD - figure out a way to only call fixups for systems that require them.
  */
-static void post_dock_fixups(acpi_handle not_used, u32 event, void *data)
+static void acpiphp_post_dock_fixup(struct acpi_device *adev)
 {
-	struct acpiphp_context *context = data;
-	struct pci_bus *bus = context->func.slot->bus;
+	struct acpiphp_context *context = acpiphp_grab_context(adev);
+	struct pci_bus *bus;
 	u32 buses;
 
-	if (!bus->self)
+	if (!context)
 		return;
 
+	bus = context->func.slot->bus;
+	if (!bus->self)
+		goto out;
+
 	/* fixup bad _DCK function that rewrites
 	 * secondary bridge on slot
 	 */
-	pci_read_config_dword(bus->self,
-			PCI_PRIMARY_BUS,
-			&buses);
+	pci_read_config_dword(bus->self, PCI_PRIMARY_BUS, &buses);
 
 	if (((buses >> 8) & 0xff) != bus->busn_res.start) {
 		buses = (buses & 0xff000000)
@@ -194,24 +218,11 @@ static void post_dock_fixups(acpi_handle
 			| ((unsigned int)(bus->busn_res.end) << 16);
 		pci_write_config_dword(bus->self, PCI_PRIMARY_BUS, buses);
 	}
-}
 
-static void dock_event(acpi_handle handle, u32 type, void *data)
-{
-	struct acpi_device *adev;
-
-	adev = acpi_bus_get_acpi_device(handle);
-	if (adev) {
-		acpiphp_hotplug_event(adev, type);
-		acpi_bus_put_acpi_device(adev);
-	}
+ out:
+	acpiphp_let_context_go(context);
 }
 
-static const struct acpi_dock_ops acpiphp_dock_ops = {
-	.fixup = post_dock_fixups,
-	.handler = dock_event,
-};
-
 /* Check whether the PCI device is managed by native PCIe hotplug driver */
 static bool device_is_managed_by_native_pciehp(struct pci_dev *pdev)
 {
@@ -241,20 +252,6 @@ static bool device_is_managed_by_native_
 	return true;
 }
 
-static void acpiphp_dock_init(void *data)
-{
-	struct acpiphp_context *context = data;
-
-	get_bridge(context->func.parent);
-}
-
-static void acpiphp_dock_release(void *data)
-{
-	struct acpiphp_context *context = data;
-
-	put_bridge(context->func.parent);
-}
-
 /**
  * acpiphp_add_context - Add ACPIPHP context to an ACPI device object.
  * @handle: ACPI handle of the object to add a context to.
@@ -300,15 +297,18 @@ static acpi_status acpiphp_add_context(a
 	newfunc = &context->func;
 	newfunc->function = function;
 	newfunc->parent = bridge;
+	acpi_unlock_hp_context();
 
-	if (acpi_has_method(handle, "_EJ0"))
+	/*
+	 * If this is a dock device, its _EJ0 should be executed by the dock
+	 * notify handler after calling _DCK.
+	 */
+	if (!is_dock_device(adev) && acpi_has_method(handle, "_EJ0"))
 		newfunc->flags = FUNC_HAS_EJ0;
 
 	if (acpi_has_method(handle, "_STA"))
 		newfunc->flags |= FUNC_HAS_STA;
 
-	acpi_unlock_hp_context();
-
 	/* search for objects that share the same slot */
 	list_for_each_entry(slot, &bridge->slots, node)
 		if (slot->device == device)
@@ -369,18 +369,6 @@ static acpi_status acpiphp_add_context(a
 				       &val, 60*1000))
 		slot->flags |= SLOT_ENABLED;
 
-	if (is_dock_device(adev)) {
-		/* we don't want to call this device's _EJ0
-		 * because we want the dock notify handler
-		 * to call it after it calls _DCK
-		 */
-		newfunc->flags &= ~FUNC_HAS_EJ0;
-		if (register_hotplug_dock_device(handle,
-			&acpiphp_dock_ops, context,
-			acpiphp_dock_init, acpiphp_dock_release))
-			pr_debug("failed to register dock device\n");
-	}
-
 	return AE_OK;
 }
 
@@ -411,11 +399,9 @@ static void cleanup_bridge(struct acpiph
 		list_for_each_entry(func, &slot->funcs, sibling) {
 			struct acpi_device *adev = func_to_acpi_device(func);
 
-			if (is_dock_device(adev))
-				unregister_hotplug_dock_device(adev->handle);
-
 			acpi_lock_hp_context();
 			adev->hp->event = NULL;
+			adev->hp->fixup = NULL;
 			acpi_unlock_hp_context();
 		}
 		slot->flags |= SLOT_IS_GOING_AWAY;
@@ -851,19 +837,12 @@ static int acpiphp_hotplug_event(struct
 {
 	struct acpiphp_context *context;
 
-	acpi_lock_hp_context();
-	context = acpiphp_get_context(adev);
-	if (!context || context->func.parent->is_going_away) {
-		acpi_unlock_hp_context();
+	context = acpiphp_grab_context(adev);
+	if (!context)
 		return -ENODATA;
-	}
-	get_bridge(context->func.parent);
-	acpiphp_put_context(context);
-	acpi_unlock_hp_context();
 
 	hotplug_event(type, context);
-
-	put_bridge(context->func.parent);
+	acpiphp_let_context_go(context);
 	return 0;
 }
 
Index: linux-pm/drivers/acpi/dock.c
===================================================================
--- linux-pm.orig/drivers/acpi/dock.c
+++ linux-pm/drivers/acpi/dock.c
@@ -185,9 +185,38 @@ static void dock_release_hotplug(struct
 static void dock_hotplug_event(struct dock_dependent_device *dd, u32 event,
 			       enum dock_callback_type cb_type)
 {
+	struct acpi_device *adev = dd->adev;
 	acpi_notify_handler cb = NULL;
 	bool run = false;
 
+	acpi_lock_hp_context();
+
+	if (!adev->hp)
+		goto no_context;
+
+	if (cb_type == DOCK_CALL_FIXUP) {
+		void (*fixup)(struct acpi_device *);
+
+		fixup = adev->hp->fixup;
+		if (fixup) {
+			acpi_unlock_hp_context();
+			fixup(adev);
+			return;
+		}
+	} else {
+		int (*notify)(struct acpi_device *, u32);
+
+		notify = adev->hp->event;
+		if (notify) {
+			acpi_unlock_hp_context();
+			notify(adev, event);
+			return;
+		}
+	}
+
+ no_context:
+	acpi_unlock_hp_context();
+
 	mutex_lock(&hotplug_lock);
 
 	if (dd->hp_context) {

