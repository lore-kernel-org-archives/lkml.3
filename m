Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760769Ab3JPXH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 19:07:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39798 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800Ab3JPXH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 19:07:28 -0400
Date: Thu, 17 Oct 2013 01:07:12 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Don Zickus <dzickus@redhat.com>, dave.hansen@linux.intel.com,
        eranian@google.com, jmario@redhat.com, linux-kernel@vger.kernel.org,
        acme@infradead.org, mingo@kernel.org
Subject: Re: [PATCH] perf, x86: Optimize intel_pmu_pebs_fixup_ip()
Message-ID: <20131016230712.GC26785@twins.programming.kicks-ass.net>
References: <20131014203549.GY227855@redhat.com>
 <20131015101404.GD10651@twins.programming.kicks-ass.net>
 <20131015130226.GX26785@twins.programming.kicks-ass.net>
 <20131015143227.GY26785@twins.programming.kicks-ass.net>
 <20131015150736.GZ26785@twins.programming.kicks-ass.net>
 <20131015154104.GA227855@redhat.com>
 <20131016105755.GX10651@twins.programming.kicks-ass.net>
 <20131016205227.GJ7456@tassilo.jf.intel.com>
 <20131016210319.GI10651@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131016210319.GI10651@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 11:03:19PM +0200, Peter Zijlstra wrote:
> Anyway; if you want to have a go at this, feel free.

OK, couldn't help myself; completely untested patch below.

I think the full once copy it best for the decode as even with the below
interface you'd end up doing a lot of duplicate copying due to the
variable size insn mess.

But it should help lots with the fragmented stack pointer chase, where
hopefully you'd have multiple frames on the same stack page.

---
 arch/x86/include/asm/uaccess.h   | 13 +++++++
 arch/x86/kernel/cpu/perf_event.c |  9 ++++-
 arch/x86/lib/usercopy.c          | 84 ++++++++++++++++++++++++++++++++++++++--
 arch/x86/mm/gup.c                | 63 +++++++++++++++++++-----------
 4 files changed, 141 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 5838fa911aa0..06c87fc989bd 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -516,6 +516,19 @@ struct __large_struct { unsigned long buf[100]; };
 
 extern unsigned long
 copy_from_user_nmi(void *to, const void __user *from, unsigned long n);
+
+struct copy_from_user_nmi_state {
+	unsigned long address;
+	unsigned long flags;
+	void *map;
+}
+
+extern unsigned long
+copy_from_user_nmi_iter(void *to, const void __user *from,
+			unsigned long n, struct copy_from_user_nmi_state *state);
+extern void
+copy_from_user_nmi_end(struct copy_from_user_nmi_state *state);
+
 extern __must_check long
 strncpy_from_user(char *dst, const char __user *src, long count);
 
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 19c9d86d2f04..7faf12c585d0 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1979,6 +1979,7 @@ static inline int
 perf_callchain_user32(struct pt_regs *regs, struct perf_callchain_entry *entry)
 {
 	/* 32-bit process in 64-bit kernel. */
+	struct copy_from_user_nmi_state state = { 0, 0, NULL };
 	unsigned long ss_base, cs_base;
 	struct stack_frame_ia32 frame;
 	const void __user *fp;
@@ -1995,7 +1996,7 @@ perf_callchain_user32(struct pt_regs *regs, struct perf_callchain_entry *entry)
 		frame.next_frame     = 0;
 		frame.return_address = 0;
 
-		bytes = copy_from_user_nmi(&frame, fp, sizeof(frame));
+		bytes = copy_from_user_nmi_iter(&frame, fp, sizeof(frame), &state);
 		if (bytes != sizeof(frame))
 			break;
 
@@ -2005,6 +2006,7 @@ perf_callchain_user32(struct pt_regs *regs, struct perf_callchain_entry *entry)
 		perf_callchain_store(entry, cs_base + frame.return_address);
 		fp = compat_ptr(ss_base + frame.next_frame);
 	}
+	copy_from_user_nmi_end(&state);
 	return 1;
 }
 #else
@@ -2018,6 +2020,7 @@ perf_callchain_user32(struct pt_regs *regs, struct perf_callchain_entry *entry)
 void
 perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
 {
+	struct copy_from_user_nmi_state state = { 0, 0, NULL };
 	struct stack_frame frame;
 	const void __user *fp;
 
@@ -2044,10 +2047,11 @@ perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
 
 	while (entry->nr < PERF_MAX_STACK_DEPTH) {
 		unsigned long bytes;
+
 		frame.next_frame	     = NULL;
 		frame.return_address = 0;
 
-		bytes = copy_from_user_nmi(&frame, fp, sizeof(frame));
+		bytes = copy_from_user_nmi_iter(&frame, fp, sizeof(frame), &state);
 		if (bytes != sizeof(frame))
 			break;
 
@@ -2057,6 +2061,7 @@ perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
 		perf_callchain_store(entry, frame.return_address);
 		fp = frame.next_frame;
 	}
+	copy_from_user_nmi_end(&state);
 }
 
 /*
diff --git a/arch/x86/lib/usercopy.c b/arch/x86/lib/usercopy.c
index 4f74d94c8d97..bce8179227cf 100644
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
@@ -18,6 +20,7 @@ copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
 {
 	unsigned long offset, addr = (unsigned long)from;
 	unsigned long size, len = 0;
+	unsigned long flags;
 	struct page *page;
 	void *map;
 	int ret;
@@ -26,9 +29,12 @@ copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
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
@@ -36,7 +42,7 @@ copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
 		map = kmap_atomic(page);
 		memcpy(to, map+offset, size);
 		kunmap_atomic(map);
-		put_page(page);
+		local_irq_restore(flags);
 
 		len  += size;
 		to   += size;
@@ -47,3 +53,75 @@ copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
 	return len;
 }
 EXPORT_SYMBOL_GPL(copy_from_user_nmi);
+
+unsigned long
+copy_from_user_nmi_iter(void *to, const void __user *from, unsigned long n,
+			struct copy_from_user_nmi_state *state)
+{
+	unsigned long offset, addr = (unsigned long)from;
+	unsigned long size, len = 0;
+	unsigned long flags;
+	struct page *page;
+	void *map;
+	int ret;
+
+	if (__range_not_ok(from, n, TASK_SIZE))
+		return len;
+
+	if (state->map) {
+		if ((state->address >> PAGE_SHIFT) ==
+		    (addr >> PAGE_SHIFT)) {
+			flags = state->flags;
+			map = state->map;
+			goto got_page;
+		}
+		kunmap_atomic(state->map);
+		local_irq_restore(state->flags);
+	}
+
+	do {
+		local_irq_save(flags);
+		ret = ___get_user_pages_fast(addr, 1, 0, &page);
+		if (!ret) {
+			local_irq_restore(flags);
+			break;
+		}
+
+		map = kmap_atomic(page);
+got_page:
+		offset = addr & (PAGE_SIZE - 1);
+		size = min(PAGE_SIZE - offset, n - len);
+
+		memcpy(to, map+offset, size);
+
+		len  += size;
+		to   += size;
+		addr += size;
+
+		if (len == n && offset + size < PAGE_SIZE) {
+			state->address = addr;
+			state->flags = flags;
+			state->map = map;
+			return len;
+		}
+
+		kunmap_atomic(map);
+		local_irq_restore(flags);
+
+	} while (len < n);
+
+	memset(state, 0, sizeof(*state));
+
+	return len;
+}
+EXPORT_SYMBOL_GPL(copy_from_user_nmi_iter);
+
+void copy_from_user_nmi_end(struct copy_from_user_nmi_state *state)
+{
+	if (state->map) {
+		kunmap_atomic(state->map);
+		local_irq_restore(state->flags);
+		memset(state, 0, sizeof(*state));
+	}
+}
+EXPORT_SYMBOL_GPL(copy_from_user_nmi_end);
diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
index dd74e46828c0..e383caf323e4 100644
--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -63,19 +63,22 @@ static inline pte_t gup_get_pte(pte_t *ptep)
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
@@ -89,7 +92,8 @@ static noinline int gup_pte_range(pmd_t pmd, unsigned long addr,
 		}
 		VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
 		page = pte_page(pte);
-		get_page(page);
+		if (flags & GUPF_GET)
+			get_page(page);
 		SetPageReferenced(page);
 		pages[*nr] = page;
 		(*nr)++;
@@ -109,7 +113,7 @@ static inline void get_head_page_multiple(struct page *page, int nr)
 }
 
 static noinline int gup_huge_pmd(pmd_t pmd, unsigned long addr,
-		unsigned long end, int write, struct page **pages, int *nr)
+		unsigned long end, int flags, struct page **pages, int *nr)
 {
 	unsigned long mask;
 	pte_t pte = *(pte_t *)&pmd;
@@ -117,7 +121,7 @@ static noinline int gup_huge_pmd(pmd_t pmd, unsigned long addr,
 	int refs;
 
 	mask = _PAGE_PRESENT|_PAGE_USER;
-	if (write)
+	if (flags & GUPF_WRITE)
 		mask |= _PAGE_RW;
 	if ((pte_flags(pte) & mask) != mask)
 		return 0;
@@ -131,19 +135,20 @@ static noinline int gup_huge_pmd(pmd_t pmd, unsigned long addr,
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
@@ -167,10 +172,10 @@ static int gup_pmd_range(pud_t pud, unsigned long addr, unsigned long end,
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
@@ -179,7 +184,7 @@ static int gup_pmd_range(pud_t pud, unsigned long addr, unsigned long end,
 }
 
 static noinline int gup_huge_pud(pud_t pud, unsigned long addr,
-		unsigned long end, int write, struct page **pages, int *nr)
+		unsigned long end, int flags, struct page **pages, int *nr)
 {
 	unsigned long mask;
 	pte_t pte = *(pte_t *)&pud;
@@ -187,7 +192,7 @@ static noinline int gup_huge_pud(pud_t pud, unsigned long addr,
 	int refs;
 
 	mask = _PAGE_PRESENT|_PAGE_USER;
-	if (write)
+	if (flags & GUPF_WRITE)
 		mask |= _PAGE_RW;
 	if ((pte_flags(pte) & mask) != mask)
 		return 0;
@@ -201,19 +206,20 @@ static noinline int gup_huge_pud(pud_t pud, unsigned long addr,
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
@@ -226,10 +232,10 @@ static int gup_pud_range(pgd_t pgd, unsigned long addr, unsigned long end,
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
@@ -241,13 +247,12 @@ static int gup_pud_range(pgd_t pgd, unsigned long addr, unsigned long end,
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
 
@@ -255,7 +260,7 @@ int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
 	addr = start;
 	len = (unsigned long) nr_pages << PAGE_SHIFT;
 	end = start + len;
-	if (unlikely(!access_ok(write ? VERIFY_WRITE : VERIFY_READ,
+	if (unlikely(!access_ok((flags & GUPF_WRITE) ? VERIFY_WRITE : VERIFY_READ,
 					(void __user *)start, len)))
 		return 0;
 
@@ -277,7 +282,6 @@ int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
 	 * (which we do on x86, with the above PAE exception), we can follow the
 	 * address down to the the page and take a ref on it.
 	 */
-	local_irq_save(flags);
 	pgdp = pgd_offset(mm, addr);
 	do {
 		pgd_t pgd = *pgdp;
@@ -285,14 +289,27 @@ int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
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
