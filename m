Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443AbaBCXeL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 18:34:11 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:60142 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753542AbaBCX2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 18:28:25 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Subject: [PATCH 13/24][Resend] ACPI / hotplug / PCI: Drop crit_sect locking
Date: Tue, 04 Feb 2014 00:27:01 +0100
Message-ID: <5034851.lQfU1PoFxK@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <7532948.aJNUotNMpR@vostro.rjw.lan>
References: <2217793.001RY6hKlo@vostro.rjw.lan> <20140203104408.GQ18029@intel.com> <7532948.aJNUotNMpR@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

After recent PCI core changes related to the rescan/remove locking,
the code sections under crit_sect mutexes from ACPIPHP slot objects
are always executed under the general PCI rescan/remove lock.
For this reason, the crit_sect mutexes are simply redundant, so drop
them.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/pci/hotplug/acpiphp.h      |    1 -
 drivers/pci/hotplug/acpiphp_glue.c |   23 +++--------------------
 2 files changed, 3 insertions(+), 21 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -347,7 +347,6 @@ static acpi_status register_slot(acpi_ha
 	slot->bus = bridge->pci_bus;
 	slot->device = device;
 	INIT_LIST_HEAD(&slot->funcs);
-	mutex_init(&slot->crit_sect);
 
 	list_add_tail(&slot->node, &bridge->slots);
 
@@ -744,7 +743,6 @@ static void acpiphp_check_bridge(struct
 		struct pci_bus *bus = slot->bus;
 		struct pci_dev *dev, *tmp;
 
-		mutex_lock(&slot->crit_sect);
 		if (slot_no_hotplug(slot)) {
 			; /* do nothing */
 		} else if (get_slot_status(slot) == ACPI_STA_ALL) {
@@ -759,7 +757,6 @@ static void acpiphp_check_bridge(struct
 		} else {
 			disable_slot(slot);
 		}
-		mutex_unlock(&slot->crit_sect);
 	}
 }
 
@@ -846,12 +843,8 @@ static void hotplug_event(acpi_handle ha
 		} else {
 			struct acpiphp_slot *slot = func->slot;
 
-			if (slot->flags & SLOT_IS_GOING_AWAY)
-				break;
-
-			mutex_lock(&slot->crit_sect);
-			enable_slot(slot);
-			mutex_unlock(&slot->crit_sect);
+			if (!(slot->flags & SLOT_IS_GOING_AWAY))
+				enable_slot(slot);
 		}
 		break;
 
@@ -862,7 +855,6 @@ static void hotplug_event(acpi_handle ha
 			acpiphp_check_bridge(bridge);
 		} else {
 			struct acpiphp_slot *slot = func->slot;
-			int ret;
 
 			if (slot->flags & SLOT_IS_GOING_AWAY)
 				break;
@@ -871,10 +863,7 @@ static void hotplug_event(acpi_handle ha
 			 * Check if anything has changed in the slot and rescan
 			 * from the parent if that's the case.
 			 */
-			mutex_lock(&slot->crit_sect);
-			ret = acpiphp_rescan_slot(slot);
-			mutex_unlock(&slot->crit_sect);
-			if (ret)
+			if (acpiphp_rescan_slot(slot))
 				acpiphp_check_bridge(func->parent);
 		}
 		break;
@@ -1088,13 +1077,10 @@ int acpiphp_enable_slot(struct acpiphp_s
 	if (slot->flags & SLOT_IS_GOING_AWAY)
 		return -ENODEV;
 
-	mutex_lock(&slot->crit_sect);
 	/* configure all functions */
 	if (!(slot->flags & SLOT_ENABLED))
 		enable_slot(slot);
 
-	mutex_unlock(&slot->crit_sect);
-
 	pci_unlock_rescan_remove();
 	return 0;
 }
@@ -1110,8 +1096,6 @@ static int acpiphp_disable_and_eject_slo
 	if (slot->flags & SLOT_IS_GOING_AWAY)
 		return -ENODEV;
 
-	mutex_lock(&slot->crit_sect);
-
 	/* unconfigure all functions */
 	disable_slot(slot);
 
@@ -1125,7 +1109,6 @@ static int acpiphp_disable_and_eject_slo
 			break;
 		}
 
-	mutex_unlock(&slot->crit_sect);
 	return 0;
 }
 
Index: linux-pm/drivers/pci/hotplug/acpiphp.h
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp.h
+++ linux-pm/drivers/pci/hotplug/acpiphp.h
@@ -93,7 +93,6 @@ struct acpiphp_slot {
 	struct list_head funcs;		/* one slot may have different
 					   objects (i.e. for each function) */
 	struct slot *slot;
-	struct mutex crit_sect;
 
 	u8		device;		/* pci device# */
 	u32		flags;		/* see below */

