Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935162AbaBDV1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:27:40 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:54728 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935148AbaBDV1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:27:34 -0500
Date: Tue, 4 Feb 2014 13:27:32 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] fdtable: Avoid triggering OOMs from alloc_fdmem
In-Reply-To: <871tzirdwf.fsf@xmission.com>
Message-ID: <alpine.DEB.2.02.1402041312410.26019@chino.kir.corp.google.com>
References: <87r47jsb2p.fsf@xmission.com> <1391530721.4301.8.camel@edumazet-glaptop2.roam.corp.google.com> <871tzirdwf.fsf@xmission.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Feb 2014, Eric W. Biederman wrote:

> My gut feel says if there is a code path that has __GFP_NOWARN and
> because of PAGE_ALLOC_COSTLY_ORDER we loop forever then there is
> something fishy going on.
> 

The __GFP_NOWARN without __GFP_NORETRY in alloc_fdmem() is pointless 
because we already know that the allocation is PAGE_ALLOC_COSTLY_ORDER or 
smaller.  That function encodes specific knowledge of the page allocator's 
implementation so it leads me to believe that __GFP_NOWARN was intended to 
be __GFP_NORETRY from the start.  Otherwise, it's just set pointlessly and 
specifically allows for the oom killing that you're now reporting.  Since 
it can fallback to vmalloc() after exhausting all of the page allocator's 
capabilities, the __GFP_NOWARN|__GFP_NORETRY seems entirely appropriate.

The vmalloc() has never been called in this function because of the 
infinite loop in kmalloc() because of its allocation context, but it 
definitely seems better than oom killing something.

Acked-by: David Rientjes <rientjes@google.com>

> I would love to hear some people who are more current on the mm
> subsystem than I am chime in.  It might be that the darn fix is going to
> be to teach __alloc_pages_slowpath to not loop forever, unless order == 0.

It doesn't loop forever, it will either return NULL because of its 
allocation context or the oom killer will kill something, even for order-3 
allocations.  In the case that you've modified, you have sane fallback 
behavior that can be utilized rather than the oom killer and __GFP_NORETRY 
was reasonable from the start.

The question is simple enough: do we want to change 
PAGE_ALLOC_COSTLY_ORDER to be smaller so that order-3 does return NULL 
without oom killing?  Perhaps there's an argument to be made that does 
exactly that, but by not setting __GFP_NORETRY you are really demanding 
order-3 memory at the time you allocate it and are willing to accept the 
consequences to free that memory.  Should we make everything except for 
order-0 inherently __GFP_NORETRY and introduce a replacement __GFP_RETRY?  
That's doable as well, but it would be a massive effort.
