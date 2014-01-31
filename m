Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbaAaKm3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 05:42:29 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:42644 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbaAaKm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 05:42:27 -0500
Date: Fri, 31 Jan 2014 02:42:25 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vladimir Davydov <vdavydov@parallels.com>
cc: Andrew Morton <akpm@linux-foundation.org>, mhocko@suse.cz,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: fix mutex not unlocked on memcg_create_kmem_cache
 fail path
In-Reply-To: <52EB487B.6040701@parallels.com>
Message-ID: <alpine.DEB.2.02.1401310241080.7183@chino.kir.corp.google.com>
References: <1391097693-31401-1-git-send-email-vdavydov@parallels.com> <20140130130129.6f8bd7fd9da55d17a9338443@linux-foundation.org> <alpine.DEB.2.02.1401301310270.15271@chino.kir.corp.google.com> <20140130132939.96a25a37016a12f9a0093a90@linux-foundation.org>
 <alpine.DEB.2.02.1401301336530.15271@chino.kir.corp.google.com> <20140130135002.22ce1c12b7136f75e5985df6@linux-foundation.org> <alpine.DEB.2.02.1401301403090.15271@chino.kir.corp.google.com> <20140130140902.93d35d866f9ea1c697811f6e@linux-foundation.org>
 <alpine.DEB.2.02.1401301411590.15271@chino.kir.corp.google.com> <20140130141538.a9e3977b5e7b76bdcf59a15f@linux-foundation.org> <alpine.DEB.2.02.1401301438500.12223@chino.kir.corp.google.com> <52EB487B.6040701@parallels.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jan 2014, Vladimir Davydov wrote:

> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -637,6 +637,9 @@ int memcg_limited_groups_array_size;
> >   * better kept as an internal representation in cgroup.c. In any case, the
> >   * cgrp_id space is not getting any smaller, and we don't have to necessarily
> >   * increase ours as well if it increases.
> > + *
> > + * Updates to MAX_SIZE should update the space for the memcg name in
> > + * memcg_create_kmem_cache().
> >   */
> >  #define MEMCG_CACHES_MIN_SIZE 4
> >  #define MEMCG_CACHES_MAX_SIZE MEM_CGROUP_ID_MAX
> > @@ -3400,8 +3403,10 @@ void mem_cgroup_destroy_cache(struct kmem_cache *cachep)
> >  static struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *memcg,
> >  						  struct kmem_cache *s)
> >  {
> > -	char *name = NULL;
> >  	struct kmem_cache *new;
> > +	const char *cgrp_name;
> > +	char *name = NULL;
> > +	size_t len;
> >  
> >  	BUG_ON(!memcg_can_account_kmem(memcg));
> >  
> > @@ -3409,9 +3414,22 @@ static struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *memcg,
> >  	if (unlikely(!name))
> >  		return NULL;
> >  
> > +	/*
> > +	 * Format of a memcg's kmem cache name:
> > +	 * <cache-name>(<memcg-id>:<cgroup-name>)
> > +	 */
> > +	len = strlen(s->name);
> > +	/* Space for parentheses, colon, terminator */
> > +	len += 4;
> > +	/* MEMCG_CACHES_MAX_SIZE is USHRT_MAX */
> > +	len += 5;
> > +	BUILD_BUG_ON(MEMCG_CACHES_MAX_SIZE > USHRT_MAX);
> > +
> 
> This looks cumbersome, IMO. Let's leave it as is for now. AFAIK,
> cgroup_name() will be reworked soon so that it won't require RCU-context
> (https://lkml.org/lkml/2014/1/28/530). Therefore, it will be possible to
> get rid of this pointless tmp_name allocation by making
> kmem_cache_create_memcg() take not just name, but printf-like format +
> vargs.
> 

You believe it's less cumbersome to do two memory allocations to figure 
out how much memory you really need to allocate rather than just 
calculating the necessary size?
