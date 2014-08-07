Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933094AbaHGQtx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 12:49:53 -0400
Received: from mail-qa0-f74.google.com ([209.85.216.74]:56389 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330AbaHGQtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 12:49:50 -0400
References: <1407186897-21048-1-git-send-email-hannes@cmpxchg.org> <1407186897-21048-2-git-send-email-hannes@cmpxchg.org> <20140807130822.GB12730@dhcp22.suse.cz> <20140807153141.GD14734@cmpxchg.org>
From: Greg Thelen <gthelen@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 1/4] mm: memcontrol: reduce reclaim invocations for higher order requests
Date: Thu, 07 Aug 2014 09:10:43 -0700
In-reply-to: <20140807153141.GD14734@cmpxchg.org>
Message-ID: <xr93lhr0z1ur.fsf@gthelen.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, Aug 07 2014, Johannes Weiner wrote:

> On Thu, Aug 07, 2014 at 03:08:22PM +0200, Michal Hocko wrote:
>> On Mon 04-08-14 17:14:54, Johannes Weiner wrote:
>> > Instead of passing the request size to direct reclaim, memcg just
>> > manually loops around reclaiming SWAP_CLUSTER_MAX pages until the
>> > charge can succeed.  That potentially wastes scan progress when huge
>> > page allocations require multiple invocations, which always have to
>> > restart from the default scan priority.
>> > 
>> > Pass the request size as a reclaim target to direct reclaim and leave
>> > it to that code to reach the goal.
>> 
>> THP charge then will ask for 512 pages to be (direct) reclaimed. That
>> is _a lot_ and I would expect long stalls to achieve this target. I
>> would also expect quick priority drop down and potential over-reclaim
>> for small and moderately sized memcgs (e.g. memcg with 1G worth of pages
>> would need to drop down below DEF_PRIORITY-2 to have a chance to scan
>> that many pages). All that done for a charge which can fallback to a
>> single page charge.
>> 
>> The current code is quite hostile to THP when we are close to the limit
>> but solving this by introducing long stalls instead doesn't sound like a
>> proper approach to me.
>
> THP latencies are actually the same when comparing high limit nr_pages
> reclaim with the current hard limit SWAP_CLUSTER_MAX reclaim, although
> system time is reduced with the high limit.
>
> High limit reclaim with SWAP_CLUSTER_MAX has better fault latency but
> it doesn't actually contain the workload - with 1G high and a 4G load,
> the consumption at the end of the run is 3.7G.
>
> So what I'm proposing works and is of equal quality from a THP POV.
> This change is complicated enough when we stick to the facts, let's
> not make up things based on gut feeling.

I think that high order non THP page allocations also benefit from this.
Such allocations don't have a small page fallback.

This may be in flux, but linux-next shows me that:
* mem_cgroup_reclaim()
  frees at least SWAP_CLUSTER_MAX (32) pages.
* try_charge() calls mem_cgroup_reclaim() indefinitely for
  costly (3) or smaller orders assuming that something is reclaimed on
  each iteration.
* try_charge() uses a loop of MEM_CGROUP_RECLAIM_RETRIES (5) for
  larger-than-costly orders.

So for larger-than-costly allocations, try_charge() should be able to
reclaim 160 (5*32) pages which satisfies an order:7 allocation.  But for
order:8+ allocations try_charge() and mem_cgroup_reclaim() are too eager
to give up without something like this.  So I think this patch is a step
in the right direction.

Coincidentally, we've been recently been experimenting with something
like this.  Though we didn't modify the interface between
mem_cgroup_reclaim() and try_to_free_mem_cgroup_pages() - instead we
looped within mem_cgroup_reclaim() until nr_pages of margin were found.
But I have no objection the proposed plumbing of nr_pages all the way
into try_to_free_mem_cgroup_pages().
