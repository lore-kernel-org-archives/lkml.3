Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346Ab3LJXDp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 18:03:45 -0500
Received: from mail-yh0-f49.google.com ([209.85.213.49]:60279 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab3LJXDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 18:03:42 -0500
Date: Tue, 10 Dec 2013 15:03:39 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mgorman@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm, page_alloc: allow __GFP_NOFAIL to allocate below
 watermarks after reclaim
In-Reply-To: <20131210075059.GA11295@suse.de>
Message-ID: <alpine.DEB.2.02.1312101453020.22701@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1312091402580.11026@chino.kir.corp.google.com> <20131210075059.GA11295@suse.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Dec 2013, Mel Gorman wrote:

> > If direct reclaim has failed to free memory, __GFP_NOFAIL allocations
> > can potentially loop forever in the page allocator.  In this case, it's
> > better to give them the ability to access below watermarks so that they
> > may allocate similar to the same privilege given to GFP_ATOMIC
> > allocations.
> > 
> > We're careful to ensure this is only done after direct reclaim has had
> > the chance to free memory, however.
> > 
> > Signed-off-by: David Rientjes <rientjes@google.com>
> 
> The main problem with doing something like this is that it just smacks
> into the adjusted watermark if there are a number of __GFP_NOFAIL. Who
> was the user of __GFP_NOFAIL that was fixed by this patch?
> 

Nobody, it comes out of a memcg discussion where __GFP_NOFAIL were 
recently given the ability to bypass charges to the root memcg when the 
memcg has hit its limit since we disallow the oom killer to kill a process 
(for the same reason that the vast majority of __GFP_NOFAIL users, those 
that do GFP_NOFS | __GFP_NOFAIL, disallow the oom killer in the page 
allocator).

Without some other thread freeing memory, these allocations simply loop 
forever.  We probably don't want to reconsider the choice that prevents 
calling the oom killer in !__GFP_FS contexts since it will allow 
unnecessary oom killing when memory can actually be freed by another 
thread.

Since there are comments in both gfp.h and page_alloc.c that say no new 
users will be added, it seems legitimate to ensure that the allocation 
will at least have a chance of succeeding, but not the point of depleting 
memory reserves entirely.

> There are enough bad users of __GFP_NOFAIL that I really question how
> good an idea it is to allow emergency reserves to be used when they are
> potentially leaked to other !__GFP_NOFAIL users via the slab allocator
> shortly afterwards.
> 

You could make the same argument for GFP_ATOMIC which can also allow 
access to memory reserves.
