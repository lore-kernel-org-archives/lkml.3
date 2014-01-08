Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815AbaAHSCJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 13:02:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36795 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbaAHSCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 13:02:06 -0500
Date: Wed, 8 Jan 2014 18:02:02 +0000
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
Message-ID: <20140108180202.GL27046@suse.de>
References: <20131216201952.GE21218@redhat.com>
 <20131219190846.GA24566@redhat.com>
 <20131219190920.GB24566@redhat.com>
 <20131223114300.GC727@redhat.com>
 <20140103195519.GA26555@redhat.com>
 <20140103195547.GB26555@redhat.com>
 <20140103130023.fdbf96fc95c702bf63871b56@linux-foundation.org>
 <20140104164347.GA31359@redhat.com>
 <20140108115400.GD27046@suse.de>
 <20140108161338.GA10434@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140108161338.GA10434@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 05:13:38PM +0100, Oleg Nesterov wrote:
> On 01/08, Mel Gorman wrote:
> >
> > On Sat, Jan 04, 2014 at 05:43:47PM +0100, Oleg Nesterov wrote:
> > >
> > > 	get/put_page(thp_tail) paths do get_page_unless_zero(page_head) +
> > > 	compound_lock(). In theory this page_head can be already freed and
> > > 	reallocated as alloc_pages(__GFP_COMP, smaller_order). In this case
> > > 	get_page_unless_zero() can succeed right after set_page_refcounted(),
> > > 	and compound_lock() can race with the non-atomic __SetPageHead() in
> > > 	prep_compound_page().
> > >
> > This patch is putting a write barrier in the page allocator fast path and
> > that is going to be a leading cause of Sad Face. We already have seen
> > large regressions before when write barriers were introduced to the page
> > allocator paths for cpusets.  Sticking it under CONFIG_TRANSPARENT_HUGEPAGE
> > does not really address the issue.
> 
> As you already mentioned in another email, smp_wmb() is mostly nop. On
> x86_64 at least.

Which sometimes means that it'll just take longer for someone to find it
and bitch about it.

> Although perhaps it would be nice to have
> 
> 	static inline void atomic_store_release(atomic_t *v, int i)
> 	{
> 		smp_store_release(&v->counter, i);
> 	}
> 
> > > Yes, but thp can access this page_head via stale pointer, tail->first_page,
> > > if it races with split_huge_page_refcount().
> >
> > To justify the introduction of a performance regression we need to be 100%
> > sure this race actually exists
> 
> See below. But let me remind that I never looked at this code before,
> I can be easily wrong.
> 
> > and not just theoretical.
> 
> It is theoretical anyway, I guess.
> 
> > For futex, the THP page (and the tail) must have been discovered via
> > the page tables in which case the page tables are temporarily preventing
> > the page being freed to the allocator.
> 
> Yes. But, for example, get_futex_key() does
> 
> 	if (unlikely(PageTail(page))) {
> 		put_page(page);
> 
> why this put_page() can't race with _split? If nothing else, another thread
> can unmap the part of this vma.
> 

The race is not prevented but that does not mean it matters. Basic
scenario where a split starts after the PageTail check but before the
put_page in get_futex_key

CPU A
get_futex_key
  -> fast gup, page table removing prevents parallel unmap and free
    -> gup_huge_pmd (arch/x86/mm/gup.c at least)
      -> get_huge_page_tail (increment page tail _map_count)
      -> get_huge_page_multiple (increment ref on head page)
  -> Check PageTail
					CPU B
					split_huge_page_to_list
					  -> split_huge_page_refcount
					     spin_lock_irq(lru_lock)
					     compound_lock
  -> put_page(tail_page)
    ->put_compound_page
       looks up head page
       takes reference unless zero
       compound_lock (block)
					     complete split
					     compound_unlock
       check PageTail

This put_page blocks on the compound lock, finds the page is no longer a
PageTail as the split barriers correctly and backs out gracefully. So sure,
splits can race but the case is cared for.

The parallel unmap is prevented by get_huge_page_multiple in the gup path
and held in place until put_page_compound frees it later.

I still don't see the case where a page gets freed to the page allocator
that causes weird problems here. Unfortunately, I also recognise I have
tunnel vision because subconsciously I don't *want* to see a problem here
that justifies adding a write barrier. Andrea may stomp all over this
reasoning in which case we'll get a good comment for the smp_wmb :/

-- 
Mel Gorman
SUSE Labs
