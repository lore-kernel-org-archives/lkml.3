Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932557AbaJUSty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 14:49:54 -0400
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:57111 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932464AbaJUStw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 14:49:52 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, benh@kernel.crashing.org, corbet@lwn.net,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Subject: [PATCH] powernv/iommu: disable IOMMU bypass with param iommu=nobypass
Date: Tue, 21 Oct 2014 16:49:43 -0200
Message-Id: <1413917383-18396-1-git-send-email-cascardo@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102118-1524-0000-0000-000000D377A6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When IOMMU bypass is enabled, a PCI device can read and write memory
that was not mapped by the driver without causing an EEH. That might
cause memory corruption, for example.

When we disable bypass, DMA reads and writes to addresses not mapped by
the IOMMU will cause an EEH, allowing us to debug such issues.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
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
index 468a0f2..58a5a27 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -75,6 +75,27 @@ static void pe_level_printk(const struct pnv_ioda_pe *pe, const char *level,
 #define pe_info(pe, fmt, ...)					\
 	pe_level_printk(pe, KERN_INFO, fmt, ##__VA_ARGS__)
 
+static int __read_mostly disable_bypass;
+
+static int __init iommu_setup(char *str)
+{
+	if (!*str)
+		return -EINVAL;
+	while (*str) {
+		if (!strncmp(str, "nobypass", 8)) {
+			disable_bypass = 1;
+			pr_info("ppc iommu: disabling bypass.\n");
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
+	if (!disable_bypass)
+		pnv_pci_ioda2_setup_bypass_pe(phb, pe);
 	return;
 fail:
 	if (pe->tce32_seg >= 0)
-- 
1.7.1

