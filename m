Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517Ab3GKX6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 19:58:49 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:38974 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279Ab3GKX6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 19:58:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [RFC][PATCH 30/30] ACPI / hotplug / PCI: Clean up bridge_mutex usage
Date: Fri, 12 Jul 2013 02:07:53 +0200
Message-ID: <1556050.sitoT3kI8H@vostro.rjw.lan>
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

Do not acquire bridge_mutex around the addition of a slot to its
bridge's list of slots and arount the addition of a function to
its slot's list of functions, because that doesn't help anything
right now (those lists are walked without any locking anyway).

However, acquire bridge_mutex around the list walk in
acpiphp_remove_slots() and use list_for_each_entry() there,
because we terminate the walk as soon as we find the first matching
entry.  This prevents that list walk from colliding with bridge
addition and removal.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -324,9 +324,7 @@ static acpi_status register_slot(acpi_ha
 	INIT_LIST_HEAD(&slot->funcs);
 	mutex_init(&slot->crit_sect);
 
-	mutex_lock(&bridge_mutex);
 	list_add_tail(&slot->node, &bridge->slots);
-	mutex_unlock(&bridge_mutex);
 
 	/* Register slots for ejectable funtions only. */
 	if (acpi_pci_check_ejectable(pbus, handle)  || is_dock_device(handle)) {
@@ -357,9 +355,7 @@ static acpi_status register_slot(acpi_ha
 
  slot_found:
 	newfunc->slot = slot;
-	mutex_lock(&bridge_mutex);
 	list_add_tail(&newfunc->sibling, &slot->funcs);
-	mutex_unlock(&bridge_mutex);
 
 	if (pci_bus_read_dev_vendor_id(pbus, PCI_DEVFN(device, function),
 				       &val, 60*1000))
@@ -997,17 +993,21 @@ void acpiphp_enumerate_slots(struct pci_
 /* Destroy hotplug slots associated with the PCI bus */
 void acpiphp_remove_slots(struct pci_bus *bus)
 {
-	struct acpiphp_bridge *bridge, *tmp;
+	struct acpiphp_bridge *bridge;
 
 	if (acpiphp_disabled)
 		return;
 
-	list_for_each_entry_safe(bridge, tmp, &bridge_list, list)
+	mutex_lock(&bridge_mutex);
+	list_for_each_entry(bridge, &bridge_list, list)
 		if (bridge->pci_bus == bus) {
+			mutex_unlock(&bridge_mutex);
 			cleanup_bridge(bridge);
 			put_bridge(bridge);
-			break;
+			return;
 		}
+
+	mutex_unlock(&bridge_mutex);
 }
 
 /**

