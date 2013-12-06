Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161067Ab3LFMV4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 07:21:56 -0500
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:47041 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161052Ab3LFMVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 07:21:53 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
To: benh@kernel.crashing.org
Cc: paulus@samba.org, shangw@linux.vnet.ibm.com, aik@ozlabs.ru,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Subject: [PATCH] powernv: fix VFIO support with PHB3
Date: Fri,  6 Dec 2013 10:21:44 -0200
Message-Id: <1386332504-18339-1-git-send-email-cascardo@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120612-8936-0000-0000-00000C15350F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have recently found out that no iommu_groups could be found under
/sys/ on a P8. That prevents PCI passthrough from working.

During my investigation, I found out there seems to be a missing
iommu_register_group for PHB3. The following patch seems to fix the
problem. After applying it, I see iommu_groups under
/sys/kernel/iommu_groups/, and can also bind vfio-pci to an adapter,
which gives me a device at /dev/vfio/.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
---
 arch/powerpc/platforms/powernv/pci-ioda.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index 084cdfa..2c6d173 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -720,6 +720,7 @@ static void pnv_pci_ioda2_setup_dma_pe(struct pnv_phb *phb,
 		tbl->it_type = TCE_PCI_SWINV_CREATE | TCE_PCI_SWINV_FREE;
 	}
 	iommu_init_table(tbl, phb->hose->node);
+	iommu_register_group(tbl, pci_domain_nr(pe->pbus), pe->pe_number);
 
 	if (pe->pdev)
 		set_iommu_table_base(&pe->pdev->dev, tbl);
-- 
1.7.1

