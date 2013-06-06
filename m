Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686Ab3FFSPw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 14:15:52 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:10606 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab3FFSPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 14:15:50 -0400
From: Betty Dall <betty.dall@hp.com>
To: rjw@sisk.pl, bhelgaas@google.com, gong.chen@linux.intel.com,
        greg.pearson@hp.com
Cc: ying.huang@intel.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Betty Dall <betty.dall@hp.com>
Subject: [PATCH v3 1/6] PCI/AER: Don't parse HEST table for non-PCIe devices
Date: Thu,  6 Jun 2013 12:10:46 -0600
Message-Id: <1370542251-27387-2-git-send-email-betty.dall@hp.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1370542251-27387-1-git-send-email-betty.dall@hp.com>
References: <1370542251-27387-1-git-send-email-betty.dall@hp.com>
Author: Bjorn Helgaas <bhelgaas@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AER is a PCIe-only capability, so there's no point in trying to match
a HEST PCIe structure with a non-PCIe device.

Previously, a HEST global AER bridge entry (type 8) could incorrectly
match *any* bridge, even a legacy PCI-PCI bridge, and a non-global
HEST entry could match a legacy PCI device.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Betty Dall <betty.dall@hp.com>
---

 drivers/pci/pcie/aer/aerdrv_acpi.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)


diff --git a/drivers/pci/pcie/aer/aerdrv_acpi.c b/drivers/pci/pcie/aer/aerdrv_acpi.c
index 5194a7d..4f798ab 100644
--- a/drivers/pci/pcie/aer/aerdrv_acpi.c
+++ b/drivers/pci/pcie/aer/aerdrv_acpi.c
@@ -59,8 +59,7 @@ static int aer_hest_parse(struct acpi_hest_header *hest_hdr, void *data)
 
 	p = (struct acpi_hest_aer_common *)(hest_hdr + 1);
 	if (p->flags & ACPI_HEST_GLOBAL) {
-		if ((pci_is_pcie(info->pci_dev) &&
-		     pci_pcie_type(info->pci_dev) == pcie_type) || bridge)
+		if ((pci_pcie_type(info->pci_dev) == pcie_type) || bridge)
 			ff = !!(p->flags & ACPI_HEST_FIRMWARE_FIRST);
 	} else
 		if (hest_match_pci(p, info->pci_dev))
@@ -89,6 +88,9 @@ static void aer_set_firmware_first(struct pci_dev *pci_dev)
 
 int pcie_aer_get_firmware_first(struct pci_dev *dev)
 {
+	if (!pci_is_pcie(dev))
+		return 0;
+
 	if (!dev->__aer_firmware_first_valid)
 		aer_set_firmware_first(dev);
 	return dev->__aer_firmware_first;
