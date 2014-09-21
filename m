Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbaIUPa3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 11:30:29 -0400
Received: from mx2.parallels.com ([199.115.105.18]:40818 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbaIUPa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 11:30:27 -0400
Date: Sun, 21 Sep 2014 19:30:10 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Greg Thelen <gthelen@google.com>
CC: Suleiman Souhlal <suleiman@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>,
        Dave Chinner <david@fromorbit.com>, Glauber Costa <glommer@gmail.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelianov <xemul@parallels.com>,
        Konstantin Khorenko <khorenko@parallels.com>,
        LKML-MM <linux-mm@kvack.org>, LKML-cgroups <cgroups@vger.kernel.org>
Subject: Re: [RFC] memory cgroup: weak points of kmem accounting design
Message-ID: <20140921153010.GB32416@esperanza>
References: <20140915104437.GA11886@esperanza>
 <CABCjUKCkgoG07djfLEpqo0sBwgKts0iMepwNsh_RdNVTVtYH3A@mail.gmail.com>
 <20140916083124.GA32139@esperanza>
 <xr93r3z9ctje.fsf@gthelen.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <xr93r3z9ctje.fsf@gthelen.mtv.corp.google.com>
X-Originating-IP: [81.5.99.36]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Wed, Sep 17, 2014 at 09:04:00PM -0700, Greg Thelen wrote:
> I've found per memcg per cache type stats useful in answering "why is my
> container oom?"  While these are kernel allocations, it is common for
> user space operations to cause these allocations (e.g. lots of open file
> descriptors).  So I don't specifically need per memcg slabinfo formatted
> data, but at the least a per memcg per cache type active object count
> would be very useful.  Thus I imagine each memcg would have an array of
> slab cache types each with per-cpu active object counters.  Per-cpu is
> used to avoid trashing those counters between cpus as objects are
> allocated and freed.

Hmm, that sounds sane. One more argument for the current design.

> As you say only memcg shrinkable cache types would need list heads.  I
> assume these per memcg shrinkable object list heads would be per cache
> type per cpu list heads for cache performance.  Allocation of a dentry
> today uses the normal slab management structures.  In this proposal I
> suspect the dentry would be dual indexed: once in the global slab/slub
> dentry lru and once in the per memcg dentry list.  If true, this might
> be a hot path regression allocation speed regression.
> 
> Do you have a shrinker design in mind?  I suspect this new design would
> involve a per memcg dcache shrinker which grabs a big per-memcg dcache
> lock while walking the dentry list.  The classic per superblock
> shrinkers would not used for memcg shrinking.

To be honest, I hadn't elaborated that in my mind when I sent this
e-mail, but now I realize that it doesn't look as if there's an easy way
to implement shrinkers in such a setup efficiently. I thought we could
keep each dentry/inode simultaneously in two list, global and memcg.
However, apart from resulting in memory wastes this, as you pointed out,
would result in a regression in operating on the lrus, which is
unacceptable.

That said, I admit my idea sounds crazy. I think sticking to Glauber's
design and trying to make it work is the best we can do now.

Thanks,
Vladimir
