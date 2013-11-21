Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496Ab3KUDdH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 22:33:07 -0500
Received: from mail-yh0-f52.google.com ([209.85.213.52]:62885 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab3KUDdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 22:33:04 -0500
Date: Wed, 20 Nov 2013 19:33:00 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: linux-mm@kvack.org, Greg Thelen <gthelen@google.com>,
        Glauber Costa <glommer@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Joern Engel <joern@logfs.org>,
        Hugh Dickins <hughd@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: user defined OOM policies
In-Reply-To: <20131120152251.GA18809@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.02.1311201917520.7167@chino.kir.corp.google.com>
References: <20131119131400.GC20655@dhcp22.suse.cz> <20131119134007.GD20655@dhcp22.suse.cz> <alpine.DEB.2.02.1311192352070.20752@chino.kir.corp.google.com> <20131120152251.GA18809@dhcp22.suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Nov 2013, Michal Hocko wrote:

> > Not sure it's hard if you have per-memcg memory reserves which I've 
> > brought up in the past with true and complete kmem accounting.  Even if 
> > you don't allocate slab, it guarantees that there will be at least a 
> > little excess memory available so that the userspace oom handler isn't oom 
> > itself.
> > This involves treating processes waiting on memory.oom_control to be 
> > treated as a special class
> 
> How do you identify such a process?
> 

Unless there's a better suggestion, the registration is done in process 
context and we can add a list_head to struct task_struct to identify this 
special class.  While memcg->under_oom, prevent this class of processes 
from moving to other memcgs with -EBUSY.  I'm thinking the "precharge" 
allocation would be done with a separate rescounter but still accounted 
for in RES_USAGE, i.e. when the first process registers for 
memory.oom_control, charge memory.oom_precharge_in_bytes to RES_USAGE and 
then on bypass account toward the new rescounter.  This would be the 
cleanest interface to do it, I believe, so the memcg assumes the cost of 
the memory reserves up front, which would default to 0 and require the 
owner to configure a memory.oom_precharge_in_bytes for such a reserve to 
be used (I think we'd use a value of 2MB).

> > Why would there be a hang if the userspace oom handlers aren't actually 
> > oom themselves as described above?
> 
> Because all the reserves might be depleted.
> 

It requires a high enough memory.oom_precharge_in_bytes and anything that 
registers for notification would presumably add in what they require (we'd 
probably only have one such oom handler per memcg).  In the worst case, 
memory.oom_delay_millisecs eventually solves the situation for us because 
of the misconfigured userspace.

The root memcg remains under the control of root and a system oom handler 
would need PF_MEMALLOC to allocate into reserves up to a sane limit (and 
we can cap the root memcg's precharge to something like 1/16 of 
reserves?).

> > I'd suggest against the other two suggestions because hierarchical 
> > per-memcg userspace oom handlers are very powerful and can be useful 
> > without actually killing anything at all, and parent oom handlers can 
> > signal child oom handlers to free memory in oom conditions (in other 
> > words, defer a parent oom condition to a child's oom handler upon 
> > notification). 
> 
> OK, but what about those who are not using memcg and need a similar
> functionality? Are there any, btw?
> 

We needed it for cpusets before we migrated to memcg, are you concerned 
about the overhead of CONFIG_MEMCG?  Otherwise, just enable it and use it 
in parallel with cpusets or only the entire system if you aren't even 
using memcg.

I don't know of anybody else who has these requirements, but Google 
requires the callbacks to userspace to our malloc() implementation to free 
unneeded arena memory and to enforce memcg priority based scoring 
selection.

> > I was planning on writing a liboom library that would lay 
> > the foundation for how this was supposed to work and some generic 
> > functions that make use of the per-memcg memory reserves.
> >
> > So my plan for the complete solution was:
> > 
> >  - allow userspace notification from the root memcg on system oom 
> >    conditions,
> > 
> >  - implement a memory.oom_delay_millisecs timeout so that the kernel 
> >    eventually intervenes if userspace fails to respond, including for
> >    system oom conditions, for whatever reason which would be set to 0
> >    if no userspace oom handler is registered for the notification, and
> 
> One thing I really dislike about timeout is that there is no easy way to
> find out which value is safe.

We tend to use the high side of what we expect, we've been using 10s for 
four or five years now back to when we used cpusets.

> It might be easier for well controlled
> environments where you know what the load is and how it behaves. How an
> ordinary user knows which number to put there without risking a race
> where the userspace just doesn't respond in time?
> 

It's always high, we use it only as a last resort.  For userspace oom 
handlers that only want to do heap analysis or logging, for example, they 
can set it to 10s, do what they need, then write 0 to immediately defer to 
the kernel.  10s should certainly be adequate for any sane userspace oom 
handler.

> >  - implement per-memcg reserves as described above so that userspace oom 
> >    handlers have access to memory even in oom conditions as an upfront
> >    charge and have the ability to free memory as necessary.
> 
> This has a similar issue as above. How to estimate the size of the
> reserve? How to make such a reserve stable over different kernel
> versions where the same query might consume more memory.
> 

Again, we tend to go on the high side and I'd recommend something like 2MB 
at the most.  A userspace oom handler will only want to do basic 
functionality anyway like dumping heaps to a file, reading the "tasks" 
file, grabbing rss values, etc.  Keep in mind that the oom precharge is 
only what is allowed to be allocated at oom time, everything else can be 
mlocked into memory and already charged to the memcg before it registers 
for memory.oom_control.

> > We already have the ability to do the actual kill from userspace, both the 
> > system oom killer and the memcg oom killer grants access to memory 
> > reserves for any process needing to allocate memory if it has a pending 
> > SIGKILL which we can send from userspace.
> 
> Yes, the killing part is not a problem the selection is the hard one.
> 

Agreed, and I think the big downside of doing it with the loadable module 
suggestion is that you can't implement such a wide variety of different 
policies in modules.  Each of our users who own a memcg tree on our 
systems may want to have their own policy and they can't load a module at 
runtime or ship with the kernel.
