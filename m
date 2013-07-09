Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab3GIANT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 20:13:19 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:35113 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400Ab3GIANQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 20:13:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [RFC][PATCH 8/8] ACPI / hotplug / PCI: Merge hotplug event handling functions
Date: Tue, 09 Jul 2013 02:22:33 +0200
Message-ID: <3222360.jplzAQezPi@vostro.rjw.lan>
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

There are separate handling event functions for hotplug bridges and
for hotplug functions, but they may be combined into one common
hotplug event handling function which simplifies the code slightly.

That also allows a theoretical bug to be dealt with which in
principle may occur if a hotplug bridge is a docking station
device, because in that case the bridge-specific notification should
be used instead of the device-specific one.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |  156 +++++++++++++++----------------------
 1 file changed, 66 insertions(+), 90 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -61,7 +61,7 @@ static DEFINE_MUTEX(bridge_mutex);
 static void handle_hotplug_event(acpi_handle handle, u32 type, void *data);
 static void acpiphp_sanitize_bus(struct pci_bus *bus);
 static void acpiphp_set_hpp_values(struct pci_bus *bus);
-static void hotplug_event_func(acpi_handle handle, u32 type, void *context);
+static void hotplug_event(acpi_handle handle, u32 type, void *data);
 static void free_bridge(struct kref *kref);
 
 /* callback routine to check for the existence of a pci dock device */
@@ -210,7 +210,7 @@ static int post_dock_fixups(struct notif
 
 
 static const struct acpi_dock_ops acpiphp_dock_ops = {
-	.handler = hotplug_event_func,
+	.handler = hotplug_event,
 };
 
 /* Check whether the PCI device is managed by native PCIe hotplug driver */
@@ -244,16 +244,24 @@ static bool device_is_managed_by_native_
 
 static void acpiphp_dock_init(void *data)
 {
-	struct acpiphp_func *func = data;
+	struct acpiphp_context *context = data;
+
+	if (context->func)
+		get_bridge(context->func->slot->bridge);
 
-	get_bridge(func->slot->bridge);
+	if (context->bridge)
+		get_bridge(context->bridge);
 }
 
 static void acpiphp_dock_release(void *data)
 {
-	struct acpiphp_func *func = data;
+	struct acpiphp_context *context = data;
+
+	if (context->bridge)
+		put_bridge(context->bridge);
 
-	put_bridge(func->slot->bridge);
+	if (context->func)
+		put_bridge(context->func->slot->bridge);
 }
 
 /* callback routine to register each ACPI PCI slot object */
@@ -390,7 +398,7 @@ static acpi_status register_slot(acpi_ha
 		 */
 		newfunc->flags &= ~FUNC_HAS_EJ0;
 		if (register_hotplug_dock_device(handle,
-			&acpiphp_dock_ops, newfunc,
+			&acpiphp_dock_ops, context,
 			acpiphp_dock_init, acpiphp_dock_release))
 			dbg("failed to register dock device\n");
 
@@ -982,24 +990,14 @@ void acpiphp_check_host_bridge(acpi_hand
 	acpiphp_put_context(context);
 }
 
-static void _handle_hotplug_event_bridge(struct work_struct *work)
+static void hotplug_event(acpi_handle handle, u32 type, void *data)
 {
-	struct acpiphp_context *context;
-	struct acpiphp_bridge *bridge;
+	struct acpiphp_context *context = data;
+	struct acpiphp_bridge *bridge = context->bridge;
+	struct acpiphp_func *func = context->func;
 	char objname[64];
 	struct acpi_buffer buffer = { .length = sizeof(objname),
 				      .pointer = objname };
-	struct acpi_hp_work *hp_work;
-	acpi_handle handle;
-	u32 type;
-
-	hp_work = container_of(work, struct acpi_hp_work, work);
-	handle = hp_work->handle;
-	type = hp_work->type;
-	context = hp_work->context;
-	bridge = context->bridge;
-
-	acpi_scan_lock_acquire();
 
 	acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
 
@@ -1008,15 +1006,24 @@ static void _handle_hotplug_event_bridge
 		/* bus re-enumerate */
 		dbg("%s: Bus check notify on %s\n", __func__, objname);
 		dbg("%s: re-enumerating slots under %s\n", __func__, objname);
-		acpiphp_check_bridge(bridge);
-		acpi_walk_namespace(ACPI_TYPE_DEVICE, handle,
-			ACPI_UINT32_MAX, check_sub_bridges, NULL, NULL, NULL);
+		if (bridge) {
+			acpiphp_check_bridge(bridge);
+			acpi_walk_namespace(ACPI_TYPE_DEVICE, handle,
+					    ACPI_UINT32_MAX, check_sub_bridges,
+					    NULL, NULL, NULL);
+		} else {
+			acpiphp_enable_slot(func->slot);
+		}
 		break;
 
 	case ACPI_NOTIFY_DEVICE_CHECK:
 		/* device check */
 		dbg("%s: Device check notify on %s\n", __func__, objname);
-		acpiphp_check_bridge(bridge);
+		if (bridge)
+			acpiphp_check_bridge(bridge);
+		else
+			acpiphp_check_bridge(func->slot->bridge);
+
 		break;
 
 	case ACPI_NOTIFY_DEVICE_WAKE:
@@ -1027,12 +1034,15 @@ static void _handle_hotplug_event_bridge
 	case ACPI_NOTIFY_EJECT_REQUEST:
 		/* request device eject */
 		dbg("%s: Device eject notify on %s\n", __func__, objname);
-		if ((bridge->flags & BRIDGE_HAS_EJ0) && bridge->func) {
-			struct acpiphp_slot *slot;
-			slot = bridge->func->slot;
-			if (!acpiphp_disable_slot(slot))
-				acpiphp_eject_slot(slot);
-		}
+		if (!func)
+			break;
+
+		if (bridge && !(bridge->flags & BRIDGE_HAS_EJ0))
+			break;
+
+		if (!(acpiphp_disable_slot(func->slot)))
+			acpiphp_eject_slot(func->slot);
+
 		break;
 
 	case ACPI_NOTIFY_FREQUENCY_MISMATCH:
@@ -1051,56 +1061,13 @@ static void _handle_hotplug_event_bridge
 		break;
 
 	default:
-		warn("notify_handler: unknown event type 0x%x for %s\n", type, objname);
+		warn("notify_handler: unknown event type 0x%x for %s\n", type,
+		     objname);
 		break;
 	}
-
-	acpi_scan_lock_release();
-	kfree(hp_work); /* allocated in handle_hotplug_event_bridge */
-	put_bridge(bridge);
 }
 
-static void hotplug_event_func(acpi_handle handle, u32 type, void *context)
-{
-	struct acpiphp_func *func = context;
-	char objname[64];
-	struct acpi_buffer buffer = { .length = sizeof(objname),
-				      .pointer = objname };
-
-	acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
-
-	switch (type) {
-	case ACPI_NOTIFY_BUS_CHECK:
-		/* bus re-enumerate */
-		dbg("%s: Bus check notify on %s\n", __func__, objname);
-		acpiphp_enable_slot(func->slot);
-		break;
-
-	case ACPI_NOTIFY_DEVICE_CHECK:
-		/* device check : re-enumerate from parent bus */
-		dbg("%s: Device check notify on %s\n", __func__, objname);
-		acpiphp_check_bridge(func->slot->bridge);
-		break;
-
-	case ACPI_NOTIFY_DEVICE_WAKE:
-		/* wake event */
-		dbg("%s: Device wake notify on %s\n", __func__, objname);
-		break;
-
-	case ACPI_NOTIFY_EJECT_REQUEST:
-		/* request device eject */
-		dbg("%s: Device eject notify on %s\n", __func__, objname);
-		if (!(acpiphp_disable_slot(func->slot)))
-			acpiphp_eject_slot(func->slot);
-		break;
-
-	default:
-		warn("notify_handler: unknown event type 0x%x for %s\n", type, objname);
-		break;
-	}
-}
-
-static void _handle_hotplug_event_func(struct work_struct *work)
+static void handle_hotplug_event_work_fn(struct work_struct *work)
 {
 	struct acpiphp_context *context;
 	struct acpi_hp_work *hp_work;
@@ -1109,11 +1076,16 @@ static void _handle_hotplug_event_func(s
 	context = hp_work->context;
 	acpi_scan_lock_acquire();
 
-	hotplug_event_func(hp_work->handle, hp_work->type, context->func);
+	hotplug_event(hp_work->handle, hp_work->type, context);
 
 	acpi_scan_lock_release();
-	kfree(hp_work); /* allocated in handle_hotplug_event_func */
-	put_bridge(context->func->slot->bridge);
+	kfree(hp_work); /* allocated in handle_hotplug_event() */
+	if (context->bridge)
+		put_bridge(context->bridge);
+
+	if (context->func)
+		put_bridge(context->func->slot->bridge);
+
 }
 
 /**
@@ -1127,17 +1099,16 @@ static void _handle_hotplug_event_func(s
 static void handle_hotplug_event(acpi_handle handle, u32 type, void *data)
 {
 	struct acpiphp_context *context = data;
-	void (*work_func)(struct work_struct *work);
 
-	if (context->bridge) {
-		get_bridge(context->bridge);
-		work_func = _handle_hotplug_event_bridge;
-	} else if (context->func) {
-		get_bridge(context->func->slot->bridge);
-		work_func = _handle_hotplug_event_func;
-	} else {
+	if (WARN_ON(!context->bridge && !context->func))
 		return;
-	}
+
+	if (context->func)
+		get_bridge(context->func->slot->bridge);
+
+	if (context->bridge)
+		get_bridge(context->bridge);
+
 	/*
 	 * Currently the code adds all hotplug events to the kacpid_wq
 	 * queue when it should add hotplug events to the kacpi_hotplug_wq.
@@ -1146,7 +1117,7 @@ static void handle_hotplug_event(acpi_ha
 	 * For now just re-add this work to the kacpi_hotplug_wq so we
 	 * don't deadlock on hotplug actions.
 	 */
-	alloc_acpi_hp_work(handle, type, context, work_func);
+	alloc_acpi_hp_work(handle, type, context, handle_hotplug_event_work_fn);
 }
 
 /*
@@ -1226,6 +1197,11 @@ void acpiphp_enumerate_slots(struct pci_
 		return;
 	}
 
+	/* If it has _DCK, there is a notify handler for it already. */
+	status = acpi_get_handle(bridge->handle, "_DCK", &handle);
+	if (ACPI_SUCCESS(status))
+		return;
+
 	/* install notify handler for P2P bridges */
 	status = acpi_install_notify_handler(bridge->handle, ACPI_SYSTEM_NOTIFY,
 					     handle_hotplug_event, context);

