Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab3LDGKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 01:10:21 -0500
Received: from mail-yh0-f49.google.com ([209.85.213.49]:41001 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483Ab3LDGKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 01:10:19 -0500
Date: Tue, 3 Dec 2013 22:10:15 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Dave Chinner <david@fromorbit.com>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: memcg: do not declare OOM from __GFP_NOFAIL
 allocations
In-Reply-To: <20131204052542.GY3556@cmpxchg.org>
Message-ID: <alpine.DEB.2.02.1312032204270.2597@chino.kir.corp.google.com>
References: <20131127225340.GE3556@cmpxchg.org> <alpine.DEB.2.02.1311271526080.22848@chino.kir.corp.google.com> <20131128102049.GF2761@dhcp22.suse.cz> <alpine.DEB.2.02.1311291543400.22413@chino.kir.corp.google.com> <20131202132201.GC18838@dhcp22.suse.cz>
 <alpine.DEB.2.02.1312021452510.13465@chino.kir.corp.google.com> <20131203222511.GU3556@cmpxchg.org> <alpine.DEB.2.02.1312031531510.5946@chino.kir.corp.google.com> <20131204030101.GV3556@cmpxchg.org> <20131204043417.GM10988@dastard>
 <20131204052542.GY3556@cmpxchg.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Dec 2013, Johannes Weiner wrote:

> However, the GFP_NOFS | __GFP_NOFAIL task stuck in the page allocator
> may hold filesystem locks that could prevent a third party from
> freeing memory and/or exiting, so we can not guarantee that only the
> __GFP_NOFAIL task is getting stuck, it might well trap other tasks.
> The same applies to open-coded GFP_NOFS allocation loops of course
> unless they cycle the filesystem locks while looping.
> 

Yup.  I think we should do this:

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2631,6 +2631,11 @@ rebalance:
 						pages_reclaimed)) {
 		/* Wait for some write requests to complete then retry */
 		wait_iff_congested(preferred_zone, BLK_RW_ASYNC, HZ/50);
+
+		/* Allocations that cannot fail must allocate from somewhere */
+		if (gfp_mask & __GFP_NOFAIL)
+			alloc_flags |= ALLOC_HARDER;
+
 		goto rebalance;
 	} else {
 		/*

so that it gets the same behavior as GFP_ATOMIC and is allowed to allocate 
from memory reserves (although not enough to totally deplete memory).  We 
need to leave some memory reserves around in case another process with 
__GFP_FS invokes the oom killer and the victim needs memory to exit since 
the GFP_NOFS | __GFP_NOFAIL failure wasn't only because reclaim was 
limited due to !__GFP_FS.

The only downside of this is that it might become harder in the future to 
ever make a case to remove __GFP_NOFAIL entirely since the behavior of the 
page allocator is changed with this and it's not equivalent to coding the 
retry directly in the caller.

On a tangent, GFP_NOWAIT | __GFP_NOFAIL and GFP_ATOMIC | __GFP_NOFAIL 
actually allows allocations to fail.  Nothing currently does that, but I 
wonder if we should do this for correctness:

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2535,17 +2535,19 @@ rebalance:
 		}
 	}
 
-	/* Atomic allocations - we can't balance anything */
-	if (!wait)
-		goto nopage;
-
-	/* Avoid recursion of direct reclaim */
-	if (current->flags & PF_MEMALLOC)
-		goto nopage;
-
-	/* Avoid allocations with no watermarks from looping endlessly */
-	if (test_thread_flag(TIF_MEMDIE) && !(gfp_mask & __GFP_NOFAIL))
-		goto nopage;
+	if (likely(!(gfp_mask & __GFP_NOFAIL))) {
+		/* Atomic allocations - we can't balance anything */
+		if (!wait)
+			goto nopage;
+
+		/* Avoid recursion of direct reclaim */
+		if (current->flags & PF_MEMALLOC)
+			goto nopage;
+
+		/* Avoid allocations without watermarks from looping forever */
+		if (test_thread_flag(TIF_MEMDIE))
+			goto nopage;
+	}
 
 	/*
 	 * Try direct compaction. The first pass is asynchronous. Subsequent

It can be likely() because the __GFP_NOFAIL restart from the first patch 
above will likely now succeed since there's access to memory reserves and 
we never actually get here but once for __GFP_NOFAIL.  Thoughts on either 
patch?
