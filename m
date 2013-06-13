Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab3FMFq2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 01:46:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58510 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab3FMFq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 01:46:26 -0400
Date: Wed, 12 Jun 2013 22:46:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] Percpu tag allocator
Message-Id: <20130612224623.bf303e33.akpm@linux-foundation.org>
In-Reply-To: <20130613035432.GE10979@localhost>
References: <1371009804-11596-1-git-send-email-koverstreet@google.com>
	<20130612163854.91da28042ab7a943b69a5970@linux-foundation.org>
	<20130613020536.GA10979@localhost>
	<20130612200311.7f9d938a.akpm@linux-foundation.org>
	<20130613035432.GE10979@localhost>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Jun 2013 20:54:32 -0700 Kent Overstreet <koverstreet@google.com> wrote:

> On Wed, Jun 12, 2013 at 08:03:11PM -0700, Andrew Morton wrote:
> > On Wed, 12 Jun 2013 19:05:36 -0700 Kent Overstreet <koverstreet@google.com> wrote:
> > 
> > > ...
> > >
> > > > Why can't we use ida_get_new_above()?
> > > > 
> > > >    If it is "speed" then how bad is the problem and what efforts have
> > > >    been made to address them within the idr code?  (A per-cpu magazine
> > > >    frontend to ida_get_new_above() might suit).
> > > > 
> > > >    If it is "functionality" then what efforts have been made to
> > > >    suitably modify the ida code?
> > > 
> > > Originally, it was because every time I opened idr.[ch] I was confronted
> > > with an enormous pile of little functions, with very little indication
> > > in the way of what they were all trying to do or which ones I might want
> > > to start with.
> > > 
> > > Having finally read enough of the code to maybe get a handle on what
> > > it's about - performance is a large part of it, but idr is also a more
> > > complicated api that does more than what I wanted.
> > 
> > They all sound like pretty crappy reasons ;) If the idr/ida interface
> > is nasty then it can be wrapped to provide the same interface as the
> > percpu tag allocator.
> 
> Well, the way I see it right now, idr and this tag allocator are doing
> two somewhat different things and I'm really not sure how one piece of
> code could do both jobs.
> 
> Supposing idr could be made percpu and just as fast as my tag allocator:

We don't know how fast either is, nor what the performance requirements are.

> the problem is, using idr where right now I'd use the tag allocator
> forces you to do two allocations instead of one:
> 
> First, you allocate your idr slot - but now that has to point to
> something, so you need a kmem_cache_alloc() too.

Only a single allocation is needed - for the bit used to reserve
ida_get_new_above()'s ID, plus epsilon for idr metadata. 
ida_get_new_above() will call kmalloc approximately 0.001 times per
invocation.

> So right now at least I honestly think letting the tag allocator and idr
> be distinct things is probably the way to go.

That depends on performance testing results and upon performance
requirements.  Neither are known at this time.

> (now someone will point out to me all the fancy percpu optimizations in
> idr I missed).

idr use percpu data for reliability, not for performance.

Cross-cpu costs might be significant.  There are surely ways to reduce
them.  I could suggest one but I've found that when I make a
suggestion, others busily work on shooting down my suggestion while
avoiding thinking of their own ideas.

> > I think all this could be done with test_and_set_bit() and friends,
> > btw.  xchg() hurts my brain.
> 
> Ahh, you were talking about with a slightly bigger rework.

Not really.  Just that the xchg() in this code could be replaced in a
straightforward fashion with test_and_set_bit().  Or maybe not.

> > > You mean if a GFP_NOWAIT allocation fails? It's the same as any other
> > > allocation, I suppose.
> > > 
> > > Did you have something else in mind that could be implemented? I don't
> > > want to add code for a reserve to this code - IMO, if a reserve is
> > > needed it should be done elsewhere (like how mempools work on top of
> > > existing allocators).
> > 
> > Dunno, really - I'm just wondering what the implications of an
> > allocation failure will be.  I suspect it's EIO?  Which in some
> > circumstances could be as serious as total system failure (loss of
> > data), so reliability/robustness is a pretty big deal.
> 
> Ahh. That's just outside the scope of this code - IME, in driver code
> GFP_NOWAIT allocations are not the norm - most tags are created when
> you're submitting a bio or processing a request, and then you're in
> process context. But in your error handling code you could also need to
> allocate tags to resubmit things - that'd be an issue if you're silly
> enough to stick all your error handling code in your interrupt handling
> path.

Our experience with alloc_pages(GFP_ATOMIC) has no relevance to this
code, because this code doesn't call alloc_pages()!  Instead of failing
if page reserves are exhausted, it will fail if no tags are available
in this new data structure.

The reliability (or otherwise) of alloc_pages(GFP_ATOMIC) is well
understood whereas the reliability of percpu_tag_alloc(GFP_ATOMIC) is
not understood at all.  So let us think about both this and about the
consequences of allocation failures.

> > Another thing: CPU hot-unplug.  If it's "don't care" then the
> > forthcoming changelog should thoroughly explain why, please.  Otherwise
> > it will need a notifier to spill back any reservation.
> 
> Oh - doesn't care, becasue steal_tags() will eventually get it. We
> _could_ satisfy more allocations if we had a notifier - but we'll still
> meet our guarantees and it's absolutely not a correctness issue, so I
> lean towards just leaving it out.

I agree.  It's a design decision which should be explained and justified
in the changelog, please.
