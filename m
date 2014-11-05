Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532AbaKEQkO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:40:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41363 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468AbaKEQkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:40:09 -0500
Date: Wed, 5 Nov 2014 08:38:54 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-e847692497a4f5d08b90af6168c49096292dfe43@git.kernel.org>
Cc: bhelgaas@google.com, bp@alien8.de, gregkh@linuxfoundation.org,
        tony.luck@intel.com, prarit@redhat.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org, grant.likely@linaro.org,
        benh@kernel.crashing.org, hpa@zytor.com, joro@8bytes.org,
        konrad.wilk@oracle.com, rdunlap@infradead.org, rjw@rjwysocki.net,
        tglx@linutronix.de, jiang.liu@linux.intel.com, yinghai@kernel.org
Reply-To: grant.likely@linaro.org, benh@kernel.crashing.org,
        tglx@linutronix.de, rjw@rjwysocki.net, joro@8bytes.org,
        konrad.wilk@oracle.com, hpa@zytor.com, rdunlap@infradead.org,
        jiang.liu@linux.intel.com, yinghai@kernel.org, bhelgaas@google.com,
        gregkh@linuxfoundation.org, bp@alien8.de, prarit@redhat.com,
        mingo@kernel.org, linux-kernel@vger.kernel.org, tony.luck@intel.com
In-Reply-To: <1414397531-28254-15-git-send-email-jiang.liu@linux.intel.com>
References: <1414397531-28254-15-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq:
  Move IRQ initialization routines from io_apic.c into vector.c
Git-Commit-ID: e847692497a4f5d08b90af6168c49096292dfe43
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

Commit-ID:  e847692497a4f5d08b90af6168c49096292dfe43
Gitweb:     http://git.kernel.org/tip/e847692497a4f5d08b90af6168c49096292dfe43
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 27 Oct 2014 16:12:05 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 5 Nov 2014 11:04:47 +0100

x86, irq: Move IRQ initialization routines from io_apic.c into vector.c

Move IRQ initialization routines from io_apic.c into vector.c,
preparing for enabling hierarchy irqdomain.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Link: http://lkml.kernel.org/r/1414397531-28254-15-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/io_apic.h |  2 ++
 arch/x86/kernel/apic/io_apic.c | 22 +---------------------
 arch/x86/kernel/apic/vector.c  | 28 ++++++++++++++++++++++++++++
 3 files changed, 31 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index b7f1499..bf006cc 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -145,6 +145,7 @@ extern unsigned long io_apic_irqs;
 
 struct irq_cfg;
 extern void ioapic_insert_resources(void);
+extern int arch_early_ioapic_init(void);
 
 extern int native_setup_ioapic_entry(int, struct IO_APIC_route_entry *,
 				     unsigned int, int,
@@ -248,6 +249,7 @@ extern void print_IO_APICs(void);
 #define io_apic_assign_pci_irqs 0
 #define setup_ioapic_ids_from_mpc x86_init_noop
 static inline void ioapic_insert_resources(void) { }
+static inline int arch_early_ioapic_init(void) { return 0; }
 static inline void print_IO_APICs(void) {}
 #define gsi_top (NR_IRQS_LEGACY)
 static inline int mp_find_ioapic(u32 gsi) { return 0; }
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 8dcdb7b..2619cbe 100644
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
index c03d5ca..e194447 100644
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
