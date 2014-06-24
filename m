Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbaFXIZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 04:25:39 -0400
Received: from mx2.parallels.com ([199.115.105.18]:60860 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbaFXIZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 04:25:38 -0400
Date: Tue, 24 Jun 2014 12:25:26 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: <akpm@linux-foundation.org>, <cl@linux.com>, <rientjes@google.com>,
        <penberg@kernel.org>, <hannes@cmpxchg.org>, <mhocko@suse.cz>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH -mm v3 7/8] slub: make dead memcg caches discard free
 slabs immediately
Message-ID: <20140624082526.GD18121@esperanza>
References: <cover.1402602126.git.vdavydov@parallels.com>
 <d4608a7a00080a51740d747703af5462f1255176.1402602126.git.vdavydov@parallels.com>
 <20140624075011.GD4836@js1304-P5Q-DELUXE>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140624075011.GD4836@js1304-P5Q-DELUXE>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 04:50:11PM +0900, Joonsoo Kim wrote:
> On Fri, Jun 13, 2014 at 12:38:21AM +0400, Vladimir Davydov wrote:
> > @@ -3409,6 +3417,9 @@ int __kmem_cache_shrink(struct kmem_cache *s)
> >  		kmalloc(sizeof(struct list_head) * objects, GFP_KERNEL);
> >  	unsigned long flags;
> >  
> > +	if (memcg_cache_dead(s))
> > +		s->min_partial = 0;
> > +
> >  	if (!slabs_by_inuse) {
> >  		/*
> >  		 * Do not fail shrinking empty slabs if allocation of the
> 
> I think that you should move down n->nr_partial test after holding the
> lock in __kmem_cache_shrink(). Access to n->nr_partial without node lock
> is racy and you can see wrong value. It results in skipping to free empty
> slab so your destroying logic could fail.

You're right! Will fix this.

And there seems to be the same problem in SLAB, where we check
node->slabs_free list emptiness w/o holding node->list_lock (see
drain_freelist) while it can be modified concurrently by free_block.
This will be fixed automatically after we make __kmem_cache_shrink unset
node->free_limit (which must be done under the lock) though.

Thank you!
