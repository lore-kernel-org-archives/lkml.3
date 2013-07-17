Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934504Ab3GQXea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:34:30 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:47850 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964907Ab3GQX1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 19:27:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 20/30] ACPI / hotplug / PCI: Consolidate slot disabling and ejecting
Date: Thu, 18 Jul 2013 01:28:30 +0200
Message-ID: <2675342.96SJAC4hmM@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <2366394.4EoP1MXmG2@vostro.rjw.lan>
References: <26431283.HJCKsss0rt@vostro.rjw.lan> <3718119.FLASu5DBx8@vostro.rjw.lan> <2366394.4EoP1MXmG2@vostro.rjw.lan>
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
 drivers/pci/hotplug/acpiphp.h      |    3 --
 drivers/pci/hotplug/acpiphp_core.c |    6 ----
 drivers/pci/hotplug/acpiphp_glue.c |   50 +++++++++++++------------------------
 3 files changed, 20 insertions(+), 39 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp.h
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp.h
+++ linux-pm/drivers/pci/hotplug/acpiphp.h
@@ -188,8 +188,7 @@ void acpiphp_unregister_hotplug_slot(str
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
@@ -765,27 +765,6 @@ static unsigned int get_slot_status(stru
 }
 
 /**
- * acpiphp_eject_slot - physically eject the slot
- * @slot: ACPI PHP slot
- */
-int acpiphp_eject_slot(struct acpiphp_slot *slot)
-{
-	struct acpiphp_func *func;
-
-	list_for_each_entry(func, &slot->funcs, sibling) {
-		/* We don't want to call _EJ0 on non-existing functions. */
-		if (!(func->flags & FUNC_HAS_EJ0))
-			continue;
-
-		if (ACPI_FAILURE(acpi_evaluate_ej0(func_to_handle(func))))
-			return -1;
-		else
-			break;
-	}
-	return 0;
-}
-
-/**
  * acpiphp_check_bridge - re-enumerate devices
  * @bridge: where to begin re-enumeration
  *
@@ -805,13 +784,11 @@ static int acpiphp_check_bridge(struct a
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
@@ -951,9 +928,7 @@ static void hotplug_event(acpi_handle ha
 	case ACPI_NOTIFY_EJECT_REQUEST:
 		/* request device eject */
 		dbg("%s: Device eject notify on %s\n", __func__, objname);
-		if (!(acpiphp_disable_slot(func->slot)))
-			acpiphp_eject_slot(func->slot);
-
+		acpiphp_disable_and_eject_slot(func->slot);
 		break;
 
 	case ACPI_NOTIFY_FREQUENCY_MISMATCH:
@@ -1148,11 +1123,12 @@ int acpiphp_enable_slot(struct acpiphp_s
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
 	int retval = 0;
 
 	mutex_lock(&slot->crit_sect);
@@ -1167,6 +1143,16 @@ int acpiphp_disable_slot(struct acpiphp_
 	if (retval)
 		goto err_exit;
 
+	list_for_each_entry(func, &slot->funcs, sibling)
+		if (func->flags & FUNC_HAS_EJ0) {
+			acpi_handle handle = func_to_handle(func);
+
+			if (ACPI_FAILURE(acpi_evaluate_ej0(handle)))
+				acpi_handle_err(handle, "_EJ0 failed\n");
+
+			break;
+		}
+
  err_exit:
 	mutex_unlock(&slot->crit_sect);
 	return retval;

