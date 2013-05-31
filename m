Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200Ab3EaT30 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 15:29:26 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:33792 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab3EaT3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 15:29:20 -0400
Date: Fri, 31 May 2013 12:29:17 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org
Subject: Re: [patch] mm, memcg: add oom killer delay
In-Reply-To: <20130531112116.GC32491@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.02.1305311224330.3434@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1305291817280.520@chino.kir.corp.google.com> <20130530150539.GA18155@dhcp22.suse.cz> <alpine.DEB.2.02.1305301338430.20389@chino.kir.corp.google.com> <20130531081052.GA32491@dhcp22.suse.cz> <alpine.DEB.2.02.1305310316210.27716@chino.kir.corp.google.com>
 <20130531112116.GC32491@dhcp22.suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 May 2013, Michal Hocko wrote:

> > We allow users to control their own memcgs by chowning them, so they must 
> > be run in the same hierarchy if they want to run their own userspace oom 
> > handler.  There's nothing in the kernel that prevents that and the user 
> > has no other option but to run in a parent cgroup.
> 
> If the access to the oom_control file is controlled by the file
> permissions then the oom handler can live inside root cgroup. Why do you
> need "must be in the same hierarchy" requirement?
> 

Users obviously don't have the ability to attach processes to the root 
memcg.  They are constrained to their own subtree of memcgs.

> > It's too easy to simply do even a "ps ax" in an oom memcg and make that 
> > thread completely unresponsive because it allocates memory.
> 
> Yes, but we are talking about oom handler and that one has to be really
> careful about what it does. So doing something that simply allocates is
> dangerous.
> 

Show me a userspace oom handler that doesn't get notified of every fork() 
in a memcg, causing a performance degradation of its own for a complete 
and utter slowpath, that will know the entire process tree of its own 
memcg or a child memcg.

This discussion is all fine and good from a theoretical point of view 
until you actually have to implement one of these yourself.  Multiple 
users are going to be running their own oom notifiers and without some 
sort of failsafe, such as memory.oom_delay_millisecs, a memcg can too 
easily deadlock looking for memory.  If that user is constrained to his or 
her own subtree, as previously stated, there's also no way to login and 
rectify the situation at that point and requires admin intervention or a 
reboot.

> > Then perhaps I'm raising constraints that you've never worked with, I 
> > don't know.  We choose to have a priority-based approach that is inherited 
> > by children; this priority is kept in userspace and and the oom handler 
> > would naturally need to know the set of tasks in the oom memcg at the time 
> > of oom and their parent-child relationship.  These priorities are 
> > completely independent of memory usage.
> 
> OK, but both reading tasks file and readdir should be doable without
> userspace (aka charged) allocations. Moreover if you run those oom
> handlers under the root cgroup then it should be even easier.

Then why does "cat tasks" stall when my memcg is totally depleted of all 
memory?

This isn't even the argument because memory.oom_delay_millisecs isn't 
going to help that situation.  I'm talking about a failsafe that ensures a 
memcg can't deadlock.  The global oom killer will always have to exist in 
the kernel, at least in the most simplistic of forms, solely for this 
reason; you can't move all of the logic to userspace and expect it to 
react 100% of the time.
