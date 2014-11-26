Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbaKZXPO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:15:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58617 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301AbaKZXPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:15:10 -0500
Date: Wed, 26 Nov 2014 15:14:14 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-30ba6dedce8de6816f9c7b7b5992566c9e357574@git.kernel.org>
Cc: rdunlap@infradead.org, benh@kernel.crashing.org, yinghai@kernel.org,
        tglx@linutronix.de, tony.luck@intel.com, gregkh@linuxfoundation.org,
        jiang.liu@linux.intel.com, rjw@rjwysocki.net, grant.likely@linaro.org,
        bhelgaas@google.com, joro@8bytes.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, mingo@kernel.org, jroedel@suse.de,
        konrad.wilk@oracle.com, bp@alien8.de
Reply-To: joro@8bytes.org, bhelgaas@google.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com, rjw@rjwysocki.net, grant.likely@linaro.org,
        jroedel@suse.de, bp@alien8.de, konrad.wilk@oracle.com,
        mingo@kernel.org, yinghai@kernel.org, rdunlap@infradead.org,
        benh@kernel.crashing.org, jiang.liu@linux.intel.com,
        tglx@linutronix.de, gregkh@linuxfoundation.org, tony.luck@intel.com
In-Reply-To: <1416901802-24211-7-git-send-email-jiang.liu@linux.intel.com>
References: <1416901802-24211-7-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq:
  Refine the way to allocate irq_cfg for legacy IRQs
Git-Commit-ID: 30ba6dedce8de6816f9c7b7b5992566c9e357574
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

Commit-ID:  30ba6dedce8de6816f9c7b7b5992566c9e357574
Gitweb:     http://git.kernel.org/tip/30ba6dedce8de6816f9c7b7b5992566c9e357574
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 15:49:30 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 23:52:46 +0100

x86, irq: Refine the way to allocate irq_cfg for legacy IRQs

To support legacy ISA IRQs, we need to preallocate irq_cfg structures
for legacy ISA IRQs. Refine the way to allocate irq_cfg for legacy ISA
IRQs, so it's more friend to hierarchy irqdomain implementation.

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
Link: http://lkml.kernel.org/r/1416901802-24211-7-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/apic/io_apic.c | 13 +------------
 arch/x86/kernel/apic/vector.c  | 42 +++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 42 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index e465171..74a0e95 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -254,8 +254,7 @@ static void free_ioapic_saved_registers(int idx)
 
 int __init arch_early_ioapic_init(void)
 {
-	struct irq_cfg *cfg;
-	int i, node = cpu_to_node(0);
+	int i;
 
 	if (!nr_legacy_irqs())
 		io_apic_irqs = ~0UL;
@@ -263,16 +262,6 @@ int __init arch_early_ioapic_init(void)
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
index 609db19..4b8fad9 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -24,6 +24,9 @@
 struct irq_domain *x86_vector_domain;
 static DEFINE_RAW_SPINLOCK(vector_lock);
 static struct irq_chip lapic_controller;
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
@@ -308,7 +315,12 @@ static int x86_vector_alloc_irqs(struct irq_domain *domain, unsigned int virq,
 	for (i = 0; i < nr_irqs; i++) {
 		irq_data = irq_domain_get_irq_data(domain, virq + i);
 		BUG_ON(!irq_data);
-		cfg = alloc_irq_cfg(irq_data->node);
+#ifdef	CONFIG_X86_IO_APIC
+		if (virq + i < nr_legacy_irqs() && legacy_irq_cfgs[virq + i])
+			cfg = legacy_irq_cfgs[virq + i];
+		else
+#endif
+			cfg = alloc_irq_cfg(irq_data->node);
 		if (!cfg) {
 			err = -ENOMEM;
 			goto error;
@@ -357,8 +369,36 @@ int __init arch_probe_nr_irqs(void)
 	return nr_legacy_irqs();
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
