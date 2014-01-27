Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbaA0Ac1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 19:32:27 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56485 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753415AbaA0AcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 19:32:22 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5/11] ACPI / hotplug / PCI: Store acpi_device pointer in acpiphp_context
Date: Mon, 27 Jan 2014 01:41:17 +0100
Message-ID: <2392255.TACRzd2AD0@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <2217793.001RY6hKlo@vostro.rjw.lan>
References: <2217793.001RY6hKlo@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

After recent modifications of the ACPI core making it create a struct
acpi_device object for every namespace node representing a device
regardless of the current status of that device the ACPIPHP code
can store a struct acpi_device pointer instead of an ACPI handle
in struct acpiphp_context.  This immediately makes it possible to
avoid making potentially costly calls to acpi_bus_get_device() in
two places and allows some more simplifications to be made going
forward.

The reason why that is correct is because ACPIPHP only installs
hotify handlers for namespace nodes that exist when
acpiphp_enumerate_slots() is called for their parent bridge.
That only happens if the parent bridge has an ACPI companion
associated with it, which means that the ACPI namespace scope
in question has been scanned already at that point.  That, in
turn, means that struct acpi_device objects have been created
for all namespace nodes in that scope and pointers to those
objects can be stored directly instead of their ACPI handles.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp.h      |    9 +++++--
 drivers/pci/hotplug/acpiphp_glue.c |   44 +++++++++++++++++--------------------
 2 files changed, 28 insertions(+), 25 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp.h
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp.h
+++ linux-pm/drivers/pci/hotplug/acpiphp.h
@@ -117,8 +117,8 @@ struct acpiphp_func {
 };
 
 struct acpiphp_context {
-	acpi_handle handle;
 	struct acpiphp_func func;
+	struct acpi_device *adev;
 	struct acpiphp_bridge *bridge;
 	unsigned int refcount;
 };
@@ -128,9 +128,14 @@ static inline struct acpiphp_context *fu
 	return container_of(func, struct acpiphp_context, func);
 }
 
+static inline struct acpi_device *func_to_acpi_device(struct acpiphp_func *func)
+{
+	return func_to_context(func)->adev;
+}
+
 static inline acpi_handle func_to_handle(struct acpiphp_func *func)
 {
-	return func_to_context(func)->handle;
+	return func_to_acpi_device(func)->handle;
 }
 
 /*
Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -73,11 +73,11 @@ static void acpiphp_context_handler(acpi
 
 /**
  * acpiphp_init_context - Create hotplug context and grab a reference to it.
- * @handle: ACPI object handle to create the context for.
+ * @adev: ACPI device object to create the context for.
  *
  * Call under acpiphp_context_lock.
  */
-static struct acpiphp_context *acpiphp_init_context(acpi_handle handle)
+static struct acpiphp_context *acpiphp_init_context(struct acpi_device *adev)
 {
 	struct acpiphp_context *context;
 	acpi_status status;
@@ -86,9 +86,9 @@ static struct acpiphp_context *acpiphp_i
 	if (!context)
 		return NULL;
 
-	context->handle = handle;
+	context->adev = adev;
 	context->refcount = 1;
-	status = acpi_attach_data(handle, acpiphp_context_handler, context);
+	status = acpi_attach_data(adev->handle, acpiphp_context_handler, context);
 	if (ACPI_FAILURE(status)) {
 		kfree(context);
 		return NULL;
@@ -118,7 +118,7 @@ static struct acpiphp_context *acpiphp_g
 
 /**
  * acpiphp_put_context - Drop a reference to ACPI hotplug context.
- * @handle: ACPI object handle to put the context for.
+ * @context: ACPI hotplug context to drop a reference to.
  *
  * The context object is removed if there are no more references to it.
  *
@@ -130,7 +130,7 @@ static void acpiphp_put_context(struct a
 		return;
 
 	WARN_ON(context->bridge);
-	acpi_detach_data(context->handle, acpiphp_context_handler);
+	acpi_detach_data(context->adev->handle, acpiphp_context_handler);
 	kfree(context);
 }
 
@@ -265,6 +265,7 @@ static acpi_status register_slot(acpi_ha
 {
 	struct acpiphp_bridge *bridge = data;
 	struct acpiphp_context *context;
+	struct acpi_device *adev;
 	struct acpiphp_slot *slot;
 	struct acpiphp_func *newfunc;
 	acpi_status status = AE_OK;
@@ -284,12 +285,14 @@ static acpi_status register_slot(acpi_ha
 				"can't evaluate _ADR (%#x)\n", status);
 		return AE_OK;
 	}
+	if (acpi_bus_get_device(handle, &adev))
+		return AE_OK;
 
 	device = (adr >> 16) & 0xffff;
 	function = adr & 0xffff;
 
 	mutex_lock(&acpiphp_context_lock);
-	context = acpiphp_init_context(handle);
+	context = acpiphp_init_context(adev);
 	if (!context) {
 		mutex_unlock(&acpiphp_context_lock);
 		acpi_handle_err(handle, "No hotplug context\n");
@@ -625,12 +628,8 @@ static void disable_slot(struct acpiphp_
 		pci_dev_put(pdev);
 	}
 
-	list_for_each_entry(func, &slot->funcs, sibling) {
-		struct acpi_device *adev;
-
-		if (!acpi_bus_get_device(func_to_handle(func), &adev))
-			acpi_bus_trim(adev);
-	}
+	list_for_each_entry(func, &slot->funcs, sibling)
+		acpi_bus_trim(func_to_acpi_device(func));
 
 	slot->flags &= (~SLOT_ENABLED);
 }
@@ -644,13 +643,10 @@ static bool slot_no_hotplug(struct acpip
 {
 	struct acpiphp_func *func;
 
-	list_for_each_entry(func, &slot->funcs, sibling) {
-		struct acpi_device *adev = NULL;
-
-		acpi_bus_get_device(func_to_handle(func), &adev);
-		if (acpiphp_no_hotplug(adev))
+	list_for_each_entry(func, &slot->funcs, sibling)
+		if (acpiphp_no_hotplug(func_to_acpi_device(func)))
 			return true;
-	}
+
 	return false;
 }
 
@@ -899,7 +895,7 @@ static void hotplug_event(acpi_handle ha
 static void hotplug_event_work(void *data, u32 type)
 {
 	struct acpiphp_context *context = data;
-	acpi_handle handle = context->handle;
+	acpi_handle handle = context->adev->handle;
 
 	acpi_scan_lock_acquire();
 	pci_lock_rescan_remove();
@@ -959,7 +955,7 @@ static void handle_hotplug_event(acpi_ha
 
 	mutex_lock(&acpiphp_context_lock);
 	context = acpiphp_get_context(handle);
-	if (context && !WARN_ON(context->handle != handle)) {
+	if (context && !WARN_ON(context->adev->handle != handle)) {
 		get_bridge(context->func.parent);
 		acpiphp_put_context(context);
 		acpi_hotplug_execute(hotplug_event_work, context, type);
@@ -983,16 +979,18 @@ static void handle_hotplug_event(acpi_ha
 void acpiphp_enumerate_slots(struct pci_bus *bus)
 {
 	struct acpiphp_bridge *bridge;
+	struct acpi_device *adev;
 	acpi_handle handle;
 	acpi_status status;
 
 	if (acpiphp_disabled)
 		return;
 
-	handle = ACPI_HANDLE(bus->bridge);
-	if (!handle)
+	adev = ACPI_COMPANION(bus->bridge);
+	if (!adev)
 		return;
 
+	handle = adev->handle;
 	bridge = kzalloc(sizeof(struct acpiphp_bridge), GFP_KERNEL);
 	if (!bridge) {
 		acpi_handle_err(handle, "No memory for bridge object\n");

