Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab3KTQHW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 11:07:22 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:38477 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753756Ab3KTQHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 11:07:18 -0500
Date: Wed, 20 Nov 2013 11:07:12 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] mm, vmscan: abort futile reclaim if we've been oom killed
Message-ID: <20131120160712.GF3556@cmpxchg.org>
References: <alpine.DEB.2.02.1311121801200.18803@chino.kir.corp.google.com>
 <20131113152412.GH707@cmpxchg.org>
 <alpine.DEB.2.02.1311131400300.23211@chino.kir.corp.google.com>
 <20131114000043.GK707@cmpxchg.org>
 <alpine.DEB.2.02.1311131639010.6735@chino.kir.corp.google.com>
 <20131118164107.GC3556@cmpxchg.org>
 <alpine.DEB.2.02.1311181712080.4292@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311181712080.4292@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 05:17:31PM -0800, David Rientjes wrote:
> On Mon, 18 Nov 2013, Johannes Weiner wrote:
> 
> > > Um, no, those processes are going through a repeated loop of direct 
> > > reclaim, calling the oom killer, iterating the tasklist, finding an 
> > > existing oom killed process that has yet to exit, and looping.  They 
> > > wouldn't loop for too long if we can reduce the amount of time that it 
> > > takes for that oom killed process to exit.
> > 
> > I'm not talking about the big loop in the page allocator.  The victim
> > is going through the same loop.  This patch is about the victim being
> > in a pointless direct reclaim cycle when it could be exiting, all I'm
> > saying is that the other tasks doing direct reclaim at that moment
> > should also be quitting and retrying the allocation.
> > 
> 
> "All other tasks" would be defined as though sharing the same mempolicy 
> context as the oom kill victim or the same set of cpuset mems, I'm not 
> sure what type of method for determining reclaim eligiblity you're 
> proposing to avoid pointlessly spinning without making progress.  Until an 
> alternative exists, my patch avoids the needless spinning and expedites 
> the exit, so I'll ask that it be merged.

I laid this out in the second half of my email, which you apparently
did not read:

"If we have multi-second stalls in direct reclaim then it should be
 fixed for all direct reclaimers.  The problem is not only OOM kill
 victims getting stuck, it's every direct reclaimer being stuck trying
 to do way too much work before retrying the allocation.

 Kswapd checks the system state after every priority cycle.  Direct
 reclaim should probably do the same and retry the allocation after
 every priority cycle or every X pages scanned, where X is something
 reasonable and not "up to every LRU page in the system"."

NAK to this incomplete drive-by fix.
