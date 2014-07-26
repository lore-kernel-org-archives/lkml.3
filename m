Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760927AbaGZCoL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 22:44:11 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:6659 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbaGZCnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 22:43:50 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: <linux-kernel@vger.kernel.org>
CC: Xinwei Hu <huxinwei@huawei.com>, Wuyun <wuyun.wu@huawei.com>,
        "Bjorn Helgaas" <bhelgaas@google.com>, <linux-pci@vger.kernel.org>,
        <Paul.Mundt@huawei.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        "Marc Zyngier" <marc.zyngier@arm.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, <linux-arch@vger.kernel.org>,
        <arnab.basu@freescale.com>,
        <virtualization@lists.linux-foundation.org>,
        Hanjun Guo <guohanjun@huawei.com>, Yijing Wang <wangyijing@huawei.com>
Subject: [RFC PATCH 02/11] PCI/MSI: Use new MSI type macro instead of PCI MSI flags
Date: Sat, 26 Jul 2014 11:08:39 +0800
Message-ID: <1406344128-27055-3-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1406344128-27055-1-git-send-email-wangyijing@huawei.com>
References: <1406344128-27055-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.166]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new MSI type marco(MSI_TYPE and MSIX_TYPE) to support
the future generic MSI driver. The coming generic MSI driver
will be used by PCI and Non-PCI devices that have MSI capability.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 arch/mips/pci/msi-octeon.c           |    4 ++--
 arch/powerpc/kernel/msi.c            |    2 +-
 arch/powerpc/platforms/pseries/msi.c |    8 ++++----
 arch/s390/pci/pci.c                  |    2 +-
 arch/x86/kernel/apic/io_apic.c       |    2 +-
 arch/x86/pci/xen.c                   |   24 ++++++++++++------------
 drivers/iommu/irq_remapping.c        |    2 +-
 drivers/irqchip/irq-armada-370-xp.c  |    2 +-
 drivers/pci/msi.c                    |   10 +++++-----
 include/linux/msi.h                  |    3 +++
 10 files changed, 31 insertions(+), 28 deletions(-)

diff --git a/arch/mips/pci/msi-octeon.c b/arch/mips/pci/msi-octeon.c
index 6a6a99f..8105610 100644
--- a/arch/mips/pci/msi-octeon.c
+++ b/arch/mips/pci/msi-octeon.c
@@ -192,14 +192,14 @@ int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 	/*
 	 * MSI-X is not supported.
 	 */
-	if (type == PCI_CAP_ID_MSIX)
+	if (type == MSIX_TYPE)
 		return -EINVAL;
 
 	/*
 	 * If an architecture wants to support multiple MSI, it needs to
 	 * override arch_setup_msi_irqs()
 	 */
-	if (type == PCI_CAP_ID_MSI && nvec > 1)
+	if (type == MSI_TYPE && nvec > 1)
 		return 1;
 
 	list_for_each_entry(entry, &dev->msi_list, list) {
diff --git a/arch/powerpc/kernel/msi.c b/arch/powerpc/kernel/msi.c
index 8bbc12d..05b3133 100644
--- a/arch/powerpc/kernel/msi.c
+++ b/arch/powerpc/kernel/msi.c
@@ -21,7 +21,7 @@ int arch_msi_check_device(struct pci_dev* dev, int nvec, int type)
 	}
 
 	/* PowerPC doesn't support multiple MSI yet */
-	if (type == PCI_CAP_ID_MSI && nvec > 1)
+	if (type == MSI_TYPE && nvec > 1)
 		return 1;
 
 	if (ppc_md.msi_check_device) {
diff --git a/arch/powerpc/platforms/pseries/msi.c b/arch/powerpc/platforms/pseries/msi.c
index 0c882e8..e2f27d6 100644
--- a/arch/powerpc/platforms/pseries/msi.c
+++ b/arch/powerpc/platforms/pseries/msi.c
@@ -339,7 +339,7 @@ static int rtas_msi_check_device(struct pci_dev *pdev, int nvec, int type)
 {
 	int quota, rc;
 
-	if (type == PCI_CAP_ID_MSIX)
+	if (type == MSIX_TYPE)
 		rc = check_req_msix(pdev, nvec);
 	else
 		rc = check_req_msi(pdev, nvec);
@@ -406,14 +406,14 @@ static int rtas_setup_msi_irqs(struct pci_dev *pdev, int nvec_in, int type)
 	if (!pdn)
 		return -ENODEV;
 
-	if (type == PCI_CAP_ID_MSIX && check_msix_entries(pdev))
+	if (type == MSIX_TYPE && check_msix_entries(pdev))
 		return -EINVAL;
 
 	/*
 	 * Firmware currently refuse any non power of two allocation
 	 * so we round up if the quota will allow it.
 	 */
-	if (type == PCI_CAP_ID_MSIX) {
+	if (type == MSIX_TYPE) {
 		int m = roundup_pow_of_two(nvec);
 		int quota = msi_quota_for_device(pdev, m);
 
@@ -427,7 +427,7 @@ static int rtas_setup_msi_irqs(struct pci_dev *pdev, int nvec_in, int type)
 	 * return MSI-Xs.
 	 */
 again:
-	if (type == PCI_CAP_ID_MSI) {
+	if (type == MSI_TYPE) {
 		if (pdn->force_32bit_msi) {
 			rc = rtas_change_msi(pdn, RTAS_CHANGE_32MSI_FN, nvec);
 			if (rc < 0) {
diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index 9ddc51e..fe3a40c 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -407,7 +407,7 @@ int arch_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 	struct msi_msg msg;
 	int rc, irq;
 
-	if (type == PCI_CAP_ID_MSI && nvec > 1)
+	if (type == MSI_TYPE && nvec > 1)
 		return 1;
 	msi_vecs = min(nvec, ZPCI_MSI_VEC_MAX);
 	msi_vecs = min_t(unsigned int, msi_vecs, CONFIG_PCI_NR_MSI);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 81e08ef..b833042 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3069,7 +3069,7 @@ int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 	int node, ret;
 
 	/* Multiple MSI vectors only supported with interrupt remapping */
-	if (type == PCI_CAP_ID_MSI && nvec > 1)
+	if (type == MSI_TYPE && nvec > 1)
 		return 1;
 
 	node = dev_to_node(&dev->dev);
diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 905956f..c19a8de 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -162,14 +162,14 @@ static int xen_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 	struct msi_desc *msidesc;
 	int *v;
 
-	if (type == PCI_CAP_ID_MSI && nvec > 1)
+	if (type == MSI_TYPE && nvec > 1)
 		return 1;
 
 	v = kzalloc(sizeof(int) * max(1, nvec), GFP_KERNEL);
 	if (!v)
 		return -ENOMEM;
 
-	if (type == PCI_CAP_ID_MSIX)
+	if (type == MSIX_TYPE)
 		ret = xen_pci_frontend_enable_msix(dev, v, nvec);
 	else
 		ret = xen_pci_frontend_enable_msi(dev, v);
@@ -178,8 +178,8 @@ static int xen_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 	i = 0;
 	list_for_each_entry(msidesc, &dev->msi_list, list) {
 		irq = xen_bind_pirq_msi_to_irq(dev, msidesc, v[i],
-					       (type == PCI_CAP_ID_MSI) ? nvec : 1,
-					       (type == PCI_CAP_ID_MSIX) ?
+					       (type == MSI_TYPE) ? nvec : 1,
+					       (type == MSIX_TYPE) ?
 					       "pcifront-msi-x" :
 					       "pcifront-msi",
 						DOMID_SELF);
@@ -224,7 +224,7 @@ static int xen_hvm_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 	struct msi_desc *msidesc;
 	struct msi_msg msg;
 
-	if (type == PCI_CAP_ID_MSI && nvec > 1)
+	if (type == MSI_TYPE && nvec > 1)
 		return 1;
 
 	list_for_each_entry(msidesc, &dev->msi_list, list) {
@@ -246,8 +246,8 @@ static int xen_hvm_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 				"xen: msi already bound to pirq=%d\n", pirq);
 		}
 		irq = xen_bind_pirq_msi_to_irq(dev, msidesc, pirq,
-					       (type == PCI_CAP_ID_MSI) ? nvec : 1,
-					       (type == PCI_CAP_ID_MSIX) ?
+					       (type == MSI_TYPE) ? nvec : 1,
+					       (type == MSIX_TYPE) ?
 					       "msi-x" : "msi",
 					       DOMID_SELF);
 		if (irq < 0)
@@ -290,10 +290,10 @@ static int xen_initdom_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 			      (pci_domain_nr(dev->bus) << 16);
 		map_irq.devfn = dev->devfn;
 
-		if (type == PCI_CAP_ID_MSI && nvec > 1) {
+		if (type == MSI_TYPE && nvec > 1) {
 			map_irq.type = MAP_PIRQ_TYPE_MULTI_MSI;
 			map_irq.entry_nr = nvec;
-		} else if (type == PCI_CAP_ID_MSIX) {
+		} else if (type == MSIX_TYPE) {
 			int pos;
 			u32 table_offset, bir;
 
@@ -310,7 +310,7 @@ static int xen_initdom_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 		if (pci_seg_supported)
 			ret = HYPERVISOR_physdev_op(PHYSDEVOP_map_pirq,
 						    &map_irq);
-		if (type == PCI_CAP_ID_MSI && nvec > 1 && ret) {
+		if (type == MSI_TYPE && nvec > 1 && ret) {
 			/*
 			 * If MAP_PIRQ_TYPE_MULTI_MSI is not available
 			 * there's nothing else we can do in this case.
@@ -337,8 +337,8 @@ static int xen_initdom_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 		}
 
 		ret = xen_bind_pirq_msi_to_irq(dev, msidesc, map_irq.pirq,
-		                               (type == PCI_CAP_ID_MSI) ? nvec : 1,
-		                               (type == PCI_CAP_ID_MSIX) ? "msi-x" : "msi",
+		                               (type == MSI_TYPE) ? nvec : 1,
+		                               (type == MSIX_TYPE) ? "msi-x" : "msi",
 		                               domid);
 		if (ret < 0)
 			goto out;
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 33c4395..a3b1805 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -142,7 +142,7 @@ error:
 static int irq_remapping_setup_msi_irqs(struct pci_dev *dev,
 					int nvec, int type)
 {
-	if (type == PCI_CAP_ID_MSI)
+	if (type == MSI_TYPE)
 		return do_setup_msi_irqs(dev, nvec);
 	else
 		return do_setup_msix_irqs(dev, nvec);
diff --git a/drivers/irqchip/irq-armada-370-xp.c b/drivers/irqchip/irq-armada-370-xp.c
index c887e6e..249823b 100644
--- a/drivers/irqchip/irq-armada-370-xp.c
+++ b/drivers/irqchip/irq-armada-370-xp.c
@@ -170,7 +170,7 @@ static int armada_370_xp_check_msi_device(struct msi_chip *chip, struct pci_dev
 					  int nvec, int type)
 {
 	/* We support MSI, but not MSI-X */
-	if (type == PCI_CAP_ID_MSI)
+	if (type == MSI_TYPE)
 		return 0;
 	return -EINVAL;
 }
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index e67acd1..e416dc0 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -75,7 +75,7 @@ int __weak arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 	 * If an architecture wants to support multiple MSI, it needs to
 	 * override arch_setup_msi_irqs()
 	 */
-	if (type == PCI_CAP_ID_MSI && nvec > 1)
+	if (type == MSI_TYPE && nvec > 1)
 		return 1;
 
 	list_for_each_entry(entry, &dev->msi_list, list) {
@@ -639,7 +639,7 @@ static int msi_capability_init(struct pci_dev *dev, int nvec)
 	list_add_tail(&entry->list, &dev->msi_list);
 
 	/* Configure MSI capability structure */
-	ret = arch_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSI);
+	ret = arch_setup_msi_irqs(dev, nvec, MSI_TYPE);
 	if (ret) {
 		msi_mask_irq(entry, mask, ~mask);
 		free_msi_irqs(dev);
@@ -754,7 +754,7 @@ static int msix_capability_init(struct pci_dev *dev,
 	if (ret)
 		return ret;
 
-	ret = arch_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSIX);
+	ret = arch_setup_msi_irqs(dev, nvec, MSIX_TYPE);
 	if (ret)
 		goto out_avail;
 
@@ -950,7 +950,7 @@ int pci_enable_msix(struct pci_dev *dev, struct msix_entry *entries, int nvec)
 	if (!entries || !dev->msix_cap || dev->current_state != PCI_D0)
 		return -EINVAL;
 
-	status = pci_msi_check_device(dev, nvec, PCI_CAP_ID_MSIX);
+	status = pci_msi_check_device(dev, nvec, MSIX_TYPE);
 	if (status)
 		return status;
 
@@ -1084,7 +1084,7 @@ int pci_enable_msi_range(struct pci_dev *dev, int minvec, int maxvec)
 		nvec = maxvec;
 
 	do {
-		rc = pci_msi_check_device(dev, nvec, PCI_CAP_ID_MSI);
+		rc = pci_msi_check_device(dev, nvec, MSI_TYPE);
 		if (rc < 0) {
 			return rc;
 		} else if (rc > 0) {
diff --git a/include/linux/msi.h b/include/linux/msi.h
index ce88c5b..3ad8416 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -67,6 +67,9 @@ void default_restore_msi_irqs(struct pci_dev *dev);
 u32 default_msi_mask_irq(struct msi_desc *desc, u32 mask, u32 flag);
 u32 default_msix_mask_irq(struct msi_desc *desc, u32 flag);
 
+#define MSI_TYPE	0x01
+#define MSIX_TYPE	0x02
+
 struct msi_chip {
 	struct module *owner;
 	struct device *dev;
-- 
1.7.1

