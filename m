Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab3L0ADy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 19:03:54 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:49846 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753948Ab3L0ADv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 19:03:51 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Agustin Barto <abarto@gmail.com>
Subject: [PATCH] PCI / ACPI: Install wakeup notify handlers for all PCI devs with ACPI
Date: Fri, 27 Dec 2013 01:17:22 +0100
Message-ID: <2145694.TZRgVXpeL1@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

It turns out that some BIOSes don't report wakeup GPEs through
_PRW, but use them for signaling wakeup anyway, which causes GPE
storms to occur on some systems after resume from system suspend.
This issue has been uncovered by commit d2e5f0c16ad6 (ACPI / PCI:
Rework the setup and cleanup of device wakeup) during the 3.9
development cycle.

Work around the problem by installing wakeup notify handlers for all
PCI devices with ACPI support (i.e. having ACPI companions) regardless
of whether or not the BIOS reports ACPI wakeup support for them.  The
presence of the wakeup notify handlers alone is not harmful in any
way if there are no events for them to handle (they are simply never
executed then), but on some systems they are needed to take care of
spurious events.

Fixes: d2e5f0c16ad6 (ACPI / PCI: Rework the setup and cleanup of device wakeup)
References: https://bugzilla.kernel.org/show_bug.cgi?id=63021
Reported-and-tested-by: Agustin Barto <abarto@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/pci-acpi.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

Index: linux-pm/drivers/pci/pci-acpi.c
===================================================================
--- linux-pm.orig/drivers/pci/pci-acpi.c
+++ linux-pm/drivers/pci/pci-acpi.c
@@ -325,29 +325,32 @@ static struct acpi_device *acpi_pci_find
 static void pci_acpi_setup(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	acpi_handle handle = ACPI_HANDLE(dev);
-	struct acpi_device *adev;
+	struct acpi_device *adev = ACPI_COMPANION(dev);
 
-	if (acpi_bus_get_device(handle, &adev) || !adev->wakeup.flags.valid)
+	if (!adev)
+		return;
+
+	pci_acpi_add_pm_notifier(adev, pci_dev);
+	if (!adev->wakeup.flags.valid)
 		return;
 
 	device_set_wakeup_capable(dev, true);
 	acpi_pci_sleep_wake(pci_dev, false);
-
-	pci_acpi_add_pm_notifier(adev, pci_dev);
 	if (adev->wakeup.flags.run_wake)
 		device_set_run_wake(dev, true);
 }
 
 static void pci_acpi_cleanup(struct device *dev)
 {
-	acpi_handle handle = ACPI_HANDLE(dev);
-	struct acpi_device *adev;
+	struct acpi_device *adev = ACPI_COMPANION(dev);
+
+	if (!adev)
+		return;
 
-	if (!acpi_bus_get_device(handle, &adev) && adev->wakeup.flags.valid) {
+	pci_acpi_remove_pm_notifier(adev);
+	if (adev->wakeup.flags.valid) {
 		device_set_wakeup_capable(dev, false);
 		device_set_run_wake(dev, false);
-		pci_acpi_remove_pm_notifier(adev);
 	}
 }
 

