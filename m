Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636Ab3KVNSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 08:18:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41998 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132Ab3KVNSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 08:18:35 -0500
Date: Fri, 22 Nov 2013 14:18:32 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Vladimir Murzin <murzin.v@gmail.com>
Cc: linux-mm@kvack.org, Greg Thelen <gthelen@google.com>,
        Glauber Costa <glommer@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
        Joern Engel <joern@logfs.org>, Hugh Dickins <hughd@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: user defined OOM policies
Message-ID: <20131122131832.GD25406@dhcp22.suse.cz>
References: <20131119131400.GC20655@dhcp22.suse.cz>
 <20131119134007.GD20655@dhcp22.suse.cz>
 <20131120172119.GA1848@hp530>
 <20131120173357.GC18809@dhcp22.suse.cz>
 <20131122072758.GA1853@hp530>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131122072758.GA1853@hp530>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 22-11-13 08:28:03, Vladimir Murzin wrote:
> On Wed, Nov 20, 2013 at 06:33:57PM +0100, Michal Hocko wrote: > On Wed
> 20-11-13 18:21:23, Vladimir Murzin wrote: > > On Tue, Nov 19, 2013 at
> 02:40:07PM +0100, Michal Hocko wrote: > > Hi Michal > > > On Tue 19-11-13
> 14:14:00, Michal Hocko wrote:
> > > > [...]
> > > > > We have basically ended up with 3 options AFAIR:
> > > > > 	1) allow memcg approach (memcg.oom_control) on the root level
> > > > >            for both OOM notification and blocking OOM killer and handle
> > > > >            the situation from the userspace same as we can for other
> > > > > 	   memcgs.
> > > > 
> > > > This looks like a straightforward approach as the similar thing is done
> > > > on the local (memcg) level. There are several problems though.
> > > > Running userspace from within OOM context is terribly hard to do
> > > > right. This is true even in the memcg case and we strongly discurage
> > > > users from doing that. The global case has nothing like outside of OOM
> > > > context though. So any hang would blocking the whole machine. Even
> > > > if the oom killer is careful and locks in all the resources it would
> > > > have hard time to query the current system state (existing processes
> > > > and their states) without any allocation.  There are certain ways to
> > > > workaround these issues - e.g. give the killer access to memory reserves
> > > > - but this all looks scary and fragile.
> > > > 
> > > > > 	2) allow modules to hook into OOM killer path and take the
> > > > > 	   appropriate action.
> > > > 
> > > > This already exists actually. There is oom_notify_list callchain and
> > > > {un}register_oom_notifier that allow modules to hook into oom and
> > > > skip the global OOM if some memory is freed. There are currently only
> > > > s390 and powerpc which seem to abuse it for something that looks like a
> > > > shrinker except it is done in OOM path...
> > > > 
> > > > I think the interface should be changed if something like this would be
> > > > used in practice. There is a lot of information lost on the way. I would
> > > > basically expect to get everything that out_of_memory gets.
> > > 
> > > Some time ago I was trying to hook OOM with custom module based policy. I
> > > needed to select process based on uss/pss values which required page walking
> > > (yes, I know it is extremely expensive, but sometimes I'd pay the bill). The
> > > learned lesson is quite simple - it is harmful to expose (all?) internal
> > > functions and locking into modules - the result is going to be completely
> > > unreliable and non predictable mess, unless the well defined interface and
> > > helpers will be established. 
> > 
> > OK, I was a bit vague it seems. I meant to give zonelist, gfp_mask,
> > allocation order and nodemask parameters to the modules. So they have a
> > better picture of what is the OOM context.
> 
> I think it make sense if we suppose modules are able to postpone task killing
> by freeing memory or like that.

That is not the primary motivation behind modules. They should define
policy. E.g. reboot on the OOM condition. Or kill everything but one
process that really matters. Or what-ever that sounds too much specific
to be implemented in the core oom killer we have now. Or just notify
userspace and let it do the job.

> However, it seems to we come back to the shrinker interface.

No that is what the notifiers are used now and that is wrong. Shrinkers
should be part of the reclaim and they already have an interface for
that.

> If we suppose that OOM is about task killing it is not
> clear for me how information about gfp mask and order can be used here
> efficiently. I'd be grateful if you elaborate more about that.

Look at what the current oom killer use them for (minimally to dump
information about allocation that led to the OOM). Modules should have
the same possibilities the current implementation has. Or is there any
reason to not do so?

> I definitely missed something, and I'm curious what OOM policy means here?

It defines an appropriate measure against OOM situations. That might
be killing the most memory consuming task, killing everything but the
set of important tasks, notify userspace and wait for an action, kill a
group of processes, reboot the machine and many others some of them very
workload specific.

> 1) calculation of the metric for the victim, like oom_badness, so we can input
> some info and make judgment based on the output.
>
> 2) selecting the victim process, like select_bad_process, so we can just query
> module and than kill the victim selected by the module.
> 
> 3) completely delegate OOM handling to the module, not matter how it will free
> the memory.

That was one of the suggestions. Other two are trivially implementable
by reusing the code we already have in the kernel and replacing the two
functions by something custom.

> 4) other?

Yes other methods, like the memcg based on or rules filter approach
(what ever that means). Plus any other ideas are welcome.

-- 
Michal Hocko
SUSE Labs
