Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab3EaKXP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 06:23:15 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:64677 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030Ab3EaKXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 06:23:02 -0400
Date: Fri, 31 May 2013 03:22:59 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org
Subject: Re: [patch] mm, memcg: add oom killer delay
In-Reply-To: <20130531081052.GA32491@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.02.1305310316210.27716@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1305291817280.520@chino.kir.corp.google.com> <20130530150539.GA18155@dhcp22.suse.cz> <alpine.DEB.2.02.1305301338430.20389@chino.kir.corp.google.com> <20130531081052.GA32491@dhcp22.suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 May 2013, Michal Hocko wrote:

> I have always discouraged people from running oom handler in the same
> memcg (or even in the same hierarchy).
> 

We allow users to control their own memcgs by chowning them, so they must 
be run in the same hierarchy if they want to run their own userspace oom 
handler.  There's nothing in the kernel that prevents that and the user 
has no other option but to run in a parent cgroup.

> Yes, mmap_sem is tricky. Nothing in the proc code should take it for
> writing and charges are done with mmap_sem held for reading but that
> doesn't prevent from non-oom thread to try to get it for writing which
> would block also all future readers. We have also seen i_mutex being
> held during charge so you have to be careful about that one as well but
> I am not aware of other locks that could be a problem.
> 
> The question is, do you really need to open any /proc/<pid>/ files which
> depend on mmap_sem (e.g. maps, smaps). /proc/<pid>/status should tell you
> about used memory. Or put it another way around. What kind of data you
> need for your OOM handler?
> 

It's too easy to simply do even a "ps ax" in an oom memcg and make that 
thread completely unresponsive because it allocates memory.

> I might be thinking about different use cases but user space OOM
> handlers I have seen so far had quite a good idea what is going on
> in the group and who to kill.

Then perhaps I'm raising constraints that you've never worked with, I 
don't know.  We choose to have a priority-based approach that is inherited 
by children; this priority is kept in userspace and and the oom handler 
would naturally need to know the set of tasks in the oom memcg at the time 
of oom and their parent-child relationship.  These priorities are 
completely independent of memory usage.

> > If the oom notifier is in the oom cgroup, it may not be able to       
> > successfully read the memcg "tasks" file to even determine the set of 
> > eligible processes.
> 
> It would have to use preallocated buffer and have mlocked all the memory
> that will be used during oom event.
> 

Wrong, the kernel itself allocates memory when reading this information 
and that would fail in an oom memcg.
