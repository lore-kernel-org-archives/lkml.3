Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349AbbAZSYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 13:24:54 -0500
Received: from resqmta-po-03v.sys.comcast.net ([96.114.154.162]:53828 "EHLO
	resqmta-po-03v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756066AbbAZSYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 13:24:52 -0500
Date: Mon, 26 Jan 2015 12:24:49 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Vladimir Davydov <vdavydov@parallels.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/3] slub: don't fail kmem_cache_shrink if slab
 placement optimization fails
In-Reply-To: <20150126170147.GB28978@esperanza>
Message-ID: <alpine.DEB.2.11.1501261216120.16638@gentwo.org>
References: <cover.1422275084.git.vdavydov@parallels.com> <3804a429071f939e6b4f654b6c6426c1fdd95f7e.1422275084.git.vdavydov@parallels.com> <alpine.DEB.2.11.1501260944550.15849@gentwo.org> <20150126170147.GB28978@esperanza>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2015, Vladimir Davydov wrote:

> Anyways, I think that silently relying on the fact that the allocator
> never fails small allocations is kind of unreliable. What if this

We are not doing that though. If the allocation fails we do nothing.

> > > +			if (page->inuse < objects)
> > > +				list_move(&page->lru,
> > > +					  slabs_by_inuse + page->inuse);
> > >  			if (!page->inuse)
> > >  				n->nr_partial--;
> > >  		}
> >
> > The condition is always true. A page that has page->inuse == objects
> > would not be on the partial list.
> >
>
> This is in case we failed to allocate the slabs_by_inuse array. We only
> have a list for empty slabs then (on stack).

Ok in that case objects == 1. If you want to do this maybe do it in a more
general way?

You could allocate an array on the stack to deal with the common cases. I
believe an array of 32 objects would be fine to allocate and cover most of
the slab caches on the system? Would eliminate most of the allocations in
kmem_cache_shrink.


