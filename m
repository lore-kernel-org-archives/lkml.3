Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab3GKX7H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 19:59:07 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:39058 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756759Ab3GKX7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 19:59:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [RFC][PATCH 10/30] ACPI / hotplug / PCI: Refactor slot allocation code in register_slot()
Date: Fri, 12 Jul 2013 01:49:13 +0200
Message-ID: <9817058.VIV33rM5GL@vostro.rjw.lan>
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

To make the code in register_slot() a bit easier to follow, change
the way the slot allocation part is organized.  Drop one local
variable that's not used any more after that modification.

This code change should not lead to any changes in behavior.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |   74 ++++++++++++++++++-------------------
 1 file changed, 36 insertions(+), 38 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -285,7 +285,7 @@ static acpi_status register_slot(acpi_ha
 	acpi_handle tmp;
 	acpi_status status = AE_OK;
 	unsigned long long adr, sun;
-	int device, function, retval, found = 0;
+	int device, function, retval;
 	struct pci_bus *pbus = bridge->pci_bus;
 	struct pci_dev *pdev;
 	u32 val;
@@ -354,44 +354,49 @@ static acpi_status register_slot(acpi_ha
 		if (slot->device == device) {
 			if (slot->sun != sun)
 				warn("sibling found, but _SUN doesn't match!\n");
-			found = 1;
-			break;
-		}
 
-	if (!found) {
-		slot = kzalloc(sizeof(struct acpiphp_slot), GFP_KERNEL);
-		if (!slot) {
-			status = AE_NO_MEMORY;
-			goto err_out;
+			goto slot_found;
 		}
 
-		slot->bridge = bridge;
-		slot->device = device;
-		slot->sun = sun;
-		INIT_LIST_HEAD(&slot->funcs);
-		mutex_init(&slot->crit_sect);
+	slot = kzalloc(sizeof(struct acpiphp_slot), GFP_KERNEL);
+	if (!slot) {
+		status = AE_NO_MEMORY;
+		goto err;
+	}
 
-		mutex_lock(&bridge_mutex);
-		list_add_tail(&slot->node, &bridge->slots);
-		mutex_unlock(&bridge_mutex);
-		bridge->nr_slots++;
+	slot->bridge = bridge;
+	slot->device = device;
+	slot->sun = sun;
+	INIT_LIST_HEAD(&slot->funcs);
+	mutex_init(&slot->crit_sect);
 
-		dbg("found ACPI PCI Hotplug slot %llu at PCI %04x:%02x:%02x\n",
-		    slot->sun, pci_domain_nr(pbus), pbus->number, device);
-		retval = acpiphp_register_hotplug_slot(slot);
-		if (retval) {
-			if (retval == -EBUSY)
-				warn("Slot %llu already registered by another "
-					"hotplug driver\n", slot->sun);
-			else
-				warn("acpiphp_register_hotplug_slot failed "
-					"(err code = 0x%x)\n", retval);
+	mutex_lock(&bridge_mutex);
+	list_add_tail(&slot->node, &bridge->slots);
+	mutex_unlock(&bridge_mutex);
+	bridge->nr_slots++;
 
-			status = AE_OK;
-			goto err;
-		}
+	dbg("found ACPI PCI Hotplug slot %llu at PCI %04x:%02x:%02x\n",
+	    slot->sun, pci_domain_nr(pbus), pbus->number, device);
+
+	retval = acpiphp_register_hotplug_slot(slot);
+	if (retval) {
+		if (retval == -EBUSY)
+			warn("Slot %llu already registered by another "
+				"hotplug driver\n", slot->sun);
+		else
+			warn("acpiphp_register_hotplug_slot failed "
+				"(err code = 0x%x)\n", retval);
+
+		bridge->nr_slots--;
+		mutex_lock(&bridge_mutex);
+		list_del(&slot->node);
+		mutex_unlock(&bridge_mutex);
+		kfree(slot);
+		status = AE_OK;
+		goto err;
 	}
 
+ slot_found:
 	newfunc->slot = slot;
 	mutex_lock(&bridge_mutex);
 	list_add_tail(&newfunc->sibling, &slot->funcs);
@@ -435,13 +440,6 @@ static acpi_status register_slot(acpi_ha
 	return AE_OK;
 
  err:
-	bridge->nr_slots--;
-	mutex_lock(&bridge_mutex);
-	list_del(&slot->node);
-	mutex_unlock(&bridge_mutex);
-	kfree(slot);
-
- err_out:
 	mutex_lock(&acpiphp_context_lock);
 	context->func = NULL;
 	acpiphp_put_context(context);

