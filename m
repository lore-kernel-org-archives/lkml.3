Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab3LQSGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:06:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755339Ab3LQSGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:06:42 -0500
Date: Tue, 17 Dec 2013 19:06:03 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: PATCH? introduce get_compound_page (Was: process 'stuck' at exit)
Message-ID: <20131217180603.GC5441@redhat.com>
References: <alpine.DEB.2.02.1312111814010.28330@ionos.tec.linutronix.de>
 <20131211175615.GA24546@redhat.com>
 <20131211191855.GA32485@redhat.com>
 <20131213151035.GE5408@redhat.com>
 <20131213162240.GA11762@redhat.com>
 <20131213173406.GG5408@redhat.com>
 <20131216183618.GA28252@redhat.com>
 <20131216201952.GE21218@redhat.com>
 <20131216204626.GA8152@redhat.com>
 <20131217165335.GA24799@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131217165335.GA24799@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 05:53:35PM +0100, Oleg Nesterov wrote:
> On 12/16, Oleg Nesterov wrote:
> >
> > On 12/16, Andrea Arcangeli wrote:
> > >
> > > On Mon, Dec 16, 2013 at 07:36:18PM +0100, Oleg Nesterov wrote:
> > > >
> > > > And compound_lock_irqsave() looks racy even after get_page_unless_zero().
> > > >
> > > > For example, suppose that page_head was already freed and then re-allocated
> > > > as (say) alloc_pages(__GFP_COMP, 1). get_page_unless_zero() can succeed right
> > > > after prep_new_page() does set_page_refcounted(). Now, can't compound_lock()
> > > > race with the non-atomic prep_compound_page()->__SetPageHead() ?
> > >
> > > Yes. We need to change to:
> > >
> > > 	if (order && (gfp_flags & __GFP_COMP))
> > > 		prep_compound_page(page, order);
> > > 	smp_wmb();
> > > 	/* as the compound_lock can be taken after it's refcounted */
> > > 	set_page_refcounted(page);
> > >
> > > __SetPageHead uses bts asm insn so literally only a "lock" prefix is
> > > missing in a assembly instruction. So the race window is incredibly
> > > small, but it must be fixed indeed. This also puts set_page_refcounted
> > > as the last action of buffered_rmqueue so there shouldn't be any other
> > > issues like this left in the page allocation code.
> > >
> > > Can you reorder set_page_refcount in your v2?
> >
> > OK. I'll try to make something on Wednesday.
> 
> Yes, I will, but...
> 
> I can't stop thinking about another change. What if we simply change
> __split_huge_page_refcount() to also do compound_lock/unlock(page_tail)
> in a main loop?
> 
> This way we can greatly simplify get/put_page paths, we can rely on
> compound_lock(sub-page) and avoid get_page_unless_zero(page_head).
> Yes, this will make _split a bit slower, but PG_compound_lock should
> not be contended? And we should change page_tail->flags carefully, but
> this looks simple.
> 
> Or this is not possible/desirable?

That would be 512 nested spinlocks instead of 1, last time I did
something like that in mm_take_all_locks people weren't too pleased as
it started firing lockdeps complains too. Generally I try to avoid
taking too many locks nested if I can.

mm_take_all_locks is fine because it only runs when you register an mm
into a device driver, so it is a very rare event and not performance
critical at all, it is a slow path by all means (only runs when you
start a virtual machine or start X with nvidia etc..). So it is not a
concern. split_huge_page to the contrary could run in a flood if
you're unlucky. split_huge_page is needed not just to handle non-THP
aware paths that mostly disappeared by now, but also when you truncate
a vma so that a THP doesn't fit in it anymore. So it's up to userland
how frequently it needs to run.

I think it's reasonable to consider it though, but then it's not
guaranteed that a put_page on a THP tail is more frequent than
split_huge_page. Keep in mind we do the get_page_unless_zero to
stabilize the head to take the compound_lock on it, only for the
tails, never for the heads. So this restricts it to _only_ the
put_page following a gup_fast. Only gup_fast can ever take a reference
on the tail pages of a THP. Nothing else can.

I intend to add the foll_flags to gup_fast parameter so we remove
FOLL_GET from it in the KVM page fault to avoid doing atomic_inc
immediately followed by atomic_dec when establishing sptes. So the
only transient mappings that cannot be converted to pin-less
mmu_notifier will have to run put_page in gup_fast.

In short you're only going to help O_DIRECT with that change, and
removing 1 locked op for every 4k written to disk may not offset the
cost of 511 locked ops in split_huge_page.

Still worth thinking about it, but not obvious win in my view (plus
the lockdep trouble with taking too many locks nested). Comments welcome.

Thanks!
Andrea
