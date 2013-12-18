Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751214Ab3LRUEl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 15:04:41 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:40465 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab3LRUEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 15:04:39 -0500
Date: Wed, 18 Dec 2013 21:04:34 +0100
From: Michal Hocko <mhocko@suse.cz>
To: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org
Subject: Re: [patch 1/2] mm, memcg: avoid oom notification when current needs
 access to memory reserves
Message-ID: <20131218200434.GA4161@dhcp22.suse.cz>
References: <20131209124840.GC3597@dhcp22.suse.cz>
 <alpine.DEB.2.02.1312091328550.11026@chino.kir.corp.google.com>
 <20131210103827.GB20242@dhcp22.suse.cz>
 <alpine.DEB.2.02.1312101655430.22701@chino.kir.corp.google.com>
 <20131211095549.GA18741@dhcp22.suse.cz>
 <alpine.DEB.2.02.1312111434200.7354@chino.kir.corp.google.com>
 <20131212103159.GB2630@dhcp22.suse.cz>
 <alpine.DEB.2.02.1312131551220.28704@chino.kir.corp.google.com>
 <20131217162342.GG28991@dhcp22.suse.cz>
 <alpine.DEB.2.02.1312171240541.21640@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1312171240541.21640@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 17-12-13 12:50:09, David Rientjes wrote:
> On Tue, 17 Dec 2013, Michal Hocko wrote:
> 
> > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > index c72b03bf9679..fee25c5934d2 100644
> > > > --- a/mm/memcontrol.c
> > > > +++ b/mm/memcontrol.c
> > > > @@ -2692,7 +2693,8 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
> > > >  	 * MEMDIE process.
> > > >  	 */
> > > >  	if (unlikely(test_thread_flag(TIF_MEMDIE)
> > > > -		     || fatal_signal_pending(current)))
> > > > +		     || fatal_signal_pending(current))
> > > > +		     || current->flags & PF_EXITING)
> > > >  		goto bypass;
> > > >  
> > > >  	if (unlikely(task_in_memcg_oom(current)))
> > > > 
> > > > rather than the later checks down the oom_synchronize paths. The comment
> > > > already mentions dying process...
> > > > 
> > > 
> > > This is scary because it doesn't even try to reclaim memcg memory before 
> > > allowing the allocation to succeed.
> > 
> > Why should it reclaim in the first place when it simply is on the way to
> > release memory. In other words why should it increase the memory
> > pressure when it is in fact releasing it?
> > 
> 
> (Answering about removing the fatal_signal_pending() check as well here.)
> 
> For memory isolation, we'd only want to bypass memcg charges when 
> absolutely necessary and it seems like TIF_MEMDIE is the only case where 
> that's required.  We don't give processes with pending SIGKILLs or those 
> in the exit() path access to memory reserves in the page allocator without 
> first determining that reclaim can't make any progress for the same reason 
> and then we only do so by setting TIF_MEMDIE when calling the oom killer.  

While I do understand arguments about isolation I would also like to be
practical here. How many charges are we talking about? Dozen pages? Much
more?
Besides that all of those should be very short lived because the task
is going to die very soon and so the memory will be freed.

So from my POV I would like to see these heuristics as simple as
possible and placed at very few places. Doing a bypass before charge
- or even after a failed charge before doing reclaim sounds like an easy
enough heuristic without a big risk.
I have really hard time to see big benefits for forcing reclaim for a
very short lived charge because this might lead to different and much
worse side effects then a quantum noise.

Maybe I am missing something and we can charge a lot during exit but
then I think we should fix the exit path to not allocate that much.

> > I am really puzzled here. On one hand you are strongly arguing for not
> > notifying when we know we can prevent from OOM action and on the other
> > hand you are ok to get vmpressure/thresholds notification when an
> > exiting task triggers reclaim.
> > 
> > So I am really lost in what you are trying to achieve here. It sounds a
> > bit arbirtrary.
> > 
> 
> It's not arbitrary to define when memcg bypass is allowed and, in my 
> opinion, it should only be done in situations where it is unavoidable and 
> therefore breaking memory isolation is required.
> 
> (We wouldn't expect a 128MB memcg to be oom [and perhaps with a userspace 
> oom handler attached] when it has 100 children each 1MB in size just 
> because they all happen to be oom at the same time.  We set up the excess 

s/oom/exiting/ ?

> memory in the parent specifically for the memcg with the oom handler 
> attached.)

I am not sure I understand what you meant here.

-- 
Michal Hocko
SUSE Labs
