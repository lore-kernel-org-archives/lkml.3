Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbaKZXWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:22:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59241 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105AbaKZXWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:22:51 -0500
Date: Wed, 26 Nov 2014 15:21:57 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-9523785062ca8b0f2fdaddc5718d71adfc0d15b3@git.kernel.org>
Cc: benh@kernel.crashing.org, jroedel@suse.de, mingo@kernel.org,
        JBeulich@suse.com, gregkh@linuxfoundation.org, joro@8bytes.org,
        tony.luck@intel.com, bhelgaas@google.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com, jiang.liu@linux.intel.com, rjw@rjwysocki.net,
        konrad.wilk@oracle.com, tglx@linutronix.de, yinghai@kernel.org,
        bp@alien8.de, rdunlap@infradead.org
Reply-To: mingo@kernel.org, benh@kernel.crashing.org, jroedel@suse.de,
        gregkh@linuxfoundation.org, joro@8bytes.org, JBeulich@suse.com,
        bhelgaas@google.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tony.luck@intel.com, bp@alien8.de, rdunlap@infradead.org,
        tglx@linutronix.de, konrad.wilk@oracle.com, yinghai@kernel.org,
        jiang.liu@linux.intel.com, rjw@rjwysocki.net
In-Reply-To: <1416901802-24211-36-git-send-email-jiang.liu@linux.intel.com>
References: <1416901802-24211-36-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq: Refine the way to calculate NR_IRQS
Git-Commit-ID: 9523785062ca8b0f2fdaddc5718d71adfc0d15b3
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

Commit-ID:  9523785062ca8b0f2fdaddc5718d71adfc0d15b3
Gitweb:     http://git.kernel.org/tip/9523785062ca8b0f2fdaddc5718d71adfc0d15b3
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 15:49:59 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 23:52:49 +0100

x86, irq: Refine the way to calculate NR_IRQS

Now we have made MSI independent of IOAPIC, so we need to refine the
way to calculate NR_IRQS to support configuration with MSI enabled but
IOAPIC disabled.

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
Cc: Jan Beulich <JBeulich@suse.com>
Link: http://lkml.kernel.org/r/1416901802-24211-36-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/irq_vectors.h | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 666c89e..b26cb12 100644
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
