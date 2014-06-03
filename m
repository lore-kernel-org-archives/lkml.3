Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933767AbaFCUSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 16:18:32 -0400
Received: from mx2.parallels.com ([199.115.105.18]:54342 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbaFCUSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 16:18:30 -0400
Date: Wed, 4 Jun 2014 00:18:19 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Christoph Lameter <cl@gentwo.org>
CC: <akpm@linux-foundation.org>, <hannes@cmpxchg.org>, <mhocko@suse.cz>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH -mm 8/8] slab: reap dead memcg caches aggressively
Message-ID: <20140603201817.GE6013@esperanza>
References: <cover.1401457502.git.vdavydov@parallels.com>
 <23a736c90a81e13a2252d35d9fc3dc04a9ed7d7c.1401457502.git.vdavydov@parallels.com>
 <alpine.DEB.2.10.1405300957390.11943@gentwo.org>
 <20140531111922.GD25076@esperanza>
 <alpine.DEB.2.10.1406021019350.2987@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1406021019350.2987@gentwo.org>
X-Originating-IP: [109.195.248.178]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 10:24:09AM -0500, Christoph Lameter wrote:
> On Sat, 31 May 2014, Vladimir Davydov wrote:
> 
> > > You can use a similar approach than in SLUB. Reduce the size of the per
> > > cpu array objects to zero. Then SLAB will always fall back to its slow
> > > path in cache_flusharray() where you may be able to do something with less
> > > of an impact on performace.
> >
> > In contrast to SLUB, for SLAB this will slow down kfree significantly.
> 
> But that is only when you want to destroy a cache. This is similar.

When we want to destroy a memcg cache, there can be really a lot of
objects allocated from it, e.g. gigabytes of inodes and dentries. That's
why I think we should avoid any performance degradations if possible.

> 
> > Fast path for SLAB is just putting an object to a per cpu array, while
> > the slow path requires taking a per node lock, which is much slower even
> > with no contention. There still can be lots of objects in a dead memcg
> > cache (e.g. hundreds of megabytes of dcache), so such performance
> > degradation is not acceptable, IMO.
> 
> I am not sure that there is such a stark difference to SLUB. SLUB also
> takes the per node lock if necessary to handle freeing especially if you
> zap the per cpu partial slab pages.

Hmm, for SLUB we will only take the node lock for inserting a slab on
the partial list, while for SLAB disabling per-cpu arrays will result in
taking the lock on each object free. So if there are only several
objects per slab, the difference won't be huge, otherwise the slow down
will be noticeable for SLAB, but not for SLUB.

I'm not that sure that we should prefer one way over another though. I
just think that if we already have periodic reaping for SLAB, why not
employ it for reaping dead memcg caches too, provided it won't obfuscate
the code? Anyway, if you think that we can neglect possible performance
degradation that will result from disabling per cpu caches for SLAB, I
can give it a try.

Thanks.
