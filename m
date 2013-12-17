Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab3LQQxN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 11:53:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964Ab3LQQxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 11:53:12 -0500
Date: Tue, 17 Dec 2013 17:53:35 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: PATCH? introduce get_compound_page (Was: process 'stuck' at
	exit)
Message-ID: <20131217165335.GA24799@redhat.com>
References: <20131211170844.GA21700@redhat.com> <alpine.DEB.2.02.1312111814010.28330@ionos.tec.linutronix.de> <20131211175615.GA24546@redhat.com> <20131211191855.GA32485@redhat.com> <20131213151035.GE5408@redhat.com> <20131213162240.GA11762@redhat.com> <20131213173406.GG5408@redhat.com> <20131216183618.GA28252@redhat.com> <20131216201952.GE21218@redhat.com> <20131216204626.GA8152@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131216204626.GA8152@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16, Oleg Nesterov wrote:
>
> On 12/16, Andrea Arcangeli wrote:
> >
> > On Mon, Dec 16, 2013 at 07:36:18PM +0100, Oleg Nesterov wrote:
> > >
> > > And compound_lock_irqsave() looks racy even after get_page_unless_zero().
> > >
> > > For example, suppose that page_head was already freed and then re-allocated
> > > as (say) alloc_pages(__GFP_COMP, 1). get_page_unless_zero() can succeed right
> > > after prep_new_page() does set_page_refcounted(). Now, can't compound_lock()
> > > race with the non-atomic prep_compound_page()->__SetPageHead() ?
> >
> > Yes. We need to change to:
> >
> > 	if (order && (gfp_flags & __GFP_COMP))
> > 		prep_compound_page(page, order);
> > 	smp_wmb();
> > 	/* as the compound_lock can be taken after it's refcounted */
> > 	set_page_refcounted(page);
> >
> > __SetPageHead uses bts asm insn so literally only a "lock" prefix is
> > missing in a assembly instruction. So the race window is incredibly
> > small, but it must be fixed indeed. This also puts set_page_refcounted
> > as the last action of buffered_rmqueue so there shouldn't be any other
> > issues like this left in the page allocation code.
> >
> > Can you reorder set_page_refcount in your v2?
>
> OK. I'll try to make something on Wednesday.

Yes, I will, but...

I can't stop thinking about another change. What if we simply change
__split_huge_page_refcount() to also do compound_lock/unlock(page_tail)
in a main loop?

This way we can greatly simplify get/put_page paths, we can rely on
compound_lock(sub-page) and avoid get_page_unless_zero(page_head).
Yes, this will make _split a bit slower, but PG_compound_lock should
not be contended? And we should change page_tail->flags carefully, but
this looks simple.

Or this is not possible/desirable?

Oleg.

