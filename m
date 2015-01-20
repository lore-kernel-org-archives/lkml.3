Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663AbbATF5K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 00:57:10 -0500
Received: from mga11.intel.com ([192.55.52.93]:65495 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721AbbATF4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 00:56:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,432,1418112000"; 
   d="scan'208";a="664448706"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Dimitri Sivanich <sivanich@sgi.com>,
        x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Andy Lutomirski <luto@amacapital.net>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [Patch Part2 v4 32/33] x86/irq: Move irqdomain specific code into asm/irqdomain.h
Date: Tue, 20 Jan 2015 13:51:52 +0800
Message-Id: <1421733113-15704-33-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421733113-15704-1-git-send-email-jiang.liu@linux.intel.com>
References: <1421733113-15704-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we have dedicated asm/irqdomain.h, so move irqdomain specific
code into it.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/hw_irq.h        |   24 -----------------------
 arch/x86/include/asm/irq_remapping.h |    2 +-
 arch/x86/include/asm/irqdomain.h     |   35 +++++++++++++++++++++++++++++++---
 arch/x86/kernel/apic/htirq.c         |    2 +-
 arch/x86/kernel/apic/msi.c           |    2 +-
 arch/x86/kernel/apic/vector.c        |    2 +-
 arch/x86/kernel/hpet.c               |    2 +-
 arch/x86/platform/uv/uv_irq.c        |    2 +-
 8 files changed, 38 insertions(+), 33 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index e7ae6eb84934..f671d4331e7e 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -94,8 +94,6 @@ extern void trace_call_function_single_interrupt(void);
 #define trace_kvm_posted_intr_ipi kvm_posted_intr_ipi
 #endif /* CONFIG_TRACING */
 
-struct irq_domain;
-
 #ifdef	CONFIG_X86_LOCAL_APIC
 struct irq_data;
 struct pci_dev;
@@ -165,22 +163,11 @@ struct irq_alloc_info {
 	};
 };
 
-enum {
-	/* Allocate contigious CPU vectors */
-	X86_IRQ_ALLOC_CONTIGOUS_VECTORS		= 0x1,
-};
-
 struct irq_cfg {
 	unsigned int		dest_apicid;
 	u8			vector;
 };
 
-extern struct irq_domain *x86_vector_domain;
-
-extern void init_irq_alloc_info(struct irq_alloc_info *info,
-				const struct cpumask *mask);
-extern void copy_irq_alloc_info(struct irq_alloc_info *dst,
-				struct irq_alloc_info *src);
 extern struct irq_cfg *irq_cfg(unsigned int irq);
 extern struct irq_cfg *irqd_cfg(struct irq_data *irq_data);
 extern void lock_vector_lock(void);
@@ -200,17 +187,6 @@ static inline void lock_vector_lock(void) {}
 static inline void unlock_vector_lock(void) {}
 #endif	/* CONFIG_X86_LOCAL_APIC */
 
-#ifdef	CONFIG_PCI_MSI
-extern void arch_init_msi_domain(struct irq_domain *domain);
-#else
-static inline void arch_init_msi_domain(struct irq_domain *domain) { }
-#endif
-#ifdef	CONFIG_HT_IRQ
-extern void arch_init_htirq_domain(struct irq_domain *domain);
-#else
-static inline void arch_init_htirq_domain(struct irq_domain *domain) { }
-#endif
-
 /* Statistics */
 extern atomic_t irq_err_count;
 extern atomic_t irq_mis_count;
diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index 022cb635c294..8fe217ba8218 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -22,7 +22,7 @@
 #ifndef __X86_IRQ_REMAPPING_H
 #define __X86_IRQ_REMAPPING_H
 
-#include <linux/irqdomain.h>
+#include <asm/irqdomain.h>
 #include <asm/hw_irq.h>
 #include <asm/io_apic.h>
 
diff --git a/arch/x86/include/asm/irqdomain.h b/arch/x86/include/asm/irqdomain.h
index fe0d4c6636ec..ae941c3f8c51 100644
--- a/arch/x86/include/asm/irqdomain.h
+++ b/arch/x86/include/asm/irqdomain.h
@@ -2,6 +2,25 @@
 #define _ASM_IRQDOMAIN_H
 
 #include <linux/irqdomain.h>
+#include <asm/hw_irq.h>
+
+#ifdef CONFIG_X86_LOCAL_APIC
+enum {
+	/* Allocate contigious CPU vectors */
+	X86_IRQ_ALLOC_CONTIGOUS_VECTORS		= 0x1,
+};
+
+extern struct irq_domain *x86_vector_domain;
+
+extern void init_irq_alloc_info(struct irq_alloc_info *info,
+				const struct cpumask *mask);
+extern void copy_irq_alloc_info(struct irq_alloc_info *dst,
+				struct irq_alloc_info *src);
+#endif /* CONFIG_X86_LOCAL_APIC */
+
+#ifdef CONFIG_X86_IO_APIC
+struct device_node;
+struct irq_data;
 
 enum ioapic_domain_type {
 	IOAPIC_DOMAIN_INVALID,
@@ -10,9 +29,6 @@ enum ioapic_domain_type {
 	IOAPIC_DOMAIN_DYNAMIC,
 };
 
-struct device_node;
-struct irq_data;
-
 struct ioapic_domain_cfg {
 	enum ioapic_domain_type		type;
 	const struct irq_domain_ops	*ops;
@@ -30,5 +46,18 @@ extern void mp_irqdomain_activate(struct irq_domain *domain,
 extern void mp_irqdomain_deactivate(struct irq_domain *domain,
 				    struct irq_data *irq_data);
 extern int mp_irqdomain_ioapic_idx(struct irq_domain *domain);
+#endif /* CONFIG_X86_IO_APIC */
+
+#ifdef CONFIG_PCI_MSI
+extern void arch_init_msi_domain(struct irq_domain *domain);
+#else
+static inline void arch_init_msi_domain(struct irq_domain *domain) { }
+#endif
+
+#ifdef CONFIG_HT_IRQ
+extern void arch_init_htirq_domain(struct irq_domain *domain);
+#else
+static inline void arch_init_htirq_domain(struct irq_domain *domain) { }
+#endif
 
 #endif
diff --git a/arch/x86/kernel/apic/htirq.c b/arch/x86/kernel/apic/htirq.c
index 4ba6b3ae7a95..94bca925bf7d 100644
--- a/arch/x86/kernel/apic/htirq.c
+++ b/arch/x86/kernel/apic/htirq.c
@@ -16,7 +16,7 @@
 #include <linux/device.h>
 #include <linux/pci.h>
 #include <linux/htirq.h>
-#include <linux/irqdomain.h>
+#include <asm/irqdomain.h>
 #include <asm/hw_irq.h>
 #include <asm/apic.h>
 #include <asm/hypertransport.h>
diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index da163da5fdee..4ca80bbcd632 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -16,7 +16,7 @@
 #include <linux/dmar.h>
 #include <linux/hpet.h>
 #include <linux/msi.h>
-#include <linux/irqdomain.h>
+#include <asm/irqdomain.h>
 #include <asm/msidef.h>
 #include <asm/hpet.h>
 #include <asm/hw_irq.h>
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index 0e7c39beefed..f5eb3999383f 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -13,8 +13,8 @@
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/compiler.h>
-#include <linux/irqdomain.h>
 #include <linux/slab.h>
+#include <asm/irqdomain.h>
 #include <asm/hw_irq.h>
 #include <asm/apic.h>
 #include <asm/i8259.h>
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index a22d7288202b..5f5cc2c061c6 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -11,8 +11,8 @@
 #include <linux/cpu.h>
 #include <linux/pm.h>
 #include <linux/io.h>
-#include <linux/irqdomain.h>
 
+#include <asm/irqdomain.h>
 #include <asm/fixmap.h>
 #include <asm/hpet.h>
 #include <asm/time.h>
diff --git a/arch/x86/platform/uv/uv_irq.c b/arch/x86/platform/uv/uv_irq.c
index 091b36ac44c4..cdf86cd3fd97 100644
--- a/arch/x86/platform/uv/uv_irq.c
+++ b/arch/x86/platform/uv/uv_irq.c
@@ -12,8 +12,8 @@
 #include <linux/rbtree.h>
 #include <linux/slab.h>
 #include <linux/irq.h>
-#include <linux/irqdomain.h>
 
+#include <asm/irqdomain.h>
 #include <asm/apic.h>
 #include <asm/uv/uv_irq.h>
 #include <asm/uv/uv_hub.h>
-- 
1.7.10.4

