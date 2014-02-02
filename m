Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431AbaBBRHX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 12:07:23 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:49424 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752005AbaBBRG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 12:06:26 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Robert Moore <robert.moore@intel.com>
Subject: [PATCH v3 3/7] ACPI / hotplug / PCI: Define hotplug context lock in the core
Date: Sun, 02 Feb 2014 18:16:47 +0100
Message-ID: <2157717.5XCedcge0O@vostro.rjw.lan>
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

Subsequent changes will require the ACPI core to acquire the lock
protecting the ACPIPHP hotplug contexts, so move the definition of
the lock to the core and change its name to be more generic.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c                |   11 +++++++++
 drivers/pci/hotplug/acpiphp_glue.c |   41 ++++++++++++++++++-------------------
 include/acpi/acpi_bus.h            |    2 +
 3 files changed, 33 insertions(+), 21 deletions(-)

Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -41,6 +41,7 @@ static DEFINE_MUTEX(acpi_scan_lock);
 static LIST_HEAD(acpi_scan_handlers_list);
 DEFINE_MUTEX(acpi_device_lock);
 LIST_HEAD(acpi_wakeup_device_list);
+static DEFINE_MUTEX(acpi_hp_context_lock);
 
 struct acpi_device_bus_id{
 	char bus_id[15];
@@ -60,6 +61,16 @@ void acpi_scan_lock_release(void)
 }
 EXPORT_SYMBOL_GPL(acpi_scan_lock_release);
 
+void acpi_lock_hp_context(void)
+{
+	mutex_lock(&acpi_hp_context_lock);
+}
+
+void acpi_unlock_hp_context(void)
+{
+	mutex_unlock(&acpi_hp_context_lock);
+}
+
 int acpi_scan_add_handler(struct acpi_scan_handler *handler)
 {
 	if (!handler || !handler->attach)
Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -58,7 +58,6 @@
 
 static LIST_HEAD(bridge_list);
 static DEFINE_MUTEX(bridge_mutex);
-static DEFINE_MUTEX(acpiphp_context_lock);
 
 static void handle_hotplug_event(acpi_handle handle, u32 type, void *data);
 static void acpiphp_sanitize_bus(struct pci_bus *bus);
@@ -75,7 +74,7 @@ static void acpiphp_context_handler(acpi
  * acpiphp_init_context - Create hotplug context and grab a reference to it.
  * @adev: ACPI device object to create the context for.
  *
- * Call under acpiphp_context_lock.
+ * Call under acpi_hp_context_lock.
  */
 static struct acpiphp_context *acpiphp_init_context(struct acpi_device *adev)
 {
@@ -100,7 +99,7 @@ static struct acpiphp_context *acpiphp_i
  * acpiphp_get_context - Get hotplug context and grab a reference to it.
  * @handle: ACPI object handle to get the context for.
  *
- * Call under acpiphp_context_lock.
+ * Call under acpi_hp_context_lock.
  */
 static struct acpiphp_context *acpiphp_get_context(acpi_handle handle)
 {
@@ -122,7 +121,7 @@ static struct acpiphp_context *acpiphp_g
  *
  * The context object is removed if there are no more references to it.
  *
- * Call under acpiphp_context_lock.
+ * Call under acpi_hp_context_lock.
  */
 static void acpiphp_put_context(struct acpiphp_context *context)
 {
@@ -151,7 +150,7 @@ static void free_bridge(struct kref *kre
 	struct acpiphp_slot *slot, *next;
 	struct acpiphp_func *func, *tmp;
 
-	mutex_lock(&acpiphp_context_lock);
+	acpi_lock_hp_context();
 
 	bridge = container_of(kref, struct acpiphp_bridge, ref);
 
@@ -175,7 +174,7 @@ static void free_bridge(struct kref *kre
 	pci_dev_put(bridge->pci_dev);
 	kfree(bridge);
 
-	mutex_unlock(&acpiphp_context_lock);
+	acpi_unlock_hp_context();
 }
 
 /*
@@ -291,17 +290,17 @@ static acpi_status register_slot(acpi_ha
 	device = (adr >> 16) & 0xffff;
 	function = adr & 0xffff;
 
-	mutex_lock(&acpiphp_context_lock);
+	acpi_lock_hp_context();
 	context = acpiphp_init_context(adev);
 	if (!context) {
-		mutex_unlock(&acpiphp_context_lock);
+		acpi_unlock_hp_context();
 		acpi_handle_err(handle, "No hotplug context\n");
 		return AE_NOT_EXIST;
 	}
 	newfunc = &context->func;
 	newfunc->function = function;
 	newfunc->parent = bridge;
-	mutex_unlock(&acpiphp_context_lock);
+	acpi_unlock_hp_context();
 
 	if (acpi_has_method(handle, "_EJ0"))
 		newfunc->flags = FUNC_HAS_EJ0;
@@ -319,9 +318,9 @@ static acpi_status register_slot(acpi_ha
 
 	slot = kzalloc(sizeof(struct acpiphp_slot), GFP_KERNEL);
 	if (!slot) {
-		mutex_lock(&acpiphp_context_lock);
+		acpi_lock_hp_context();
 		acpiphp_put_context(context);
-		mutex_unlock(&acpiphp_context_lock);
+		acpi_unlock_hp_context();
 		return AE_NO_MEMORY;
 	}
 
@@ -396,7 +395,7 @@ static struct acpiphp_bridge *acpiphp_ha
 	struct acpiphp_context *context;
 	struct acpiphp_bridge *bridge = NULL;
 
-	mutex_lock(&acpiphp_context_lock);
+	acpi_lock_hp_context();
 	context = acpiphp_get_context(handle);
 	if (context) {
 		bridge = context->bridge;
@@ -405,7 +404,7 @@ static struct acpiphp_bridge *acpiphp_ha
 
 		acpiphp_put_context(context);
 	}
-	mutex_unlock(&acpiphp_context_lock);
+	acpi_unlock_hp_context();
 	return bridge;
 }
 
@@ -796,12 +795,12 @@ static void hotplug_event(u32 type, void
 	acpi_handle handle = context->adev->handle;
 	struct acpiphp_bridge *bridge;
 
-	mutex_lock(&acpiphp_context_lock);
+	acpi_lock_hp_context();
 	bridge = context->bridge;
 	if (bridge)
 		get_bridge(bridge);
 
-	mutex_unlock(&acpiphp_context_lock);
+	acpi_unlock_hp_context();
 
 	pci_lock_rescan_remove();
 
@@ -902,16 +901,16 @@ static void handle_hotplug_event(acpi_ha
 		goto out;
 	}
 
-	mutex_lock(&acpiphp_context_lock);
+	acpi_lock_hp_context();
 	context = acpiphp_get_context(handle);
 	if (context && !WARN_ON(context->adev->handle != handle)) {
 		get_bridge(context->func.parent);
 		acpiphp_put_context(context);
 		acpi_hotplug_execute(hotplug_event_work, context, type);
-		mutex_unlock(&acpiphp_context_lock);
+		acpi_unlock_hp_context();
 		return;
 	}
-	mutex_unlock(&acpiphp_context_lock);
+	acpi_unlock_hp_context();
 	ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
 
  out:
@@ -967,10 +966,10 @@ void acpiphp_enumerate_slots(struct pci_
 		 * parent is going to be handled by pciehp, in which case this
 		 * bridge is not interesting to us either.
 		 */
-		mutex_lock(&acpiphp_context_lock);
+		acpi_lock_hp_context();
 		context = acpiphp_get_context(handle);
 		if (!context) {
-			mutex_unlock(&acpiphp_context_lock);
+			acpi_unlock_hp_context();
 			put_device(&bus->dev);
 			pci_dev_put(bridge->pci_dev);
 			kfree(bridge);
@@ -980,7 +979,7 @@ void acpiphp_enumerate_slots(struct pci_
 		context->bridge = bridge;
 		/* Get a reference to the parent bridge. */
 		get_bridge(context->func.parent);
-		mutex_unlock(&acpiphp_context_lock);
+		acpi_unlock_hp_context();
 	}
 
 	/* must be added to the list prior to calling register_slot */
Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -402,6 +402,8 @@ static inline bool acpi_bus_can_wakeup(a
 
 void acpi_scan_lock_acquire(void);
 void acpi_scan_lock_release(void);
+void acpi_lock_hp_context(void);
+void acpi_unlock_hp_context(void);
 int acpi_scan_add_handler(struct acpi_scan_handler *handler);
 int acpi_bus_register_driver(struct acpi_driver *driver);
 void acpi_bus_unregister_driver(struct acpi_driver *driver);

