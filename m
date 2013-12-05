Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932718Ab3LEAXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 19:23:50 -0500
Received: from mail-yh0-f41.google.com ([209.85.213.41]:45877 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756097Ab3LEAXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 19:23:46 -0500
Date: Wed, 4 Dec 2013 16:23:41 -0800 (PST)
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
In-Reply-To: <20131204111318.GE8410@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.02.1312041606260.6329@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1311141525440.30112@chino.kir.corp.google.com> <20131118154115.GA3556@cmpxchg.org> <20131118165110.GE32623@dhcp22.suse.cz> <20131122165100.GN3556@cmpxchg.org> <alpine.DEB.2.02.1311261648570.21003@chino.kir.corp.google.com>
 <20131127163435.GA3556@cmpxchg.org> <20131202200221.GC5524@dhcp22.suse.cz> <20131202212500.GN22729@cmpxchg.org> <20131203120454.GA12758@dhcp22.suse.cz> <alpine.DEB.2.02.1312031544530.5946@chino.kir.corp.google.com> <20131204111318.GE8410@dhcp22.suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Dec 2013, Michal Hocko wrote:

> > I'll repeat: Section 10 of Documentation/cgroups/memory.txt specifies what 
> > userspace should do when waking up; one of those options is not "check if 
> > the memcg is still actually oom in a short period of time once a charging 
> > task with a pending SIGKILL or in the exit path has been able to exit."
> > Users of this interface typically also disable the memcg oom killer 
> > through the same file, it's ludicrous to put the responsibility on 
> > userspace to determine if the wakeup is actionable and requires it to 
> > intervene in one of the methods listed in section 10.
> 
> David, you would need to show us that such a condition happens in real
> loads often enough that such a tweak is worth it. Repeating that a race
> exists doesn't help, because yeah it does and it will after your patch
> as well. So show us that it happens considerably less often with this
> check.
>  

Google depends on getting memory.oom_control notifications only when they 
are actionable, which is exactly how Documentation/cgroups/memory.txt 
describes how userspace should respond to such a notification.

"Actionable" here means that the kernel has exhausted its capabilities of 
allowing for future memory freeing, which is the entire premise of any oom 
killer.

Giving a dying process or a process that is going to subsequently die 
access to memory reserves is a capability the kernel users to ensure 
progress is made in oom conditions.  It is not an exhaustion of 
capabilities.

Yes, we all know that subsequent to the userspace notification that memory 
may be freed and the kill no longer becomes required.  There is nothing 
that can be done about that, and it has never been implied that a memcg is 
guaranteed to still be oom when the process wakes up.

I'm referring to a siutation that can manifest in a number of ways: 
coincidental process exit, coincidental process being killed, 
VMPRESSURE_CRITICAL notification that results in a process being killed, 
or memory threshold notification that results in a process being killed.  
Regardless, we're talking about a situation where something is already 
in the exit path or has been killed and is simply attempting to free its 
memory.

Such a process simply needs access to memory reserves to make progress and 
free its memory as part of the exit path.  The process waiting on 
memory.oom_control does _not_ need to do any of the actions mentioned in 
Documentation/cgroups/memory.txt: reduce usage, enlarge the limit, kill a 
process, or move a process with charge migration.

It would be ridiculous to require anybody implementing such a process to 
check if the oom condition still exists after a period of time before 
taking such an action.  It would be required to wait for any possible 
dying task or process with a pending SIGKILL to exit and there's no way to 
determine how long is long enough to wait or that it will get woken up 
again if it relies on a second signal for the same oom condition.  At the 
same time, the action taken by such a process would still be as racy as it 
would with the patch: we simply can't guarantee memory is not freed 
immediately after we issue the SIGKILL.

What we can control is that the kernel has exhausted its capabilities of 
allowing for future memory freeing at the time of notification.  That's 
the goal of the patch, at the same time making it consistent with the 
documentation.
