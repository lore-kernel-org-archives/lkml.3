Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbaIKOD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:03:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:38216 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755349AbaIKODX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:03:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="384739487"
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
Subject: [RFC Part2 v1 19/21] iommu/amd: Clean up unused MSI related code
Date: Thu, 11 Sep 2014 22:03:46 +0800
Message-Id: <1410444228-3134-20-git-send-email-jiang.liu@linux.intel.com>
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
 drivers/iommu/amd_iommu.c |  115 +--------------------------------------------
 1 file changed, 2 insertions(+), 113 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 71ab03949599..e34587a9d317 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -3940,8 +3940,7 @@ out_unlock:
 	return table;
 }
 
-static int alloc_irq_index(struct irq_cfg *cfg, struct irq_2_irte *irte_info,
-			   u16 devid, int count)
+static int alloc_irq_index(u16 devid, int count)
 {
 	struct irq_remap_table *table;
 	unsigned long flags;
@@ -3967,11 +3966,6 @@ static int alloc_irq_index(struct irq_cfg *cfg, struct irq_2_irte *irte_info,
 				table->table[index - c + 1] = IRTE_ALLOCATED;
 
 			index -= count - 1;
-
-			cfg->remapped	      = 1;
-			irte_info->devid      = devid;
-			irte_info->index      = index;
-
 			goto out;
 		}
 	}
@@ -4171,106 +4165,6 @@ static int free_irq(int irq)
 	return 0;
 }
 
-static void compose_msi_msg(struct pci_dev *pdev,
-			    unsigned int irq, unsigned int dest,
-			    struct msi_msg *msg, u8 hpet_id)
-{
-	struct irq_2_irte *irte_info;
-	struct irq_cfg *cfg;
-	union irte irte;
-
-	cfg = irq_cfg(irq);
-	if (!cfg)
-		return;
-
-	irte_info = &cfg->irq_2_irte;
-
-	irte.val		= 0;
-	irte.fields.vector	= cfg->vector;
-	irte.fields.int_type    = apic->irq_delivery_mode;
-	irte.fields.destination	= dest;
-	irte.fields.dm		= apic->irq_dest_mode;
-	irte.fields.valid	= 1;
-
-	modify_irte(irte_info->devid, irte_info->index, irte);
-
-	msg->address_hi = MSI_ADDR_BASE_HI;
-	msg->address_lo = MSI_ADDR_BASE_LO;
-	msg->data       = irte_info->index;
-}
-
-static int msi_alloc_irq(struct pci_dev *pdev, int irq, int nvec)
-{
-	struct irq_cfg *cfg;
-	int index;
-	u16 devid;
-
-	if (!pdev)
-		return -EINVAL;
-
-	cfg = irq_cfg(irq);
-	if (!cfg)
-		return -EINVAL;
-
-	devid = get_device_id(&pdev->dev);
-	index = alloc_irq_index(cfg, &cfg->irq_2_irte, devid, nvec);
-
-	return index < 0 ? MAX_IRQS_PER_TABLE : index;
-}
-
-static int msi_setup_irq(struct pci_dev *pdev, unsigned int irq,
-			 int index, int offset)
-{
-	struct irq_2_irte *irte_info;
-	struct irq_cfg *cfg;
-	u16 devid;
-
-	if (!pdev)
-		return -EINVAL;
-
-	cfg = irq_cfg(irq);
-	if (!cfg)
-		return -EINVAL;
-
-	if (index >= MAX_IRQS_PER_TABLE)
-		return 0;
-
-	devid		= get_device_id(&pdev->dev);
-	irte_info	= &cfg->irq_2_irte;
-
-	cfg->remapped	      = 1;
-	irte_info->devid      = devid;
-	irte_info->index      = index + offset;
-
-	return 0;
-}
-
-static int setup_hpet_msi(unsigned int irq, unsigned int id)
-{
-	struct irq_2_irte *irte_info;
-	struct irq_cfg *cfg;
-	int index, devid;
-
-	cfg = irq_cfg(irq);
-	if (!cfg)
-		return -EINVAL;
-
-	irte_info = &cfg->irq_2_irte;
-	devid     = get_hpet_devid(id);
-	if (devid < 0)
-		return devid;
-
-	index = alloc_irq_index(cfg, &cfg->irq_2_irte, devid, 1);
-	if (index < 0)
-		return index;
-
-	cfg->remapped	      = 1;
-	irte_info->devid      = devid;
-	irte_info->index      = index;
-
-	return 0;
-}
-
 static int get_devid(struct irq_alloc_info *info)
 {
 	int devid = -1;
@@ -4363,10 +4257,6 @@ struct irq_remap_ops amd_iommu_irq_ops = {
 	.setup_ioapic_entry	= setup_ioapic_entry,
 	.set_affinity		= set_affinity,
 	.free_irq		= free_irq,
-	.compose_msi_msg	= compose_msi_msg,
-	.msi_alloc_irq		= msi_alloc_irq,
-	.msi_setup_irq		= msi_setup_irq,
-	.setup_hpet_msi		= setup_hpet_msi,
 	.get_ir_irq_domain	= get_ir_irq_domain,
 	.get_irq_domain		= get_irq_domain,
 	.get_ioapic_entry	= get_ioapic_entry,
@@ -4457,8 +4347,7 @@ static int irq_remapping_alloc(struct irq_domain *domain, unsigned int virq,
 		else
 			ret = -ENOMEM;
 	} else {
-		cfg = irq_cfg(virq);
-		index = alloc_irq_index(cfg, &data->irq_2_irte, devid, nr_irqs);
+		index = alloc_irq_index(devid, nr_irqs);
 	}
 	if (index < 0) {
 		pr_warn("Failed to allocate IRTE\n");
-- 
1.7.10.4

