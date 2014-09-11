Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbaIKODX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:03:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:38216 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755142AbaIKODS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:03:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="384739451"
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
Subject: [RFC Part2 v1 18/21] iommu/vt-d: Clean up unused MSI related code
Date: Thu, 11 Sep 2014 22:03:45 +0800
Message-Id: <1410444228-3134-19-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1410444228-3134-1-git-send-email-jiang.liu@linux.intel.com>
References: <1410444228-3134-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now MSI interrupt has been converted to new hierarchy irqdomain
interfaces, so kill legacy MSI related code.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/intel_irq_remapping.c |  144 -----------------------------------
 1 file changed, 144 deletions(-)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 8bac5935e0d5..840db5fee320 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -146,44 +146,6 @@ static int qi_flush_iec(struct intel_iommu *iommu, int index, int mask)
 	return qi_submit_sync(&desc, iommu);
 }
 
-static int map_irq_to_irte_handle(int irq, u16 *sub_handle)
-{
-	struct irq_2_iommu *irq_iommu = irq_2_iommu(irq);
-	unsigned long flags;
-	int index;
-
-	if (!irq_iommu)
-		return -1;
-
-	raw_spin_lock_irqsave(&irq_2_ir_lock, flags);
-	*sub_handle = irq_iommu->sub_handle;
-	index = irq_iommu->irte_index;
-	raw_spin_unlock_irqrestore(&irq_2_ir_lock, flags);
-	return index;
-}
-
-static int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index, u16 subhandle)
-{
-	struct irq_2_iommu *irq_iommu = irq_2_iommu(irq);
-	struct irq_cfg *cfg = irq_cfg(irq);
-	unsigned long flags;
-
-	if (!irq_iommu)
-		return -1;
-
-	raw_spin_lock_irqsave(&irq_2_ir_lock, flags);
-
-	cfg->remapped = 1;
-	irq_iommu->iommu = iommu;
-	irq_iommu->irte_index = index;
-	irq_iommu->sub_handle = subhandle;
-	irq_iommu->irte_mask = 0;
-
-	raw_spin_unlock_irqrestore(&irq_2_ir_lock, flags);
-
-	return 0;
-}
-
 static int modify_irte(struct irq_2_iommu *irq_iommu,
 		       struct irte *irte_modified)
 {
@@ -1072,108 +1034,6 @@ intel_ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	return 0;
 }
 
-static void intel_compose_msi_msg(struct pci_dev *pdev,
-				  unsigned int irq, unsigned int dest,
-				  struct msi_msg *msg, u8 hpet_id)
-{
-	struct irq_cfg *cfg;
-	struct irte irte;
-	u16 sub_handle = 0;
-	int ir_index;
-
-	cfg = irq_cfg(irq);
-
-	ir_index = map_irq_to_irte_handle(irq, &sub_handle);
-	BUG_ON(ir_index == -1);
-
-	prepare_irte(&irte, cfg->vector, dest);
-
-	/* Set source-id of interrupt request */
-	if (pdev)
-		set_msi_sid(&irte, pdev);
-	else
-		set_hpet_sid(&irte, hpet_id);
-
-	modify_irte(irq_2_iommu(irq), &irte);
-
-	msg->address_hi = MSI_ADDR_BASE_HI;
-	msg->data = sub_handle;
-	msg->address_lo = MSI_ADDR_BASE_LO | MSI_ADDR_IR_EXT_INT |
-			  MSI_ADDR_IR_SHV |
-			  MSI_ADDR_IR_INDEX1(ir_index) |
-			  MSI_ADDR_IR_INDEX2(ir_index);
-}
-
-/*
- * Map the PCI dev to the corresponding remapping hardware unit
- * and allocate 'nvec' consecutive interrupt-remapping table entries
- * in it.
- */
-static int intel_msi_alloc_irq(struct pci_dev *dev, int irq, int nvec)
-{
-	struct intel_iommu *iommu;
-	int index;
-
-	down_read(&dmar_global_lock);
-	iommu = map_dev_to_ir(dev);
-	if (!iommu) {
-		printk(KERN_ERR
-		       "Unable to map PCI %s to iommu\n", pci_name(dev));
-		index = -ENOENT;
-	} else {
-		index = alloc_irte(iommu, irq, irq_2_iommu(irq), nvec);
-		if (index < 0) {
-			printk(KERN_ERR
-			       "Unable to allocate %d IRTE for PCI %s\n",
-			       nvec, pci_name(dev));
-			index = -ENOSPC;
-		}
-	}
-	up_read(&dmar_global_lock);
-
-	return index;
-}
-
-static int intel_msi_setup_irq(struct pci_dev *pdev, unsigned int irq,
-			       int index, int sub_handle)
-{
-	struct intel_iommu *iommu;
-	int ret = -ENOENT;
-
-	down_read(&dmar_global_lock);
-	iommu = map_dev_to_ir(pdev);
-	if (iommu) {
-		/*
-		 * setup the mapping between the irq and the IRTE
-		 * base index, the sub_handle pointing to the
-		 * appropriate interrupt remap table entry.
-		 */
-		set_irte_irq(irq, iommu, index, sub_handle);
-		ret = 0;
-	}
-	up_read(&dmar_global_lock);
-
-	return ret;
-}
-
-static int intel_setup_hpet_msi(unsigned int irq, unsigned int id)
-{
-	int ret = -1;
-	struct intel_iommu *iommu;
-	int index;
-
-	down_read(&dmar_global_lock);
-	iommu = map_hpet_to_ir(id);
-	if (iommu) {
-		index = alloc_irte(iommu, irq, irq_2_iommu(irq), 1);
-		if (index >= 0)
-			ret = 0;
-	}
-	up_read(&dmar_global_lock);
-
-	return ret;
-}
-
 static struct irq_domain *intel_get_ir_irq_domain(struct irq_alloc_info *info)
 {
 	struct intel_iommu *iommu = NULL;
@@ -1247,10 +1107,6 @@ struct irq_remap_ops intel_irq_remap_ops = {
 	.setup_ioapic_entry	= intel_setup_ioapic_entry,
 	.set_affinity		= intel_ioapic_set_affinity,
 	.free_irq		= free_irte,
-	.compose_msi_msg	= intel_compose_msi_msg,
-	.msi_alloc_irq		= intel_msi_alloc_irq,
-	.msi_setup_irq		= intel_msi_setup_irq,
-	.setup_hpet_msi		= intel_setup_hpet_msi,
 	.get_ir_irq_domain	= intel_get_ir_irq_domain,
 	.get_irq_domain		= intel_get_irq_domain,
 	.get_ioapic_entry	= intel_get_ioapic_entry,
-- 
1.7.10.4

