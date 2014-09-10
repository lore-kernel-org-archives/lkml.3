Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751225AbaIJMCM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 08:02:12 -0400
Received: from mx2.parallels.com ([199.115.105.18]:54507 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbaIJMCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 08:02:10 -0400
Date: Wed, 10 Sep 2014 16:01:57 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Greg Thelen <gthelen@google.com>, Hugh Dickins <hughd@google.com>,
        Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>,
        Glauber Costa <glommer@gmail.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelianov <xemul@parallels.com>,
        Konstantin Khorenko <khorenko@parallels.com>,
        LKML-MM <linux-mm@kvack.org>, LKML-cgroups <cgroups@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] memory cgroup: my thoughts on memsw
Message-ID: <20140910120157.GA13796@esperanza>
References: <20140904143055.GA20099@esperanza>
 <5408E1CD.3090004@jp.fujitsu.com>
 <20140905082846.GA25641@esperanza>
 <5409C6BB.7060009@jp.fujitsu.com>
 <20140905160029.GF25641@esperanza>
 <540A4420.2030504@jp.fujitsu.com>
 <20140908110131.GA11812@esperanza>
 <540DB4EC.6060100@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <540DB4EC.6060100@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 10:53:48PM +0900, Kamezawa Hiroyuki wrote:
> (2014/09/08 20:01), Vladimir Davydov wrote:
> >On Sat, Sep 06, 2014 at 08:15:44AM +0900, Kamezawa Hiroyuki wrote:
> >>As you noticed, hitting anon+swap limit just means oom-kill.
> >>My point is that using oom-killer for "server management" just seems crazy.
> >>
> >>Let my clarify things. your proposal was.
> >>  1. soft-limit will be a main feature for server management.
> >>  2. Because of soft-limit, global memory reclaim runs.
> >>  3. Using swap at global memory reclaim can cause poor performance.
> >>  4. So, making use of OOM-Killer for avoiding swap.
> >>
> >>I can't agree "4". I think
> >>
> >>  - don't configure swap.
> >
> >Suppose there are two containers, each having soft limit set to 50% of
> >total system RAM. One of the containers eats 90% of the system RAM by
> >allocating anonymous pages. Another starts using file caches and wants
> >more than 10% of RAM to work w/o issuing disk reads. So what should we
> >do then?
> >We won't be able to shrink the first container to its soft
> >limit, because there's no swap. Leaving it as is would be unfair from
> >the second container's point of view. Kill it? But the whole system is
> >going OK, because the working set of the second container is easily
> >shrinkable. Besides there may be some progress in shrinking file caches
> >from the first container.
> >
> >>  - use zram
> >
> >In fact this isn't different from the previous proposal (working w/o
> >swap). ZRAM only compresses data while still storing them in RAM so we
> >eventually may get into a situation where almost all RAM is full of
> >compressed anon pages.
> >
> 
> In above 2 cases, "vmpressure" works fine.

What if a container allocates memory so fast that the userspace thread
handling its threshold notifications won't have time to react before it
eats all memory?

Thanks,
Vladimir
