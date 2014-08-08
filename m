Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359AbaHHMr5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 08:47:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52917 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863AbaHHMry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 08:47:54 -0400
Date: Fri, 8 Aug 2014 14:47:50 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 1/4] mm: memcontrol: reduce reclaim invocations for
 higher order requests
Message-ID: <20140808124750.GL4004@dhcp22.suse.cz>
References: <1407186897-21048-1-git-send-email-hannes@cmpxchg.org>
 <1407186897-21048-2-git-send-email-hannes@cmpxchg.org>
 <20140807130822.GB12730@dhcp22.suse.cz>
 <20140807153141.GD14734@cmpxchg.org>
 <xr93lhr0z1ur.fsf@gthelen.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xr93lhr0z1ur.fsf@gthelen.mtv.corp.google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 07-08-14 09:10:43, Greg Thelen wrote:
> On Thu, Aug 07 2014, Johannes Weiner wrote:
[...]
> > So what I'm proposing works and is of equal quality from a THP POV.
> > This change is complicated enough when we stick to the facts, let's
> > not make up things based on gut feeling.
> 
> I think that high order non THP page allocations also benefit from this.
> Such allocations don't have a small page fallback.
> 
> This may be in flux, but linux-next shows me that:
> * mem_cgroup_reclaim()
>   frees at least SWAP_CLUSTER_MAX (32) pages.
> * try_charge() calls mem_cgroup_reclaim() indefinitely for
>   costly (3) or smaller orders assuming that something is reclaimed on
>   each iteration.
> * try_charge() uses a loop of MEM_CGROUP_RECLAIM_RETRIES (5) for
>   larger-than-costly orders.

Unless there is __GFP_NORETRY which fails the charge after the first
round of unsuccessful reclaim. This is the case regardless of nr_pages
but only THP are charged with __GFP_NORETRY currently.

> So for larger-than-costly allocations, try_charge() should be able to
> reclaim 160 (5*32) pages which satisfies an order:7 allocation.  But for
> order:8+ allocations try_charge() and mem_cgroup_reclaim() are too eager
> to give up without something like this.  So I think this patch is a step
> in the right direction.

I think we should be careful for charges which are OK to fail because
there is a fallback for them (THP). The only other high-order charges are
coming from kmem and I am yet not sure what to do about those without
memcg specific slab reclaim. I wouldn't make this discussion more
complicated for this case now.

> Coincidentally, we've been recently been experimenting with something
> like this.  Though we didn't modify the interface between
> mem_cgroup_reclaim() and try_to_free_mem_cgroup_pages() - instead we
> looped within mem_cgroup_reclaim() until nr_pages of margin were found.
> But I have no objection the proposed plumbing of nr_pages all the way
> into try_to_free_mem_cgroup_pages().

-- 
Michal Hocko
SUSE Labs
