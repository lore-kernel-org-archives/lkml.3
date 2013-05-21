Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab3EUDdk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 23:33:40 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:47955 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278Ab3EUDdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 23:33:37 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Paul Mackerras <paulus@samba.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] powerpc/vfio: Enable on pSeries platform
Date: Tue, 21 May 2013 13:33:11 +1000
Message-Id: <1369107191-28547-4-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1369107191-28547-1-git-send-email-aik@ozlabs.ru>
References: <1369107191-28547-1-git-send-email-aik@ozlabs.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The enables VFIO on the pSeries platform, enabling user space
programs to access PCI devices directly.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Paul Mackerras <paulus@samba.org>
---
 arch/powerpc/platforms/pseries/iommu.c |    4 ++++
 drivers/iommu/Kconfig                  |    2 +-
 drivers/vfio/Kconfig                   |    2 +-
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index 86ae364..23fc1dc 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -614,6 +614,7 @@ static void pci_dma_bus_setup_pSeries(struct pci_bus *bus)
 
 	iommu_table_setparms(pci->phb, dn, tbl);
 	pci->iommu_table = iommu_init_table(tbl, pci->phb->node);
+	iommu_register_group(tbl, pci_domain_nr(bus), 0);
 
 	/* Divide the rest (1.75GB) among the children */
 	pci->phb->dma_window_size = 0x80000000ul;
@@ -658,6 +659,7 @@ static void pci_dma_bus_setup_pSeriesLP(struct pci_bus *bus)
 				   ppci->phb->node);
 		iommu_table_setparms_lpar(ppci->phb, pdn, tbl, dma_window);
 		ppci->iommu_table = iommu_init_table(tbl, ppci->phb->node);
+		iommu_register_group(tbl, pci_domain_nr(bus), 0);
 		pr_debug("  created table: %p\n", ppci->iommu_table);
 	}
 }
@@ -684,6 +686,7 @@ static void pci_dma_dev_setup_pSeries(struct pci_dev *dev)
 				   phb->node);
 		iommu_table_setparms(phb, dn, tbl);
 		PCI_DN(dn)->iommu_table = iommu_init_table(tbl, phb->node);
+		iommu_register_group(tbl, pci_domain_nr(phb->bus), 0);
 		set_iommu_table_base(&dev->dev, PCI_DN(dn)->iommu_table);
 		return;
 	}
@@ -1184,6 +1187,7 @@ static void pci_dma_dev_setup_pSeriesLP(struct pci_dev *dev)
 				   pci->phb->node);
 		iommu_table_setparms_lpar(pci->phb, pdn, tbl, dma_window);
 		pci->iommu_table = iommu_init_table(tbl, pci->phb->node);
+		iommu_register_group(tbl, pci_domain_nr(pci->phb->bus), 0);
 		pr_debug("  created table: %p\n", pci->iommu_table);
 	} else {
 		pr_debug("  found DMA window, table: %p\n", pci->iommu_table);
diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 3f3abde..01730b2 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -263,7 +263,7 @@ config SHMOBILE_IOMMU_L1SIZE
 
 config SPAPR_TCE_IOMMU
 	bool "sPAPR TCE IOMMU Support"
-	depends on PPC_POWERNV
+	depends on PPC_POWERNV || PPC_PSERIES
 	select IOMMU_API
 	help
 	  Enables bits of IOMMU API required by VFIO. The iommu_ops
diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index b464687..26b3d9d 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -12,7 +12,7 @@ menuconfig VFIO
 	tristate "VFIO Non-Privileged userspace driver framework"
 	depends on IOMMU_API
 	select VFIO_IOMMU_TYPE1 if X86
-	select VFIO_IOMMU_SPAPR_TCE if PPC_POWERNV
+	select VFIO_IOMMU_SPAPR_TCE if (PPC_POWERNV || PPC_PSERIES)
 	help
 	  VFIO provides a framework for secure userspace device drivers.
 	  See Documentation/vfio.txt for more details.
-- 
1.7.10.4

