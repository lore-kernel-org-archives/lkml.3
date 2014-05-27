Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbaE0XH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 19:07:28 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:33553 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbaE0XH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 19:07:27 -0400
Date: Tue, 27 May 2014 16:05:36 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mmotm/next]
 memcg-mm-introduce-lowlimit-reclaim-fix2.patch
In-Reply-To: <20140527150100.70f6c7cf93d27d58c8f5eb48@linux-foundation.org>
Message-ID: <alpine.LSU.2.11.1405271534150.4770@eggly.anvils>
References: <alpine.LSU.2.11.1405271432400.4485@eggly.anvils> <20140527150100.70f6c7cf93d27d58c8f5eb48@linux-foundation.org>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2014, Andrew Morton wrote:
> On Tue, 27 May 2014 14:36:04 -0700 (PDT) Hugh Dickins <hughd@google.com> wrote:
> 
> > mem_cgroup_within_guarantee() oopses in _raw_spin_lock_irqsave() when
> > booted with cgroup_disable=memory.  Fix that in the obvious inelegant
> > way for now - though I hope we are moving towards a world in which
> > almost all of the mem_cgroup_disabled() tests will vanish, with a
> > root_mem_cgroup which can handle the basics even when disabled.
> > 
> > I bet there's a neater way of doing this, rearranging the loop (and we
> > shall want to avoid spinlocking on root_mem_cgroup when we reach that
> > new world), but that's the kind of thing I'd get wrong in a hurry!
> > 
> > ...
> >
> > @@ -2793,6 +2793,9 @@ static struct mem_cgroup *mem_cgroup_loo
> >  bool mem_cgroup_within_guarantee(struct mem_cgroup *memcg,
> >  		struct mem_cgroup *root)
> >  {
> > +	if (mem_cgroup_disabled())
> > +		return false;
> > +
> >  	do {
> >  		if (!res_counter_low_limit_excess(&memcg->res))
> >  			return true;
> 
> This seems to be an awfully late and deep place at which to be noticing
> mem_cgroup_disabled().  Should mem_cgroup_within_guarantee() even be called
> in this state?

I think it's a natural consequence of our preferring to use a single
path for memcg and non-memcg, outside of memcontrol.c itself.  So in
vmscan.c there are loops iterating through a subtree of memcgs, which
in the non-memcg case can only ever encounter root_mem_cgroup (or NULL).

In doing so, it's not surprising that __shrink_zone() should want to
check mem_cgroup_within_guarantee().  Now, __shrink_zone() does have an
honor_memcg_guarantee arg passed in, and I did consider initializing
that according to !mem_cgroup_disabled(): which would be not so late
and not so deep.  But then noticed mem_cgroup_all_within_guarantee(),
which is called without condition on honor_guarantee, so backed away:
we could very easily change that, I suppose, but...

I'm sure there is a better way of dealing with this than sprinkling
mem_cgroup_disabled() tests all over, and IIUC Hannes is moving us
towards that by making root_mem_cgroup more of a first-class citizen
(following on from earlier per-cpu-ification of memcg's most expensive
fields).

My attitude is that for now we just chuck in a !mem_cgroup_disabled()
wherever it stops a crash, as before; but in future aim to give the
cgroup_disabled=memory root_mem_cgroup all it needs to handle this
seamlessly.  Ideally just a !mem_cgroup_disabled() test at the point
of memcg creation, and everything else fall out naturally (but maybe
some more lookup_page_cgroup() NULL tests).  In practice we may identify
other places, where it's useful to add a special test to avoid expense;
though usually that would be expense worth avoiding at the root, even
when !mem_cgroup_disabled().

And probably a static dummy root_mem_cgroup even when !CONFIG_MEMCG.

(Not that I'm expecting to do any of this work myself!)

Hugh
