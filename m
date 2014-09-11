Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbaIKIao (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:30:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:19404 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954AbaIKIWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:22:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,504,1406617200"; 
   d="scan'208";a="571628978"
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
Subject: [RFC Part1 v1 04/18] x86, irq: Refine hw_irq.h to prepare for irqdomain support
Date: Thu, 11 Sep 2014 16:24:51 +0800
Message-Id: <1410423905-26239-5-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1410423905-26239-1-git-send-email-jiang.liu@linux.intel.com>
References: <1410423905-26239-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refine hw_irq.h to prepare for irqdomain support by:
1) guarding common APIC related interfaces with CONFIG_X86_LOCAL_APIC
2) guarding interrupt remapping related interfaces with CONFIG_IRQ_REMAP
3) guarding IOAPIC related interfaces with CONFIG_X86_IO_APIC

There should be no functional changes.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/hw_irq.h |   94 ++++++++++++++++++++++-------------------
 1 file changed, 51 insertions(+), 43 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 28f283988c8e..8188d648d48c 100644
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
@@ -150,18 +123,64 @@ struct irq_cfg {
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
 extern void send_cleanup_vector(struct irq_cfg *);
 
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
@@ -195,17 +214,6 @@ extern void (*__initconst interrupt[NR_VECTORS-FIRST_EXTERNAL_VECTOR])(void);
 
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
 
-- 
1.7.10.4

