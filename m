Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbaIKOED (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:04:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:38216 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063AbaIKOD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:03:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="384739543"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RFC Part2 v1 20/21] x86: irq_remapping: Clean up unused MSI related code
Date: Thu, 11 Sep 2014 22:03:47 +0800
Message-Id: <1410444228-3134-21-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1410444228-3134-1-git-send-email-jiang.liu@linux.intel.com>
References: <1410444228-3134-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now MSI interrupt has been converted to new hierarchy irqdomain
interfaces, so kill legacy MSI related code and interfaces.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/irq_remapping.h |   13 ---
 arch/x86/include/asm/pci.h           |    5 --
 arch/x86/kernel/x86_init.c           |    2 -
 drivers/iommu/irq_remapping.c        |  153 ----------------------------------
 drivers/iommu/irq_remapping.h        |   15 ----
 5 files changed, 188 deletions(-)

diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index 440053ca7515..8dc1d06f74d9 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -48,10 +48,6 @@ extern int setup_ioapic_remapped_entry(int irq,
 				       int vector,
 				       struct io_apic_irq_attr *attr);
 extern void free_remapped_irq(int irq);
-extern void compose_remapped_msi_msg(struct pci_dev *pdev,
-				     unsigned int irq, unsigned int dest,
-				     struct msi_msg *msg, u8 hpet_id);
-extern int setup_hpet_msi_remapped(unsigned int irq, unsigned int id);
 extern void panic_if_irq_remap(const char *msg);
 extern bool setup_remapped_irq(int irq,
 			       struct irq_cfg *cfg,
@@ -100,15 +96,6 @@ static inline int setup_ioapic_remapped_entry(int irq,
 	return -ENODEV;
 }
 static inline void free_remapped_irq(int irq) { }
-static inline void compose_remapped_msi_msg(struct pci_dev *pdev,
-					    unsigned int irq, unsigned int dest,
-					    struct msi_msg *msg, u8 hpet_id)
-{
-}
-static inline int setup_hpet_msi_remapped(unsigned int irq, unsigned int id)
-{
-	return -ENODEV;
-}
 
 static inline void panic_if_irq_remap(const char *msg)
 {
diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index 4e370a5d8117..d8c80ff32e8c 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -96,15 +96,10 @@ extern void pci_iommu_alloc(void);
 #ifdef CONFIG_PCI_MSI
 /* implemented in arch/x86/kernel/apic/io_apic. */
 struct msi_desc;
-void native_compose_msi_msg(struct pci_dev *pdev, unsigned int irq,
-			    unsigned int dest, struct msi_msg *msg, u8 hpet_id);
 int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type);
 void native_teardown_msi_irq(unsigned int irq);
 void native_restore_msi_irqs(struct pci_dev *dev);
-int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc,
-		  unsigned int irq_base, unsigned int irq_offset);
 #else
-#define native_compose_msi_msg		NULL
 #define native_setup_msi_irqs		NULL
 #define native_teardown_msi_irq		NULL
 #endif
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index e48b674639cc..814fcbadaad1 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -111,11 +111,9 @@ EXPORT_SYMBOL_GPL(x86_platform);
 #if defined(CONFIG_PCI_MSI)
 struct x86_msi_ops x86_msi = {
 	.setup_msi_irqs		= native_setup_msi_irqs,
-	.compose_msi_msg	= native_compose_msi_msg,
 	.teardown_msi_irq	= native_teardown_msi_irq,
 	.teardown_msi_irqs	= default_teardown_msi_irqs,
 	.restore_msi_irqs	= default_restore_msi_irqs,
-	.setup_hpet_msi		= default_setup_hpet_msi,
 	.msi_mask_irq		= default_msi_mask_irq,
 	.msix_mask_irq		= default_msix_mask_irq,
 };
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index bda0d8e73fde..d72094e01dec 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -25,9 +25,6 @@ int no_x2apic_optout;
 
 static struct irq_remap_ops *remap_ops;
 
-static int msi_alloc_remapped_irq(struct pci_dev *pdev, int irq, int nvec);
-static int msi_setup_remapped_irq(struct pci_dev *pdev, unsigned int irq,
-				  int index, int sub_handle);
 static int set_remapped_irq_affinity(struct irq_data *data,
 				     const struct cpumask *mask,
 				     bool force);
@@ -50,117 +47,6 @@ static void irq_remapping_disable_io_apic(void)
 		disconnect_bsp_APIC(0);
 }
 
-#ifndef CONFIG_GENERIC_IRQ_LEGACY_ALLOC_HWIRQ
-static unsigned int irq_alloc_hwirqs(int cnt, int node)
-{
-	return irq_domain_alloc_irqs(NULL, -1, cnt, node, NULL);
-}
-
-static void irq_free_hwirqs(unsigned int from, int cnt)
-{
-	irq_domain_free_irqs(from, cnt);
-}
-#endif
-
-static int do_setup_msi_irqs(struct pci_dev *dev, int nvec)
-{
-	int ret, sub_handle, nvec_pow2, index = 0;
-	unsigned int irq;
-	struct msi_desc *msidesc;
-
-	WARN_ON(!list_is_singular(&dev->msi_list));
-	msidesc = list_entry(dev->msi_list.next, struct msi_desc, list);
-	WARN_ON(msidesc->irq);
-	WARN_ON(msidesc->msi_attrib.multiple);
-	WARN_ON(msidesc->nvec_used);
-
-	irq = irq_alloc_hwirqs(nvec, dev_to_node(&dev->dev));
-	if (irq == 0)
-		return -ENOSPC;
-
-	nvec_pow2 = __roundup_pow_of_two(nvec);
-	msidesc->nvec_used = nvec;
-	msidesc->msi_attrib.multiple = ilog2(nvec_pow2);
-	for (sub_handle = 0; sub_handle < nvec; sub_handle++) {
-		if (!sub_handle) {
-			index = msi_alloc_remapped_irq(dev, irq, nvec_pow2);
-			if (index < 0) {
-				ret = index;
-				goto error;
-			}
-		} else {
-			ret = msi_setup_remapped_irq(dev, irq + sub_handle,
-						     index, sub_handle);
-			if (ret < 0)
-				goto error;
-		}
-		ret = setup_msi_irq(dev, msidesc, irq, sub_handle);
-		if (ret < 0)
-			goto error;
-	}
-	return 0;
-
-error:
-	irq_free_hwirqs(irq, nvec);
-
-	/*
-	 * Restore altered MSI descriptor fields and prevent just destroyed
-	 * IRQs from tearing down again in default_teardown_msi_irqs()
-	 */
-	msidesc->irq = 0;
-	msidesc->nvec_used = 0;
-	msidesc->msi_attrib.multiple = 0;
-
-	return ret;
-}
-
-static int do_setup_msix_irqs(struct pci_dev *dev, int nvec)
-{
-	int node, ret, sub_handle, index = 0;
-	struct msi_desc *msidesc;
-	unsigned int irq;
-
-	node		= dev_to_node(&dev->dev);
-	sub_handle	= 0;
-
-	list_for_each_entry(msidesc, &dev->msi_list, list) {
-
-		irq = irq_alloc_hwirqs(1, node);
-		if (irq == 0)
-			return -1;
-
-		if (sub_handle == 0)
-			ret = index = msi_alloc_remapped_irq(dev, irq, nvec);
-		else
-			ret = msi_setup_remapped_irq(dev, irq, index, sub_handle);
-
-		if (ret < 0)
-			goto error;
-
-		ret = setup_msi_irq(dev, msidesc, irq, 0);
-		if (ret < 0)
-			goto error;
-
-		sub_handle += 1;
-		irq        += 1;
-	}
-
-	return 0;
-
-error:
-	irq_free_hwirqs(irq, 1);
-	return ret;
-}
-
-static int irq_remapping_setup_msi_irqs(struct pci_dev *dev,
-					int nvec, int type)
-{
-	if (type == PCI_CAP_ID_MSI)
-		return do_setup_msi_irqs(dev, nvec);
-	else
-		return do_setup_msix_irqs(dev, nvec);
-}
-
 static void eoi_ioapic_pin_remapped(int apic, int pin, int vector)
 {
 	/*
@@ -178,8 +64,6 @@ static void __init irq_remapping_modify_x86_ops(void)
 	x86_io_apic_ops.set_affinity	= set_remapped_irq_affinity;
 	x86_io_apic_ops.setup_entry	= setup_ioapic_remapped_entry;
 	x86_io_apic_ops.eoi_ioapic_pin	= eoi_ioapic_pin_remapped;
-	x86_msi.setup_hpet_msi		= setup_hpet_msi_remapped;
-	x86_msi.compose_msi_msg		= compose_remapped_msi_msg;
 }
 
 static __init int setup_nointremap(char *str)
@@ -326,43 +210,6 @@ void free_remapped_irq(int irq)
 		remap_ops->free_irq(irq);
 }
 
-void compose_remapped_msi_msg(struct pci_dev *pdev,
-			      unsigned int irq, unsigned int dest,
-			      struct msi_msg *msg, u8 hpet_id)
-{
-	struct irq_cfg *cfg = irq_cfg(irq);
-
-	if (!irq_remapped(cfg))
-		native_compose_msi_msg(pdev, irq, dest, msg, hpet_id);
-	else if (remap_ops && remap_ops->compose_msi_msg)
-		remap_ops->compose_msi_msg(pdev, irq, dest, msg, hpet_id);
-}
-
-static int msi_alloc_remapped_irq(struct pci_dev *pdev, int irq, int nvec)
-{
-	if (!remap_ops || !remap_ops->msi_alloc_irq)
-		return -ENODEV;
-
-	return remap_ops->msi_alloc_irq(pdev, irq, nvec);
-}
-
-static int msi_setup_remapped_irq(struct pci_dev *pdev, unsigned int irq,
-				  int index, int sub_handle)
-{
-	if (!remap_ops || !remap_ops->msi_setup_irq)
-		return -ENODEV;
-
-	return remap_ops->msi_setup_irq(pdev, irq, index, sub_handle);
-}
-
-int setup_hpet_msi_remapped(unsigned int irq, unsigned int id)
-{
-	if (!remap_ops || !remap_ops->setup_hpet_msi)
-		return -ENODEV;
-
-	return remap_ops->setup_hpet_msi(irq, id);
-}
-
 void panic_if_irq_remap(const char *msg)
 {
 	if (irq_remapping_enabled)
diff --git a/drivers/iommu/irq_remapping.h b/drivers/iommu/irq_remapping.h
index 6e46074f06d0..474e20be528f 100644
--- a/drivers/iommu/irq_remapping.h
+++ b/drivers/iommu/irq_remapping.h
@@ -70,21 +70,6 @@ struct irq_remap_ops {
 	/* Free an IRQ */
 	int (*free_irq)(int);
 
-	/* Create MSI msg to use for interrupt remapping */
-	void (*compose_msi_msg)(struct pci_dev *,
-				unsigned int, unsigned int,
-				struct msi_msg *, u8);
-
-	/* Allocate remapping resources for MSI */
-	int (*msi_alloc_irq)(struct pci_dev *, int, int);
-
-	/* Setup the remapped MSI irq */
-	int (*msi_setup_irq)(struct pci_dev *, unsigned int, int, int);
-
-	/* Setup interrupt remapping for an HPET MSI */
-	int (*setup_hpet_msi)(unsigned int, unsigned int);
-
-	/* Get the irqdomain associated the IOMMU device */
 	struct irq_domain *(*get_ir_irq_domain)(struct irq_alloc_info *);
 
 	/* Get the MSI irqdomain associated with the IOMMU device */
-- 
1.7.10.4

