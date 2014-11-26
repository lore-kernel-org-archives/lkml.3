Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbaKZXZB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:25:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58878 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466AbaKZXSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:18:32 -0500
Date: Wed, 26 Nov 2014 15:17:37 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-eda28e7c9786bf35dbd94cf820f60f82b1c574ec@git.kernel.org>
Cc: mingo@kernel.org, tglx@linutronix.de, jroedel@suse.de,
        jiang.liu@linux.intel.com, yinghai@kernel.org,
        gregkh@linuxfoundation.org, benh@kernel.crashing.org,
        rdunlap@infradead.org, bp@alien8.de, bhelgaas@google.com,
        rjw@rjwysocki.net, linux-kernel@vger.kernel.org, joro@8bytes.org,
        hpa@zytor.com, konrad.wilk@oracle.com, tony.luck@intel.com
Reply-To: tony.luck@intel.com, konrad.wilk@oracle.com, joro@8bytes.org,
        hpa@zytor.com, rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, gregkh@linuxfoundation.org, bp@alien8.de,
        bhelgaas@google.com, rdunlap@infradead.org, jiang.liu@linux.intel.com,
        jroedel@suse.de, yinghai@kernel.org, tglx@linutronix.de,
        mingo@kernel.org
In-Reply-To: <1416901802-24211-20-git-send-email-jiang.liu@linux.intel.com>
References: <1416901802-24211-20-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] iommu/vt-d: Clean up unsued code
Git-Commit-ID: eda28e7c9786bf35dbd94cf820f60f82b1c574ec
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

Commit-ID:  eda28e7c9786bf35dbd94cf820f60f82b1c574ec
Gitweb:     http://git.kernel.org/tip/eda28e7c9786bf35dbd94cf820f60f82b1c574ec
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 15:49:43 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 23:52:48 +0100

iommu/vt-d: Clean up unsued code

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
Link: http://lkml.kernel.org/r/1416901802-24211-20-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/intel_irq_remapping.c | 187 +-----------------------------------
 1 file changed, 1 insertion(+), 186 deletions(-)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 95c4482..9a887ba 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -62,35 +62,6 @@ static struct irq_domain_ops intel_ir_domain_ops;
 
 static int __init parse_ioapics_under_ir(void);
 
-static struct irq_2_iommu *irq_2_iommu(unsigned int irq)
-{
-	struct irq_cfg *cfg = irq_cfg(irq);
-	return cfg ? &cfg->irq_2_iommu : NULL;
-}
-
-static int get_irte(int irq, struct irte *entry)
-{
-	struct irq_2_iommu *irq_iommu = irq_2_iommu(irq);
-	unsigned long flags;
-	int index;
-
-	if (!entry || !irq_iommu)
-		return -1;
-
-	raw_spin_lock_irqsave(&irq_2_ir_lock, flags);
-
-	if (unlikely(!irq_iommu->iommu)) {
-		raw_spin_unlock_irqrestore(&irq_2_ir_lock, flags);
-		return -1;
-	}
-
-	index = irq_iommu->irte_index + irq_iommu->sub_handle;
-	*entry = *(irq_iommu->iommu->ir_table->base + index);
-
-	raw_spin_unlock_irqrestore(&irq_2_ir_lock, flags);
-	return 0;
-}
-
 static int alloc_irte(struct intel_iommu *iommu, int irq,
 		      struct irq_2_iommu *irq_iommu, u16 count)
 {
@@ -228,29 +199,6 @@ static int clear_entries(struct irq_2_iommu *irq_iommu)
 	return qi_flush_iec(iommu, index, irq_iommu->irte_mask);
 }
 
-static int free_irte(int irq)
-{
-	struct irq_2_iommu *irq_iommu = irq_2_iommu(irq);
-	unsigned long flags;
-	int rc;
-
-	if (!irq_iommu || irq_iommu->iommu == NULL)
-		return -1;
-
-	raw_spin_lock_irqsave(&irq_2_ir_lock, flags);
-
-	rc = clear_entries(irq_iommu);
-
-	irq_iommu->iommu = NULL;
-	irq_iommu->irte_index = 0;
-	irq_iommu->sub_handle = 0;
-	irq_iommu->irte_mask = 0;
-
-	raw_spin_unlock_irqrestore(&irq_2_ir_lock, flags);
-
-	return rc;
-}
-
 /*
  * source validation type
  */
@@ -925,8 +873,7 @@ error:
 	return -1;
 }
 
-static void prepare_irte(struct irte *irte, int vector,
-			 unsigned int dest)
+static void prepare_irte(struct irte *irte, int vector, unsigned int dest)
 {
 	memset(irte, 0, sizeof(*irte));
 
@@ -946,135 +893,6 @@ static void prepare_irte(struct irte *irte, int vector,
 	irte->redir_hint = 1;
 }
 
-static int intel_setup_ioapic_entry(int irq,
-				    struct IO_APIC_route_entry *route_entry,
-				    unsigned int destination, int vector,
-				    struct io_apic_irq_attr *attr)
-{
-	int ioapic_id = mpc_ioapic_id(attr->ioapic);
-	struct intel_iommu *iommu;
-	struct IR_IO_APIC_route_entry *entry;
-	struct irte irte;
-	int index;
-
-	down_read(&dmar_global_lock);
-	iommu = map_ioapic_to_ir(ioapic_id);
-	if (!iommu) {
-		pr_warn("No mapping iommu for ioapic %d\n", ioapic_id);
-		index = -ENODEV;
-	} else {
-		index = alloc_irte(iommu, irq, irq_2_iommu(irq), 1);
-		if (index < 0) {
-			pr_warn("Failed to allocate IRTE for ioapic %d\n",
-				ioapic_id);
-			index = -ENOMEM;
-		}
-	}
-	up_read(&dmar_global_lock);
-	if (index < 0)
-		return index;
-
-	prepare_irte(&irte, vector, destination);
-
-	/* Set source-id of interrupt request */
-	set_ioapic_sid(&irte, ioapic_id);
-
-	modify_irte(irq_2_iommu(irq), &irte);
-
-	apic_printk(APIC_VERBOSE, KERN_DEBUG "IOAPIC[%d]: "
-		"Set IRTE entry (P:%d FPD:%d Dst_Mode:%d "
-		"Redir_hint:%d Trig_Mode:%d Dlvry_Mode:%X "
-		"Avail:%X Vector:%02X Dest:%08X "
-		"SID:%04X SQ:%X SVT:%X)\n",
-		attr->ioapic, irte.present, irte.fpd, irte.dst_mode,
-		irte.redir_hint, irte.trigger_mode, irte.dlvry_mode,
-		irte.avail, irte.vector, irte.dest_id,
-		irte.sid, irte.sq, irte.svt);
-
-	entry = (struct IR_IO_APIC_route_entry *)route_entry;
-	memset(entry, 0, sizeof(*entry));
-
-	entry->index2	= (index >> 15) & 0x1;
-	entry->zero	= 0;
-	entry->format	= 1;
-	entry->index	= (index & 0x7fff);
-	/*
-	 * IO-APIC RTE will be configured with virtual vector.
-	 * irq handler will do the explicit EOI to the io-apic.
-	 */
-	entry->vector	= attr->ioapic_pin;
-	entry->mask	= 0;			/* enable IRQ */
-	entry->trigger	= attr->trigger;
-	entry->polarity	= attr->polarity;
-
-	/* Mask level triggered irqs.
-	 * Use IRQ_DELAYED_DISABLE for edge triggered irqs.
-	 */
-	if (attr->trigger)
-		entry->mask = 1;
-
-	return 0;
-}
-
-/*
- * Migrate the IO-APIC irq in the presence of intr-remapping.
- *
- * For both level and edge triggered, irq migration is a simple atomic
- * update(of vector and cpu destination) of IRTE and flush the hardware cache.
- *
- * For level triggered, we eliminate the io-apic RTE modification (with the
- * updated vector information), by using a virtual vector (io-apic pin number).
- * Real vector that is used for interrupting cpu will be coming from
- * the interrupt-remapping table entry.
- *
- * As the migration is a simple atomic update of IRTE, the same mechanism
- * is used to migrate MSI irq's in the presence of interrupt-remapping.
- */
-static int
-intel_ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
-			  bool force)
-{
-	struct irq_cfg *cfg = irqd_cfg(data);
-	unsigned int dest, irq = data->irq;
-	struct irte irte;
-	int err;
-
-	if (get_irte(irq, &irte))
-		return -EBUSY;
-
-	err = assign_irq_vector(irq, cfg, mask);
-	if (err)
-		return err;
-
-	err = apic->cpu_mask_to_apicid_and(cfg->domain, mask, &dest);
-	if (err) {
-		if (assign_irq_vector(irq, cfg, data->affinity))
-			pr_err("Failed to recover vector for irq %d\n", irq);
-		return err;
-	}
-
-	irte.vector = cfg->vector;
-	irte.dest_id = IRTE_DEST(dest);
-
-	/*
-	 * Atomically updates the IRTE with the new destination, vector
-	 * and flushes the interrupt entry cache.
-	 */
-	modify_irte(irq_2_iommu(irq), &irte);
-
-	/*
-	 * After this point, all the interrupts will start arriving
-	 * at the new destination. So, time to cleanup the previous
-	 * vector allocation.
-	 */
-	if (cfg->move_in_progress)
-		send_cleanup_vector(cfg);
-
-	cpumask_copy(data->affinity, mask);
-
-	return 0;
-}
-
 static struct irq_domain *intel_get_ir_irq_domain(struct irq_alloc_info *info)
 {
 	struct intel_iommu *iommu = NULL;
@@ -1129,9 +947,6 @@ struct irq_remap_ops intel_irq_remap_ops = {
 	.disable		= disable_irq_remapping,
 	.reenable		= reenable_irq_remapping,
 	.enable_faulting	= enable_drhd_fault_handling,
-	.setup_ioapic_entry	= intel_setup_ioapic_entry,
-	.set_affinity		= intel_ioapic_set_affinity,
-	.free_irq		= free_irte,
 	.get_ir_irq_domain	= intel_get_ir_irq_domain,
 	.get_irq_domain		= intel_get_irq_domain,
 };
