Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612AbaGVTBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 15:01:32 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:56760 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586AbaGVTBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 15:01:30 -0400
From: Max Filippov <jcmvbkbc@gmail.com>
To: linux-xtensa@linux-xtensa.org
Cc: Chris Zankel <chris@zankel.net>, Marc Gauthier <marc@cadence.com>,
        linux-kernel@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 4/8] xtensa: implement clear_user_highpage and copy_user_highpage
Date: Tue, 22 Jul 2014 23:01:09 +0400
Message-Id: <1406055673-10100-5-git-send-email-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1406055673-10100-1-git-send-email-jcmvbkbc@gmail.com>
References: <1406055673-10100-1-git-send-email-jcmvbkbc@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Existing clear_user_page and copy_user_page cannot be used with highmem
because they calculate physical page address from its virtual address
and do it incorrectly in case of high memory page mapped with
kmap_atomic. Also kmap is not needed, as most likely userspace mapping
color would be different from the kmapped color.

Provide clear_user_highpage and copy_user_highpage functions that
determine if temporary mapping is needed for the pages. Move most of the
logic of the former clear_user_page and copy_user_page to
xtensa/mm/cache.c only leaving temporary mapping setup, invalidation and
clearing/copying in the xtensa/mm/misc.S. Rename these functions to
clear_page_alias and copy_page_alias.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 arch/xtensa/include/asm/cacheflush.h |   2 +
 arch/xtensa/include/asm/page.h       |  12 +++-
 arch/xtensa/mm/cache.c               |  63 +++++++++++++++++++
 arch/xtensa/mm/misc.S                | 116 ++++++++++++++++-------------------
 4 files changed, 127 insertions(+), 66 deletions(-)

diff --git a/arch/xtensa/include/asm/cacheflush.h b/arch/xtensa/include/asm/cacheflush.h
index 555a98a..e72aaca 100644
--- a/arch/xtensa/include/asm/cacheflush.h
+++ b/arch/xtensa/include/asm/cacheflush.h
@@ -37,6 +37,7 @@
  * specials for cache aliasing:
  *
  * __flush_invalidate_dcache_page_alias(vaddr,paddr)
+ * __invalidate_dcache_page_alias(vaddr,paddr)
  * __invalidate_icache_page_alias(vaddr,paddr)
  */
 
@@ -62,6 +63,7 @@ extern void __flush_invalidate_dcache_range(unsigned long, unsigned long);
 
 #if defined(CONFIG_MMU) && (DCACHE_WAY_SIZE > PAGE_SIZE)
 extern void __flush_invalidate_dcache_page_alias(unsigned long, unsigned long);
+extern void __invalidate_dcache_page_alias(unsigned long, unsigned long);
 #else
 static inline void __flush_invalidate_dcache_page_alias(unsigned long virt,
 							unsigned long phys) { }
diff --git a/arch/xtensa/include/asm/page.h b/arch/xtensa/include/asm/page.h
index 47f5823..11721cc 100644
--- a/arch/xtensa/include/asm/page.h
+++ b/arch/xtensa/include/asm/page.h
@@ -134,6 +134,7 @@ static inline __attribute_const__ int get_order(unsigned long size)
 #endif
 
 struct page;
+struct vm_area_struct;
 extern void clear_page(void *page);
 extern void copy_page(void *to, void *from);
 
@@ -143,8 +144,15 @@ extern void copy_page(void *to, void *from);
  */
 
 #if DCACHE_WAY_SIZE > PAGE_SIZE
-extern void clear_user_page(void*, unsigned long, struct page*);
-extern void copy_user_page(void*, void*, unsigned long, struct page*);
+extern void clear_page_alias(void *vaddr, unsigned long paddr);
+extern void copy_page_alias(void *to, void *from,
+			    unsigned long to_paddr, unsigned long from_paddr);
+
+#define clear_user_highpage clear_user_highpage
+void clear_user_highpage(struct page *page, unsigned long vaddr);
+#define __HAVE_ARCH_COPY_USER_HIGHPAGE
+void copy_user_highpage(struct page *to, struct page *from,
+			unsigned long vaddr, struct vm_area_struct *vma);
 #else
 # define clear_user_page(page, vaddr, pg)	clear_page(page)
 # define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
diff --git a/arch/xtensa/mm/cache.c b/arch/xtensa/mm/cache.c
index 63cbb86..96aea66 100644
--- a/arch/xtensa/mm/cache.c
+++ b/arch/xtensa/mm/cache.c
@@ -63,6 +63,69 @@
 #error "HIGHMEM is not supported on cores with aliasing cache."
 #endif
 
+#if (DCACHE_WAY_SIZE > PAGE_SIZE)
+static inline void kmap_invalidate_coherent(struct page *page,
+					    unsigned long vaddr)
+{
+	if (!DCACHE_ALIAS_EQ(page_to_phys(page), vaddr)) {
+		unsigned long kvaddr;
+
+		if (!PageHighMem(page)) {
+			kvaddr = (unsigned long)page_to_virt(page);
+
+			__invalidate_dcache_page(kvaddr);
+		} else {
+			kvaddr = TLBTEMP_BASE_1 +
+				(page_to_phys(page) & DCACHE_ALIAS_MASK);
+
+			__invalidate_dcache_page_alias(kvaddr,
+						       page_to_phys(page));
+		}
+	}
+}
+
+static inline void *coherent_kvaddr(struct page *page, unsigned long base,
+				    unsigned long vaddr, unsigned long *paddr)
+{
+	if (PageHighMem(page) || !DCACHE_ALIAS_EQ(page_to_phys(page), vaddr)) {
+		*paddr = page_to_phys(page);
+		return (void *)(base + (vaddr & DCACHE_ALIAS_MASK));
+	} else {
+		*paddr = 0;
+		return page_to_virt(page);
+	}
+}
+
+void clear_user_highpage(struct page *page, unsigned long vaddr)
+{
+	unsigned long paddr;
+	void *kvaddr = coherent_kvaddr(page, TLBTEMP_BASE_1, vaddr, &paddr);
+
+	pagefault_disable();
+	kmap_invalidate_coherent(page, vaddr);
+	set_bit(PG_arch_1, &page->flags);
+	clear_page_alias(kvaddr, paddr);
+	pagefault_enable();
+}
+
+void copy_user_highpage(struct page *dst, struct page *src,
+			unsigned long vaddr, struct vm_area_struct *vma)
+{
+	unsigned long dst_paddr, src_paddr;
+	void *dst_vaddr = coherent_kvaddr(dst, TLBTEMP_BASE_1, vaddr,
+					  &dst_paddr);
+	void *src_vaddr = coherent_kvaddr(src, TLBTEMP_BASE_2, vaddr,
+					  &src_paddr);
+
+	pagefault_disable();
+	kmap_invalidate_coherent(dst, vaddr);
+	set_bit(PG_arch_1, &dst->flags);
+	copy_page_alias(dst_vaddr, src_vaddr, dst_paddr, src_paddr);
+	pagefault_enable();
+}
+
+#endif /* DCACHE_WAY_SIZE > PAGE_SIZE */
+
 #if (DCACHE_WAY_SIZE > PAGE_SIZE) && XCHAL_DCACHE_IS_WRITEBACK
 
 /*
diff --git a/arch/xtensa/mm/misc.S b/arch/xtensa/mm/misc.S
index 1f68558..11a01c3 100644
--- a/arch/xtensa/mm/misc.S
+++ b/arch/xtensa/mm/misc.S
@@ -110,41 +110,24 @@ ENTRY(__tlbtemp_mapping_start)
 #if (DCACHE_WAY_SIZE > PAGE_SIZE)
 
 /*
- * clear_user_page (void *addr, unsigned long vaddr, struct page *page)
- *                     a2              a3                 a4
+ * clear_page_alias(void *addr, unsigned long paddr)
+ *                     a2              a3
  */
 
-ENTRY(clear_user_page)
+ENTRY(clear_page_alias)
 
 	entry	a1, 32
 
-	/* Mark page dirty and determine alias. */
+	/* Skip setting up a temporary DTLB if not aliased low page. */
 
-	movi	a7, (1 << PG_ARCH_1)
-	l32i	a5, a4, PAGE_FLAGS
-	xor	a6, a2, a3
-	extui	a3, a3, PAGE_SHIFT, DCACHE_ALIAS_ORDER
-	extui	a6, a6, PAGE_SHIFT, DCACHE_ALIAS_ORDER
-	or	a5, a5, a7
-	slli	a3, a3, PAGE_SHIFT
-	s32i	a5, a4, PAGE_FLAGS
+	movi	a5, PAGE_OFFSET
+	movi	a6, 0
+	beqz	a3, 1f
 
-	/* Skip setting up a temporary DTLB if not aliased. */
-
-	beqz	a6, 1f
-
-	/* Invalidate kernel page. */
-
-	mov	a10, a2
-	call8	__invalidate_dcache_page
-
-	/* Setup a temporary DTLB with the color of the VPN */
-
-	movi	a4, ((PAGE_KERNEL | _PAGE_HW_WRITE) - PAGE_OFFSET) & 0xffffffff
-	movi	a5, TLBTEMP_BASE_1			# virt
-	add	a6, a2, a4				# ppn
-	add	a2, a5, a3				# add 'color'
+	/* Setup a temporary DTLB for the addr. */
 
+	addi	a6, a3, (PAGE_KERNEL | _PAGE_HW_WRITE)
+	mov	a4, a2
 	wdtlb	a6, a2
 	dsync
 
@@ -165,62 +148,43 @@ ENTRY(clear_user_page)
 
 	/* We need to invalidate the temporary idtlb entry, if any. */
 
-1:	addi	a2, a2, -PAGE_SIZE
-	idtlb	a2
+1:	idtlb	a4
 	dsync
 
 	retw
 
-ENDPROC(clear_user_page)
+ENDPROC(clear_page_alias)
 
 /*
- * copy_page_user (void *to, void *from, unsigned long vaddr, struct page *page)
- *                    a2          a3	        a4		    a5
+ * copy_page_alias(void *to, void *from,
+ *			a2	  a3
+ *                 unsigned long to_paddr, unsigned long from_paddr)
+ *	        		 a4			 a5
  */
 
-ENTRY(copy_user_page)
+ENTRY(copy_page_alias)
 
 	entry	a1, 32
 
-	/* Mark page dirty and determine alias for destination. */
-
-	movi	a8, (1 << PG_ARCH_1)
-	l32i	a9, a5, PAGE_FLAGS
-	xor	a6, a2, a4
-	xor	a7, a3, a4
-	extui	a4, a4, PAGE_SHIFT, DCACHE_ALIAS_ORDER
-	extui	a6, a6, PAGE_SHIFT, DCACHE_ALIAS_ORDER
-	extui	a7, a7, PAGE_SHIFT, DCACHE_ALIAS_ORDER
-	or	a9, a9, a8
-	slli	a4, a4, PAGE_SHIFT
-	s32i	a9, a5, PAGE_FLAGS
-	movi	a5, ((PAGE_KERNEL | _PAGE_HW_WRITE) - PAGE_OFFSET) & 0xffffffff
-
-	beqz	a6, 1f
-
-	/* Invalidate dcache */
-
-	mov	a10, a2
-	call8	__invalidate_dcache_page
+	/* Skip setting up a temporary DTLB for destination if not aliased. */
 
-	/* Setup a temporary DTLB with a matching color. */
+	movi	a6, 0
+	movi	a7, 0
+	beqz	a4, 1f
 
-	movi	a8, TLBTEMP_BASE_1			# base
-	add	a6, a2, a5				# ppn
-	add	a2, a8, a4				# add 'color'
+	/* Setup a temporary DTLB for destination. */
 
+	addi	a6, a4, (PAGE_KERNEL | _PAGE_HW_WRITE)
 	wdtlb	a6, a2
 	dsync
 
-	/* Skip setting up a temporary DTLB for destination if not aliased. */
+	/* Skip setting up a temporary DTLB for source if not aliased. */
 
-1:	beqz	a7, 1f
+1:	beqz	a5, 1f
 
-	/* Setup a temporary DTLB with a matching color. */
+	/* Setup a temporary DTLB for source. */
 
-	movi	a8, TLBTEMP_BASE_2			# base
-	add	a7, a3, a5				# ppn
-	add	a3, a8, a4
+	addi	a7, a5, PAGE_KERNEL
 	addi	a8, a3, 1				# way1
 
 	wdtlb	a7, a8
@@ -271,7 +235,7 @@ ENTRY(copy_user_page)
 
 	retw
 
-ENDPROC(copy_user_page)
+ENDPROC(copy_page_alias)
 
 #endif
 
@@ -300,6 +264,30 @@ ENTRY(__flush_invalidate_dcache_page_alias)
 	retw
 
 ENDPROC(__flush_invalidate_dcache_page_alias)
+
+/*
+ * void __invalidate_dcache_page_alias (addr, phys)
+ *                                       a2    a3
+ */
+
+ENTRY(__invalidate_dcache_page_alias)
+
+	entry	sp, 16
+
+	movi	a7, 0			# required for exception handler
+	addi	a6, a3, (PAGE_KERNEL | _PAGE_HW_WRITE)
+	mov	a4, a2
+	wdtlb	a6, a2
+	dsync
+
+	___invalidate_dcache_page a2 a3
+
+	idtlb	a4
+	dsync
+
+	retw
+
+ENDPROC(__invalidate_dcache_page_alias)
 #endif
 
 ENTRY(__tlbtemp_mapping_itlb)
-- 
1.8.1.4

