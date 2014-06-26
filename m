Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbaFZO4j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 10:56:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36505 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753430AbaFZO4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 10:56:38 -0400
Date: Thu, 26 Jun 2014 15:56:32 +0100
From: Mel Gorman <mgorman@suse.de>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/6] mm: page_alloc: Reduce cost of dirty zone balancing
Message-ID: <20140626145632.GG10819@suse.de>
References: <1403683129-10814-1-git-send-email-mgorman@suse.de>
 <1403683129-10814-6-git-send-email-mgorman@suse.de>
 <20140625163528.11368b86ef7d0a38cf9d1255@linux-foundation.org>
 <20140626084314.GE10819@suse.de>
 <20140626143738.GS7331@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140626143738.GS7331@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 10:37:38AM -0400, Johannes Weiner wrote:
> On Thu, Jun 26, 2014 at 09:43:14AM +0100, Mel Gorman wrote:
> > On Wed, Jun 25, 2014 at 04:35:28PM -0700, Andrew Morton wrote:
> > > On Wed, 25 Jun 2014 08:58:48 +0100 Mel Gorman <mgorman@suse.de> wrote:
> > > 
> > > > @@ -325,7 +321,14 @@ static unsigned long zone_dirty_limit(struct zone *zone)
> > > >   */
> > > >  bool zone_dirty_ok(struct zone *zone)
> > > >  {
> > > > -	unsigned long limit = zone_dirty_limit(zone);
> > > > +	unsigned long limit = zone->dirty_limit_cached;
> > > > +	struct task_struct *tsk = current;
> > > > +
> > > > +	if (tsk->flags & PF_LESS_THROTTLE || rt_task(tsk)) {
> > > > +		limit = zone_dirty_limit(zone);
> > > > +		zone->dirty_limit_cached = limit;
> > > > +		limit += limit / 4;
> > > > +	}
> > > 
> > > Could we get a comment in here explaining what we're doing and why
> > > PF_LESS_THROTTLE and rt_task control whether we do it?
> > > 
> > 
> >         /*
> >          * The dirty limits are lifted by 1/4 for PF_LESS_THROTTLE (ie. nfsd)
> >          * and real-time tasks to prioritise their allocations.
> >          * PF_LESS_THROTTLE tasks may be cleaning memory and rt tasks may be
> >          * blocking tasks that can clean pages.
> >          */
> > 
> > That's fairly weak though. It would also seem reasonable to just delete
> > this check and allow PF_LESS_THROTTLE and rt_tasks to fall into the slow
> > path if dirty pages are already fairly distributed between zones.
> > Johannes, any objection to that limit raising logic being deleted?
> 
> I copied that over from global_dirty_limits() such that the big
> picture and the per-zone picture have the same view - otherwise these
> tasks fall back to first fit zone allocations before global limits
> start throttling dirtiers and waking up the flushers.  This increases
> the probability of reclaim running into dirty pages.
> 
> Would you remove it from global_dirty_limits() as well?
> 
> On that note, I don't really understand why global_dirty_limits()
> raises the *background* limit for less-throttle/rt tasks, shouldn't it
> only raise the dirty limit?  Sure, the throttle point is somewhere
> between the two limits, but we don't really want to defer waking up
> the flushers for them.

All of which is fair enough and is something that should be examined on
a rainy day (shouldn't take too long in Ireland). I'm not going to touch
it within this series though. It's outside the scope of what I'm trying
to do here -- restore performance of tiobench and bonnie++ to as close to
3.0 levels as possible. The series is tripping up enough on the fair zone
and CFQ aspects as it is without increasing the scope :(

-- 
Mel Gorman
SUSE Labs
