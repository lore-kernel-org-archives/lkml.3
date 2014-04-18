Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaDRNle (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:41:34 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:59158 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305AbaDRNlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:41:32 -0400
Date: Fri, 18 Apr 2014 09:41:22 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: mhocko@suse.cz, akpm@linux-foundation.org, glommer@gmail.com,
        cl@linux-foundation.org, penberg@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, devel@openvz.org
Subject: Re: [PATCH RFC -mm v2 1/3] memcg, slab: do not schedule cache
 destruction when last page goes away
Message-ID: <20140418134122.GB26283@cmpxchg.org>
References: <cover.1397804745.git.vdavydov@parallels.com>
 <e929fb6cc3a10ce1a9dcee0440e6995bdf427090.1397804745.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e929fb6cc3a10ce1a9dcee0440e6995bdf427090.1397804745.git.vdavydov@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 12:04:47PM +0400, Vladimir Davydov wrote:
> After a memcg is offlined, we mark its kmem caches that cannot be
> deleted right now due to pending objects as dead by setting the
> memcg_cache_params::dead flag, so that memcg_release_pages will schedule
> cache destruction (memcg_cache_params::destroy) as soon as the last slab
> of the cache is freed (memcg_cache_params::nr_pages drops to zero).
> 
> I guess the idea was to destroy the caches as soon as possible, i.e.
> immediately after freeing the last object. However, it just doesn't work
> that way, because kmem caches always preserve some pages for the sake of
> performance, so that nr_pages never gets to zero unless the cache is
> shrunk explicitly using kmem_cache_shrink. Of course, we could account
> the total number of objects on the cache or check if all the slabs
> allocated for the cache are empty on kmem_cache_free and schedule
> destruction if so, but that would be too costly.
> 
> Thus we have a piece of code that works only when we explicitly call
> kmem_cache_shrink, but complicates the whole picture a lot. Moreover,
> it's racy in fact. For instance, kmem_cache_shrink may free the last
> slab and thus schedule cache destruction before it finishes checking
> that the cache is empty, which can lead to use-after-free.

Can't this still happen when the last object free races with css
destruction?  IIRC, you were worried in the past that slab/slub might
need a refcount to the cache to prevent this.  What changed?

> So I propose to remove this async cache destruction from
> memcg_release_pages, and check if the cache is empty explicitly after
> calling kmem_cache_shrink instead. This will simplify things a lot w/o
> introducing any functional changes.

Agreed.

> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
