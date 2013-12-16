Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444Ab3LPUU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 15:20:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384Ab3LPUUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 15:20:23 -0500
Date: Mon, 16 Dec 2013 21:19:52 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: PATCH? introduce get_compound_page (Was: process 'stuck' at exit)
Message-ID: <20131216201952.GE21218@redhat.com>
References: <CA+55aFxLbFWhgzg=Rn0rhUpoOjbTE3QqUSxHTsCyk8GjDUFxJg@mail.gmail.com>
 <CA+55aFw_emAUOr5BYx0TfTCGEOrW6-ZRATWbm00DvCXsGD7=DQ@mail.gmail.com>
 <20131211170844.GA21700@redhat.com>
 <alpine.DEB.2.02.1312111814010.28330@ionos.tec.linutronix.de>
 <20131211175615.GA24546@redhat.com>
 <20131211191855.GA32485@redhat.com>
 <20131213151035.GE5408@redhat.com>
 <20131213162240.GA11762@redhat.com>
 <20131213173406.GG5408@redhat.com>
 <20131216183618.GA28252@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131216183618.GA28252@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 07:36:18PM +0100, Oleg Nesterov wrote:
> On 12/13, Andrea Arcangeli wrote:
> >
> > On Fri, Dec 13, 2013 at 05:22:40PM +0100, Oleg Nesterov wrote:
> > >
> > > I'll try to make v2 based on -mm and your suggestions.
> >
> > Ok great!
> 
> Yes, it would be great, but I need your help again ;)
> 
> 
> Let me quote the pseudo-code you sent me:
> 
> 	put_compound_tail(page) {
> 		page_head = compound_trans_head(page);
> 		if (!__compound_tail_refcounted(page_head)) {
> 			...
> 			return ...;
> 		}
> 
> 		flags = compound_lock_irqsave(page_head);
> 		...
> 
> Sure, put_compound_tail() should be the simplified version of
> put_compound_page() which doesn't dec page_head->_count, this is clear.
> 
> But afaics, compound_lock_irqsave() above looks unsafe without
> get_page_unless_zero(page_head) ? If we race with _split, page_head
> can be freed and compound_lock() can race with, say, free_pages_check()
> which plays with page->flags ?
> 
> So it seems that put_compound_tail() should also do get/put(head) like
> put_compound_page() does, and this probably means we should factor out
> the common code somehow.
> 

Yes it was supposed to do the get_page_unless_zero before the
compound_lock.

> Or I missed something?
> 
> 
> 
> OTOH, I can't really understand
> 
> 	if (likely(page != page_head && get_page_unless_zero(page_head)))
> 
> in __get_page_tail() and put_compound_page().
> 
> First of all, is it really possible that page == compound_trans_head(page)?

It is possible if it become a regular page because split_huge_page
run in between.

compound_trans_head guarantees us it got us to a safe head page. And
the idea was to do get_page_unless_zero only on head pages and never
on tails to be safer/simpler. Same goes for the compound_lock that
follows still on the page_head where "page != page_head".

If you like, you can try to optimize away the check and reuse the
PageTail branch inside the compound_lock but I'm not sure if it's
worth it.

> We already verified that PG_tail was set. Of course this bit can be cleared
> and ->first_page can be a dangling pointer but it can never be changed to
> point to this page? (in fact, afaics it can be changed at all as long as we
> have a reference, but this doesn't matter).

If PG_tail gets cleared compound_trans_head returns "page".

> And compound_lock_irqsave() looks racy even after get_page_unless_zero().
> 
> For example, suppose that page_head was already freed and then re-allocated
> as (say) alloc_pages(__GFP_COMP, 1). get_page_unless_zero() can succeed right
> after prep_new_page() does set_page_refcounted(). Now, can't compound_lock()
> race with the non-atomic prep_compound_page()->__SetPageHead() ?

Yes. We need to change to:

	if (order && (gfp_flags & __GFP_COMP))
		prep_compound_page(page, order);
	smp_wmb();
	/* as the compound_lock can be taken after it's refcounted */
	set_page_refcounted(page);

__SetPageHead uses bts asm insn so literally only a "lock" prefix is
missing in a assembly instruction. So the race window is incredibly
small, but it must be fixed indeed. This also puts set_page_refcounted
as the last action of buffered_rmqueue so there shouldn't be any other
issues like this left in the page allocation code.

Can you reorder set_page_refcount in your v2?

I wonder if arch_alloc_page needs refcount 1, it sets the page as
stable on s390. the other way around is to move prep_compound_page
before set_page_refcounted (though I think if we can, keeping the
refcounted at the very last with a comment is preferable).

> Finally. basepage_index(page) after put_page(page) in get_futex_key() looks
> confusing imho. I think this is correct, we already checked PageAnon() so it
> can't be a thp page. But probably this needs a comment and __basepage_index()
> should do BUG_ON(!PageHuge()).

This looks a bug if you apply the patches to add THP in pagecache, and
BUG_ON(!PageHuge) would also break THP in pagecache later (though
safer than silently broken like now).

It'd safer to read the basepage_index in a local variable just before
doing the put_compund_tail but I agree it's not going to make a
difference right now.

But the whole idea of working with the head of the THP despite the
address points to a tail, looks flakey if there is a split (THP in
pagecache). I mean chances are reading basepage_index(page) before
releasing the tail pin is not enough.

The Anon path looks sane for all cases, as it doesn't pretend to
return any information on the actual mapping and it limits itself to
do the PageAnon check on the actual head that has PageAnon set, which
is still valid thing to do even after a split, and in fact required if
a split didn't take place yet as the tail "page" isn't anon but just a
tail.
