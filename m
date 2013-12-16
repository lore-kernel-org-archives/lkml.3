Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab3LPSf4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 13:35:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754690Ab3LPSfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 13:35:55 -0500
Date: Mon, 16 Dec 2013 19:36:18 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: PATCH? introduce get_compound_page (Was: process 'stuck' at
	exit)
Message-ID: <20131216183618.GA28252@redhat.com>
References: <CA+55aFwr2e5x13fA+QWjt=iJFmCcugFErdqaeeUtH4XPBExC6Q@mail.gmail.com> <CA+55aFxLbFWhgzg=Rn0rhUpoOjbTE3QqUSxHTsCyk8GjDUFxJg@mail.gmail.com> <CA+55aFw_emAUOr5BYx0TfTCGEOrW6-ZRATWbm00DvCXsGD7=DQ@mail.gmail.com> <20131211170844.GA21700@redhat.com> <alpine.DEB.2.02.1312111814010.28330@ionos.tec.linutronix.de> <20131211175615.GA24546@redhat.com> <20131211191855.GA32485@redhat.com> <20131213151035.GE5408@redhat.com> <20131213162240.GA11762@redhat.com> <20131213173406.GG5408@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131213173406.GG5408@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13, Andrea Arcangeli wrote:
>
> On Fri, Dec 13, 2013 at 05:22:40PM +0100, Oleg Nesterov wrote:
> >
> > I'll try to make v2 based on -mm and your suggestions.
>
> Ok great!

Yes, it would be great, but I need your help again ;)


Let me quote the pseudo-code you sent me:

	put_compound_tail(page) {
		page_head = compound_trans_head(page);
		if (!__compound_tail_refcounted(page_head)) {
			...
			return ...;
		}

		flags = compound_lock_irqsave(page_head);
		...

Sure, put_compound_tail() should be the simplified version of
put_compound_page() which doesn't dec page_head->_count, this is clear.

But afaics, compound_lock_irqsave() above looks unsafe without
get_page_unless_zero(page_head) ? If we race with _split, page_head
can be freed and compound_lock() can race with, say, free_pages_check()
which plays with page->flags ?

So it seems that put_compound_tail() should also do get/put(head) like
put_compound_page() does, and this probably means we should factor out
the common code somehow.

Or I missed something?



OTOH, I can't really understand

	if (likely(page != page_head && get_page_unless_zero(page_head)))

in __get_page_tail() and put_compound_page().

First of all, is it really possible that page == compound_trans_head(page)?
We already verified that PG_tail was set. Of course this bit can be cleared
and ->first_page can be a dangling pointer but it can never be changed to
point to this page? (in fact, afaics it can be changed at all as long as we
have a reference, but this doesn't matter).



And compound_lock_irqsave() looks racy even after get_page_unless_zero().

For example, suppose that page_head was already freed and then re-allocated
as (say) alloc_pages(__GFP_COMP, 1). get_page_unless_zero() can succeed right
after prep_new_page() does set_page_refcounted(). Now, can't compound_lock()
race with the non-atomic prep_compound_page()->__SetPageHead() ?



Finally. basepage_index(page) after put_page(page) in get_futex_key() looks
confusing imho. I think this is correct, we already checked PageAnon() so it
can't be a thp page. But probably this needs a comment and __basepage_index()
should do BUG_ON(!PageHuge()).

Oleg.

