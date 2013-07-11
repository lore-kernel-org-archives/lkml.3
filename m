Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102Ab3GLAD4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 20:03:56 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:39041 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756679Ab3GKX66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 19:58:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [RFC][PATCH 16/30] ACPI / hotplug / PCI: Drop handle field from struct acpiphp_func
Date: Fri, 12 Jul 2013 01:55:34 +0200
Message-ID: <1415979.zL9GvHn6uE@vostro.rjw.lan>
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

The ACPI handle stored in struct acpiphp_func is also stored in the
struct acpiphp_context object containing it and it is trivial to get
from a struct acpiphp_func pointer to the handle field of the outer
struct acpiphp_context.

Hence, the handle field of struct acpiphp_func is redundant, so drop
it and provide a helper function, func_to_handle(), allowing it
users to get the ACPI handle for the given struct acpiphp_func
pointer.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp.h      |    6 ++++-
 drivers/pci/hotplug/acpiphp_glue.c |   42 ++++++++++++++++++++++---------------
 2 files changed, 30 insertions(+), 18 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp.h
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp.h
+++ linux-pm/drivers/pci/hotplug/acpiphp.h
@@ -117,7 +117,6 @@ struct acpiphp_func {
 
 	struct list_head sibling;
 	struct notifier_block nb;
-	acpi_handle	handle;
 
 	u8		function;	/* pci function# */
 	u32		flags;		/* see below */
@@ -135,6 +134,11 @@ static inline struct acpiphp_context *fu
 	return container_of(func, struct acpiphp_context, func);
 }
 
+static inline acpi_handle func_to_handle(struct acpiphp_func *func)
+{
+	return func_to_context(func)->handle;
+}
+
 /*
  * struct acpiphp_attention_info - device specific attention registration
  *
Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -295,7 +295,6 @@ static acpi_status register_slot(acpi_ha
 		return AE_NOT_EXIST;
 	}
 	newfunc = &context->func;
-	newfunc->handle = handle;
 	newfunc->function = function;
 	mutex_unlock(&acpiphp_context_lock);
 
@@ -436,12 +435,14 @@ static void cleanup_bridge(struct acpiph
 
 	list_for_each_entry(slot, &bridge->slots, node) {
 		list_for_each_entry(func, &slot->funcs, sibling) {
-			if (is_dock_device(func->handle)) {
-				unregister_hotplug_dock_device(func->handle);
+			acpi_handle handle = func_to_handle(func);
+
+			if (is_dock_device(handle)) {
+				unregister_hotplug_dock_device(handle);
 				unregister_dock_notifier(&func->nb);
 			}
 			if (!(func->flags & FUNC_HAS_DCK)) {
-				status = acpi_remove_notify_handler(func->handle,
+				status = acpi_remove_notify_handler(handle,
 							ACPI_SYSTEM_NOTIFY,
 							handle_hotplug_event);
 				if (ACPI_FAILURE(status))
@@ -469,7 +470,8 @@ static int power_on_slot(struct acpiphp_
 	list_for_each_entry(func, &slot->funcs, sibling) {
 		if (func->flags & FUNC_HAS_PS0) {
 			dbg("%s: executing _PS0\n", __func__);
-			status = acpi_evaluate_object(func->handle, "_PS0", NULL, NULL);
+			status = acpi_evaluate_object(func_to_handle(func),
+						      "_PS0", NULL, NULL);
 			if (ACPI_FAILURE(status)) {
 				warn("%s: _PS0 failed\n", __func__);
 				retval = -1;
@@ -501,7 +503,8 @@ static int power_off_slot(struct acpiphp
 
 	list_for_each_entry(func, &slot->funcs, sibling) {
 		if (func->flags & FUNC_HAS_PS3) {
-			status = acpi_evaluate_object(func->handle, "_PS3", NULL, NULL);
+			status = acpi_evaluate_object(func_to_handle(func),
+						      "_PS3", NULL, NULL);
 			if (ACPI_FAILURE(status)) {
 				warn("%s: _PS3 failed\n", __func__);
 				retval = -1;
@@ -555,10 +558,11 @@ static unsigned char acpiphp_max_busnr(s
  */
 static int acpiphp_bus_add(struct acpiphp_func *func)
 {
+	acpi_handle handle = func_to_handle(func);
 	struct acpi_device *device;
 	int ret_val;
 
-	if (!acpi_bus_get_device(func->handle, &device)) {
+	if (!acpi_bus_get_device(handle, &device)) {
 		dbg("bus exists... trim\n");
 		/* this shouldn't be in here, so remove
 		 * the bus then re-add it...
@@ -566,9 +570,9 @@ static int acpiphp_bus_add(struct acpiph
 		acpi_bus_trim(device);
 	}
 
-	ret_val = acpi_bus_scan(func->handle);
+	ret_val = acpi_bus_scan(handle);
 	if (!ret_val)
-		ret_val = acpi_bus_get_device(func->handle, &device);
+		ret_val = acpi_bus_get_device(handle, &device);
 
 	if (ret_val)
 		dbg("error adding bus, %x\n", -ret_val);
@@ -610,7 +614,8 @@ static void acpiphp_set_acpi_region(stru
 		params[1].type = ACPI_TYPE_INTEGER;
 		params[1].integer.value = 1;
 		/* _REG is optional, we don't care about if there is failure */
-		acpi_evaluate_object(func->handle, "_REG", &arg_list, NULL);
+		acpi_evaluate_object(func_to_handle(func), "_REG", &arg_list,
+				     NULL);
 	}
 }
 
@@ -751,9 +756,8 @@ static int disable_device(struct acpiphp
 		pci_dev_put(pdev);
 	}
 
-	list_for_each_entry(func, &slot->funcs, sibling) {
-		acpiphp_bus_trim(func->handle);
-	}
+	list_for_each_entry(func, &slot->funcs, sibling)
+		acpiphp_bus_trim(func_to_handle(func));
 
 	slot->flags &= (~SLOT_ENABLED);
 
@@ -775,17 +779,20 @@ static int disable_device(struct acpiphp
  */
 static unsigned int get_slot_status(struct acpiphp_slot *slot)
 {
-	acpi_status status;
 	unsigned long long sta = 0;
-	u32 dvid;
 	struct acpiphp_func *func;
 
 	list_for_each_entry(func, &slot->funcs, sibling) {
 		if (func->flags & FUNC_HAS_STA) {
-			status = acpi_evaluate_integer(func->handle, "_STA", NULL, &sta);
+			acpi_status status;
+
+			status = acpi_evaluate_integer(func_to_handle(func),
+						       "_STA", NULL, &sta);
 			if (ACPI_SUCCESS(status) && sta)
 				break;
 		} else {
+			u32 dvid;
+
 			pci_bus_read_config_dword(slot->bridge->pci_bus,
 						  PCI_DEVFN(slot->device,
 							    func->function),
@@ -820,7 +827,8 @@ int acpiphp_eject_slot(struct acpiphp_sl
 			arg.type = ACPI_TYPE_INTEGER;
 			arg.integer.value = 1;
 
-			status = acpi_evaluate_object(func->handle, "_EJ0", &arg_list, NULL);
+			status = acpi_evaluate_object(func_to_handle(func),
+						      "_EJ0", &arg_list, NULL);
 			if (ACPI_FAILURE(status)) {
 				warn("%s: _EJ0 failed\n", __func__);
 				return -1;

