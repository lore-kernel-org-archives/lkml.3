Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346Ab3CWOZo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 10:25:44 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:36175 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973Ab3CWOZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 10:25:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>, linux-pci@vger.kernel.org
Subject: [PATCH] PCI / ACPI: Always resume devices on ACPI wakeup notifications
Date: Sat, 23 Mar 2013 15:33:03 +0100
Message-ID: <2282655.IicBMMa6jN@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc3+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

It turns out that _Lxx control methods provided by some BIOSes clear
the PME Status bit of PCI devices they handle, which means that
pci_acpi_wake_dev() cannot really use that bit to check whether or
not the device has signalled wakeup.

For this reason, make pci_acpi_wake_dev() always attempt to resume
the device it is called for regardless of the device's PME Status bit
value (that bit still has to be cleared if set at this point,
though).

Reported-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/pci-acpi.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

Index: linux-pm/drivers/pci/pci-acpi.c
===================================================================
--- linux-pm.orig/drivers/pci/pci-acpi.c
+++ linux-pm/drivers/pci/pci-acpi.c
@@ -53,14 +53,15 @@ static void pci_acpi_wake_dev(acpi_handl
 		return;
 	}
 
-	if (!pci_dev->pm_cap || !pci_dev->pme_support
-	     || pci_check_pme_status(pci_dev)) {
-		if (pci_dev->pme_poll)
-			pci_dev->pme_poll = false;
+	/* Clear PME Status if set. */
+	if (pci_dev->pme_support)
+		pci_check_pme_status(pci_dev);
 
-		pci_wakeup_event(pci_dev);
-		pm_runtime_resume(&pci_dev->dev);
-	}
+	if (pci_dev->pme_poll)
+		pci_dev->pme_poll = false;
+
+	pci_wakeup_event(pci_dev);
+	pm_runtime_resume(&pci_dev->dev);
 
 	if (pci_dev->subordinate)
 		pci_pme_wakeup_bus(pci_dev->subordinate);

