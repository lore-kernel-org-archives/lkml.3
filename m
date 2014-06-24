Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbaFXHtF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 03:49:05 -0400
Received: from mx2.parallels.com ([199.115.105.18]:44980 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbaFXHtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 03:49:03 -0400
Date: Tue, 24 Jun 2014 11:48:53 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: <akpm@linux-foundation.org>, <cl@linux.com>, <rientjes@google.com>,
        <penberg@kernel.org>, <hannes@cmpxchg.org>, <mhocko@suse.cz>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH -mm v3 8/8] slab: do not keep free objects/slabs on dead
 memcg caches
Message-ID: <20140624074853.GB18121@esperanza>
References: <cover.1402602126.git.vdavydov@parallels.com>
 <a985aec824cd35df381692fca83f7a8debc80305.1402602126.git.vdavydov@parallels.com>
 <20140624073840.GC4836@js1304-P5Q-DELUXE>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140624073840.GC4836@js1304-P5Q-DELUXE>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 04:38:41PM +0900, Joonsoo Kim wrote:
> On Fri, Jun 13, 2014 at 12:38:22AM +0400, Vladimir Davydov wrote:
> > @@ -3462,6 +3474,17 @@ static inline void __cache_free(struct kmem_cache *cachep, void *objp,
> >  
> >  	kmemcheck_slab_free(cachep, objp, cachep->object_size);
> >  
> > +#ifdef CONFIG_MEMCG_KMEM
> > +	if (unlikely(!ac)) {
> > +		int nodeid = page_to_nid(virt_to_page(objp));
> > +
> > +		spin_lock(&cachep->node[nodeid]->list_lock);
> > +		free_block(cachep, &objp, 1, nodeid);
> > +		spin_unlock(&cachep->node[nodeid]->list_lock);
> > +		return;
> > +	}
> > +#endif
> > +
> 
> And, please document intention of this code. :)

Sure.

> And, you said that this way of implementation would be slow because
> there could be many object in dead caches and this implementation
> needs node spin_lock on each object freeing. Is it no problem now?

It may be :(

> If you have any performance data about this implementation and
> alternative one, could you share it?

I haven't (shame on me!). I'll do some testing today and send you the
results.

Thanks.
