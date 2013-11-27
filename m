Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489Ab3K0QjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 11:39:23 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:42394 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338Ab3K0QjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 11:39:21 -0500
Date: Wed, 27 Nov 2013 11:39:16 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: memcg: do not declare OOM from __GFP_NOFAIL
 allocations
Message-ID: <20131127163916.GB3556@cmpxchg.org>
References: <1385140676-5677-1-git-send-email-hannes@cmpxchg.org>
 <alpine.DEB.2.02.1311261658170.21003@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1311261931210.5973@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311261931210.5973@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 07:33:12PM -0800, David Rientjes wrote:
> On Tue, 26 Nov 2013, David Rientjes wrote:
> 
> > On Fri, 22 Nov 2013, Johannes Weiner wrote:
> > 
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index 13b9d0f..cc4f9cb 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -2677,6 +2677,9 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
> > >  	if (unlikely(task_in_memcg_oom(current)))
> > >  		goto bypass;
> > >  
> > > +	if (gfp_mask & __GFP_NOFAIL)
> > > +		oom = false;
> > > +
> > >  	/*
> > >  	 * We always charge the cgroup the mm_struct belongs to.
> > >  	 * The mm_struct's mem_cgroup changes on task migration if the
> > 
> > Sorry, I don't understand this.  What happens in the following scenario:
> > 
> >  - memory.usage_in_bytes == memory.limit_in_bytes,
> > 
> >  - memcg reclaim fails to reclaim memory, and
> > 
> >  - all processes (perhaps only one) attached to the memcg are doing one of
> >    the over dozen __GFP_NOFAIL allocations in the kernel?
> > 
> > How do we make forward progress if you cannot oom kill something?

Bypass the limit.

> Ah, this is because of 3168ecbe1c04 ("mm: memcg: use proper memcg in limit 
> bypass") which just bypasses all of these allocations and charges the root 
> memcg.  So if allocations want to bypass memcg isolation they just have to 
> be __GFP_NOFAIL?

I don't think we have another option.
