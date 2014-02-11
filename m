Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbaBKAEg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 19:04:36 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:55517 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752850AbaBKAEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 19:04:30 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux PCI <linux-pci@vger.kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 2/2] ACPI / hotplug / PCI: Add ACPIPHP contexts to devices handled by PCIeHP
Date: Tue, 11 Feb 2014 01:18:37 +0100
Message-ID: <6623444.enfLAe3lRN@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1461050.jQppMgDSvA@vostro.rjw.lan>
References: <1461050.jQppMgDSvA@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Currently, ACPIPHP does not add hotplug context to devices that
should be handled by the native PCI hotplug (PCIeHP) code.  The
reason why was because PCIeHP didn't know about the devices'
connections with ACPI and would not clean up things properly
during an eject of an ACPI-backed device, for example.

However, after recent changes that made the ACPI core create struct
acpi_device objects for all namespace nodes regardless of the
underlying devices' status and added PCI rescan-remove locking to
both ACPIPHP and PCIeHP, that concern is not valid any more.
Namely, after those changes PCIeHP need not care about the ACPI
side of things any more and it should be serialized with respect to
ACPIPHP and they won't be running concurrently with each other in
any case.

For this reason, make ACPIPHP to add its hotplug context to
all devices with ACPI companions, even the ones that should be
handled by PCIeHP in principle.  That may work around hotplug
issues on some systems where PCIeHP is supposed to work, but it
doesn't and the ACPI hotplug signaling works instead.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -277,9 +277,6 @@ static acpi_status acpiphp_add_context(a
 	struct pci_dev *pdev = bridge->pci_dev;
 	u32 val;
 
-	if (pdev && device_is_managed_by_native_pciehp(pdev))
-		return AE_OK;
-
 	status = acpi_evaluate_integer(handle, "_ADR", NULL, &adr);
 	if (ACPI_FAILURE(status)) {
 		if (status != AE_NOT_FOUND)
@@ -338,8 +335,14 @@ static acpi_status acpiphp_add_context(a
 
 	list_add_tail(&slot->node, &bridge->slots);
 
-	/* Register slots for ejectable functions only. */
-	if (acpi_pci_check_ejectable(pbus, handle)  || is_dock_device(handle)) {
+	/*
+	 * Expose slots to user space for functions that have _EJ0 or _RMV or
+	 * are located in dock stations.  Do not expose them for devices handled
+	 * by the native PCIe hotplug (PCIeHP), becuase that code is supposed to
+	 * expose slots to user space in those cases.
+	 */
+	if ((acpi_pci_check_ejectable(pbus, handle) || is_dock_device(handle))
+	    && !(pdev && device_is_managed_by_native_pciehp(pdev))) {
 		unsigned long long sun;
 		int retval;
 

