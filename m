Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429Ab3FFEK6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 00:10:58 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:58610 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab3FFEKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 00:10:54 -0400
Date: Wed, 5 Jun 2013 21:10:51 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] memcg: do not sleep on OOM waitqueue with full charge
 context
In-Reply-To: <1370488193-4747-2-git-send-email-hannes@cmpxchg.org>
Message-ID: <alpine.DEB.2.02.1306052058340.25115@chino.kir.corp.google.com>
References: <1370488193-4747-1-git-send-email-hannes@cmpxchg.org> <1370488193-4747-2-git-send-email-hannes@cmpxchg.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Jun 2013, Johannes Weiner wrote:

> The memcg OOM handling is incredibly fragile because once a memcg goes
> OOM, one task (kernel or userspace) is responsible for resolving the
> situation.

Not sure what this means.  Are you referring to the case where the memcg 
is disabled from oom killing and we're relying on a userspace handler and 
it may be caught on the waitqueue itself?  Otherwise, are you referring to 
the task as eventually being the only one that takes the hierarchy oom 
lock and calls mem_cgroup_out_of_memory()?  I don't think you can make a 
case for the latter since the one that calls mem_cgroup_out_of_memory() 
should return and call memcg_wakeup_oom().  We obviously don't want to do 
any memory allocations in this path.

> Every other task that gets caught trying to charge memory
> gets stuck in a waitqueue while potentially holding various filesystem
> and mm locks on which the OOM handling task may now deadlock.
> 

What locks?  The oom killer quite extensively needs task_lock() but we 
shouldn't be calling it in the case where we hold this since its a 
spinlock and mem_cgroup_do_charge() never gets to the point of handling 
the oom.

Again, are you referring only to a userspace handler here?

> Do two things:
> 
> 1. When OOMing in a system call (buffered IO and friends), invoke the
>    OOM killer but just return -ENOMEM, never sleep.  Userspace should
>    be able to handle this.
> 

The sleep should never occur for any significant duration currently, the 
current implementation ensures one process calls 
mem_cgroup_out_of_memory() while all others sit on a waitqueue until that 
process returns from the oom killer and then they all wakeup again so the 
killed process may exit and all others can retry their allocations now 
that something has been killed.  If that process hasn't exited yet, the 
next process that locks the memcg oom hierarchy will see the killed 
process with TIF_MEMDIE and the oom killer is deferred.  So this sleep is 
very temporary already, I don't see why you're trying to make it faster 
while another thread finds a candidate task, it works quite well already.

> 2. When OOMing in a page fault and somebody else is handling the
>    situation, do not sleep directly in the charging code.  Instead,
>    remember the OOMing memcg in the task struct and then fully unwind
>    the page fault stack first before going to sleep.
> 

Are you trying to address a situation here where the memcg oom handler 
takes too long to work?  We've quite extensively tried to improve that, 
especially by reducing its dependency on tasklist_lock which is contended 
from the writeside in the exit path and by only iterating processes that 
are attached to that memcg hierarchy and not all processes on the system 
like before.  I don't see the issue with scheduling other oom processes 
while one is doing mem_cgroup_out_of_memory().  (I would if the oom killer 
required things like mm->mmap_sem, but obviously it doesn't for reasons 
not related to memcg.)

> While reworking the OOM routine, also remove a needless OOM waitqueue
> wakeup when invoking the killer.  Only uncharges and limit increases,
> things that actually change the memory situation, should do wakeups.
> 

It's not needless at all, it's vitally required!  The oom killed process 
needs to be removed from the waitqueue and scheduled now with TIF_MEMDIE 
that the memcg oom killer provided so the allocation succeeds in the page 
allocator and memcg bypasses the charge so it can exit.

Exactly what problem are you trying to address with this patch?  I don't 
see any description of the user-visible effects or a specific xample of 
the scenario you're trying to address here.
