Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322Ab3K0QJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 11:09:18 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:42377 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505Ab3K0QJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 11:09:16 -0500
Date: Wed, 27 Nov 2013 11:09:10 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] mm, vmscan: abort futile reclaim if we've been oom killed
Message-ID: <20131127160910.GZ3556@cmpxchg.org>
References: <20131113152412.GH707@cmpxchg.org>
 <alpine.DEB.2.02.1311131400300.23211@chino.kir.corp.google.com>
 <20131114000043.GK707@cmpxchg.org>
 <alpine.DEB.2.02.1311131639010.6735@chino.kir.corp.google.com>
 <20131118164107.GC3556@cmpxchg.org>
 <alpine.DEB.2.02.1311181712080.4292@chino.kir.corp.google.com>
 <20131120160712.GF3556@cmpxchg.org>
 <alpine.DEB.2.02.1311201803000.30862@chino.kir.corp.google.com>
 <20131121164019.GK3556@cmpxchg.org>
 <alpine.DEB.2.02.1311261634040.21003@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311261634040.21003@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 04:47:56PM -0800, David Rientjes wrote:
> On Thu, 21 Nov 2013, Johannes Weiner wrote:
> 
> > All I'm trying to do is find the broader root cause for the problem
> > you are experiencing and find a solution that will leave us with
> > maintainable code.  It does not matter how few instructions your fix
> > adds, it changes the outcome of the algorithm and makes every
> > developer trying to grasp the complexity of page reclaim think about
> > yet another special condition.
> > 
> > The more specific the code is, the harder it will be to understand in
> > the future.  Yes, it's a one-liner, but we've had death by a thousand
> > cuts before, many times.  A few cycles ago, kswapd was blowing up left
> > and right simply because it was trying to meet too many specific
> > objectives from facilitating order-0 allocators, maintaining zone
> > health, enabling compaction for higher order allocation, writing back
> > dirty pages.  Ultimately, it just got stuck in endless loops because
> > of conflicting conditionals.  We've had similar problems in the scan
> > count calculation etc where all the checks and special cases left us
> > with code that was impossible to reason about.  There really is a
> > history of "low overhead one-liner fixes" eating us alive in the VM.
> > 
> 
> Your objection is that the added code is obscure and will require kernel 
> hackers to think about why it's there?  I could certainly add a comment:
> 
> 	/*
> 	 * The oom killer only kills processes when reclaim has already
> 	 * failed for its allocation context, continuously trying won't
> 	 * help.
> 	 */
> 
> to the patch? 
> 
> > The solution was always to take a step back and integrate all
> > requirements properly.  Not only did this fix the problems, the code
> > ended up being much more robust and easier to understand and modify as
> > well.
> > 
> > If shortening the direct reclaim cycle is an adequate solution to your
> > problem, it would be much preferable.  Because
> > 
> >   "checking at a reasonable interval if the work I'm doing is still
> >    necessary"
> > 
> > is a much more approachable, generic, and intuitive concept than
> > 
> >   "the OOM killer has gone off, direct reclaim is futile, I should
> >    exit quickly to release memory so that not more tasks get caught
> >    doing direct reclaim".
> > 
> > and the fix would benefit a much wider audience.
> > 
> 
> I agree with your point that obscure random fixes does obfuscate the VM in 
> many different ways and I'd like to support you in anyway that I can to 
> make sure that my fix doesn't do that for anybody in the future, the 
> comment being added may be one way of doing that.
> 
> I disagree with changing the "reasonable interval" to determine if reclaim 
> is still necessary because many parallel reclaimers will indicate a higher 
> demand for free memory and it prevents short-circuiting direct reclaim, 
> returning to the page allocator, and finding that the memory you've 
> reclaimed has been stolen by another allocator.

I can't reach the same conclusion as you.  There will always be
concurrent allocators while some tasks are in direct reclaim.  But the
longer you reclaim without checking free pages, the higher the
opportunity for another task to steal your work.  Shortening direct
reclaim cycles would actually mean shrinking that window where other
tasks can steal the pages you reclaimed.

> That race to allocate the reclaimed memory will always exist if checking 
> zone watermarks from direct reclaim to determine whether we should 
> terminate or not as part of your suggested, the alternative would be to 
> actually do get_page_from_freelist() and actually allocate on every 
> iteration.  For the vast majority of reclaimers, I think this would 
> terminate prematurely when we haven't hit the SWAP_CLUSTER_MAX threshold 
> and since the removal of lumpy reclaim and the reliance on synchronous 
> memory compaction following one of these oom events to defragment memory, 
> I would be tenative to implement such a solution.

Yes, I really meant get_page_from_freelist() after every priority
cycle.  What does "prematurely" mean?  If task A is currently doing
reclaim and task B steals the pages, A will have to go back to direct
reclaim.  If A reclaims one cycle and then allocates, there is a
reduced chance of B stealing the pages, and so B will have to do
direct reclaim and pull its own weight.  If A did enough for both,
there wouldn't have been any point in continuing reclaim.
