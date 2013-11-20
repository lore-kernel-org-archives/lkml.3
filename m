Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab3KTPW4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 10:22:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59051 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060Ab3KTPWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 10:22:54 -0500
Date: Wed, 20 Nov 2013 16:22:51 +0100
From: Michal Hocko <mhocko@suse.cz>
To: David Rientjes <rientjes@google.com>
Cc: linux-mm@kvack.org, Greg Thelen <gthelen@google.com>,
        Glauber Costa <glommer@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Joern Engel <joern@logfs.org>,
        Hugh Dickins <hughd@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: user defined OOM policies
Message-ID: <20131120152251.GA18809@dhcp22.suse.cz>
References: <20131119131400.GC20655@dhcp22.suse.cz>
 <20131119134007.GD20655@dhcp22.suse.cz>
 <alpine.DEB.2.02.1311192352070.20752@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311192352070.20752@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 20-11-13 00:02:20, David Rientjes wrote:
> On Tue, 19 Nov 2013, Michal Hocko wrote:
> 
> > > We have basically ended up with 3 options AFAIR:
> > > 	1) allow memcg approach (memcg.oom_control) on the root level
> > >            for both OOM notification and blocking OOM killer and handle
> > >            the situation from the userspace same as we can for other
> > > 	   memcgs.
> > 
> > This looks like a straightforward approach as the similar thing is done
> > on the local (memcg) level. There are several problems though.
> > Running userspace from within OOM context is terribly hard to do
> > right.
> 
> Not sure it's hard if you have per-memcg memory reserves which I've 
> brought up in the past with true and complete kmem accounting.  Even if 
> you don't allocate slab, it guarantees that there will be at least a 
> little excess memory available so that the userspace oom handler isn't oom 
> itself.
> This involves treating processes waiting on memory.oom_control to be 
> treated as a special class

How do you identify such a process?

> so that they are allowed to allocate an 
> additional pre-configured amount of memory.  For non-root memcgs, this 
> would simply be a dummy usage that would be charged to the memcg when the 
> oom notification is registered and actually accessible only by the oom 
> handler itself while memcg->under_oom.  For root memcgs, this would simply 
> be a PF_MEMALLOC type behavior that dips into per-zone memory reserves.
> 
> > This is true even in the memcg case and we strongly discurage
> > users from doing that. The global case has nothing like outside of OOM
> > context though. So any hang would blocking the whole machine.
> 
> Why would there be a hang if the userspace oom handlers aren't actually 
> oom themselves as described above?

Because all the reserves might be depleted.

> I'd suggest against the other two suggestions because hierarchical 
> per-memcg userspace oom handlers are very powerful and can be useful 
> without actually killing anything at all, and parent oom handlers can 
> signal child oom handlers to free memory in oom conditions (in other 
> words, defer a parent oom condition to a child's oom handler upon 
> notification). 

OK, but what about those who are not using memcg and need a similar
functionality? Are there any, btw?

> I was planning on writing a liboom library that would lay 
> the foundation for how this was supposed to work and some generic 
> functions that make use of the per-memcg memory reserves.
>
> So my plan for the complete solution was:
> 
>  - allow userspace notification from the root memcg on system oom 
>    conditions,
> 
>  - implement a memory.oom_delay_millisecs timeout so that the kernel 
>    eventually intervenes if userspace fails to respond, including for
>    system oom conditions, for whatever reason which would be set to 0
>    if no userspace oom handler is registered for the notification, and

One thing I really dislike about timeout is that there is no easy way to
find out which value is safe. It might be easier for well controlled
environments where you know what the load is and how it behaves. How an
ordinary user knows which number to put there without risking a race
where the userspace just doesn't respond in time?

>  - implement per-memcg reserves as described above so that userspace oom 
>    handlers have access to memory even in oom conditions as an upfront
>    charge and have the ability to free memory as necessary.

This has a similar issue as above. How to estimate the size of the
reserve? How to make such a reserve stable over different kernel
versions where the same query might consume more memory.

As I've said in my previous email. The reserves can help but it is still
easy to do wrong and looks rather fragile for general purposes.

> We already have the ability to do the actual kill from userspace, both the 
> system oom killer and the memcg oom killer grants access to memory 
> reserves for any process needing to allocate memory if it has a pending 
> SIGKILL which we can send from userspace.

Yes, the killing part is not a problem the selection is the hard one.

-- 
Michal Hocko
SUSE Labs
