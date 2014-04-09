Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932942AbaDIKCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 06:02:52 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:55051 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932812AbaDIKCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 06:02:46 -0400
Date: Wed, 9 Apr 2014 11:01:50 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        David Howells <dhowells@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Greg Ungerer <gerg@uclinux.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Michal Simek <monstr@monstr.eu>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [RFC PATCH] Remove flush_icache_user_range()
Message-ID: <20140409100150.GO16119@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The subject of flush_icache_user_range() recently came up in a discussion
about uprobes on ARM - and it was suggested maybe to make use of it as
the flush_dcache_page() in uprobes doesn't have the desired effect.

However, uprobes does not track the vma for userspace, which would mean
it has to pass NULL as the first argument.  As this function is a no-op
on many architectures, this would not be a problem, but there is one
which does dereference this argument.

Moreover, the ARM implementation of flush_icache_user_range() just called
flush_dcache_page(), so changing to this would not result in any change.
Modifying it do perform as uprobes wanted is unclear whether that was
the correct solution.

After surveying this function, it appears that not only is it
undocumented, but it is not used by generic code at all - it is used
by a few architectures in their copy_to_user_page() function.  Many
architectures define this and never make any use of it, or define it
to be empty but still use it in copy_to_user_page().

There are four which do have some effect:
	alpha
	frv
	m68k
	powerpc

Alpha's implementation aliases to flush_icache_page(), so this is
trivial to change.  The others are not so trivial, and require some
knowledge of the architecture to change.  However, I doubt it would be
a difficult job.

The alternative would be to document this function (anyone know what
it's semantics are supposed to be?) so that we know what should be
expected from it.

What has been proposed for uprobes is a uprobe specific function -
flush_uprobe_xol_access() which is used after uprobes writes via the
kmap_atomic() mapping of the page:

+       xol_page_kaddr = kmap_atomic(area->page);
+
+       /* Initialize the slot */
+       memcpy(xol_page_kaddr + (xol_vaddr & ~PAGE_MASK),
+              &uprobe->arch.ixol,
+              sizeof(uprobe->arch.ixol));
+
+       arch_uprobe_flush_xol_access(area->page, xol_vaddr,
+                                    xol_page_kaddr + (xol_vaddr & ~PAGE_MASK),
+                                    sizeof(uprobe->arch.ixol));
+
+       kunmap_atomic(xol_page_kaddr);

Comments?

 arch/alpha/include/asm/cacheflush.h      | 13 ++++---------
 arch/alpha/kernel/smp.c                  |  4 +---
 arch/arm/include/asm/cacheflush.h        |  3 ---
 arch/cris/include/asm/cacheflush.h       |  1 -
 arch/frv/include/asm/cacheflush.h        |  2 ++
 arch/ia64/include/asm/cacheflush.h       | 13 +++++--------
 arch/m32r/include/asm/cacheflush.h       |  6 +-----
 arch/m68k/include/asm/cacheflush_no.h    |  1 -
 arch/microblaze/include/asm/cacheflush.h |  1 -
 arch/mn10300/include/asm/cacheflush.h    |  3 ---
 arch/sparc/include/asm/cacheflush_32.h   |  2 --
 arch/sparc/include/asm/cacheflush_64.h   |  1 -
 arch/tile/include/asm/cacheflush.h       |  1 -
 arch/unicore32/include/asm/cacheflush.h  |  3 ---
 include/asm-generic/cacheflush.h         |  6 +-----
 15 files changed, 14 insertions(+), 46 deletions(-)

diff --git a/arch/alpha/include/asm/cacheflush.h b/arch/alpha/include/asm/cacheflush.h
index a9cb6aa447aa..97c01e9f6d27 100644
--- a/arch/alpha/include/asm/cacheflush.h
+++ b/arch/alpha/include/asm/cacheflush.h
@@ -42,13 +42,13 @@ extern void smp_imb(void);
    that icache entries are tagged with the ASN and load a new mm context.  */
 /* ??? Ought to use this in arch/alpha/kernel/signal.c too.  */
 
+/* This is used only in __do_fault and do_swap_page.  */
 #ifndef CONFIG_SMP
 #include <linux/sched.h>
 
 extern void __load_new_mm_context(struct mm_struct *);
 static inline void
-flush_icache_user_range(struct vm_area_struct *vma, struct page *page,
-			unsigned long addr, int len)
+flush_icache_page(struct vm_area_struct *vma, struct page *page)
 {
 	if (vma->vm_flags & VM_EXEC) {
 		struct mm_struct *mm = vma->vm_mm;
@@ -59,17 +59,12 @@ flush_icache_user_range(struct vm_area_struct *vma, struct page *page,
 	}
 }
 #else
-extern void flush_icache_user_range(struct vm_area_struct *vma,
-		struct page *page, unsigned long addr, int len);
+extern void flush_icache_page(struct vm_area_struct *vma, struct page *page);
 #endif
 
-/* This is used only in __do_fault and do_swap_page.  */
-#define flush_icache_page(vma, page) \
-  flush_icache_user_range((vma), (page), 0, 0)
-
 #define copy_to_user_page(vma, page, vaddr, dst, src, len) \
 do { memcpy(dst, src, len); \
-     flush_icache_user_range(vma, page, vaddr, len); \
+     flush_icache_page(vma, page); \
 } while (0)
 #define copy_from_user_page(vma, page, vaddr, dst, src, len) \
 	memcpy(dst, src, len)
diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index 99ac36d5de4e..fee1c5a5b9bb 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -751,9 +751,7 @@ ipi_flush_icache_page(void *x)
 		flush_tlb_other(mm);
 }
 
-void
-flush_icache_user_range(struct vm_area_struct *vma, struct page *page,
-			unsigned long addr, int len)
+void flush_icache_page(struct vm_area_struct *vma, struct page *page)
 {
 	struct mm_struct *mm = vma->vm_mm;
 
diff --git a/arch/arm/include/asm/cacheflush.h b/arch/arm/include/asm/cacheflush.h
index 8b8b61685a34..0077e596b483 100644
--- a/arch/arm/include/asm/cacheflush.h
+++ b/arch/arm/include/asm/cacheflush.h
@@ -327,9 +327,6 @@ extern void flush_kernel_dcache_page(struct page *);
 #define flush_dcache_mmap_unlock(mapping) \
 	spin_unlock_irq(&(mapping)->tree_lock)
 
-#define flush_icache_user_range(vma,page,addr,len) \
-	flush_dcache_page(page)
-
 /*
  * We don't appear to need to do anything here.  In fact, if we did, we'd
  * duplicate cache flushing elsewhere performed by flush_dcache_page().
diff --git a/arch/cris/include/asm/cacheflush.h b/arch/cris/include/asm/cacheflush.h
index 36795bca605e..419b98ff05b6 100644
--- a/arch/cris/include/asm/cacheflush.h
+++ b/arch/cris/include/asm/cacheflush.h
@@ -18,7 +18,6 @@
 #define flush_dcache_mmap_unlock(mapping)	do { } while (0)
 #define flush_icache_range(start, end)		do { } while (0)
 #define flush_icache_page(vma,pg)		do { } while (0)
-#define flush_icache_user_range(vma,pg,adr,len)	do { } while (0)
 #define flush_cache_vmap(start, end)		do { } while (0)
 #define flush_cache_vunmap(start, end)		do { } while (0)
 
diff --git a/arch/frv/include/asm/cacheflush.h b/arch/frv/include/asm/cacheflush.h
index edbac54ae015..386022261d34 100644
--- a/arch/frv/include/asm/cacheflush.h
+++ b/arch/frv/include/asm/cacheflush.h
@@ -95,7 +95,9 @@ static inline void flush_icache_page(struct vm_area_struct *vma, struct page *pa
  */
 #define copy_to_user_page(vma, page, vaddr, dst, src, len)	\
 do {								\
+	unsigned long _vaddr = vaddr;				\
 	memcpy((dst), (src), (len));				\
+	frv_cache_wback_inv(_vaddr, _vaddr + (len));		\
 	flush_icache_user_range((vma), (page), (vaddr), (len));	\
 } while(0)
 
diff --git a/arch/ia64/include/asm/cacheflush.h b/arch/ia64/include/asm/cacheflush.h
index 429eefc93ee7..02f20e72ebbd 100644
--- a/arch/ia64/include/asm/cacheflush.h
+++ b/arch/ia64/include/asm/cacheflush.h
@@ -38,15 +38,12 @@ extern void flush_icache_range (unsigned long start, unsigned long end);
 extern void clflush_cache_range(void *addr, int size);
 
 
-#define flush_icache_user_range(vma, page, user_addr, len)					\
-do {												\
-	unsigned long _addr = (unsigned long) page_address(page) + ((user_addr) & ~PAGE_MASK);	\
-	flush_icache_range(_addr, _addr + (len));						\
-} while (0)
-
 #define copy_to_user_page(vma, page, vaddr, dst, src, len) \
-do { memcpy(dst, src, len); \
-     flush_icache_user_range(vma, page, vaddr, len); \
+do {
+     unsigned long _addr = (unsigned long) page_address(page) + \
+     			((vaddr) & ~PAGE_MASK); \
+     memcpy(dst, src, len); \
+     flush_icache_range(_addr, _addr + (len)); \
 } while (0)
 #define copy_from_user_page(vma, page, vaddr, dst, src, len) \
 	memcpy(dst, src, len)
diff --git a/arch/m32r/include/asm/cacheflush.h b/arch/m32r/include/asm/cacheflush.h
index 8e8e04516c39..6ae48713b026 100644
--- a/arch/m32r/include/asm/cacheflush.h
+++ b/arch/m32r/include/asm/cacheflush.h
@@ -19,13 +19,11 @@ extern void _flush_cache_copyback_all(void);
 #ifndef CONFIG_SMP
 #define flush_icache_range(start, end)		_flush_cache_copyback_all()
 #define flush_icache_page(vma,pg)		_flush_cache_copyback_all()
-#define flush_icache_user_range(vma,pg,adr,len)	_flush_cache_copyback_all()
 #define flush_cache_sigtramp(addr)		_flush_cache_copyback_all()
 #else	/* CONFIG_SMP */
 extern void smp_flush_cache_all(void);
 #define flush_icache_range(start, end)		smp_flush_cache_all()
 #define flush_icache_page(vma,pg)		smp_flush_cache_all()
-#define flush_icache_user_range(vma,pg,adr,len)	smp_flush_cache_all()
 #define flush_cache_sigtramp(addr)		_flush_cache_copyback_all()
 #endif	/* CONFIG_SMP */
 #elif defined(CONFIG_CHIP_M32102)
@@ -40,7 +38,6 @@ extern void smp_flush_cache_all(void);
 #define flush_dcache_mmap_unlock(mapping)	do { } while (0)
 #define flush_icache_range(start, end)		_flush_cache_all()
 #define flush_icache_page(vma,pg)		_flush_cache_all()
-#define flush_icache_user_range(vma,pg,adr,len)	_flush_cache_all()
 #define flush_cache_sigtramp(addr)		_flush_cache_all()
 #else
 #define flush_cache_all()			do { } while (0)
@@ -54,7 +51,6 @@ extern void smp_flush_cache_all(void);
 #define flush_dcache_mmap_unlock(mapping)	do { } while (0)
 #define flush_icache_range(start, end)		do { } while (0)
 #define flush_icache_page(vma,pg)		do { } while (0)
-#define flush_icache_user_range(vma,pg,adr,len)	do { } while (0)
 #define flush_cache_sigtramp(addr)		do { } while (0)
 #endif	/* CONFIG_CHIP_* */
 
@@ -64,7 +60,7 @@ extern void smp_flush_cache_all(void);
 #define copy_to_user_page(vma, page, vaddr, dst, src, len)	\
 do {								\
 	memcpy(dst, src, len);					\
-	flush_icache_user_range(vma, page, vaddr, len);		\
+	flush_icache_page(vma, page);				\
 } while (0)
 #define copy_from_user_page(vma, page, vaddr, dst, src, len)	\
 	memcpy(dst, src, len)
diff --git a/arch/m68k/include/asm/cacheflush_no.h b/arch/m68k/include/asm/cacheflush_no.h
index d2b3935ae147..693e1c108194 100644
--- a/arch/m68k/include/asm/cacheflush_no.h
+++ b/arch/m68k/include/asm/cacheflush_no.h
@@ -19,7 +19,6 @@
 #define flush_dcache_mmap_unlock(mapping)	do { } while (0)
 #define flush_icache_range(start, len)		__flush_icache_all()
 #define flush_icache_page(vma,pg)		do { } while (0)
-#define flush_icache_user_range(vma,pg,adr,len)	do { } while (0)
 #define flush_cache_vmap(start, end)		do { } while (0)
 #define flush_cache_vunmap(start, end)		do { } while (0)
 
diff --git a/arch/microblaze/include/asm/cacheflush.h b/arch/microblaze/include/asm/cacheflush.h
index ffea82a16d2c..d4b150b8a4de 100644
--- a/arch/microblaze/include/asm/cacheflush.h
+++ b/arch/microblaze/include/asm/cacheflush.h
@@ -61,7 +61,6 @@ void microblaze_cache_init(void);
 #define invalidate_icache()				mbc->iin();
 #define invalidate_icache_range(start, end)		mbc->iinr(start, end);
 
-#define flush_icache_user_range(vma, pg, adr, len)	flush_icache();
 #define flush_icache_page(vma, pg)			do { } while (0)
 
 #define enable_dcache()					mbc->de();
diff --git a/arch/mn10300/include/asm/cacheflush.h b/arch/mn10300/include/asm/cacheflush.h
index faed90240ded..360374074a9a 100644
--- a/arch/mn10300/include/asm/cacheflush.h
+++ b/arch/mn10300/include/asm/cacheflush.h
@@ -147,9 +147,6 @@ extern void flush_icache_range(unsigned long start, unsigned long end);
 #endif
 
 
-#define flush_icache_user_range(vma, pg, adr, len) \
-	flush_icache_range(adr, adr + len)
-
 #define copy_to_user_page(vma, page, vaddr, dst, src, len) \
 	do {					\
 		memcpy(dst, src, len);		\
diff --git a/arch/sparc/include/asm/cacheflush_32.h b/arch/sparc/include/asm/cacheflush_32.h
index bb014c24f318..66354e476ad6 100644
--- a/arch/sparc/include/asm/cacheflush_32.h
+++ b/arch/sparc/include/asm/cacheflush_32.h
@@ -16,8 +16,6 @@
 #define flush_icache_range(start, end)		do { } while (0)
 #define flush_icache_page(vma, pg)		do { } while (0)
 
-#define flush_icache_user_range(vma,pg,adr,len)	do { } while (0)
-
 #define copy_to_user_page(vma, page, vaddr, dst, src, len) \
 	do {							\
 		flush_cache_page(vma, vaddr, page_to_pfn(page));\
diff --git a/arch/sparc/include/asm/cacheflush_64.h b/arch/sparc/include/asm/cacheflush_64.h
index 301736d9e7a1..f920ebc8bc12 100644
--- a/arch/sparc/include/asm/cacheflush_64.h
+++ b/arch/sparc/include/asm/cacheflush_64.h
@@ -48,7 +48,6 @@ extern void __flush_dcache_range(unsigned long start, unsigned long end);
 extern void flush_dcache_page(struct page *page);
 
 #define flush_icache_page(vma, pg)	do { } while(0)
-#define flush_icache_user_range(vma,pg,adr,len)	do { } while (0)
 
 extern void flush_ptrace_access(struct vm_area_struct *, struct page *,
 				unsigned long uaddr, void *kaddr,
diff --git a/arch/tile/include/asm/cacheflush.h b/arch/tile/include/asm/cacheflush.h
index 92ee4c8a4f76..8e69495ae132 100644
--- a/arch/tile/include/asm/cacheflush.h
+++ b/arch/tile/include/asm/cacheflush.h
@@ -35,7 +35,6 @@
 #define flush_cache_vmap(start, end)		do { } while (0)
 #define flush_cache_vunmap(start, end)		do { } while (0)
 #define flush_icache_page(vma, pg)		do { } while (0)
-#define flush_icache_user_range(vma, pg, adr, len)	do { } while (0)
 
 /* Flush the icache just on this cpu */
 extern void __flush_icache_range(unsigned long start, unsigned long end);
diff --git a/arch/unicore32/include/asm/cacheflush.h b/arch/unicore32/include/asm/cacheflush.h
index c0301e6c8b81..6886b309ec54 100644
--- a/arch/unicore32/include/asm/cacheflush.h
+++ b/arch/unicore32/include/asm/cacheflush.h
@@ -184,9 +184,6 @@ extern void flush_dcache_page(struct page *);
 #define flush_dcache_mmap_unlock(mapping)		\
 	spin_unlock_irq(&(mapping)->tree_lock)
 
-#define flush_icache_user_range(vma, page, addr, len)	\
-	flush_dcache_page(page)
-
 /*
  * We don't appear to need to do anything here.  In fact, if we did, we'd
  * duplicate cache flushing elsewhere performed by flush_dcache_page().
diff --git a/include/asm-generic/cacheflush.h b/include/asm-generic/cacheflush.h
index 87bc536ccde3..65141f38b072 100644
--- a/include/asm-generic/cacheflush.h
+++ b/include/asm-generic/cacheflush.h
@@ -19,15 +19,11 @@
 #define flush_dcache_mmap_unlock(mapping)	do { } while (0)
 #define flush_icache_range(start, end)		do { } while (0)
 #define flush_icache_page(vma,pg)		do { } while (0)
-#define flush_icache_user_range(vma,pg,adr,len)	do { } while (0)
 #define flush_cache_vmap(start, end)		do { } while (0)
 #define flush_cache_vunmap(start, end)		do { } while (0)
 
 #define copy_to_user_page(vma, page, vaddr, dst, src, len) \
-	do { \
-		memcpy(dst, src, len); \
-		flush_icache_user_range(vma, page, vaddr, len); \
-	} while (0)
+	memcpy(dst, src, len)
 #define copy_from_user_page(vma, page, vaddr, dst, src, len) \
 	memcpy(dst, src, len)
 


-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
