Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbaIZPC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 11:02:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:27175 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755399AbaIZO4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 10:56:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,604,1406617200"; 
   d="scan'208";a="597292284"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [RFC v1 13/28] x86: irq_remapping: Clean up unsued code
Date: Fri, 26 Sep 2014 22:57:43 +0800
Message-Id: <1411743478-31435-14-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1411743478-31435-1-git-send-email-jiang.liu@linux.intel.com>
References: <1411743478-31435-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we have converted to hierarchy irqdomain, so clean up unused code.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/irq_remapping.h |   23 ----------------------
 arch/x86/kernel/apic/vector.c        |    1 -
 drivers/iommu/irq_remapping.c        |   36 ----------------------------------
 3 files changed, 60 deletions(-)

diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index 9ed7e2d5fd7d..f78b741ddffc 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -25,12 +25,7 @@
 #include <linux/irqdomain.h>
 #include <asm/io_apic.h>
 
-struct IO_APIC_route_entry;
-struct io_apic_irq_attr;
-struct irq_chip;
 struct msi_msg;
-struct pci_dev;
-struct irq_cfg;
 struct irq_alloc_info;
 
 #ifdef CONFIG_IRQ_REMAP
@@ -43,13 +38,7 @@ extern int irq_remapping_enable(void);
 extern void irq_remapping_disable(void);
 extern int irq_remapping_reenable(int);
 extern int irq_remap_enable_fault_handling(void);
-extern void free_remapped_irq(int irq);
 extern void panic_if_irq_remap(const char *msg);
-extern bool setup_remapped_irq(int irq,
-			       struct irq_cfg *cfg,
-			       struct irq_chip *chip);
-
-void irq_remap_modify_chip_defaults(struct irq_chip *chip);
 
 extern struct irq_domain *irq_remapping_get_ir_irq_domain(
 				struct irq_alloc_info *info);
@@ -93,23 +82,11 @@ static inline int irq_remapping_enable(void) { return -ENODEV; }
 static inline void irq_remapping_disable(void) { }
 static inline int irq_remapping_reenable(int eim) { return -ENODEV; }
 static inline int irq_remap_enable_fault_handling(void) { return -ENODEV; }
-static inline void free_remapped_irq(int irq) { }
 
 static inline void panic_if_irq_remap(const char *msg)
 {
 }
 
-static inline void irq_remap_modify_chip_defaults(struct irq_chip *chip)
-{
-}
-
-static inline bool setup_remapped_irq(int irq,
-				      struct irq_cfg *cfg,
-				      struct irq_chip *chip)
-{
-	return false;
-}
-
 static inline struct irq_domain *
 irq_remapping_get_ir_irq_domain(struct irq_alloc_info *info)
 {
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index a149a6b37efe..c3ba34553b29 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -283,7 +283,6 @@ static void x86_vector_free_irqs(struct irq_domain *domain,
 	for (i = 0; i < nr_irqs; i++) {
 		irq_data = irq_domain_get_irq_data(x86_vector_domain, virq + i);
 		if (irq_data && irq_data->chip_data) {
-			free_remapped_irq(virq);
 			clear_irq_vector(virq + i, irq_data->chip_data);
 			free_irq_cfg(irq_data->chip_data);
 #ifdef	CONFIG_X86_IO_APIC
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index cebb198ecf16..eb6477c01177 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -25,11 +25,6 @@ int no_x2apic_optout;
 
 static struct irq_remap_ops *remap_ops;
 
-static bool irq_remapped(struct irq_cfg *cfg)
-{
-	return (cfg->remapped == 1);
-}
-
 static void irq_remapping_disable_io_apic(void)
 {
 	/*
@@ -159,17 +154,6 @@ int __init irq_remap_enable_fault_handling(void)
 	return remap_ops->enable_faulting();
 }
 
-void free_remapped_irq(int irq)
-{
-	struct irq_cfg *cfg = irq_cfg(irq);
-
-	if (!remap_ops || !remap_ops->free_irq)
-		return;
-
-	if (irq_remapped(cfg))
-		remap_ops->free_irq(irq);
-}
-
 void panic_if_irq_remap(const char *msg)
 {
 	if (irq_remapping_enabled)
@@ -194,26 +178,6 @@ void irq_remapping_print_chip(struct irq_data *data, struct seq_file *p)
 		seq_printf(p, " %s", data->chip->name);
 }
 
-static void ir_print_prefix(struct irq_data *data, struct seq_file *p)
-{
-	seq_printf(p, " IR-%s", data->chip->name);
-}
-
-void irq_remap_modify_chip_defaults(struct irq_chip *chip)
-{
-	chip->irq_print_chip = ir_print_prefix;
-	chip->irq_ack = ir_ack_apic_edge;
-}
-
-bool setup_remapped_irq(int irq, struct irq_cfg *cfg, struct irq_chip *chip)
-{
-	if (!irq_remapped(cfg))
-		return false;
-	irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
-	irq_remap_modify_chip_defaults(chip);
-	return true;
-}
-
 /**
  * irq_remapping_get_ir_irq_domain - Get the irqdomain associated the IOMMU
  *				     device serving @info
-- 
1.7.10.4

