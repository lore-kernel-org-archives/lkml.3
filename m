Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbaIKIX2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:23:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:19478 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753306AbaIKIXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:23:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,504,1406617200"; 
   d="scan'208";a="571629199"
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
Subject: [RFC Part1 v1 12/18] x86, irq: Move IOAPIC related declarations from hw_irq.h into io_apic.h
Date: Thu, 11 Sep 2014 16:24:59 +0800
Message-Id: <1410423905-26239-13-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1410423905-26239-1-git-send-email-jiang.liu@linux.intel.com>
References: <1410423905-26239-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up code by moving IOAPIC related declarations from hw_irq.h into
io_apic.h.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/hw_irq.h  |   33 ---------------------------------
 arch/x86/include/asm/io_apic.h |   23 ++++++++++++++++++++---
 arch/x86/kernel/apic/io_apic.c |   10 ++++++++++
 3 files changed, 30 insertions(+), 36 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index dca760e9cd12..7624fffc2822 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -154,39 +154,6 @@ static inline void lock_vector_lock(void) {}
 static inline void unlock_vector_lock(void) {}
 #endif	/* CONFIG_X86_LOCAL_APIC */
 
-/* IOAPIC */
-#ifdef CONFIG_X86_IO_APIC
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
-extern void setup_IO_APIC(void);
-extern void enable_IO_APIC(void);
-extern void disable_IO_APIC(void);
-extern void setup_ioapic_dest(void);
-extern int IO_APIC_get_PCI_irq_vector(int bus, int devfn, int pin);
-extern void print_IO_APICs(void);
-
-extern unsigned long io_apic_irqs;
-#define IO_APIC_IRQ(x) (((x) >= NR_IRQS_LEGACY) || ((1 << (x)) & io_apic_irqs))
-#else	/* CONFIG_X86_IO_APIC */
-#define IO_APIC_IRQ(x)	0
-static inline void print_IO_APICs(void) {}
-#endif	/* CONFIG_X86_IO_APIC */
-
 /* Statistics */
 extern atomic_t irq_err_count;
 extern atomic_t irq_mis_count;
diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index a2245cb5ca3f..533803dc3733 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -132,6 +132,10 @@ extern int noioapicquirk;
 /* -1 if "noapic" boot option passed */
 extern int noioapicreroute;
 
+extern unsigned long io_apic_irqs;
+
+#define IO_APIC_IRQ(x) (((x) >= NR_IRQS_LEGACY) || ((1 << (x)) & io_apic_irqs))
+
 /*
  * If we use the IO-APIC for IRQ routing, disable automatic
  * assignment of PCI IRQ's.
@@ -139,7 +143,6 @@ extern int noioapicreroute;
 #define io_apic_assign_pci_irqs \
 	(mp_irq_entries && !skip_ioapic_setup && io_apic_irqs)
 
-struct io_apic_irq_attr;
 struct irq_cfg;
 extern void ioapic_insert_resources(void);
 
@@ -157,6 +160,13 @@ extern int restore_ioapic_entries(void);
 extern void setup_ioapic_ids_from_mpc(void);
 extern void setup_ioapic_ids_from_mpc_nocheck(void);
 
+struct io_apic_irq_attr {
+	int ioapic;
+	int ioapic_pin;
+	int trigger;
+	int polarity;
+};
+
 enum ioapic_domain_type {
 	IOAPIC_DOMAIN_INVALID,
 	IOAPIC_DOMAIN_LEGACY,
@@ -196,6 +206,7 @@ extern int mp_set_gsi_attr(u32 gsi, int trigger, int polarity, int node);
 extern void __init pre_init_apic_IRQ0(void);
 
 extern void mp_save_irq(struct mpc_intsrc *m);
+extern bool mp_should_keep_irq(struct device *dev);
 
 extern void disable_ioapic_support(void);
 
@@ -226,13 +237,19 @@ static inline void io_apic_modify(unsigned int apic, unsigned int reg, unsigned
 
 extern void io_apic_eoi(unsigned int apic, unsigned int vector);
 
-extern bool mp_should_keep_irq(struct device *dev);
-
+extern void setup_IO_APIC(void);
+extern void enable_IO_APIC(void);
+extern void disable_IO_APIC(void);
+extern void setup_ioapic_dest(void);
+extern int IO_APIC_get_PCI_irq_vector(int bus, int devfn, int pin);
+extern void print_IO_APICs(void);
 #else  /* !CONFIG_X86_IO_APIC */
 
+#define IO_APIC_IRQ(x)		0
 #define io_apic_assign_pci_irqs 0
 #define setup_ioapic_ids_from_mpc x86_init_noop
 static inline void ioapic_insert_resources(void) { }
+static inline void print_IO_APICs(void) {}
 #define gsi_top (NR_IRQS_LEGACY)
 static inline int mp_find_ioapic(u32 gsi) { return 0; }
 static inline u32 mp_pin_to_gsi(int ioapic, int pin) { return UINT_MAX; }
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index bca60cd61950..e2b3e8b40fcb 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3014,6 +3014,16 @@ int mp_ioapic_registered(u32 gsi_base)
 	return 0;
 }
 
+static inline void set_io_apic_irq_attr(struct io_apic_irq_attr *irq_attr,
+					int ioapic, int ioapic_pin,
+					int trigger, int polarity)
+{
+	irq_attr->ioapic	= ioapic;
+	irq_attr->ioapic_pin	= ioapic_pin;
+	irq_attr->trigger	= trigger;
+	irq_attr->polarity	= polarity;
+}
+
 int mp_irqdomain_map(struct irq_domain *domain, unsigned int virq,
 		     irq_hw_number_t hwirq)
 {
-- 
1.7.10.4

