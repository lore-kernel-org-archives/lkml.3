Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454AbaEaLTf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 07:19:35 -0400
Received: from mx2.parallels.com ([199.115.105.18]:50248 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558AbaEaLTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 07:19:34 -0400
Date: Sat, 31 May 2014 15:19:23 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Christoph Lameter <cl@gentwo.org>
CC: <akpm@linux-foundation.org>, <hannes@cmpxchg.org>, <mhocko@suse.cz>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH -mm 8/8] slab: reap dead memcg caches aggressively
Message-ID: <20140531111922.GD25076@esperanza>
References: <cover.1401457502.git.vdavydov@parallels.com>
 <23a736c90a81e13a2252d35d9fc3dc04a9ed7d7c.1401457502.git.vdavydov@parallels.com>
 <alpine.DEB.2.10.1405300957390.11943@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405300957390.11943@gentwo.org>
X-Originating-IP: [81.5.110.170]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 10:01:26AM -0500, Christoph Lameter wrote:
> On Fri, 30 May 2014, Vladimir Davydov wrote:
> 
> > We don't disable free objects caching for SLAB, because it would force
> > kfree to always take a spin lock, which would degrade performance
> > significantly.
> 
> You can use a similar approach than in SLUB. Reduce the size of the per
> cpu array objects to zero. Then SLAB will always fall back to its slow
> path in cache_flusharray() where you may be able to do something with less
> of an impact on performace.

In contrast to SLUB, for SLAB this will slow down kfree significantly.
Fast path for SLAB is just putting an object to a per cpu array, while
the slow path requires taking a per node lock, which is much slower even
with no contention. There still can be lots of objects in a dead memcg
cache (e.g. hundreds of megabytes of dcache), so such performance
degradation is not acceptable, IMO.

OTOH, we already have cache_reap running periodically for each cache.
Making it drain all free objects in dead caches won't impact performance
at all, neither will it complicate the code. The only downside is a dead
cache won't be destroyed immediately after it becomes unused, but since
cache_reap runs pretty often (each several secs), it shouldn't result in
any problems, I guess.

Thanks.
