Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749Ab3GKX7B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 19:59:01 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:39016 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756655Ab3GKX6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 19:58:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [RFC][PATCH 21/30] ACPI / hotplug / PCI: Consolidate slot disabling and ejecting
Date: Fri, 12 Jul 2013 01:59:55 +0200
Message-ID: <31949614.9GWyx1vXud@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <3718119.FLASu5DBx8@vostro.rjw.lan>
References: <26431283.HJCKsss0rt@vostro.rjw.lan> <3718119.FLASu5DBx8@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

Both acpiphp_disable_slot() and acpiphp_eject_slot() are always
called together so instead of calling each separately we can
consolidate them into one function acpiphp_disable_and_eject_slot()
that does both (but it will return success on _EJ0 failures that
were ignored in the majority of call sites anyway).

[rjw: Rebased plus minor tweaks]
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp.h      |    3 -
 drivers/pci/hotplug/acpiphp_core.c |    6 ---
 drivers/pci/hotplug/acpiphp_glue.c |   74 +++++++++++++++----------------------
 3 files changed, 33 insertions(+), 50 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp.h
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp.h
+++ linux-pm/drivers/pci/hotplug/acpiphp.h
@@ -186,8 +186,7 @@ void acpiphp_unregister_hotplug_slot(str
 typedef int (*acpiphp_callback)(struct acpiphp_slot *slot, void *data);
 
 int acpiphp_enable_slot(struct acpiphp_slot *slot);
-int acpiphp_disable_slot(struct acpiphp_slot *slot);
-int acpiphp_eject_slot(struct acpiphp_slot *slot);
+int acpiphp_disable_and_eject_slot(struct acpiphp_slot *slot);
 u8 acpiphp_get_power_status(struct acpiphp_slot *slot);
 u8 acpiphp_get_attention_status(struct acpiphp_slot *slot);
 u8 acpiphp_get_latch_status(struct acpiphp_slot *slot);
Index: linux-pm/drivers/pci/hotplug/acpiphp_core.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_core.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_core.c
@@ -155,15 +155,11 @@ static int enable_slot(struct hotplug_sl
 static int disable_slot(struct hotplug_slot *hotplug_slot)
 {
 	struct slot *slot = hotplug_slot->private;
-	int retval;
 
 	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
 
 	/* disable the specified slot */
-	retval = acpiphp_disable_slot(slot->acpi_slot);
-	if (!retval)
-		retval = acpiphp_eject_slot(slot->acpi_slot);
-	return retval;
+	return acpiphp_disable_and_eject_slot(slot->acpi_slot);
 }
 
 
Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -777,38 +777,6 @@ static unsigned int get_slot_status(stru
 }
 
 /**
- * acpiphp_eject_slot - physically eject the slot
- * @slot: ACPI PHP slot
- */
-int acpiphp_eject_slot(struct acpiphp_slot *slot)
-{
-	acpi_status status;
-	struct acpiphp_func *func;
-	struct acpi_object_list arg_list;
-	union acpi_object arg;
-
-	list_for_each_entry(func, &slot->funcs, sibling) {
-		/* We don't want to call _EJ0 on non-existing functions. */
-		if ((func->flags & FUNC_HAS_EJ0)) {
-			/* _EJ0 method take one argument */
-			arg_list.count = 1;
-			arg_list.pointer = &arg;
-			arg.type = ACPI_TYPE_INTEGER;
-			arg.integer.value = 1;
-
-			status = acpi_evaluate_object(func_to_handle(func),
-						      "_EJ0", &arg_list, NULL);
-			if (ACPI_FAILURE(status)) {
-				warn("%s: _EJ0 failed\n", __func__);
-				return -1;
-			} else
-				break;
-		}
-	}
-	return 0;
-}
-
-/**
  * acpiphp_check_bridge - re-enumerate devices
  * @bridge: where to begin re-enumeration
  *
@@ -828,13 +796,11 @@ static int acpiphp_check_bridge(struct a
 		if (slot->flags & SLOT_ENABLED) {
 			if (status == ACPI_STA_ALL)
 				continue;
-			retval = acpiphp_disable_slot(slot);
-			if (retval) {
-				err("Error occurred in disabling\n");
+
+			retval = acpiphp_disable_and_eject_slot(slot);
+			if (retval)
 				goto err_exit;
-			} else {
-				acpiphp_eject_slot(slot);
-			}
+
 			disabled++;
 		} else {
 			if (status != ACPI_STA_ALL)
@@ -974,9 +940,7 @@ static void hotplug_event(acpi_handle ha
 	case ACPI_NOTIFY_EJECT_REQUEST:
 		/* request device eject */
 		dbg("%s: Device eject notify on %s\n", __func__, objname);
-		if (!(acpiphp_disable_slot(func->slot)))
-			acpiphp_eject_slot(func->slot);
-
+		acpiphp_disable_and_eject_slot(func->slot);
 		break;
 
 	case ACPI_NOTIFY_FREQUENCY_MISMATCH:
@@ -1171,11 +1135,14 @@ int acpiphp_enable_slot(struct acpiphp_s
 }
 
 /**
- * acpiphp_disable_slot - power off slot
+ * acpiphp_disable_and_eject_slot - power off and eject slot
  * @slot: ACPI PHP slot
  */
-int acpiphp_disable_slot(struct acpiphp_slot *slot)
+int acpiphp_disable_and_eject_slot(struct acpiphp_slot *slot)
 {
+	struct acpiphp_func *func;
+	struct acpi_object_list arg_list;
+	union acpi_object arg;
 	int retval = 0;
 
 	mutex_lock(&slot->crit_sect);
@@ -1190,6 +1157,27 @@ int acpiphp_disable_slot(struct acpiphp_
 	if (retval)
 		goto err_exit;
 
+	list_for_each_entry(func, &slot->funcs, sibling) {
+		/* We don't want to call _EJ0 on non-existing functions. */
+		if (func->flags & FUNC_HAS_EJ0) {
+			acpi_handle handle = func_to_handle(func);
+			acpi_status status;
+
+			/* _EJ0 method take one argument */
+			arg_list.count = 1;
+			arg_list.pointer = &arg;
+			arg.type = ACPI_TYPE_INTEGER;
+			arg.integer.value = 1;
+
+			status = acpi_evaluate_object(handle, "_EJ0", &arg_list,
+						      NULL);
+			if (ACPI_FAILURE(status))
+				acpi_handle_err(handle, "_EJ0 failed\n");
+
+			break;
+		}
+	}
+
  err_exit:
 	mutex_unlock(&slot->crit_sect);
 	return retval;

