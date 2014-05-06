Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793AbaEFSaJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 14:30:09 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:47786 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbaEFSaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 14:30:06 -0400
Date: Tue, 6 May 2014 20:30:01 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, Tejun Heo <tj@kernel.org>,
        Hugh Dickins <hughd@google.com>, Roman Gushchin <klamm@yandex-team.ru>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 1/4] memcg, mm: introduce lowlimit reclaim
Message-ID: <20140506183001.GB30921@dhcp22.suse.cz>
References: <20140430225550.GD26041@cmpxchg.org>
 <20140502093628.GC3446@dhcp22.suse.cz>
 <20140502155805.GO23420@cmpxchg.org>
 <20140502164930.GP3446@dhcp22.suse.cz>
 <20140502220056.GP23420@cmpxchg.org>
 <20140506132932.GF19914@cmpxchg.org>
 <20140506143242.GB19672@dhcp22.suse.cz>
 <20140506152112.GG19914@cmpxchg.org>
 <20140506161256.GE19672@dhcp22.suse.cz>
 <20140506165150.GI19914@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140506165150.GI19914@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 06-05-14 12:51:50, Johannes Weiner wrote:
> On Tue, May 06, 2014 at 06:12:56PM +0200, Michal Hocko wrote:
> > On Tue 06-05-14 11:21:12, Johannes Weiner wrote:
> > > On Tue, May 06, 2014 at 04:32:42PM +0200, Michal Hocko wrote:
[...]
> > > > The strongest point was made by Rik when he claimed that memcg is not
> > > > aware of memory zones and so one memcg with lowlimit larger than the
> > > > size of a zone can eat up that zone without any way to free it.
> > > 
> > > But who actually cares if an individual zone can be reclaimed?
> > > 
> > > Userspace allocations can fall back to any other zone.  Unless there
> > > are hard bindings, but hopefully nobody binds a memcg to a node that
> > > is smaller than that memcg's guarantee. 
> > 
> > The protected group might spill over to another group and eat it when
> > another group would be simply pushed out from the node it is bound to.
> 
> I don't really understand the point you're trying to make.

I was just trying to show a case where individual zone matters. To make
it more specific consider 2 groups A (with low-limit 60% RAM) and B
(say with low-limit 10% RAM) and bound to a node X (25% of RAM). Now
having 70% of RAM reserved for guarantee makes some sense, right? B is
not over-committing the node it is bound to. Yet the A's allocations
might make pressure on X regardless that the whole system is still doing
good. This can lead to a situation where X gets depleted and nothing
would be reclaimable leading to an OOM condition.

I can imagine that most people would rather see the lowlimit break than
OOM. And if there is somebody who really wants OOM even under such
condition then why not, I would be happy to add a knob which would allow
that. But I feel that the default behavior should be the least explosive
one...

> > > And while the pages are not
> > > reclaimable, they are still movable, so the NUMA balancer is free to
> > > correct any allocation mistakes later on.
> > 
> > Do we want to depend on NUMA balancer, though?
> 
> You're missing my point.
> 
> This is about which functionality of the system is actually impeded by
> having large portions of a zone unreclaimable.  Freeing pages in a
> zone is means to an end, not an end in itself.
> 
> We wouldn't depend on the NUMA balancer to "free" a zone, I'm just
> saying that the NUMA balancer would be unaffected by a zone full of
> unreclaimable pages, as long as they are movable.

Agreed. I wasn't objecting to that part. I was merely noticing that we
do not want to depend on NUMA balancer to fix up placements later just
because they are unreclaimable due to restrictions defined outside of
the NUMA scope.

> So who exactly cares about the ability to reclaim individual zones and
> how is it a new type of problem compared to existing unreclaimable but
> movable memory?

The low limit makes the current situation different. Page allocator
simply cannot make the best decisions on the placement because it
doesn't have any idea to which group the page gets charged to and
therefore whether it gets protected or not. NUMA balancing can help
to reduce this issues but I do not think it can handle the problem
itself.
-- 
Michal Hocko
SUSE Labs
