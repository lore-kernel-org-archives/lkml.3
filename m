Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab3HKCrW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 22:47:22 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:25526 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab3HKCqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 22:46:11 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 05/28] x86, irq: Modify irq chip once for irq remapping
Date: Sat, 10 Aug 2013 19:45:16 -0700
Message-Id: <1376189139-31856-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1376189139-31856-1-git-send-email-yinghai@kernel.org>
References: <1376189139-31856-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code: after irq remapping is enabled, irq_chip fields are modified
during every irq setup.
	mp_register_gsi
		io_apic_set_pci_routing
			io_apic_setup_irq_pin
				setup_ioapic_irq
					ioapic_register_intr
						setup_remapped_irq
	native_setup_msi_irqs
		setup_msi_irq
			setup_remapped_irq
	default_setup_hpet_msi
		setup_remapped_irq
that is not efficient.

We only need to modify those irq chip one time after we enable
irq remapping.

Change irq_remap_modify_chip_defaults() to __init as it only gets
called during booting stage, via irq_remap_modify_chips().

Affected irq_chip: ioapic_chip, msi_chip, hpet_msi_type.
We don't need to use #ifdef in irq_remap_modify_chips():
IRQ_REMAP only support x86_64 && X86_IO_APIC && PCI_MSI.
HPET_TIMER is selected when x86_64 is set.
When we have IRQ_REMAP enabled, al three chips are defined and
used.

-v3: Remove irq_chip in setup_remapped_irq according to Sebastian.
     also add missing "\n" in printk.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Joerg Roedel <joro@8bytes.org>
---
 arch/x86/include/asm/io_apic.h       |  5 +++++
 arch/x86/include/asm/irq_remapping.h |  8 ++------
 arch/x86/kernel/apic/apic.c          |  9 ++++++++-
 arch/x86/kernel/apic/io_apic.c       | 14 ++++++--------
 drivers/iommu/irq_remapping.c        | 13 ++++++++++---
 5 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 459e50a..eaff3ad 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -215,6 +215,11 @@ static inline void io_apic_modify(unsigned int apic, unsigned int reg, unsigned
 
 extern void io_apic_eoi(unsigned int apic, unsigned int vector);
 
+extern struct irq_chip ioapic_chip;
+extern struct irq_chip msi_chip;
+extern struct irq_chip hpet_msi_type;
+void irq_remap_modify_chips(void);
+
 #else  /* !CONFIG_X86_IO_APIC */
 
 #define io_apic_assign_pci_irqs 0
diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index 606f42e..304c93f 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -52,9 +52,7 @@ extern void compose_remapped_msi_msg(struct pci_dev *pdev,
 				     struct msi_msg *msg, u8 hpet_id);
 extern int setup_hpet_msi_remapped(unsigned int irq, unsigned int id);
 extern void panic_if_irq_remap(const char *msg);
-extern bool setup_remapped_irq(int irq,
-			       struct irq_cfg *cfg,
-			       struct irq_chip *chip);
+extern bool setup_remapped_irq(int irq, struct irq_cfg *cfg);
 
 #else  /* CONFIG_IRQ_REMAP */
 
@@ -89,9 +87,7 @@ static inline void panic_if_irq_remap(const char *msg)
 {
 }
 
-static inline bool setup_remapped_irq(int irq,
-				      struct irq_cfg *cfg,
-				      struct irq_chip *chip)
+static inline bool setup_remapped_irq(int irq, struct irq_cfg *cfg)
 {
 	return false;
 }
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index eca89c5..9b64203 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1571,6 +1571,8 @@ void enable_x2apic(void)
 int __init enable_IR(void)
 {
 #ifdef CONFIG_IRQ_REMAP
+	int ret;
+
 	if (!irq_remapping_supported()) {
 		pr_debug("intr-remapping not supported\n");
 		return -1;
@@ -1582,7 +1584,12 @@ int __init enable_IR(void)
 		return -1;
 	}
 
-	return irq_remapping_enable();
+	ret = irq_remapping_enable();
+
+	if (ret >= 0)
+		irq_remap_modify_chips();
+
+	return ret;
 #endif
 	return -1;
 }
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 9ed796c..eda56ad 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1238,8 +1238,6 @@ void __setup_vector_irq(int cpu)
 	raw_spin_unlock(&vector_lock);
 }
 
-static struct irq_chip ioapic_chip;
-
 #ifdef CONFIG_X86_32
 static inline int IO_APIC_irq_trigger(int irq)
 {
@@ -1280,7 +1278,7 @@ static void ioapic_register_intr(unsigned int irq, struct irq_cfg *cfg,
 		fasteoi = false;
 	}
 
-	if (setup_remapped_irq(irq, cfg, chip))
+	if (setup_remapped_irq(irq, cfg))
 		fasteoi = trigger != 0;
 
 	hdl = fasteoi ? handle_fasteoi_irq : handle_edge_irq;
@@ -2511,7 +2509,7 @@ static void ack_apic_level(struct irq_data *data)
 	ioapic_irqd_unmask(data, cfg, masked);
 }
 
-static struct irq_chip ioapic_chip __read_mostly = {
+struct irq_chip ioapic_chip __read_mostly = {
 	.name			= "IO-APIC",
 	.irq_startup		= startup_ioapic_irq,
 	.irq_mask		= mask_ioapic_irq,
@@ -3093,7 +3091,7 @@ msi_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
  * IRQ Chip for MSI PCI/PCI-X/PCI-Express Devices,
  * which implement the MSI or MSI-X Capability Structure.
  */
-static struct irq_chip msi_chip = {
+struct irq_chip msi_chip = {
 	.name			= "PCI-MSI",
 	.irq_unmask		= unmask_msi_irq,
 	.irq_mask		= mask_msi_irq,
@@ -3123,7 +3121,7 @@ int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc,
 	if (!irq_offset)
 		write_msi_msg(irq, &msg);
 
-	setup_remapped_irq(irq, irq_get_chip_data(irq), chip);
+	setup_remapped_irq(irq, irq_get_chip_data(irq));
 
 	irq_set_chip_and_handler_name(irq, chip, handle_edge_irq, "edge");
 
@@ -3240,7 +3238,7 @@ static int hpet_msi_set_affinity(struct irq_data *data,
 	return IRQ_SET_MASK_OK_NOCOPY;
 }
 
-static struct irq_chip hpet_msi_type = {
+struct irq_chip hpet_msi_type = {
 	.name = "HPET_MSI",
 	.irq_unmask = hpet_msi_unmask,
 	.irq_mask = hpet_msi_mask,
@@ -3261,7 +3259,7 @@ int default_setup_hpet_msi(unsigned int irq, unsigned int id)
 
 	hpet_msi_write(irq_get_handler_data(irq), &msg);
 	irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
-	setup_remapped_irq(irq, irq_get_chip_data(irq), chip);
+	setup_remapped_irq(irq, irq_get_chip_data(irq));
 
 	irq_set_chip_and_handler_name(irq, chip, handle_edge_irq, "edge");
 	return 0;
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 85ae2cf..8e4e3af 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -375,19 +375,26 @@ static void ir_print_prefix(struct irq_data *data, struct seq_file *p)
 	seq_printf(p, " IR-%s", data->chip->name);
 }
 
-static void irq_remap_modify_chip_defaults(struct irq_chip *chip)
+static void __init irq_remap_modify_chip_defaults(struct irq_chip *chip)
 {
+	printk(KERN_DEBUG "irq_chip: %s ==> IR-%s\n", chip->name, chip->name);
 	chip->irq_print_chip = ir_print_prefix;
 	chip->irq_ack = ir_ack_apic_edge;
 	chip->irq_eoi = ir_ack_apic_level;
 	chip->irq_set_affinity = x86_io_apic_ops.set_affinity;
 }
 
-bool setup_remapped_irq(int irq, struct irq_cfg *cfg, struct irq_chip *chip)
+void __init irq_remap_modify_chips(void)
+{
+	irq_remap_modify_chip_defaults(&ioapic_chip);
+	irq_remap_modify_chip_defaults(&msi_chip);
+	irq_remap_modify_chip_defaults(&hpet_msi_type);
+}
+
+bool setup_remapped_irq(int irq, struct irq_cfg *cfg)
 {
 	if (!irq_remapped(cfg))
 		return false;
 	irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
-	irq_remap_modify_chip_defaults(chip);
 	return true;
 }
-- 
1.8.1.4

