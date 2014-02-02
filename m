Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105AbaBBATW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 19:19:22 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:58459 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754861AbaBBASX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 19:18:23 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v2 1/13] ACPI / hotplug / PCI: Remove entries from bus->devices in reverse order
Date: Sun, 02 Feb 2014 01:21:17 +0100
Message-ID: <2191766.e0OEb5Pek7@vostro.rjw.lan>
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

According to the changelog of commit 29ed1f29b68a (PCI: pciehp: Fix null
pointer deref when hot-removing SR-IOV device) it is unsafe to walk the
bus->devices list of a PCI bus and remove devices from it in direct order,
because that may lead to NULL pointer dereferences related to virtual
functions.

For this reason, change all of the bus->devices list walks in
acpiphp_glue.c during which devices may be removed to be carried out in
reverse order.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -742,7 +742,7 @@ static void trim_stale_devices(struct pc
 
 		/* The device is a bridge. so check the bus below it. */
 		pm_runtime_get_sync(&dev->dev);
-		list_for_each_entry_safe(child, tmp, &bus->devices, bus_list)
+		list_for_each_entry_safe_reverse(child, tmp, &bus->devices, bus_list)
 			trim_stale_devices(child);
 
 		pm_runtime_put(&dev->dev);
@@ -773,8 +773,8 @@ static void acpiphp_check_bridge(struct
 			; /* do nothing */
 		} else if (get_slot_status(slot) == ACPI_STA_ALL) {
 			/* remove stale devices if any */
-			list_for_each_entry_safe(dev, tmp, &bus->devices,
-						 bus_list)
+			list_for_each_entry_safe_reverse(dev, tmp,
+							 &bus->devices, bus_list)
 				if (PCI_SLOT(dev->devfn) == slot->device)
 					trim_stale_devices(dev);
 
@@ -805,7 +805,7 @@ static void acpiphp_sanitize_bus(struct
 	int i;
 	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM;
 
-	list_for_each_entry_safe(dev, tmp, &bus->devices, bus_list) {
+	list_for_each_entry_safe_reverse(dev, tmp, &bus->devices, bus_list) {
 		for (i=0; i<PCI_BRIDGE_RESOURCES; i++) {
 			struct resource *res = &dev->resource[i];
 			if ((res->flags & type_mask) && !res->start &&

