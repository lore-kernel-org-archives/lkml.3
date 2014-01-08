Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269AbaAHLyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 06:54:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51994 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755605AbaAHLyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 06:54:06 -0500
Date: Wed, 8 Jan 2014 11:54:00 +0000
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
Message-ID: <20140108115400.GD27046@suse.de>
References: <20131213173406.GG5408@redhat.com>
 <20131216183618.GA28252@redhat.com>
 <20131216201952.GE21218@redhat.com>
 <20131219190846.GA24566@redhat.com>
 <20131219190920.GB24566@redhat.com>
 <20131223114300.GC727@redhat.com>
 <20140103195519.GA26555@redhat.com>
 <20140103195547.GB26555@redhat.com>
 <20140103130023.fdbf96fc95c702bf63871b56@linux-foundation.org>
 <20140104164347.GA31359@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140104164347.GA31359@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 04, 2014 at 05:43:47PM +0100, Oleg Nesterov wrote:
> On 01/03, Andrew Morton wrote:
> >
> > On Fri, 3 Jan 2014 20:55:47 +0100 Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > > get/put_page(thp_tail) paths do get_page_unless_zero(page_head) +
> > > compound_lock(). In theory this page_head can be already freed and
> > > reallocated as alloc_pages(__GFP_COMP, smaller_order). In this case
> > > get_page_unless_zero() can succeed right after set_page_refcounted(),
> > > and compound_lock() can race with the non-atomic __SetPageHead().
> >
> > Would be useful to mention that these things are happening inside
> > prep_compound_opage() (yes?).
> 
> Agreed. Added "in prep_compound_opage()" into the changelog:
> 
> 	get/put_page(thp_tail) paths do get_page_unless_zero(page_head) +
> 	compound_lock(). In theory this page_head can be already freed and
> 	reallocated as alloc_pages(__GFP_COMP, smaller_order). In this case
> 	get_page_unless_zero() can succeed right after set_page_refcounted(),
> 	and compound_lock() can race with the non-atomic __SetPageHead() in
> 	prep_compound_page().
> 
> 	Perhaps we should rework the thp locking (under discussion), but
> 	until then this patch moves set_page_refcounted() and adds wmb()
> 	to ensure that page->_count != 0 comes as a last change.
> 
> 	I am not sure about other callers of set_page_refcounted(), but at
> 	first glance they look fine to me.
> 
> or should I send v3?
> 

This patch is putting a write barrier in the page allocator fast path and
that is going to be a leading cause of Sad Face. We already have seen
large regressions before when write barriers were introduced to the page
allocator paths for cpusets.  Sticking it under CONFIG_TRANSPARENT_HUGEPAGE
does not really address the issue.

> > > Perhaps we should rework the thp locking (under discussion), but
> > > until then this patch moves set_page_refcounted() and adds wmb()
> > > to ensure that page->_count != 0 comes as a last change.
> > >
> > > I am not sure about other callers of set_page_refcounted(), but at
> > > first glance they look fine to me.
> >
> > I don't get it.  We're in prep_new_page() - this page is freshly
> > allocated and no other thread yet has any means by which to look it up
> > and start fiddling with it?
> 
> Yes, but thp can access this page_head via stale pointer, tail->first_page,
> if it races with split_huge_page_refcount().

To justify the introduction of a performance regression we need to be 100%
sure this race actually exists and not just theoretical. I had lost track
of this thread but did not see a description of how this bug can actually
happen. At the risk of sounding stupid -- what are the actual circumstances
when this race can occur?

For example, in the reclaim paths, we are going to be dealing with the head
pages as they are on the LRU. They get split into base pages and then the
compound handling becomes irrelevant. I cannot see problems there.

For futex, the THP page (and the tail) must have been discovered via
the page tables in which case the page tables are temporarily preventing
the page being freed to the allocator. GUP fast paths are protected from
parallel teardowns and the slow paths are protected from parallel unmaps
and frees by mmap_sem.

Compaction and other walkers mostly deal with the head and/or deal with
pages on the LRU where there will be an elevated reference count.

The changelog needs a specific example where the problem can occur and
even then we should consider if there is an option other than smacking
the page allocator.

>  In this case we rely on
> compound_lock() to detect this race, the problem is that compound_lock()
> itself can race with head_page->flags manipulations.
> 
> For example, __get_page_tail() roughly does:
> 
> 	// PageTail(page) was already checked
> 
> 	page_head = page->first_page;
> 
> 	/* WINDOW */
> 
> 	get_page_unless_zero(page_head);
> 
> 	compound_lock(page_head);
> 
> 	recheck PageTail(page) to ensure page_head is still valid
> 
> However, in the WINDOW above, split_huge_page() can split this huge page.
> After that its head can be freed and reallocated. Of course, I don't think
> it is possible to hit this race in practice, but still this looks wrong.
> 

I can't think of a reason why we would actually hit that race in practice
but I might have tunnel vision due to disliking that barrier so much. Unless
there is an example with no other possible solution, I do not think we
should stick a write barrier into the page allocator fast path.

-- 
Mel Gorman
SUSE Labs
