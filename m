Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab3AXK5H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:57:07 -0500
Received: from alvesta.synopsys.com ([198.182.60.77]:42551 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474Ab3AXK4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:56:18 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Gilad Ben-Yossef <gilad@benyossef.com>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Noam Camus <noamc@ezchip.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH v3 59/71] ARC: Add support for ioremap_prot API
Date: Thu, 24 Jan 2013 16:20:36 +0530
Message-ID: <1359024639-21915-23-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359024639-21915-1-git-send-email-vgupta@synopsys.com>
References: <1359024639-21915-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gilad Ben-Yossef <gilad@benyossef.com>

Implement ioremap_prot() to allow mapping IO memory with variable
protection
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
 arch/arc/mm/ioremap.c       |   48 ++++++++++++++++++++++++++++++++----------
 4 files changed, 42 insertions(+), 12 deletions(-)

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index cd4ad61..2dab40d 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -25,6 +25,7 @@ config ARC
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_GENERIC_HARDIRQS
+	select HAVE_IOREMAP_PROT
 	select HAVE_IRQ_WORK
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
diff --git a/arch/arc/include/asm/io.h b/arch/arc/include/asm/io.h
index d20051b..473424d 100644
--- a/arch/arc/include/asm/io.h
+++ b/arch/arc/include/asm/io.h
@@ -16,6 +16,8 @@
 #define PCI_IOBASE ((void __iomem *)0)
 
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
index 52518b6..3e5c92c 100644
--- a/arch/arc/mm/ioremap.c
+++ b/arch/arc/mm/ioremap.c
@@ -16,25 +16,49 @@
 
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
+void __iomem *ioremap_prot(phys_addr_t paddr, unsigned long size,
+			   unsigned long flags)
+{
+	void __iomem *vaddr;
+	struct vm_struct *area;
+	unsigned long off, end;
+	pgprot_t prot = __pgprot(flags);
+
+	/* Don't allow wraparound, zero size */
+	end = paddr + size - 1;
+	if ((!size) || (end < paddr))
+		return NULL;
+
 	/* An early platform driver might end up here */
 	if (!slab_is_available())
 		return NULL;
 
-	/* Mappings have to be page-aligned, page-sized */
+	/* force uncached */
+	prot = pgprot_noncached(prot);
+
+	/* Mappings have to be page-aligned */
 	off = paddr & ~PAGE_MASK;
 	paddr &= PAGE_MASK;
 	size = PAGE_ALIGN(end + 1) - paddr;
@@ -45,17 +69,17 @@ void __iomem *ioremap(unsigned long paddr, unsigned long size)
 	area = get_vm_area(size, VM_IOREMAP);
 	if (!area)
 		return NULL;
-
 	area->phys_addr = paddr;
-	vaddr = (unsigned long)area->addr;
-	if (ioremap_page_range(vaddr, vaddr + size, paddr, prot)) {
-		vfree(area->addr);
+	vaddr = (void __iomem *)area->addr;
+	if (ioremap_page_range((unsigned long)vaddr,
+			       (unsigned long)vaddr + size, paddr, prot)) {
+		vunmap((void __force *)vaddr);
 		return NULL;
 	}
-
 	return (void __iomem *)(off + (char __iomem *)vaddr);
 }
-EXPORT_SYMBOL(ioremap);
+EXPORT_SYMBOL(ioremap_prot);
+
 
 void iounmap(const void __iomem *addr)
 {
-- 
1.7.4.1

