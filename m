Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab3KMWQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 17:16:18 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:47770 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab3KMWQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 17:16:06 -0500
Date: Wed, 13 Nov 2013 14:16:04 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] mm, vmscan: abort futile reclaim if we've been oom
 killed
In-Reply-To: <20131113152412.GH707@cmpxchg.org>
Message-ID: <alpine.DEB.2.02.1311131400300.23211@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1311121801200.18803@chino.kir.corp.google.com> <20131113152412.GH707@cmpxchg.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Nov 2013, Johannes Weiner wrote:

> > The oom killer is only invoked when reclaim has already failed and it
> > only kills processes if the victim is also oom.  In other words, the oom
> > killer does not select victims when a process tries to allocate from a
> > disjoint cpuset or allocate DMA memory, for example.
> > 
> > Therefore, it's pointless for an oom killed process to continue
> > attempting to reclaim memory in a loop when it has been granted access to
> > memory reserves.  It can simply return to the page allocator and allocate
> > memory.
> 
> On the other hand, finishing reclaim of 32 pages should not be a
> problem.
> 

The reclaim will fail, the only reason current has TIF_MEMDIE set is 
because reclaim has completely failed.

> > If there is a very large number of processes trying to reclaim memory,
> > the cond_resched() in shrink_slab() becomes troublesome since it always
> > forces a schedule to other processes also trying to reclaim memory.
> > Compounded by many reclaim loops, it is possible for a process to sit in
> > do_try_to_free_pages() for a very long time when reclaim is pointless and
> > it could allocate if it just returned to the page allocator.
> 
> "Very large number of processes"
> 
> "sit in do_try_to_free_pages() for a very long time"
> 
> Can you quantify this a bit more?
> 

I have seen kernel logs where ~700 processes are stuck in direct reclaim 
simultaneously or scanning the tasklist in the oom killer only to defer 
because it finds a process that has already been oom killed as is stuck in 
do_try_to_free_pages() making very slow progress because of the number of 
processes trying to reclaim.

I haven't quantified how long the oom killed process sits in 
do_try_to_free_pages() as a result of needlessly looping trying to reclaim 
memory that will ultimately fail.

When the kernel oom kills something in a system oom condition, we hope 
that it will exit quickly because otherwise every other memory allocator 
comes to a grinding halt for as long as it takes to free memory.

> And how common are OOM kills on your setups that you need to optimize
> them on this level?
> 

Very common, the sum of our top-level memcg hardlimits exceeds the amount 
of memory on the system and we very frequently encounter system conditions 
as a regular event.

> It sounds like your problem could be solved by having cond_resched()
> not schedule away from TIF_MEMDIE processes, which would be much
> preferable to oom-killed checks in random places.
> 

I don't know of any other "random places" other than when the oom killed 
process is sitting in reclaim before it is selected as the victim.  Once 
it returns to the page allocator, it will immediately allocate and then be 
able to handle its pending SIGKILL.  The one spot identified where it is 
absolutely pointless to spin is in reclaim since it is virtually 
guaranteed to fail.  This patch fixes that issue.
