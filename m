Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab3JBDIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 23:08:48 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:50172 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab3JBDIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 23:08:46 -0400
Date: Tue, 1 Oct 2013 20:08:43 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch for-3.12] mm, memcg: protect mem_cgroup_read_events for
 cpu hotplug
In-Reply-To: <20131002022227.GR856@cmpxchg.org>
Message-ID: <alpine.DEB.2.02.1310011958440.31300@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1310011629350.27758@chino.kir.corp.google.com> <20131002022227.GR856@cmpxchg.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Oct 2013, Johannes Weiner wrote:

> On Tue, Oct 01, 2013 at 04:31:23PM -0700, David Rientjes wrote:
> > for_each_online_cpu() needs the protection of {get,put}_online_cpus() so
> > cpu_online_mask doesn't change during the iteration.
> 
> There is no problem report here.
> 
> Is there a crash?
> 

No.

> If it's just accuracy of the read, why would we care about some
> inaccuracies in counters that can change before you even get the
> results to userspace?  And care to the point where we hold up CPU
> hotplugging for this?
> 

cpu_hotplug.lock is held while a cpu is going down, it's a coarse lock 
that is used kernel-wide to synchronize cpu hotplug activity.  Memcg has 
a cpu hotplug notifier, called while there may not be any cpu hotplug 
refcounts, which drains per-cpu event counts to memcg->nocpu_base.events 
to maintain a cumulative event count as cpus disappear.  Without 
get_online_cpus() in mem_cgroup_read_events(), it's possible to account 
for the event count on a dying cpu twice, and this value may be 
significantly large.

In fact, all memcg->pcp_counter_lock use should be nested by 
{get,put}_online_cpus().

This fixes that issue and ensures the reported statistics are not vastly 
over-reported during cpu hotplug.

> Also, the fact that you directly sent this to Linus suggests there is
> some urgency for this fix.  What's going on?
> 

I believe users of cpu hotplug still want event counts that are 
approximate to the real value and that this is 3.12 material.
