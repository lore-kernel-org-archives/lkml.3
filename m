Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147AbaEBNBd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 09:01:33 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:60154 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbaEBNBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 09:01:32 -0400
Date: Fri, 2 May 2014 09:01:18 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, Tejun Heo <tj@kernel.org>,
        Hugh Dickins <hughd@google.com>, Roman Gushchin <klamm@yandex-team.ru>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 1/4] memcg, mm: introduce lowlimit reclaim
Message-ID: <20140502130118.GK23420@cmpxchg.org>
References: <1398688005-26207-1-git-send-email-mhocko@suse.cz>
 <1398688005-26207-2-git-send-email-mhocko@suse.cz>
 <20140430225550.GD26041@cmpxchg.org>
 <20140502093628.GC3446@dhcp22.suse.cz>
 <20140502120715.GI3446@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140502120715.GI3446@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2014 at 02:07:15PM +0200, Michal Hocko wrote:
> On Fri 02-05-14 11:36:28, Michal Hocko wrote:
> > On Wed 30-04-14 18:55:50, Johannes Weiner wrote:
> > > On Mon, Apr 28, 2014 at 02:26:42PM +0200, Michal Hocko wrote:
> > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > index 19d620b3d69c..40e517630138 100644
> > > > --- a/mm/memcontrol.c
> > > > +++ b/mm/memcontrol.c
> > > > @@ -2808,6 +2808,29 @@ static struct mem_cgroup *mem_cgroup_lookup(unsigned short id)
> > > >  	return mem_cgroup_from_id(id);
> > > >  }
> > > >  
> > > > +/**
> > > > + * mem_cgroup_reclaim_eligible - checks whether given memcg is eligible for the
> > > > + * reclaim
> > > > + * @memcg: target memcg for the reclaim
> > > > + * @root: root of the reclaim hierarchy (null for the global reclaim)
> > > > + *
> > > > + * The given group is reclaimable if it is above its low limit and the same
> > > > + * applies for all parents up the hierarchy until root (including).
> > > > + */
> > > > +bool mem_cgroup_reclaim_eligible(struct mem_cgroup *memcg,
> > > > +		struct mem_cgroup *root)
> > > 
> > > Could you please rename this to something that is more descriptive in
> > > the reclaim callsite?  How about mem_cgroup_within_low_limit()?
> > 
> > I have intentionally used somethig that is not low_limit specific. The
> > generic reclaim code does't have to care about the reason why a memcg is
> > not reclaimable. I agree that having follow_low_limit paramter explicit
> > and mem_cgroup_reclaim_eligible not is messy. So something should be
> > renamed. I would probably go with s@follow_low_limit@check_reclaim_eligible@
> > but I do not have a strong preference.
> 
> What about this?

I really don't like it.

Yes, we should be hiding implementation details, but we should stop
treating memcg like an alien in this code.  The VM code obviously
doesn't have to know HOW the guarantees are exactly implemented, but
it's a perfectly fine *concept* that can be known outside of memcg:

shrink_zone:
for each memcg in system:
  if mem_cgroup_within_guarantee(memcg):
    continue
  reclaim(memcg-zone)

is perfectly understandable and makes it easier to reason about the
behavior of the reclaim code.  If I just see !mem_cgroup_eligible(), I
don't know if this affects the scenario I'm thinking about at all.

It's obscuring useful information for absolutely no benefit.  If you
burden the reclaim code with a callback, you better explain what you
are doing.  You owe it to the reader.
