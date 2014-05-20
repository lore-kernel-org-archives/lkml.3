Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303AbaETGdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 02:33:51 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:9229 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750699AbaETGdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 02:33:50 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsgGAOr2elN5LL1s/2dsb2JhbABZgwarBwEBAQaaKQGBFRd0giUBAQUnExwjEAgDDgoJJQ8FJQMhE4hA0mIXFoU/iHkHhEABA480iiuLE4gLg0orgTEk
Date: Tue, 20 May 2014 16:33:30 +1000
From: Dave Chinner <david@fromorbit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, riel@redhat.com,
        kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com,
        kamezawa.hiroyu@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [PATCH] mm/vmscan: Do not block forever at
 shrink_inactive_list().
Message-ID: <20140520063330.GI18954@dastard>
References: <201405192340.FCD48964.OFQHOOJLVSFFMt@I-love.SAKURA.ne.jp>
 <20140520004449.GE18954@dastard>
 <20140519225915.3370328d.akpm@linux-foundation.org>
 <20140519230311.583f762c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140519230311.583f762c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 11:03:11PM -0700, Andrew Morton wrote:
> On Mon, 19 May 2014 22:59:15 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Tue, 20 May 2014 10:44:49 +1000 Dave Chinner <david@fromorbit.com> wrote:
> > 
> > > @@ -258,14 +258,23 @@ xfs_bmapi_allocate_worker(
> > >  	struct xfs_bmalloca	*args = container_of(work,
> > >  						struct xfs_bmalloca, work);
> > >  	unsigned long		pflags;
> > > +	unsigned long		new_pflags = PF_FSTRANS;
> > >  
> > > -	/* we are in a transaction context here */
> > > -	current_set_flags_nested(&pflags, PF_FSTRANS);
> > > +	/*
> > > +	 * we are in a transaction context here, but may also be doing work
> > > +	 * in kswapd context, and hence we may need to inherit that state
> > > +	 * temporarily to ensure that we don't block waiting for memory reclaim
> > > +	 * in any way.
> > > +	 */
> > > +	if (args->kswapd)
> > > +		new_pflags |= PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD;
> > 
> > So current_is_kswapd() returns true for a thread which is not kswapd. 
> > That's a bit smelly.
> > 
> > Should this thread really be incrementing KSWAPD_INODESTEAL instead of
> > PGINODESTEAL, for example?  current_is_kswapd() does a range of things,
> > only one(?) of which you actually want.
> > 
> > It would be cleaner to create a new PF_ flag to select just that
> > behavior.  That's a better model than telling the world "I am magic and
> > special".
> 
> Or a new __GFP_FLAG.

Sure - and with that XFS will need another PF_ flag to tell the
memory allocator to set the new __GFP_FLAG on every allocation done
in that kworker task context, just like it uses PF_FSTRANS to ensure
that __GFP_NOFS is set for all the allocations in that kworker
context....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
