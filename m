Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab3DNTUd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 15:20:33 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:57967
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753444Ab3DNTUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 15:20:32 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Varun Sethi <Varun.Sethi@freescale.com>
To: <joro@8bytes.org>, <stuart.yoder@freescale.com>, <scottwood@freescale.com>,
        <iommu@lists.linux-foundation.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <galak@kernel.crashing.org>,
        <benh@kernel.crashing.org>
CC: Varun Sethi <Varun.Sethi@freescale.com>
Subject: [PATCH 1/3] iommu: Move swap_pci_ref function to pci.h.
Date: Mon, 15 Apr 2013 00:42:00 +0530
Message-ID: <1365966722-1804-1-git-send-email-Varun.Sethi@freescale.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

swap_pci_ref function is used by the IOMMU API code for swapping pci device
pointers, while determining the iommu group for the device.
Currently this function was being implemented for different IOMMU drivers.
This patch moves the function to pci.h so that the implementation can be
shared across various IOMMU drivers.

Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
---
 drivers/iommu/amd_iommu.c   |    6 ------
 drivers/iommu/intel-iommu.c |    6 ------
 include/linux/pci.h         |    8 ++++++++
 3 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index a7f6b04..c36c046 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -263,12 +263,6 @@ static bool check_device(struct device *dev)
 	return true;
 }
 
-static void swap_pci_ref(struct pci_dev **from, struct pci_dev *to)
-{
-	pci_dev_put(*from);
-	*from = to;
-}
-
 static struct pci_bus *find_hosted_bus(struct pci_bus *bus)
 {
 	while (!bus->self) {
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 6e0b9ff..8d7c979 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -4137,12 +4137,6 @@ static int intel_iommu_domain_has_cap(struct iommu_domain *domain,
 	return 0;
 }
 
-static void swap_pci_ref(struct pci_dev **from, struct pci_dev *to)
-{
-	pci_dev_put(*from);
-	*from = to;
-}
-
 #define REQ_ACS_FLAGS	(PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF)
 
 static int intel_iommu_add_device(struct device *dev)
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 2461033a..41511de 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1850,6 +1850,14 @@ static inline struct eeh_dev *pci_dev_to_eeh_dev(struct pci_dev *pdev)
 }
 #endif
 
+#ifdef CONFIG_IOMMU_API
+static inline void swap_pci_ref(struct pci_dev **from, struct pci_dev *to)
+{
+	pci_dev_put(*from);
+	*from = to;
+}
+#endif
+
 /**
  * pci_find_upstream_pcie_bridge - find upstream PCIe-to-PCI bridge of a device
  * @pdev: the PCI device
-- 
1.7.4.1


