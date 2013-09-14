Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261Ab3INB1R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 21:27:17 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:55865 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755913Ab3INB1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 21:27:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PCI <linux-pci@vger.kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Huang Ying <ying.huang@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "David E. Box" <david.e.box@intel.com>
Subject: [PATCH] PCI / ACPI / PM: Clear pme_poll for devices in D3cold on wakeup
Date: Sat, 14 Sep 2013 03:38:20 +0200
Message-ID: <4974289.QhzOmFXm0s@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Commit 448bd85 (PCI/PM: add PCIe runtime D3cold support) added a
piece of code to pci_acpi_wake_dev() causing that function to behave
in a special way for devices in D3cold (so that their configuration
registeres are not accessed before those devices are resumed).
However, it didn't take the clearing of the pme_poll flag into
account.  That has to be done for all devices, even if they are in
D3cold, or pci_pme_list_scan() will not know that wakeup has been
signaled for the device and will poll its PME Status bit
unnecessarily.

Fix the problem by moving the clearing of the pme_poll flag in
pci_acpi_wake_dev() before the code introduced by commit 448bd85.

Reported-and-tested-by: David E. Box <david.e.box@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: 3.6+ <stable@vger.kernel.org> # 3.6+
---
 drivers/pci/pci-acpi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-pm/drivers/pci/pci-acpi.c
===================================================================
--- linux-pm.orig/drivers/pci/pci-acpi.c
+++ linux-pm/drivers/pci/pci-acpi.c
@@ -47,6 +47,9 @@ static void pci_acpi_wake_dev(acpi_handl
 	if (event != ACPI_NOTIFY_DEVICE_WAKE || !pci_dev)
 		return;
 
+	if (pci_dev->pme_poll)
+		pci_dev->pme_poll = false;
+
 	if (pci_dev->current_state == PCI_D3cold) {
 		pci_wakeup_event(pci_dev);
 		pm_runtime_resume(&pci_dev->dev);
@@ -57,9 +60,6 @@ static void pci_acpi_wake_dev(acpi_handl
 	if (pci_dev->pme_support)
 		pci_check_pme_status(pci_dev);
 
-	if (pci_dev->pme_poll)
-		pci_dev->pme_poll = false;
-
 	pci_wakeup_event(pci_dev);
 	pm_runtime_resume(&pci_dev->dev);
 

