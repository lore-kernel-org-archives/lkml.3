Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbaKDMCa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 07:02:30 -0500
Received: from mga14.intel.com ([192.55.52.115]:24101 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946AbaKDMCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 07:02:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,313,1413270000"; 
   d="scan'208";a="616766935"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>, x86@kernel.org,
        Joerg Roedel <joro@8bytes.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux-foundation.org
Subject: [Patch Part2 v4 13/31] x86: irq_remapping: Introduce new interfaces to support hierarchy irqdomain
Date: Tue,  4 Nov 2014 20:01:47 +0800
Message-Id: <1415102525-9898-14-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415102525-9898-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415102525-9898-1-git-send-email-jiang.liu@linux.intel.com>
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

Architecture specific needs to implement two hooks:
1) arch_get_ir_parent_domain(): get parent irqdomain for IR irqdomain,
   which is x86_vector_domain on x86 platforms.
2) arch_create_msi_irq_domain(): create an MSI irqdomain associated with
   the interrupt remapping unit.

We also add follwing callbacks into struct irq_remap_ops:
	struct irq_domain *(*get_ir_irq_domain)(struct irq_alloc_info *);
	struct irq_domain *(*get_irq_domain)(struct irq_alloc_info *);

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
 arch/x86/include/asm/hw_irq.h        |   35 +++++++++++++++++++++++++
 arch/x86/include/asm/irq_remapping.h |   39 +++++++++++++++++++++++++++
 drivers/iommu/irq_remapping.c        |   48 +++++++++++++++++++++++++++++++++-
 drivers/iommu/irq_remapping.h        |   10 +++++++
 4 files changed, 131 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 78130156601a..9e91a5d048de 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -113,10 +113,45 @@ struct irq_2_irte {
 #ifdef	CONFIG_X86_LOCAL_APIC
 struct irq_data;
 struct irq_domain;
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
+	enum irq_alloc_type	type;
 	u32			flags;
 	const struct cpumask	*mask;	/* CPU mask for vector allocation */
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
+			irq_hw_number_t	msi_hwirq;
+		};
+#endif
+#ifdef	CONFIG_X86_IO_APIC
+		struct {
+			int		ioapic_id;
+			int		ioapic_pin;
+			u32		ioapic_trigger : 1;
+			u32		ioapic_polarity : 1;
+			struct IO_APIC_route_entry *ioapic_entry;
+		};
+#endif
+	};
 };
 
 /* Request contigious CPU vectors */
diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index 230dde9b695e..d2410ac8cef9 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -22,6 +22,8 @@
 #ifndef __X86_IRQ_REMAPPING_H
 #define __X86_IRQ_REMAPPING_H
 
+#include <linux/irqdomain.h>
+#include <asm/hw_irq.h>
 #include <asm/io_apic.h>
 
 struct IO_APIC_route_entry;
@@ -30,6 +32,7 @@ struct irq_chip;
 struct msi_msg;
 struct pci_dev;
 struct irq_cfg;
+struct irq_alloc_info;
 
 #ifdef CONFIG_IRQ_REMAP
 
@@ -58,6 +61,28 @@ extern bool setup_remapped_irq(int irq,
 
 void irq_remap_modify_chip_defaults(struct irq_chip *chip);
 
+extern struct irq_domain *irq_remapping_get_ir_irq_domain(
+				struct irq_alloc_info *info);
+extern struct irq_domain *irq_remapping_get_irq_domain(
+				struct irq_alloc_info *info);
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
@@ -101,6 +126,20 @@ static inline bool setup_remapped_irq(int irq,
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
+#define	irq_remapping_print_chip	NULL
 #endif /* CONFIG_IRQ_REMAP */
 
 extern int dmar_alloc_hwirq(void);
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 63886bafed9f..176ff4372b7d 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -377,7 +377,7 @@ void panic_if_irq_remap(const char *msg)
 		panic(msg);
 }
 
-static void ir_ack_apic_edge(struct irq_data *data)
+void ir_ack_apic_edge(struct irq_data *data)
 {
 	ack_APIC_irq();
 }
@@ -388,6 +388,19 @@ static void ir_ack_apic_level(struct irq_data *data)
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
@@ -409,3 +422,36 @@ bool setup_remapped_irq(int irq, struct irq_cfg *cfg, struct irq_chip *chip)
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
diff --git a/drivers/iommu/irq_remapping.h b/drivers/iommu/irq_remapping.h
index fde250f86e60..8c159d6fac46 100644
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
@@ -81,11 +83,19 @@ struct irq_remap_ops {
 
 	/* Setup interrupt remapping for an HPET MSI */
 	int (*alloc_hpet_msi)(unsigned int, unsigned int);
+
+	/* Get the irqdomain associated the IOMMU device */
+	struct irq_domain *(*get_ir_irq_domain)(struct irq_alloc_info *);
+
+	/* Get the MSI irqdomain associated with the IOMMU device */
+	struct irq_domain *(*get_irq_domain)(struct irq_alloc_info *);
 };
 
 extern struct irq_remap_ops intel_irq_remap_ops;
 extern struct irq_remap_ops amd_iommu_irq_ops;
 
+extern void ir_ack_apic_edge(struct irq_data *data);
+
 #else  /* CONFIG_IRQ_REMAP */
 
 #define irq_remapping_enabled 0
-- 
1.7.10.4

