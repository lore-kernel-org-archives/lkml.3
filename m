Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393AbaIKOCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:02:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:23636 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753915AbaIKOCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:02:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="384739223"
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
Subject: [RFC Part2 v1 13/21] iommu/amd: Enhance AMD IR driver to suppport hierarchy irqdomain
Date: Thu, 11 Sep 2014 22:03:40 +0800
Message-Id: <1410444228-3134-14-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1410444228-3134-1-git-send-email-jiang.liu@linux.intel.com>
References: <1410444228-3134-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance AMD interrupt remapping driver to support hierarchy irqdomain,
it will simplify the code eventually.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/amd_iommu.c       |  338 ++++++++++++++++++++++++++++++++++++++-
 drivers/iommu/amd_iommu_init.c  |    4 +
 drivers/iommu/amd_iommu_proto.h |    9 ++
 drivers/iommu/amd_iommu_types.h |    5 +
 4 files changed, 350 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index e0def6249284..71ab03949599 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -33,6 +33,7 @@
 #include <linux/export.h>
 #include <linux/irq.h>
 #include <linux/msi.h>
+#include <linux/irqdomain.h>
 #include <asm/irq_remapping.h>
 #include <asm/io_apic.h>
 #include <asm/apic.h>
@@ -3835,6 +3836,17 @@ union irte {
 	} fields;
 };
 
+struct amd_ir_data {
+	struct irq_2_irte			irq_2_irte;
+	union irte				irte_entry;
+	union {
+		struct msi_msg			msi_entry;
+		struct IR_IO_APIC_route_entry	ioapic_entry;
+	};
+};
+
+static struct irq_chip amd_ir_chip;
+
 #define DTE_IRQ_PHYS_ADDR_MASK	(((1ULL << 45)-1) << 6)
 #define DTE_IRQ_REMAP_INTCTL    (2ULL << 60)
 #define DTE_IRQ_TABLE_LEN       (8ULL << 1)
@@ -3928,7 +3940,8 @@ out_unlock:
 	return table;
 }
 
-static int alloc_irq_index(struct irq_cfg *cfg, u16 devid, int count)
+static int alloc_irq_index(struct irq_cfg *cfg, struct irq_2_irte *irte_info,
+			   u16 devid, int count)
 {
 	struct irq_remap_table *table;
 	unsigned long flags;
@@ -3950,15 +3963,12 @@ static int alloc_irq_index(struct irq_cfg *cfg, u16 devid, int count)
 			c = 0;
 
 		if (c == count)	{
-			struct irq_2_irte *irte_info;
-
 			for (; c != 0; --c)
 				table->table[index - c + 1] = IRTE_ALLOCATED;
 
 			index -= count - 1;
 
 			cfg->remapped	      = 1;
-			irte_info             = &cfg->irq_2_irte;
 			irte_info->devid      = devid;
 			irte_info->index      = index;
 
@@ -4203,7 +4213,7 @@ static int msi_alloc_irq(struct pci_dev *pdev, int irq, int nvec)
 		return -EINVAL;
 
 	devid = get_device_id(&pdev->dev);
-	index = alloc_irq_index(cfg, devid, nvec);
+	index = alloc_irq_index(cfg, &cfg->irq_2_irte, devid, nvec);
 
 	return index < 0 ? MAX_IRQS_PER_TABLE : index;
 }
@@ -4250,7 +4260,7 @@ static int setup_hpet_msi(unsigned int irq, unsigned int id)
 	if (devid < 0)
 		return devid;
 
-	index = alloc_irq_index(cfg, devid, 1);
+	index = alloc_irq_index(cfg, &cfg->irq_2_irte, devid, 1);
 	if (index < 0)
 		return index;
 
@@ -4261,6 +4271,88 @@ static int setup_hpet_msi(unsigned int irq, unsigned int id)
 	return 0;
 }
 
+static int get_devid(struct irq_alloc_info *info)
+{
+	int devid = -1;
+
+	switch (info->type) {
+	case X86_IRQ_ALLOC_TYPE_IOAPIC:
+		devid     = get_ioapic_devid(info->ioapic_id);
+		break;
+	case X86_IRQ_ALLOC_TYPE_HPET:
+		devid     = get_hpet_devid(info->hpet_id);
+		break;
+	case X86_IRQ_ALLOC_TYPE_MSI:
+	case X86_IRQ_ALLOC_TYPE_MSIX:
+		devid = get_device_id(&info->msi_dev->dev);
+		break;
+	}
+
+	return devid;
+}
+
+static struct irq_domain *get_ir_irq_domain(struct irq_alloc_info *info)
+{
+	int devid;
+	struct amd_iommu *iommu;
+
+	if (!info)
+		return NULL;
+
+	devid = get_devid(info);
+	if (devid >= 0) {
+		iommu = amd_iommu_rlookup_table[devid];
+		if (iommu)
+			return iommu->ir_domain;
+	}
+
+	return NULL;
+}
+
+static struct irq_domain *get_irq_domain(struct irq_alloc_info *info)
+{
+	int devid;
+	struct amd_iommu *iommu;
+
+	if (!info)
+		return NULL;
+
+	switch (info->type) {
+	case X86_IRQ_ALLOC_TYPE_MSI:
+	case X86_IRQ_ALLOC_TYPE_MSIX:
+		devid = get_device_id(&info->msi_dev->dev);
+		if (devid >= 0) {
+			iommu = amd_iommu_rlookup_table[devid];
+			if (iommu)
+				return iommu->msi_domain;
+		}
+		break;
+	default:
+		break;
+	}
+
+	return NULL;
+}
+
+static int get_ioapic_entry(struct irq_data *irq_data,
+				  struct IR_IO_APIC_route_entry *entry)
+{
+	struct amd_ir_data *ir_data = irq_data->chip_data;
+
+	*entry = ir_data->ioapic_entry;
+
+	return 0;
+}
+
+static int get_msi_entry(struct irq_data *irq_data, struct msi_msg *msg)
+{
+	struct amd_ir_data *ir_data = irq_data->chip_data;
+
+	*msg = ir_data->msi_entry;
+
+	return 0;
+}
+
 struct irq_remap_ops amd_iommu_irq_ops = {
 	.supported		= amd_iommu_supported,
 	.prepare		= amd_iommu_prepare,
@@ -4275,5 +4367,239 @@ struct irq_remap_ops amd_iommu_irq_ops = {
 	.msi_alloc_irq		= msi_alloc_irq,
 	.msi_setup_irq		= msi_setup_irq,
 	.setup_hpet_msi		= setup_hpet_msi,
+	.get_ir_irq_domain	= get_ir_irq_domain,
+	.get_irq_domain		= get_irq_domain,
+	.get_ioapic_entry	= get_ioapic_entry,
+	.get_msi_entry		= get_msi_entry,
 };
+
+static void irq_remapping_prepare_irte(struct amd_ir_data *data,
+				       struct irq_cfg *irq_cfg,
+				       struct irq_alloc_info *info,
+				       int devid, int index, int sub_handle)
+{
+	union irte *irte = &data->irte_entry;
+	struct irq_2_irte *irte_info = &data->irq_2_irte;
+	struct IR_IO_APIC_route_entry *entry = &data->ioapic_entry;
+	struct msi_msg *msg = &data->msi_entry;
+
+	irq_cfg->remapped = 1;
+	data->irq_2_irte.devid = devid;
+	data->irq_2_irte.index = index + sub_handle;
+
+	/* Setup IRTE for IOMMU */
+	irte->val = 0;
+	irte->fields.vector      = irq_cfg->vector;
+	irte->fields.int_type    = apic->irq_delivery_mode;
+	irte->fields.destination = irq_cfg->dest_apicid;
+	irte->fields.dm          = apic->irq_dest_mode;
+	irte->fields.valid       = 1;
+
+	switch (info->type) {
+	case X86_IRQ_ALLOC_TYPE_IOAPIC:
+		/* Setup IOAPIC entry */
+		memset(entry, 0, sizeof(*entry));
+		entry->vector        = index;
+		entry->mask          = 0;
+		entry->trigger       = info->ioapic_trigger;
+		entry->polarity      = info->ioapic_polarity;
+		/* Mask level triggered irqs. */
+		if (info->ioapic_trigger)
+			entry->mask = 1;
+		break;
+
+	case X86_IRQ_ALLOC_TYPE_HPET:
+	case X86_IRQ_ALLOC_TYPE_MSI:
+	case X86_IRQ_ALLOC_TYPE_MSIX:
+		msg->address_hi = MSI_ADDR_BASE_HI;
+		msg->address_lo = MSI_ADDR_BASE_LO;
+		msg->data = irte_info->index;
+		break;
+
+	default:
+		BUG_ON(1);
+		break;
+	}
+}
+
+static int irq_remapping_alloc(struct irq_domain *domain, unsigned int virq,
+			       unsigned int nr_irqs, void *arg)
+{
+	struct irq_alloc_info *info = arg;
+	struct amd_ir_data *data;
+	struct irq_data *irq_data;
+	struct irq_cfg *cfg;
+	int i, ret, devid;
+	int index = -1;
+
+	if (!info)
+		return -EINVAL;
+	if (nr_irqs > 1 && info->type != X86_IRQ_ALLOC_TYPE_MSI &&
+	    info->type != X86_IRQ_ALLOC_TYPE_MSIX)
+		return -EINVAL;
+
+	devid = get_devid(info);
+	if (devid < 0)
+		return -EINVAL;
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
+	if (info->type == X86_IRQ_ALLOC_TYPE_IOAPIC) {
+		if (get_irq_table(devid, true))
+			index = info->ioapic_pin;
+		else
+			ret = -ENOMEM;
+	} else {
+		cfg = irq_cfg(virq);
+		index = alloc_irq_index(cfg, &data->irq_2_irte, devid, nr_irqs);
+	}
+	if (index < 0) {
+		pr_warn("Failed to allocate IRTE\n");
+		kfree(data);
+		goto out_free_parent;
+	}
+
+	for (i = 0; i < nr_irqs; i++) {
+		irq_data = irq_domain_get_irq_data(domain, virq + i);
+		cfg = irqd_cfg(irq_data);
+		if (!irq_data || !cfg) {
+			ret = -EINVAL;
+			goto out_free_data;
+		}
+
+		if (i > 0) {
+			data = kzalloc(sizeof(*data), GFP_KERNEL);
+			if (!data)
+				goto out_free_data;
+		}
+		irq_data->hwirq = (devid << 16) + i;
+		irq_data->chip_data = data;
+		irq_data->chip = &amd_ir_chip;
+		irq_remapping_prepare_irte(data, cfg, info, devid, index, i);
+		irq_set_status_flags(virq + i, IRQ_MOVE_PCNTXT);
+	}
+	return 0;
+
+out_free_data:
+	for (i--; i >= 0; i--) {
+		irq_data = irq_domain_get_irq_data(domain, virq + i);
+		if (irq_data->chip_data) {
+			kfree(irq_data->chip_data);
+			irq_domain_reset_irq_data(irq_data);
+		}
+	}
+	for (i = 0; i < nr_irqs; i++)
+		free_irte(devid, index + i);
+out_free_parent:
+	irq_domain_free_irqs_parent(domain, virq, nr_irqs);
+	return ret;
+}
+
+static void irq_remapping_free(struct irq_domain *domain, unsigned int virq,
+			       unsigned int nr_irqs)
+{
+	struct irq_data *irq_data;
+	struct amd_ir_data *data;
+	struct irq_2_irte *irte_info;
+	int i;
+
+	for (i = 0; i < nr_irqs; i++) {
+		irq_data = irq_domain_get_irq_data(domain, virq  + i);
+		if (irq_data && irq_data->chip_data) {
+			data = irq_data->chip_data;
+			irte_info = &data->irq_2_irte;
+			free_irte(irte_info->devid, irte_info->index);
+			irq_domain_reset_irq_data(irq_data);
+			kfree(data);
+		}
+	}
+	irq_domain_free_irqs_parent(domain, virq, nr_irqs);
+}
+
+static int irq_remapping_activate(struct irq_domain *domain,
+				  struct irq_data *irq_data)
+{
+	struct amd_ir_data *data = irq_data->chip_data;
+	struct irq_2_irte *irte_info = &data->irq_2_irte;
+
+	modify_irte(irte_info->devid, irte_info->index, data->irte_entry);
+
+	return 0;
+}
+
+static int irq_remapping_deactivate(struct irq_domain *domain,
+				    struct irq_data *irq_data)
+{
+	struct amd_ir_data *data = irq_data->chip_data;
+	struct irq_2_irte *irte_info = &data->irq_2_irte;
+	union irte entry;
+
+	entry.val = 0;
+	modify_irte(irte_info->devid, irte_info->index, data->irte_entry);
+
+	return 0;
+}
+
+static struct irq_domain_ops amd_ir_domain_ops = {
+	.alloc = irq_remapping_alloc,
+	.free = irq_remapping_free,
+	.activate = irq_remapping_activate,
+	.deactivate = irq_remapping_deactivate,
+};
+
+static int amd_ir_set_affinity(struct irq_data *data,
+			       const struct cpumask *mask, bool force)
+{
+	struct amd_ir_data *ir_data = data->chip_data;
+	struct irq_2_irte *irte_info = &ir_data->irq_2_irte;
+	struct irq_cfg *cfg = irqd_cfg(data);
+	struct irq_data *parent = data->parent_data;
+	int ret;
+
+	ret = parent->chip->irq_set_affinity(parent, mask, force);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * Atomically updates the IRTE with the new destination, vector
+	 * and flushes the interrupt entry cache.
+	 */
+	ir_data->irte_entry.fields.vector = cfg->vector;
+	ir_data->irte_entry.fields.destination = cfg->dest_apicid;
+	modify_irte(irte_info->devid, irte_info->index, ir_data->irte_entry);
+
+	/*
+	 * After this point, all the interrupts will start arriving
+	 * at the new destination. So, time to cleanup the previous
+	 * vector allocation.
+	 */
+	if (cfg->move_in_progress)
+		send_cleanup_vector(cfg);
+
+	return ret;
+}
+
+static struct irq_chip amd_ir_chip = {
+	.irq_ack = ir_ack_apic_edge,
+	.irq_set_affinity = amd_ir_set_affinity,
+};
+
+int amd_iommu_create_irq_domain(struct amd_iommu *iommu)
+{
+	iommu->ir_domain = irq_domain_add_tree(NULL, &amd_ir_domain_ops, iommu);
+	if (!iommu->ir_domain)
+		return -ENOMEM;
+
+	iommu->ir_domain->parent = arch_get_ir_parent_domain();
+	iommu->msi_domain = arch_create_msi_irq_domain(iommu->ir_domain);
+
+	return 0;
+}
 #endif
diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 3783e0b44df6..e9b3b91d45ff 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1115,6 +1115,10 @@ static int __init init_iommu_one(struct amd_iommu *iommu, struct ivhd_header *h)
 	if (ret)
 		return ret;
 
+	ret = amd_iommu_create_irq_domain(iommu);
+	if (ret)
+		return ret;
+
 	/*
 	 * Make sure IOMMU is not considered to translate itself. The IVRS
 	 * table tells us so, but this is a lie!
diff --git a/drivers/iommu/amd_iommu_proto.h b/drivers/iommu/amd_iommu_proto.h
index 95ed6deae47f..612a22192fa0 100644
--- a/drivers/iommu/amd_iommu_proto.h
+++ b/drivers/iommu/amd_iommu_proto.h
@@ -63,6 +63,15 @@ extern u8 amd_iommu_pc_get_max_counters(u16 devid);
 extern int amd_iommu_pc_get_set_reg_val(u16 devid, u8 bank, u8 cntr, u8 fxn,
 				    u64 *value, bool is_write);
 
+#ifdef CONFIG_IRQ_REMAP
+extern int amd_iommu_create_irq_domain(struct amd_iommu *iommu);
+#else
+static inline int amd_iommu_create_irq_domain(struct amd_iommu *iommu)
+{
+	return 0;
+}
+#endif
+
 #define PPR_SUCCESS			0x0
 #define PPR_INVALID			0x1
 #define PPR_FAILURE			0xf
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index 8e43b7cba133..ccb84d7491ed 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -392,6 +392,7 @@ struct amd_iommu_fault {
 
 
 struct iommu_domain;
+struct irq_domain;
 
 /*
  * This structure contains generic data for  IOMMU protection domains
@@ -595,6 +596,10 @@ struct amd_iommu {
 	/* The maximum PC banks and counters/bank (PCSup=1) */
 	u8 max_banks;
 	u8 max_counters;
+#ifdef CONFIG_IRQ_REMAP
+	struct irq_domain *ir_domain;
+	struct irq_domain *msi_domain;
+#endif
 };
 
 struct devid_map {
-- 
1.7.10.4

