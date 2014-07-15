Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933635AbaGOTp1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 15:45:27 -0400
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:38533 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933367AbaGOTpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 15:45:22 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
        akpm@linux-foundation.org, arnd@arndb.de, konrad.wilk@oracle.com,
        plagnioj@jcrosoft.com, tomi.valkeinen@ti.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stefan.bader@canonical.com, luto@amacapital.net, airlied@gmail.com,
        bp@alien8.de, Toshi Kani <toshi.kani@hp.com>
Subject: [RFC PATCH 4/11] x86, mm, asm-gen: Add ioremap_wt() for WT mapping
Date: Tue, 15 Jul 2014 13:34:37 -0600
Message-Id: <1405452884-25688-5-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1405452884-25688-1-git-send-email-toshi.kani@hp.com>
References: <1405452884-25688-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces ioremap_wt() for creating WT maps on x86.
It follows the same model as ioremap_wc() for multi-architecture
support.  ARCH_HAS_IOREMAP_WT is defined in x86's io.h to indicate
that ioremap_wt() is implemented on x86.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 arch/x86/include/asm/io.h   |    2 ++
 arch/x86/mm/ioremap.c       |   23 +++++++++++++++++++++++
 include/asm-generic/io.h    |    4 ++++
 include/asm-generic/iomap.h |    4 ++++
 4 files changed, 33 insertions(+)

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index b8237d8..646e367 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -35,6 +35,7 @@
   */
 
 #define ARCH_HAS_IOREMAP_WC
+#define ARCH_HAS_IOREMAP_WT
 
 #include <linux/string.h>
 #include <linux/compiler.h>
@@ -316,6 +317,7 @@ extern void unxlate_dev_mem_ptr(unsigned long phys, void *addr);
 extern int ioremap_change_attr(unsigned long vaddr, unsigned long size,
 				unsigned long prot_val);
 extern void __iomem *ioremap_wc(resource_size_t offset, unsigned long size);
+extern void __iomem *ioremap_wt(resource_size_t offset, unsigned long size);
 
 extern bool is_early_ioremap_ptep(pte_t *ptep);
 
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 282829f..d3dab0b 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -149,6 +149,9 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 	case _PAGE_CACHE_WC:
 		prot = PAGE_KERNEL_IO_WC;
 		break;
+	case _PAGE_CACHE_WT:
+		prot = PAGE_KERNEL_IO_WT;
+		break;
 	case _PAGE_CACHE_WB:
 		prot = PAGE_KERNEL_IO;
 		break;
@@ -243,6 +246,26 @@ void __iomem *ioremap_wc(resource_size_t phys_addr, unsigned long size)
 }
 EXPORT_SYMBOL(ioremap_wc);
 
+/**
+ * ioremap_wt	-	map memory into CPU space write through
+ * @phys_addr:	bus address of the memory
+ * @size:	size of the resource to map
+ *
+ * This version of ioremap ensures that the memory is marked write through.
+ * Write through provides cached reads and uncached writes.
+ *
+ * Must be freed with iounmap.
+ */
+void __iomem *ioremap_wt(resource_size_t phys_addr, unsigned long size)
+{
+	if (pat_enabled)
+		return __ioremap_caller(phys_addr, size, _PAGE_CACHE_WT,
+					__builtin_return_address(0));
+	else
+		return ioremap_nocache(phys_addr, size);
+}
+EXPORT_SYMBOL(ioremap_wt);
+
 void __iomem *ioremap_cache(resource_size_t phys_addr, unsigned long size)
 {
 	return __ioremap_caller(phys_addr, size, _PAGE_CACHE_WB,
diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index 975e1cc..03e31a7 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -322,6 +322,10 @@ static inline void __iomem *ioremap(phys_addr_t offset, unsigned long size)
 #define ioremap_wc ioremap_nocache
 #endif
 
+#ifndef ioremap_wt
+#define ioremap_wc ioremap_nocache
+#endif
+
 static inline void iounmap(void __iomem *addr)
 {
 }
diff --git a/include/asm-generic/iomap.h b/include/asm-generic/iomap.h
index 1b41011..d8f8622 100644
--- a/include/asm-generic/iomap.h
+++ b/include/asm-generic/iomap.h
@@ -66,6 +66,10 @@ extern void ioport_unmap(void __iomem *);
 #define ioremap_wc ioremap_nocache
 #endif
 
+#ifndef ARCH_HAS_IOREMAP_WT
+#define ioremap_wt ioremap_nocache
+#endif
+
 #ifdef CONFIG_PCI
 /* Destroy a virtual mapping cookie for a PCI BAR (memory or IO) */
 struct pci_dev;
