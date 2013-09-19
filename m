Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab3ISHg7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 03:36:59 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:6120
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751767Ab3ISHg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 03:36:57 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 8
X-BigFish: VS8(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kz70kd2iz1de098h1de097h8275bhz2dh2a8h839he5bhf0ah107ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1fe8h1ff5h20cfi1155h)
From: Bharat Bhushan <r65777@freescale.com>
To: <alex.williamson@redhat.com>, <joro@8bytes.org>,
        <benh@kernel.crashing.org>, <galak@kernel.crashing.org>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-pci@vger.kernel.org>, <agraf@suse.de>,
        <scottwood@freescale.com>, <iommu@lists.linux-foundation.org>
CC: Bharat Bhushan <Bharat.Bhushan@freescale.com>,
        Bharat Bhushan <bharat.bhushan@freescale.com>
Subject: [PATCH 1/7] powerpc: Add interface to get msi region information
Date: Thu, 19 Sep 2013 12:59:17 +0530
Message-ID: <1379575763-2091-2-git-send-email-Bharat.Bhushan@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1379575763-2091-1-git-send-email-Bharat.Bhushan@freescale.com>
References: <1379575763-2091-1-git-send-email-Bharat.Bhushan@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds interface to get following information
  - Number of MSI regions (which is number of MSI banks for powerpc).
  - Get the region address range: Physical page which have the
     address/addresses used for generating MSI interrupt
     and size of the page.

These are required to create IOMMU (Freescale PAMU) mapping for
devices which are directly assigned using VFIO.

Signed-off-by: Bharat Bhushan <bharat.bhushan@freescale.com>
---
 arch/powerpc/include/asm/machdep.h |    8 +++++++
 arch/powerpc/include/asm/pci.h     |    2 +
 arch/powerpc/kernel/msi.c          |   18 ++++++++++++++++
 arch/powerpc/sysdev/fsl_msi.c      |   39 +++++++++++++++++++++++++++++++++--
 arch/powerpc/sysdev/fsl_msi.h      |   11 ++++++++-
 drivers/pci/msi.c                  |   26 ++++++++++++++++++++++++
 include/linux/msi.h                |    8 +++++++
 include/linux/pci.h                |   13 ++++++++++++
 8 files changed, 120 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/include/asm/machdep.h b/arch/powerpc/include/asm/machdep.h
index 8b48090..8d1b787 100644
--- a/arch/powerpc/include/asm/machdep.h
+++ b/arch/powerpc/include/asm/machdep.h
@@ -30,6 +30,7 @@ struct file;
 struct pci_controller;
 struct kimage;
 struct pci_host_bridge;
+struct msi_region;
 
 struct machdep_calls {
 	char		*name;
@@ -124,6 +125,13 @@ struct machdep_calls {
 	int		(*setup_msi_irqs)(struct pci_dev *dev,
 					  int nvec, int type);
 	void		(*teardown_msi_irqs)(struct pci_dev *dev);
+
+	/* Returns the number of MSI regions (banks) */
+	int		(*msi_get_region_count)(void);
+
+	/* Returns the requested region's address and size */
+	int		(*msi_get_region)(int region_num,
+					  struct msi_region *region);
 #endif
 
 	void		(*restart)(char *cmd);
diff --git a/arch/powerpc/include/asm/pci.h b/arch/powerpc/include/asm/pci.h
index 6653f27..e575349 100644
--- a/arch/powerpc/include/asm/pci.h
+++ b/arch/powerpc/include/asm/pci.h
@@ -117,6 +117,8 @@ extern int pci_proc_domain(struct pci_bus *bus);
 #define arch_setup_msi_irqs arch_setup_msi_irqs
 #define arch_teardown_msi_irqs arch_teardown_msi_irqs
 #define arch_msi_check_device arch_msi_check_device
+#define arch_msi_get_region_count arch_msi_get_region_count
+#define arch_msi_get_region arch_msi_get_region
 
 struct vm_area_struct;
 /* Map a range of PCI memory or I/O space for a device into user space */
diff --git a/arch/powerpc/kernel/msi.c b/arch/powerpc/kernel/msi.c
index 8bbc12d..1a67787 100644
--- a/arch/powerpc/kernel/msi.c
+++ b/arch/powerpc/kernel/msi.c
@@ -13,6 +13,24 @@
 
 #include <asm/machdep.h>
 
+int arch_msi_get_region_count(void)
+{
+	if (ppc_md.msi_get_region_count) {
+		pr_debug("msi: Using platform get_region_count routine.\n");
+		return ppc_md.msi_get_region_count();
+	}
+	return 0;
+}
+
+int arch_msi_get_region(int region_num, struct msi_region *region)
+{
+	if (ppc_md.msi_get_region) {
+		pr_debug("msi: Using platform get_region routine.\n");
+		return ppc_md.msi_get_region(region_num, region);
+	}
+	return 0;
+}
+
 int arch_msi_check_device(struct pci_dev* dev, int nvec, int type)
 {
 	if (!ppc_md.setup_msi_irqs || !ppc_md.teardown_msi_irqs) {
diff --git a/arch/powerpc/sysdev/fsl_msi.c b/arch/powerpc/sysdev/fsl_msi.c
index ab02db3..ed045cb 100644
--- a/arch/powerpc/sysdev/fsl_msi.c
+++ b/arch/powerpc/sysdev/fsl_msi.c
@@ -96,6 +96,34 @@ static int fsl_msi_init_allocator(struct fsl_msi *msi_data)
 	return 0;
 }
 
+static int fsl_msi_get_region_count(void)
+{
+	int count = 0;
+	struct fsl_msi *msi_data;
+
+	list_for_each_entry(msi_data, &msi_head, list)
+		count++;
+
+	return count;
+}
+
+static int fsl_msi_get_region(int region_num, struct msi_region *region)
+{
+	struct fsl_msi *msi_data;
+
+	list_for_each_entry(msi_data, &msi_head, list) {
+		if (msi_data->bank_index == region_num) {
+			region->region_num = msi_data->bank_index;
+			/* Setting PAGE_SIZE as MSIIR is a 4 byte register */
+			region->size = PAGE_SIZE;
+			region->addr = msi_data->msiir & ~(region->size - 1);
+			return 0;
+		}
+	}
+
+	return -ENODEV;
+}
+
 static int fsl_msi_check_device(struct pci_dev *pdev, int nvec, int type)
 {
 	if (type == PCI_CAP_ID_MSIX)
@@ -137,7 +165,8 @@ static void fsl_compose_msi_msg(struct pci_dev *pdev, int hwirq,
 	if (reg && (len == sizeof(u64)))
 		address = be64_to_cpup(reg);
 	else
-		address = fsl_pci_immrbar_base(hose) + msi_data->msiir_offset;
+		address = fsl_pci_immrbar_base(hose) +
+			   (msi_data->msiir & 0xfffff);
 
 	msg->address_lo = lower_32_bits(address);
 	msg->address_hi = upper_32_bits(address);
@@ -376,6 +405,7 @@ static int fsl_of_msi_probe(struct platform_device *dev)
 	int len;
 	u32 offset;
 	static const u32 all_avail[] = { 0, NR_MSI_IRQS };
+	static int bank_index;
 
 	match = of_match_device(fsl_of_msi_ids, &dev->dev);
 	if (!match)
@@ -419,8 +449,8 @@ static int fsl_of_msi_probe(struct platform_device *dev)
 				dev->dev.of_node->full_name);
 			goto error_out;
 		}
-		msi->msiir_offset =
-			features->msiir_offset + (res.start & 0xfffff);
+		msi->msiir = res.start + features->msiir_offset;
+		printk("msi->msiir = %llx\n", msi->msiir);
 	}
 
 	msi->feature = features->fsl_pic_ip;
@@ -470,6 +500,7 @@ static int fsl_of_msi_probe(struct platform_device *dev)
 		}
 	}
 
+	msi->bank_index = bank_index++;
 	list_add_tail(&msi->list, &msi_head);
 
 	/* The multiple setting ppc_md.setup_msi_irqs will not harm things */
@@ -477,6 +508,8 @@ static int fsl_of_msi_probe(struct platform_device *dev)
 		ppc_md.setup_msi_irqs = fsl_setup_msi_irqs;
 		ppc_md.teardown_msi_irqs = fsl_teardown_msi_irqs;
 		ppc_md.msi_check_device = fsl_msi_check_device;
+		ppc_md.msi_get_region_count = fsl_msi_get_region_count;
+		ppc_md.msi_get_region = fsl_msi_get_region;
 	} else if (ppc_md.setup_msi_irqs != fsl_setup_msi_irqs) {
 		dev_err(&dev->dev, "Different MSI driver already installed!\n");
 		err = -ENODEV;
diff --git a/arch/powerpc/sysdev/fsl_msi.h b/arch/powerpc/sysdev/fsl_msi.h
index 8225f86..6bd5cfc 100644
--- a/arch/powerpc/sysdev/fsl_msi.h
+++ b/arch/powerpc/sysdev/fsl_msi.h
@@ -29,12 +29,19 @@ struct fsl_msi {
 	struct irq_domain *irqhost;
 
 	unsigned long cascade_irq;
-
-	u32 msiir_offset; /* Offset of MSIIR, relative to start of CCSR */
+	dma_addr_t msiir; /* MSIIR Address in CCSR */
 	void __iomem *msi_regs;
 	u32 feature;
 	int msi_virqs[NR_MSI_REG];
 
+	/*
+	 * During probe each bank is assigned a index number.
+	 * index number ranges from 0 to 2^32.
+	 * Example  MSI bank 1 = 0
+	 * MSI bank 2 = 1, and so on.
+	 */
+	int bank_index;
+
 	struct msi_bitmap bitmap;
 
 	struct list_head list;          /* support multiple MSI banks */
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index aca7578..6d85c15 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -30,6 +30,20 @@ static int pci_msi_enable = 1;
 
 /* Arch hooks */
 
+#ifndef arch_msi_get_region_count
+int arch_msi_get_region_count(void)
+{
+	return 0;
+}
+#endif
+
+#ifndef arch_msi_get_region
+int arch_msi_get_region(int region_num, struct msi_region *region)
+{
+	return 0;
+}
+#endif
+
 #ifndef arch_msi_check_device
 int arch_msi_check_device(struct pci_dev *dev, int nvec, int type)
 {
@@ -903,6 +917,18 @@ void pci_disable_msi(struct pci_dev *dev)
 }
 EXPORT_SYMBOL(pci_disable_msi);
 
+int msi_get_region_count(void)
+{
+	return arch_msi_get_region_count();
+}
+EXPORT_SYMBOL(msi_get_region_count);
+
+int msi_get_region(int region_num, struct msi_region *region)
+{
+	return arch_msi_get_region(region_num, region);
+}
+EXPORT_SYMBOL(msi_get_region);
+
 /**
  * pci_msix_table_size - return the number of device's MSI-X table entries
  * @dev: pointer to the pci_dev data structure of MSI-X device function
diff --git a/include/linux/msi.h b/include/linux/msi.h
index ee66f3a..ae32601 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -50,6 +50,12 @@ struct msi_desc {
 	struct kobject kobj;
 };
 
+struct msi_region {
+	int region_num;
+	dma_addr_t addr;
+	size_t size;
+};
+
 /*
  * The arch hook for setup up msi irqs
  */
@@ -58,5 +64,7 @@ void arch_teardown_msi_irq(unsigned int irq);
 int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type);
 void arch_teardown_msi_irqs(struct pci_dev *dev);
 int arch_msi_check_device(struct pci_dev* dev, int nvec, int type);
+int arch_msi_get_region_count(void);
+int arch_msi_get_region(int region_num, struct msi_region *region);
 
 #endif /* LINUX_MSI_H */
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 186540d..2b26a59 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1126,6 +1126,7 @@ struct msix_entry {
 	u16	entry;	/* driver uses to specify entry, OS writes */
 };
 
+struct msi_region;
 
 #ifndef CONFIG_PCI_MSI
 static inline int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec)
@@ -1168,6 +1169,16 @@ static inline int pci_msi_enabled(void)
 {
 	return 0;
 }
+
+static inline int msi_get_region_count(void)
+{
+	return 0;
+}
+
+static inline int msi_get_region(int region_num, struct msi_region *region)
+{
+	return 0;
+}
 #else
 int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec);
 int pci_enable_msi_block_auto(struct pci_dev *dev, unsigned int *maxvec);
@@ -1180,6 +1191,8 @@ void pci_disable_msix(struct pci_dev *dev);
 void msi_remove_pci_irq_vectors(struct pci_dev *dev);
 void pci_restore_msi_state(struct pci_dev *dev);
 int pci_msi_enabled(void);
+int msi_get_region_count(void);
+int msi_get_region(int region_num, struct msi_region *region);
 #endif
 
 #ifdef CONFIG_PCIEPORTBUS
-- 
1.7.0.4


