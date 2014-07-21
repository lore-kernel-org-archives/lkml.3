Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759AbaGUAee (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 20:34:34 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:63161 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751353AbaGUAed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 20:34:33 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] ACPI / PCI: Use ACPI_COMPANION() instead of ACPI_HANDLE()
Date: Mon, 21 Jul 2014 02:52:53 +0200
Message-ID: <2972136.muxEZR9mUT@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The ACPI_HANDLE() macro evaluates ACPI_COMPANION() internally to
return the handle of the device's ACPI companion, so it is much
more straightforward and efficient to use ACPI_COMPANION()
directly to obtain the device's ACPI companion object instead of
using ACPI_HANDLE() and acpi_bus_get_device() on the returned
handle for the same thing.

Use ACPI_COMPANION() instead of ACPI_HANDLE() in the PCI ACPI support
code.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/pci-acpi.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

Index: linux-pm/drivers/pci/pci-acpi.c
===================================================================
--- linux-pm.orig/drivers/pci/pci-acpi.c
+++ linux-pm/drivers/pci/pci-acpi.c
@@ -175,14 +175,13 @@ static pci_power_t acpi_pci_choose_state
 
 static bool acpi_pci_power_manageable(struct pci_dev *dev)
 {
-	acpi_handle handle = ACPI_HANDLE(&dev->dev);
-
-	return handle ? acpi_bus_power_manageable(handle) : false;
+	struct acpi_device *adev = ACPI_COMPANION(&dev->dev);
+	return adev ? acpi_device_power_manageable(adev) : false;
 }
 
 static int acpi_pci_set_power_state(struct pci_dev *dev, pci_power_t state)
 {
-	acpi_handle handle = ACPI_HANDLE(&dev->dev);
+	struct acpi_device *adev = ACPI_COMPANION(&dev->dev);
 	static const u8 state_conv[] = {
 		[PCI_D0] = ACPI_STATE_D0,
 		[PCI_D1] = ACPI_STATE_D1,
@@ -193,7 +192,7 @@ static int acpi_pci_set_power_state(stru
 	int error = -EINVAL;
 
 	/* If the ACPI device has _EJ0, ignore the device */
-	if (!handle || acpi_has_method(handle, "_EJ0"))
+	if (!adev || acpi_has_method(adev->handle, "_EJ0"))
 		return -ENODEV;
 
 	switch (state) {
@@ -207,7 +206,7 @@ static int acpi_pci_set_power_state(stru
 	case PCI_D1:
 	case PCI_D2:
 	case PCI_D3hot:
-		error = acpi_bus_set_power(handle, state_conv[state]);
+		error = acpi_device_set_power(adev, state_conv[state]);
 	}
 
 	if (!error)
@@ -219,9 +218,8 @@ static int acpi_pci_set_power_state(stru
 
 static bool acpi_pci_can_wakeup(struct pci_dev *dev)
 {
-	acpi_handle handle = ACPI_HANDLE(&dev->dev);
-
-	return handle ? acpi_bus_can_wakeup(handle) : false;
+	struct acpi_device *adev = ACPI_COMPANION(&dev->dev);
+	return adev ? acpi_device_can_wakeup(adev) : false;
 }
 
 static void acpi_pci_propagate_wakeup_enable(struct pci_bus *bus, bool enable)

