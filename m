Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101AbaKHSSf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 13:18:35 -0500
Received: from mga11.intel.com ([192.55.52.93]:30726 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932081AbaKHSSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 13:18:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="413534393"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Jiang Liu <jiang.liu@linux.intel.com>, Jan Beulich <JBeulich@suse.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [Patch Part3 v3 35/38] x86, irq: Refine the way to calculate NR_IRQS
Date: Sun,  9 Nov 2014 02:13:35 +0800
Message-Id: <1415470418-10874-36-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415470418-10874-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415470418-10874-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we have made MSI independent of IOAPIC, so we need to refine the
way to calculate NR_IRQS to support configuration with MSI enabled but
IOAPIC disabled.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/irq_vectors.h |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 666c89ec4bd7..b26cb124a4f1 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -155,18 +155,22 @@ static inline int invalid_vm86_irq(int irq)
  * static arrays.
  */
 
-#define NR_IRQS_LEGACY			  16
+#define NR_IRQS_LEGACY			16
 
-#define IO_APIC_VECTOR_LIMIT		( 32 * MAX_IO_APICS )
+#define CPU_VECTOR_LIMIT		(64 * NR_CPUS)
+#define IO_APIC_VECTOR_LIMIT		(32 * MAX_IO_APICS)
 
-#ifdef CONFIG_X86_IO_APIC
-# define CPU_VECTOR_LIMIT		(64 * NR_CPUS)
-# define NR_IRQS					\
+#if defined(CONFIG_X86_IO_APIC) && defined(CONFIG_PCI_MSI)
+#define NR_IRQS						\
 	(CPU_VECTOR_LIMIT > IO_APIC_VECTOR_LIMIT ?	\
 		(NR_VECTORS + CPU_VECTOR_LIMIT)  :	\
 		(NR_VECTORS + IO_APIC_VECTOR_LIMIT))
-#else /* !CONFIG_X86_IO_APIC: */
-# define NR_IRQS			NR_IRQS_LEGACY
+#elif defined(CONFIG_X86_IO_APIC)
+#define	NR_IRQS				(NR_VECTORS + IO_APIC_VECTOR_LIMIT)
+#elif defined(CONFIG_PCI_MSI)
+#define NR_IRQS				(NR_VECTORS + CPU_VECTOR_LIMIT)
+#else
+#define NR_IRQS				NR_IRQS_LEGACY
 #endif
 
 #endif /* _ASM_X86_IRQ_VECTORS_H */
-- 
1.7.10.4

