Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751065AbaIKODE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:03:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:39913 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754809AbaIKOC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:02:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="384739008"
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
Subject: [RFC Part2 v1 10/21] x86: irq_remapping: Introduce new interfaces to support hierarchy irqdomain
Date: Thu, 11 Sep 2014 22:03:37 +0800
Message-Id: <1410444228-3134-11-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1410444228-3134-1-git-send-email-jiang.liu@linux.intel.com>
References: <1410444228-3134-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce new interfaces for interrupt remapping drivers to support
hierarchy irqdomain:
1) irq_remapping_get_ir_irq_domain(): get irqdomain associated with an
   interrupt remapping unit. IOAPIC/HPET drivers use this interface to
   get parent interrupt remapping irqdomain.
2) irq_remapping_get_irq_domain(): get irqdomain for an IRQ allocation.
   This is mainly used to support MSI irqdomain. We must build one MSI
   irqdomain for each interrupt remapping unit. MSI driver calls this
   interface to get MSI irqdomain associated with an IR irqdomain which
   manages the PCI devices.
3) irq_remapping_get_ioapic_entry(): get IOAPIC entry content rewritten
   by the interrupt remapping driver for remapped IOAPIC interrupt.
4) irq_remapping_get_msi_entry(): get MSI/HPET entry content rewritten
   by the interrupt remapping driver for remapped MSI/HPET interrupt.

Architecture specific needs to implement two hooks:
1) arch_get_ir_parent_domain(): get parent irqdomain for IR irqdomain,
   which is x86_vector_domain on x86 platforms.
2) arch_create_msi_irq_domain(): create an MSI irqdomain associated with
   the interrupt remapping unit.

We also add follwing callbacks into struct irq_remap_ops:
	struct irq_domain *(*get_ir_irq_domain)(struct irq_alloc_info *);
	struct irq_domain *(*get_irq_domain)(struct irq_alloc_info *);
	int (*get_ioapic_entry)(struct irq_data *,
				struct IR_IO_APIC_route_entry *);
	int (*get_msi_entry)(struct irq_data *, struct msi_msg *);

Once all clients of IR have been converted to new hierarchy irqdomain
interfaces, we will:
1) Remove set_ioapic_entry, set_affinity, free_irq, compose_msi_msg,
   msi_alloc_irq, msi_setup_irq, setup_hpet_msi from struct remap_osp
2) Kill setup_ioapic_remapped_entry, free_remapped_irq,
   compose_remapped_msi_msg, setup_hpet_msi_remapped, setup_remapped_irq.
3) Simplify x86_io_apic_ops and x86_msi.

We could achieve a much more clear architecture with all these changes
applied.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/hw_irq.h        |   36 +++++++++++++++-
 arch/x86/include/asm/irq_remapping.h |   53 +++++++++++++++++++++++
 drivers/iommu/irq_remapping.c        |   78 +++++++++++++++++++++++++++++++++-
 drivers/iommu/irq_remapping.h        |   17 ++++++++
 4 files changed, 182 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 313ae21a0784..57f81f5a9686 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -112,9 +112,43 @@ struct irq_2_irte {
 
 #ifdef	CONFIG_X86_LOCAL_APIC
 struct irq_data;
+struct pci_dev;
+struct msi_desc;
+
+enum irq_alloc_type {
+	X86_IRQ_ALLOC_TYPE_IOAPIC = 1,
+	X86_IRQ_ALLOC_TYPE_HPET,
+	X86_IRQ_ALLOC_TYPE_MSI,
+	X86_IRQ_ALLOC_TYPE_MSIX,
+};
 
 struct irq_alloc_info {
-	const struct cpumask *mask;	/* CPU mask for vector allocation */
+	const struct cpumask	*mask;	/* CPU mask for vector allocation */
+	enum irq_alloc_type	type;
+	union {
+		int		unused;
+#ifdef	CONFIG_HPET_TIMER
+		struct {
+			int		hpet_id;
+			int		hpet_index;
+			void		*hpet_data;
+		};
+#endif
+#ifdef	CONFIG_PCI_MSI
+		struct {
+			struct pci_dev	*msi_dev;
+			struct msi_desc *msi_desc;
+		};
+#endif
+#ifdef	CONFIG_X86_IO_APIC
+		struct {
+			int		ioapic_id;
+			int		ioapic_pin;
+			u32		ioapic_trigger : 1;
+			u32		ioapic_polarity : 1;
+		};
+#endif
+	};
 };
 
 struct irq_cfg {
diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index 230dde9b695e..428b4e6d637c 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -30,6 +30,7 @@ struct irq_chip;
 struct msi_msg;
 struct pci_dev;
 struct irq_cfg;
+struct irq_alloc_info;
 
 #ifdef CONFIG_IRQ_REMAP
 
@@ -58,6 +59,32 @@ extern bool setup_remapped_irq(int irq,
 
 void irq_remap_modify_chip_defaults(struct irq_chip *chip);
 
+extern struct irq_domain *irq_remapping_get_ir_irq_domain(
+				struct irq_alloc_info *info);
+extern struct irq_domain *irq_remapping_get_irq_domain(
+				struct irq_alloc_info *info);
+extern int irq_remapping_get_ioapic_entry(struct irq_data *irq_data,
+					  struct IR_IO_APIC_route_entry *entry);
+extern int irq_remapping_get_msi_entry(struct irq_data *irq_data,
+				       struct msi_msg *entry);
+extern void irq_remapping_print_chip(struct irq_data *data, struct seq_file *p);
+
+/*
+ * Create MSI/MSIx irqdomain for interrupt remapping device, use @parent as
+ * parent irqdomain.
+ */
+static inline struct irq_domain *
+arch_create_msi_irq_domain(struct irq_domain *parent)
+{
+	return NULL;
+}
+
+/* Get parent irqdomain for interrupt remapping irqdomain */
+static inline struct irq_domain *arch_get_ir_parent_domain(void)
+{
+	return x86_vector_domain;
+}
+
 #else  /* CONFIG_IRQ_REMAP */
 
 static inline void setup_irq_remapping_ops(void) { }
@@ -101,6 +128,32 @@ static inline bool setup_remapped_irq(int irq,
 {
 	return false;
 }
+
+static inline struct irq_domain *
+irq_remapping_get_ir_irq_domain(struct irq_alloc_info *info)
+{
+	return NULL;
+}
+
+static inline struct irq_domain *
+irq_remapping_get_irq_domain(struct irq_alloc_info *info)
+{
+	return NULL;
+}
+
+static inline int irq_remapping_get_ioapic_entry(struct irq_data *irq_data,
+				struct IR_IO_APIC_route_entry *entry)
+{
+	return -ENOSYS;
+}
+
+static inline int irq_remapping_get_msi_entry(struct irq_data *irq_data,
+					      struct msi_msg *entry)
+{
+	return -ENOSYS;
+}
+
+#define	irq_remapping_print_chip	NULL
 #endif /* CONFIG_IRQ_REMAP */
 
 extern int dmar_alloc_hwirq(void);
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 7dd893ee70be..7ac44a464be0 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -370,7 +370,7 @@ void panic_if_irq_remap(const char *msg)
 		panic(msg);
 }
 
-static void ir_ack_apic_edge(struct irq_data *data)
+void ir_ack_apic_edge(struct irq_data *data)
 {
 	ack_APIC_irq();
 }
@@ -381,6 +381,19 @@ static void ir_ack_apic_level(struct irq_data *data)
 	eoi_ioapic_irq(data->irq, irqd_cfg(data));
 }
 
+void irq_remapping_print_chip(struct irq_data *data, struct seq_file *p)
+{
+	/*
+	 * Assume interrupt is remapped if the parent irqdomain isn't the
+	 * vector domain, which is true for MSI, HPET and IOAPIC on x86
+	 * platforms.
+	 */
+	if (data->domain && data->domain->parent != arch_get_ir_parent_domain())
+		seq_printf(p, " IR-%s", data->chip->name);
+	else
+		seq_printf(p, " %s", data->chip->name);
+}
+
 static void ir_print_prefix(struct irq_data *data, struct seq_file *p)
 {
 	seq_printf(p, " IR-%s", data->chip->name);
@@ -402,3 +415,66 @@ bool setup_remapped_irq(int irq, struct irq_cfg *cfg, struct irq_chip *chip)
 	irq_remap_modify_chip_defaults(chip);
 	return true;
 }
+
+/**
+ * irq_remapping_get_ir_irq_domain - Get the irqdomain associated the IOMMU
+ *				     device serving @info
+ * @info: interrupt allocation information, used to find the IOMMU device
+ *
+ * It's used to get parent irqdomain for HPET and IOAPIC domains.
+ * Returns pointer to IRQ domain, or NULL on failure.
+ */
+struct irq_domain *
+irq_remapping_get_ir_irq_domain(struct irq_alloc_info *info)
+{
+	if (!remap_ops || !remap_ops->get_ir_irq_domain)
+		return NULL;
+
+	return remap_ops->get_ir_irq_domain(info);
+}
+
+/**
+ * irq_remapping_get_irq_domain - Get the irqdomain serving the MSI interrupt
+ * @info: interrupt allocation information, used to find the IOMMU device
+ *
+ * It's used to get irqdomain for MSI/MSIx interrupt allocation.
+ * Returns pointer to IRQ domain, or NULL on failure.
+ */
+struct irq_domain *
+irq_remapping_get_irq_domain(struct irq_alloc_info *info)
+{
+	if (!remap_ops || !remap_ops->get_irq_domain)
+		return NULL;
+
+	return remap_ops->get_irq_domain(info);
+}
+
+/**
+ * irq_remapping_get_ioapic_entry - Get IOAPIC entry content rewritten by
+ *				    interrupt remapping driver
+ * @irq_data: irq_data associated with interrupt remapping irqdomain
+ * @entry: host returned data
+ *
+ * Caller must make sure that the interrupt is remapped.
+ * Return 0 on success, otherwise return error code
+ */
+int irq_remapping_get_ioapic_entry(struct irq_data *irq_data,
+				   struct IR_IO_APIC_route_entry *entry)
+{
+	return remap_ops->get_ioapic_entry(irq_data, entry);
+}
+
+/**
+ * irq_remapping_get_ioapic_entry - Get MSI data rewritten by interrupt
+ *				    remapping driver
+ * @irq_data: irq_data associated with interrupt remapping irqdomain
+ * @entry: host returned data
+ *
+ * Caller must make sure that the interrupt is remapped.
+ * Return 0 on success, otherwise return error code
+ */
+int irq_remapping_get_msi_entry(struct irq_data *irq_data,
+				struct msi_msg *entry)
+{
+	return remap_ops->get_msi_entry(irq_data, entry);
+}
diff --git a/drivers/iommu/irq_remapping.h b/drivers/iommu/irq_remapping.h
index 90c4dae5a46b..6e46074f06d0 100644
--- a/drivers/iommu/irq_remapping.h
+++ b/drivers/iommu/irq_remapping.h
@@ -30,6 +30,8 @@ struct irq_data;
 struct cpumask;
 struct pci_dev;
 struct msi_msg;
+struct irq_domain;
+struct irq_alloc_info;
 
 extern int disable_irq_remap;
 extern int irq_remap_broken;
@@ -81,11 +83,26 @@ struct irq_remap_ops {
 
 	/* Setup interrupt remapping for an HPET MSI */
 	int (*setup_hpet_msi)(unsigned int, unsigned int);
+
+	/* Get the irqdomain associated the IOMMU device */
+	struct irq_domain *(*get_ir_irq_domain)(struct irq_alloc_info *);
+
+	/* Get the MSI irqdomain associated with the IOMMU device */
+	struct irq_domain *(*get_irq_domain)(struct irq_alloc_info *);
+
+	/* Get IOAPIC entry content rewritten by interrupt remapping driver */
+	int (*get_ioapic_entry)(struct irq_data *,
+				struct IR_IO_APIC_route_entry *);
+
+	/*  Get MSI data rewritten by interrupt remapping driver */
+	int (*get_msi_entry)(struct irq_data *, struct msi_msg *);
 };
 
 extern struct irq_remap_ops intel_irq_remap_ops;
 extern struct irq_remap_ops amd_iommu_irq_ops;
 
+extern void ir_ack_apic_edge(struct irq_data *data);
+
 #else  /* CONFIG_IRQ_REMAP */
 
 #define irq_remapping_enabled 0
-- 
1.7.10.4

