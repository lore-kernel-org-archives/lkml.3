Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbaBCXbn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 18:31:43 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:53012 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753672AbaBCX21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 18:28:27 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Subject: [PATCH 9/24][Resend] ACPI / hotplug / PCI: Drop acpiphp_bus_trim()
Date: Tue, 04 Feb 2014 00:23:27 +0100
Message-ID: <1689985.1LxlJr9Vc9@vostro.rjw.lan>
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

If trim_stale_devices() calls acpi_bus_trim() directly, we can
save a potentially costly acpi_bus_get_device() invocation.  After
making that change acpiphp_bus_trim() would only be called from one
place, so move the code from it to that place and drop it.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |   30 +++++++++++-------------------
 1 file changed, 11 insertions(+), 19 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -489,19 +489,6 @@ static unsigned char acpiphp_max_busnr(s
 }
 
 /**
- * acpiphp_bus_trim - Trim device objects in an ACPI namespace subtree.
- * @handle: ACPI device object handle to start from.
- */
-static void acpiphp_bus_trim(acpi_handle handle)
-{
-	struct acpi_device *adev = NULL;
-
-	acpi_bus_get_device(handle, &adev);
-	if (adev)
-		acpi_bus_trim(adev);
-}
-
-/**
  * acpiphp_bus_add - Scan ACPI namespace subtree.
  * @handle: ACPI object handle to start the scan from.
  */
@@ -641,8 +628,12 @@ static void disable_slot(struct acpiphp_
 		if (PCI_SLOT(dev->devfn) == slot->device)
 			pci_stop_and_remove_bus_device(dev);
 
-	list_for_each_entry(func, &slot->funcs, sibling)
-		acpiphp_bus_trim(func_to_handle(func));
+	list_for_each_entry(func, &slot->funcs, sibling) {
+		struct acpi_device *adev;
+
+		if (!acpi_bus_get_device(func_to_handle(func), &adev))
+			acpi_bus_trim(adev);
+	}
 
 	slot->flags &= (~SLOT_ENABLED);
 }
@@ -714,11 +705,12 @@ static unsigned int get_slot_status(stru
  */
 static void trim_stale_devices(struct pci_dev *dev)
 {
-	acpi_handle handle = ACPI_HANDLE(&dev->dev);
+	struct acpi_device *adev = ACPI_COMPANION(&dev->dev);
 	struct pci_bus *bus = dev->subordinate;
 	bool alive = false;
 
-	if (handle) {
+	if (adev) {
+		acpi_handle handle = adev->handle;
 		acpi_status status;
 		unsigned long long sta;
 
@@ -734,8 +726,8 @@ static void trim_stale_devices(struct pc
 	}
 	if (!alive) {
 		pci_stop_and_remove_bus_device(dev);
-		if (handle)
-			acpiphp_bus_trim(handle);
+		if (adev)
+			acpi_bus_trim(adev);
 	} else if (bus) {
 		struct pci_dev *child, *tmp;
 

