Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868AbaAHQNm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 11:13:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755610AbaAHQNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 11:13:40 -0500
Date: Wed, 8 Jan 2014 17:13:38 +0100
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
Message-ID: <20140108161338.GA10434@redhat.com>
References: <20131216183618.GA28252@redhat.com> <20131216201952.GE21218@redhat.com> <20131219190846.GA24566@redhat.com> <20131219190920.GB24566@redhat.com> <20131223114300.GC727@redhat.com> <20140103195519.GA26555@redhat.com> <20140103195547.GB26555@redhat.com> <20140103130023.fdbf96fc95c702bf63871b56@linux-foundation.org> <20140104164347.GA31359@redhat.com> <20140108115400.GD27046@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140108115400.GD27046@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08, Mel Gorman wrote:
>
> On Sat, Jan 04, 2014 at 05:43:47PM +0100, Oleg Nesterov wrote:
> >
> > 	get/put_page(thp_tail) paths do get_page_unless_zero(page_head) +
> > 	compound_lock(). In theory this page_head can be already freed and
> > 	reallocated as alloc_pages(__GFP_COMP, smaller_order). In this case
> > 	get_page_unless_zero() can succeed right after set_page_refcounted(),
> > 	and compound_lock() can race with the non-atomic __SetPageHead() in
> > 	prep_compound_page().
> >
> This patch is putting a write barrier in the page allocator fast path and
> that is going to be a leading cause of Sad Face. We already have seen
> large regressions before when write barriers were introduced to the page
> allocator paths for cpusets.  Sticking it under CONFIG_TRANSPARENT_HUGEPAGE
> does not really address the issue.

As you already mentioned in another email, smp_wmb() is mostly nop. On
x86_64 at least. Although perhaps it would be nice to have

	static inline void atomic_store_release(atomic_t *v, int i)
	{
		smp_store_release(&v->counter, i);
	}

> > Yes, but thp can access this page_head via stale pointer, tail->first_page,
> > if it races with split_huge_page_refcount().
>
> To justify the introduction of a performance regression we need to be 100%
> sure this race actually exists

See below. But let me remind that I never looked at this code before,
I can be easily wrong.

> and not just theoretical.

It is theoretical anyway, I guess.

> For futex, the THP page (and the tail) must have been discovered via
> the page tables in which case the page tables are temporarily preventing
> the page being freed to the allocator.

Yes. But, for example, get_futex_key() does

	if (unlikely(PageTail(page))) {
		put_page(page);

why this put_page() can't race with _split? If nothing else, another thread
can unmap the part of this vma.

> > For example, __get_page_tail() roughly does:
> >
> > 	// PageTail(page) was already checked
> >
> > 	page_head = page->first_page;
> >
> > 	/* WINDOW */
> >
> > 	get_page_unless_zero(page_head);
> >
> > 	compound_lock(page_head);
> >
> > 	recheck PageTail(page) to ensure page_head is still valid
> >
> > However, in the WINDOW above, split_huge_page() can split this huge page.
> > After that its head can be freed and reallocated. Of course, I don't think
> > it is possible to hit this race in practice, but still this looks wrong.
> >
>
> I can't think of a reason why we would actually hit that race in practice

Agreed, the window is tiny, unlikely this possible.

> I do not think we
> should stick a write barrier into the page allocator fast path.

OK, I won't argue, I leave this to you and Andrea.


But I still think this code needs other cleanups/simplifications. In
particular get_futex_key()->__get_user_pages_fast() should die imho.

Oleg.

