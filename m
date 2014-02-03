Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbaBCX3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 18:29:09 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:54097 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753844AbaBCX2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 18:28:32 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Subject: [PATCH 1/24][Resend] ACPI / hotplug / PCI: Remove entries from bus->devices in reverse order
Date: Tue, 04 Feb 2014 00:14:48 +0100
Message-ID: <1839968.W3QXGMsfBF@vostro.rjw.lan>
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

According to the changelog of commit 29ed1f29b68a (PCI: pciehp: Fix null
pointer deref when hot-removing SR-IOV device) it is unsafe to walk the
bus->devices list of a PCI bus and remove devices from it in direct order,
because that may lead to NULL pointer dereferences related to virtual
functions.

For this reason, change all of the bus->devices list walks in
acpiphp_glue.c during which devices may be removed to be carried out in
reverse order.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
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
