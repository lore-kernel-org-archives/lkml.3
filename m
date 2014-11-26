Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbaKZXKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:10:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58341 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000AbaKZXKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:10:48 -0500
Date: Wed, 26 Nov 2014 15:09:48 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-2be90208a0c0ef8cde3ee7e6361366047abbe3a7@git.kernel.org>
Cc: rjw@rjwysocki.net, tglx@linutronix.de, bhelgaas@google.com,
        joro@8bytes.org, jiang.liu@linux.intel.com, benh@kernel.crashing.org,
        bp@alien8.de, hpa@zytor.com, konrad.wilk@oracle.com,
        linux-kernel@vger.kernel.org, jroedel@suse.de,
        gregkh@linuxfoundation.org, rdunlap@infradead.org, yinghai@kernel.org,
        tony.luck@intel.com, mingo@kernel.org
Reply-To: bhelgaas@google.com, tglx@linutronix.de, rjw@rjwysocki.net,
        jiang.liu@linux.intel.com, benh@kernel.crashing.org, bp@alien8.de,
        joro@8bytes.org, linux-kernel@vger.kernel.org, jroedel@suse.de,
        gregkh@linuxfoundation.org, hpa@zytor.com, konrad.wilk@oracle.com,
        yinghai@kernel.org, tony.luck@intel.com, mingo@kernel.org,
        rdunlap@infradead.org
In-Reply-To: <1416894816-23245-17-git-send-email-jiang.liu@linux.intel.com>
References: <1416894816-23245-17-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] iommu/amd: Clean up unused MSI related code
Git-Commit-ID: 2be90208a0c0ef8cde3ee7e6361366047abbe3a7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2be90208a0c0ef8cde3ee7e6361366047abbe3a7
Gitweb:     http://git.kernel.org/tip/2be90208a0c0ef8cde3ee7e6361366047abbe3a7
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 13:53:25 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 18:59:25 +0100

iommu/amd: Clean up unused MSI related code

Now MSI interrupt has been converted to new hierarchy irqdomain
interfaces, so kill legacy MSI related code.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Acked-by: Joerg Roedel <jroedel@suse.de>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: iommu@lists.linux-foundation.org
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Joerg Roedel <joro@8bytes.org>
Link: http://lkml.kernel.org/r/1416894816-23245-17-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/iommu/amd_iommu.c | 115 +---------------------------------------------
 1 file changed, 2 insertions(+), 113 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index d027423..38fb944 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -3958,8 +3958,7 @@ out_unlock:
 	return table;
 }
 
-static int alloc_irq_index(struct irq_cfg *cfg, struct irq_2_irte *irte_info,
-			   u16 devid, int count)
+static int alloc_irq_index(u16 devid, int count)
 {
 	struct irq_remap_table *table;
 	unsigned long flags;
@@ -3985,11 +3984,6 @@ static int alloc_irq_index(struct irq_cfg *cfg, struct irq_2_irte *irte_info,
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
@@ -4189,106 +4183,6 @@ static int free_irq(int irq)
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
-static int alloc_hpet_msi(unsigned int irq, unsigned int id)
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
@@ -4365,10 +4259,6 @@ struct irq_remap_ops amd_iommu_irq_ops = {
 	.setup_ioapic_entry	= setup_ioapic_entry,
 	.set_affinity		= set_affinity,
 	.free_irq		= free_irq,
-	.compose_msi_msg	= compose_msi_msg,
-	.msi_alloc_irq		= msi_alloc_irq,
-	.msi_setup_irq		= msi_setup_irq,
-	.alloc_hpet_msi		= alloc_hpet_msi,
 	.get_ir_irq_domain	= get_ir_irq_domain,
 	.get_irq_domain		= get_irq_domain,
 };
@@ -4466,8 +4356,7 @@ static int irq_remapping_alloc(struct irq_domain *domain, unsigned int virq,
 		else
 			ret = -ENOMEM;
 	} else {
-		cfg = irq_cfg(virq);
-		index = alloc_irq_index(cfg, &data->irq_2_irte, devid, nr_irqs);
+		index = alloc_irq_index(devid, nr_irqs);
 	}
 	if (index < 0) {
 		pr_warn("Failed to allocate IRTE\n");
