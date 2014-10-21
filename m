Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbaJUMEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 08:04:40 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:43196 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404AbaJUMEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 08:04:37 -0400
From: Frank Blaschka <blaschka@linux.vnet.ibm.com>
To: alex.williamson@redhat.com, schwidefsky@de.ibm.com
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        sebott@linux.vnet.ibm.com, gerald.schaefer@de.ibm.com,
        kvm@vger.kernel.org, agraf@suse.de,
        Frank Blaschka <blaschka@linux.vnet.ibm.com>
Subject: [PATCH linux-next] vfio: make vfio build and run on s390
Date: Tue, 21 Oct 2014 14:04:28 +0200
Message-Id: <1413893068-45404-1-git-send-email-blaschka@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102112-0009-0000-0000-0000019F5677
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce platform functions to let vfio announce if INTx is available and
if PCI BARs are mapable. Also take care vfio_pci_vga_rw is building on
platforms which do not support I/O ports.

Signed-off-by: Frank Blaschka <blaschka@linux.vnet.ibm.com>
---
 arch/s390/include/asm/pci.h      |  3 +++
 drivers/vfio/Kconfig             |  2 +-
 drivers/vfio/pci/vfio_pci.c      | 33 ++++++++++++++++++++++++++++-----
 drivers/vfio/pci/vfio_pci_rdwr.c |  4 ++++
 4 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
index 6790d0d..0ca2008 100644
--- a/arch/s390/include/asm/pci.h
+++ b/arch/s390/include/asm/pci.h
@@ -12,6 +12,9 @@
 #include <asm/pci_clp.h>
 #include <asm/pci_debug.h>
 
+#define __ARCH_PCI_NO_BARMAP
+#define __ARCH_PCI_NO_INTX
+
 #define PCIBIOS_MIN_IO		0x1000
 #define PCIBIOS_MIN_MEM		0x10000000
 
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
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 9558da3..808072f 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -210,12 +210,25 @@ error:
 	return ret;
 }
 
+static int vfio_pci_intx_available(struct pci_dev *pdev)
+{
+#ifdef __ARCH_PCI_NO_INTX
+	return 0;
+#else
+	u8 pin;
+	int rc = 0;
+
+	pci_read_config_byte(pdev, PCI_INTERRUPT_PIN, &pin);
+	if (pin)
+		rc = 1;
+	return rc;
+#endif
+}
+
 static int vfio_pci_get_irq_count(struct vfio_pci_device *vdev, int irq_type)
 {
 	if (irq_type == VFIO_PCI_INTX_IRQ_INDEX) {
-		u8 pin;
-		pci_read_config_byte(vdev->pdev, PCI_INTERRUPT_PIN, &pin);
-		if (pin)
+		if (vfio_pci_intx_available(vdev->pdev))
 			return 1;
 
 	} else if (irq_type == VFIO_PCI_MSI_IRQ_INDEX) {
@@ -350,6 +363,16 @@ static int vfio_pci_for_each_slot_or_bus(struct pci_dev *pdev,
 	return walk.ret;
 }
 
+static int vfio_pci_bar_mapable(struct pci_dev *pdev, __u32 index, __u64 size)
+{
+#ifdef __ARCH_PCI_NO_BARMAP
+	return 0;
+#else
+	return (pci_resource_flags(pdev, index) &
+		IORESOURCE_MEM && size >= PAGE_SIZE);
+#endif
+}
+
 static long vfio_pci_ioctl(void *device_data,
 			   unsigned int cmd, unsigned long arg)
 {
@@ -406,9 +429,9 @@ static long vfio_pci_ioctl(void *device_data,
 
 			info.flags = VFIO_REGION_INFO_FLAG_READ |
 				     VFIO_REGION_INFO_FLAG_WRITE;
-			if (pci_resource_flags(pdev, info.index) &
-			    IORESOURCE_MEM && info.size >= PAGE_SIZE)
+			if (vfio_pci_bar_mapable(pdev, info.index, info.size))
 				info.flags |= VFIO_REGION_INFO_FLAG_MMAP;
+
 			break;
 		case VFIO_PCI_ROM_REGION_INDEX:
 		{
diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index 210db24..02c5623 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -180,6 +180,9 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_device *vdev, char __user *buf,
 ssize_t vfio_pci_vga_rw(struct vfio_pci_device *vdev, char __user *buf,
 			       size_t count, loff_t *ppos, bool iswrite)
 {
+#ifdef CONFIG_NO_IOPORT_MAP
+	return -EINVAL;
+#else
 	int ret;
 	loff_t off, pos = *ppos & VFIO_PCI_OFFSET_MASK;
 	void __iomem *iomem = NULL;
@@ -235,4 +238,5 @@ ssize_t vfio_pci_vga_rw(struct vfio_pci_device *vdev, char __user *buf,
 		*ppos += done;
 
 	return done;
+#endif
 }
-- 
1.8.5.5

