Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbaIZO4L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 10:56:11 -0400
Received: from mga14.intel.com ([192.55.52.115]:47845 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754160AbaIZO4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 10:56:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,604,1406617200"; 
   d="scan'208";a="597292022"
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
Subject: [RFC v1 04/28] x86, irq: Refine the way to allocate irq_cfg for legacy IRQs
Date: Fri, 26 Sep 2014 22:57:34 +0800
Message-Id: <1411743478-31435-5-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1411743478-31435-1-git-send-email-jiang.liu@linux.intel.com>
References: <1411743478-31435-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To support legacy ISA IRQs, we need to preallocate irq_cfg structures
for legacy ISA IRQs. Refine the way to allocate irq_cfg for legacy ISA
IRQs, so it's more friend to hierarchy irqdomain implementation.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/apic/io_apic.c |   13 +-----------
 arch/x86/kernel/apic/vector.c  |   43 ++++++++++++++++++++++++++++++++++++++--
 2 files changed, 42 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 61cf53b65225..875c40bdbd16 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -264,8 +264,7 @@ static void free_ioapic_saved_registers(int idx)
 
 int __init arch_early_ioapic_init(void)
 {
-	struct irq_cfg *cfg;
-	int i, node = cpu_to_node(0);
+	int i;
 
 	if (!nr_legacy_irqs())
 		io_apic_irqs = ~0UL;
@@ -273,16 +272,6 @@ int __init arch_early_ioapic_init(void)
 	for_each_ioapic(i)
 		alloc_ioapic_saved_registers(i);
 
-	/*
-	 * For legacy IRQ's, start with assigning irq0 to irq15 to
-	 * IRQ0_VECTOR to IRQ15_VECTOR for all cpu's.
-	 */
-	for (i = 0; i < nr_legacy_irqs(); i++) {
-		cfg = alloc_irq_and_cfg_at(i, node);
-		cfg->vector = IRQ0_VECTOR + i;
-		cpumask_setall(cfg->domain);
-	}
-
 	return 0;
 }
 
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index 68f8032d181c..1fb9e602e3ae 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -24,6 +24,9 @@
 struct irq_domain *x86_vector_domain;
 static DEFINE_RAW_SPINLOCK(vector_lock);
 static struct irq_chip vector_chip;
+#ifdef	CONFIG_X86_IO_APIC
+static struct irq_cfg *legacy_irq_cfgs[NR_IRQS_LEGACY];
+#endif
 
 void lock_vector_lock(void)
 {
@@ -283,6 +286,10 @@ static void x86_vector_free_irqs(struct irq_domain *domain,
 			free_remapped_irq(virq);
 			clear_irq_vector(virq + i, irq_data->chip_data);
 			free_irq_cfg(irq_data->chip_data);
+#ifdef	CONFIG_X86_IO_APIC
+			if (virq + i < nr_legacy_irqs())
+				legacy_irq_cfgs[virq + i] = NULL;
+#endif
 			irq_domain_reset_irq_data(irq_data);
 		}
 	}
@@ -303,7 +310,11 @@ static int x86_vector_alloc_irqs(struct irq_domain *domain, unsigned int virq,
 	for (i = 0; i < nr_irqs; i++) {
 		irq_data = irq_domain_get_irq_data(domain, virq + i);
 		BUG_ON(!irq_data);
-		cfg = alloc_irq_cfg(irq_data->node);
+#ifdef	CONFIG_X86_IO_APIC
+		if (virq + i >= nr_legacy_irqs() ||
+		    (cfg = legacy_irq_cfgs[virq + i]) == NULL)
+#endif
+			cfg = alloc_irq_cfg(irq_data->node);
 		if (!cfg) {
 			err = -ENOMEM;
 			goto error;
@@ -349,11 +360,39 @@ int __init arch_probe_nr_irqs(void)
 	if (nr < nr_irqs)
 		nr_irqs = nr;
 
-	return 0;
+	return nr_legacy_irqs();
 }
 
+#ifdef	CONFIG_X86_IO_APIC
+static void init_legacy_irqs(void)
+{
+	int i, node = cpu_to_node(0);
+	struct irq_cfg *cfg;
+
+	/*
+	 * For legacy IRQ's, start with assigning irq0 to irq15 to
+	 * IRQ0_VECTOR to IRQ15_VECTOR for all cpu's.
+	 */
+	for (i = 0; i < nr_legacy_irqs(); i++) {
+		cfg = legacy_irq_cfgs[i] = alloc_irq_cfg(node);
+		BUG_ON(!cfg);
+		/*
+		 * For legacy IRQ's, start with assigning irq0 to irq15 to
+		 * IRQ0_VECTOR to IRQ15_VECTOR for all cpu's.
+		 */
+		cfg->vector = IRQ0_VECTOR + i;
+		cpumask_setall(cfg->domain);
+		irq_set_chip_data(i, cfg);
+	}
+}
+#else
+static void init_legacy_irqs(void) { }
+#endif
+
 int __init arch_early_irq_init(void)
 {
+	init_legacy_irqs();
+
 	x86_vector_domain = irq_domain_add_tree(NULL, &x86_vector_domain_ops,
 						NULL);
 	BUG_ON(x86_vector_domain == NULL);
-- 
1.7.10.4

