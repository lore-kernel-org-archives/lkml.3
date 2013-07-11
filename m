Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042Ab3GLACB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 20:02:01 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:39068 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756448Ab3GKX7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 19:59:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [RFC][PATCH 8/30] ACPI / hotplug / PCI: Merge hotplug event handling functions
Date: Fri, 12 Jul 2013 01:47:41 +0200
Message-ID: <22160346.DCirzFoHly@vostro.rjw.lan>
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

There are separate handling event functions for hotplug bridges and
for hotplug functions, but they may be combined into one common
hotplug event handling function which simplifies the code slightly.

That also allows a theoretical bug to be dealt with which in
principle may occur if a hotplug bridge is on a dock station, because
in that case the bridge-specific notification should be used instead
of the function-specific one, but the dock station always uses the
latter.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |  148 +++++++++++++++----------------------
 1 file changed, 63 insertions(+), 85 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -62,7 +62,7 @@ static DEFINE_MUTEX(acpiphp_context_lock
 static void handle_hotplug_event(acpi_handle handle, u32 type, void *data);
 static void acpiphp_sanitize_bus(struct pci_bus *bus);
 static void acpiphp_set_hpp_values(struct pci_bus *bus);
-static void hotplug_event_func(acpi_handle handle, u32 type, void *context);
+static void hotplug_event(acpi_handle handle, u32 type, void *data);
 static void free_bridge(struct kref *kref);
 
 /* callback routine to check for the existence of a pci dock device */
@@ -228,7 +228,7 @@ static int post_dock_fixups(struct notif
 
 
 static const struct acpi_dock_ops acpiphp_dock_ops = {
-	.handler = hotplug_event_func,
+	.handler = hotplug_event,
 };
 
 /* Check whether the PCI device is managed by native PCIe hotplug driver */
@@ -262,16 +262,16 @@ static bool device_is_managed_by_native_
 
 static void acpiphp_dock_init(void *data)
 {
-	struct acpiphp_func *func = data;
+	struct acpiphp_context *context = data;
 
-	get_bridge(func->slot->bridge);
+	get_bridge(context->func->slot->bridge);
 }
 
 static void acpiphp_dock_release(void *data)
 {
-	struct acpiphp_func *func = data;
+	struct acpiphp_context *context = data;
 
-	put_bridge(func->slot->bridge);
+	put_bridge(context->func->slot->bridge);
 }
 
 /* callback routine to register each ACPI PCI slot object */
@@ -408,7 +408,7 @@ static acpi_status register_slot(acpi_ha
 		 */
 		newfunc->flags &= ~FUNC_HAS_EJ0;
 		if (register_hotplug_dock_device(handle,
-			&acpiphp_dock_ops, newfunc,
+			&acpiphp_dock_ops, context,
 			acpiphp_dock_init, acpiphp_dock_release))
 			dbg("failed to register dock device\n");
 
@@ -1009,24 +1009,26 @@ void acpiphp_check_host_bridge(acpi_hand
 		ACPI_UINT32_MAX, check_sub_bridges, NULL, NULL, NULL);
 }
 
-static void _handle_hotplug_event_bridge(struct work_struct *work)
+static void hotplug_event(acpi_handle handle, u32 type, void *data)
 {
-	struct acpiphp_context *context;
+	struct acpiphp_context *context = data;
 	struct acpiphp_bridge *bridge;
+	struct acpiphp_func *func;
 	char objname[64];
 	struct acpi_buffer buffer = { .length = sizeof(objname),
 				      .pointer = objname };
-	struct acpi_hp_work *hp_work;
-	acpi_handle handle;
-	u32 type;
 
-	hp_work = container_of(work, struct acpi_hp_work, work);
-	handle = hp_work->handle;
-	type = hp_work->type;
-	context = hp_work->context;
+	mutex_lock(&acpiphp_context_lock);
 	bridge = context->bridge;
+	if (bridge)
+		get_bridge(bridge);
 
-	acpi_scan_lock_acquire();
+	/*
+	 * If context->func is not NULL, we are holding a reference to its
+	 * parent bridge, so it won't go away until we drop that reference.
+	 */
+	func = context->func;
+	mutex_unlock(&acpiphp_context_lock);
 
 	acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
 
@@ -1035,15 +1037,24 @@ static void _handle_hotplug_event_bridge
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
@@ -1054,12 +1065,15 @@ static void _handle_hotplug_event_bridge
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
@@ -1078,56 +1092,16 @@ static void _handle_hotplug_event_bridge
 		break;
 
 	default:
-		warn("notify_handler: unknown event type 0x%x for %s\n", type, objname);
+		warn("notify_handler: unknown event type 0x%x for %s\n", type,
+		     objname);
 		break;
 	}
 
-	acpi_scan_lock_release();
-	kfree(hp_work); /* allocated in handle_hotplug_event_bridge */
-	put_bridge(bridge);
-}
-
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
+	if (bridge)
+		put_bridge(bridge);
 }
 
-static void _handle_hotplug_event_func(struct work_struct *work)
+static void hotplug_event_work(struct work_struct *work)
 {
 	struct acpiphp_context *context;
 	struct acpi_hp_work *hp_work;
@@ -1136,11 +1110,18 @@ static void _handle_hotplug_event_func(s
 	context = hp_work->context;
 	acpi_scan_lock_acquire();
 
-	hotplug_event_func(hp_work->handle, hp_work->type, context->func);
+	hotplug_event(hp_work->handle, hp_work->type, context);
 
 	acpi_scan_lock_release();
-	kfree(hp_work); /* allocated in handle_hotplug_event_func */
-	put_bridge(context->func->slot->bridge);
+	kfree(hp_work); /* allocated in handle_hotplug_event() */
+
+	mutex_lock(&acpiphp_context_lock);
+	if (context->func)
+		put_bridge(context->func->slot->bridge);
+	else
+		acpiphp_put_context(context);
+
+	mutex_unlock(&acpiphp_context_lock);
 }
 
 /**
@@ -1154,22 +1135,19 @@ static void _handle_hotplug_event_func(s
 static void handle_hotplug_event(acpi_handle handle, u32 type, void *data)
 {
 	struct acpiphp_context *context;
-	void (*work_func)(struct work_struct *work) = NULL;
 
 	mutex_lock(&acpiphp_context_lock);
 	context = acpiphp_get_context(handle);
 	if (context) {
-		if (context->bridge) {
-			get_bridge(context->bridge);
-			work_func = _handle_hotplug_event_bridge;
-		} else if (context->func) {
+		if (context->func) {
 			get_bridge(context->func->slot->bridge);
-			work_func = _handle_hotplug_event_func;
+			acpiphp_put_context(context);
+		} else if (!context->bridge) {
+			acpiphp_put_context(context);
+			context = NULL;
 		}
-		acpiphp_put_context(context);
 	}
 	mutex_unlock(&acpiphp_context_lock);
-
 	/*
 	 * Currently the code adds all hotplug events to the kacpid_wq
 	 * queue when it should add hotplug events to the kacpi_hotplug_wq.
@@ -1178,8 +1156,8 @@ static void handle_hotplug_event(acpi_ha
 	 * For now just re-add this work to the kacpi_hotplug_wq so we
 	 * don't deadlock on hotplug actions.
 	 */
-	if (work_func)
-		alloc_acpi_hp_work(handle, type, context, work_func);
+	if (context)
+		alloc_acpi_hp_work(handle, type, context, hotplug_event_work);
 }
 
 /*

