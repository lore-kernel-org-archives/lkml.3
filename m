Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570Ab3FMDyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 23:54:39 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:43387 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756659Ab3FMDyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 23:54:37 -0400
Date: Wed, 12 Jun 2013 20:54:32 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] Percpu tag allocator
Message-ID: <20130613035432.GE10979@localhost>
References: <1371009804-11596-1-git-send-email-koverstreet@google.com>
 <20130612163854.91da28042ab7a943b69a5970@linux-foundation.org>
 <20130613020536.GA10979@localhost>
 <20130612200311.7f9d938a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130612200311.7f9d938a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 08:03:11PM -0700, Andrew Morton wrote:
> On Wed, 12 Jun 2013 19:05:36 -0700 Kent Overstreet <koverstreet@google.com> wrote:
> 
> > ...
> >
> > > Why can't we use ida_get_new_above()?
> > > 
> > >    If it is "speed" then how bad is the problem and what efforts have
> > >    been made to address them within the idr code?  (A per-cpu magazine
> > >    frontend to ida_get_new_above() might suit).
> > > 
> > >    If it is "functionality" then what efforts have been made to
> > >    suitably modify the ida code?
> > 
> > Originally, it was because every time I opened idr.[ch] I was confronted
> > with an enormous pile of little functions, with very little indication
> > in the way of what they were all trying to do or which ones I might want
> > to start with.
> > 
> > Having finally read enough of the code to maybe get a handle on what
> > it's about - performance is a large part of it, but idr is also a more
> > complicated api that does more than what I wanted.
> 
> They all sound like pretty crappy reasons ;) If the idr/ida interface
> is nasty then it can be wrapped to provide the same interface as the
> percpu tag allocator.

Well, the way I see it right now, idr and this tag allocator are doing
two somewhat different things and I'm really not sure how one piece of
code could do both jobs.

Supposing idr could be made percpu and just as fast as my tag allocator:
the problem is, using idr where right now I'd use the tag allocator
forces you to do two allocations instead of one:

First, you allocate your idr slot - but now that has to point to
something, so you need a kmem_cache_alloc() too. Which is probably the
way to go if you don't want to preallocate everything, but for the kinds
of things I'm using the tag allocator for preallocating tag structs is
fine but that second allocation would really hurt.

So, suppose we reimplement idr on top of the tag allocator: you have a
parallel array (or array type thing) of pointers, that lets you map
integers -> pointers - that gets you the current idr functionality
(minus whatever I've missed about it).

But with idr you don't have to specify the maximum integer/tag up front
- it enlarges the mapping as needed, which is great but it's a fair
amount of complexity. So now we've got two parallel data structures -
the tag allocator, and this extensible array thing - idr, if I'm not
mistaken, rolls the allocation stuff into the extensible array data
structure.

For users of idr who care about scalability this might be the way to go,
but I'm sure there's plenty who don't and this would be be a (perhaps
small) regression in memory and runtime overhead.

So right now at least I honestly think letting the tag allocator and idr
be distinct things is probably the way to go.

> I could understand performance being an issue, but diligence demands
> that we test that, or at least provide a convincing argument.

Well, idr is going to be a lot heavier than the atomic bit vector this
tag allocator originally replaced in driver code, and that was a very
significant performance improvement.

(now someone will point out to me all the fancy percpu optimizations in
idr I missed).


> The nice thing about a lock per cpu is that the stealing CPU can grab
> it and then steal a bunch of tags without releasing the lock: less
> lock-taking.  Maybe the current code does that amortisation as well;
> my intent-reverse-engineering resources got depleted.

Yeah, the current code does do that.

> Also, with a lock-per-cpu the stolen-from CPU just spins, so the ugly
> TAG_CPU_STEALING fallback-to-global-allocator thing goes away.
> 
> > > Also, I wonder if this was all done in the incorrect order.  Why make
> > > alloc_local_tag() fail?  steal_tags() could have just noodled off and
> > > tried to steal from the next CPU if alloc_local_tag() was in progress
> > > on this CPU?
> > 
> > steal_tags() can't notice that alloc_local_tag() is in progress,
> 
> Yes it can - the stolen-from CPU sets a flag in its cpu-local object
> while in its critical section.  The stealing CPU sees that and skips.
> 
> I think all this could be done with test_and_set_bit() and friends,
> btw.  xchg() hurts my brain.

Ahh, you were talking about with a slightly bigger rework.

It's not xchg/cmpxchg that hurt my brain (I've used cmpxchg once or
twice just for keeping some statistics up to date that was just
something slightly more interesting than a counter) - it's when there's
pointers involved and insane ordering that my brain melts.

ABA. Feh.

> > You mean if a GFP_NOWAIT allocation fails? It's the same as any other
> > allocation, I suppose.
> > 
> > Did you have something else in mind that could be implemented? I don't
> > want to add code for a reserve to this code - IMO, if a reserve is
> > needed it should be done elsewhere (like how mempools work on top of
> > existing allocators).
> 
> Dunno, really - I'm just wondering what the implications of an
> allocation failure will be.  I suspect it's EIO?  Which in some
> circumstances could be as serious as total system failure (loss of
> data), so reliability/robustness is a pretty big deal.

Ahh. That's just outside the scope of this code - IME, in driver code
GFP_NOWAIT allocations are not the norm - most tags are created when
you're submitting a bio or processing a request, and then you're in
process context. But in your error handling code you could also need to
allocate tags to resubmit things - that'd be an issue if you're silly
enough to stick all your error handling code in your interrupt handling
path.

(i've seen such things done.)

> Another thing: CPU hot-unplug.  If it's "don't care" then the
> forthcoming changelog should thoroughly explain why, please.  Otherwise
> it will need a notifier to spill back any reservation.

Oh - doesn't care, becasue steal_tags() will eventually get it. We
_could_ satisfy more allocations if we had a notifier - but we'll still
meet our guarantees and it's absolutely not a correctness issue, so I
lean towards just leaving it out.
