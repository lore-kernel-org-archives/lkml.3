Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630AbaJWVTw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 17:19:52 -0400
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:50717 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbaJWVTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 17:19:50 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, benh@kernel.crashing.org, corbet@lwn.net,
        gwshan@linux.vnet.ibm.com,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Subject: [PATCH v2] powernv/iommu: disable IOMMU bypass with param iommu=nobypass
Date: Thu, 23 Oct 2014 19:19:35 -0200
Message-Id: <1414099175-27863-1-git-send-email-cascardo@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102321-0017-0000-0000-000000D0C17D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When IOMMU bypass is enabled, a PCI device can read and write memory
that was not mapped by the driver without causing an EEH. That might
cause memory corruption, for example.

When we disable bypass, DMA reads and writes to addresses not mapped by
the IOMMU will cause an EEH, allowing us to debug such issues.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Reviewed-by: Gavin Shan <gwshan@linux.vnet.ibm.com>
---
 Documentation/kernel-parameters.txt       |    2 ++
 arch/powerpc/platforms/powernv/pci-ioda.c |   24 +++++++++++++++++++++++-
 2 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 988160a..b03322a 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1454,6 +1454,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 		forcesac
 		soft
 		pt		[x86, IA-64]
+		nobypass	[PPC/POWERNV]
+			Disable IOMMU bypass, using IOMMU for PCI devices.
 
 
 	io7=		[HW] IO7 for Marvel based alpha systems
diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index 468a0f2..a7d2f32 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -75,6 +75,27 @@ static void pe_level_printk(const struct pnv_ioda_pe *pe, const char *level,
 #define pe_info(pe, fmt, ...)					\
 	pe_level_printk(pe, KERN_INFO, fmt, ##__VA_ARGS__)
 
+static bool pnv_iommu_bypass_disabled __read_mostly;
+
+static int __init iommu_setup(char *str)
+{
+	if (!str)
+		return -EINVAL;
+	while (*str) {
+		if (!strncmp(str, "nobypass", 8)) {
+			pnv_iommu_bypass_disabled = true;
+			pr_info("PowerNV: IOMMU bypass window disabled.\n");
+		}
+		str += strcspn(str, ",");
+		if (*str == ',')
+			str++;
+	}
+
+	return 0;
+}
+
+early_param("iommu", iommu_setup);
+
 /*
  * stdcix is only supposed to be used in hypervisor real mode as per
  * the architecture spec
@@ -1243,7 +1264,8 @@ static void pnv_pci_ioda2_setup_dma_pe(struct pnv_phb *phb,
 		pnv_ioda_setup_bus_dma(pe, pe->pbus, true);
 
 	/* Also create a bypass window */
-	pnv_pci_ioda2_setup_bypass_pe(phb, pe);
+	if (!pnv_iommu_bypass_disabled)
+		pnv_pci_ioda2_setup_bypass_pe(phb, pe);
 	return;
 fail:
 	if (pe->tce32_seg >= 0)
-- 
1.7.1

