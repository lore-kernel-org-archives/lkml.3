Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631AbbAZTgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 14:36:45 -0500
Received: from mx2.parallels.com ([199.115.105.18]:57852 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbbAZTgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 14:36:42 -0500
Date: Mon, 26 Jan 2015 22:36:29 +0300
From: Vladimir Davydov <vdavydov@parallels.com>
To: Christoph Lameter <cl@linux.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm 1/3] slub: don't fail kmem_cache_shrink if slab
 placement optimization fails
Message-ID: <20150126193629.GA2660@esperanza>
References: <cover.1422275084.git.vdavydov@parallels.com>
 <3804a429071f939e6b4f654b6c6426c1fdd95f7e.1422275084.git.vdavydov@parallels.com>
 <alpine.DEB.2.11.1501260944550.15849@gentwo.org>
 <20150126170147.GB28978@esperanza>
 <alpine.DEB.2.11.1501261216120.16638@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1501261216120.16638@gentwo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 12:24:49PM -0600, Christoph Lameter wrote:
> On Mon, 26 Jan 2015, Vladimir Davydov wrote:
> 
> > Anyways, I think that silently relying on the fact that the allocator
> > never fails small allocations is kind of unreliable. What if this
> 
> We are not doing that though. If the allocation fails we do nothing.

Yeah, that's correct, but memcg/kmem wants it to always free empty slabs
(see patch 3 for details), so I'm trying to be punctual and eliminate
any possibility of failure, because a failure (if it ever happened)
would result in a permanent memory leak (pinned mem_cgroup + its
kmem_caches).

> 
> > > > +			if (page->inuse < objects)
> > > > +				list_move(&page->lru,
> > > > +					  slabs_by_inuse + page->inuse);
> > > >  			if (!page->inuse)
> > > >  				n->nr_partial--;
> > > >  		}
> > >
> > > The condition is always true. A page that has page->inuse == objects
> > > would not be on the partial list.
> > >
> >
> > This is in case we failed to allocate the slabs_by_inuse array. We only
> > have a list for empty slabs then (on stack).
> 
> Ok in that case objects == 1. If you want to do this maybe do it in a more
> general way?
> 
> You could allocate an array on the stack to deal with the common cases. I
> believe an array of 32 objects would be fine to allocate and cover most of
> the slab caches on the system? Would eliminate most of the allocations in
> kmem_cache_shrink.

We could do that, but IMO that would only complicate the code w/o
yielding any real benefits. This function is slow and called rarely
anyway, so I don't think there is any point to optimize out a page
allocation here.

Thanks,
Vladimir
