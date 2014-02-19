Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbaBSKNv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 05:13:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbaBSKNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 05:13:48 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org
Subject: [PATCH] portdrv: Use pci_enable_msix_range() instead of pci_enable_msix()
Date: Wed, 19 Feb 2014 11:15:26 +0100
Message-Id: <1392804931-30671-6-git-send-email-agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org
---
 drivers/pci/pcie/portdrv_core.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
index 986f8ea..4e46eca 100644
--- a/drivers/pci/pcie/portdrv_core.c
+++ b/drivers/pci/pcie/portdrv_core.c
@@ -99,8 +99,9 @@ static int pcie_port_enable_msix(struct pci_dev *dev, int *vectors, int mask)
 	for (i = 0; i < nr_entries; i++)
 		msix_entries[i].entry = i;
 
-	status = pci_enable_msix(dev, msix_entries, nr_entries);
-	if (status)
+	status = pci_enable_msix_range(dev,
+				       msix_entries, nr_entries, nr_entries);
+	if (status < 0)
 		goto Exit;
 
 	for (i = 0; i < PCIE_PORT_DEVICE_MAXSERVICES; i++)
@@ -159,21 +160,23 @@ static int pcie_port_enable_msix(struct pci_dev *dev, int *vectors, int mask)
 		idx[PCIE_PORT_SERVICE_AER_SHIFT] = i;
 	}
 
+	status = 0;
+
 	/*
 	 * If nvec is equal to the allocated number of entries, we can just use
 	 * what we have.  Otherwise, the port has some extra entries not for the
 	 * services we know and we need to work around that.
 	 */
-	if (nvec == nr_entries) {
-		status = 0;
-	} else {
+	if (nvec != nr_entries) {
 		/* Drop the temporary MSI-X setup */
 		pci_disable_msix(dev);
 
 		/* Now allocate the MSI-X vectors for real */
-		status = pci_enable_msix(dev, msix_entries, nvec);
-		if (status)
+		nvec = pci_enable_msix_range(dev, msix_entries, nvec, nvec);
+		if (nvec < 0) {
+			status = nvec;
 			goto Exit;
+		}
 	}
 
 	for (i = 0; i < PCIE_PORT_DEVICE_MAXSERVICES; i++)
-- 
1.7.7.6

