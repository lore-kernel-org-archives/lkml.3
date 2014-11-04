Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbaKDMKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 07:10:42 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:60379 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbaKDMKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 07:10:40 -0500
From: Frank Blaschka <blaschka@linux.vnet.ibm.com>
To: alex.williamson@redhat.com
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frank Blaschka <frank.blaschka@de.ibm.com>
Subject: [PATCH linux-next] vfio: make vfio run on s390
Date: Tue,  4 Nov 2014 13:10:31 +0100
Message-Id: <1415103031-50412-1-git-send-email-blaschka@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14110412-0017-0000-0000-000001B50827
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Blaschka <frank.blaschka@de.ibm.com>

add Kconfig switch to hide INTx
add Kconfig switch to let vfio announce PCI BARs are not mapable

Signed-off-by: Frank Blaschka <frank.blaschka@de.ibm.com>
---
 drivers/vfio/Kconfig               | 2 +-
 drivers/vfio/pci/Kconfig           | 8 ++++++++
 drivers/vfio/pci/vfio_pci.c        | 5 +++--
 drivers/vfio/pci/vfio_pci_config.c | 7 +++++++
 4 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index d8c5763..b93c259 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -16,7 +16,7 @@ config VFIO_SPAPR_EEH
 menuconfig VFIO
 	tristate "VFIO Non-Privileged userspace driver framework"
 	depends on IOMMU_API
-	select VFIO_IOMMU_TYPE1 if X86
+	select VFIO_IOMMU_TYPE1 if (X86 || S390)
 	select VFIO_IOMMU_SPAPR_TCE if (PPC_POWERNV || PPC_PSERIES)
 	select VFIO_SPAPR_EEH if (PPC_POWERNV || PPC_PSERIES)
 	select ANON_INODES
diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index c41b01e..c6bb5da 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -16,3 +16,11 @@ config VFIO_PCI_VGA
 	  BIOS and generic video drivers.
 
 	  If you don't know what to do here, say N.
+
+config VFIO_PCI_MMAP
+	depends on VFIO_PCI
+	def_bool y if !S390
+
+config VFIO_PCI_INTX
+	depends on VFIO_PCI
+	def_bool y if !S390
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 9558da3..255201f 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -215,7 +215,7 @@ static int vfio_pci_get_irq_count(struct vfio_pci_device *vdev, int irq_type)
 	if (irq_type == VFIO_PCI_INTX_IRQ_INDEX) {
 		u8 pin;
 		pci_read_config_byte(vdev->pdev, PCI_INTERRUPT_PIN, &pin);
-		if (pin)
+		if (IS_ENABLED(CONFIG_VFIO_PCI_INTX) && pin)
 			return 1;
 
 	} else if (irq_type == VFIO_PCI_MSI_IRQ_INDEX) {
@@ -406,7 +406,8 @@ static long vfio_pci_ioctl(void *device_data,
 
 			info.flags = VFIO_REGION_INFO_FLAG_READ |
 				     VFIO_REGION_INFO_FLAG_WRITE;
-			if (pci_resource_flags(pdev, info.index) &
+			if (IS_ENABLED(CONFIG_VFIO_PCI_MMAP) &&
+			    pci_resource_flags(pdev, info.index) &
 			    IORESOURCE_MEM && info.size >= PAGE_SIZE)
 				info.flags |= VFIO_REGION_INFO_FLAG_MMAP;
 			break;
diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 1de3f94..ff75ca3 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -609,6 +609,10 @@ static int __init init_pci_cap_basic_perm(struct perm_bits *perm)
 
 	/* Sometimes used by sw, just virtualize */
 	p_setb(perm, PCI_INTERRUPT_LINE, (u8)ALL_VIRT, (u8)ALL_WRITE);
+
+	/* Virtualize interrupt pin to allow hiding INTx */
+	p_setb(perm, PCI_INTERRUPT_PIN, (u8)ALL_VIRT, (u8)NO_WRITE);
+
 	return 0;
 }
 
@@ -1445,6 +1449,9 @@ int vfio_config_init(struct vfio_pci_device *vdev)
 		*(__le16 *)&vconfig[PCI_DEVICE_ID] = cpu_to_le16(pdev->device);
 	}
 
+	if (!IS_ENABLED(CONFIG_VFIO_PCI_INTX))
+		vconfig[PCI_INTERRUPT_PIN] = 0;
+
 	ret = vfio_cap_init(vdev);
 	if (ret)
 		goto out;
-- 
1.8.5.5

