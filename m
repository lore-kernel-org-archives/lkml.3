Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbaJ0IOF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 04:14:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:37448 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbaJ0IOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 04:14:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,794,1406617200"; 
   d="scan'208";a="621214090"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Prarit Bhargava <prarit@redhat.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [Patch Part1 v3 14/20] x86, irq: Move IRQ initialization routines from io_apic.c into vector.c
Date: Mon, 27 Oct 2014 16:12:05 +0800
Message-Id: <1414397531-28254-15-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1414397531-28254-1-git-send-email-jiang.liu@linux.intel.com>
References: <1414397531-28254-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move IRQ initialization routines from io_apic.c into vector.c,
preparing for enabling hierarchy irqdomain.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/io_apic.h |    2 ++
 arch/x86/kernel/apic/io_apic.c |   22 +---------------------
 arch/x86/kernel/apic/vector.c  |   28 ++++++++++++++++++++++++++++
 3 files changed, 31 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 533803dc3733..7bf86bfe05b1 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -145,6 +145,7 @@ extern unsigned long io_apic_irqs;
 
 struct irq_cfg;
 extern void ioapic_insert_resources(void);
+extern int arch_early_ioapic_init(void);
 
 extern int native_setup_ioapic_entry(int, struct IO_APIC_route_entry *,
 				     unsigned int, int,
@@ -249,6 +250,7 @@ extern void print_IO_APICs(void);
 #define io_apic_assign_pci_irqs 0
 #define setup_ioapic_ids_from_mpc x86_init_noop
 static inline void ioapic_insert_resources(void) { }
+static inline int arch_early_ioapic_init(void) { return 0; }
 static inline void print_IO_APICs(void) {}
 #define gsi_top (NR_IRQS_LEGACY)
 static inline int mp_find_ioapic(u32 gsi) { return 0; }
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index b6f249ac5d20..f94094a0b00d 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -245,7 +245,7 @@ static void free_ioapic_saved_registers(int idx)
 	ioapics[idx].saved_registers = NULL;
 }
 
-int __init arch_early_irq_init(void)
+int __init arch_early_ioapic_init(void)
 {
 	struct irq_cfg *cfg;
 	int i, node = cpu_to_node(0);
@@ -2487,26 +2487,6 @@ unsigned int arch_dynirq_lower_bound(unsigned int from)
 	return ioapic_initialized ? ioapic_dynirq_base : gsi_top;
 }
 
-int __init arch_probe_nr_irqs(void)
-{
-	int nr;
-
-	if (nr_irqs > (NR_VECTORS * nr_cpu_ids))
-		nr_irqs = NR_VECTORS * nr_cpu_ids;
-
-	nr = (gsi_top + nr_legacy_irqs()) + 8 * nr_cpu_ids;
-#if defined(CONFIG_PCI_MSI) || defined(CONFIG_HT_IRQ)
-	/*
-	 * for MSI and HT dyn irq
-	 */
-	nr += gsi_top * 16;
-#endif
-	if (nr < nr_irqs)
-		nr_irqs = nr;
-
-	return 0;
-}
-
 #ifdef CONFIG_X86_32
 static int io_apic_get_unique_id(int ioapic, int apic_id)
 {
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index f728cbfc29a9..2d778f508f65 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -235,6 +235,34 @@ void clear_irq_vector(int irq, struct irq_cfg *cfg)
 	raw_spin_unlock_irqrestore(&vector_lock, flags);
 }
 
+int __init arch_probe_nr_irqs(void)
+{
+	int nr;
+
+	if (nr_irqs > (NR_VECTORS * nr_cpu_ids))
+		nr_irqs = NR_VECTORS * nr_cpu_ids;
+
+	nr = (gsi_top + nr_legacy_irqs()) + 8 * nr_cpu_ids;
+#if defined(CONFIG_PCI_MSI) || defined(CONFIG_HT_IRQ)
+	/*
+	 * for MSI and HT dyn irq
+	 */
+	if (gsi_top <= NR_IRQS_LEGACY)
+		nr +=  8 * nr_cpu_ids;
+	else
+		nr += gsi_top * 16;
+#endif
+	if (nr < nr_irqs)
+		nr_irqs = nr;
+
+	return nr_legacy_irqs();
+}
+
+int __init arch_early_irq_init(void)
+{
+	return arch_early_ioapic_init();
+}
+
 static void __setup_vector_irq(int cpu)
 {
 	/* Initialize vector_irq on a new cpu */
-- 
1.7.10.4

