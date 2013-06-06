Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab3FFSPy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 14:15:54 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:20676 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab3FFSPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 14:15:52 -0400
From: Betty Dall <betty.dall@hp.com>
To: rjw@sisk.pl, bhelgaas@google.com, gong.chen@linux.intel.com,
        greg.pearson@hp.com
Cc: ying.huang@intel.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Betty Dall <betty.dall@hp.com>
Subject: [PATCH v3 2/6] PCI/AER: Factor out HEST device type matching
Date: Thu,  6 Jun 2013 12:10:47 -0600
Message-Id: <1370542251-27387-3-git-send-email-betty.dall@hp.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1370542251-27387-1-git-send-email-betty.dall@hp.com>
References: <1370542251-27387-1-git-send-email-betty.dall@hp.com>
Author: Bjorn Helgaas <bhelgaas@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This factors out the matching of HEST structure type and PCIe device type
to improve readability.  No functional change.
    
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Betty Dall <betty.dall@hp.com>
---

 drivers/pci/pcie/aer/aerdrv_acpi.c |   35 +++++++++++++++++------------------
 1 files changed, 17 insertions(+), 18 deletions(-)


diff --git a/drivers/pci/pcie/aer/aerdrv_acpi.c b/drivers/pci/pcie/aer/aerdrv_acpi.c
index 4f798ab..e7ea573 100644
--- a/drivers/pci/pcie/aer/aerdrv_acpi.c
+++ b/drivers/pci/pcie/aer/aerdrv_acpi.c
@@ -29,6 +29,22 @@ static inline int hest_match_pci(struct acpi_hest_aer_common *p,
 		 p->function == PCI_FUNC(pci->devfn));
 }
 
+static inline bool hest_match_type(struct acpi_hest_header *hest_hdr,
+				struct pci_dev *dev)
+{
+	u16 hest_type = hest_hdr->type;
+	u8 pcie_type = pci_pcie_type(dev);
+
+	if ((hest_type == ACPI_HEST_TYPE_AER_ROOT_PORT &&
+		pcie_type == PCI_EXP_TYPE_ROOT_PORT) ||
+	    (hest_type == ACPI_HEST_TYPE_AER_ENDPOINT &&
+		pcie_type == PCI_EXP_TYPE_ENDPOINT) ||
+	    (hest_type == ACPI_HEST_TYPE_AER_BRIDGE &&
+		(dev->class >> 16) == PCI_BASE_CLASS_BRIDGE))
+		return true;
+	return false;
+}
+
 struct aer_hest_parse_info {
 	struct pci_dev *pci_dev;
 	int firmware_first;
@@ -38,28 +54,11 @@ static int aer_hest_parse(struct acpi_hest_header *hest_hdr, void *data)
 {
 	struct aer_hest_parse_info *info = data;
 	struct acpi_hest_aer_common *p;
-	u8 pcie_type = 0;
-	u8 bridge = 0;
 	int ff = 0;
 
-	switch (hest_hdr->type) {
-	case ACPI_HEST_TYPE_AER_ROOT_PORT:
-		pcie_type = PCI_EXP_TYPE_ROOT_PORT;
-		break;
-	case ACPI_HEST_TYPE_AER_ENDPOINT:
-		pcie_type = PCI_EXP_TYPE_ENDPOINT;
-		break;
-	case ACPI_HEST_TYPE_AER_BRIDGE:
-		if ((info->pci_dev->class >> 16) == PCI_BASE_CLASS_BRIDGE)
-			bridge = 1;
-		break;
-	default:
-		return 0;
-	}
-
 	p = (struct acpi_hest_aer_common *)(hest_hdr + 1);
 	if (p->flags & ACPI_HEST_GLOBAL) {
-		if ((pci_pcie_type(info->pci_dev) == pcie_type) || bridge)
+		if (hest_match_type(hest_hdr, info->pci_dev))
 			ff = !!(p->flags & ACPI_HEST_FIRMWARE_FIRST);
 	} else
 		if (hest_match_pci(p, info->pci_dev))
