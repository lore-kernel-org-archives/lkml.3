Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab3LRTSx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 14:18:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929Ab3LRTSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 14:18:51 -0500
Date: Wed, 18 Dec 2013 20:19:13 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH -mm 0/7] (Was: introduce get_compound_page)
Message-ID: <20131218191913.GA6464@redhat.com>
References: <20131211175615.GA24546@redhat.com> <20131211191855.GA32485@redhat.com> <20131213151035.GE5408@redhat.com> <20131213162240.GA11762@redhat.com> <20131213173406.GG5408@redhat.com> <20131216183618.GA28252@redhat.com> <20131216201952.GE21218@redhat.com> <20131216204626.GA8152@redhat.com> <20131217165335.GA24799@redhat.com> <20131217180603.GC5441@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131217180603.GC5441@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17, Andrea Arcangeli wrote:
>
> On Tue, Dec 17, 2013 at 05:53:35PM +0100, Oleg Nesterov wrote:
> >
> > I can't stop thinking about another change. What if we simply change
> > __split_huge_page_refcount() to also do compound_lock/unlock(page_tail)
> > in a main loop?
> >
> > This way we can greatly simplify get/put_page paths, we can rely on
> > compound_lock(sub-page) and avoid get_page_unless_zero(page_head).
> > Yes, this will make _split a bit slower, but PG_compound_lock should
> > not be contended? And we should change page_tail->flags carefully, but
> > this looks simple.
> >
> > Or this is not possible/desirable?
>
> That would be 512 nested spinlocks instead of 1,

Yes. But, just in case, we do not need to take them all at once. We
only need to take/release the additional lock per page_tail in a loop.

> last time I did
> something like that in mm_take_all_locks people weren't too pleased as
> it started firing lockdeps complains too.

bit_spin_lock() doesn't have the lockdep annotations and it would be
trivial to add _nested if necessary.

> split_huge_page to the contrary could run in a flood if
> you're unlucky. split_huge_page is needed not just to handle non-THP
> aware paths that mostly disappeared by now, but also when you truncate
> a vma so that a THP doesn't fit in it anymore. So it's up to userland
> how frequently it needs to run.

Yes, I understand. I _think_ this should be fine performance-wise,
compared to other things split_huge_page() paths should do these 511
test_and_set_bit + clear_bit should not be noticeable.

But of course I can be wrong.

> I think it's reasonable to consider it though, but then it's not
> guaranteed that a put_page on a THP tail is more frequent than
> split_huge_page. Keep in mind we do the get_page_unless_zero to
> stabilize the head to take the compound_lock on it, only for the
> tails, never for the heads. So this restricts it to _only_ the
> put_page following a gup_fast. Only gup_fast can ever take a reference
> on the tail pages of a THP. Nothing else can.

I see. But my main point was simplification.

And I'm afraid this compound_lock() in get/put can race with someone
else playing with page->flags "because I own this freshly allocated
page". Perhaps.


However. I do understand your concerns, lets forget about this for now.


---------------------------------------------------------------------------
Please review get_futex_key() changes we discussed before. As for the race
with prep_new_page() I'll send another patch, it is completely orthogonal
to this series.

Testing. I simply have no idea how can I test this series so I didn't
even try ;) I'll try to do something tomorrow, but in any case I have
to rely on your review.

Most of the cleanups in this series are not needed to change get_futex_key(),
but imho make sense. And we need more cleanups after this series, I'll do
this later if this series makes any sense.

Oleg.

 include/linux/mm.h |    2 +
 kernel/futex.c     |   37 +--------
 mm/swap.c          |  251 ++++++++++++++++++++++++++--------------------------
 3 files changed, 128 insertions(+), 162 deletions(-)

