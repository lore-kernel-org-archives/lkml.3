Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbaKZXSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:18:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58908 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744AbaKZXSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:18:43 -0500
Date: Wed, 26 Nov 2014 15:17:52 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-7aad9b7c36feee80ddf83e049057258a5cf4402c@git.kernel.org>
Cc: bhelgaas@google.com, jroedel@suse.de, benh@kernel.crashing.org,
        mingo@kernel.org, rjw@rjwysocki.net, yinghai@kernel.org,
        rdunlap@infradead.org, linux-kernel@vger.kernel.org,
        jiang.liu@linux.intel.com, bp@alien8.de, joro@8bytes.org,
        tony.luck@intel.com, konrad.wilk@oracle.com,
        gregkh@linuxfoundation.org, tglx@linutronix.de, hpa@zytor.com
Reply-To: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jiang.liu@linux.intel.com, tony.luck@intel.com, bp@alien8.de,
        joro@8bytes.org, gregkh@linuxfoundation.org, konrad.wilk@oracle.com,
        yinghai@kernel.org, rdunlap@infradead.org, mingo@kernel.org,
        rjw@rjwysocki.net, jroedel@suse.de, bhelgaas@google.com,
        benh@kernel.crashing.org
In-Reply-To: <1416901802-24211-21-git-send-email-jiang.liu@linux.intel.com>
References: <1416901802-24211-21-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] iommu/amd: Clean up unsued code
Git-Commit-ID: 7aad9b7c36feee80ddf83e049057258a5cf4402c
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

Commit-ID:  7aad9b7c36feee80ddf83e049057258a5cf4402c
Gitweb:     http://git.kernel.org/tip/7aad9b7c36feee80ddf83e049057258a5cf4402c
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 15:49:44 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 23:52:48 +0100

iommu/amd: Clean up unsued code

Now we have converted to hierarchy irqdomain, so clean up unused code.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
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
Link: http://lkml.kernel.org/r/1416901802-24211-21-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/amd_iommu.c | 144 ----------------------------------------------
 1 file changed, 144 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 38fb944..e2b56b4 100644
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
