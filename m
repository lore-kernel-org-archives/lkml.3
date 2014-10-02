Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbaJBPy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 11:54:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753540AbaJBPy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 11:54:28 -0400
Date: Thu, 2 Oct 2014 17:53:48 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andres Lagar-Cavilla <andreslc@google.com>, Gleb Natapov <gleb@kernel.org>,
        Radim Krcmar <rkrcmar@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>, Jianyu Zhan <nasa4836@gmail.com>,
        Paul Cassella <cassella@cray.com>, Hugh Dickins <hughd@google.com>,
        Peter Feiner <pfeiner@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: RFC: get_user_pages_locked|unlocked to leverage VM_FAULT_RETRY
Message-ID: <20141002155348.GI2342@redhat.com>
References: <20140926172535.GC4590@redhat.com>
 <20141001153611.GC2843@worktop.programming.kicks-ass.net>
 <20141002123117.GB2342@redhat.com>
 <20141002125052.GF2849@worktop.programming.kicks-ass.net>
 <20141002125638.GE6324@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141002125638.GE6324@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 02:56:38PM +0200, Peter Zijlstra wrote:
> On Thu, Oct 02, 2014 at 02:50:52PM +0200, Peter Zijlstra wrote:
> > On Thu, Oct 02, 2014 at 02:31:17PM +0200, Andrea Arcangeli wrote:
> > > On Wed, Oct 01, 2014 at 05:36:11PM +0200, Peter Zijlstra wrote:
> > > > For all these and the other _fast() users, is there an actual limit to
> > > > the nr_pages passed in? Because we used to have the 64 pages limit from
> > > > DIO, but without that we get rather long IRQ-off latencies.
> > > 
> > > Ok, I would tend to think this is an issue to solve in gup_fast
> > > implementation, I wouldn't blame or modify the callers for it.
> > > 
> > > I don't think there's anything that prevents gup_fast to enable irqs
> > > after certain number of pages have been taken, nop; and disable the
> > > irqs again.
> > > 
> > 
> > Agreed, I once upon a time had a patch set converting the 2 (x86 and
> > powerpc) gup_fast implementations at the time, but somehow that never
> > got anywhere.
> > 
> > Just saying we should probably do that before we add callers with
> > unlimited nr_pages.
> 
> https://lkml.org/lkml/2009/6/24/457
> 
> Clearly there's more work these days. Many more archs grew a gup.c

What about this? The alternative is that I do s/gup_fast/gup_unlocked/
to still retain the mmap_sem scalability benefit. It'd be still better
than the current plain gup() (and it would be equivalent for
userfaultfd point of view).

Or if the below is ok, should I modify all other archs too or are the
respective maintainers going to fix it themself? For example the arm*
gup_fast is a moving target in development on linux-mm right now and I
should only patch the gup_rcu version that didn't hit upstream yet. In
fact after that gup_rcu merge, supposedly the powerpc and sparc
gup_fast can be dropped from arch/* entirely and they can use the
generic version (otherwise having the arm gup_fast in mm/ instead of
arch/ would be a mistake). Right now, I wouldn't touch at least
arm/sparc/powerpc until the gup_rcu hit upstream as those are all
about to disappear.

Thanks,
Andrea

>From 2f6079396a59e64a380ff06e6107276dfa67b3ba Mon Sep 17 00:00:00 2001
From: Andrea Arcangeli <aarcange@redhat.com>
Date: Thu, 2 Oct 2014 16:58:00 +0200
Subject: [PATCH] mm: gup: make get_user_pages_fast and __get_user_pages_fast
 latency conscious

This teaches gup_fast and __gup_fast to re-enable irqs and
cond_resched() if possible every BATCH_PAGES.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 arch/x86/mm/gup.c | 239 +++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 154 insertions(+), 85 deletions(-)

diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
index 2ab183b..e05d7b0 100644
--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -12,6 +12,12 @@
 
 #include <asm/pgtable.h>
 
+/*
+ * Keep irq disabled for no more than BATCH_PAGES pages.
+ * Matches PTRS_PER_PTE (or half in non-PAE kernels).
+ */
+#define BATCH_PAGES	512
+
 static inline pte_t gup_get_pte(pte_t *ptep)
 {
 #ifndef CONFIG_X86_PAE
@@ -250,6 +256,40 @@ static int gup_pud_range(pgd_t pgd, unsigned long addr, unsigned long end,
 	return 1;
 }
 
+static inline int __get_user_pages_fast_batch(unsigned long start,
+					      unsigned long end,
+					      int write, struct page **pages)
+{
+	struct mm_struct *mm = current->mm;
+	unsigned long next;
+	unsigned long flags;
+	pgd_t *pgdp;
+	int nr = 0;
+
+	/*
+	 * This doesn't prevent pagetable teardown, but does prevent
+	 * the pagetables and pages from being freed on x86.
+	 *
+	 * So long as we atomically load page table pointers versus teardown
+	 * (which we do on x86, with the above PAE exception), we can follow the
+	 * address down to the the page and take a ref on it.
+	 */
+	local_irq_save(flags);
+	pgdp = pgd_offset(mm, start);
+	do {
+		pgd_t pgd = *pgdp;
+
+		next = pgd_addr_end(start, end);
+		if (pgd_none(pgd))
+			break;
+		if (!gup_pud_range(pgd, start, next, write, pages, &nr))
+			break;
+	} while (pgdp++, start = next, start != end);
+	local_irq_restore(flags);
+
+	return nr;
+}
+
 /*
  * Like get_user_pages_fast() except its IRQ-safe in that it won't fall
  * back to the regular GUP.
@@ -257,31 +297,57 @@ static int gup_pud_range(pgd_t pgd, unsigned long addr, unsigned long end,
 int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			  struct page **pages)
 {
-	struct mm_struct *mm = current->mm;
-	unsigned long addr, len, end;
-	unsigned long next;
-	unsigned long flags;
-	pgd_t *pgdp;
-	int nr = 0;
+	unsigned long len, end, batch_pages;
+	int nr, ret;
 
 	start &= PAGE_MASK;
-	addr = start;
 	len = (unsigned long) nr_pages << PAGE_SHIFT;
 	end = start + len;
+	/*
+	 * get_user_pages() handles nr_pages == 0 gracefully, but
+	 * gup_fast starts walking the first pagetable in a do {}
+	 * while() fashion so it's not robust to handle nr_pages ==
+	 * 0. There's no point in being permissive about end < start
+	 * either. So this check verifies both nr_pages being non
+	 * zero, and that "end" didn't overflow.
+	 */
+	VM_BUG_ON(end <= start);
 	if (unlikely(!access_ok(write ? VERIFY_WRITE : VERIFY_READ,
 					(void __user *)start, len)))
 		return 0;
 
-	/*
-	 * XXX: batch / limit 'nr', to avoid large irq off latency
-	 * needs some instrumenting to determine the common sizes used by
-	 * important workloads (eg. DB2), and whether limiting the batch size
-	 * will decrease performance.
-	 *
-	 * It seems like we're in the clear for the moment. Direct-IO is
-	 * the main guy that batches up lots of get_user_pages, and even
-	 * they are limited to 64-at-a-time which is not so many.
-	 */
+	ret = 0;
+	for (;;) {
+		batch_pages = nr_pages;
+		if (batch_pages > BATCH_PAGES && !irqs_disabled())
+			batch_pages = BATCH_PAGES;
+		len = (unsigned long) batch_pages << PAGE_SHIFT;
+		end = start + len;
+		nr = __get_user_pages_fast_batch(start, end, write, pages);
+		VM_BUG_ON(nr > batch_pages);
+		nr_pages -= nr;
+		ret += nr;
+		if (!nr_pages || nr != batch_pages)
+			break;
+		start += len;
+		pages += batch_pages;
+	}
+
+	return ret;
+}
+
+static inline int get_user_pages_fast_batch(unsigned long start,
+					    unsigned long end,
+					    int write, struct page **pages)
+{
+	struct mm_struct *mm = current->mm;
+	unsigned long next;
+	pgd_t *pgdp;
+	int nr = 0;
+#ifdef CONFIG_DEBUG_VM
+	unsigned long orig_start = start;
+#endif
+
 	/*
 	 * This doesn't prevent pagetable teardown, but does prevent
 	 * the pagetables and pages from being freed on x86.
@@ -290,18 +356,22 @@ int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
 	 * (which we do on x86, with the above PAE exception), we can follow the
 	 * address down to the the page and take a ref on it.
 	 */
-	local_irq_save(flags);
-	pgdp = pgd_offset(mm, addr);
+	local_irq_disable();
+	pgdp = pgd_offset(mm, start);
 	do {
 		pgd_t pgd = *pgdp;
 
-		next = pgd_addr_end(addr, end);
-		if (pgd_none(pgd))
+		next = pgd_addr_end(start, end);
+		if (pgd_none(pgd)) {
+			VM_BUG_ON(nr >= (end-orig_start) >> PAGE_SHIFT);
 			break;
-		if (!gup_pud_range(pgd, addr, next, write, pages, &nr))
+		}
+		if (!gup_pud_range(pgd, start, next, write, pages, &nr)) {
+			VM_BUG_ON(nr >= (end-orig_start) >> PAGE_SHIFT);
 			break;
-	} while (pgdp++, addr = next, addr != end);
-	local_irq_restore(flags);
+		}
+	} while (pgdp++, start = next, start != end);
+	local_irq_enable();
 
 	return nr;
 }
@@ -326,80 +396,79 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			struct page **pages)
 {
 	struct mm_struct *mm = current->mm;
-	unsigned long addr, len, end;
-	unsigned long next;
-	pgd_t *pgdp;
-	int nr = 0;
+	unsigned long len, end, batch_pages;
+	int nr, ret;
+#ifdef CONFIG_DEBUG_VM
+	unsigned long orig_start = start;
+#endif
 
 	start &= PAGE_MASK;
-	addr = start;
+#ifdef CONFIG_DEBUG_VM
+	orig_start = start;
+#endif
 	len = (unsigned long) nr_pages << PAGE_SHIFT;
 
 	end = start + len;
-	if (end < start)
-		goto slow_irqon;
+	/*
+	 * get_user_pages() handles nr_pages == 0 gracefully, but
+	 * gup_fast starts walking the first pagetable in a do {}
+	 * while() fashion so it's not robust to handle nr_pages ==
+	 * 0. There's no point in being permissive about end < start
+	 * either. So this check verifies both nr_pages being non
+	 * zero, and that "end" didn't overflow.
+	 */
+	VM_BUG_ON(end <= start);
 
+	nr = ret = 0;
 #ifdef CONFIG_X86_64
 	if (end >> __VIRTUAL_MASK_SHIFT)
 		goto slow_irqon;
 #endif
+	for (;;) {
+		cond_resched();
+		batch_pages = min(nr_pages, BATCH_PAGES);
+		len = (unsigned long) batch_pages << PAGE_SHIFT;
+		end = start + len;
+		nr = get_user_pages_fast_batch(start, end, write, pages);
+		VM_BUG_ON(nr > batch_pages);
+		nr_pages -= nr;
+		ret += nr;
+		if (!nr_pages)
+			break;
+		if (nr < batch_pages)
+			goto slow_irqon;
+		start += len;
+		pages += batch_pages;
+	}
 
-	/*
-	 * XXX: batch / limit 'nr', to avoid large irq off latency
-	 * needs some instrumenting to determine the common sizes used by
-	 * important workloads (eg. DB2), and whether limiting the batch size
-	 * will decrease performance.
-	 *
-	 * It seems like we're in the clear for the moment. Direct-IO is
-	 * the main guy that batches up lots of get_user_pages, and even
-	 * they are limited to 64-at-a-time which is not so many.
-	 */
-	/*
-	 * This doesn't prevent pagetable teardown, but does prevent
-	 * the pagetables and pages from being freed on x86.
-	 *
-	 * So long as we atomically load page table pointers versus teardown
-	 * (which we do on x86, with the above PAE exception), we can follow the
-	 * address down to the the page and take a ref on it.
-	 */
-	local_irq_disable();
-	pgdp = pgd_offset(mm, addr);
-	do {
-		pgd_t pgd = *pgdp;
-
-		next = pgd_addr_end(addr, end);
-		if (pgd_none(pgd))
-			goto slow;
-		if (!gup_pud_range(pgd, addr, next, write, pages, &nr))
-			goto slow;
-	} while (pgdp++, addr = next, addr != end);
-	local_irq_enable();
-
-	VM_BUG_ON(nr != (end - start) >> PAGE_SHIFT);
-	return nr;
-
-	{
-		int ret;
+	VM_BUG_ON(ret != (end - orig_start) >> PAGE_SHIFT);
+	return ret;
 
-slow:
-		local_irq_enable();
 slow_irqon:
-		/* Try to get the remaining pages with get_user_pages */
-		start += nr << PAGE_SHIFT;
-		pages += nr;
-
-		ret = get_user_pages_unlocked(current, mm, start,
-					      (end - start) >> PAGE_SHIFT,
-					      write, 0, pages);
-
-		/* Have to be a bit careful with return values */
-		if (nr > 0) {
-			if (ret < 0)
-				ret = nr;
-			else
-				ret += nr;
-		}
+	/* Try to get the remaining pages with get_user_pages */
+	start += nr << PAGE_SHIFT;
+	pages += nr;
 
-		return ret;
+	/*
+	 * "nr" was the get_user_pages_fast_batch last retval, "ret"
+	 * was the sum of all get_user_pages_fast_batch retvals, now
+	 * "nr" becomes the sum of all get_user_pages_fast_batch
+	 * retvals and "ret" will become the get_user_pages_unlocked
+	 * retval.
+	 */
+	nr = ret;
+
+	ret = get_user_pages_unlocked(current, mm, start,
+				      (end - start) >> PAGE_SHIFT,
+				      write, 0, pages);
+
+	/* Have to be a bit careful with return values */
+	if (nr > 0) {
+		if (ret < 0)
+			ret = nr;
+		else
+			ret += nr;
 	}
+
+	return ret;
 }
