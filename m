Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbbALNAH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 08:00:07 -0500
Received: from mx2.parallels.com ([199.115.105.18]:59201 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbbALNAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 08:00:05 -0500
Date: Mon, 12 Jan 2015 15:59:56 +0300
From: Vladimir Davydov <vdavydov@parallels.com>
To: Tejun Heo <tj@kernel.org>
CC: Johannes Weiner <hannes@cmpxchg.org>,
        "Suzuki K. Poulose" <Suzuki.Poulose@arm.com>, <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH cgroup/for-3.19-fixes] cgroup: implement
 cgroup_subsys->unbind() callback
Message-ID: <20150112125956.GF2110@esperanza>
References: <54B01335.4060901@arm.com>
 <20150110085525.GD2110@esperanza>
 <20150110214316.GF25319@htj.dyndns.org>
 <20150111205543.GA5480@phnom.home.cmpxchg.org>
 <20150112080114.GE2110@esperanza>
 <20150112112845.GS25319@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20150112112845.GS25319@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 06:28:45AM -0500, Tejun Heo wrote:
> On Mon, Jan 12, 2015 at 11:01:14AM +0300, Vladimir Davydov wrote:
> > Come to think of it, I wonder how many users actually want to mount
> > different controllers subset after unmount. Because we could allow
> 
> It wouldn't be a common use case but, on the face of it, we still
> support it.  If we collecctively decide that once a sub cgroup is
> created for any controller no further hierarchy configuration for that
> controller is allowed, that'd work too, but one way or the other, the
> behavior, I believe, should be well-defined.  As it currently stands,
> the conditions and failure mode are opaque to userland, which is never
> a good thing.
> 
> > mounting the same subset perfectly well, even if it includes memcg. BTW,
> > AFAIU in the unified hierarchy we won't have this problem at all,
> > because by definition it mounts all controllers IIRC, so do we need to
> > bother fixing this in such a complicated manner at all for the setup
> > that's going to be deprecated anyway?
> 
> There will likely be a quite long transition period and if and when
> the old things can be removed, this added cleanup logic can go away
> with it.  It depends on how complex the implementation would get but
> as long as it isn't too much and stays mostly isolated from the saner
> paths, I think it's probably the right thing to do.

We can't just move kmem objects from a per-memcg kmem_cache to the
global one fixing page counters, because in contrast to page cache and
swap we don't even track all kmem allocations. So we have to keep all
per-memcg kmem_cache's somewhere after unmount until they can finally be
destroyed, but the whole logic behind per-memcg kmem_cache's destruction
is currently tightly interwoven with that of css's (we destroy
kmem_cache's from css_free), and there won't be any css's after unmount.

That said, it isn't possible to add a couple of isolated functions,
which will live their own lives and can be easily removed once we've
switched to the unified hierarchy. Quite the contrary, implementing of
kmem reparenting would make me rethink and complicate kmemcg code all
over the place. That's why I'm rather reluctant to do it.

I haven't dug deep into the cgroup core, but may be we could detach the
old root in cgroup_kill_sb() and leave it dangling until the last
reference to it has gone?

BTW, IIRC the problem always existed for kmem-active memory cgroups,
because we never had kmem reparenting. May be, we could therefore just
document somewhere that kmem accounting is highly discouraged to be used
in the legacy hierarchy and merge these two patches as is to handle page
cache and swap charges? We won't break anything, because it was always
broken :-)

Thanks,
Vladimir
