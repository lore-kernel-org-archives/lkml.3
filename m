Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbaIZN2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 09:28:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:49154 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754742AbaIZN2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 09:28:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,604,1406617200"; 
   d="scan'208";a="597257941"
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
Subject: [Patch v2 12/18] x86, irq: Move IOAPIC related declarations from hw_irq.h into io_apic.h
Date: Fri, 26 Sep 2014 21:29:49 +0800
Message-Id: <1411738196-29958-13-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1411738196-29958-1-git-send-email-jiang.liu@linux.intel.com>
References: <1411738196-29958-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up code by moving IOAPIC related declarations from hw_irq.h into
io_apic.h.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/hw_irq.h      |   33 ---------------------------------
 arch/x86/include/asm/io_apic.h     |   23 ++++++++++++++++++++---
 arch/x86/kernel/apic/io_apic.c     |   10 ++++++++++
 arch/x86/kernel/crash.c            |    1 +
 arch/x86/kernel/machine_kexec_32.c |    1 +
 arch/x86/kernel/machine_kexec_64.c |    1 +
 arch/x86/kernel/reboot.c           |    1 +
 7 files changed, 34 insertions(+), 36 deletions(-)

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
index 0741d864612a..3fc4f540ef0f 100644
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
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index a618fcd2c07d..71bdb8cf8ba1 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -28,6 +28,7 @@
 #include <asm/nmi.h>
 #include <asm/hw_irq.h>
 #include <asm/apic.h>
+#include <asm/io_apic.h>
 #include <asm/hpet.h>
 #include <linux/kdebug.h>
 #include <asm/cpu.h>
diff --git a/arch/x86/kernel/machine_kexec_32.c b/arch/x86/kernel/machine_kexec_32.c
index 1667b1de8d5d..aad1a49e69c3 100644
--- a/arch/x86/kernel/machine_kexec_32.c
+++ b/arch/x86/kernel/machine_kexec_32.c
@@ -20,6 +20,7 @@
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
 #include <asm/apic.h>
+#include <asm/io_apic.h>
 #include <asm/cpufeature.h>
 #include <asm/desc.h>
 #include <asm/cacheflush.h>
diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index 485981059a40..415480d3ea84 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -22,6 +22,7 @@
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
+#include <asm/io_apic.h>
 #include <asm/debugreg.h>
 #include <asm/kexec-bzimage64.h>
 
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 17962e667a91..bae6c609888e 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -12,6 +12,7 @@
 #include <acpi/reboot.h>
 #include <asm/io.h>
 #include <asm/apic.h>
+#include <asm/io_apic.h>
 #include <asm/desc.h>
 #include <asm/hpet.h>
 #include <asm/pgtable.h>
-- 
1.7.10.4

