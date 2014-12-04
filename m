Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447AbaLDPSE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 10:18:04 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:40700 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094AbaLDPSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 10:18:02 -0500
Date: Thu, 4 Dec 2014 16:17:58 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Qiang Huang <h.huangqiang@huawei.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] mm, oom: remove gfp helper function
Message-ID: <20141204151758.GC25001@dhcp22.suse.cz>
References: <alpine.DEB.2.10.1411261416480.13014@chino.kir.corp.google.com>
 <20141127102547.GA18833@dhcp22.suse.cz>
 <20141201233040.GB29642@phnom.home.cmpxchg.org>
 <20141203155222.GH23236@dhcp22.suse.cz>
 <20141203181509.GA24567@phnom.home.cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141203181509.GA24567@phnom.home.cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 03-12-14 13:15:09, Johannes Weiner wrote:
> On Wed, Dec 03, 2014 at 04:52:22PM +0100, Michal Hocko wrote:
> > On Mon 01-12-14 18:30:40, Johannes Weiner wrote:
> > > On Thu, Nov 27, 2014 at 11:25:47AM +0100, Michal Hocko wrote:
> > > > On Wed 26-11-14 14:17:32, David Rientjes wrote:
> > > > > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > > > > --- a/mm/page_alloc.c
> > > > > +++ b/mm/page_alloc.c
> > > > > @@ -2706,7 +2706,7 @@ rebalance:
> > > > >  	 * running out of options and have to consider going OOM
> > > > >  	 */
> > > > >  	if (!did_some_progress) {
> > > > > -		if (oom_gfp_allowed(gfp_mask)) {
> > > > 		/*
> > > > 		 * Do not attempt to trigger OOM killer for !__GFP_FS
> > > > 		 * allocations because it would be premature to kill
> > > > 		 * anything just because the reclaim is stuck on
> > > > 		 * dirty/writeback pages.
> > > > 		 * __GFP_NORETRY allocations might fail and so the OOM
> > > > 		 * would be more harmful than useful.
> > > > 		 */
> > > 
> > > I don't think we need to explain the individual flags, but it would
> > > indeed be useful to remark here that we shouldn't OOM kill from
> > > allocations contexts with (severely) limited reclaim abilities.
> > 
> > Is __GFP_NORETRY really related to limited reclaim abilities? I thought
> > it was merely a way to tell the allocator to fail rather than spend too
> > much time reclaiming.
> 
> And you wouldn't call that "limited reclaim ability"?

I really do not want to go into language lawyering here. But to me the
reclaim ability is what the reclaim is capable to do with the given gfp.
And __GFP_NORETRY is completely irrelevant for the reclaim. It tells the
allocator how hard it should try (similar like __GFP_REPEAT or
__GFP_NOFAIL) unlike __GFP_FS which restricts the reclaim in its
operation.

> I guess it's a
> matter of phrasing, but the point is that we don't want anybody to OOM
> kill that didn't exhaust all other options that are usually available
> to allocators.  This includes the ability to enter the FS, the ability
> to do IO in general, and the ability to retry reclaim.  Possibly more.

Right.

> > If you are referring to __GFP_FS part then I have
> > no objections to be less specific, of course, but __GFP_IO would fall
> > into the same category but we are not checking for it. I have no idea
> > why we consider the first and not the later one, to be honest...
> 
> Which proves my point that we should document high-level intent rather
> than implementation.  Suddenly, that missing __GFP_IO is sticking out
> like a sore thumb...

I am obviously not insisting on the above wording. I am for everything
that would clarify the test and do not force me to go through several
hops of the git blame to find the original intention again after year
when I forget this again.

-- 
Michal Hocko
SUSE Labs
