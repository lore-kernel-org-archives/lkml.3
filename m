Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbaFJNJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 09:09:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282AbaFJNJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 09:09:32 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, x86@kernel.org,
        xen-devel@lists.xenproject.org, iommu@lists.linux-foundation.org,
        linux-ide@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH 2/3] PCI/MSI/x86: Support pci_enable_msi_partial()
Date: Tue, 10 Jun 2014 15:10:31 +0200
Message-Id: <1f052377ed5a93922fe84beacb02b913c63b8293.1402405331.git.agordeev@redhat.com>
In-Reply-To: <cover.1402405331.git.agordeev@redhat.com>
References: <cover.1402405331.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change is a prerequisite for the forthcoming update
of the AHCI device driver to conserve 10/16 MSIs on Intel
chipsets. The update makes use of 'nvec_mme' parameter of
pci_enable_msi_partial() function.

Cc: x86@kernel.org
Cc: xen-devel@lists.xenproject.org
Cc: iommu@lists.linux-foundation.org
Cc: linux-ide@vger.kernel.org
Cc: linux-pci@vger.kernel.org
Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 arch/x86/include/asm/pci.h      |    3 ++-
 arch/x86/include/asm/x86_init.h |    3 ++-
 arch/x86/kernel/apic/io_apic.c  |    2 +-
 arch/x86/kernel/x86_init.c      |    2 +-
 arch/x86/pci/xen.c              |    9 ++++++---
 drivers/iommu/irq_remapping.c   |   10 +++++-----
 6 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index 0892ea0..24c9b92 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -96,7 +96,8 @@ extern void pci_iommu_alloc(void);
 #ifdef CONFIG_PCI_MSI
 /* implemented in arch/x86/kernel/apic/io_apic. */
 struct msi_desc;
-int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type);
+int native_setup_msi_irqs(struct pci_dev *dev,
+			  int nvec, int nvec_mme, int type);
 void native_teardown_msi_irq(unsigned int irq);
 void native_restore_msi_irqs(struct pci_dev *dev);
 int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc,
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index e45e4da..0c3ecb6 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -175,7 +175,8 @@ struct msi_msg;
 struct msi_desc;
 
 struct x86_msi_ops {
-	int (*setup_msi_irqs)(struct pci_dev *dev, int nvec, int type);
+	int (*setup_msi_irqs)(struct pci_dev *dev,
+			      int nvec, int nvec_mme, int type);
 	void (*compose_msi_msg)(struct pci_dev *dev, unsigned int irq,
 				unsigned int dest, struct msi_msg *msg,
 			       u8 hpet_id);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 9d0a979..0c0faa4 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3060,7 +3060,7 @@ int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc,
 	return 0;
 }
 
-int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int nvec_mme, int type)
 {
 	struct msi_desc *msidesc;
 	unsigned int irq;
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index b65bf95..939171a 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -123,7 +123,7 @@ struct x86_msi_ops x86_msi = {
 /* MSI arch specific hooks */
 int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int nvec_mme, int type)
 {
-	return x86_msi.setup_msi_irqs(dev, nvec, type);
+	return x86_msi.setup_msi_irqs(dev, nvec, nvec_mme, type);
 }
 
 void arch_teardown_msi_irqs(struct pci_dev *dev)
diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 905956f..72e4277 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -156,7 +156,8 @@ static int acpi_register_gsi_xen(struct device *dev, u32 gsi,
 struct xen_pci_frontend_ops *xen_pci_frontend;
 EXPORT_SYMBOL_GPL(xen_pci_frontend);
 
-static int xen_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+static int xen_setup_msi_irqs(struct pci_dev *dev,
+			      int nvec, int nvec_mme, int type)
 {
 	int irq, ret, i;
 	struct msi_desc *msidesc;
@@ -218,7 +219,8 @@ static void xen_msi_compose_msg(struct pci_dev *pdev, unsigned int pirq,
 	msg->data = XEN_PIRQ_MSI_DATA;
 }
 
-static int xen_hvm_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+static int xen_hvm_setup_msi_irqs(struct pci_dev *dev,
+				  int nvec, int nvec_mme, int type)
 {
 	int irq, pirq;
 	struct msi_desc *msidesc;
@@ -266,7 +268,8 @@ error:
 #ifdef CONFIG_XEN_DOM0
 static bool __read_mostly pci_seg_supported = true;
 
-static int xen_initdom_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+static int xen_initdom_setup_msi_irqs(struct pci_dev *dev,
+				      int nvec, int nvec_mme, int type)
 {
 	int ret = 0;
 	struct msi_desc *msidesc;
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 33c4395..6300bfd 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -49,9 +49,9 @@ static void irq_remapping_disable_io_apic(void)
 		disconnect_bsp_APIC(0);
 }
 
-static int do_setup_msi_irqs(struct pci_dev *dev, int nvec)
+static int do_setup_msi_irqs(struct pci_dev *dev, int nvec, int nvec_pow2)
 {
-	int ret, sub_handle, nvec_pow2, index = 0;
+	int ret, sub_handle, index = 0;
 	unsigned int irq;
 	struct msi_desc *msidesc;
 
@@ -60,12 +60,12 @@ static int do_setup_msi_irqs(struct pci_dev *dev, int nvec)
 	WARN_ON(msidesc->irq);
 	WARN_ON(msidesc->msi_attrib.multiple);
 	WARN_ON(msidesc->nvec_used);
+	BUG_ON(!is_power_of_2(nvec_pow2));
 
 	irq = irq_alloc_hwirqs(nvec, dev_to_node(&dev->dev));
 	if (irq == 0)
 		return -ENOSPC;
 
-	nvec_pow2 = __roundup_pow_of_two(nvec);
 	msidesc->nvec_used = nvec;
 	msidesc->msi_attrib.multiple = ilog2(nvec_pow2);
 	for (sub_handle = 0; sub_handle < nvec; sub_handle++) {
@@ -140,10 +140,10 @@ error:
 }
 
 static int irq_remapping_setup_msi_irqs(struct pci_dev *dev,
-					int nvec, int type)
+					int nvec, int nvec_mme, int type)
 {
 	if (type == PCI_CAP_ID_MSI)
-		return do_setup_msi_irqs(dev, nvec);
+		return do_setup_msi_irqs(dev, nvec, nvec_mme);
 	else
 		return do_setup_msix_irqs(dev, nvec);
 }
-- 
1.7.7.6

