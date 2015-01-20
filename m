Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbbATDHm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 22:07:42 -0500
Received: from mga02.intel.com ([134.134.136.20]:63974 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbbATDHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 22:07:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="442528571"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Dimitri Sivanich <sivanich@sgi.com>,
        x86@kernel.org, Joerg Roedel <joro@8bytes.org>,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, iommu@lists.linux-foundation.org,
        Joerg Roedel <jroedel@suse.de>
Subject: [Patch Part1 v7 08/38] irq_remapping: Introduce new interfaces to support hierarchy irqdomain
Date: Tue, 20 Jan 2015 11:08:11 +0800
Message-Id: <1421723321-8386-9-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421723321-8386-1-git-send-email-jiang.liu@linux.intel.com>
References: <1421723321-8386-1-git-send-email-jiang.liu@linux.intel.com>
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
   manages the PCI devices. In a further step we will store the irqdomain
   pointer in the device struct to avoid this call in the irq allocation
   path.

Architecture specific needs to implement two hooks:
1) arch_get_ir_parent_domain(): get parent irqdomain for IR irqdomain,
   which is x86_vector_domain on x86 platforms.
2) arch_create_msi_irq_domain(): create an MSI irqdomain associated with
   the interrupt remapping unit.

We also add following callbacks into struct irq_remap_ops:
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
Link: http://lkml.kernel.org/r/1416894816-23245-9-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/hw_irq.h        |   37 +++++++++++++++++++++++++
 arch/x86/include/asm/irq_remapping.h |   36 ++++++++++++++++++++++++
 drivers/iommu/irq_remapping.c        |   50 +++++++++++++++++++++++++++++++++-
 drivers/iommu/irq_remapping.h        |   10 +++++++
 4 files changed, 132 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index eb7692c9ab93..bd7881c5a57a 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -113,10 +113,47 @@ struct irq_2_irte {
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
+			int		ioapic_node;
+			u32		ioapic_trigger : 1;
+			u32		ioapic_polarity : 1;
+			u32		ioapic_valid : 1;
+			struct IO_APIC_route_entry *ioapic_entry;
+		};
+#endif
+	};
 };
 
 enum {
diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index 86d897bc15dd..2031e7abdb25 100644
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
 
@@ -56,6 +59,25 @@ extern bool setup_remapped_irq(int irq,
 
 void irq_remap_modify_chip_defaults(struct irq_chip *chip);
 
+extern struct irq_domain *
+irq_remapping_get_ir_irq_domain( struct irq_alloc_info *info);
+extern struct irq_domain *
+irq_remapping_get_irq_domain(struct irq_alloc_info *info);
+extern void irq_remapping_print_chip(struct irq_data *data, struct seq_file *p);
+
+/* Create PCI MSI/MSIx irqdomain, use @parent as the parent irqdomain. */
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
 
 static inline void set_irq_remapping_broken(void) { }
@@ -97,6 +119,20 @@ static inline bool setup_remapped_irq(int irq,
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
index 5617150fd8fb..c306421d86c1 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -345,7 +345,7 @@ void panic_if_irq_remap(const char *msg)
 		panic(msg);
 }
 
-static void ir_ack_apic_edge(struct irq_data *data)
+void ir_ack_apic_edge(struct irq_data *data)
 {
 	ack_APIC_irq();
 }
@@ -356,6 +356,19 @@ static void ir_ack_apic_level(struct irq_data *data)
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
@@ -377,3 +390,38 @@ bool setup_remapped_irq(int irq, struct irq_cfg *cfg, struct irq_chip *chip)
 	irq_remap_modify_chip_defaults(chip);
 	return true;
 }
+
+/**
+ * irq_remapping_get_ir_irq_domain - Get the irqdomain associated with the IOMMU
+ *				     device serving request @info
+ * @info: interrupt allocation information, used to identify the IOMMU device
+ *
+ * It's used to get parent irqdomain for HPET and IOAPIC irqdomains.
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
+ * irq_remapping_get_irq_domain - Get the irqdomain serving the request @info
+ * @info: interrupt allocation information, used to identify the IOMMU device
+ *
+ * There will be one PCI MSI/MSIX irqdomain associated with each interrupt
+ * remapping device, so this interface is used to retrieve the PCI MSI/MSIX
+ * irqdomain serving request @info.
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
index c448eb48340a..32a3ad30d760 100644
--- a/drivers/iommu/irq_remapping.h
+++ b/drivers/iommu/irq_remapping.h
@@ -30,6 +30,8 @@ struct irq_data;
 struct cpumask;
 struct pci_dev;
 struct msi_msg;
+struct irq_domain;
+struct irq_alloc_info;
 
 extern int irq_remap_broken;
 extern int disable_sourceid_checking;
@@ -77,11 +79,19 @@ struct irq_remap_ops {
 
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

