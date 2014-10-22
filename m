Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933340AbaJVMkg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 08:40:36 -0400
Received: from gum.cmpxchg.org ([85.214.110.215]:42615 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933049AbaJVMkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 08:40:35 -0400
Date: Wed, 22 Oct 2014 08:40:25 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: remove mem_cgroup_reclaimable check from soft
 reclaim
Message-ID: <20141022124025.GA17161@phnom.home.cmpxchg.org>
References: <1413897350-32553-1-git-send-email-vdavydov@parallels.com>
 <20141021182239.GA24899@phnom.home.cmpxchg.org>
 <20141022112116.GA30802@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141022112116.GA30802@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 01:21:16PM +0200, Michal Hocko wrote:
> On Tue 21-10-14 14:22:39, Johannes Weiner wrote:
> [...]
> > From 27bd24b00433d9f6c8d60ba2b13dbff158b06c13 Mon Sep 17 00:00:00 2001
> > From: Johannes Weiner <hannes@cmpxchg.org>
> > Date: Tue, 21 Oct 2014 09:53:54 -0400
> > Subject: [patch] mm: memcontrol: do not filter reclaimable nodes in NUMA
> >  round-robin
> > 
> > The round-robin node reclaim currently tries to include only nodes
> > that have memory of the memcg in question, which is quite elaborate.
> > 
> > Just use plain round-robin over the nodes that are allowed by the
> > task's cpuset, which are the most likely to contain that memcg's
> > memory.  But even if zones without memcg memory are encountered,
> > direct reclaim will skip over them without too much hassle.
> 
> I do not think that using the current's node mask is correct. Different
> tasks in the same memcg might be bound to different nodes and then a set
> of nodes might be reclaimed much more if a particular task hits limit
> more often. It also doesn't make much sense from semantical POV, we are
> reclaiming memcg so the mask should be union of all tasks allowed nodes.

Unless the cpuset hierarchy is separate from the memcg hierarchy, all
tasks in the memcg belong to the same cpuset.  And the whole point of
cpusets is that a group of tasks has the same nodemask, no?

Sure, there are *possible* configurations for which this assumption
breaks, like multiple hierarchies, but are they sensible?  Do we care?

> What we do currently is overly complicated though and I agree that there
> is no good reason for it.
> Let's just s@cpuset_current_mems_allowed@node_online_map@ and round
> robin over all nodes. As you said we do not have to optimize for empty
> zones.

That was what I first had.  And cpuset_current_mems_allowed defaults
to node_online_map, but once the user sets up cpusets in conjunction
with memcgs, it seems to be the preferred value.

The other end of this is that if you have 16 nodes and use cpuset to
bind the task to node 14 and 15, round-robin iterations of node 1-13
will reclaim the group's memory on 14 and only the 15 iteration will
actually look at memory from node 15 first.

It seems using the cpuset bindings, while theoretically independent,
would do the right thing for all intents and purposes.
