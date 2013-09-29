Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341Ab3I2Tou (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:44:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59549 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755862Ab3I2T2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:28:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [ 01/71] PCI / ACPI / PM: Clear pme_poll for devices in D3cold on wakeup
Date: Sun, 29 Sep 2013 12:27:13 -0700
Message-Id: <20130929192643.645675433@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929192643.539596256@linuxfoundation.org>
References: <20130929192643.539596256@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

commit 834145156bedadfb50121f0bc5e9d9f9f942bcca upstream.

Commit 448bd85 (PCI/PM: add PCIe runtime D3cold support) added a
piece of code to pci_acpi_wake_dev() causing that function to behave
in a special way for devices in D3cold (so that their configuration
registers are not accessed before those devices are resumed).
However, it didn't take the clearing of the pme_poll flag into
account.  That has to be done for all devices, even if they are in
D3cold, or pci_pme_list_scan() will not know that wakeup has been
signaled for the device and will poll its PME Status bit
unnecessarily.

Fix the problem by moving the clearing of the pme_poll flag in
pci_acpi_wake_dev() before the code introduced by commit 448bd85.

Reported-and-tested-by: David E. Box <david.e.box@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/pci-acpi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
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
 


