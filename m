Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933554AbaE3PBa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:01:30 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:56663 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933182AbaE3PB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:01:28 -0400
Date: Fri, 30 May 2014 10:01:26 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Vladimir Davydov <vdavydov@parallels.com>
cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@suse.cz,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -mm 8/8] slab: reap dead memcg caches aggressively
In-Reply-To: <23a736c90a81e13a2252d35d9fc3dc04a9ed7d7c.1401457502.git.vdavydov@parallels.com>
Message-ID: <alpine.DEB.2.10.1405300957390.11943@gentwo.org>
References: <cover.1401457502.git.vdavydov@parallels.com> <23a736c90a81e13a2252d35d9fc3dc04a9ed7d7c.1401457502.git.vdavydov@parallels.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2014, Vladimir Davydov wrote:

> There is no use in keeping free objects/slabs on dead memcg caches,
> because they will never be allocated. So let's make cache_reap() shrink
> as many free objects from such caches as possible.
>
> Note the difference between SLAB and SLUB handling of dead memcg caches.
> For SLUB, dead cache destruction is scheduled as soon as the last object
> is freed, because dead caches do not cache free objects. For SLAB, dead
> caches can keep some free objects on per cpu arrays, so that an empty
> dead cache will be hanging around until cache_reap() drains it.

Calling kmem_cache_shrink() should drain all caches though. Reduce the
size of the queues to zero or so before calling shrink so that no new
caches are build up?

> We don't disable free objects caching for SLAB, because it would force
> kfree to always take a spin lock, which would degrade performance
> significantly.

You can use a similar approach than in SLUB. Reduce the size of the per
cpu array objects to zero. Then SLAB will always fall back to its slow
path in cache_flusharray() where you may be able to do something with less
of an impact on performace.
