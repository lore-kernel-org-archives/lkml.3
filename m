Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424Ab3JJPpm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:45:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52710 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756384Ab3JJPpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:45:38 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 052/104] PCI / ACPI / PM: Clear pme_poll for devices in D3cold on wakeup
Date: Thu, 10 Oct 2013 08:41:40 -0700
Message-Id: <1381419752-29733-53-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/pci/pci-acpi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
index 21354bf..e1e3d1b 100644
--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
@@ -47,6 +47,9 @@ static void pci_acpi_wake_dev(acpi_handle handle, u32 event, void *context)
 	if (event != ACPI_NOTIFY_DEVICE_WAKE || !pci_dev)
 		return;
 
+	if (pci_dev->pme_poll)
+		pci_dev->pme_poll = false;
+
 	if (pci_dev->current_state == PCI_D3cold) {
 		pci_wakeup_event(pci_dev);
 		pm_runtime_resume(&pci_dev->dev);
@@ -57,9 +60,6 @@ static void pci_acpi_wake_dev(acpi_handle handle, u32 event, void *context)
 	if (pci_dev->pme_support)
 		pci_check_pme_status(pci_dev);
 
-	if (pci_dev->pme_poll)
-		pci_dev->pme_poll = false;
-
 	pci_wakeup_event(pci_dev);
 	pm_runtime_resume(&pci_dev->dev);
 
-- 
1.8.1.2

