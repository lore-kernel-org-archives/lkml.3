Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbaFJKGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 06:06:47 -0400
Received: from mx2.parallels.com ([199.115.105.18]:39580 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbaFJKGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 06:06:45 -0400
Date: Tue, 10 Jun 2014 14:06:31 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: <akpm@linux-foundation.org>, <cl@linux.com>, <rientjes@google.com>,
        <penberg@kernel.org>, <hannes@cmpxchg.org>, <mhocko@suse.cz>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH -mm v2 3/8] memcg: mark caches that belong to offline
 memcgs as dead
Message-ID: <20140610100629.GB6293@esperanza>
References: <cover.1402060096.git.vdavydov@parallels.com>
 <9e6537847c22a5050f84bd2bf5633f7c022fb801.1402060096.git.vdavydov@parallels.com>
 <20140610074840.GF19036@js1304-P5Q-DELUXE>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140610074840.GF19036@js1304-P5Q-DELUXE>
X-Originating-IP: [81.5.110.170]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 04:48:40PM +0900, Joonsoo Kim wrote:
> On Fri, Jun 06, 2014 at 05:22:40PM +0400, Vladimir Davydov wrote:
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 886b5b414958..ed42fd1105a5 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -3294,6 +3294,7 @@ static void memcg_unregister_all_caches(struct mem_cgroup *memcg)
> >  	mutex_lock(&memcg_slab_mutex);
> >  	list_for_each_entry_safe(params, tmp, &memcg->memcg_slab_caches, list) {
> >  		cachep = memcg_params_to_cache(params);
> > +		cachep->memcg_params->dead = true;
> 
> I guess that this needs smp_wmb() and memcg_cache_dead() needs
> smp_rmb(), since we could call memcg_cache_dead() without holding any locks.

Good catch! Actually, I thought we always call on_each_cpu, which works
effectively as a full memory barrier, from kmem_cache_shrink, but that's
not always true for SLUB, so we do need the barriers here. Will fix in
the next iteration.

Thanks.
