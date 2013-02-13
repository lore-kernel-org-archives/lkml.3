Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759521Ab3BMONr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 09:13:47 -0500
Received: from www.linutronix.de ([62.245.132.108]:59099 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755960Ab3BMONq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 09:13:46 -0500
Date: Wed, 13 Feb 2013 15:13:44 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [ANNOUNCE] 3.6.11-rt29
Message-ID: <alpine.LFD.2.02.1302131506020.11905@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT Folks,

I'm pleased to announce the 3.6.11-rt29 release.

Changes since 3.6.11-rt26:

   1) Fix the RT highmem implementation on x86 this time really. The
      issue I was seeing with kmap_atomic and friends was actually
      when CONFIG_HIGHMEM was disabled. x8632 uses the atomic maps for
      io_mapping_map_atomic_wc() even when CONFIG_HIGHMEM is off.

   2) Modify the kmap_atomic per thread storage mechanism to reduce
      code in switch_to
      
   3) Rewrite RT highmem support for ARM with the kmap_atomic switch
      mechanism like x86_32 uses it.

This is probably the last release for 3.6 from my side. Steven might
keep it maintained until the 3.8-rt stabilizes, but that's not yet
decided.

The delta patch against 3.6.11-rt28 is appended below and can be found
here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/incr/patch-3.6.11-rt28-rt29.patch.xz

The RT patch against 3.6.11 can be found here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/patch-3.6.11-rt29.patch.xz

The split quilt queue is available at:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/patches-3.6.11-rt29.tar.xz

Enjoy,

	tglx

------------->
Index: linux-stable/arch/arm/include/asm/highmem.h
===================================================================
--- linux-stable.orig/arch/arm/include/asm/highmem.h
+++ linux-stable/arch/arm/include/asm/highmem.h
@@ -57,25 +57,10 @@ static inline void *kmap_high_get(struct
 #ifdef CONFIG_HIGHMEM
 extern void *kmap(struct page *page);
 extern void kunmap(struct page *page);
-# ifndef CONFIG_PREEMPT_RT_FULL
 extern void *kmap_atomic(struct page *page);
 extern void __kunmap_atomic(void *kvaddr);
 extern void *kmap_atomic_pfn(unsigned long pfn);
 extern struct page *kmap_atomic_to_page(const void *ptr);
-# else
-#  define kmap_atomic(page)	\
-	({ pagefault_disable(); kmap(page); })
-
-#  define kmap_atomic_pfn(pfn)	\
-	({ pagefault_disable(); kmap(pfn_to_page(pfn)) })
-
-#  define __kunmap_atomic(kvaddr)	\
-	do { kunmap(kmap_to_page(kvaddr)); pagefault_enable(); } while(0)
-
-#  define kmap_atomic_to_page(kvaddr)	\
-	kmap_to_page(kvaddr)
-
-# endif
 #endif
 
 #endif
Index: linux-stable/arch/arm/mm/highmem.c
===================================================================
--- linux-stable.orig/arch/arm/mm/highmem.c
+++ linux-stable/arch/arm/mm/highmem.c
@@ -36,9 +36,9 @@ void kunmap(struct page *page)
 }
 EXPORT_SYMBOL(kunmap);
 
-#ifndef CONFIG_PREEMPT_RT_FULL
 void *kmap_atomic(struct page *page)
 {
+	pte_t pte = mk_pte(page, kmap_prot);
 	unsigned int idx;
 	unsigned long vaddr;
 	void *kmap;
@@ -77,7 +77,10 @@ void *kmap_atomic(struct page *page)
 	 * in place, so the contained TLB flush ensures the TLB is updated
 	 * with the new mapping.
 	 */
-	set_top_pte(vaddr, mk_pte(page, kmap_prot));
+#ifdef CONFIG_PREEMPT_RT_FULL
+	current->kmap_pte[type] = pte;
+#endif
+	set_top_pte(vaddr, pte);
 
 	return (void *)vaddr;
 }
@@ -111,6 +114,7 @@ EXPORT_SYMBOL(__kunmap_atomic);
 
 void *kmap_atomic_pfn(unsigned long pfn)
 {
+	pte_t pte = pfn_pte(pfn, kmap_prot);
 	unsigned long vaddr;
 	int idx, type;
 
@@ -122,7 +126,10 @@ void *kmap_atomic_pfn(unsigned long pfn)
 #ifdef CONFIG_DEBUG_HIGHMEM
 	BUG_ON(!pte_none(get_top_pte(vaddr)));
 #endif
-	set_top_pte(vaddr, pfn_pte(pfn, kmap_prot));
+#ifdef CONFIG_PREEMPT_RT_FULL
+	current->kmap_pte[type] = pte;
+#endif
+	set_top_pte(vaddr, pte);
 
 	return (void *)vaddr;
 }
@@ -136,4 +143,28 @@ struct page *kmap_atomic_to_page(const v
 
 	return pte_page(get_top_pte(vaddr));
 }
+
+#if defined CONFIG_PREEMPT_RT_FULL
+void switch_kmaps(struct task_struct *prev_p, struct task_struct *next_p)
+{
+	int i;
+
+	/*
+	 * Clear @prev's kmap_atomic mappings
+	 */
+	for (i = 0; i < prev_p->kmap_idx; i++) {
+		int idx = i + KM_TYPE_NR * smp_processor_id();
+
+		set_top_pte(__fix_to_virt(FIX_KMAP_BEGIN + idx), __pte(0));
+	}
+	/*
+	 * Restore @next_p's kmap_atomic mappings
+	 */
+	for (i = 0; i < next_p->kmap_idx; i++) {
+		int idx = i + KM_TYPE_NR * smp_processor_id();
+
+		set_top_pte(__fix_to_virt(FIX_KMAP_BEGIN + idx),
+			    next_p->kmap_pte[i]);
+	}
+}
 #endif
Index: linux-stable/arch/x86/include/asm/highmem.h
===================================================================
--- linux-stable.orig/arch/x86/include/asm/highmem.h
+++ linux-stable/arch/x86/include/asm/highmem.h
@@ -56,39 +56,16 @@ extern unsigned long highstart_pfn, high
 
 extern void *kmap_high(struct page *page);
 extern void kunmap_high(struct page *page);
-extern void *kmap_high_prot(struct page *page, pgprot_t prot);
 
 void *kmap(struct page *page);
 void kunmap(struct page *page);
 
-#ifndef CONFIG_PREEMPT_RT_FULL
 void *kmap_atomic_prot(struct page *page, pgprot_t prot);
 void *kmap_atomic(struct page *page);
 void __kunmap_atomic(void *kvaddr);
 void *kmap_atomic_pfn(unsigned long pfn);
 void *kmap_atomic_prot_pfn(unsigned long pfn, pgprot_t prot);
 struct page *kmap_atomic_to_page(void *ptr);
-#else
-void *__kmap_prot(struct page *page, pgprot_t prot);
-# define kmap_atomic(page)			\
-	({ pagefault_disable(); kmap(page); })
-
-# define kmap_atomic_pfn(pfn)			\
-	({ pagefault_disable(); kmap(pfn_to_page(pfn)) })
-
-# define __kunmap_atomic(kvaddr)		\
-	do { kunmap(kmap_to_page(kvaddr)); pagefault_enable(); } while(0)
-
-# define kmap_atomic_prot(page, prot)		\
-	({ pagefault_disable(); __kmap_prot(page, prot); })
-
-# define kmap_atomic_prot_pfn(pfn, prot)	\
-	({ pagefault_disable(); __kmap_prot(pfn_to_page(pfn), prot); })
-
-# define kmap_atomic_to_page(kvaddr)		\
-	kmap_to_page(kvaddr)
-
-#endif
 
 #define flush_cache_kmaps()	do { } while (0)
 
Index: linux-stable/arch/x86/kernel/process_32.c
===================================================================
--- linux-stable.orig/arch/x86/kernel/process_32.c
+++ linux-stable/arch/x86/kernel/process_32.c
@@ -198,6 +198,34 @@ start_thread(struct pt_regs *regs, unsig
 }
 EXPORT_SYMBOL_GPL(start_thread);
 
+#ifdef CONFIG_PREEMPT_RT_FULL
+static void switch_kmaps(struct task_struct *prev_p, struct task_struct *next_p)
+{
+	int i;
+
+	/*
+	 * Clear @prev's kmap_atomic mappings
+	 */
+	for (i = 0; i < prev_p->kmap_idx; i++) {
+		int idx = i + KM_TYPE_NR * smp_processor_id();
+		pte_t *ptep = kmap_pte - idx;
+
+		kpte_clear_flush(ptep, __fix_to_virt(FIX_KMAP_BEGIN + idx));
+	}
+	/*
+	 * Restore @next_p's kmap_atomic mappings
+	 */
+	for (i = 0; i < next_p->kmap_idx; i++) {
+		int idx = i + KM_TYPE_NR * smp_processor_id();
+
+		set_pte(kmap_pte - idx, next_p->kmap_pte[i]);
+	}
+}
+#else
+static inline void
+switch_kmaps(struct task_struct *prev_p, struct task_struct *next_p) { }
+#endif
+
 
 /*
  *	switch_to(x,y) should switch tasks from x to y.
@@ -277,40 +305,7 @@ __switch_to(struct task_struct *prev_p, 
 		     task_thread_info(next_p)->flags & _TIF_WORK_CTXSW_NEXT))
 		__switch_to_xtra(prev_p, next_p, tss);
 
-#if defined CONFIG_PREEMPT_RT_FULL && defined CONFIG_HIGHMEM
-	/*
-	 * Save @prev's kmap_atomic stack
-	 */
-	prev_p->kmap_idx = __this_cpu_read(__kmap_atomic_idx);
-	if (unlikely(prev_p->kmap_idx)) {
-		int i;
-
-		for (i = 0; i < prev_p->kmap_idx; i++) {
-			int idx = i + KM_TYPE_NR * smp_processor_id();
-
-			pte_t *ptep = kmap_pte - idx;
-			prev_p->kmap_pte[i] = *ptep;
-			kpte_clear_flush(ptep, __fix_to_virt(FIX_KMAP_BEGIN + idx));
-		}
-
-		__this_cpu_write(__kmap_atomic_idx, 0);
-	}
-
-	/*
-	 * Restore @next_p's kmap_atomic stack
-	 */
-	if (unlikely(next_p->kmap_idx)) {
-		int i;
-
-		__this_cpu_write(__kmap_atomic_idx, next_p->kmap_idx);
-
-		for (i = 0; i < next_p->kmap_idx; i++) {
-			int idx = i + KM_TYPE_NR * smp_processor_id();
-
-			set_pte(kmap_pte - idx, next_p->kmap_pte[i]);
-		}
-	}
-#endif
+	switch_kmaps(prev_p, next_p);
 
 	/*
 	 * Leave lazy mode, flushing any hypercalls made here.
Index: linux-stable/arch/x86/mm/highmem_32.c
===================================================================
--- linux-stable.orig/arch/x86/mm/highmem_32.c
+++ linux-stable/arch/x86/mm/highmem_32.c
@@ -21,17 +21,6 @@ void kunmap(struct page *page)
 }
 EXPORT_SYMBOL(kunmap);
 
-#ifdef CONFIF_PREEMPT_RT_FULL
-void *__kmap_prot(struct page *page, pgprot_t prot)
-{
-	might_sleep();
-	if (!PageHighMem(page))
-		return page_address(page);
-	return kmap_high_prot(page, prot);
-}
-#endif
-
-#ifndef CONFIG_PREEMPT_RT_FULL
 /*
  * kmap_atomic/kunmap_atomic is significantly faster than kmap/kunmap because
  * no global lock is needed and because the kmap code must perform a global TLB
@@ -42,6 +31,7 @@ void *__kmap_prot(struct page *page, pgp
  */
 void *kmap_atomic_prot(struct page *page, pgprot_t prot)
 {
+	pte_t pte = mk_pte(page, prot);
 	unsigned long vaddr;
 	int idx, type;
 
@@ -55,7 +45,10 @@ void *kmap_atomic_prot(struct page *page
 	idx = type + KM_TYPE_NR*smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	WARN_ON(!pte_none(*(kmap_pte-idx)));
-	set_pte(kmap_pte-idx, mk_pte(page, prot));
+#ifdef CONFIG_PREEMPT_RT_FULL
+	current->kmap_pte[type] = pte;
+#endif
+	set_pte(kmap_pte-idx, pte);
 	arch_flush_lazy_mmu_mode();
 
 	return (void *)vaddr;
@@ -126,7 +119,6 @@ struct page *kmap_atomic_to_page(void *p
 	return pte_page(*pte);
 }
 EXPORT_SYMBOL(kmap_atomic_to_page);
-#endif
 
 void __init set_highmem_pages_init(void)
 {
Index: linux-stable/include/linux/highmem.h
===================================================================
--- linux-stable.orig/include/linux/highmem.h
+++ linux-stable/include/linux/highmem.h
@@ -7,6 +7,7 @@
 #include <linux/mm.h>
 #include <linux/uaccess.h>
 #include <linux/hardirq.h>
+#include <linux/sched.h>
 
 #include <asm/cacheflush.h>
 
@@ -59,8 +60,6 @@ static inline void *kmap(struct page *pa
 	return page_address(page);
 }
 
-#define __kmap_prot(page, prot)	kmap(page)
-
 static inline void kunmap(struct page *page)
 {
 }
@@ -87,32 +86,49 @@ static inline void __kunmap_atomic(void 
 
 #if defined(CONFIG_HIGHMEM) || defined(CONFIG_X86_32)
 
+#ifndef CONFIG_PREEMPT_RT_FULL
 DECLARE_PER_CPU(int, __kmap_atomic_idx);
+#endif
 
 static inline int kmap_atomic_idx_push(void)
 {
+#ifndef CONFIG_PREEMPT_RT_FULL
 	int idx = __this_cpu_inc_return(__kmap_atomic_idx) - 1;
 
-#ifdef CONFIG_DEBUG_HIGHMEM
+# ifdef CONFIG_DEBUG_HIGHMEM
 	WARN_ON_ONCE(in_irq() && !irqs_disabled());
 	BUG_ON(idx > KM_TYPE_NR);
-#endif
+# endif
 	return idx;
+#else
+	return current->kmap_idx++;
+#endif
 }
 
 static inline int kmap_atomic_idx(void)
 {
+#ifndef CONFIG_PREEMPT_RT_FULL
 	return __this_cpu_read(__kmap_atomic_idx) - 1;
+#else
+	return current->kmap_idx - 1;
+#endif
 }
 
 static inline void kmap_atomic_idx_pop(void)
 {
-#ifdef CONFIG_DEBUG_HIGHMEM
+#ifndef CONFIG_PREEMPT_RT_FULL
+# ifdef CONFIG_DEBUG_HIGHMEM
 	int idx = __this_cpu_dec_return(__kmap_atomic_idx);
 
 	BUG_ON(idx < 0);
-#else
+# else
 	__this_cpu_dec(__kmap_atomic_idx);
+# endif
+#else
+	current->kmap_idx--;
+# ifdef CONFIG_DEBUG_HIGHMEM
+	BUG_ON(current->kmap_idx < 0);
+# endif
 #endif
 }
 
Index: linux-stable/include/linux/sched.h
===================================================================
--- linux-stable.orig/include/linux/sched.h
+++ linux-stable/include/linux/sched.h
@@ -1621,9 +1621,11 @@ struct task_struct {
 	int softirq_nestcnt;
 	unsigned int softirqs_raised;
 #endif
-#if defined CONFIG_PREEMPT_RT_FULL && defined CONFIG_HIGHMEM
+#ifdef CONFIG_PREEMPT_RT_FULL
+# if defined CONFIG_HIGHMEM || defined CONFIG_X86_32
 	int kmap_idx;
 	pte_t kmap_pte[KM_TYPE_NR];
+# endif
 #endif
 
 #ifdef CONFIG_DEBUG_PREEMPT
Index: linux-stable/localversion-rt
===================================================================
--- linux-stable.orig/localversion-rt
+++ linux-stable/localversion-rt
@@ -1 +1 @@
--rt28
+-rt29
Index: linux-stable/mm/highmem.c
===================================================================
--- linux-stable.orig/mm/highmem.c
+++ linux-stable/mm/highmem.c
@@ -29,10 +29,11 @@
 #include <linux/kgdb.h>
 #include <asm/tlbflush.h>
 
-
+#ifndef CONFIG_PREEMPT_RT_FULL
 #if defined(CONFIG_HIGHMEM) || defined(CONFIG_X86_32)
 DEFINE_PER_CPU(int, __kmap_atomic_idx);
 #endif
+#endif
 
 /*
  * Virtual_count is not a pure "count".
@@ -47,8 +48,9 @@ DEFINE_PER_CPU(int, __kmap_atomic_idx);
 unsigned long totalhigh_pages __read_mostly;
 EXPORT_SYMBOL(totalhigh_pages);
 
-
+#ifndef CONFIG_PREEMPT_RT_FULL
 EXPORT_PER_CPU_SYMBOL(__kmap_atomic_idx);
+#endif
 
 unsigned int nr_free_highpages (void)
 {
@@ -157,7 +159,7 @@ void kmap_flush_unused(void)
 	unlock_kmap();
 }
 
-static inline unsigned long map_new_virtual(struct page *page, pgprot_t prot)
+static inline unsigned long map_new_virtual(struct page *page)
 {
 	unsigned long vaddr;
 	int count;
@@ -199,7 +201,7 @@ start:
 	}
 	vaddr = PKMAP_ADDR(last_pkmap_nr);
 	set_pte_at(&init_mm, vaddr,
-		   &(pkmap_page_table[last_pkmap_nr]), mk_pte(page, prot));
+		   &(pkmap_page_table[last_pkmap_nr]), mk_pte(page, kmap_prot));
 
 	pkmap_count[last_pkmap_nr] = 1;
 	set_page_address(page, (void *)vaddr);
@@ -215,7 +217,7 @@ start:
  *
  * We cannot call this from interrupts, as it may block.
  */
-void *kmap_high_prot(struct page *page, pgprot_t prot)
+void *kmap_high(struct page *page)
 {
 	unsigned long vaddr;
 
@@ -226,26 +228,13 @@ void *kmap_high_prot(struct page *page, 
 	lock_kmap();
 	vaddr = (unsigned long)page_address(page);
 	if (!vaddr)
-		vaddr = map_new_virtual(page, prot);
+		vaddr = map_new_virtual(page);
 	pkmap_count[PKMAP_NR(vaddr)]++;
 	BUG_ON(pkmap_count[PKMAP_NR(vaddr)] < 2);
 	unlock_kmap();
 	return (void*) vaddr;
 }
-EXPORT_SYMBOL(kmap_high_prot);
 
-/**
- * kmap_high - map a highmem page into memory
- * @page: &struct page to map
- *
- * Returns the page's virtual memory address.
- *
- * We cannot call this from interrupts, as it may block.
- */
-void *kmap_high(struct page *page)
-{
-	return kmap_high_prot(page, kmap_prot);
-}
 EXPORT_SYMBOL(kmap_high);
 
 #ifdef ARCH_NEEDS_KMAP_HIGH_GET
Index: linux-stable/arch/x86/mm/iomap_32.c
===================================================================
--- linux-stable.orig/arch/x86/mm/iomap_32.c
+++ linux-stable/arch/x86/mm/iomap_32.c
@@ -56,6 +56,7 @@ EXPORT_SYMBOL_GPL(iomap_free);
 
 void *kmap_atomic_prot_pfn(unsigned long pfn, pgprot_t prot)
 {
+	pte_t pte = pfn_pte(pfn, prot);
 	unsigned long vaddr;
 	int idx, type;
 
@@ -64,7 +65,10 @@ void *kmap_atomic_prot_pfn(unsigned long
 	type = kmap_atomic_idx_push();
 	idx = type + KM_TYPE_NR * smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
-	set_pte(kmap_pte - idx, pfn_pte(pfn, prot));
+#ifdef CONFIG_PREEMPT_RT_FULL
+	current->kmap_pte[type] = pte;
+#endif
+	set_pte(kmap_pte - idx, pte);
 	arch_flush_lazy_mmu_mode();
 
 	return (void *)vaddr;
Index: linux-stable/arch/arm/include/asm/switch_to.h
===================================================================
--- linux-stable.orig/arch/arm/include/asm/switch_to.h
+++ linux-stable/arch/arm/include/asm/switch_to.h
@@ -3,6 +3,14 @@
 
 #include <linux/thread_info.h>
 
+#if defined CONFIG_PREEMPT_RT_FULL && defined CONFIG_HIGHMEM
+void switch_kmaps(struct task_struct *prev_p, struct task_struct *next_p);
+#else
+static inline void
+switch_kmaps(struct task_struct *prev_p, struct task_struct *next_p) { }
+#endif
+
+
 /*
  * switch_to(prev, next) should switch from task `prev' to `next'
  * `prev' will never be the same as `next'.  schedule() itself
@@ -12,6 +20,7 @@ extern struct task_struct *__switch_to(s
 
 #define switch_to(prev,next,last)					\
 do {									\
+	switch_kmaps(prev, next);					\
 	last = __switch_to(prev,task_thread_info(prev), task_thread_info(next));	\
 } while (0)
 
