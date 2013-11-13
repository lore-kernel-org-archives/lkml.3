Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759420Ab3KMPYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 10:24:23 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:36831 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759206Ab3KMPYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 10:24:19 -0500
Date: Wed, 13 Nov 2013 10:24:12 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] mm, vmscan: abort futile reclaim if we've been oom killed
Message-ID: <20131113152412.GH707@cmpxchg.org>
References: <alpine.DEB.2.02.1311121801200.18803@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311121801200.18803@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 06:02:18PM -0800, David Rientjes wrote:
> The oom killer is only invoked when reclaim has already failed and it
> only kills processes if the victim is also oom.  In other words, the oom
> killer does not select victims when a process tries to allocate from a
> disjoint cpuset or allocate DMA memory, for example.
> 
> Therefore, it's pointless for an oom killed process to continue
> attempting to reclaim memory in a loop when it has been granted access to
> memory reserves.  It can simply return to the page allocator and allocate
> memory.

On the other hand, finishing reclaim of 32 pages should not be a
problem.

> If there is a very large number of processes trying to reclaim memory,
> the cond_resched() in shrink_slab() becomes troublesome since it always
> forces a schedule to other processes also trying to reclaim memory.
> Compounded by many reclaim loops, it is possible for a process to sit in
> do_try_to_free_pages() for a very long time when reclaim is pointless and
> it could allocate if it just returned to the page allocator.

"Very large number of processes"

"sit in do_try_to_free_pages() for a very long time"

Can you quantify this a bit more?

And how common are OOM kills on your setups that you need to optimize
them on this level?

It sounds like your problem could be solved by having cond_resched()
not schedule away from TIF_MEMDIE processes, which would be much
preferable to oom-killed checks in random places.
