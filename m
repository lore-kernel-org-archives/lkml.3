Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbaAIL1r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 06:27:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50565 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbaAIL1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 06:27:41 -0500
Date: Thu, 9 Jan 2014 11:27:36 +0000
From: Mel Gorman <mgorman@suse.de>
To: Oleg Nesterov <oleg@redhat.com>
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
Message-ID: <20140109112736.GR27046@suse.de>
References: <20131219190920.GB24566@redhat.com>
 <20131223114300.GC727@redhat.com>
 <20140103195519.GA26555@redhat.com>
 <20140103195547.GB26555@redhat.com>
 <20140103130023.fdbf96fc95c702bf63871b56@linux-foundation.org>
 <20140104164347.GA31359@redhat.com>
 <20140108115400.GD27046@suse.de>
 <20140108161338.GA10434@redhat.com>
 <20140108180202.GL27046@suse.de>
 <20140108190443.GA17282@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140108190443.GA17282@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 08:04:43PM +0100, Oleg Nesterov wrote:
> On 01/08, Mel Gorman wrote:
> >
> > On Wed, Jan 08, 2014 at 05:13:38PM +0100, Oleg Nesterov wrote:
> > >
> > > Yes. But, for example, get_futex_key() does
> > >
> > > 	if (unlikely(PageTail(page))) {
> > > 		put_page(page);
> > >
> > > why this put_page() can't race with _split? If nothing else, another thread
> > > can unmap the part of this vma.
> > >
> >
> > The race is not prevented but that does not mean it matters. Basic
> > scenario where a split starts after the PageTail check but before the
> > put_page in get_futex_key
> >
> > CPU A
> > get_futex_key
> >   -> fast gup, page table removing prevents parallel unmap and free
> >     -> gup_huge_pmd (arch/x86/mm/gup.c at least)
> >       -> get_huge_page_tail (increment page tail _map_count)
> >       -> get_huge_page_multiple (increment ref on head page)
> >   -> Check PageTail
> > 					CPU B
> > 					split_huge_page_to_list
> > 					  -> split_huge_page_refcount
> > 					     spin_lock_irq(lru_lock)
> > 					     compound_lock
> >   -> put_page(tail_page)
> >     ->put_compound_page
> >        looks up head page
> 
> Yes.
> 
> But suppose that CPU B completes split_huge_page_to_list/munmap/etc
> and frees this head page.
> 

Where did the reference taken by get_huge_page_multiple go?

CPU A
static noinline int gup_huge_pmd(pmd_t pmd, unsigned long addr,
                unsigned long end, int write, struct page **pages, int *nr)
{
	....
	do {
		...
		if (PageTail(page))
			/* Increment page->_mapcount */
			get_huge_page_tail(page);
		...
		refs++;
	} while (...)
	get_head_page_multiple(head, refs);
}

CPU A in get_futex_key has taken multiple references to the head page,
one for every base page on the huge page

Now the splitter comes along which does a bunch of stuff but the
important part is in __split_huge_page_refcount()

static void __split_huge_page_refcount(struct page *page,
                                       struct list_head *list)
{
	...
	spin_lock_irq(&zone->lru_lock);
	compound_lock(page);

	for_every_tail_page() {
		/* This picks up refcounts from GUP get_huge_page_tail */
		tail_count += page_mapcount(page_tail);

		/* Propogate all mapcounts to the "real" refcount in the tail page */
		atomic_add(page_mapcount(head) + page_mapcount(tail), tail->_count)

		.... flag reinits with barriers ...
	}
	atomic_sub(tail_count, headpage->_count);
	...
	unlock stuff
}

The refcounts on page->_mapcount taken while the page was huge is
propogated to the tail pages so it's still pinned in place.

	
> >        takes reference unless zero
> 
> suppose this page_head was reallocated and get_page_unless_zero()
> succeds right after set_page_refcounted(),
> 

You're right. The head page can still be freed and reallocated as a *smaller*
compound page but futex.c is doing the reference count on the tail page
that should have an elevated count even after the split

#ifdef CONFIG_TRANSPARENT_HUGEPAGE
        page_head = page;
        if (unlikely(PageTail(page))) {
                put_page(page);


so I'm still not seeing how a tail page racing with a split ends up with
mayhem.

> >        compound_lock (block)
> > 					     complete split
> > 					     compound_unlock
> >        check PageTail
> >
> > This put_page blocks on the compound lock, finds the page is no longer a
> > PageTail
> 
> Sure. The problem is that compound_lock() itself can race with prep_new_page()
> or I missed something.
> 

I could also still be stuck in a "la la la, everything is fine" mode.

-- 
Mel Gorman
SUSE Labs
