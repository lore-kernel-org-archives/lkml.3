Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770Ab3LSGJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 01:09:18 -0500
Received: from mail-gg0-f172.google.com ([209.85.161.172]:37380 "EHLO
	mail-gg0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab3LSGJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 01:09:16 -0500
Date: Wed, 18 Dec 2013 22:09:12 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org
Subject: Re: [patch 1/2] mm, memcg: avoid oom notification when current needs
 access to memory reserves
In-Reply-To: <20131218200434.GA4161@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.02.1312182157510.1247@chino.kir.corp.google.com>
References: <20131209124840.GC3597@dhcp22.suse.cz> <alpine.DEB.2.02.1312091328550.11026@chino.kir.corp.google.com> <20131210103827.GB20242@dhcp22.suse.cz> <alpine.DEB.2.02.1312101655430.22701@chino.kir.corp.google.com> <20131211095549.GA18741@dhcp22.suse.cz>
 <alpine.DEB.2.02.1312111434200.7354@chino.kir.corp.google.com> <20131212103159.GB2630@dhcp22.suse.cz> <alpine.DEB.2.02.1312131551220.28704@chino.kir.corp.google.com> <20131217162342.GG28991@dhcp22.suse.cz> <alpine.DEB.2.02.1312171240541.21640@chino.kir.corp.google.com>
 <20131218200434.GA4161@dhcp22.suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Dec 2013, Michal Hocko wrote:

> > For memory isolation, we'd only want to bypass memcg charges when 
> > absolutely necessary and it seems like TIF_MEMDIE is the only case where 
> > that's required.  We don't give processes with pending SIGKILLs or those 
> > in the exit() path access to memory reserves in the page allocator without 
> > first determining that reclaim can't make any progress for the same reason 
> > and then we only do so by setting TIF_MEMDIE when calling the oom killer.  
> 
> While I do understand arguments about isolation I would also like to be
> practical here. How many charges are we talking about? Dozen pages? Much
> more?

The PF_EXITING bypass is indeed much less concerning than the 
fatal_signal_pending() bypass.

> Besides that all of those should be very short lived because the task
> is going to die very soon and so the memory will be freed.
> 

We don't know how much memory is being allocated while 
fatal_signal_pending() is true before the process can handle the SIGKILL, 
so this could potentially bypass a significant amount of memory.  If we 
are to have a configuration such as what Tejun recommended for oom 
handling:

			 _____root______
			/		\
		    user		 oom
		   /    \		/   \
		  A	 B	       a     b

where the limit of A + B can be greater than the limit of user for 
overcommit, and the limit of user is the amount of RAM minus whatever is 
reserved for the oom hierarchy, then significant bypass to the root memcg 
will cause memcgs in the oom hierarchy to actually not be able to allocate 
memory from the page allocator.

The PF_EXITING bypass is much less concerning because we shouldn't be 
doing significant memory allocation in the exit() path, but it's also true 
that neither the PF_EXITING nor the fatal_signal_pending() bypass is 
required.  In Tejun's suggested configuration above, we absolutely do want 
to reclaim from the user hierarchy before declaring oom and setting 
TIF_MEMDIE, otherwise the oom hierarchy cannot allocate.

> So from my POV I would like to see these heuristics as simple as
> possible and placed at very few places. Doing a bypass before charge
> - or even after a failed charge before doing reclaim sounds like an easy
> enough heuristic without a big risk.

It's a very significant risk of depleting memory that is available for oom 
handling in the suggested configuration.
