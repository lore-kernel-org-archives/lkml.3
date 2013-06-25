Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407Ab3FYQU7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 12:20:59 -0400
Received: from mga14.intel.com ([143.182.124.37]:29715 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206Ab3FYQTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 12:19:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,938,1363158000"; 
   d="scan'208";a="322373891"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Yinghai Lu <yinghai@kernel.org>,
        john.ronciak@intel.com, miles.j.penner@intel.com,
        bruce.w.allan@intel.com,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        x86@kernel.org
Subject: [PATCH 4/6] PCI: acpiphp: check for new devices on enabled host
Date: Tue, 25 Jun 2013 19:22:08 +0300
Message-Id: <1372177330-28013-5-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1372177330-28013-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1372177330-28013-1-git-send-email-mika.westerberg@linux.intel.com>
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

For ACPI_STA_ALL state we first trim devices which don't respond and
look for the ones after that. We do that even if slot already enabled
(SLOT_ENABLED).

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c | 56 ++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 29 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 80a6ea1..82a4ec9 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -868,43 +868,41 @@ int acpiphp_eject_slot(struct acpiphp_slot *slot)
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
+			list_for_each_entry_safe(dev, tmp,
+					&bus->devices, bus_list) {
+				if (PCI_SLOT(dev->devfn) != slot->device)
+					continue;
+				pci_trim_stale_devices(dev);
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
-- 
1.8.3.1

