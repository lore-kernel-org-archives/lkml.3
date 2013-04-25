Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759739Ab3DYVYr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 17:24:47 -0400
Received: from mout.gmx.net ([212.227.17.22]:50644 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759724Ab3DYVYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 17:24:46 -0400
Date: Thu, 25 Apr 2013 23:24:38 +0200
From: Helge Deller <deller@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] late parisc fixes for 3.9
Message-ID: <20130425212438.GA25421@p100.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V03:K0:9QJAMtoUy9UiEtbMAQSWk3h3X5QB2SqDRxk6akICO/djzbYEGXx
 K4UcOFpGEg4leErze7jZCXFwijiYSeCl1D6tyN0cpHJAnvjORt1DsRjeC9ddHcJ80SHQOuz
 wYE5S8eUj/1Afj+xcqK5JuATfIDuYtIYCLzGXrVoII50F1FiDZ6knOACPEdbuqw2qih1IBn
 hcq+gLF74tnWKho8e4pcw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I know it's *very* late in the 3.9 release cycle, but since there aren't
that many people testing the parisc linux kernel, a few (for our port)
critical issues just showed up a few days back for the first time.

That said, it would be very kind if you could pull this patchset which
touches parisc source files only.

What's in it?
* add missing __ucmpdi2 symbol, which is required for btrfs on 32bit kernel.
* change kunmap() macro to static inline function. This fixes a
  debian/gcc-4.4 build error.
* add locking when doing PTE updates. This fixes random userspace crashes.
* disable (optional) -mlong-calls compiler option for modules, else
  modules can't be loaded at runtime.
* a smart patch by Will Deacon which fixes 64bit put_user() warnings on
  32bit kernel.

Thanks,
Helge



The following changes since commit 0fbd06761f5c17cc9b20e02af60fd7ee9c895996:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc (2013-04-24 17:10:18 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux.git fixes-3.9-late

for you to fetch changes up to bda079d336cd8183e1d844a265ea87ae3e1bbe78:

  parisc: use spin_lock_irqsave/spin_unlock_irqrestore for PTE updates (2013-04-25 22:37:00 +0200)

----------------------------------------------------------------
Helge Deller (1):
      parisc: disable -mlong-calls compiler option for kernel modules

John David Anglin (3):
      parisc: Provide __ucmpdi2 to resolve undefined references in 32 bit builds.
      parisc: Change kunmap macro to static inline function
      parisc: use spin_lock_irqsave/spin_unlock_irqrestore for PTE updates

Will Deacon (1):
      parisc: uaccess: fix compiler warnings caused by __put_user casting

 arch/parisc/Makefile                 |  6 +++--
 arch/parisc/include/asm/cacheflush.h |  5 +++-
 arch/parisc/include/asm/pgtable.h    | 47 +++++++++++++++++++-----------------
 arch/parisc/include/asm/uaccess.h    | 14 +++--------
 arch/parisc/kernel/cache.c           |  5 +---
 arch/parisc/kernel/parisc_ksyms.c    |  2 ++
 arch/parisc/lib/Makefile             |  3 ++-
 arch/parisc/lib/ucmpdi2.c            | 25 +++++++++++++++++++
 8 files changed, 67 insertions(+), 40 deletions(-)
 create mode 100644 arch/parisc/lib/ucmpdi2.c

--------------



diff --git a/arch/parisc/Makefile b/arch/parisc/Makefile
index 01d95e2..113e282 100644
--- a/arch/parisc/Makefile
+++ b/arch/parisc/Makefile
@@ -65,8 +65,10 @@ ifndef CONFIG_FUNCTION_TRACER
 endif
 
 # Use long jumps instead of long branches (needed if your linker fails to
-# link a too big vmlinux executable)
-cflags-$(CONFIG_MLONGCALLS)	+= -mlong-calls
+# link a too big vmlinux executable). Not enabled for building modules.
+ifdef CONFIG_MLONGCALLS
+KBUILD_CFLAGS_KERNEL += -mlong-calls
+endif
 
 # select which processor to optimise for
 cflags-$(CONFIG_PA7100)		+= -march=1.1 -mschedule=7100
diff --git a/arch/parisc/include/asm/cacheflush.h b/arch/parisc/include/asm/cacheflush.h
index 79f694f..f0e2784 100644
--- a/arch/parisc/include/asm/cacheflush.h
+++ b/arch/parisc/include/asm/cacheflush.h
@@ -140,7 +140,10 @@ static inline void *kmap(struct page *page)
 	return page_address(page);
 }
 
-#define kunmap(page)			kunmap_parisc(page_address(page))
+static inline void kunmap(struct page *page)
+{
+	kunmap_parisc(page_address(page));
+}
 
 static inline void *kmap_atomic(struct page *page)
 {
diff --git a/arch/parisc/include/asm/pgtable.h b/arch/parisc/include/asm/pgtable.h
index 7df49fa..1e40d7f 100644
--- a/arch/parisc/include/asm/pgtable.h
+++ b/arch/parisc/include/asm/pgtable.h
@@ -16,6 +16,8 @@
 #include <asm/processor.h>
 #include <asm/cache.h>
 
+extern spinlock_t pa_dbit_lock;
+
 /*
  * kern_addr_valid(ADDR) tests if ADDR is pointing to valid kernel
  * memory.  For the return value to be meaningful, ADDR must be >=
@@ -44,8 +46,11 @@ extern void purge_tlb_entries(struct mm_struct *, unsigned long);
 
 #define set_pte_at(mm, addr, ptep, pteval)                      \
 	do {                                                    \
+		unsigned long flags;				\
+		spin_lock_irqsave(&pa_dbit_lock, flags);	\
 		set_pte(ptep, pteval);                          \
 		purge_tlb_entries(mm, addr);                    \
+		spin_unlock_irqrestore(&pa_dbit_lock, flags);	\
 	} while (0)
 
 #endif /* !__ASSEMBLY__ */
@@ -435,48 +440,46 @@ extern void update_mmu_cache(struct vm_area_struct *, unsigned long, pte_t *);
 
 static inline int ptep_test_and_clear_young(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
 {
-#ifdef CONFIG_SMP
+	pte_t pte;
+	unsigned long flags;
+
 	if (!pte_young(*ptep))
 		return 0;
-	return test_and_clear_bit(xlate_pabit(_PAGE_ACCESSED_BIT), &pte_val(*ptep));
-#else
-	pte_t pte = *ptep;
-	if (!pte_young(pte))
+
+	spin_lock_irqsave(&pa_dbit_lock, flags);
+	pte = *ptep;
+	if (!pte_young(pte)) {
+		spin_unlock_irqrestore(&pa_dbit_lock, flags);
 		return 0;
-	set_pte_at(vma->vm_mm, addr, ptep, pte_mkold(pte));
+	}
+	set_pte(ptep, pte_mkold(pte));
+	purge_tlb_entries(vma->vm_mm, addr);
+	spin_unlock_irqrestore(&pa_dbit_lock, flags);
 	return 1;
-#endif
 }
 
-extern spinlock_t pa_dbit_lock;
-
 struct mm_struct;
 static inline pte_t ptep_get_and_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 {
 	pte_t old_pte;
+	unsigned long flags;
 
-	spin_lock(&pa_dbit_lock);
+	spin_lock_irqsave(&pa_dbit_lock, flags);
 	old_pte = *ptep;
 	pte_clear(mm,addr,ptep);
-	spin_unlock(&pa_dbit_lock);
+	purge_tlb_entries(mm, addr);
+	spin_unlock_irqrestore(&pa_dbit_lock, flags);
 
 	return old_pte;
 }
 
 static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 {
-#ifdef CONFIG_SMP
-	unsigned long new, old;
-
-	do {
-		old = pte_val(*ptep);
-		new = pte_val(pte_wrprotect(__pte (old)));
-	} while (cmpxchg((unsigned long *) ptep, old, new) != old);
+	unsigned long flags;
+	spin_lock_irqsave(&pa_dbit_lock, flags);
+	set_pte(ptep, pte_wrprotect(*ptep));
 	purge_tlb_entries(mm, addr);
-#else
-	pte_t old_pte = *ptep;
-	set_pte_at(mm, addr, ptep, pte_wrprotect(old_pte));
-#endif
+	spin_unlock_irqrestore(&pa_dbit_lock, flags);
 }
 
 #define pte_same(A,B)	(pte_val(A) == pte_val(B))
diff --git a/arch/parisc/include/asm/uaccess.h b/arch/parisc/include/asm/uaccess.h
index 4ba2c93..e0a8235 100644
--- a/arch/parisc/include/asm/uaccess.h
+++ b/arch/parisc/include/asm/uaccess.h
@@ -181,30 +181,24 @@ struct exception_data {
 #if !defined(CONFIG_64BIT)
 
 #define __put_kernel_asm64(__val,ptr) do {		    \
-	u64 __val64 = (u64)(__val);			    \
-	u32 hi = (__val64) >> 32;			    \
-	u32 lo = (__val64) & 0xffffffff;		    \
 	__asm__ __volatile__ (				    \
 		"\n1:\tstw %2,0(%1)"			    \
-		"\n2:\tstw %3,4(%1)\n\t"		    \
+		"\n2:\tstw %R2,4(%1)\n\t"		    \
 		ASM_EXCEPTIONTABLE_ENTRY(1b,fixup_put_user_skip_2)\
 		ASM_EXCEPTIONTABLE_ENTRY(2b,fixup_put_user_skip_1)\
 		: "=r"(__pu_err)                            \
-		: "r"(ptr), "r"(hi), "r"(lo), "0"(__pu_err) \
+		: "r"(ptr), "r"(__val), "0"(__pu_err) \
 		: "r1");				    \
 } while (0)
 
 #define __put_user_asm64(__val,ptr) do {	    	    \
-	u64 __val64 = (u64)(__val);			    \
-	u32 hi = (__val64) >> 32;			    \
-	u32 lo = (__val64) & 0xffffffff;		    \
 	__asm__ __volatile__ (				    \
 		"\n1:\tstw %2,0(%%sr3,%1)"		    \
-		"\n2:\tstw %3,4(%%sr3,%1)\n\t"		    \
+		"\n2:\tstw %R2,4(%%sr3,%1)\n\t"		    \
 		ASM_EXCEPTIONTABLE_ENTRY(1b,fixup_put_user_skip_2)\
 		ASM_EXCEPTIONTABLE_ENTRY(2b,fixup_put_user_skip_1)\
 		: "=r"(__pu_err)                            \
-		: "r"(ptr), "r"(hi), "r"(lo), "0"(__pu_err) \
+		: "r"(ptr), "r"(__val), "0"(__pu_err) \
 		: "r1");				    \
 } while (0)
 
diff --git a/arch/parisc/kernel/cache.c b/arch/parisc/kernel/cache.c
index 4b12890..83ded26 100644
--- a/arch/parisc/kernel/cache.c
+++ b/arch/parisc/kernel/cache.c
@@ -421,14 +421,11 @@ void purge_tlb_entries(struct mm_struct *mm, unsigned long addr)
 	/* Note: purge_tlb_entries can be called at startup with
 	   no context.  */
 
-	/* Disable preemption while we play with %sr1.  */
-	preempt_disable();
-	mtsp(mm->context, 1);
 	purge_tlb_start(flags);
+	mtsp(mm->context, 1);
 	pdtlb(addr);
 	pitlb(addr);
 	purge_tlb_end(flags);
-	preempt_enable();
 }
 EXPORT_SYMBOL(purge_tlb_entries);
 
diff --git a/arch/parisc/kernel/parisc_ksyms.c b/arch/parisc/kernel/parisc_ksyms.c
index 6795dc6..568b2c6 100644
--- a/arch/parisc/kernel/parisc_ksyms.c
+++ b/arch/parisc/kernel/parisc_ksyms.c
@@ -120,11 +120,13 @@ extern void __ashrdi3(void);
 extern void __ashldi3(void);
 extern void __lshrdi3(void);
 extern void __muldi3(void);
+extern void __ucmpdi2(void);
 
 EXPORT_SYMBOL(__ashrdi3);
 EXPORT_SYMBOL(__ashldi3);
 EXPORT_SYMBOL(__lshrdi3);
 EXPORT_SYMBOL(__muldi3);
+EXPORT_SYMBOL(__ucmpdi2);
 
 asmlinkage void * __canonicalize_funcptr_for_compare(void *);
 EXPORT_SYMBOL(__canonicalize_funcptr_for_compare);
diff --git a/arch/parisc/lib/Makefile b/arch/parisc/lib/Makefile
index 5f2e690..5651536 100644
--- a/arch/parisc/lib/Makefile
+++ b/arch/parisc/lib/Makefile
@@ -2,6 +2,7 @@
 # Makefile for parisc-specific library files
 #
 
-lib-y	:= lusercopy.o bitops.o checksum.o io.o memset.o fixup.o memcpy.o
+lib-y	:= lusercopy.o bitops.o checksum.o io.o memset.o fixup.o memcpy.o \
+	   ucmpdi2.o
 
 obj-y	:= iomap.o
diff --git a/arch/parisc/lib/ucmpdi2.c b/arch/parisc/lib/ucmpdi2.c
new file mode 100644
index 0000000..149c016
--- /dev/null
+++ b/arch/parisc/lib/ucmpdi2.c
@@ -0,0 +1,25 @@
+#include <linux/module.h>
+
+union ull_union {
+	unsigned long long ull;
+	struct {
+		unsigned int high;
+		unsigned int low;
+	} ui;
+};
+
+int __ucmpdi2(unsigned long long a, unsigned long long b)
+{
+	union ull_union au = {.ull = a};
+	union ull_union bu = {.ull = b};
+
+	if (au.ui.high < bu.ui.high)
+		return 0;
+	else if (au.ui.high > bu.ui.high)
+		return 2;
+	if (au.ui.low < bu.ui.low)
+		return 0;
+	else if (au.ui.low > bu.ui.low)
+		return 2;
+	return 1;
+}
