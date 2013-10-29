Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab3J2Ler (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 07:34:47 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:14770 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754795Ab3J2Lep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 07:34:45 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 4
X-BigFish: VS4(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kzd2iz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah107ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1fe8h1ff5h2218h2216h1155h)
From: Bharat Bhushan <r65777@freescale.com>
To: <alex.williamson@redhat.com>, <joro@8bytes.org>,
        <galak@kernel.crashing.org>, <scottwood@freescale.com>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-pci@vger.kernel.org>, <agraf@suse.de>,
        <stuart.yoder@freescale.com>
CC: Bharat Bhushan <Bharat.Bhushan@freescale.com>,
        Bharat Bhushan <bharat.bhushan@freescale.com>
Subject: [PATCH 5/5 RFC] vfio: setup iova-base for msi interrupts for vfio assigned device
Date: Tue, 29 Oct 2013 16:57:41 +0530
Message-ID: <1383046062-16520-5-git-send-email-Bharat.Bhushan@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1383046062-16520-1-git-send-email-Bharat.Bhushan@freescale.com>
References: <1383046062-16520-1-git-send-email-Bharat.Bhushan@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PAMU (FSL IOMMU) has a concept of primary window and subwindows.
Primary window corresponds to the complete guest iova address space
(including MSI space), with respect to IOMMU_API this is termed as
geometry. IOVA Base of subwindow is determined from the number of
subwindows (configurable using iommu API).
MSI I/O page must be within the geometry and maximum supported
subwindows, so MSI IO-page is setup just after guest memory iova space.

This patch is for setting up MSI iova-base for vfio devices assigned
in msi subsystem, so that when msi-message will be composed then this
configured iova will be used.

According to this design vfio will make msi_set_iova() msi-API call to
setup iova for a device. MSI will keep track of iova-base of all device
under a msi-bank. When composing the MSI address and data this list will
be traversed, if device found in the list then device used by vfio and
its iova-base will be taken from here otherwise iova-base will be taken
as before.

This is a draft patch to describe the interface to setup iova in MSI
(what Alex Williamson proposed earlier on related patchset).
Currently I have bundled all changes in one patch to take initial
review comment on design. I will divide this in multiple logical
patches once this design is accepted.

Signed-off-by: Bharat Bhushan <bharat.bhushan@freescale.com>
---
 arch/powerpc/include/asm/machdep.h |    2 +
 arch/powerpc/kernel/msi.c          |   10 ++++++
 arch/powerpc/sysdev/fsl_msi.c      |   64 ++++++++++++++++++++++++++++++++++++
 arch/powerpc/sysdev/fsl_msi.h      |   10 ++++-
 drivers/pci/msi.c                  |   12 +++++++
 include/linux/pci.h                |    8 ++++
 6 files changed, 104 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/machdep.h b/arch/powerpc/include/asm/machdep.h
index 8d1b787..e87b806 100644
--- a/arch/powerpc/include/asm/machdep.h
+++ b/arch/powerpc/include/asm/machdep.h
@@ -132,6 +132,8 @@ struct machdep_calls {
 	/* Returns the requested region's address and size */
 	int		(*msi_get_region)(int region_num,
 					  struct msi_region *region);
+	int		(*msi_set_iova)(struct pci_dev *pdev, int region_num,
+					dma_addr_t iova, bool set);
 #endif
 
 	void		(*restart)(char *cmd);
diff --git a/arch/powerpc/kernel/msi.c b/arch/powerpc/kernel/msi.c
index 1a67787..e2bd555 100644
--- a/arch/powerpc/kernel/msi.c
+++ b/arch/powerpc/kernel/msi.c
@@ -13,6 +13,16 @@
 
 #include <asm/machdep.h>
 
+int arch_msi_set_iova(struct pci_dev *pdev, int region_num,
+		      dma_addr_t iova, bool set)
+{
+	if (ppc_md.msi_set_iova) {
+		pr_debug("msi: Using platform get_region_count routine.\n");
+		return ppc_md.msi_set_iova(pdev, region_num, iova, set);
+	}
+	return 0;
+}
+
 int arch_msi_get_region_count(void)
 {
 	if (ppc_md.msi_get_region_count) {
diff --git a/arch/powerpc/sysdev/fsl_msi.c b/arch/powerpc/sysdev/fsl_msi.c
index eeebbf0..ad22d74 100644
--- a/arch/powerpc/sysdev/fsl_msi.c
+++ b/arch/powerpc/sysdev/fsl_msi.c
@@ -137,6 +137,46 @@ static int fsl_msi_get_region(int region_num, struct msi_region *region)
 	return -ENODEV;
 }
 
+static int fsl_msi_set_iova(struct pci_dev *pdev, int region_num,
+			    dma_addr_t iova, bool set)
+{
+	struct fsl_msi *msi_data;
+	struct fsl_msi_device *device;
+
+	list_for_each_entry(msi_data, &msi_head, list) {
+		if (msi_data->bank_index != region_num)
+			continue;
+		mutex_lock(&msi_data->lock);
+		if (set) {
+			list_for_each_entry(device, &msi_data->device_list, list) {
+				if (device->dev == pdev) {
+					device->iova = iova;
+					mutex_unlock(&msi_data->lock);
+					return 0;
+				}
+			}
+
+			device = kzalloc(sizeof(struct fsl_msi_device), GFP_KERNEL);
+			device->dev = pdev;
+			device->iova = iova;
+			list_add_tail(&device->list, &msi_data->device_list);
+		} else {
+			list_for_each_entry(device, &msi_data->device_list, list) {
+				if (device->dev == pdev) {
+					list_del(&device->list);
+					kfree(device);
+					mutex_unlock(&msi_data->lock);
+					return 0;
+				}
+			}
+		}
+
+		mutex_unlock(&msi_data->lock);
+		break;
+	}
+	return 0;
+}
+
 static int fsl_msi_check_device(struct pci_dev *pdev, int nvec, int type)
 {
 	if (type == PCI_CAP_ID_MSIX)
@@ -167,6 +207,7 @@ static void fsl_compose_msi_msg(struct pci_dev *pdev, int hwirq,
 				struct msi_msg *msg,
 				struct fsl_msi *fsl_msi_data)
 {
+	struct fsl_msi_device *device;
 	struct fsl_msi *msi_data = fsl_msi_data;
 	struct pci_controller *hose = pci_bus_to_host(pdev->bus);
 	u64 address; /* Physical address of the MSIIR */
@@ -181,6 +222,18 @@ static void fsl_compose_msi_msg(struct pci_dev *pdev, int hwirq,
 		address = fsl_pci_immrbar_base(hose) +
 			   (msi_data->msiir & 0xfffff);
 
+	printk("%s address = %llx\n", __func__, address);
+	
+	mutex_lock(&msi_data->lock);
+	list_for_each_entry(device, &msi_data->device_list, list) {
+		if (device->dev == pdev) {
+			address = device->iova | (msi_data->msiir & 0xfff);
+			break;
+		}
+	}
+	mutex_unlock(&msi_data->lock);
+	printk("%s address = %llx\n", __func__, address);
+
 	msg->address_lo = lower_32_bits(address);
 	msg->address_hi = upper_32_bits(address);
 
@@ -356,6 +409,7 @@ static int fsl_of_msi_remove(struct platform_device *ofdev)
 	struct fsl_msi *msi = platform_get_drvdata(ofdev);
 	int virq, i;
 	struct fsl_msi_cascade_data *cascade_data;
+	struct fsl_msi_device *device;
 
 	if (msi->list.prev != NULL)
 		list_del(&msi->list);
@@ -371,6 +425,13 @@ static int fsl_of_msi_remove(struct platform_device *ofdev)
 		msi_bitmap_free(&msi->bitmap);
 	if ((msi->feature & FSL_PIC_IP_MASK) != FSL_PIC_IP_VMPIC)
 		iounmap(msi->msi_regs);
+
+	mutex_lock(&msi->lock);
+	list_for_each_entry(device, &msi->device_list, list) {
+		list_del(&device->list);
+		kfree(device);
+	}
+	mutex_unlock(&msi->lock);
 	kfree(msi);
 
 	return 0;
@@ -436,6 +497,8 @@ static int fsl_of_msi_probe(struct platform_device *dev)
 		dev_err(&dev->dev, "No memory for MSI structure\n");
 		return -ENOMEM;
 	}
+	INIT_LIST_HEAD(&msi->device_list);
+	mutex_init(&msi->lock);
 	platform_set_drvdata(dev, msi);
 
 	msi->irqhost = irq_domain_add_linear(dev->dev.of_node,
@@ -558,6 +621,7 @@ static int fsl_of_msi_probe(struct platform_device *dev)
 		ppc_md.msi_check_device = fsl_msi_check_device;
 		ppc_md.msi_get_region_count = fsl_msi_get_region_count;
 		ppc_md.msi_get_region = fsl_msi_get_region;
+		ppc_md.msi_set_iova = fsl_msi_set_iova;
 	} else if (ppc_md.setup_msi_irqs != fsl_setup_msi_irqs) {
 		dev_err(&dev->dev, "Different MSI driver already installed!\n");
 		err = -ENODEV;
diff --git a/arch/powerpc/sysdev/fsl_msi.h b/arch/powerpc/sysdev/fsl_msi.h
index a2cc5a2..adda5c3 100644
--- a/arch/powerpc/sysdev/fsl_msi.h
+++ b/arch/powerpc/sysdev/fsl_msi.h
@@ -27,9 +27,15 @@
 #define FSL_PIC_IP_IPIC   0x00000002
 #define FSL_PIC_IP_VMPIC  0x00000003
 
+struct fsl_msi_device {
+	struct list_head list;
+	struct pci_dev *dev;
+	dma_addr_t iova;
+};
+
 struct fsl_msi {
 	struct irq_domain *irqhost;
-
+	struct mutex lock;
 	unsigned long cascade_irq;
 	phys_addr_t msiir; /* MSIIR Address in CCSR */
 	u32 ibs_shift; /* Shift of interrupt bit select */
@@ -37,7 +43,7 @@ struct fsl_msi {
 	void __iomem *msi_regs;
 	u32 feature;
 	int msi_virqs[NR_MSI_REG_MAX];
-
+	struct list_head device_list;
 	/*
 	 * During probe each bank is assigned a index number.
 	 * index number start from 0.
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 2643a29..59ec465 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -77,6 +77,18 @@ int __weak arch_msi_get_region(int region_num, struct msi_region *region)
 	return 0;
 }
 
+int __weak arch_msi_set_iova(struct pci_dev *pdev, int region_num,
+			     dma_addr_t iova, bool set)
+{
+	return 0;
+}
+
+int msi_set_iova(struct pci_dev *pdev, int region_num, dma_addr_t iova, bool set)
+{
+	return arch_msi_set_iova(pdev, region_num, iova, set);
+}
+EXPORT_SYMBOL(msi_set_iova);
+
 int msi_get_region_count(void)
 {
 	return arch_msi_get_region_count();
diff --git a/include/linux/pci.h b/include/linux/pci.h
index c587034..c6d3e58 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1195,6 +1195,12 @@ static inline int msi_get_region(int region_num, struct msi_region *region)
 {
 	return 0;
 }
+
+static inline int msi_set_iova(struct pci_dev *pdev, int region_num,
+			       dma_addr_t iova, bool set)
+{
+	return 0;
+}
 #else
 int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec);
 int pci_enable_msi_block_auto(struct pci_dev *dev, unsigned int *maxvec);
@@ -1209,6 +1215,8 @@ void pci_restore_msi_state(struct pci_dev *dev);
 int pci_msi_enabled(void);
 int msi_get_region_count(void);
 int msi_get_region(int region_num, struct msi_region *region);
+int msi_set_iova(struct pci_dev *pdev, int region_num,
+		 dma_addr_t iova, bool set);
 #endif
 
 #ifdef CONFIG_PCIEPORTBUS
-- 
1.7.0.4


