Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727AbaAIOE7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 09:04:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756446AbaAIOEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 09:04:50 -0500
Date: Thu, 9 Jan 2014 15:04:47 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH v2 1/1] mm: fix the theoretical compound_lock() vs
	prep_new_page() race
Message-ID: <20140109140447.GA25391@redhat.com>
References: <20131223114300.GC727@redhat.com> <20140103195519.GA26555@redhat.com> <20140103195547.GB26555@redhat.com> <20140103130023.fdbf96fc95c702bf63871b56@linux-foundation.org> <20140104164347.GA31359@redhat.com> <20140108115400.GD27046@suse.de> <20140108161338.GA10434@redhat.com> <20140108180202.GL27046@suse.de> <20140108190443.GA17282@redhat.com> <20140109112736.GR27046@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140109112736.GR27046@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09, Mel Gorman wrote:
>
> On Wed, Jan 08, 2014 at 08:04:43PM +0100, Oleg Nesterov wrote:
> >
> > Yes.
> >
> > But suppose that CPU B completes split_huge_page_to_list/munmap/etc
> > and frees this head page.
> >
>
> Where did the reference taken by get_huge_page_multiple go?

In __split_huge_page_refcount(), see below.

> CPU A
> static noinline int gup_huge_pmd(pmd_t pmd, unsigned long addr,
>                 unsigned long end, int write, struct page **pages, int *nr)
> {
> 	....
> 	do {
> 		...
> 		if (PageTail(page))
> 			/* Increment page->_mapcount */
> 			get_huge_page_tail(page);
> 		...
> 		refs++;
> 	} while (...)
> 	get_head_page_multiple(head, refs);
> }
>
> CPU A in get_futex_key has taken multiple references to the head page,
> one for every base page on the huge page

Not sure I understand "multiple references to the head page" above...
I mean, in this particular case case nr == 1.

IOW, If gup returns a tail page, this page_tail has 1 in ->_mapcount
(to simplify) and its ->first_page gets the additional 1 in ->_count.

> static void __split_huge_page_refcount(struct page *page,
>                                        struct list_head *list)
> {
> 	...
> 	spin_lock_irq(&zone->lru_lock);
> 	compound_lock(page);
>
> 	for_every_tail_page() {
> 		/* This picks up refcounts from GUP get_huge_page_tail */
> 		tail_count += page_mapcount(page_tail);
>
> 		/* Propogate all mapcounts to the "real" refcount in the tail page */
> 		atomic_add(page_mapcount(head) + page_mapcount(tail), tail->_count)
>
> 		.... flag reinits with barriers ...
> 	}
> 	atomic_sub(tail_count, headpage->_count);
> 	...
> 	unlock stuff
> }
>
> The refcounts on page->_mapcount taken while the page was huge is
> propogated to the tail pages so it's still pinned in place.

Yes. But at the same time atomic_sub(tail_count, headpage->_count)
above reverts the result of get_head_page_multiple(head) done by
gup() above.

IOW, after __split_huge_page_refcount() page_tail no longer pins its
former page_head.

> > >        takes reference unless zero
> >
> > suppose this page_head was reallocated and get_page_unless_zero()
> > succeds right after set_page_refcounted(),
> >
>
> You're right. The head page can still be freed and reallocated as a *smaller*
> compound page but futex.c is doing the reference count on the tail page
> that should have an elevated count even after the split

Yes, page_tail can't go away, the reference was moved to page_tail->_count.

> #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>         page_head = page;
>         if (unlikely(PageTail(page))) {
>                 put_page(page);
>
>
> so I'm still not seeing how a tail page racing with a split ends up with
> mayhem.

But get/put(page_tail) plays with page_head which can be freed/reallocated,
it does compound_lock(page_head).

> I could also still be stuck in a "la la la, everything is fine" mode.

More likely it is me who tries to deny the fact I missed something ;)



But let me try again. Lets ignore PageSlab/PageHeadHuge. put_compound_page()
is complicated, but roughly it does:

	CPU 0						CPU 1

	if (!PageTail(page_tail))
		return;

	page_head = page_tail->first_page;
	
							unmap this vma, free everything.
							page_tail can't go away, its
							->_count was incremented by
							__split_huge_page_refcount().
							

							alloc_pages(GFP_COMP, 1) reallocates
							page_head, prep_new_page() does
							set_page_refcounted(page_head),
							

	// succeeds after set_page_refcounted()
	get_page_unless_zero(page_head);

	compound_lock(page_head)			prep_compound_page(page_head);

Now, both compound_lock() and prep_compound_page() play with the same
page_head->flags, but __SetPageHead(page_head) is non-atomic.

OK. Even if I am right, we can probably make another fix.
put_compound_page() and __get_page_tail() can do yet another PageTail()
check _before_ compound_lock().

Although personally I'd prefer this patch. And if we change get/put
I think it would be  better to do this on top of

	"[PATCH -mm 6/7] mm: thp: introduce get_lock_thp_head()"
	http://marc.info/?l=linux-kernel&m=138739438800899

Oleg.

