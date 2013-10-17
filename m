Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762822Ab3JQVId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 17:08:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35525 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758386Ab3JQVIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 17:08:32 -0400
Date: Thu, 17 Oct 2013 23:08:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Don Zickus <dzickus@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        dave.hansen@linux.intel.com, Stephane Eranian <eranian@google.com>,
        jmario@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] perf, x86: Optimize intel_pmu_pebs_fixup_ip()
Message-ID: <20131017210816.GY10651@twins.programming.kicks-ass.net>
References: <20131015154104.GA227855@redhat.com>
 <20131016105755.GX10651@twins.programming.kicks-ass.net>
 <20131016205227.GJ7456@tassilo.jf.intel.com>
 <20131016210319.GI10651@twins.programming.kicks-ass.net>
 <20131016230712.GC26785@twins.programming.kicks-ass.net>
 <20131017094145.GE3364@laptop.programming.kicks-ass.net>
 <20131017160034.GO227855@redhat.com>
 <20131017160439.GP227855@redhat.com>
 <20131017163039.GR10651@twins.programming.kicks-ass.net>
 <CA+55aFx-1Xu2aSvAMi8SSUwq-J9Yo3oJGY8yUYWyAZmZmr8prQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx-1Xu2aSvAMi8SSUwq-J9Yo3oJGY8yUYWyAZmZmr8prQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 11:26:23AM -0700, Linus Torvalds wrote:
> On Thu, Oct 17, 2013 at 9:30 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > So avoid having to call copy_from_user_nmi() for every instruction.
> > Since we already limit the max basic block size, we can easily
> > pre-allocate a piece of memory to copy the entire thing into in one
> > go.
> 
> copy_from_user_nmi() itself is all kinds of nasty.
> 
> Using __get_user_pages_fast() for a single page is quite expensive,
> and mucks around with the page counts etc.
> 
> If copy_from_user_nmi() just did the (simple) page table walk by hand,
> it could avoid *all* of that. No page count stuff - just have
> interrupts disabled over not just the page walk, but the copy too - to
> guarantee that no cross-CPU TLB flush can come in.
> 
> So instead of trying to improve __get_user_pages_fast() - which is
> impossible because the interface fundamentally means that it has to
> iterate over things and check page counts - you could simplify the
> caller instead.
> 
> That is, if we really care any more. Maybe this "do the
> copy_from_user_nmi() just once" is already good enough that nobody
> much cares.

I did a patch that avoids the page count mucking about, Don didn't see
any significant improvements from it.

---
Subject: x86: Optimize copy_from_user_nmi()
From: Peter Zijlstra <peterz@infradead.org>
Date: Wed Oct 16 10:55:59 CEST 2013

Since copy_from_user_nmi() is pretty much always called from either
IRQ or NMI context there's no need to take and release a reference on
the page.

Provide yet another __gup_fast() interface: '___gup_fast()' which
assumes the called has disabled IRQs and which makes the taking of
page count references optional.

Then change copy_from_user_nmi() to use this new variant to avoid
taking and releasing page references, thereby avoiding a number of
atomic ops.

This can be esp. useful when profiling threaded apps that run mostly
the same code; in that case intel_pmu_pebs_fixup_ip() can call
copy_form_user_nmi() a lot on the same few text pages from many CPUs
at the same time.

Cc: eranian@google.com
Cc: Don Zickus <dzickus@redhat.com>
Cc: jmario@redhat.com
Cc: acme@infradead.org
Cc: mingo@kernel.org
Cc: dave.hansen@linux.intel.com
Suggested-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20131015150736.GZ26785@twins.programming.kicks-ass.net
---
 arch/x86/lib/usercopy.c |   12 ++++++---
 arch/x86/mm/gup.c       |   63 ++++++++++++++++++++++++++++++------------------
 2 files changed, 49 insertions(+), 26 deletions(-)

--- a/arch/x86/lib/usercopy.c
+++ b/arch/x86/lib/usercopy.c
@@ -10,6 +10,8 @@
 #include <asm/word-at-a-time.h>
 #include <linux/sched.h>
 
+extern int ___get_user_pages_fast(unsigned long start, int nr_pages, int flags,
+			  struct page **pages);
 /*
  * best effort, GUP based copy_from_user() that is NMI-safe
  */
@@ -18,6 +20,7 @@ copy_from_user_nmi(void *to, const void
 {
 	unsigned long offset, addr = (unsigned long)from;
 	unsigned long size, len = 0;
+	unsigned long flags;
 	struct page *page;
 	void *map;
 	int ret;
@@ -26,9 +29,12 @@ copy_from_user_nmi(void *to, const void
 		return len;
 
 	do {
-		ret = __get_user_pages_fast(addr, 1, 0, &page);
-		if (!ret)
+		local_irq_save(flags);
+		ret = ___get_user_pages_fast(addr, 1, 0, &page);
+		if (!ret) {
+			local_irq_restore(flags);
 			break;
+		}
 
 		offset = addr & (PAGE_SIZE - 1);
 		size = min(PAGE_SIZE - offset, n - len);
@@ -36,7 +42,7 @@ copy_from_user_nmi(void *to, const void
 		map = kmap_atomic(page);
 		memcpy(to, map+offset, size);
 		kunmap_atomic(map);
-		put_page(page);
+		local_irq_restore(flags);
 
 		len  += size;
 		to   += size;
--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -63,19 +63,22 @@ static inline pte_t gup_get_pte(pte_t *p
 #endif
 }
 
+#define GUPF_GET	0x01
+#define GUPF_WRITE	0x02
+
 /*
  * The performance critical leaf functions are made noinline otherwise gcc
  * inlines everything into a single function which results in too much
  * register pressure.
  */
 static noinline int gup_pte_range(pmd_t pmd, unsigned long addr,
-		unsigned long end, int write, struct page **pages, int *nr)
+		unsigned long end, int flags, struct page **pages, int *nr)
 {
 	unsigned long mask;
 	pte_t *ptep;
 
 	mask = _PAGE_PRESENT|_PAGE_USER;
-	if (write)
+	if (flags & GUPF_WRITE)
 		mask |= _PAGE_RW;
 
 	ptep = pte_offset_map(&pmd, addr);
@@ -89,7 +92,8 @@ static noinline int gup_pte_range(pmd_t
 		}
 		VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
 		page = pte_page(pte);
-		get_page(page);
+		if (flags & GUPF_GET)
+			get_page(page);
 		SetPageReferenced(page);
 		pages[*nr] = page;
 		(*nr)++;
@@ -109,7 +113,7 @@ static inline void get_head_page_multipl
 }
 
 static noinline int gup_huge_pmd(pmd_t pmd, unsigned long addr,
-		unsigned long end, int write, struct page **pages, int *nr)
+		unsigned long end, int flags, struct page **pages, int *nr)
 {
 	unsigned long mask;
 	pte_t pte = *(pte_t *)&pmd;
@@ -117,7 +121,7 @@ static noinline int gup_huge_pmd(pmd_t p
 	int refs;
 
 	mask = _PAGE_PRESENT|_PAGE_USER;
-	if (write)
+	if (flags & GUPF_WRITE)
 		mask |= _PAGE_RW;
 	if ((pte_flags(pte) & mask) != mask)
 		return 0;
@@ -131,19 +135,20 @@ static noinline int gup_huge_pmd(pmd_t p
 	do {
 		VM_BUG_ON(compound_head(page) != head);
 		pages[*nr] = page;
-		if (PageTail(page))
+		if ((flags & GUPF_GET) && PageTail(page))
 			get_huge_page_tail(page);
 		(*nr)++;
 		page++;
 		refs++;
 	} while (addr += PAGE_SIZE, addr != end);
-	get_head_page_multiple(head, refs);
+	if (flags & GUPF_GET)
+		get_head_page_multiple(head, refs);
 
 	return 1;
 }
 
 static int gup_pmd_range(pud_t pud, unsigned long addr, unsigned long end,
-		int write, struct page **pages, int *nr)
+		int flags, struct page **pages, int *nr)
 {
 	unsigned long next;
 	pmd_t *pmdp;
@@ -167,10 +172,10 @@ static int gup_pmd_range(pud_t pud, unsi
 		if (pmd_none(pmd) || pmd_trans_splitting(pmd))
 			return 0;
 		if (unlikely(pmd_large(pmd))) {
-			if (!gup_huge_pmd(pmd, addr, next, write, pages, nr))
+			if (!gup_huge_pmd(pmd, addr, next, flags, pages, nr))
 				return 0;
 		} else {
-			if (!gup_pte_range(pmd, addr, next, write, pages, nr))
+			if (!gup_pte_range(pmd, addr, next, flags, pages, nr))
 				return 0;
 		}
 	} while (pmdp++, addr = next, addr != end);
@@ -179,7 +184,7 @@ static int gup_pmd_range(pud_t pud, unsi
 }
 
 static noinline int gup_huge_pud(pud_t pud, unsigned long addr,
-		unsigned long end, int write, struct page **pages, int *nr)
+		unsigned long end, int flags, struct page **pages, int *nr)
 {
 	unsigned long mask;
 	pte_t pte = *(pte_t *)&pud;
@@ -187,7 +192,7 @@ static noinline int gup_huge_pud(pud_t p
 	int refs;
 
 	mask = _PAGE_PRESENT|_PAGE_USER;
-	if (write)
+	if (flags & GUPF_WRITE)
 		mask |= _PAGE_RW;
 	if ((pte_flags(pte) & mask) != mask)
 		return 0;
@@ -201,19 +206,20 @@ static noinline int gup_huge_pud(pud_t p
 	do {
 		VM_BUG_ON(compound_head(page) != head);
 		pages[*nr] = page;
-		if (PageTail(page))
+		if ((flags & GUPF_GET) && PageTail(page))
 			get_huge_page_tail(page);
 		(*nr)++;
 		page++;
 		refs++;
 	} while (addr += PAGE_SIZE, addr != end);
-	get_head_page_multiple(head, refs);
+	if (flags & GUPF_GET)
+		get_head_page_multiple(head, refs);
 
 	return 1;
 }
 
 static int gup_pud_range(pgd_t pgd, unsigned long addr, unsigned long end,
-			int write, struct page **pages, int *nr)
+			int flags, struct page **pages, int *nr)
 {
 	unsigned long next;
 	pud_t *pudp;
@@ -226,10 +232,10 @@ static int gup_pud_range(pgd_t pgd, unsi
 		if (pud_none(pud))
 			return 0;
 		if (unlikely(pud_large(pud))) {
-			if (!gup_huge_pud(pud, addr, next, write, pages, nr))
+			if (!gup_huge_pud(pud, addr, next, flags, pages, nr))
 				return 0;
 		} else {
-			if (!gup_pmd_range(pud, addr, next, write, pages, nr))
+			if (!gup_pmd_range(pud, addr, next, flags, pages, nr))
 				return 0;
 		}
 	} while (pudp++, addr = next, addr != end);
@@ -241,13 +247,12 @@ static int gup_pud_range(pgd_t pgd, unsi
  * Like get_user_pages_fast() except its IRQ-safe in that it won't fall
  * back to the regular GUP.
  */
-int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
+int ___get_user_pages_fast(unsigned long start, int nr_pages, int flags,
 			  struct page **pages)
 {
 	struct mm_struct *mm = current->mm;
 	unsigned long addr, len, end;
 	unsigned long next;
-	unsigned long flags;
 	pgd_t *pgdp;
 	int nr = 0;
 
@@ -255,7 +260,7 @@ int __get_user_pages_fast(unsigned long
 	addr = start;
 	len = (unsigned long) nr_pages << PAGE_SHIFT;
 	end = start + len;
-	if (unlikely(!access_ok(write ? VERIFY_WRITE : VERIFY_READ,
+	if (unlikely(!access_ok((flags & GUPF_WRITE) ? VERIFY_WRITE : VERIFY_READ,
 					(void __user *)start, len)))
 		return 0;
 
@@ -277,7 +282,6 @@ int __get_user_pages_fast(unsigned long
 	 * (which we do on x86, with the above PAE exception), we can follow the
 	 * address down to the the page and take a ref on it.
 	 */
-	local_irq_save(flags);
 	pgdp = pgd_offset(mm, addr);
 	do {
 		pgd_t pgd = *pgdp;
@@ -285,14 +289,27 @@ int __get_user_pages_fast(unsigned long
 		next = pgd_addr_end(addr, end);
 		if (pgd_none(pgd))
 			break;
-		if (!gup_pud_range(pgd, addr, next, write, pages, &nr))
+		if (!gup_pud_range(pgd, addr, next, flags, pages, &nr))
 			break;
 	} while (pgdp++, addr = next, addr != end);
-	local_irq_restore(flags);
 
 	return nr;
 }
 
+int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
+			  struct page **pages)
+{
+	unsigned long flags;
+	int ret;
+
+	local_irq_save(flags);
+	ret = ___get_user_pages_fast(start, nr_pages,
+			GUPF_GET | (write ? GUPF_WRITE : 0), pages);
+	local_irq_restore(flags);
+
+	return ret;
+}
+
 /**
  * get_user_pages_fast() - pin user pages in memory
  * @start:	starting user address
