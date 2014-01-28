Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379AbaA1WHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 17:07:24 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56948 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932253AbaA1WFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 17:05:35 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 1/5][RFT] ACPI / hotplug / PCI: Attach hotplug contexts to struct acpi_device
Date: Tue, 28 Jan 2014 23:12:45 +0100
Message-ID: <2254246.sgjtYXNFrG@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <1508034.JFmpIOzjVZ@vostro.rjw.lan>
References: <2217793.001RY6hKlo@vostro.rjw.lan> <1508034.JFmpIOzjVZ@vostro.rjw.lan>
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

For this reason, modify the code to attach the ACPIPHP's device
hotplug contexts to struct device objects representing hotplug
devices.

This also allows further consolidation of the ACPI hotplug code
to be carried out in subsequent changesets.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c                |    3 +
 drivers/pci/hotplug/acpiphp.h      |    9 ++-
 drivers/pci/hotplug/acpiphp_glue.c |   99 ++++++++++++++++++++++---------------
 include/acpi/acpi_bus.h            |   11 ++++
 4 files changed, 80 insertions(+), 42 deletions(-)

Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -139,6 +139,16 @@ struct acpi_scan_handler {
 };
 
 /*
+ * ACPI Hotplug Context
+ * --------------------
+ */
+
+struct acpi_hotplug_context {
+	struct acpi_device *self;
+	void (*release)(struct acpi_hotplug_context *);
+};
+
+/*
  * ACPI Driver
  * -----------
  */
@@ -331,6 +341,7 @@ struct acpi_device {
 	struct acpi_device_perf performance;
 	struct acpi_device_dir dir;
 	struct acpi_scan_handler *handler;
+	struct acpi_hotplug_context *hp;
 	struct acpi_driver *driver;
 	void *driver_data;
 	struct device dev;
Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -1063,6 +1063,9 @@ static void acpi_device_del_work_fn(stru
 		mutex_unlock(&acpi_device_del_lock);
 
 		acpi_device_del(adev);
+		if (adev->hp && adev->hp->release)
+			adev->hp->release(adev->hp);
+
 		/*
 		 * Drop references to all power resources that might have been
 		 * used by the device.
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
@@ -53,9 +53,13 @@
 #include <linux/slab.h>
 #include <linux/acpi.h>
 
+#include <asm/pgtable.h>
+
 #include "../pci.h"
 #include "acpiphp.h"
 
+#define INVALID_ACPI_HANDLE	((acpi_handle)empty_zero_page)
+
 static LIST_HEAD(bridge_list);
 static DEFINE_MUTEX(bridge_mutex);
 static DEFINE_MUTEX(acpiphp_context_lock);
@@ -66,9 +70,9 @@ static void acpiphp_set_hpp_values(struc
 static void hotplug_event(u32 type, void *data);
 static void free_bridge(struct kref *kref);
 
-static void acpiphp_context_handler(acpi_handle handle, void *context)
+static void acpiphp_free_context(struct acpi_hotplug_context *hp)
 {
-	/* Intentionally empty. */
+	kfree(to_acpiphp_context(hp));
 }
 
 /**
@@ -80,39 +84,29 @@ static void acpiphp_context_handler(acpi
 static struct acpiphp_context *acpiphp_init_context(struct acpi_device *adev)
 {
 	struct acpiphp_context *context;
-	acpi_status status;
 
 	context = kzalloc(sizeof(*context), GFP_KERNEL);
 	if (!context)
 		return NULL;
 
-	context->adev = adev;
+	context->hp.self = adev;
+	context->hp.release = acpiphp_free_context;
 	context->refcount = 1;
-	status = acpi_attach_data(adev->handle, acpiphp_context_handler, context);
-	if (ACPI_FAILURE(status)) {
-		kfree(context);
-		return NULL;
-	}
+	adev->hp = &context->hp;
 	return context;
 }
 
 /**
  * acpiphp_get_context - Get hotplug context and grab a reference to it.
- * @handle: ACPI object handle to get the context for.
+ * @adev: ACPI device object to get the context for.
  *
  * Call under acpiphp_context_lock.
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
 
@@ -130,7 +124,7 @@ static void acpiphp_put_context(struct a
 		return;
 
 	WARN_ON(context->bridge);
-	acpi_detach_data(context->adev->handle, acpiphp_context_handler);
+	context->hp.self->hp = NULL;
 	kfree(context);
 }
 
@@ -395,9 +389,13 @@ static struct acpiphp_bridge *acpiphp_ha
 {
 	struct acpiphp_context *context;
 	struct acpiphp_bridge *bridge = NULL;
+	struct acpi_device *adev;
+
+	if (acpi_bus_get_device(handle, &adev))
+		return NULL;
 
 	mutex_lock(&acpiphp_context_lock);
-	context = acpiphp_get_context(handle);
+	context = acpiphp_get_context(adev);
 	if (context) {
 		bridge = context->bridge;
 		if (bridge)
@@ -793,7 +791,7 @@ static void hotplug_event(u32 type, void
 	struct acpiphp_context *context = data;
 	struct acpiphp_func *func = &context->func;
 	struct acpiphp_slot *slot = func->slot;
-	acpi_handle handle = context->adev->handle;
+	acpi_handle handle = context->hp.self->handle;
 	struct acpiphp_bridge *bridge;
 
 	mutex_lock(&acpiphp_context_lock);
@@ -842,18 +840,39 @@ static void hotplug_event(u32 type, void
 
 static void hotplug_event_work(void *data, u32 type)
 {
-	struct acpiphp_context *context = data;
+	struct acpi_device *adev = data;
+	struct acpiphp_context *context;
+	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
 
 	acpi_scan_lock_acquire();
-	pci_lock_rescan_remove();
+	/*
+	 * The device object's ACPI handle cannot become invalid as long as we
+	 * are holding acpi_scan_lock, but it might have become invalid before
+	 * that lock was acquired.
+	 */
+	if (adev->handle == INVALID_ACPI_HANDLE)
+		goto out;
 
-	hotplug_event(type, context);
+	mutex_lock(&acpiphp_context_lock);
+	context = acpiphp_get_context(adev);
+	if (!context) {
+		mutex_unlock(&acpiphp_context_lock);
+		goto out;
+	}
+	get_bridge(context->func.parent);
+	acpiphp_put_context(context);
+	mutex_unlock(&acpiphp_context_lock);
 
+	pci_lock_rescan_remove();
+	hotplug_event(type, context);
 	pci_unlock_rescan_remove();
-	acpi_scan_lock_release();
-	acpi_evaluate_hotplug_ost(context->adev->handle, type,
-				  ACPI_OST_SC_SUCCESS, NULL);
 	put_bridge(context->func.parent);
+	ost_code = ACPI_OST_SC_SUCCESS;
+
+ out:
+	acpi_evaluate_hotplug_ost(adev->handle, type, ost_code, NULL);
+	put_device(&adev->dev);
+	acpi_scan_lock_release();
 }
 
 /**
@@ -866,7 +885,8 @@ static void hotplug_event_work(void *dat
  */
 static void handle_hotplug_event(acpi_handle handle, u32 type, void *data)
 {
-	struct acpiphp_context *context;
+	struct acpi_device *adev;
+	acpi_status status;
 	u32 ost_code = ACPI_OST_SC_SUCCESS;
 
 	switch (type) {
@@ -901,17 +921,16 @@ static void handle_hotplug_event(acpi_ha
 		goto out;
 	}
 
-	mutex_lock(&acpiphp_context_lock);
-	context = acpiphp_get_context(handle);
-	if (context && !WARN_ON(context->adev->handle != handle)) {
-		get_bridge(context->func.parent);
-		acpiphp_put_context(context);
-		acpi_hotplug_execute(hotplug_event_work, context, type);
-		mutex_unlock(&acpiphp_context_lock);
-		return;
-	}
-	mutex_unlock(&acpiphp_context_lock);
 	ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
+	if (acpi_bus_get_device(handle, &adev))
+		goto out;
+
+	get_device(&adev->dev);
+	status = acpi_hotplug_execute(hotplug_event_work, adev, type);
+	if (ACPI_SUCCESS(status))
+		return;
+
+	put_device(&adev->dev);
 
  out:
 	acpi_evaluate_hotplug_ost(handle, type, ost_code, NULL);
@@ -967,7 +986,7 @@ void acpiphp_enumerate_slots(struct pci_
 		 * bridge is not interesting to us either.
 		 */
 		mutex_lock(&acpiphp_context_lock);
-		context = acpiphp_get_context(handle);
+		context = acpiphp_get_context(adev);
 		if (!context) {
 			mutex_unlock(&acpiphp_context_lock);
 			put_device(&bus->dev);

