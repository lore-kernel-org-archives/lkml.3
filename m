Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab3AVVZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 16:25:11 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:39213 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654Ab3AVVZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 16:25:01 -0500
Subject: [PATCH 4/5] create slow_virt_to_phys()
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Gleb Natapov <gleb@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>, Rik van Riel <riel@redhat.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Tue, 22 Jan 2013 13:24:33 -0800
References: <20130122212428.8DF70119@kernel.stglabs.ibm.com>
In-Reply-To: <20130122212428.8DF70119@kernel.stglabs.ibm.com>
Message-Id: <20130122212433.4D1FCA62@kernel.stglabs.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012221-9360-0000-0000-00000F8F1A79
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is necessary because __pa() does not work on some kinds of
memory, like vmalloc() or the alloc_remap() areas on 32-bit
NUMA systems.  We have some functions to do conversions _like_
this in the vmalloc() code (like vmalloc_to_page()), but they
do not work on sizes other than 4k pages.  We would potentially
need to be able to handle all the page sizes that we use for
the kernel linear mapping (4k, 2M, 1G).

In practice, on 32-bit NUMA systems, the percpu areas get stuck
in the alloc_remap() area.  Any __pa() call on them will break
and basically return garbage.

This patch introduces a new function slow_virt_to_phys(), which
walks the kernel page tables on x86 and should do precisely
the same logical thing as __pa(), but actually work on a wider
range of memory.  It should work on the normal linear mapping,
vmalloc(), kmap(), etc...

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Acked-by: Rik van Riel <riel@redhat.com>
---

 linux-2.6.git-dave/arch/x86/include/asm/pgtable_types.h |    1 
 linux-2.6.git-dave/arch/x86/mm/pageattr.c               |   31 ++++++++++++++++
 2 files changed, 32 insertions(+)

diff -puN arch/x86/include/asm/pgtable_types.h~create-slow_virt_to_phys arch/x86/include/asm/pgtable_types.h
--- linux-2.6.git/arch/x86/include/asm/pgtable_types.h~create-slow_virt_to_phys	2013-01-22 13:17:16.100314776 -0800
+++ linux-2.6.git-dave/arch/x86/include/asm/pgtable_types.h	2013-01-22 13:17:16.104314809 -0800
@@ -352,6 +352,7 @@ static inline void update_page_count(int
  * as a pte too.
  */
 extern pte_t *lookup_address(unsigned long address, unsigned int *level);
+extern phys_addr_t slow_virt_to_phys(void *__address);
 
 #endif	/* !__ASSEMBLY__ */
 
diff -puN arch/x86/mm/pageattr.c~create-slow_virt_to_phys arch/x86/mm/pageattr.c
--- linux-2.6.git/arch/x86/mm/pageattr.c~create-slow_virt_to_phys	2013-01-22 13:17:16.100314776 -0800
+++ linux-2.6.git-dave/arch/x86/mm/pageattr.c	2013-01-22 13:17:16.104314809 -0800
@@ -364,6 +364,37 @@ pte_t *lookup_address(unsigned long addr
 EXPORT_SYMBOL_GPL(lookup_address);
 
 /*
+ * This is necessary because __pa() does not work on some
+ * kinds of memory, like vmalloc() or the alloc_remap()
+ * areas on 32-bit NUMA systems.  The percpu areas can
+ * end up in this kind of memory, for instance.
+ *
+ * This could be optimized, but it is only intended to be
+ * used at inititalization time, and keeping it
+ * unoptimized should increase the testing coverage for
+ * the more obscure platforms.
+ */
+phys_addr_t slow_virt_to_phys(void *__virt_addr)
+{
+	unsigned long virt_addr = (unsigned long)__virt_addr;
+	phys_addr_t phys_addr;
+	unsigned long offset;
+	enum pg_level level;
+	unsigned long psize;
+	unsigned long pmask;
+	pte_t *pte;
+
+	pte = lookup_address(virt_addr, &level);
+	BUG_ON(!pte);
+	psize = page_level_size(level);
+	pmask = page_level_mask(level);
+	offset = virt_addr & ~pmask;
+	phys_addr = pte_pfn(*pte) << PAGE_SHIFT;
+	return (phys_addr | offset);
+}
+EXPORT_SYMBOL_GPL(slow_virt_to_phys);
+
+/*
  * Set the new pmd in all the pgds we know about:
  */
 static void __set_pmd_pte(pte_t *kpte, unsigned long address, pte_t pte)
_

