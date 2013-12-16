Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab3LPUqD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 15:46:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846Ab3LPUqC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 15:46:02 -0500
Date: Mon, 16 Dec 2013 21:46:26 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: PATCH? introduce get_compound_page (Was: process 'stuck' at
	exit)
Message-ID: <20131216204626.GA8152@redhat.com>
References: <CA+55aFw_emAUOr5BYx0TfTCGEOrW6-ZRATWbm00DvCXsGD7=DQ@mail.gmail.com> <20131211170844.GA21700@redhat.com> <alpine.DEB.2.02.1312111814010.28330@ionos.tec.linutronix.de> <20131211175615.GA24546@redhat.com> <20131211191855.GA32485@redhat.com> <20131213151035.GE5408@redhat.com> <20131213162240.GA11762@redhat.com> <20131213173406.GG5408@redhat.com> <20131216183618.GA28252@redhat.com> <20131216201952.GE21218@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131216201952.GE21218@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16, Andrea Arcangeli wrote:
>
> On Mon, Dec 16, 2013 at 07:36:18PM +0100, Oleg Nesterov wrote:
> >
> > So it seems that put_compound_tail() should also do get/put(head) like
> > put_compound_page() does, and this probably means we should factor out
> > the common code somehow.
> >
>
> Yes it was supposed to do the get_page_unless_zero before the
> compound_lock.

OK,

> > OTOH, I can't really understand
> >
> > 	if (likely(page != page_head && get_page_unless_zero(page_head)))
> >
> > in __get_page_tail() and put_compound_page().
> >
> > First of all, is it really possible that page == compound_trans_head(page)?
>
> ...
>
> If PG_tail gets cleared compound_trans_head returns "page".

Damn, indeed, thanks.

> > And compound_lock_irqsave() looks racy even after get_page_unless_zero().
> >
> > For example, suppose that page_head was already freed and then re-allocated
> > as (say) alloc_pages(__GFP_COMP, 1). get_page_unless_zero() can succeed right
> > after prep_new_page() does set_page_refcounted(). Now, can't compound_lock()
> > race with the non-atomic prep_compound_page()->__SetPageHead() ?
>
> Yes. We need to change to:
>
> 	if (order && (gfp_flags & __GFP_COMP))
> 		prep_compound_page(page, order);
> 	smp_wmb();
> 	/* as the compound_lock can be taken after it's refcounted */
> 	set_page_refcounted(page);
>
> __SetPageHead uses bts asm insn so literally only a "lock" prefix is
> missing in a assembly instruction. So the race window is incredibly
> small, but it must be fixed indeed. This also puts set_page_refcounted
> as the last action of buffered_rmqueue so there shouldn't be any other
> issues like this left in the page allocation code.
>
> Can you reorder set_page_refcount in your v2?

OK. I'll try to make something on Wednesday.


> > Finally. basepage_index(page) after put_page(page) in get_futex_key() looks
> > confusing imho. I think this is correct, we already checked PageAnon() so it
> > can't be a thp page. But probably this needs a comment and __basepage_index()
> > should do BUG_ON(!PageHuge()).
>
> This looks a bug if you apply the patches to add THP in pagecache, and
> BUG_ON(!PageHuge) would also break THP in pagecache later (though
> safer than silently broken like now).
>
> It'd safer to read the basepage_index in a local variable just before
> doing the put_compund_tail but I agree it's not going to make a
> difference right now.

Yes, so lets discuss (and perhaps change) this later/separately.

Andrea, thanks again for your help.

Oleg.

