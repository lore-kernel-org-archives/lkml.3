Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab3K0DdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 22:33:19 -0500
Received: from mail-yh0-f43.google.com ([209.85.213.43]:47963 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab3K0DdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 22:33:16 -0500
Date: Tue, 26 Nov 2013 19:33:12 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: memcg: do not declare OOM from __GFP_NOFAIL
 allocations
In-Reply-To: <alpine.DEB.2.02.1311261658170.21003@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1311261931210.5973@chino.kir.corp.google.com>
References: <1385140676-5677-1-git-send-email-hannes@cmpxchg.org> <alpine.DEB.2.02.1311261658170.21003@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Nov 2013, David Rientjes wrote:

> On Fri, 22 Nov 2013, Johannes Weiner wrote:
> 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 13b9d0f..cc4f9cb 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2677,6 +2677,9 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
> >  	if (unlikely(task_in_memcg_oom(current)))
> >  		goto bypass;
> >  
> > +	if (gfp_mask & __GFP_NOFAIL)
> > +		oom = false;
> > +
> >  	/*
> >  	 * We always charge the cgroup the mm_struct belongs to.
> >  	 * The mm_struct's mem_cgroup changes on task migration if the
> 
> Sorry, I don't understand this.  What happens in the following scenario:
> 
>  - memory.usage_in_bytes == memory.limit_in_bytes,
> 
>  - memcg reclaim fails to reclaim memory, and
> 
>  - all processes (perhaps only one) attached to the memcg are doing one of
>    the over dozen __GFP_NOFAIL allocations in the kernel?
> 
> How do we make forward progress if you cannot oom kill something?
> 

Ah, this is because of 3168ecbe1c04 ("mm: memcg: use proper memcg in limit 
bypass") which just bypasses all of these allocations and charges the root 
memcg.  So if allocations want to bypass memcg isolation they just have to 
be __GFP_NOFAIL?
