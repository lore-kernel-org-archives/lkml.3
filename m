Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265Ab3E3Urn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 16:47:43 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:59502 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757840Ab3E3Ure (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 16:47:34 -0400
Date: Thu, 30 May 2013 13:47:30 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org
Subject: Re: [patch] mm, memcg: add oom killer delay
In-Reply-To: <20130530150539.GA18155@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.02.1305301338430.20389@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1305291817280.520@chino.kir.corp.google.com> <20130530150539.GA18155@dhcp22.suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 May 2013, Michal Hocko wrote:

> > Completely disabling the oom killer for a memcg is problematic if
> > userspace is unable to address the condition itself, usually because it
> > is unresponsive. 
> 
> Isn't this a bug in the userspace oom handler? Why is it unresponsive? It
> shouldn't allocated any memory so nothing should prevent it from running (if
> other tasks are preempting it permanently then the priority of the handler
> should be increased).
> 

Unresponsiveness isn't necessarily only because of memory constraints, you 
may have your oom notifier in a parent cgroup that isn't oom.  If a 
process is stuck on mm->mmap_sem in the oom cgroup, though, the oom 
notifier may not be able to scrape /proc/pid and attain necessary 
information in making an oom kill decision.  If the oom notifier is in the 
oom cgroup, it may not be able to successfully read the memcg "tasks" 
file to even determine the set of eligible processes.  There is also no 
guarantee that the userspace oom handler will have the necessary memory to 
even re-enable the oom killer in the memcg under oom which would allow the 
kernel to make forward progress.

We've used this for a few years as a complement to oom notifiers so that a 
process would have a grace period to deal with the oom condition itself 
before allowing the kernel to terminate a process and free memory.  We've 
simply had no alternative in the presence of kernel constraints that 
prevent it from being done in any other way.  We _want_ userspace to deal 
with the issue but when it cannot collect the necessary information (and 
we're not tracing every fork() that every process in a potentially oom 
memcg does) to deal with the condition, we want the kernel to step in 
instead of relying on an admin to login or a global oom condition.

If you'd like to debate this issue, I'd be more than happy to do so and 
show why this patch is absolutely necessary for inclusion, but I'd ask 
that you'd present the code from your userspace oom handler so I can 
understand how it works without needing such backup support.
