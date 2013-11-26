Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab3KZB3a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 20:29:30 -0500
Received: from mail-yh0-f51.google.com ([209.85.213.51]:47631 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023Ab3KZB3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 20:29:23 -0500
Date: Mon, 25 Nov 2013 17:29:20 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Luigi Semenzato <semenzato@google.com>
cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        Greg Thelen <gthelen@google.com>, Glauber Costa <glommer@gmail.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Joern Engel <joern@logfs.org>,
        Hugh Dickins <hughd@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: user defined OOM policies
In-Reply-To: <CAA25o9Q64eK5LHhrRyVn73kFz=Z7Jji=rYWS=9jWL_4y9ZGbQA@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1311251717370.27270@chino.kir.corp.google.com>
References: <20131119131400.GC20655@dhcp22.suse.cz> <20131119134007.GD20655@dhcp22.suse.cz> <alpine.DEB.2.02.1311192352070.20752@chino.kir.corp.google.com> <20131120152251.GA18809@dhcp22.suse.cz> <CAA25o9S5EQBvyk=HP3obdCaXKjoUVtzeb4QsNmoLMq6NnOYifA@mail.gmail.com>
 <alpine.DEB.2.02.1311201933420.7167@chino.kir.corp.google.com> <CAA25o9Q64eK5LHhrRyVn73kFz=Z7Jji=rYWS=9jWL_4y9ZGbQA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Nov 2013, Luigi Semenzato wrote:

> Yes, I agree that we can't always prevent OOM situations, and in fact
> we tolerate OOM kills, although they have a worse impact on the users
> than controlled freeing does.
> 

If the controlled freeing is able to actually free memory in time before 
hitting an oom condition, it should work pretty well.  That ability is 
seems to be highly dependent on sane thresholds for indvidual applications 
and I'm afraid we can never positively ensure that we wakeup and are able 
to free memory in time to avoid the oom condition.

> Well OK here it goes.  I hate to be a party-pooper, but the notion of
> a user-level OOM-handler scares me a bit for various reasons.
> 
> 1. Our custom notifier sends low-memory warnings well ahead of memory
> depletion.  If we don't have enough time to free memory then, what can
> the last-minute OOM handler do?
> 

The userspace oom handler doesn't necessarily guarantee that you can do 
memory freeing, our usecase wants to do a priority-based oom killing that 
is different from the kernel oom killer based on rss.  To do that, you 
only really need to read certain proc files and you can do killing based 
on uptime, for example.  You can also do a hierarchical traversal of 
memcgs based on a priority.

We already have hooks in the kernel oom killer, things like 
/proc/sys/vm/oom_kill_allocating_task and /proc/sys/vm/panic_on_oom that 
implement different policies that could now trivially be done in userspace 
with memory reserves and a timeout.  The point is that we can't possibly 
encode every possible policy into the kernel and there's no reason why 
userspace can't do the kill itself.

> 2. In addition to the time factor, it's not trivial to do anything,
> including freeing memory, without allocating memory first, so we'll
> need a reserve, but how much, and who is allowed to use it?
> 

The reserve is configurable in the proposal as a memcg precharge and would 
be dependent on the memory needed by the userspace oom handler at wakeup.  
Only processes that are waiting on memory.oom_control have access to the 
memory reserve.

> 3. How does one select the OOM-handler timeout?  If the freeing paths
> in the code are swapped out, the time needed to bring them in can be
> highly variable.
> 

The userspace oom handler itself is mlocked in memory, you'd want to 
select a timeout that is large enough to only react in situations where 
userspace is known to be unresponsive; it's only meant as a failsafe to 
avoid the memcg sitting around forever not making any forward progress.

> 4. Why wouldn't the OOM-handler also do the killing itself?  (Which is
> essentially what we do.)  Then all we need is a low-memory notifier
> which can predict how quickly we'll run out of memory.
> 

It can, but the prediction of how quickly we'll run out of memory is 
nearly impossible for every class of application and the timeout is 
required before the kernel steps in to solve the situation.

> 5. The use case mentioned earlier (the fact that the killing of one
> process can make an entire group of processes useless) can be dealt
> with using OOM priorities and user-level code.
> 

It depends on the application being killed.

> I confess I am surprised that the OOM killer works as well as I think
> it does.  Adding a user-level component would bring a whole new level
> of complexity to code that's already hard to fully comprehend, and
> might not really address the fundamental issues.
> 

The kernel code that would be added certainly isn't complex and I believe 
it is better than the current functionality that only allows you to 
disable the memcg oom killer entirely to effect any userspace policy.
