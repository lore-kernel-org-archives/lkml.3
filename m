Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846Ab3GCOCi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 10:02:38 -0400
Received: from mga03.intel.com ([143.182.124.21]:16372 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932661Ab3GCOCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 10:02:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,988,1363158000"; 
   d="scan'208";a="263621141"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Yinghai Lu <yinghai@kernel.org>,
        john.ronciak@intel.com, miles.j.penner@intel.com,
        bruce.w.allan@intel.com,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, x86@kernel.org
Subject: [PATCH v2 4/8] PCI: acpiphp: check for new devices on enabled host
Date: Wed,  3 Jul 2013 17:04:51 +0300
Message-Id: <1372860295-8306-5-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1372860295-8306-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1372860295-8306-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

Current acpiphp_check_bridge() implementation is pretty dumb:
 - it enables the slot if it's not enabled and the slot status is
   ACPI_STA_ALL;
 - it disables the slot if it's enabled and slot is not in ACPI_STA_ALL
   state.

This behavior is not enough to handle Thunderbolt chaining case
properly. We need to actually rescan for new devices even if a device
has already in the slot.

The new implementation disables and stops the slot if it's not in
ACPI_STA_ALL state.

For ACPI_STA_ALL state we first trim devices which don't respond. In order
to support that we introduce a new function pci_trim_stale_devices() that
goes through the child devices of a given bus, check if the device is gone
and in that case stop and remove the device.

Once we have trimmed the bus we start looking for any new devices that
might have appeared on the bus. We do that even if the slot is already
enabled (SLOT_ENABLED).

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c | 55 ++++++++++++++++++--------------------
 drivers/pci/remove.c               | 20 ++++++++++++++
 include/linux/pci.h                |  1 +
 3 files changed, 47 insertions(+), 29 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 0f4da3b..c9ec06e 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -865,43 +865,40 @@ int acpiphp_eject_slot(struct acpiphp_slot *slot)
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
-			retval = acpiphp_disable_slot(slot);
-			if (retval) {
-				err("Error occurred in disabling\n");
-				goto err_exit;
-			} else {
-				acpiphp_eject_slot(slot);
+		struct pci_bus *bus = slot->bridge->pci_bus;
+		struct pci_dev *dev, *tmp;
+		int retval;
+
+		mutex_lock(&slot->crit_sect);
+		/* wake up all functions */
+		retval = power_on_slot(slot);
+		if (retval)
+			goto unlock;
+
+		if (get_slot_status(slot) == ACPI_STA_ALL) {
+			/* remove stale devices if any */
+			list_for_each_entry_safe(dev, tmp, &bus->devices,
+						 bus_list) {
+				if (PCI_SLOT(dev->devfn) == slot->device)
+					pci_trim_stale_devices(dev);
 			}
-			disabled++;
+
+			/* configure all functions */
+			retval = enable_device(slot);
+			if (retval)
+				power_off_slot(slot);
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
+			power_off_slot(slot);
 		}
+unlock:
+		mutex_unlock(&slot->crit_sect);
 	}
-
-	dbg("%s: %d enabled, %d disabled\n", __func__, enabled, disabled);
-
- err_exit:
-	return retval;
 }
 
 static void acpiphp_set_hpp_values(struct pci_bus *bus)
diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index 8fc54b7..77b7a64 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -112,6 +112,26 @@ void pci_stop_and_remove_bus_device(struct pci_dev *dev)
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
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 3a24e4f..8f6e7a0 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -754,6 +754,7 @@ struct pci_dev *pci_dev_get(struct pci_dev *dev);
 void pci_dev_put(struct pci_dev *dev);
 void pci_remove_bus(struct pci_bus *b);
 void pci_stop_and_remove_bus_device(struct pci_dev *dev);
+void pci_trim_stale_devices(struct pci_dev *dev);
 void pci_stop_root_bus(struct pci_bus *bus);
 void pci_remove_root_bus(struct pci_bus *bus);
 void pci_setup_cardbus(struct pci_bus *bus);
-- 
1.8.3.2

