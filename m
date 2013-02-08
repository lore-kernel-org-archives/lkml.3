Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946997Ab3BHTeh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 14:34:37 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:26574 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760511Ab3BHTaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 14:30:02 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2 02/26] x86, irq: Modify irq chip once for irq remapping
Date: Fri,  8 Feb 2013 11:27:59 -0800
Message-Id: <1360351703-20571-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
References: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now after irq remapping is enabled, irq_chip fields are modified during
every irq setup.

Only need to change them one during we enable irq mapping.

Also change irq_remap_modify_chip_defaults() to __init.

We don't need to use #ifdef in irq_remap_modify_chips(), as
IRQ_REMAP only support x86_64 AND X86_IO_APIC AND PCI_MSI,
also HPET_TIMER is set when x86_64 is set.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Joerg Roedel <joro@8bytes.org>
---
 arch/x86/include/asm/io_apic.h |    5 +++++
 arch/x86/kernel/apic/apic.c    |    9 ++++++++-
 arch/x86/kernel/apic/io_apic.c |    8 +++-----
 drivers/iommu/irq_remapping.c  |   11 +++++++++--
 4 files changed, 25 insertions(+), 8 deletions(-)

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
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index a5b4dce..84815b1 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1552,6 +1552,8 @@ void enable_x2apic(void)
 int __init enable_IR(void)
 {
 #ifdef CONFIG_IRQ_REMAP
+	int ret;
+
 	if (!irq_remapping_supported()) {
 		pr_debug("intr-remapping not supported\n");
 		return -1;
@@ -1563,7 +1565,12 @@ int __init enable_IR(void)
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
index 9ed796c..f78f7f6 100644
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
@@ -3240,7 +3238,7 @@ static int hpet_msi_set_affinity(struct irq_data *data,
 	return IRQ_SET_MASK_OK_NOCOPY;
 }
 
-static struct irq_chip hpet_msi_type = {
+struct irq_chip hpet_msi_type = {
 	.name = "HPET_MSI",
 	.irq_unmask = hpet_msi_unmask,
 	.irq_mask = hpet_msi_mask,
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 01ed477..33918c3 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -368,19 +368,26 @@ static void ir_print_prefix(struct irq_data *data, struct seq_file *p)
 	seq_printf(p, " IR-%s", data->chip->name);
 }
 
-static void irq_remap_modify_chip_defaults(struct irq_chip *chip)
+static void __init irq_remap_modify_chip_defaults(struct irq_chip *chip)
 {
+	printk(KERN_DEBUG "irq_chip: %s ==> IR-%s", chip->name, chip->name);
 	chip->irq_print_chip = ir_print_prefix;
 	chip->irq_ack = ir_ack_apic_edge;
 	chip->irq_eoi = ir_ack_apic_level;
 	chip->irq_set_affinity = x86_io_apic_ops.set_affinity;
 }
 
+void __init irq_remap_modify_chips(void)
+{
+	irq_remap_modify_chip_defaults(&ioapic_chip);
+	irq_remap_modify_chip_defaults(&msi_chip);
+	irq_remap_modify_chip_defaults(&hpet_msi_type);
+}
+
 bool setup_remapped_irq(int irq, struct irq_cfg *cfg, struct irq_chip *chip)
 {
 	if (!irq_remapped(cfg))
 		return false;
 	irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
-	irq_remap_modify_chip_defaults(chip);
 	return true;
 }
-- 
1.7.10.4

