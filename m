Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757081Ab3ARMe4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 07:34:56 -0500
Received: from us01smtp2.synopsys.com ([198.182.44.80]:61763 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756861Ab3ARMez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 07:34:55 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Gilad Ben-Yossef <gilad@benyossef.com>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Noam Camus <noamc@ezchip.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH v2 66/76] ARC: Add support for ioremap_prot API
Date: Fri, 18 Jan 2013 17:55:20 +0530
Message-ID: <1358511930-7424-67-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1358511930-7424-1-git-send-email-vgupta@synopsys.com>
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gilad Ben-Yossef <gilad@benyossef.com>

Implement ioremap_prot() to allow mapping IO memory with variable protection
via TLB.

Implementing this allows the /dev/mem driver to use its generic access()
VMA callback, which in turn allows ptrace to examine data in memory
mapped regions mapped via /dev/mem, such as Arc DCCM.

The end result is that it is possible to examine values of variables
placed into DCCM in user space programs via GDB.

CC: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
CC: Noam Camus <noamc@ezchip.com>
Acked-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/Kconfig            |    1 +
 arch/arc/include/asm/io.h   |    2 +
 arch/arc/include/asm/page.h |    3 ++
 arch/arc/mm/ioremap.c       |   58 ++++++++++++++++++++++++++++++------------
 4 files changed, 47 insertions(+), 17 deletions(-)

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index 9202c1a..d73e69b 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -26,6 +26,7 @@ config ARC
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_GENERIC_HARDIRQS
+	select HAVE_IOREMAP_PROT
 	select HAVE_IRQ_WORK
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
diff --git a/arch/arc/include/asm/io.h b/arch/arc/include/asm/io.h
index b2221f5..9ae833c 100644
--- a/arch/arc/include/asm/io.h
+++ b/arch/arc/include/asm/io.h
@@ -13,6 +13,8 @@
 #include <asm/page.h>
 
 extern void __iomem *ioremap(unsigned long physaddr, unsigned long size);
+extern void __iomem *ioremap_prot(phys_addr_t offset, unsigned long size,
+				  unsigned long flags);
 extern void iounmap(const void __iomem *addr);
 
 #define ioremap_nocache(phy, sz)	ioremap(phy, sz)
diff --git a/arch/arc/include/asm/page.h b/arch/arc/include/asm/page.h
index dfe1f8a..bdf5461 100644
--- a/arch/arc/include/asm/page.h
+++ b/arch/arc/include/asm/page.h
@@ -48,6 +48,8 @@ typedef unsigned long pgtable_t;
 #define __pgd(x)        ((pgd_t) { (x) })
 #define __pgprot(x)     ((pgprot_t) { (x) })
 
+#define pte_pgprot(x) __pgprot(pte_val(x))
+
 #else /* !STRICT_MM_TYPECHECKS */
 
 typedef unsigned long pte_t;
@@ -60,6 +62,7 @@ typedef unsigned long pgtable_t;
 #define pgprot_val(x)	(x)
 #define __pte(x)	(x)
 #define __pgprot(x)	(x)
+#define pte_pgprot(x)	(x)
 
 #endif
 
diff --git a/arch/arc/mm/ioremap.c b/arch/arc/mm/ioremap.c
index a82ec3a..1cc3bc4 100644
--- a/arch/arc/mm/ioremap.c
+++ b/arch/arc/mm/ioremap.c
@@ -15,24 +15,48 @@
 
 void __iomem *ioremap(unsigned long paddr, unsigned long size)
 {
-	unsigned long vaddr;
-	struct vm_struct *area;
-	unsigned long off, end;
-	const pgprot_t prot = PAGE_KERNEL_NO_CACHE;
+	unsigned long end;
 
 	/* Don't allow wraparound or zero size */
 	end = paddr + size - 1;
 	if (!size || (end < paddr))
 		return NULL;
 
-	/* If the region is h/w uncached, nothing special needed */
+	/* If the region is h/w uncached, avoid MMU mappings */
 	if (paddr >= ARC_UNCACHED_ADDR_SPACE)
 		return (void __iomem *)paddr;
 
-	/* Mappings have to be page-aligned, page-sized */
-	off = paddr & ~PAGE_MASK;
-	paddr &= PAGE_MASK;
-	size = PAGE_ALIGN(end + 1) - paddr;
+	return ioremap_prot(paddr, size, PAGE_KERNEL_NO_CACHE);
+}
+EXPORT_SYMBOL(ioremap);
+
+/*
+ * ioremap with access flags
+ * Cache semantics wise it is same as ioremap - "forced" uncached.
+ * However unline vanilla ioremap which bypasses ARC MMU for addresses in
+ * ARC hardware uncached region, this one still goes thru the MMU as caller
+ * might need finer access control (R/W/X)
+ */
+void __iomem *ioremap_prot(phys_addr_t phys_addr, unsigned long size,
+			   unsigned long flags)
+{
+	void __iomem *addr;
+	struct vm_struct *area;
+	unsigned long offset, last_addr;
+	pgprot_t prot = __pgprot(flags);
+
+	/* Don't allow wraparound, zero size */
+	last_addr = phys_addr + size - 1;
+	if ((!size) || (last_addr < phys_addr))
+		return NULL;
+
+	/* force uncached */
+	prot = pgprot_noncached(prot);
+
+	/* Mappings have to be page-aligned */
+	offset = phys_addr & ~PAGE_MASK;
+	phys_addr &= PAGE_MASK;
+	size = PAGE_ALIGN(last_addr + 1) - phys_addr;
 
 	/*
 	 * Ok, go for it..
@@ -40,17 +64,17 @@ void __iomem *ioremap(unsigned long paddr, unsigned long size)
 	area = get_vm_area(size, VM_IOREMAP);
 	if (!area)
 		return NULL;
-
-	area->phys_addr = paddr;
-	vaddr = (unsigned long)area->addr;
-	if (ioremap_page_range(vaddr, vaddr + size, paddr, prot)) {
-		vfree(area->addr);
+	area->phys_addr = phys_addr;
+	addr = (void __iomem *)area->addr;
+	if (ioremap_page_range((unsigned long)addr,
+			       (unsigned long)addr + size, phys_addr, prot)) {
+		vunmap((void __force *)addr);
 		return NULL;
 	}
-
-	return (void __iomem *)(off + (char __iomem *)vaddr);
+	return (void __iomem *)(offset + (char __iomem *)addr);
 }
-EXPORT_SYMBOL(ioremap);
+EXPORT_SYMBOL(ioremap_prot);
+
 
 void iounmap(const void __iomem *addr)
 {
-- 
1.7.4.1

