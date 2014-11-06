Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbaKFOUm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 09:20:42 -0500
Received: from mga14.intel.com ([192.55.52.115]:45273 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947AbaKFOUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 09:20:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,326,1413270000"; 
   d="scan'208";a="618222928"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux-foundation.org
Subject: [Patch Part2 v5 15/31] iommu/vt-d: Enhance Intel IR driver to suppport hierarchy irqdomain
Date: Thu,  6 Nov 2014 22:20:28 +0800
Message-Id: <1415283644-2559-16-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415283644-2559-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415283644-2559-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance Intel interrupt remapping driver to support hierarchy irqdomain,
it will simplify the code eventually. It also implements intel_ir_chip
to support stacked irq_chip.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Acked-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/intel_irq_remapping.c |  349 +++++++++++++++++++++++++++++++++--
 include/linux/intel-iommu.h         |    4 +
 2 files changed, 335 insertions(+), 18 deletions(-)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 5acad492701e..e58b9a594311 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -8,6 +8,7 @@
 #include <linux/irq.h>
 #include <linux/intel-iommu.h>
 #include <linux/acpi.h>
+#include <linux/irqdomain.h>
 #include <asm/io_apic.h>
 #include <asm/smp.h>
 #include <asm/cpu.h>
@@ -31,6 +32,14 @@ struct hpet_scope {
 	unsigned int devfn;
 };
 
+struct intel_ir_data {
+	struct irq_2_iommu			irq_2_iommu;
+	struct irte				irte_entry;
+	union {
+		struct msi_msg			msi_entry;
+	};
+};
+
 #define IR_X2APIC_MODE(mode) (mode ? (1 << 11) : 0)
 #define IRTE_DEST(dest) ((x2apic_mode) ? dest : dest << 8)
 
@@ -50,6 +59,7 @@ static int ir_ioapic_num, ir_hpet_num;
  * the dmar_global_lock.
  */
 static DEFINE_RAW_SPINLOCK(irq_2_ir_lock);
+static struct irq_domain_ops intel_ir_domain_ops;
 
 static int __init parse_ioapics_under_ir(void);
 
@@ -263,7 +273,7 @@ static int free_irte(int irq)
 	unsigned long flags;
 	int rc;
 
-	if (!irq_iommu)
+	if (!irq_iommu || irq_iommu->iommu == NULL)
 		return -1;
 
 	raw_spin_lock_irqsave(&irq_2_ir_lock, flags);
@@ -480,36 +490,47 @@ static int intel_setup_irq_remapping(struct intel_iommu *iommu, int mode)
 	struct page *pages;
 	unsigned long *bitmap;
 
-	ir_table = iommu->ir_table = kzalloc(sizeof(struct ir_table),
-					     GFP_ATOMIC);
-
-	if (!iommu->ir_table)
+	ir_table = kzalloc(sizeof(struct ir_table), GFP_ATOMIC);
+	if (!ir_table)
 		return -ENOMEM;
 
 	pages = alloc_pages_node(iommu->node, GFP_ATOMIC | __GFP_ZERO,
 				 INTR_REMAP_PAGE_ORDER);
-
 	if (!pages) {
 		pr_err("IR%d: failed to allocate pages of order %d\n",
 		       iommu->seq_id, INTR_REMAP_PAGE_ORDER);
-		kfree(iommu->ir_table);
-		return -ENOMEM;
+		goto out_free_table;
 	}
 
 	bitmap = kcalloc(BITS_TO_LONGS(INTR_REMAP_TABLE_ENTRIES),
 			 sizeof(long), GFP_ATOMIC);
 	if (bitmap == NULL) {
 		pr_err("IR%d: failed to allocate bitmap\n", iommu->seq_id);
-		__free_pages(pages, INTR_REMAP_PAGE_ORDER);
-		kfree(ir_table);
-		return -ENOMEM;
+		goto out_free_pages;
+	}
+
+	iommu->ir_domain = irq_domain_add_linear(NULL, INTR_REMAP_TABLE_ENTRIES,
+						 &intel_ir_domain_ops, iommu);
+	if (!iommu->ir_domain) {
+		pr_err("IR%d: failed to allocate irqdomain\n", iommu->seq_id);
+		goto out_free_bitmap;
 	}
+	iommu->ir_domain->parent = arch_get_ir_parent_domain();
+	iommu->ir_msi_domain = arch_create_msi_irq_domain(iommu->ir_domain);
 
 	ir_table->base = page_address(pages);
 	ir_table->bitmap = bitmap;
-
+	iommu->ir_table = ir_table;
 	iommu_set_irq_remapping(iommu, mode);
 	return 0;
+
+out_free_bitmap:
+	kfree(bitmap);
+out_free_pages:
+	__free_pages(pages, INTR_REMAP_PAGE_ORDER);
+out_free_table:
+	kfree(ir_table);
+	return -ENOMEM;
 }
 
 /*
@@ -1013,12 +1034,6 @@ intel_ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	struct irte irte;
 	int err;
 
-	if (!config_enabled(CONFIG_SMP))
-		return -EINVAL;
-
-	if (!cpumask_intersects(mask, cpu_online_mask))
-		return -EINVAL;
-
 	if (get_irte(irq, &irte))
 		return -EBUSY;
 
@@ -1051,6 +1066,7 @@ intel_ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 		send_cleanup_vector(cfg);
 
 	cpumask_copy(data->affinity, mask);
+
 	return 0;
 }
 
@@ -1156,6 +1172,53 @@ static int intel_alloc_hpet_msi(unsigned int irq, unsigned int id)
 	return ret;
 }
 
+static struct irq_domain *intel_get_ir_irq_domain(struct irq_alloc_info *info)
+{
+	struct intel_iommu *iommu = NULL;
+
+	if (!info)
+		return NULL;
+
+	switch (info->type) {
+	case X86_IRQ_ALLOC_TYPE_IOAPIC:
+		iommu = map_ioapic_to_ir(info->ioapic_id);
+		break;
+	case X86_IRQ_ALLOC_TYPE_HPET:
+		iommu = map_hpet_to_ir(info->hpet_id);
+		break;
+	case X86_IRQ_ALLOC_TYPE_MSI:
+	case X86_IRQ_ALLOC_TYPE_MSIX:
+		iommu = map_dev_to_ir(info->msi_dev);
+		break;
+	default:
+		BUG_ON(1);
+		break;
+	}
+
+	return iommu ? iommu->ir_domain : NULL;
+}
+
+static struct irq_domain *intel_get_irq_domain(struct irq_alloc_info *info)
+{
+	struct intel_iommu *iommu;
+
+	if (!info)
+		return NULL;
+
+	switch (info->type) {
+	case X86_IRQ_ALLOC_TYPE_MSI:
+	case X86_IRQ_ALLOC_TYPE_MSIX:
+		iommu = map_dev_to_ir(info->msi_dev);
+		if (iommu)
+			return iommu->ir_msi_domain;
+		break;
+	default:
+		break;
+	}
+
+	return NULL;
+}
+
 struct irq_remap_ops intel_irq_remap_ops = {
 	.supported		= intel_irq_remapping_supported,
 	.prepare		= dmar_table_init,
@@ -1170,4 +1233,254 @@ struct irq_remap_ops intel_irq_remap_ops = {
 	.msi_alloc_irq		= intel_msi_alloc_irq,
 	.msi_setup_irq		= intel_msi_setup_irq,
 	.alloc_hpet_msi		= intel_alloc_hpet_msi,
+	.get_ir_irq_domain	= intel_get_ir_irq_domain,
+	.get_irq_domain		= intel_get_irq_domain,
+};
+
+/*
+ * Migrate the IO-APIC irq in the presence of intr-remapping.
+ *
+ * For both level and edge triggered, irq migration is a simple atomic
+ * update(of vector and cpu destination) of IRTE and flush the hardware cache.
+ *
+ * For level triggered, we eliminate the io-apic RTE modification (with the
+ * updated vector information), by using a virtual vector (io-apic pin number).
+ * Real vector that is used for interrupting cpu will be coming from
+ * the interrupt-remapping table entry.
+ *
+ * As the migration is a simple atomic update of IRTE, the same mechanism
+ * is used to migrate MSI irq's in the presence of interrupt-remapping.
+ */
+static int
+intel_ir_set_affinity(struct irq_data *data, const struct cpumask *mask,
+		      bool force)
+{
+	struct intel_ir_data *ir_data = data->chip_data;
+	struct irte *irte = &ir_data->irte_entry;
+	struct irq_cfg *cfg = irqd_cfg(data);
+	struct irq_data *parent = data->parent_data;
+	int ret;
+
+	ret = parent->chip->irq_set_affinity(parent, mask, force);
+	if (ret < 0 || ret == IRQ_SET_MASK_OK_DONE)
+		return ret;
+
+	/*
+	 * Atomically updates the IRTE with the new destination, vector
+	 * and flushes the interrupt entry cache.
+	 */
+	irte->vector = cfg->vector;
+	irte->dest_id = IRTE_DEST(cfg->dest_apicid);
+	modify_irte(&ir_data->irq_2_iommu, irte);
+
+	/*
+	 * After this point, all the interrupts will start arriving
+	 * at the new destination. So, time to cleanup the previous
+	 * vector allocation.
+	 */
+	if (cfg->move_in_progress)
+		send_cleanup_vector(cfg);
+
+	return IRQ_SET_MASK_OK_DONE;
+}
+
+static void intel_ir_compose_msi_msg(struct irq_data *irq_data,
+				     struct msi_msg *msg)
+{
+	struct intel_ir_data *ir_data = irq_data->chip_data;
+
+	*msg = ir_data->msi_entry;
+}
+
+static struct irq_chip intel_ir_chip = {
+	.irq_ack = ir_ack_apic_edge,
+	.irq_set_affinity = intel_ir_set_affinity,
+	.irq_compose_msi_msg = intel_ir_compose_msi_msg,
+};
+
+static void intel_irq_remapping_prepare_irte(struct intel_ir_data *data,
+					     struct irq_cfg *irq_cfg,
+					     struct irq_alloc_info *info,
+					     int index, int sub_handle)
+{
+	struct IR_IO_APIC_route_entry *entry;
+	struct irte *irte = &data->irte_entry;
+	struct msi_msg *msg = &data->msi_entry;
+
+	prepare_irte(irte, irq_cfg->vector, irq_cfg->dest_apicid);
+	switch (info->type) {
+	case X86_IRQ_ALLOC_TYPE_IOAPIC:
+		/* Set source-id of interrupt request */
+		set_ioapic_sid(irte, info->ioapic_id);
+		apic_printk(APIC_VERBOSE, KERN_DEBUG "IOAPIC[%d]: Set IRTE entry (P:%d FPD:%d Dst_Mode:%d Redir_hint:%d Trig_Mode:%d Dlvry_Mode:%X Avail:%X Vector:%02X Dest:%08X SID:%04X SQ:%X SVT:%X)\n",
+			info->ioapic_id, irte->present, irte->fpd,
+			irte->dst_mode, irte->redir_hint,
+			irte->trigger_mode, irte->dlvry_mode,
+			irte->avail, irte->vector, irte->dest_id,
+			irte->sid, irte->sq, irte->svt);
+
+		entry = (struct IR_IO_APIC_route_entry *)info->ioapic_entry;
+		info->ioapic_entry = NULL;
+		memset(entry, 0, sizeof(*entry));
+		entry->index2	= (index >> 15) & 0x1;
+		entry->zero	= 0;
+		entry->format	= 1;
+		entry->index	= (index & 0x7fff);
+		/*
+		 * IO-APIC RTE will be configured with virtual vector.
+		 * irq handler will do the explicit EOI to the io-apic.
+		 */
+		entry->vector	= info->ioapic_pin;
+		entry->mask	= 0;			/* enable IRQ */
+		entry->trigger	= info->ioapic_trigger;
+		entry->polarity	= info->ioapic_polarity;
+		if (info->ioapic_trigger)
+			entry->mask = 1; /* Mask level triggered irqs. */
+		break;
+
+	case X86_IRQ_ALLOC_TYPE_HPET:
+	case X86_IRQ_ALLOC_TYPE_MSI:
+	case X86_IRQ_ALLOC_TYPE_MSIX:
+		if (info->type == X86_IRQ_ALLOC_TYPE_HPET)
+			set_hpet_sid(irte, info->hpet_id);
+		else
+			set_msi_sid(irte, info->msi_dev);
+
+		msg->address_hi = MSI_ADDR_BASE_HI;
+		msg->data = sub_handle;
+		msg->address_lo = MSI_ADDR_BASE_LO | MSI_ADDR_IR_EXT_INT |
+				  MSI_ADDR_IR_SHV |
+				  MSI_ADDR_IR_INDEX1(index) |
+				  MSI_ADDR_IR_INDEX2(index);
+		break;
+
+	default:
+		BUG_ON(1);
+		break;
+	}
+}
+
+static void intel_free_irq_resources(struct irq_domain *domain,
+				     unsigned int virq, unsigned int nr_irqs)
+{
+	struct irq_data *irq_data;
+	struct intel_ir_data *data;
+	struct irq_2_iommu *irq_iommu;
+	unsigned long flags;
+	int i;
+
+	for (i = 0; i < nr_irqs; i++) {
+		irq_data = irq_domain_get_irq_data(domain, virq  + i);
+		if (irq_data && irq_data->chip_data) {
+			data = irq_data->chip_data;
+			irq_iommu = &data->irq_2_iommu;
+			raw_spin_lock_irqsave(&irq_2_ir_lock, flags);
+			clear_entries(irq_iommu);
+			raw_spin_unlock_irqrestore(&irq_2_ir_lock, flags);
+			irq_domain_reset_irq_data(irq_data);
+			kfree(data);
+		}
+	}
+}
+
+static int intel_irq_remapping_alloc(struct irq_domain *domain,
+				     unsigned int virq, unsigned int nr_irqs,
+				     void *arg)
+{
+	struct intel_iommu *iommu = domain->host_data;
+	struct irq_alloc_info *info = arg;
+	struct intel_ir_data *data;
+	struct irq_data *irq_data;
+	struct irq_cfg *irq_cfg;
+	int i, ret, index;
+
+	if (!info || !iommu)
+		return -EINVAL;
+	if (nr_irqs > 1 && info->type != X86_IRQ_ALLOC_TYPE_MSI &&
+	    info->type != X86_IRQ_ALLOC_TYPE_MSIX)
+		return -EINVAL;
+
+	/*
+	 * With IRQ remapping enabled, don't need contigious CPU vectors
+	 * to support multiple MSI interrupts.
+	 */
+	if (info->type == X86_IRQ_ALLOC_TYPE_MSI)
+		info->flags &= ~X86_IRQ_ALLOC_CONTIGOUS_VECTORS;
+
+	ret = irq_domain_alloc_irqs_parent(domain, virq, nr_irqs, arg);
+	if (ret < 0)
+		return ret;
+
+	ret = -ENOMEM;
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		goto out_free_parent;
+
+	down_read(&dmar_global_lock);
+	index = alloc_irte(iommu, virq, &data->irq_2_iommu, nr_irqs);
+	up_read(&dmar_global_lock);
+	if (index < 0) {
+		pr_warn("Failed to allocate IRTE\n");
+		kfree(data);
+		goto out_free_parent;
+	}
+
+	for (i = 0; i < nr_irqs; i++) {
+		irq_data = irq_domain_get_irq_data(domain, virq + i);
+		irq_cfg = irqd_cfg(irq_data);
+		if (!irq_data || !irq_cfg) {
+			ret = -EINVAL;
+			goto out_free_data;
+		}
+
+		if (i > 0) {
+			data = kzalloc(sizeof(*data), GFP_KERNEL);
+			if (!data)
+				goto out_free_data;
+		}
+		irq_data->hwirq = (index << 16) + i;
+		irq_data->chip_data = data;
+		irq_data->chip = &intel_ir_chip;
+		intel_irq_remapping_prepare_irte(data, irq_cfg, info, index, i);
+		irq_set_status_flags(virq + i, IRQ_MOVE_PCNTXT);
+	}
+	return 0;
+
+out_free_data:
+	intel_free_irq_resources(domain, virq, i);
+out_free_parent:
+	irq_domain_free_irqs_common(domain, virq, nr_irqs);
+	return ret;
+}
+
+static void intel_irq_remapping_free(struct irq_domain *domain,
+				     unsigned int virq, unsigned int nr_irqs)
+{
+	intel_free_irq_resources(domain, virq, nr_irqs);
+	irq_domain_free_irqs_common(domain, virq, nr_irqs);
+}
+
+static void intel_irq_remapping_activate(struct irq_domain *domain,
+					 struct irq_data *irq_data)
+{
+	struct intel_ir_data *data = irq_data->chip_data;
+
+	modify_irte(&data->irq_2_iommu, &data->irte_entry);
+}
+
+static void intel_irq_remapping_deactivate(struct irq_domain *domain,
+					   struct irq_data *irq_data)
+{
+	struct intel_ir_data *data = irq_data->chip_data;
+	struct irte entry;
+
+	memset(&entry, 0, sizeof(entry));
+	modify_irte(&data->irq_2_iommu, &entry);
+}
+
+static struct irq_domain_ops intel_ir_domain_ops = {
+	.alloc = intel_irq_remapping_alloc,
+	.free = intel_irq_remapping_free,
+	.activate = intel_irq_remapping_activate,
+	.deactivate = intel_irq_remapping_deactivate,
 };
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index a65208a8fe18..ecaf3a937845 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -286,6 +286,8 @@ struct q_inval {
 
 #define INTR_REMAP_TABLE_ENTRIES	65536
 
+struct irq_domain;
+
 struct ir_table {
 	struct irte *base;
 	unsigned long *bitmap;
@@ -335,6 +337,8 @@ struct intel_iommu {
 
 #ifdef CONFIG_IRQ_REMAP
 	struct ir_table *ir_table;	/* Interrupt remapping info */
+	struct irq_domain *ir_domain;
+	struct irq_domain *ir_msi_domain;
 #endif
 	struct device	*iommu_dev; /* IOMMU-sysfs device */
 	int		node;
-- 
1.7.10.4

