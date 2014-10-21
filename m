Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381AbaJUL6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 07:58:12 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:55418 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932283AbaJUL6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 07:58:09 -0400
From: Frank Blaschka <blaschka@linux.vnet.ibm.com>
To: joro@8bytes.org, schwidefsky@de.ibm.com
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        iommu@lists.linux-foundation.org, sebott@linux.vnet.ibm.com,
        gerald.schaefer@de.ibm.com,
        Frank Blaschka <blaschka@linux.vnet.ibm.com>
Subject: [PATCH linux-next] iommu: add iommu for s390 platform
Date: Tue, 21 Oct 2014 13:57:25 +0200
Message-Id: <1413892645-37657-1-git-send-email-blaschka@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102111-0021-0000-0000-0000017A7D19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a basic iommu for the s390 platform. The code is pretty simple
since on s390 each PCI device has its own virtual io address space
starting at the same vio address. For this a domain could hold only
one pci device. Also there is no relation between pci devices so each
device belongs to a separate iommu group.

Signed-off-by: Frank Blaschka <blaschka@linux.vnet.ibm.com>
---
 MAINTAINERS                 |   8 ++
 arch/s390/include/asm/pci.h |   3 +
 arch/s390/pci/pci_dma.c     |  19 ++++-
 drivers/iommu/Kconfig       |   9 +++
 drivers/iommu/Makefile      |   1 +
 drivers/iommu/s390-iommu.c  | 179 ++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 217 insertions(+), 2 deletions(-)
 create mode 100644 drivers/iommu/s390-iommu.c

diff --git a/MAINTAINERS b/MAINTAINERS
index bc69ca4..a3ba11b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7935,6 +7935,14 @@ F:	drivers/s390/net/*iucv*
 F:	include/net/iucv/
 F:	net/iucv/
 
+S390 IOMMU
+M:      Frank Blaschka <blaschka@linux.vnet.ibm.com>
+M:      linux390@de.ibm.com
+L:      linux-s390@vger.kernel.org
+W:      http://www.ibm.com/developerworks/linux/linux390/
+S:      Supported
+F:      drivers/iommu/s390-iommu.c
+
 S3C24XX SD/MMC Driver
 M:	Ben Dooks <ben-linux@fluff.org>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
index c030900..6790d0d 100644
--- a/arch/s390/include/asm/pci.h
+++ b/arch/s390/include/asm/pci.h
@@ -177,6 +177,9 @@ struct zpci_dev *get_zdev_by_fid(u32);
 /* DMA */
 int zpci_dma_init(void);
 void zpci_dma_exit(void);
+int dma_update_trans(struct zpci_dev *zdev, unsigned long pa,
+		     dma_addr_t dma_addr, size_t size, int flags);
+void dma_purge_rto_entries(struct zpci_dev *zdev);
 
 /* FMB */
 int zpci_fmb_enable_device(struct zpci_dev *);
diff --git a/arch/s390/pci/pci_dma.c b/arch/s390/pci/pci_dma.c
index 4cbb29a..a4db33e 100644
--- a/arch/s390/pci/pci_dma.c
+++ b/arch/s390/pci/pci_dma.c
@@ -139,8 +139,8 @@ static void dma_update_cpu_trans(struct zpci_dev *zdev, void *page_addr,
 		entry_clr_protected(entry);
 }
 
-static int dma_update_trans(struct zpci_dev *zdev, unsigned long pa,
-			    dma_addr_t dma_addr, size_t size, int flags)
+int dma_update_trans(struct zpci_dev *zdev, unsigned long pa,
+		     dma_addr_t dma_addr, size_t size, int flags)
 {
 	unsigned int nr_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
 	u8 *page_addr = (u8 *) (pa & PAGE_MASK);
@@ -210,6 +210,21 @@ static void dma_cleanup_tables(struct zpci_dev *zdev)
 	zdev->dma_table = NULL;
 }
 
+void dma_purge_rto_entries(struct zpci_dev *zdev)
+{
+	unsigned long *table;
+	int rtx;
+
+	if (!zdev || !zdev->dma_table)
+		return;
+	table = zdev->dma_table;
+	for (rtx = 0; rtx < ZPCI_TABLE_ENTRIES; rtx++)
+		if (reg_entry_isvalid(table[rtx])) {
+			dma_free_seg_table(table[rtx]);
+			invalidate_table_entry(&table[rtx]);
+		}
+}
+
 static unsigned long __dma_alloc_iommu(struct zpci_dev *zdev,
 				       unsigned long start, int size)
 {
diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index dd51122..545e3fd 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -302,4 +302,13 @@ config ARM_SMMU
 	  Say Y here if your SoC includes an IOMMU device implementing
 	  the ARM SMMU architecture.
 
+config S390_IOMMU
+        bool "s390 IOMMU Support"
+        depends on S390 && PCI
+        select IOMMU_API
+        help
+          Support for the IBM s/390 IOMMU
+
+          If unsure, say N here.
+
 endif # IOMMU_SUPPORT
diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index 16edef7..1278aad 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -19,3 +19,4 @@ obj-$(CONFIG_EXYNOS_IOMMU) += exynos-iommu.o
 obj-$(CONFIG_SHMOBILE_IOMMU) += shmobile-iommu.o
 obj-$(CONFIG_SHMOBILE_IPMMU) += shmobile-ipmmu.o
 obj-$(CONFIG_FSL_PAMU) += fsl_pamu.o fsl_pamu_domain.o
+obj-$(CONFIG_S390_IOMMU) += s390-iommu.o
diff --git a/drivers/iommu/s390-iommu.c b/drivers/iommu/s390-iommu.c
new file mode 100644
index 0000000..f9f048d
--- /dev/null
+++ b/drivers/iommu/s390-iommu.c
@@ -0,0 +1,179 @@
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/pm_runtime.h>
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/mm.h>
+#include <linux/iommu.h>
+#include <linux/errno.h>
+#include <linux/list.h>
+#include <linux/memblock.h>
+#include <linux/export.h>
+#include <linux/pci.h>
+#include <linux/sizes.h>
+#include <asm/pci_dma.h>
+
+#define S390_IOMMU_PGSIZES SZ_4K
+
+struct s390_domain {
+	struct zpci_dev *zdev;
+};
+
+static int s390_iommu_domain_init(struct iommu_domain *domain)
+{
+	struct s390_domain *priv;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	domain->priv = priv;
+	return 0;
+}
+
+static void s390_iommu_domain_destroy(struct iommu_domain *domain)
+{
+	kfree(domain->priv);
+	domain->priv = NULL;
+}
+
+static int s390_iommu_attach_device(struct iommu_domain *domain,
+				    struct device *dev)
+{
+	struct s390_domain *priv = domain->priv;
+
+	if (priv->zdev)
+		return -EEXIST;
+
+	priv->zdev = (struct zpci_dev *)to_pci_dev(dev)->sysdata;
+	return 0;
+}
+
+static void s390_iommu_detach_device(struct iommu_domain *domain,
+				     struct device *dev)
+{
+	struct s390_domain *priv = domain->priv;
+
+	dma_purge_rto_entries(priv->zdev);
+	priv->zdev = NULL;
+}
+
+static int s390_iommu_map(struct iommu_domain *domain, unsigned long iova,
+			  phys_addr_t paddr, size_t size, int prot)
+{
+	struct s390_domain *priv = domain->priv;
+	int flags = 0;
+	int rc;
+
+	if (!priv->zdev)
+		return -ENODEV;
+
+	rc = dma_update_trans(priv->zdev, (unsigned long)paddr, iova, size,
+			      flags);
+
+	return rc;
+}
+
+static phys_addr_t s390_iommu_iova_to_phys(struct iommu_domain *domain,
+					   dma_addr_t iova)
+{
+	struct s390_domain *priv = domain->priv;
+	phys_addr_t phys = 0;
+	unsigned long *sto, *pto, *rto;
+	unsigned int rtx, sx, px;
+
+	if (!priv->zdev)
+		return -ENODEV;
+
+	rtx = calc_rtx(iova);
+	sx = calc_sx(iova);
+	px = calc_px(iova);
+	rto = priv->zdev->dma_table;
+
+	if (reg_entry_isvalid(rto[rtx])) {
+		sto = get_rt_sto(rto[rtx]);
+		if (reg_entry_isvalid(sto[sx])) {
+			pto = get_st_pto(sto[sx]);
+			if ((pto[px] & ZPCI_PTE_VALID_MASK) == ZPCI_PTE_VALID)
+				phys = pto[px] & ZPCI_PTE_ADDR_MASK;
+		}
+	}
+
+	return phys;
+}
+
+static size_t s390_iommu_unmap(struct iommu_domain *domain,
+			       unsigned long iova, size_t size)
+{
+	struct s390_domain *priv = domain->priv;
+	int flags = ZPCI_PTE_INVALID;
+	phys_addr_t paddr;
+	int rc;
+
+	if (!priv->zdev)
+		goto out;
+
+	paddr = s390_iommu_iova_to_phys(domain, iova);
+	if (!paddr)
+		goto out;
+
+	rc = dma_update_trans(priv->zdev, (unsigned long)paddr, iova, size,
+			      flags);
+out:
+	return size;
+}
+
+static bool s390_iommu_capable(enum iommu_cap cap)
+{
+	switch (cap) {
+	case IOMMU_CAP_CACHE_COHERENCY:
+		return true;
+	case IOMMU_CAP_INTR_REMAP:
+		return true;
+	}
+
+	return false;
+}
+
+static int s390_iommu_add_device(struct device *dev)
+{
+	struct iommu_group *group;
+	int ret;
+
+	group = iommu_group_alloc();
+	if (IS_ERR(group)) {
+		dev_err(dev, "Failed to allocate IOMMU group\n");
+		return PTR_ERR(group);
+	}
+
+	ret = iommu_group_add_device(group, dev);
+	return ret;
+}
+
+static void s390_iommu_remove_device(struct device *dev)
+{
+	iommu_group_remove_device(dev);
+}
+
+static struct iommu_ops s390_iommu_ops = {
+	.capable = s390_iommu_capable,
+	.domain_init = s390_iommu_domain_init,
+	.domain_destroy = s390_iommu_domain_destroy,
+	.attach_dev = s390_iommu_attach_device,
+	.detach_dev = s390_iommu_detach_device,
+	.map = s390_iommu_map,
+	.unmap = s390_iommu_unmap,
+	.iova_to_phys = s390_iommu_iova_to_phys,
+	.add_device = s390_iommu_add_device,
+	.remove_device = s390_iommu_remove_device,
+	.pgsize_bitmap = S390_IOMMU_PGSIZES,
+};
+
+static int __init s390_iommu_init(void)
+{
+	bus_set_iommu(&pci_bus_type, &s390_iommu_ops);
+	return 0;
+}
+subsys_initcall(s390_iommu_init);
-- 
1.8.5.5

