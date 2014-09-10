Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbaIJUcs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 16:32:48 -0400
Received: from gum.cmpxchg.org ([85.214.110.215]:48729 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380AbaIJUcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 16:32:47 -0400
Date: Wed, 10 Sep 2014 16:32:40 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Leon Romanovsky <leon@leon.nu>,
        Vlastimil Babka <vbabka@suse.cz>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] mm: page_alloc: Fix setting of ZONE_FAIR_DEPLETED on UP
 v2
Message-ID: <20140910203240.GA2043@cmpxchg.org>
References: <1404893588-21371-7-git-send-email-mgorman@suse.de>
 <53E4EC53.1050904@suse.cz>
 <20140811121241.GD7970@suse.de>
 <53E8B83D.1070004@suse.cz>
 <20140902140116.GD29501@cmpxchg.org>
 <20140905101451.GF17501@suse.de>
 <CALq1K=JO2b-=iq40RRvK8JFFbrzyH5EyAp5jyS50CeV0P3eQcA@mail.gmail.com>
 <20140908115718.GL17501@suse.de>
 <20140909125318.b07aee9f77b5a15d6b3041f1@linux-foundation.org>
 <20140910091603.GS17501@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140910091603.GS17501@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 10:16:03AM +0100, Mel Gorman wrote:
> On Tue, Sep 09, 2014 at 12:53:18PM -0700, Andrew Morton wrote:
> > On Mon, 8 Sep 2014 12:57:18 +0100 Mel Gorman <mgorman@suse.de> wrote:
> > 
> > > zone_page_state is an API hazard because of the difference in behaviour
> > > between SMP and UP is very surprising. There is a good reason to allow
> > > NR_ALLOC_BATCH to go negative -- when the counter is reset the negative
> > > value takes recent activity into account. This patch makes zone_page_state
> > > behave the same on SMP and UP as saving one branch on UP is not likely to
> > > make a measurable performance difference.
> > > 
> > > ...
> > >
> > > --- a/include/linux/vmstat.h
> > > +++ b/include/linux/vmstat.h
> > > @@ -131,10 +131,8 @@ static inline unsigned long zone_page_state(struct zone *zone,
> > >  					enum zone_stat_item item)
> > >  {
> > >  	long x = atomic_long_read(&zone->vm_stat[item]);
> > > -#ifdef CONFIG_SMP
> > >  	if (x < 0)
> > >  		x = 0;
> > > -#endif
> > >  	return x;
> > >  }
> > 
> > We now have three fixes for the same thing. 
> 
> This might be holding a record for most patches for what should have
> been a trivial issue :P
> 
> > I'm presently holding on
> > to hannes's mm-page_alloc-fix-zone-allocation-fairness-on-up.patch.
> > 
> 
> This is my preferred fix because it clearly points to where the source of the
> original problem is. Furthermore, the second hunk really should be reading
> the unsigned counter value. It's an inconsequential corner-case but it's
> still more correct although it's a pity that it's also a layering violation.
> However, adding a new API to return the raw value on UP and SMP is likely
> to be interpreted as unwelcome indirection.
> 
> > Regularizing zone_page_state() in this fashion seems a good idea and is
> > presumably safe because callers have been tested with SMP.  So unless
> > shouted at I think I'll queue this one for 3.18?
> 
> Both are ok but if we really want to regularise the API then all readers
> should be brought in line and declared an API cleanup. That looks like
> the following;
> 
> ---8<---
> From: Mel Gorman <mgorman@suse.de>
> Subject: [PATCH] mm: vmstat: regularize UP and SMP behavior
> 
> zone_page_state and friends are an API hazard because of the difference in
> behaviour between SMP and UP is very surprising.  There is a good reason
> to allow NR_ALLOC_BATCH to go negative -- when the counter is reset the
> negative value takes recent activity into account. NR_ALLOC_BATCH callers
> that matter access the raw counter but the API hazard is a lesson.
> 
> This patch makes zone_page_state, global_page_state and
> zone_page_state_snapshot return the same values on SMP and UP as saving
> the branches on UP is unlikely to make a measurable performance difference.

The API still returns an unsigned long and so can not really support
counters that can go logically negative - as opposed to negative reads
that are a side-effect of concurrency and can be interpreted as zero.

The problem is that the fairness batches abuse the internals of what
is publicly an unsigned counter to implement an unlocked allocator
that needs to be able to go negative.  We could make that counter API
truly signed to support that, but I think this patch makes the code
actually more confusing and inconsistent.
