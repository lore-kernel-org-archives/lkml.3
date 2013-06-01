Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab3FAKVJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 06:21:09 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:56836 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab3FAKVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 06:21:04 -0400
Date: Sat, 1 Jun 2013 12:20:58 +0200
From: Michal Hocko <mhocko@suse.cz>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org
Subject: Re: [patch] mm, memcg: add oom killer delay
Message-ID: <20130601102058.GA19474@dhcp22.suse.cz>
References: <alpine.DEB.2.02.1305291817280.520@chino.kir.corp.google.com>
 <20130530150539.GA18155@dhcp22.suse.cz>
 <alpine.DEB.2.02.1305301338430.20389@chino.kir.corp.google.com>
 <20130531081052.GA32491@dhcp22.suse.cz>
 <alpine.DEB.2.02.1305310316210.27716@chino.kir.corp.google.com>
 <20130531112116.GC32491@dhcp22.suse.cz>
 <alpine.DEB.2.02.1305311224330.3434@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1305311224330.3434@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 31-05-13 12:29:17, David Rientjes wrote:
> On Fri, 31 May 2013, Michal Hocko wrote:
> 
> > > We allow users to control their own memcgs by chowning them, so they must 
> > > be run in the same hierarchy if they want to run their own userspace oom 
> > > handler.  There's nothing in the kernel that prevents that and the user 
> > > has no other option but to run in a parent cgroup.
> > 
> > If the access to the oom_control file is controlled by the file
> > permissions then the oom handler can live inside root cgroup. Why do you
> > need "must be in the same hierarchy" requirement?
> > 
> 
> Users obviously don't have the ability to attach processes to the root 
> memcg.  They are constrained to their own subtree of memcgs.

OK, I assume those groups are generally untrusted, right? So you cannot
let them register their oom handler even via an admin interface. This
makes it a bit complicated because it makes much harder demands on the
handler itself as it has to run under restricted environment.

> > > It's too easy to simply do even a "ps ax" in an oom memcg and make that 
> > > thread completely unresponsive because it allocates memory.
> > 
> > Yes, but we are talking about oom handler and that one has to be really
> > careful about what it does. So doing something that simply allocates is
> > dangerous.
> > 
> 
> Show me a userspace oom handler that doesn't get notified of every fork() 
> in a memcg, causing a performance degradation of its own for a complete 
> and utter slowpath, that will know the entire process tree of its own 
> memcg or a child memcg.

I still do not see why you cannot simply read tasks file into a
preallocated buffer. This would be few pages even for thousands of pids.
You do not have to track processes as they come and go.

> This discussion is all fine and good from a theoretical point of view 
> until you actually have to implement one of these yourself.  Multiple 
> users are going to be running their own oom notifiers and without some 
> sort of failsafe, such as memory.oom_delay_millisecs, a memcg can too 
> easily deadlock looking for memory.

As I said before. oom_delay_millisecs is actually really easy to be done
from userspace. If you really need a safety break then you can register
such a handler as a fallback. I am not familiar with eventfd internals
much but I guess that multiple handlers are possible. The fallback might
be enforeced by the admin (when a new group is created) or by the
container itself. Would something like this work for your use case?

> If that user is constrained to his or her own subtree, as previously
> stated, there's also no way to login and rectify the situation at that
> point and requires admin intervention or a reboot.

Yes, insisting on the same subtree makes the life much harder for oom
handlers. I totally agree with you on that. I just feel that introducing
a new knob to workaround user "inability" to write a proper handler
(what ever that means) is not justified.
 
> > > Then perhaps I'm raising constraints that you've never worked with, I 
> > > don't know.  We choose to have a priority-based approach that is inherited 
> > > by children; this priority is kept in userspace and and the oom handler 
> > > would naturally need to know the set of tasks in the oom memcg at the time 
> > > of oom and their parent-child relationship.  These priorities are 
> > > completely independent of memory usage.
> > 
> > OK, but both reading tasks file and readdir should be doable without
> > userspace (aka charged) allocations. Moreover if you run those oom
> > handlers under the root cgroup then it should be even easier.
> 
> Then why does "cat tasks" stall when my memcg is totally depleted of all 
> memory?

if you run it like this then cat obviously needs some charged
allocations. If you had a proper handler which mlocks its buffer for the
read syscall then you shouldn't require any allocation at the oom time.
This shouldn't be that hard to do without too much memory overhead. As I
said we are talking about few (dozens) of pages per handler.

> This isn't even the argument because memory.oom_delay_millisecs isn't 
> going to help that situation.  I'm talking about a failsafe that ensures a 
> memcg can't deadlock.  The global oom killer will always have to exist in 
> the kernel, at least in the most simplistic of forms, solely for this 
> reason; you can't move all of the logic to userspace and expect it to 
> react 100% of the time.

The global case is even more complicated because every allocation
matters - not just those that are charged as for memcg case. Btw. at
last LSF there was a discussion about enabling oom_control for the root
cgroup but this is off-topic here and should be discussed separately
when somebody actually tries to implement this.
-- 
Michal Hocko
SUSE Labs
