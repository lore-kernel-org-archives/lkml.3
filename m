Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219Ab3K0Wxw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 17:53:52 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:42494 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758183Ab3K0Wxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 17:53:46 -0500
Date: Wed, 27 Nov 2013 17:53:40 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: memcg: do not declare OOM from __GFP_NOFAIL
 allocations
Message-ID: <20131127225340.GE3556@cmpxchg.org>
References: <1385140676-5677-1-git-send-email-hannes@cmpxchg.org>
 <alpine.DEB.2.02.1311261658170.21003@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1311261931210.5973@chino.kir.corp.google.com>
 <20131127163916.GB3556@cmpxchg.org>
 <alpine.DEB.2.02.1311271336220.9222@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311271336220.9222@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 01:38:59PM -0800, David Rientjes wrote:
> On Wed, 27 Nov 2013, Johannes Weiner wrote:
> 
> > > Ah, this is because of 3168ecbe1c04 ("mm: memcg: use proper memcg in limit 
> > > bypass") which just bypasses all of these allocations and charges the root 
> > > memcg.  So if allocations want to bypass memcg isolation they just have to 
> > > be __GFP_NOFAIL?
> > 
> > I don't think we have another option.
> > 
> 
> We don't give __GFP_NOFAIL allocations access to memory reserves in the 
> page allocator and we do call the oom killer for them so that a process is 
> killed so that memory is freed.  Why do we have a different policy for 
> memcg?

Oh boy, that's the epic story we dealt with all throughout the last
merge window... ;-)

__GFP_NOFAIL allocations might come in with various filesystem locks
held that could prevent an OOM victim from exiting, so a loop around
the OOM killer in an allocation context is prone to loop endlessly.

Because of this, I changed memcg to never invoke OOM kills from the
allocation context anymore but save it for the end of the page fault
handler.  __GFP_NOFAIL allocations can not fail and thus do not reach
the end of the page fault, so no OOM kill invocation possible.

Arguably, the page allocator should also just return NULL and leave
OOM killing to pagefault_out_of_memory(), but it's much less likely to
get stuck since the overall system has more chances of producing free
memory even without an OOM kill than a memcg with a single process and
no swap for example.
