Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbbATDG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 22:06:27 -0500
Received: from mga11.intel.com ([192.55.52.93]:61844 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811AbbATDGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 22:06:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="442528167"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Dimitri Sivanich <sivanich@sgi.com>,
        x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>
Subject: [Patch Part1 v7 02/38] x86/irq: Use hierarchy irqdomain to manage CPU interrupt vectors
Date: Tue, 20 Jan 2015 11:08:05 +0800
Message-Id: <1421723321-8386-3-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421723321-8386-1-git-send-email-jiang.liu@linux.intel.com>
References: <1421723321-8386-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Abstract CPU local APIC as an interrupt controller and create an
irqdomain for it to manage CPU interrupt vectors. It's the base to
enable hierarchy irqdomain on x86 systems. Eventually we will build
a irqdomain hierarchy as below:

IOAPIC domain-------|
MSI/MSI-x domain------> [Inerrupt Remapping domain] -> CPU vector domain
HPET_IRQ domain_____|                                         ^
DMAR domain---------------------------------------------------|
HT_IRQ domain-------------------------------------------------|

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Link: http://lkml.kernel.org/r/1416894816-23245-3-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/Kconfig               |    3 +-
 arch/x86/include/asm/hw_irq.h  |   17 +++++
 arch/x86/kernel/apic/io_apic.c |    3 -
 arch/x86/kernel/apic/vector.c  |  156 ++++++++++++++++++++++++++++++++++++----
 4 files changed, 161 insertions(+), 18 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ba397bde7948..ff7cad03d7f7 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -457,7 +457,6 @@ config X86_INTEL_CE
 	select X86_REBOOTFIXUPS
 	select OF
 	select OF_EARLY_FLATTREE
-	select IRQ_DOMAIN
 	---help---
 	  Select for the Intel CE media processor (CE4100) SOC.
 	  This option compiles in support for the CE4100 SOC for settop
@@ -884,11 +883,11 @@ config X86_LOCAL_APIC
 	def_bool y
 	depends on X86_64 || SMP || X86_32_NON_STANDARD || X86_UP_APIC || PCI_MSI
 	select GENERIC_IRQ_LEGACY_ALLOC_HWIRQ
+	select IRQ_DOMAIN_HIERARCHY
 
 config X86_IO_APIC
 	def_bool X86_64 || SMP || X86_32_NON_STANDARD || X86_UP_IOAPIC
 	depends on X86_LOCAL_APIC
-	select IRQ_DOMAIN
 
 config X86_REROUTE_FOR_BROKEN_BOOT_IRQS
 	bool "Reroute for broken boot IRQs"
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index b988ddf7434b..eb7692c9ab93 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -112,6 +112,17 @@ struct irq_2_irte {
 
 #ifdef	CONFIG_X86_LOCAL_APIC
 struct irq_data;
+struct irq_domain;
+
+struct irq_alloc_info {
+	u32			flags;
+	const struct cpumask	*mask;	/* CPU mask for vector allocation */
+};
+
+enum {
+	/* Allocate contigious CPU vectors */
+	X86_IRQ_ALLOC_CONTIGOUS_VECTORS		= 0x1,
+};
 
 struct irq_cfg {
 	cpumask_var_t		domain;
@@ -135,6 +146,12 @@ struct irq_cfg {
 	};
 };
 
+extern struct irq_domain *x86_vector_domain;
+
+extern void init_irq_alloc_info(struct irq_alloc_info *info,
+				const struct cpumask *mask);
+extern void copy_irq_alloc_info(struct irq_alloc_info *dst,
+				struct irq_alloc_info *src);
 extern struct irq_cfg *irq_cfg(unsigned int irq);
 extern struct irq_cfg *irqd_cfg(struct irq_data *irq_data);
 extern struct irq_cfg *alloc_irq_and_cfg_at(unsigned int at, int node);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index f4dc2462a1ac..56d532106ef3 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2356,9 +2356,6 @@ static int mp_irqdomain_create(int ioapic)
 		ioapic_dynirq_base = max(ioapic_dynirq_base,
 					 gsi_cfg->gsi_end + 1);
 
-	if (gsi_cfg->gsi_base == 0)
-		irq_set_default_host(ip->irqdomain);
-
 	return 0;
 }
 
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index c724ef6b218c..f8340c72546f 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -3,6 +3,8 @@
  *
  * Copyright (C) 1997, 1998, 1999, 2000, 2009 Ingo Molnar, Hajnalka Szabo
  *	Moved from arch/x86/kernel/apic/io_apic.c.
+ * Jiang Liu <jiang.liu@linux.intel.com>
+ *	Enable support of hierarchy irqdomain
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -19,7 +21,9 @@
 #include <asm/desc.h>
 #include <asm/irq_remapping.h>
 
+struct irq_domain *x86_vector_domain;
 static DEFINE_RAW_SPINLOCK(vector_lock);
+static struct irq_chip lapic_controller;
 
 void lock_vector_lock(void)
 {
@@ -36,15 +40,21 @@ void unlock_vector_lock(void)
 
 struct irq_cfg *irq_cfg(unsigned int irq)
 {
-	return irq_get_chip_data(irq);
+	return irqd_cfg(irq_get_irq_data(irq));
 }
 
 struct irq_cfg *irqd_cfg(struct irq_data *irq_data)
 {
+	if (!irq_data)
+		return NULL;
+
+	while (irq_data->parent_data)
+		irq_data = irq_data->parent_data;
+
 	return irq_data->chip_data;
 }
 
-static struct irq_cfg *alloc_irq_cfg(unsigned int irq, int node)
+static struct irq_cfg *alloc_irq_cfg(int node)
 {
 	struct irq_cfg *cfg;
 
@@ -79,7 +89,7 @@ struct irq_cfg *alloc_irq_and_cfg_at(unsigned int at, int node)
 			return cfg;
 	}
 
-	cfg = alloc_irq_cfg(at, node);
+	cfg = alloc_irq_cfg(node);
 	if (cfg)
 		irq_set_chip_data(at, cfg);
 	else
@@ -87,14 +97,13 @@ struct irq_cfg *alloc_irq_and_cfg_at(unsigned int at, int node)
 	return cfg;
 }
 
-static void free_irq_cfg(unsigned int at, struct irq_cfg *cfg)
+static void free_irq_cfg(struct irq_cfg *cfg)
 {
-	if (!cfg)
-		return;
-	irq_set_chip_data(at, NULL);
-	free_cpumask_var(cfg->domain);
-	free_cpumask_var(cfg->old_domain);
-	kfree(cfg);
+	if (cfg) {
+		free_cpumask_var(cfg->domain);
+		free_cpumask_var(cfg->old_domain);
+		kfree(cfg);
+	}
 }
 
 static int
@@ -241,6 +250,90 @@ void clear_irq_vector(int irq, struct irq_cfg *cfg)
 	raw_spin_unlock_irqrestore(&vector_lock, flags);
 }
 
+void init_irq_alloc_info(struct irq_alloc_info *info,
+			 const struct cpumask *mask)
+{
+	memset(info, 0, sizeof(*info));
+	info->mask = mask;
+}
+
+void copy_irq_alloc_info(struct irq_alloc_info *dst, struct irq_alloc_info *src)
+{
+	if (src)
+		*dst = *src;
+	else
+		memset(dst, 0, sizeof(*dst));
+}
+
+static inline const struct cpumask *
+irq_alloc_info_get_mask(struct irq_alloc_info *info)
+{
+	return (!info || !info->mask) ? apic->target_cpus() : info->mask;
+}
+
+static void x86_vector_free_irqs(struct irq_domain *domain,
+				 unsigned int virq, unsigned int nr_irqs)
+{
+	int i;
+	struct irq_data *irq_data;
+
+	for (i = 0; i < nr_irqs; i++) {
+		irq_data = irq_domain_get_irq_data(x86_vector_domain, virq + i);
+		if (irq_data && irq_data->chip_data) {
+			free_remapped_irq(virq);
+			clear_irq_vector(virq + i, irq_data->chip_data);
+			free_irq_cfg(irq_data->chip_data);
+			irq_domain_reset_irq_data(irq_data);
+		}
+	}
+}
+
+static int x86_vector_alloc_irqs(struct irq_domain *domain, unsigned int virq,
+				 unsigned int nr_irqs, void *arg)
+{
+	int i, err;
+	struct irq_cfg *cfg;
+	struct irq_data *irq_data;
+	const struct cpumask *mask;
+	struct irq_alloc_info *info = arg;
+
+	if (disable_apic)
+		return -ENXIO;
+
+	/* Currently vector allocator can't guarantee contigious allocations */
+	if ((info->flags & X86_IRQ_ALLOC_CONTIGOUS_VECTORS) && nr_irqs > 1)
+		return -ENOSYS;
+
+	mask = irq_alloc_info_get_mask(info);
+	for (i = 0; i < nr_irqs; i++) {
+		irq_data = irq_domain_get_irq_data(domain, virq + i);
+		BUG_ON(!irq_data);
+		cfg = alloc_irq_cfg(irq_data->node);
+		if (!cfg) {
+			err = -ENOMEM;
+			goto error;
+		}
+
+		irq_data->chip = &lapic_controller;
+		irq_data->chip_data = cfg;
+		irq_data->hwirq = virq + i;
+		err = assign_irq_vector(virq, cfg, mask);
+		if (err)
+			goto error;
+	}
+
+	return 0;
+
+error:
+	x86_vector_free_irqs(domain, virq, i + 1);
+	return err;
+}
+
+static struct irq_domain_ops x86_vector_domain_ops = {
+	.alloc = x86_vector_alloc_irqs,
+	.free = x86_vector_free_irqs,
+};
+
 int __init arch_probe_nr_irqs(void)
 {
 	int nr;
@@ -266,6 +359,11 @@ int __init arch_probe_nr_irqs(void)
 
 int __init arch_early_irq_init(void)
 {
+	x86_vector_domain = irq_domain_add_tree(NULL, &x86_vector_domain_ops,
+						NULL);
+	BUG_ON(x86_vector_domain == NULL);
+	irq_set_default_host(x86_vector_domain);
+
 	return arch_early_ioapic_init();
 }
 
@@ -380,6 +478,37 @@ int apic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	return 0;
 }
 
+static int vector_set_affinity(struct irq_data *irq_data,
+			       const struct cpumask *dest, bool force)
+{
+	int err;
+	int irq = irq_data->irq;
+	struct irq_cfg *cfg = irq_data->chip_data;
+
+	if (!config_enabled(CONFIG_SMP))
+		return -EPERM;
+
+	if (!cpumask_intersects(dest, cpu_online_mask))
+		return -EINVAL;
+
+	err = assign_irq_vector(irq, cfg, dest);
+	if (err) {
+		struct irq_data *top = irq_get_irq_data(irq);
+
+		if (assign_irq_vector(irq, cfg, top->affinity))
+			pr_err("Failed to recover vector for irq %d\n", irq);
+		return err;
+	}
+
+	return IRQ_SET_MASK_OK;
+}
+
+static struct irq_chip lapic_controller = {
+	.irq_ack		= apic_ack_edge,
+	.irq_set_affinity	= vector_set_affinity,
+	.irq_retrigger		= apic_retrigger_irq,
+};
+
 #ifdef CONFIG_SMP
 void send_cleanup_vector(struct irq_cfg *cfg)
 {
@@ -497,7 +626,7 @@ int arch_setup_hwirq(unsigned int irq, int node)
 	unsigned long flags;
 	int ret;
 
-	cfg = alloc_irq_cfg(irq, node);
+	cfg = alloc_irq_cfg(node);
 	if (!cfg)
 		return -ENOMEM;
 
@@ -508,7 +637,7 @@ int arch_setup_hwirq(unsigned int irq, int node)
 	if (!ret)
 		irq_set_chip_data(irq, cfg);
 	else
-		free_irq_cfg(irq, cfg);
+		free_irq_cfg(cfg);
 	return ret;
 }
 
@@ -518,7 +647,8 @@ void arch_teardown_hwirq(unsigned int irq)
 
 	free_remapped_irq(irq);
 	clear_irq_vector(irq, cfg);
-	free_irq_cfg(irq, cfg);
+	irq_set_chip_data(irq, NULL);
+	free_irq_cfg(cfg);
 }
 
 static void __init print_APIC_field(int base)
-- 
1.7.10.4

