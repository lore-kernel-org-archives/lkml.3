Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043AbbATFvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 00:51:36 -0500
Received: from mga11.intel.com ([192.55.52.93]:32974 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002AbbATFvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 00:51:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,432,1418112000"; 
   d="scan'208";a="664447477"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Dimitri Sivanich <sivanich@sgi.com>,
        Joerg Roedel <joro@8bytes.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [Patch Part2 v4 10/33] irq_remapping/vt-d: Clean up unsued code
Date: Tue, 20 Jan 2015 13:51:30 +0800
Message-Id: <1421733113-15704-11-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421733113-15704-1-git-send-email-jiang.liu@linux.intel.com>
References: <1421733113-15704-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 drivers/iommu/intel_irq_remapping.c |  187 +----------------------------------
 1 file changed, 1 insertion(+), 186 deletions(-)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 05941118a179..e76e5723ae87 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -63,35 +63,6 @@ static struct irq_domain_ops intel_ir_domain_ops;
 
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
@@ -229,29 +200,6 @@ static int clear_entries(struct irq_2_iommu *irq_iommu)
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
@@ -932,8 +880,7 @@ error:
 	return -1;
 }
 
-static void prepare_irte(struct irte *irte, int vector,
-			 unsigned int dest)
+static void prepare_irte(struct irte *irte, int vector, unsigned int dest)
 {
 	memset(irte, 0, sizeof(*irte));
 
@@ -953,135 +900,6 @@ static void prepare_irte(struct irte *irte, int vector,
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
@@ -1135,9 +953,6 @@ struct irq_remap_ops intel_irq_remap_ops = {
 	.disable		= disable_irq_remapping,
 	.reenable		= reenable_irq_remapping,
 	.enable_faulting	= enable_drhd_fault_handling,
-	.setup_ioapic_entry	= intel_setup_ioapic_entry,
-	.set_affinity		= intel_ioapic_set_affinity,
-	.free_irq		= free_irte,
 	.get_ir_irq_domain	= intel_get_ir_irq_domain,
 	.get_irq_domain		= intel_get_irq_domain,
 };
-- 
1.7.10.4

