Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934269Ab3GQX1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:27:24 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:47813 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757698Ab3GQX1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 19:27:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 28/30] ACPI / hotplug / PCI: Redefine enable_device() and disable_device()
Date: Thu, 18 Jul 2013 01:35:05 +0200
Message-ID: <15117547.14X2XaKnYp@vostro.rjw.lan>
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

Notice that functions enable_device() and disable_device() cannot
fail and their return values are ignored in the majority of places,
so redefine them as void and use the opportunity to change their
names to enable_slot() and disable_slot(), respectively, which much
better reflects what they do.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |   33 ++++++++++++---------------------
 1 file changed, 12 insertions(+), 21 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -532,13 +532,13 @@ static void check_hotplug_bridge(struct
 }
 
 /**
- * enable_device - enable, configure a slot
+ * enable_slot - enable, configure a slot
  * @slot: slot to be enabled
  *
  * This function should be called per *physical slot*,
  * not per each slot object in ACPI namespace.
  */
-static int __ref enable_device(struct acpiphp_slot *slot)
+static void __ref enable_slot(struct acpiphp_slot *slot)
 {
 	struct pci_dev *dev;
 	struct pci_bus *bus = slot->bus;
@@ -556,6 +556,7 @@ static int __ref enable_device(struct ac
 		list_for_each_entry(dev, &bus->devices, bus_list) {
 			if (PCI_SLOT(dev->devfn) != slot->device)
 				continue;
+
 			if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE ||
 			    dev->hdr_type == PCI_HEADER_TYPE_CARDBUS) {
 				max = pci_scan_bridge(bus, dev, max, pass);
@@ -594,8 +595,6 @@ static int __ref enable_device(struct ac
 			continue;
 		}
 	}
-
-	return 0;
 }
 
 /* return first device in slot, acquiring a reference on it */
@@ -617,16 +616,16 @@ static struct pci_dev *dev_in_slot(struc
 }
 
 /**
- * disable_device - disable a slot
+ * disable_slot - disable a slot
  * @slot: ACPI PHP slot
  */
-static int disable_device(struct acpiphp_slot *slot)
+static void disable_slot(struct acpiphp_slot *slot)
 {
 	struct acpiphp_func *func;
 	struct pci_dev *pdev;
 
 	/*
-	 * enable_device() enumerates all functions in this device via
+	 * enable_slot() enumerates all functions in this device via
 	 * pci_scan_slot(), whether they have associated ACPI hotplug
 	 * methods (_EJ0, etc.) or not.  Therefore, we remove all functions
 	 * here.
@@ -640,8 +639,6 @@ static int disable_device(struct acpiphp
 		acpiphp_bus_trim(func_to_handle(func));
 
 	slot->flags &= (~SLOT_ENABLED);
-
-	return 0;
 }
 
 
@@ -751,9 +748,9 @@ static void acpiphp_check_bridge(struct
 					trim_stale_devices(dev);
 
 			/* configure all functions */
-			enable_device(slot);
+			enable_slot(slot);
 		} else {
-			disable_device(slot);
+			disable_slot(slot);
 		}
 		mutex_unlock(&slot->crit_sect);
 	}
@@ -860,7 +857,7 @@ static void hotplug_event(acpi_handle ha
 			struct acpiphp_slot *slot = func->slot;
 
 			mutex_lock(&slot->crit_sect);
-			enable_device(slot);
+			enable_slot(slot);
 			mutex_unlock(&slot->crit_sect);
 		}
 		break;
@@ -1047,16 +1044,13 @@ void acpiphp_remove_slots(struct pci_bus
  */
 int acpiphp_enable_slot(struct acpiphp_slot *slot)
 {
-	int retval = 0;
-
 	mutex_lock(&slot->crit_sect);
-
 	/* configure all functions */
 	if (!(slot->flags & SLOT_ENABLED))
-		retval = enable_device(slot);
+		enable_slot(slot);
 
 	mutex_unlock(&slot->crit_sect);
-	return retval;
+	return 0;
 }
 
 /**
@@ -1071,9 +1065,7 @@ int acpiphp_disable_and_eject_slot(struc
 	mutex_lock(&slot->crit_sect);
 
 	/* unconfigure all functions */
-	retval = disable_device(slot);
-	if (retval)
-		goto err_exit;
+	disable_slot(slot);
 
 	list_for_each_entry(func, &slot->funcs, sibling)
 		if (func->flags & FUNC_HAS_EJ0) {
@@ -1085,7 +1077,6 @@ int acpiphp_disable_and_eject_slot(struc
 			break;
 		}
 
- err_exit:
 	mutex_unlock(&slot->crit_sect);
 	return retval;
 }

