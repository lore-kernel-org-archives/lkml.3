Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709AbaKFJSG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 04:18:06 -0500
Received: from mx2.parallels.com ([199.115.105.18]:40554 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbaKFJSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 04:18:00 -0500
Date: Thu, 6 Nov 2014 12:17:49 +0300
From: Vladimir Davydov <vdavydov@parallels.com>
To: Christoph Lameter <cl@linux.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm 8/8] slab: recharge slab pages to the allocating
 memory cgroup
Message-ID: <20141106091749.GB4839@esperanza>
References: <cover.1415046910.git.vdavydov@parallels.com>
 <fe7c55a7ff9bb8a1ddff0256f5404196c10bfd08.1415046910.git.vdavydov@parallels.com>
 <alpine.DEB.2.11.1411051242410.28485@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1411051242410.28485@gentwo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Wed, Nov 05, 2014 at 12:43:31PM -0600, Christoph Lameter wrote:
> On Mon, 3 Nov 2014, Vladimir Davydov wrote:
> 
> > +static __always_inline void slab_free(struct kmem_cache *cachep, void *objp);
> > +
> >  static __always_inline void *
> >  slab_alloc_node(struct kmem_cache *cachep, gfp_t flags, int nodeid,
> >  		   unsigned long caller)
> > @@ -3185,6 +3187,10 @@ slab_alloc_node(struct kmem_cache *cachep, gfp_t flags, int nodeid,
> >  		kmemcheck_slab_alloc(cachep, flags, ptr, cachep->object_size);
> >  		if (unlikely(flags & __GFP_ZERO))
> >  			memset(ptr, 0, cachep->object_size);
> > +		if (unlikely(memcg_kmem_recharge_slab(ptr, flags))) {
> > +			slab_free(cachep, ptr);
> > +			ptr = NULL;
> > +		}
> >  	}
> >
> >  	return ptr;
> > @@ -3250,6 +3256,10 @@ slab_alloc(struct kmem_cache *cachep, gfp_t flags, unsigned long caller)
> >  		kmemcheck_slab_alloc(cachep, flags, objp, cachep->object_size);
> >  		if (unlikely(flags & __GFP_ZERO))
> >  			memset(objp, 0, cachep->object_size);
> > +		if (unlikely(memcg_kmem_recharge_slab(objp, flags))) {
> > +			slab_free(cachep, objp);
> > +			objp = NULL;
> > +		}
> >  	}
> >
> 
> Please do not add code to the hotpaths if its avoidable. Can you charge
> the full slab only when allocated please?

I call memcg_kmem_recharge_slab only on alloc path. Free path isn't
touched. The overhead added is one function call. The function only
reads and compares two pointers under RCU most of time. This is
comparable to the overhead introduced by memcg_kmem_get_cache, which is
called in slab_alloc/slab_alloc_node earlier.

Anyways, if you think this is unacceptable, I don't mind dropping the
whole patch set and thinking more on how to fix this per-memcg caches
trickery. What do you think?

Thanks,
Vladimir
