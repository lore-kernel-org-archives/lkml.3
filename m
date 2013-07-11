Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086Ab3GLADz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 20:03:55 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:39026 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756684Ab3GKX66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 19:58:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [RFC][PATCH 15/30] ACPI / hotplug / PCI: Embed function struct into struct acpiphp_context
Date: Fri, 12 Jul 2013 01:54:57 +0200
Message-ID: <12161362.vmNXQEUhXG@vostro.rjw.lan>
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

Since there has to be a struct acpiphp_func object for every struct
acpiphp_context created by register_slot(), the struct acpiphp_func
one can be embedded into the struct acpiphp_context one, which allows
some code simplifications to be made.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp.h      |    8 +++++--
 drivers/pci/hotplug/acpiphp_glue.c |   42 +++++++++++++------------------------
 2 files changed, 21 insertions(+), 29 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp.h
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp.h
+++ linux-pm/drivers/pci/hotplug/acpiphp.h
@@ -113,7 +113,6 @@ struct acpiphp_slot {
  * typically 8 objects per slot (i.e. for each PCI function)
  */
 struct acpiphp_func {
-	struct acpiphp_context *context;
 	struct acpiphp_slot *slot;	/* parent */
 
 	struct list_head sibling;
@@ -126,11 +125,16 @@ struct acpiphp_func {
 
 struct acpiphp_context {
 	acpi_handle handle;
-	struct acpiphp_func *func;
+	struct acpiphp_func func;
 	struct acpiphp_bridge *bridge;
 	unsigned int refcount;
 };
 
+static inline struct acpiphp_context *func_to_context(struct acpiphp_func *func)
+{
+	return container_of(func, struct acpiphp_context, func);
+}
+
 /*
  * struct acpiphp_attention_info - device specific attention registration
  *
Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -128,7 +128,7 @@ static void acpiphp_put_context(struct a
 	if (--context->refcount)
 		return;
 
-	WARN_ON(context->func || context->bridge);
+	WARN_ON(context->bridge);
 	acpi_detach_data(context->handle, acpiphp_context_handler);
 	kfree(context);
 }
@@ -155,12 +155,9 @@ static void free_bridge(struct kref *kre
 	bridge = container_of(kref, struct acpiphp_bridge, ref);
 
 	list_for_each_entry_safe(slot, next, &bridge->slots, node) {
-		list_for_each_entry_safe(func, tmp, &slot->funcs, sibling) {
-			context = func->context;
-			context->func = NULL;
-			acpiphp_put_context(context);
-			kfree(func);
-		}
+		list_for_each_entry_safe(func, tmp, &slot->funcs, sibling)
+			acpiphp_put_context(func_to_context(func));
+
 		kfree(slot);
 	}
 
@@ -168,7 +165,7 @@ static void free_bridge(struct kref *kre
 	/* Root bridges will not have hotplug context. */
 	if (context) {
 		/* Release the reference taken by acpiphp_enumerate_slots(). */
-		put_bridge(context->func->slot->bridge);
+		put_bridge(context->func.slot->bridge);
 		context->bridge = NULL;
 		acpiphp_put_context(context);
 	}
@@ -252,14 +249,14 @@ static void acpiphp_dock_init(void *data
 {
 	struct acpiphp_context *context = data;
 
-	get_bridge(context->func->slot->bridge);
+	get_bridge(context->func.slot->bridge);
 }
 
 static void acpiphp_dock_release(void *data)
 {
 	struct acpiphp_context *context = data;
 
-	put_bridge(context->func->slot->bridge);
+	put_bridge(context->func.slot->bridge);
 }
 
 /* callback routine to register each ACPI PCI slot object */
@@ -290,23 +287,16 @@ static acpi_status register_slot(acpi_ha
 	device = (adr >> 16) & 0xffff;
 	function = adr & 0xffff;
 
-	newfunc = kzalloc(sizeof(struct acpiphp_func), GFP_KERNEL);
-	if (!newfunc)
-		return AE_NO_MEMORY;
-
-	newfunc->handle = handle;
-	newfunc->function = function;
-
 	mutex_lock(&acpiphp_context_lock);
 	context = acpiphp_init_context(handle);
 	if (!context) {
 		mutex_unlock(&acpiphp_context_lock);
 		acpi_handle_err(handle, "No hotplug context\n");
-		kfree(newfunc);
 		return AE_NOT_EXIST;
 	}
-	newfunc->context = context;
-	context->func = newfunc;
+	newfunc = &context->func;
+	newfunc->handle = handle;
+	newfunc->function = function;
 	mutex_unlock(&acpiphp_context_lock);
 
 	if (ACPI_SUCCESS(acpi_get_handle(handle, "_EJ0", &tmp)))
@@ -415,10 +405,8 @@ static acpi_status register_slot(acpi_ha
 
  err:
 	mutex_lock(&acpiphp_context_lock);
-	context->func = NULL;
 	acpiphp_put_context(context);
 	mutex_unlock(&acpiphp_context_lock);
-	kfree(newfunc);
 	return status;
 }
 
@@ -961,7 +949,7 @@ void acpiphp_check_host_bridge(acpi_hand
 static void hotplug_event(acpi_handle handle, u32 type, void *data)
 {
 	struct acpiphp_context *context = data;
-	struct acpiphp_func *func = context->func;
+	struct acpiphp_func *func = &context->func;
 	struct acpiphp_bridge *bridge;
 	char objname[64];
 	struct acpi_buffer buffer = { .length = sizeof(objname),
@@ -1052,7 +1040,7 @@ static void hotplug_event_work(struct wo
 
 	acpi_scan_lock_release();
 	kfree(hp_work); /* allocated in handle_hotplug_event() */
-	put_bridge(context->func->slot->bridge);
+	put_bridge(context->func.slot->bridge);
 }
 
 /**
@@ -1070,7 +1058,7 @@ static void handle_hotplug_event(acpi_ha
 	mutex_lock(&acpiphp_context_lock);
 	context = acpiphp_get_context(handle);
 	if (context) {
-		get_bridge(context->func->slot->bridge);
+		get_bridge(context->func.slot->bridge);
 		acpiphp_put_context(context);
 	}
 	mutex_unlock(&acpiphp_context_lock);
@@ -1132,7 +1120,7 @@ void acpiphp_enumerate_slots(struct pci_
 		 */
 		mutex_lock(&acpiphp_context_lock);
 		context = acpiphp_get_context(handle);
-		if (WARN_ON(!context || !context->func)) {
+		if (WARN_ON(!context)) {
 			mutex_unlock(&acpiphp_context_lock);
 			put_device(&bus->dev);
 			kfree(bridge);
@@ -1141,7 +1129,7 @@ void acpiphp_enumerate_slots(struct pci_
 		bridge->context = context;
 		context->bridge = bridge;
 		/* Get a reference to the parent bridge. */
-		get_bridge(context->func->slot->bridge);
+		get_bridge(context->func.slot->bridge);
 		mutex_unlock(&acpiphp_context_lock);
 	}
 

