Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294AbaKHSV2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 13:21:28 -0500
Received: from mga01.intel.com ([192.55.52.88]:51546 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754265AbaKHSPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 13:15:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="413533891"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [Patch Part3 v3 20/38] iommu/amd: Clean up unsued code
Date: Sun,  9 Nov 2014 02:13:20 +0800
Message-Id: <1415470418-10874-21-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415470418-10874-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415470418-10874-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we have converted to hierarchy irqdomain, so clean up unused code.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/amd_iommu.c |  144 ---------------------------------------------
 1 file changed, 144 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 336d310b5b7b..704c18e3eb63 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -3996,22 +3996,6 @@ out:
 	return index;
 }
 
-static int get_irte(u16 devid, int index, union irte *irte)
-{
-	struct irq_remap_table *table;
-	unsigned long flags;
-
-	table = get_irq_table(devid, false);
-	if (!table)
-		return -ENOMEM;
-
-	spin_lock_irqsave(&table->lock, flags);
-	irte->val = table->table[index];
-	spin_unlock_irqrestore(&table->lock, flags);
-
-	return 0;
-}
-
 static int modify_irte(u16 devid, int index, union irte irte)
 {
 	struct irq_remap_table *table;
@@ -4058,131 +4042,6 @@ static void free_irte(u16 devid, int index)
 	iommu_completion_wait(iommu);
 }
 
-static int setup_ioapic_entry(int irq, struct IO_APIC_route_entry *entry,
-			      unsigned int destination, int vector,
-			      struct io_apic_irq_attr *attr)
-{
-	struct irq_remap_table *table;
-	struct irq_2_irte *irte_info;
-	struct irq_cfg *cfg;
-	union irte irte;
-	int ioapic_id;
-	int index;
-	int devid;
-	int ret;
-
-	cfg = irq_cfg(irq);
-	if (!cfg)
-		return -EINVAL;
-
-	irte_info = &cfg->irq_2_irte;
-	ioapic_id = mpc_ioapic_id(attr->ioapic);
-	devid     = get_ioapic_devid(ioapic_id);
-
-	if (devid < 0)
-		return devid;
-
-	table = get_irq_table(devid, true);
-	if (table == NULL)
-		return -ENOMEM;
-
-	index = attr->ioapic_pin;
-
-	/* Setup IRQ remapping info */
-	cfg->remapped	      = 1;
-	irte_info->devid      = devid;
-	irte_info->index      = index;
-
-	/* Setup IRTE for IOMMU */
-	irte.val		= 0;
-	irte.fields.vector      = vector;
-	irte.fields.int_type    = apic->irq_delivery_mode;
-	irte.fields.destination = destination;
-	irte.fields.dm          = apic->irq_dest_mode;
-	irte.fields.valid       = 1;
-
-	ret = modify_irte(devid, index, irte);
-	if (ret)
-		return ret;
-
-	/* Setup IOAPIC entry */
-	memset(entry, 0, sizeof(*entry));
-
-	entry->vector        = index;
-	entry->mask          = 0;
-	entry->trigger       = attr->trigger;
-	entry->polarity      = attr->polarity;
-
-	/*
-	 * Mask level triggered irqs.
-	 */
-	if (attr->trigger)
-		entry->mask = 1;
-
-	return 0;
-}
-
-static int set_affinity(struct irq_data *data, const struct cpumask *mask,
-			bool force)
-{
-	struct irq_2_irte *irte_info;
-	unsigned int dest, irq;
-	struct irq_cfg *cfg;
-	union irte irte;
-	int err;
-
-	if (!config_enabled(CONFIG_SMP))
-		return -1;
-
-	cfg       = irqd_cfg(data);
-	irq       = data->irq;
-	irte_info = &cfg->irq_2_irte;
-
-	if (!cpumask_intersects(mask, cpu_online_mask))
-		return -EINVAL;
-
-	if (get_irte(irte_info->devid, irte_info->index, &irte))
-		return -EBUSY;
-
-	if (assign_irq_vector(irq, cfg, mask))
-		return -EBUSY;
-
-	err = apic->cpu_mask_to_apicid_and(cfg->domain, mask, &dest);
-	if (err) {
-		if (assign_irq_vector(irq, cfg, data->affinity))
-			pr_err("AMD-Vi: Failed to recover vector for irq %d\n", irq);
-		return err;
-	}
-
-	irte.fields.vector      = cfg->vector;
-	irte.fields.destination = dest;
-
-	modify_irte(irte_info->devid, irte_info->index, irte);
-
-	if (cfg->move_in_progress)
-		send_cleanup_vector(cfg);
-
-	cpumask_copy(data->affinity, mask);
-
-	return 0;
-}
-
-static int free_irq(int irq)
-{
-	struct irq_2_irte *irte_info;
-	struct irq_cfg *cfg;
-
-	cfg = irq_cfg(irq);
-	if (!cfg)
-		return -EINVAL;
-
-	irte_info = &cfg->irq_2_irte;
-
-	free_irte(irte_info->devid, irte_info->index);
-
-	return 0;
-}
-
 static int get_devid(struct irq_alloc_info *info)
 {
 	int devid = -1;
@@ -4256,9 +4115,6 @@ struct irq_remap_ops amd_iommu_irq_ops = {
 	.disable		= amd_iommu_disable,
 	.reenable		= amd_iommu_reenable,
 	.enable_faulting	= amd_iommu_enable_faulting,
-	.setup_ioapic_entry	= setup_ioapic_entry,
-	.set_affinity		= set_affinity,
-	.free_irq		= free_irq,
 	.get_ir_irq_domain	= get_ir_irq_domain,
 	.get_irq_domain		= get_irq_domain,
 };
-- 
1.7.10.4

