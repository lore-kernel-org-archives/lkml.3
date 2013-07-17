Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934496Ab3GQXga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:36:30 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:47825 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932148Ab3GQX1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 19:27:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 25/30] ACPI / hotplug / PCI: Check for new devices on enabled slots
Date: Thu, 18 Jul 2013 01:32:52 +0200
Message-ID: <1818424.8fNkf5pBy3@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <2366394.4EoP1MXmG2@vostro.rjw.lan>
References: <26431283.HJCKsss0rt@vostro.rjw.lan> <3718119.FLASu5DBx8@vostro.rjw.lan> <2366394.4EoP1MXmG2@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The current implementation of acpiphp_check_bridge() is pretty dumb:
 - It enables a slot if it's not enabled and the slot status is
   ACPI_STA_ALL.
 - It disables a slot if it's enabled and the slot status is not
   ACPI_STA_ALL.

This behavior is not sufficient to handle the Thunderbolt daisy
chaining case properly, however, because in that case the bus
behind the already enabled slot needs to be rescanned for new
devices.

For this reason, modify acpiphp_check_bridge() so that slots are
disabled and stopped if they are not in the ACPI_STA_ALL state.

For slots in the ACPI_STA_ALL state, devices behind them that don't
respond are trimmed using a new function, trim_stale_devices(),
introduced specifically for this purpose.  That function walks
the given bus and checks each device on it.  If the device doesn't
respond, it is assumed to be gone and is removed.

Once all of the stale devices directy behind the slot have been
removed, acpiphp_check_bridge() will start looking for new devices
that might have appeared on the given bus.  It will do that even if
the slot is already enabled (SLOT_ENABLED is set for it).

In addition to that, make the bus check notification ignore
SLOT_ENABLED and go for enable_device() directly if bridge is NULL,
so that devices behind the slot are re-enumerated in that case too.

This change is based on earlier patches from Kirill A Shutemov
and Mika Westerberg.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |   87 +++++++++++++++++++++++++------------
 1 file changed, 60 insertions(+), 27 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -46,6 +46,7 @@
 #include <linux/pci.h>
 #include <linux/pci_hotplug.h>
 #include <linux/pci-acpi.h>
+#include <linux/pm_runtime.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/acpi.h>
@@ -687,47 +688,75 @@ static unsigned int get_slot_status(stru
 }
 
 /**
+ * trim_stale_devices - remove PCI devices that are not responding.
+ * @dev: PCI device to start walking the hierarchy from.
+ */
+static void trim_stale_devices(struct pci_dev *dev)
+{
+	acpi_handle handle = ACPI_HANDLE(&dev->dev);
+	struct pci_bus *bus = dev->subordinate;
+	bool alive = false;
+
+	if (handle) {
+		acpi_status status;
+		unsigned long long sta;
+
+		status = acpi_evaluate_integer(handle, "_STA", NULL, &sta);
+		alive = ACPI_SUCCESS(status) && sta == ACPI_STA_ALL;
+	}
+	if (!alive) {
+		u32 v;
+
+		/* Check if the device responds. */
+		alive = pci_bus_read_dev_vendor_id(dev->bus, dev->devfn, &v, 0);
+	}
+	if (!alive) {
+		pci_stop_and_remove_bus_device(dev);
+		if (handle)
+			acpiphp_bus_trim(handle);
+	} else if (bus) {
+		struct pci_dev *child, *tmp;
+
+		/* The device is a bridge. so check the bus below it. */
+		pm_runtime_get_sync(&dev->dev);
+		list_for_each_entry_safe(child, tmp, &bus->devices, bus_list)
+			trim_stale_devices(child);
+
+		pm_runtime_put(&dev->dev);
+	}
+}
+
+/**
  * acpiphp_check_bridge - re-enumerate devices
  * @bridge: where to begin re-enumeration
  *
  * Iterate over all slots under this bridge and make sure that if a
  * card is present they are enabled, and if not they are disabled.
  */
-static int acpiphp_check_bridge(struct acpiphp_bridge *bridge)
+static void acpiphp_check_bridge(struct acpiphp_bridge *bridge)
 {
 	struct acpiphp_slot *slot;
-	int retval = 0;
-	int enabled, disabled;
-
-	enabled = disabled = 0;
 
 	list_for_each_entry(slot, &bridge->slots, node) {
-		unsigned int status = get_slot_status(slot);
-		if (slot->flags & SLOT_ENABLED) {
-			if (status == ACPI_STA_ALL)
-				continue;
+		struct pci_bus *bus = slot->bus;
+		struct pci_dev *dev, *tmp;
 
-			retval = acpiphp_disable_and_eject_slot(slot);
-			if (retval)
-				goto err_exit;
+		mutex_lock(&slot->crit_sect);
+		/* wake up all functions */
+		if (get_slot_status(slot) == ACPI_STA_ALL) {
+			/* remove stale devices if any */
+			list_for_each_entry_safe(dev, tmp, &bus->devices,
+						 bus_list)
+				if (PCI_SLOT(dev->devfn) == slot->device)
+					trim_stale_devices(dev);
 
-			disabled++;
+			/* configure all functions */
+			enable_device(slot);
 		} else {
-			if (status != ACPI_STA_ALL)
-				continue;
-			retval = acpiphp_enable_slot(slot);
-			if (retval) {
-				err("Error occurred in enabling\n");
-				goto err_exit;
-			}
-			enabled++;
+			disable_device(slot);
 		}
+		mutex_unlock(&slot->crit_sect);
 	}
-
-	dbg("%s: %d enabled, %d disabled\n", __func__, enabled, disabled);
-
- err_exit:
-	return retval;
 }
 
 static void acpiphp_set_hpp_values(struct pci_bus *bus)
@@ -828,7 +857,11 @@ static void hotplug_event(acpi_handle ha
 					    ACPI_UINT32_MAX, check_sub_bridges,
 					    NULL, NULL, NULL);
 		} else {
-			acpiphp_enable_slot(func->slot);
+			struct acpiphp_slot *slot = func->slot;
+
+			mutex_lock(&slot->crit_sect);
+			enable_device(slot);
+			mutex_unlock(&slot->crit_sect);
 		}
 		break;
 

