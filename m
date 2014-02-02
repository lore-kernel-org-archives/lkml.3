Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbaBBASZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 19:18:25 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:59500 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754850AbaBBASW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 19:18:22 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v2 3/13] ACPI / hotplug / PCI: Simplify disable_slot()
Date: Sun, 02 Feb 2014 01:23:30 +0100
Message-ID: <1662988.VQzBl3dffR@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <1935791.liE9ZlzmO9@vostro.rjw.lan>
References: <2217793.001RY6hKlo@vostro.rjw.lan> <1935791.liE9ZlzmO9@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

After recent PCI core changes related to the rescan/remove locking,
the ACPIPHP's disable_slot() function is only called under the
general PCI rescan/remove lock, so it doesn't have to use
dev_in_slot() any more to avoid race conditions.  Make it simply
walk the devices on the bus and drop the ones in the slot being
disabled and drop dev_in_slot() which has no more users.

Moreover, to avoid problems described in the changelog of commit
29ed1f29b68a (PCI: pciehp: Fix null pointer deref when hot-removing
SR-IOV device), make disable_slot() carry out the list walk in
reverse order.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |   28 +++++-----------------------
 1 file changed, 5 insertions(+), 23 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -604,32 +604,15 @@ static void __ref enable_slot(struct acp
 	}
 }
 
-/* return first device in slot, acquiring a reference on it */
-static struct pci_dev *dev_in_slot(struct acpiphp_slot *slot)
-{
-	struct pci_bus *bus = slot->bus;
-	struct pci_dev *dev;
-	struct pci_dev *ret = NULL;
-
-	down_read(&pci_bus_sem);
-	list_for_each_entry(dev, &bus->devices, bus_list)
-		if (PCI_SLOT(dev->devfn) == slot->device) {
-			ret = pci_dev_get(dev);
-			break;
-		}
-	up_read(&pci_bus_sem);
-
-	return ret;
-}
-
 /**
  * disable_slot - disable a slot
  * @slot: ACPI PHP slot
  */
 static void disable_slot(struct acpiphp_slot *slot)
 {
+	struct pci_bus *bus = slot->bus;
+	struct pci_dev *dev, *prev;
 	struct acpiphp_func *func;
-	struct pci_dev *pdev;
 
 	/*
 	 * enable_slot() enumerates all functions in this device via
@@ -637,10 +620,9 @@ static void disable_slot(struct acpiphp_
 	 * methods (_EJ0, etc.) or not.  Therefore, we remove all functions
 	 * here.
 	 */
-	while ((pdev = dev_in_slot(slot))) {
-		pci_stop_and_remove_bus_device(pdev);
-		pci_dev_put(pdev);
-	}
+	list_for_each_entry_safe_reverse(dev, prev, &bus->devices, bus_list)
+		if (PCI_SLOT(dev->devfn) == slot->device)
+			pci_stop_and_remove_bus_device(dev);
 
 	list_for_each_entry(func, &slot->funcs, sibling)
 		acpiphp_bus_trim(func_to_handle(func));

