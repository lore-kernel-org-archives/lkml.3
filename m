Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab3GIAOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 20:14:45 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:35125 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474Ab3GIANT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 20:13:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [RFC][PATCH 5/8] ACPI / hotplug / PCI: Unified notify handler for hotplug events
Date: Tue, 09 Jul 2013 02:19:04 +0200
Message-ID: <1475924.SZkPqZAdKY@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <26431283.HJCKsss0rt@vostro.rjw.lan>
References: <26431283.HJCKsss0rt@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Using the hotplug context objects introduced previously rework the
ACPI-based PCI hotplug (acpiphp) core code so that all notifications
for ACPI device objects corresponding to the hotplug PCI devices are
handled by one function, handle_hotplug_event(), which recognizes
whether it has to handle a bridge or a function.

In addition to code size reduction it allows some ugly pieces of code
where notify handlers have to be uninstalled and installed again to
go away.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp.h      |    1 
 drivers/pci/hotplug/acpiphp_glue.c |  127 +++++++++++++------------------------
 2 files changed, 48 insertions(+), 80 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -58,11 +58,10 @@ static DEFINE_MUTEX(bridge_mutex);
 
 #define MY_NAME "acpiphp_glue"
 
-static void handle_hotplug_event_bridge (acpi_handle, u32, void *);
+static void handle_hotplug_event(acpi_handle handle, u32 type, void *data);
 static void acpiphp_sanitize_bus(struct pci_bus *bus);
 static void acpiphp_set_hpp_values(struct pci_bus *bus);
 static void hotplug_event_func(acpi_handle handle, u32 type, void *context);
-static void handle_hotplug_event_func(acpi_handle handle, u32 type, void *context);
 static void free_bridge(struct kref *kref);
 
 /* callback routine to check for the existence of a pci dock device */
@@ -163,13 +162,13 @@ static void free_bridge(struct kref *kre
 		kfree(slot);
 	}
 
+	context = bridge->context;
 	/* Release reference acquired by acpiphp_enumerate_slots(). */
-	if ((bridge->flags & BRIDGE_HAS_EJ0) && bridge->func)
+	if (context->handler_for_func)
 		put_bridge(bridge->func->slot->bridge);
 
 	put_device(&bridge->pci_bus->dev);
 	pci_dev_put(bridge->pci_dev);
-	context = bridge->context;
 	context->bridge = NULL;
 	kfree(bridge);
 	acpiphp_put_context(context);
@@ -406,12 +405,12 @@ static acpi_status register_slot(acpi_ha
 
 	/* install notify handler */
 	if (!(newfunc->flags & FUNC_HAS_DCK)) {
-		status = acpi_install_notify_handler(handle,
-					     ACPI_SYSTEM_NOTIFY,
-					     handle_hotplug_event_func,
-					     newfunc);
-
-		if (ACPI_FAILURE(status))
+		status = acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
+						     handle_hotplug_event,
+						     context);
+		if (ACPI_SUCCESS(status))
+			context->handler_for_func = true;
+		else
 			err("failed to register interrupt notify handler\n");
 	}
 
@@ -465,23 +464,13 @@ static void cleanup_bridge(struct acpiph
 	acpi_status status;
 	acpi_handle handle = bridge->handle;
 
-	if (!pci_is_root_bus(bridge->pci_bus)) {
-		status = acpi_remove_notify_handler(handle,
-					    ACPI_SYSTEM_NOTIFY,
-					    handle_hotplug_event_bridge);
+	if (!bridge->context->handler_for_func) {
+		status = acpi_remove_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
+						    handle_hotplug_event);
 		if (ACPI_FAILURE(status))
 			err("failed to remove notify handler\n");
 	}
 
-	if ((bridge->flags & BRIDGE_HAS_EJ0) && bridge->func) {
-		status = acpi_install_notify_handler(bridge->func->handle,
-						ACPI_SYSTEM_NOTIFY,
-						handle_hotplug_event_func,
-						bridge->func);
-		if (ACPI_FAILURE(status))
-			err("failed to install interrupt notify handler\n");
-	}
-
 	list_for_each_entry(slot, &bridge->slots, node) {
 		list_for_each_entry(func, &slot->funcs, sibling) {
 			if (is_dock_device(func->handle)) {
@@ -489,9 +478,10 @@ static void cleanup_bridge(struct acpiph
 				unregister_dock_notifier(&func->nb);
 			}
 			if (!(func->flags & FUNC_HAS_DCK)) {
+				func->context->handler_for_func = false;
 				status = acpi_remove_notify_handler(func->handle,
-						ACPI_SYSTEM_NOTIFY,
-						handle_hotplug_event_func);
+							ACPI_SYSTEM_NOTIFY,
+							handle_hotplug_event);
 				if (ACPI_FAILURE(status))
 					err("failed to remove notify handler\n");
 			}
@@ -1072,31 +1062,6 @@ static void _handle_hotplug_event_bridge
 	put_bridge(bridge);
 }
 
-/**
- * handle_hotplug_event_bridge - handle ACPI event on bridges
- * @handle: Notify()'ed acpi_handle
- * @type: Notify code
- * @context: pointer to acpiphp_bridge structure
- *
- * Handles ACPI event notification on {host,p2p} bridges.
- */
-static void handle_hotplug_event_bridge(acpi_handle handle, u32 type,
-					void *context)
-{
-	struct acpiphp_bridge *bridge = context;
-
-	/*
-	 * Currently the code adds all hotplug events to the kacpid_wq
-	 * queue when it should add hotplug events to the kacpi_hotplug_wq.
-	 * The proper way to fix this is to reorganize the code so that
-	 * drivers (dock, etc.) do not call acpi_os_execute(), etc.
-	 * For now just re-add this work to the kacpi_hotplug_wq so we
-	 * don't deadlock on hotplug actions.
-	 */
-	get_bridge(bridge);
-	alloc_acpi_hp_work(handle, type, context, _handle_hotplug_event_bridge);
-}
-
 static void hotplug_event_func(acpi_handle handle, u32 type, void *context)
 {
 	struct acpiphp_func *func = context;
@@ -1154,18 +1119,29 @@ static void _handle_hotplug_event_func(s
 }
 
 /**
- * handle_hotplug_event_func - handle ACPI event on functions (i.e. slots)
+ * handle_hotplug_event - handle ACPI hotplug event
  * @handle: Notify()'ed acpi_handle
  * @type: Notify code
- * @context: pointer to acpiphp_func structure
+ * @data: pointer to acpiphp_context structure
  *
  * Handles ACPI event notification on slots.
  */
-static void handle_hotplug_event_func(acpi_handle handle, u32 type,
-				      void *context)
+static void handle_hotplug_event(acpi_handle handle, u32 type, void *data)
 {
-	struct acpiphp_func *func = context;
+	struct acpiphp_context *context = data;
+	void (*work_func)(struct work_struct *work);
 
+	if (context->bridge) {
+		get_bridge(context->bridge);
+		data = context->bridge;
+		work_func = _handle_hotplug_event_bridge;
+	} else if (context->func) {
+		get_bridge(context->func->slot->bridge);
+		data = context->func;
+		work_func = _handle_hotplug_event_func;
+	} else {
+		return;
+	}
 	/*
 	 * Currently the code adds all hotplug events to the kacpid_wq
 	 * queue when it should add hotplug events to the kacpi_hotplug_wq.
@@ -1174,8 +1150,7 @@ static void handle_hotplug_event_func(ac
 	 * For now just re-add this work to the kacpi_hotplug_wq so we
 	 * don't deadlock on hotplug actions.
 	 */
-	get_bridge(func->slot->bridge);
-	alloc_acpi_hp_work(handle, type, context, _handle_hotplug_event_func);
+	alloc_acpi_hp_work(handle, type, data, work_func);
 }
 
 /*
@@ -1243,33 +1218,25 @@ void acpiphp_enumerate_slots(struct pci_
 	if (pci_is_root_bus(bridge->pci_bus))
 		return;
 
+	status = acpi_get_handle(bridge->handle, "_EJ0", &handle);
+	if (ACPI_SUCCESS(status)) {
+		dbg("found ejectable p2p bridge\n");
+		bridge->flags |= BRIDGE_HAS_EJ0;
+	}
+	if (context->handler_for_func) {
+		/* Notify handler already installed. */
+		bridge->func = context->func;
+		get_bridge(context->func->slot->bridge);
+		return;
+	}
+
 	/* install notify handler for P2P bridges */
 	status = acpi_install_notify_handler(bridge->handle, ACPI_SYSTEM_NOTIFY,
-					     handle_hotplug_event_bridge,
-					     bridge);
-	if (ACPI_FAILURE(status)) {
-		acpi_handle_err(bridge->handle,
-				"failed to register notify handler\n");
-		goto err;
-	}
-	status = acpi_get_handle(bridge->handle, "_EJ0", &handle);
-	if (ACPI_FAILURE(status))
+					     handle_hotplug_event, context);
+	if (ACPI_SUCCESS(status))
 		return;
 
-	dbg("found ejectable p2p bridge\n");
-	bridge->flags |= BRIDGE_HAS_EJ0;
-	if (context->func) {
-		get_bridge(context->func->slot->bridge);
-		bridge->func = context->func;
-		handle = context->handle;
-		WARN_ON(bridge->handle != handle);
-		status = acpi_remove_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
-						    handle_hotplug_event_func);
-		if (ACPI_FAILURE(status))
-			acpi_handle_err(handle,
-					"failed to remove notify handler\n");
-	}
-	return;
+	acpi_handle_err(bridge->handle, "failed to register notify handler\n");
 
  err:
 	cleanup_bridge(bridge);
Index: linux-pm/drivers/pci/hotplug/acpiphp.h
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp.h
+++ linux-pm/drivers/pci/hotplug/acpiphp.h
@@ -137,6 +137,7 @@ struct acpiphp_context {
 	acpi_handle handle;
 	struct acpiphp_func *func;
 	struct acpiphp_bridge *bridge;
+	bool handler_for_func:1;
 };
 
 /*

