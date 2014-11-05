Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113AbaKEQhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:37:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41203 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590AbaKEQhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:37:17 -0500
Date: Wed, 5 Nov 2014 08:35:48 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-ead3fb62ae4ac8df90312edfd8c4907da8a4481c@git.kernel.org>
Cc: benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, yinghai@kernel.org, konrad.wilk@oracle.com,
        jiang.liu@linux.intel.com, joro@8bytes.org, tglx@linutronix.de,
        hpa@zytor.com, rjw@rjwysocki.net, mingo@kernel.org,
        rdunlap@infradead.org, gregkh@linuxfoundation.org, bp@alien8.de,
        tony.luck@intel.com, prarit@redhat.com
Reply-To: rdunlap@infradead.org, rjw@rjwysocki.net, mingo@kernel.org,
        tony.luck@intel.com, prarit@redhat.com, gregkh@linuxfoundation.org,
        bp@alien8.de, tglx@linutronix.de, jiang.liu@linux.intel.com,
        konrad.wilk@oracle.com, joro@8bytes.org, yinghai@kernel.org,
        benh@kernel.crashing.org, bhelgaas@google.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com
In-Reply-To: <1414397531-28254-6-git-send-email-jiang.liu@linux.intel.com>
References: <1414397531-28254-6-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq:
  Refine hw_irq.h to prepare for irqdomain support
Git-Commit-ID: ead3fb62ae4ac8df90312edfd8c4907da8a4481c
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

Commit-ID:  ead3fb62ae4ac8df90312edfd8c4907da8a4481c
Gitweb:     http://git.kernel.org/tip/ead3fb62ae4ac8df90312edfd8c4907da8a4481c
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 27 Oct 2014 16:11:56 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 5 Nov 2014 11:04:46 +0100

x86, irq: Refine hw_irq.h to prepare for irqdomain support

Refine hw_irq.h to prepare for irqdomain support by:

1) guarding common APIC related interfaces with CONFIG_X86_LOCAL_APIC
2) guarding interrupt remapping related interfaces with CONFIG_IRQ_REMAP
3) guarding IOAPIC related interfaces with CONFIG_X86_IO_APIC

No functional changes.

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
Cc: Prarit Bhargava <prarit@redhat.com>
Link: http://lkml.kernel.org/r/1414397531-28254-6-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/hw_irq.h | 94 +++++++++++++++++++++++--------------------
 1 file changed, 51 insertions(+), 43 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 66e59e6..9e2d08b 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -94,30 +94,7 @@ extern void trace_call_function_single_interrupt(void);
 #define trace_kvm_posted_intr_ipi kvm_posted_intr_ipi
 #endif /* CONFIG_TRACING */
 
-/* IOAPIC */
-#define IO_APIC_IRQ(x) (((x) >= NR_IRQS_LEGACY) || ((1<<(x)) & io_apic_irqs))
-extern unsigned long io_apic_irqs;
-
-extern void setup_IO_APIC(void);
-extern void disable_IO_APIC(void);
-
-struct io_apic_irq_attr {
-	int ioapic;
-	int ioapic_pin;
-	int trigger;
-	int polarity;
-};
-
-static inline void set_io_apic_irq_attr(struct io_apic_irq_attr *irq_attr,
-					int ioapic, int ioapic_pin,
-					int trigger, int polarity)
-{
-	irq_attr->ioapic	= ioapic;
-	irq_attr->ioapic_pin	= ioapic_pin;
-	irq_attr->trigger	= trigger;
-	irq_attr->polarity	= polarity;
-}
-
+#ifdef CONFIG_IRQ_REMAP
 /* Intel specific interrupt remapping information */
 struct irq_2_iommu {
 	struct intel_iommu *iommu;
@@ -131,14 +108,10 @@ struct irq_2_irte {
 	u16 devid; /* Device ID for IRTE table */
 	u16 index; /* Index into IRTE table*/
 };
+#endif	/* CONFIG_IRQ_REMAP */
 
-/*
- * This is performance-critical, we want to do it O(1)
- *
- * Most irqs are mapped 1:1 with pins.
- */
+#ifdef	CONFIG_X86_LOCAL_APIC
 struct irq_cfg {
-	struct list_head	irq_2_pin;
 	cpumask_var_t		domain;
 	cpumask_var_t		old_domain;
 	u8			vector;
@@ -150,8 +123,16 @@ struct irq_cfg {
 		struct irq_2_irte  irq_2_irte;
 	};
 #endif
+	union {
+#ifdef CONFIG_X86_IO_APIC
+		struct {
+			struct list_head	irq_2_pin;
+		};
+#endif
+	};
 };
 
+extern void setup_vector_irq(int cpu);
 extern int assign_irq_vector(int, struct irq_cfg *, const struct cpumask *);
 #ifdef CONFIG_SMP
 extern void send_cleanup_vector(struct irq_cfg *);
@@ -162,10 +143,48 @@ static inline void send_cleanup_vector(struct irq_cfg *c) { }
 struct irq_data;
 int __ioapic_set_affinity(struct irq_data *, const struct cpumask *,
 			  unsigned int *dest_id);
-extern int IO_APIC_get_PCI_irq_vector(int bus, int devfn, int pin);
-extern void setup_ioapic_dest(void);
+#endif	/* CONFIG_X86_LOCAL_APIC */
+
+#ifdef CONFIG_X86_IO_APIC
+extern void lock_vector_lock(void);
+extern void unlock_vector_lock(void);
+extern void __setup_vector_irq(int cpu);
+#else
+static inline void lock_vector_lock(void) {}
+static inline void unlock_vector_lock(void) {}
+static inline void __setup_vector_irq(int cpu) {}
+#endif
+
+/* IOAPIC */
+#ifdef CONFIG_X86_IO_APIC
+struct io_apic_irq_attr {
+	int ioapic;
+	int ioapic_pin;
+	int trigger;
+	int polarity;
+};
+
+static inline void set_io_apic_irq_attr(struct io_apic_irq_attr *irq_attr,
+					int ioapic, int ioapic_pin,
+					int trigger, int polarity)
+{
+	irq_attr->ioapic	= ioapic;
+	irq_attr->ioapic_pin	= ioapic_pin;
+	irq_attr->trigger	= trigger;
+	irq_attr->polarity	= polarity;
+}
 
+extern void setup_IO_APIC(void);
 extern void enable_IO_APIC(void);
+extern void disable_IO_APIC(void);
+extern void setup_ioapic_dest(void);
+extern int IO_APIC_get_PCI_irq_vector(int bus, int devfn, int pin);
+
+extern unsigned long io_apic_irqs;
+#define IO_APIC_IRQ(x) (((x) >= NR_IRQS_LEGACY) || ((1 << (x)) & io_apic_irqs))
+#else	/* CONFIG_X86_IO_APIC */
+#define IO_APIC_IRQ(x)	0
+#endif	/* CONFIG_X86_IO_APIC */
 
 /* Statistics */
 extern atomic_t irq_err_count;
@@ -200,17 +219,6 @@ extern void (*__initconst interrupt[FIRST_SYSTEM_VECTOR
 
 typedef int vector_irq_t[NR_VECTORS];
 DECLARE_PER_CPU(vector_irq_t, vector_irq);
-extern void setup_vector_irq(int cpu);
-
-#ifdef CONFIG_X86_IO_APIC
-extern void lock_vector_lock(void);
-extern void unlock_vector_lock(void);
-extern void __setup_vector_irq(int cpu);
-#else
-static inline void lock_vector_lock(void) {}
-static inline void unlock_vector_lock(void) {}
-static inline void __setup_vector_irq(int cpu) {}
-#endif
 
 #endif /* !ASSEMBLY_ */
 
