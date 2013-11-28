Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab3K1KCW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 05:02:22 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:38804 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab3K1KCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 05:02:17 -0500
Date: Thu, 28 Nov 2013 11:02:13 +0100
From: Michal Hocko <mhocko@suse.cz>
To: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>, azurit@pobox.sk,
        mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [merged]
 mm-memcg-handle-non-error-oom-situations-more-gracefully.patch removed from
 -mm tree
Message-ID: <20131128100213.GE2761@dhcp22.suse.cz>
References: <526028bd.k5qPj2+MDOK1o6ii%akpm@linux-foundation.org>
 <alpine.DEB.2.02.1311271453270.13682@chino.kir.corp.google.com>
 <20131127233353.GH3556@cmpxchg.org>
 <alpine.DEB.2.02.1311271622330.10617@chino.kir.corp.google.com>
 <20131128021809.GI3556@cmpxchg.org>
 <alpine.DEB.2.02.1311271826001.5120@chino.kir.corp.google.com>
 <20131128031313.GK3556@cmpxchg.org>
 <alpine.DEB.2.02.1311271914460.5120@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311271914460.5120@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 27-11-13 19:20:37, David Rientjes wrote:
> On Wed, 27 Nov 2013, Johannes Weiner wrote:
> 
> > > It appears as though this work is being developed in Linus's tree rather 
> > > than -mm, so I'm asking if we should consider backing some of it out for 
> > > 3.14 instead.
> > 
> > The changes fix a deadlock problem.  Are they creating problems that
> > are worse than deadlocks, that would justify their revert?
> > 
> 
> None that I am currently aware of,

Are you saing that scenarios described in 3812c8c8f395 (mm: memcg: do not
trap chargers with full callstack on OOM) are not real or that _you_
haven't seen an issue like that?

The later doesn't seem to be so relevant as we had at least one user who
has seen those in the real life.

> I'll continue to try them out. 

> I'd suggest just dropping the stable@kernel.org from the whole series
> though unless there is another report of such a problem that people
> are running into.

The stable backport is another question though. Although the bug was
there since ages and the rework by Johannes is definitely a step forward
I would be careful to push this into stable becuase the rework brings an
user visible behavior change which might be unexpected (especially in
the middle of the stable life cycle). Seeing allocation failures instead
of OOM for charges outside of page fault context is surely a big change
in semantic.

Take mmap(MAP_POPULATE) as an example. Previously we would OOM if the
limit was reached. Now the syscall returns without any error code but a
later access might block on the OOM. While I do not see this as a
problem in general as this is consistent with !memcg case I wouldn't
like to see a breakage of the previous expectation in the middle stable
life cycle.

> > Since we can't physically draw a perfect line, we should strive for a
> > reasonable and intuitive line.  After that it's rapidly diminishing
> > returns.  Killing something after that much reclaim effort without
> > success is a completely reasonable and intuitive line to draw.  It's
> > also the line that has been drawn a long time ago and we're not
> > breaking this because of a micro optmimization.
> > 
> 
> You don't think something like this is helpful after scanning a memcg will 
> a large number of processes?

It looks as a one-shot workaround for short lived processes to me.
I agree with Johannes that it doesn't seem to be worth it. The race will
be always there. Moreover why should memcg OOM killer should behave
differently from the global OOM?

> We've had this patch internally since we started using memcg, it has 
> avoided some unnecessary oom killing.
> ---
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1836,6 +1836,13 @@ static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	if (!chosen)
>  		return;
>  	points = chosen_points * 1000 / totalpages;
> +
> +	/* One last chance to see if we really need to kill something */
> +	if (mem_cgroup_margin(memcg) >= (1 << order)) {
> +		put_task_struct(chosen);
> +		return;
> +	}
> +
>  	oom_kill_process(chosen, gfp_mask, order, points, totalpages, memcg,
>  			 NULL, "Memory cgroup out of memory");
>  }

-- 
Michal Hocko
SUSE Labs
