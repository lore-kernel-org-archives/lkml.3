Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231Ab3K1DUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 22:20:50 -0500
Received: from mail-yh0-f43.google.com ([209.85.213.43]:50975 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667Ab3K1DUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 22:20:43 -0500
Date: Wed, 27 Nov 2013 19:20:37 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        azurit@pobox.sk, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [merged] mm-memcg-handle-non-error-oom-situations-more-gracefully.patch
 removed from -mm tree
In-Reply-To: <20131128031313.GK3556@cmpxchg.org>
Message-ID: <alpine.DEB.2.02.1311271914460.5120@chino.kir.corp.google.com>
References: <526028bd.k5qPj2+MDOK1o6ii%akpm@linux-foundation.org> <alpine.DEB.2.02.1311271453270.13682@chino.kir.corp.google.com> <20131127233353.GH3556@cmpxchg.org> <alpine.DEB.2.02.1311271622330.10617@chino.kir.corp.google.com> <20131128021809.GI3556@cmpxchg.org>
 <alpine.DEB.2.02.1311271826001.5120@chino.kir.corp.google.com> <20131128031313.GK3556@cmpxchg.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Nov 2013, Johannes Weiner wrote:

> > It appears as though this work is being developed in Linus's tree rather 
> > than -mm, so I'm asking if we should consider backing some of it out for 
> > 3.14 instead.
> 
> The changes fix a deadlock problem.  Are they creating problems that
> are worse than deadlocks, that would justify their revert?
> 

None that I am currently aware of, I'll continue to try them out.  I'd 
suggest just dropping the stable@kernel.org from the whole series though 
unless there is another report of such a problem that people are running 
into.

> Since we can't physically draw a perfect line, we should strive for a
> reasonable and intuitive line.  After that it's rapidly diminishing
> returns.  Killing something after that much reclaim effort without
> success is a completely reasonable and intuitive line to draw.  It's
> also the line that has been drawn a long time ago and we're not
> breaking this because of a micro optmimization.
> 

You don't think something like this is helpful after scanning a memcg will 
a large number of processes?

We've had this patch internally since we started using memcg, it has 
avoided some unnecessary oom killing.
---
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1836,6 +1836,13 @@ static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (!chosen)
 		return;
 	points = chosen_points * 1000 / totalpages;
+
+	/* One last chance to see if we really need to kill something */
+	if (mem_cgroup_margin(memcg) >= (1 << order)) {
+		put_task_struct(chosen);
+		return;
+	}
+
 	oom_kill_process(chosen, gfp_mask, order, points, totalpages, memcg,
 			 NULL, "Memory cgroup out of memory");
 }
