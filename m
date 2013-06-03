Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758289Ab3FCVSE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 17:18:04 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:33772 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757635Ab3FCVR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 17:17:58 -0400
Date: Mon, 3 Jun 2013 14:17:54 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org
Subject: Re: [patch] mm, memcg: add oom killer delay
In-Reply-To: <20130603193147.GC23659@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.02.1306031411380.22083@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1305291817280.520@chino.kir.corp.google.com> <20130530150539.GA18155@dhcp22.suse.cz> <alpine.DEB.2.02.1305301338430.20389@chino.kir.corp.google.com> <20130531081052.GA32491@dhcp22.suse.cz> <alpine.DEB.2.02.1305310316210.27716@chino.kir.corp.google.com>
 <20130531112116.GC32491@dhcp22.suse.cz> <alpine.DEB.2.02.1305311224330.3434@chino.kir.corp.google.com> <20130601102058.GA19474@dhcp22.suse.cz> <alpine.DEB.2.02.1306031102480.7956@chino.kir.corp.google.com> <20130603193147.GC23659@dhcp22.suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Jun 2013, Michal Hocko wrote:

> > What do you suggest when you read the "tasks" file and it returns -ENOMEM 
> > because kmalloc() fails because the userspace oom handler's memcg is also 
> > oom? 
> 
> That would require that you track kernel allocations which is currently
> done only for explicit caches.
> 

That will not always be the case, and I think this could be a prerequisite 
patch for such support that we have internally.  I'm not sure a userspace 
oom notifier would want to keep a preallocated buffer around that is 
mlocked in memory for all possible lengths of this file.

> > Obviously it's not a situation we want to get into, but unless you 
> > know that handler's exact memory usage across multiple versions, nothing 
> > else is sharing that memcg, and it's a perfect implementation, you can't 
> > guarantee it.  We need to address real world problems that occur in 
> > practice.
> 
> If you really need to have such a guarantee then you can have a _global_
> watchdog observing oom_control of all groups that provide such a vague
> requirements for oom user handlers.
> 

The whole point is to allow the user to implement their own oom policy.  
If the policy was completely encapsulated in kernel code, we don't need to 
ever disable the oom killer even with memory.oom_control.  Users may 
choose to kill the largest process, the newest process, the oldest 
process, sacrifice children instead of parents, prevent forkbombs, 
implement their own priority scoring (which is what we do), kill the 
allocating task, etc.

To not merge this patch, I'd ask that you show an alternative that allows 
users to implement their own userspace oom handlers and not require admin 
intervention when things go wrong.
