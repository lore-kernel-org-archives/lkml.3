Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318AbaBCXdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 18:33:21 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51995 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753554AbaBCX20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 18:28:26 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Subject: [PATCH 12/24][Resend] ACPI / hotplug / PCI: Drop acpiphp_bus_add()
Date: Tue, 04 Feb 2014 00:26:06 +0100
Message-ID: <1535557.TbkE2ed7qM@vostro.rjw.lan>
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

acpiphp_bus_add() is only called from one place, so move the code out
of it into that place and drop it.  Also make that code use
func_to_acpi_device() to get the struct acpi_device pointer it needs
instead of calling acpi_bus_get_device() which may be costly.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |   22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -491,20 +491,6 @@ static unsigned char acpiphp_max_busnr(s
 	return max;
 }
 
-/**
- * acpiphp_bus_add - Scan ACPI namespace subtree.
- * @handle: ACPI object handle to start the scan from.
- */
-static void acpiphp_bus_add(acpi_handle handle)
-{
-	struct acpi_device *adev = NULL;
-
-	acpi_bus_scan(handle);
-	acpi_bus_get_device(handle, &adev);
-	if (acpi_device_enumerated(adev))
-		acpi_device_set_power(adev, ACPI_STATE_D0);
-}
-
 static void acpiphp_set_acpi_region(struct acpiphp_slot *slot)
 {
 	struct acpiphp_func *func;
@@ -544,9 +530,13 @@ static int acpiphp_rescan_slot(struct ac
 {
 	struct acpiphp_func *func;
 
-	list_for_each_entry(func, &slot->funcs, sibling)
-		acpiphp_bus_add(func_to_handle(func));
+	list_for_each_entry(func, &slot->funcs, sibling) {
+		struct acpi_device *adev = func_to_acpi_device(func);
 
+		acpi_bus_scan(adev->handle);
+		if (acpi_device_enumerated(adev))
+			acpi_device_set_power(adev, ACPI_STATE_D0);
+	}
 	return pci_scan_slot(slot->bus, PCI_DEVFN(slot->device, 0));
 }
 

