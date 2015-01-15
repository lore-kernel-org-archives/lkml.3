Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398AbbAOKpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 05:45:23 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:49527 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbbAOKpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 05:45:21 -0500
Date: Thu, 15 Jan 2015 11:45:17 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, mgorman@suse.de, mingo@redhat.com
Subject: Re: [PATCH] sched,numa: do not move past the balance point if
 unbalanced
Message-ID: <20150115104517.GR23965@worktop.programming.kicks-ass.net>
References: <20150112163039.7eb9a9e0@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150112163039.7eb9a9e0@annuminas.surriel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 04:30:39PM -0500, Rik van Riel wrote:
> There is a subtle interaction between the logic introduced in commit
> e63da03639cc9e6e83b62e7ef8ffdbb92421416a, the way the load balancer

  e63da03639cc ("sched/numa: Allow task switch if load imbalance improves")

I have the below in my .gitconfig to easily create them things:

[core]
        abbrev = 12
[alias]
        one = show -s --pretty='format:%h (\"%s\")'

> counts the load on each NUMA node, and the way NUMA hinting faults are
> done.
> 
> Specifically, the load balancer only counts currently running tasks
> in the load, while NUMA hinting faults may cause tasks to stop, if
> the page is locked by another task.
> 
> This could cause all of the threads of a large single instance workload,
> like SPECjbb2005, to migrate to the same NUMA node. This was possible
> because occasionally they all fault on the same few pages, and only one
> of the threads remains runnable. That thread can move to the process's
> preferred NUMA node without making the imbalance worse, because nothing
> else is running at that time.
> 
> The fix is to check the direction of the net moving of load, and to
> refuse a NUMA move if it would cause the system to move past the point
> of balance.  In an unbalanced state, only moves that bring us closer
> to the balance point are allowed.

Did you also test with whatever load needed the previous thing? Its far
too easy to fix one and break the other in my experience ;-)

>  	orig_src_load = env->src_stats.load;
> -	orig_dst_load = env->dst_stats.load;
>  
> -	if (orig_dst_load < orig_src_load)
> -		swap(orig_dst_load, orig_src_load);
> -
> -	old_imb = orig_dst_load * src_capacity * 100 -
> -		  orig_src_load * dst_capacity * env->imbalance_pct;
> +	/*
> +	 * In a task swap, there will be one load moving from src to dst,
> +	 * and another moving back. This is the net sum of both moves.
> +	 * Allow the move if it brings the system closer to a balanced
> +	 * situation, without crossing over the balance point.
> +	 */

This comment seems to 'forget' about the !swap moves?

> +	moved_load = orig_src_load - src_load;
>  
> -	/* Would this change make things worse? */
> -	return (imb > old_imb);
> +	if (moved_load > 0)
> +		/* Moving src -> dst. Did we overshoot balance? */
> +		return src_load < dst_load;

So here we inhibit movement when the src cpu gained (moved_load > 0) and
src was smaller than dst.

However there is no check the new src value is in fact bigger than dst;
src could have gained and still be smaller. And afaict that's a valid
move, even under the proposed semantics, right?

> +	else
> +		/* Moving dst -> src. Did we overshoot balance? */
> +		return dst_load < src_load;

And vs.

>  }

One should use capacity muck when comparing load between CPUs.

In any case, brain hurt.


