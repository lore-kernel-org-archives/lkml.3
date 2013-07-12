Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757169Ab3GLAGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 20:06:37 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:38989 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279Ab3GKX6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 19:58:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [RFC][PATCH 26/30] ACPI / hotplug / PCI: Check for new devices on enabled slots
Date: Fri, 12 Jul 2013 02:04:26 +0200
Message-ID: <2151956.sN7iU9NUtE@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <3718119.FLASu5DBx8@vostro.rjw.lan>
References: <26431283.HJCKsss0rt@vostro.rjw.lan> <3718119.FLASu5DBx8@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Subject: 

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

For slots in the ACPI_STA_ALL state devices that don't respond
are trimmed using a new function, pci_trim_stale_devices(),
introduced specifically for this purpose.  That function walks
the given bus and checks each device on it.  If the device doesn't
respond, it is assumed to be gone and removed.

Once all of the stale device objects on the bus have been removed,
we start looking for new devices that might have appeared on that
bus.  We do that even if the slot is already enabled (SLOT_ENABLED).

Moreover, make the bus check notification ignore SLOT_ENABLED and
go for enable_device() directly if bridge is NULL, so that devices
behind the slot are re-enumerated in that case too.

[rjw: Rebased, modified the changelog]
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |   49 +++++++++++++++----------------------
 drivers/pci/remove.c               |   20 +++++++++++++++
 include/linux/pci.h                |    1 
 3 files changed, 42 insertions(+), 28 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -705,41 +705,30 @@ static unsigned int get_slot_status(stru
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
-
-			retval = acpiphp_disable_and_eject_slot(slot);
-			if (retval)
-				goto err_exit;
+		struct pci_bus *bus = slot->bus;
+		struct pci_dev *dev, *tmp;
+
+		mutex_lock(&slot->crit_sect);
+		/* wake up all functions */
+		if (get_slot_status(slot) == ACPI_STA_ALL) {
+			/* remove stale devices if any */
+			list_for_each_entry_safe(dev, tmp, &bus->devices,
+						 bus_list)
+				if (PCI_SLOT(dev->devfn) == slot->device)
+					pci_trim_stale_devices(dev);
 
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
@@ -840,7 +829,11 @@ static void hotplug_event(acpi_handle ha
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
 
Index: linux-pm/drivers/pci/remove.c
===================================================================
--- linux-pm.orig/drivers/pci/remove.c
+++ linux-pm/drivers/pci/remove.c
@@ -112,6 +112,26 @@ void pci_stop_and_remove_bus_device(stru
 }
 EXPORT_SYMBOL(pci_stop_and_remove_bus_device);
 
+/**
+ * pci_trim_stale_devices - remove stale device or any stale child
+ */
+void pci_trim_stale_devices(struct pci_dev *dev)
+{
+	struct pci_bus *bus = dev->subordinate;
+	struct pci_dev *child, *tmp;
+	bool alive;
+	u32 l;
+
+	/* check if the device responds */
+	alive = pci_bus_read_dev_vendor_id(dev->bus, dev->devfn, &l, 0);
+	if (!alive)
+		pci_stop_and_remove_bus_device(dev);
+
+	if (alive && bus)
+		list_for_each_entry_safe(child, tmp, &bus->devices, bus_list)
+			pci_trim_stale_devices(child);
+}
+
 void pci_stop_root_bus(struct pci_bus *bus)
 {
 	struct pci_dev *child, *tmp;
Index: linux-pm/include/linux/pci.h
===================================================================
--- linux-pm.orig/include/linux/pci.h
+++ linux-pm/include/linux/pci.h
@@ -754,6 +754,7 @@ struct pci_dev *pci_dev_get(struct pci_d
 void pci_dev_put(struct pci_dev *dev);
 void pci_remove_bus(struct pci_bus *b);
 void pci_stop_and_remove_bus_device(struct pci_dev *dev);
+void pci_trim_stale_devices(struct pci_dev *dev);
 void pci_stop_root_bus(struct pci_bus *bus);
 void pci_remove_root_bus(struct pci_bus *bus);
 void pci_setup_cardbus(struct pci_bus *bus);

