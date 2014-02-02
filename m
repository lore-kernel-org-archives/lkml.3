Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbaBBAUQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 19:20:16 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:59177 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754804AbaBBASU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 19:18:20 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v2 6/13] ACPI / hotplug / PCI: Drop acpiphp_bus_trim()
Date: Sun, 02 Feb 2014 01:26:12 +0100
Message-ID: <2923642.zryv5SIjaW@vostro.rjw.lan>
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

If trim_stale_devices() calls acpi_bus_trim() directly, we can
save a potentially costly acpi_bus_get_device() invocation.  After
making that change acpiphp_bus_trim() would only be called from one
place, so move the code from it to that place and drop it.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |   30 +++++++++++-------------------
 1 file changed, 11 insertions(+), 19 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -468,19 +468,6 @@ static unsigned char acpiphp_max_busnr(s
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
@@ -620,8 +607,12 @@ static void disable_slot(struct acpiphp_
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
@@ -693,11 +684,12 @@ static unsigned int get_slot_status(stru
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
 
@@ -713,8 +705,8 @@ static void trim_stale_devices(struct pc
 	}
 	if (!alive) {
 		pci_stop_and_remove_bus_device(dev);
-		if (handle)
-			acpiphp_bus_trim(handle);
+		if (adev)
+			acpi_bus_trim(adev);
 	} else if (bus) {
 		struct pci_dev *child, *tmp;
 

