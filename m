Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab3LCWZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 17:25:23 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:44156 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754476Ab3LCWZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 17:25:21 -0500
Date: Tue, 3 Dec 2013 17:25:11 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: memcg: do not declare OOM from __GFP_NOFAIL
 allocations
Message-ID: <20131203222511.GU3556@cmpxchg.org>
References: <alpine.DEB.2.02.1311261658170.21003@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1311261931210.5973@chino.kir.corp.google.com>
 <20131127163916.GB3556@cmpxchg.org>
 <alpine.DEB.2.02.1311271336220.9222@chino.kir.corp.google.com>
 <20131127225340.GE3556@cmpxchg.org>
 <alpine.DEB.2.02.1311271526080.22848@chino.kir.corp.google.com>
 <20131128102049.GF2761@dhcp22.suse.cz>
 <alpine.DEB.2.02.1311291543400.22413@chino.kir.corp.google.com>
 <20131202132201.GC18838@dhcp22.suse.cz>
 <alpine.DEB.2.02.1312021452510.13465@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1312021452510.13465@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 03:02:09PM -0800, David Rientjes wrote:
> On Mon, 2 Dec 2013, Michal Hocko wrote:
> 
> > > > What if the callers simply cannot deal with the allocation failure?
> > > > 84235de394d97 (fs: buffer: move allocation failure loop into the
> > > > allocator) describes one such case when __getblk_slow tries desperately
> > > > to grow buffers relying on the reclaim to free something. As there might
> > > > be no reclaim going on we are screwed.
> > > > 
> > > 
> > > My suggestion is to spin, not return NULL. 
> > 
> > Spin on which level? The whole point of this change was to not spin for
> > ever because the caller might sit on top of other locks which might
> > prevent somebody else to die although it has been killed.
> 
> See my question about the non-memcg page allocator behavior below.

No, please answer the question.

> > > Bypassing to the root memcg 
> > > can lead to a system oom condition whereas if memcg weren't involved at 
> > > all the page allocator would just spin (because of !__GFP_FS).
> > 
> > I am confused now. The page allocation has already happened at the time
> > we are doing the charge. So the global OOM would have happened already.
> > 
> 
> That's precisely the point, the successful charges can allow additional 
> page allocations to occur and cause system oom conditions if you don't 
> have memcg isolation.  Some customers, including us, use memcg to ensure 
> that a set of processes cannot use more resources than allowed.  Any 
> bypass opens up the possibility of additional memory allocations that 
> cause the system to be oom and then we end up requiring a userspace oom 
> handler because our policy is complex enough that it cannot be effected 
> simply by /proc/pid/oom_score_adj.
> 
> I'm not quite sure how significant of a point this is, though, because it 
> depends on the caller doing the __GFP_NOFAIL allocations that allow the 
> bypass.  If you're doing
> 
> 	for (i = 0; i < 1 << 20; i++)
> 		page[i] = alloc_page(GFP_NOFS | __GFP_NOFAIL);

Hyperbole serves no one.

> it can become significant, but I'm unsure of how much memory all callers 
> end up allocating in this context.
>
> > > > That being said, while I do agree with you that we should strive for
> > > > isolation as much as possible there are certain cases when this is
> > > > impossible to achieve without seeing much worse consequences. For now,
> > > > we hope that __GFP_NOFAIL is used very scarcely.
> > > 
> > > If that's true, why not bypass the per-zone min watermarks in the page 
> > > allocator as well to allow these allocations to succeed?
> > 
> > Allocations are already done. We simply cannot charge that allocation
> > because we have reached the hard limit. And the said allocation might
> > prevent OOM action to proceed due to held locks.
> 
> I'm referring to the generic non-memcg page allocator behavior.  Forget 
> memcg for a moment.  What is the behavior in the _page_allocator_ for 
> GFP_NOFS | __GFP_NOFAIL?  Do we spin forever if reclaim fails or do we 
> bypas the per-zone min watermarks to allow it to allocate because "it 
> needs to succeed, it may be holding filesystem locks"?
> 
> It's already been acknowledged in this thread that no bypassing is done 
> in the page allocator and it just spins.  There's some handwaving saying 
> that since the entire system is oom that there is a greater chance that 
> memory will be freed by something else, but that's just handwaving and is 
> certainly no guaranteed.

Do you have another explanation of why this deadlock is not triggering
in the global case?  It's pretty obvious that there is a deadlock that
can not be resolved unless some unrelated task intervenes, just read
__alloc_pages_slowpath().

But we had a concrete bug report for memcg where there was no other
task to intervene.  One was stuck in the OOM killer waiting for the
victim to exit, the victim was stuck on locks that the killer held.

> So, my question again: why not bypass the per-zone min watermarks in the 
> page allocator?

I don't even know what your argument is supposed to be.  The fact that
we don't do it in the page allocator means that there can't be a bug
in memcg?
