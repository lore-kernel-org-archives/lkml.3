Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100Ab3GLAFq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 20:05:46 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:39008 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753874Ab3GKX6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 19:58:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [RFC][PATCH 23/30] ACPI / hotplug / PCI: Do not exectute _PS0 and _PS3 directly
Date: Fri, 12 Jul 2013 02:01:30 +0200
Message-ID: <1757750.sf0hy8txF5@vostro.rjw.lan>
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

The ACPI-based PCI hotplug (acpiphp) core code need not and really
should not execute _PS0 and _PS3 directly for devices it handles.

First of all, it is not necessary to put devices into D3 after
acpi_bus_trim() has walked through them, because
acpi_device_unregister() invoked by it puts each device into D3cold
before returning.  Thus after disable_device() the slot should be
powered down already.

Second, calling _PS0 directly on ACPI device objects may not be
appropriate, because it may require power resources to be set up in
a specific way in advance and that must be taken care of by the ACPI
core.  Thus modify acpiphp_bus_add() to power up the device using
the appropriate interface after it has run acpi_bus_scan() on its
handle.

After that, the functions executing _PS0 and _PS3, power_on_slot()
and power_off_slot(), are not necessary any more, so drop them
and update the code calling them accordingly.  Also drop the
function flags related to device power states, since they aren't
useful any more too.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp.h      |    7 --
 drivers/pci/hotplug/acpiphp_glue.c |  106 +++----------------------------------
 2 files changed, 10 insertions(+), 103 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -305,12 +305,6 @@ static acpi_status register_slot(acpi_ha
 	if (ACPI_SUCCESS(acpi_get_handle(handle, "_STA", &tmp)))
 		newfunc->flags |= FUNC_HAS_STA;
 
-	if (ACPI_SUCCESS(acpi_get_handle(handle, "_PS0", &tmp)))
-		newfunc->flags |= FUNC_HAS_PS0;
-
-	if (ACPI_SUCCESS(acpi_get_handle(handle, "_PS3", &tmp)))
-		newfunc->flags |= FUNC_HAS_PS3;
-
 	if (ACPI_SUCCESS(acpi_get_handle(handle, "_DCK", &tmp)))
 		newfunc->flags |= FUNC_HAS_DCK;
 
@@ -369,7 +363,7 @@ static acpi_status register_slot(acpi_ha
 
 	if (pci_bus_read_dev_vendor_id(pbus, PCI_DEVFN(device, function),
 				       &val, 60*1000))
-		slot->flags |= (SLOT_ENABLED | SLOT_POWEREDON);
+		slot->flags |= SLOT_ENABLED;
 
 	if (is_dock_device(handle)) {
 		/* we don't want to call this device's _EJ0
@@ -458,73 +452,6 @@ static void cleanup_bridge(struct acpiph
 	mutex_unlock(&bridge_mutex);
 }
 
-static int power_on_slot(struct acpiphp_slot *slot)
-{
-	acpi_status status;
-	struct acpiphp_func *func;
-	int retval = 0;
-
-	/* if already enabled, just skip */
-	if (slot->flags & SLOT_POWEREDON)
-		goto err_exit;
-
-	list_for_each_entry(func, &slot->funcs, sibling) {
-		if (func->flags & FUNC_HAS_PS0) {
-			dbg("%s: executing _PS0\n", __func__);
-			status = acpi_evaluate_object(func_to_handle(func),
-						      "_PS0", NULL, NULL);
-			if (ACPI_FAILURE(status)) {
-				warn("%s: _PS0 failed\n", __func__);
-				retval = -1;
-				goto err_exit;
-			} else
-				break;
-		}
-	}
-
-	/* TBD: evaluate _STA to check if the slot is enabled */
-
-	slot->flags |= SLOT_POWEREDON;
-
- err_exit:
-	return retval;
-}
-
-
-static int power_off_slot(struct acpiphp_slot *slot)
-{
-	acpi_status status;
-	struct acpiphp_func *func;
-
-	int retval = 0;
-
-	/* if already disabled, just skip */
-	if ((slot->flags & SLOT_POWEREDON) == 0)
-		goto err_exit;
-
-	list_for_each_entry(func, &slot->funcs, sibling) {
-		if (func->flags & FUNC_HAS_PS3) {
-			status = acpi_evaluate_object(func_to_handle(func),
-						      "_PS3", NULL, NULL);
-			if (ACPI_FAILURE(status)) {
-				warn("%s: _PS3 failed\n", __func__);
-				retval = -1;
-				goto err_exit;
-			} else
-				break;
-		}
-	}
-
-	/* TBD: evaluate _STA to check if the slot is disabled */
-
-	slot->flags &= (~SLOT_POWEREDON);
-
- err_exit:
-	return retval;
-}
-
-
-
 /**
  * acpiphp_max_busnr - return the highest reserved bus number under the given bus.
  * @bus: bus to start search with
@@ -571,8 +498,13 @@ static void acpiphp_bus_trim(acpi_handle
  */
 static void acpiphp_bus_add(acpi_handle handle)
 {
+	struct acpi_device *adev = NULL;
+
 	acpiphp_bus_trim(handle);
 	acpi_bus_scan(handle);
+	acpi_bus_get_device(handle, &adev);
+	if (adev)
+		acpi_device_set_power(adev, ACPI_STATE_D0);
 }
 
 static void acpiphp_set_acpi_region(struct acpiphp_slot *slot)
@@ -1107,23 +1039,8 @@ int acpiphp_enable_slot(struct acpiphp_s
 	int retval;
 
 	mutex_lock(&slot->crit_sect);
-
-	/* wake up all functions */
-	retval = power_on_slot(slot);
-	if (retval)
-		goto err_exit;
-
-	if (get_slot_status(slot) == ACPI_STA_ALL) {
-		/* configure all functions */
-		retval = enable_device(slot);
-		if (retval)
-			power_off_slot(slot);
-	} else {
-		dbg("%s: Slot status is not ACPI_STA_ALL\n", __func__);
-		power_off_slot(slot);
-	}
-
- err_exit:
+	/* configure all functions */
+	retval = enable_device(slot);
 	mutex_unlock(&slot->crit_sect);
 	return retval;
 }
@@ -1146,11 +1063,6 @@ int acpiphp_disable_and_eject_slot(struc
 	if (retval)
 		goto err_exit;
 
-	/* power off all functions */
-	retval = power_off_slot(slot);
-	if (retval)
-		goto err_exit;
-
 	list_for_each_entry(func, &slot->funcs, sibling) {
 		/* We don't want to call _EJ0 on non-existing functions. */
 		if (func->flags & FUNC_HAS_EJ0) {
@@ -1184,7 +1096,7 @@ int acpiphp_disable_and_eject_slot(struc
  */
 u8 acpiphp_get_power_status(struct acpiphp_slot *slot)
 {
-	return (slot->flags & SLOT_POWEREDON);
+	return (slot->flags & SLOT_ENABLED);
 }
 
 
Index: linux-pm/drivers/pci/hotplug/acpiphp.h
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp.h
+++ linux-pm/drivers/pci/hotplug/acpiphp.h
@@ -160,7 +160,6 @@ struct acpiphp_attention_info
 
 /* slot flags */
 
-#define SLOT_POWEREDON		(0x00000001)
 #define SLOT_ENABLED		(0x00000002)
 #define SLOT_MULTIFUNCTION	(0x00000004)
 
@@ -168,11 +167,7 @@ struct acpiphp_attention_info
 
 #define FUNC_HAS_STA		(0x00000001)
 #define FUNC_HAS_EJ0		(0x00000002)
-#define FUNC_HAS_PS0		(0x00000010)
-#define FUNC_HAS_PS1		(0x00000020)
-#define FUNC_HAS_PS2		(0x00000040)
-#define FUNC_HAS_PS3		(0x00000080)
-#define FUNC_HAS_DCK            (0x00000100)
+#define FUNC_HAS_DCK            (0x00000003)
 
 /* function prototypes */
 

