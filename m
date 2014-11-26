Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbaKZXIo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:08:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58177 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836AbaKZXIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:08:42 -0500
Date: Wed, 26 Nov 2014 15:07:44 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-924e90f8d1688f7b9b2daf57b0395a1882bb94a8@git.kernel.org>
Cc: rdunlap@infradead.org, tony.luck@intel.com, gregkh@linuxfoundation.org,
        bhelgaas@google.com, jroedel@suse.de, benh@kernel.crashing.org,
        jiang.liu@linux.intel.com, hpa@zytor.com, bp@alien8.de,
        rjw@rjwysocki.net, tglx@linutronix.de, konrad.wilk@oracle.com,
        joro@8bytes.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        yinghai@kernel.org
Reply-To: rdunlap@infradead.org, tony.luck@intel.com,
        gregkh@linuxfoundation.org, bhelgaas@google.com, jroedel@suse.de,
        benh@kernel.crashing.org, hpa@zytor.com, jiang.liu@linux.intel.com,
        bp@alien8.de, rjw@rjwysocki.net, joro@8bytes.org,
        konrad.wilk@oracle.com, tglx@linutronix.de, yinghai@kernel.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org
In-Reply-To: <1416894816-23245-9-git-send-email-jiang.liu@linux.intel.com>
References: <1416894816-23245-9-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86: irq_remapping:
  Introduce new interfaces to support hierarchy irqdomain
Git-Commit-ID: 924e90f8d1688f7b9b2daf57b0395a1882bb94a8
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

Commit-ID:  924e90f8d1688f7b9b2daf57b0395a1882bb94a8
Gitweb:     http://git.kernel.org/tip/924e90f8d1688f7b9b2daf57b0395a1882bb94a8
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 13:53:17 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 18:59:24 +0100

x86: irq_remapping: Introduce new interfaces to support hierarchy irqdomain

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
 arch/x86/include/asm/hw_irq.h        | 37 ++++++++++++++++++++++++++
 arch/x86/include/asm/irq_remapping.h | 36 ++++++++++++++++++++++++++
 drivers/iommu/irq_remapping.c        | 50 +++++++++++++++++++++++++++++++++++-
 drivers/iommu/irq_remapping.h        | 10 ++++++++
 4 files changed, 132 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index eb7692c..bd7881c 100644
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
index 230dde9..3421f10 100644
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
 
@@ -58,6 +61,25 @@ extern bool setup_remapped_irq(int irq,
 
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
 
 static inline void setup_irq_remapping_ops(void) { }
@@ -101,6 +123,20 @@ static inline bool setup_remapped_irq(int irq,
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
index d29a53e..04ea521 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -369,7 +369,7 @@ void panic_if_irq_remap(const char *msg)
 		panic(msg);
 }
 
-static void ir_ack_apic_edge(struct irq_data *data)
+void ir_ack_apic_edge(struct irq_data *data)
 {
 	ack_APIC_irq();
 }
@@ -380,6 +380,19 @@ static void ir_ack_apic_level(struct irq_data *data)
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
@@ -401,3 +414,38 @@ bool setup_remapped_irq(int irq, struct irq_cfg *cfg, struct irq_chip *chip)
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
index fde250f..8c159d6 100644
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
