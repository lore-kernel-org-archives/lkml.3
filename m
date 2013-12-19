Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab3LSJpe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 04:45:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46436 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897Ab3LSJp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 04:45:28 -0500
Date: Thu, 19 Dec 2013 10:45:27 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Vasily Averin <vvs@parallels.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>,
        Glauber Costa <glommer@gmail.com>, linux-kernel@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
        Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>, devel@openvz.org
Subject: Re: [Devel] [PATCH 1/6] slab: cleanup kmem_cache_create_memcg()
Message-ID: <20131219094527.GC10855@dhcp22.suse.cz>
References: <6f02b2d079ffd0990ae335339c803337b13ecd8c.1387372122.git.vdavydov@parallels.com>
 <52B2AB7C.1010803@parallels.com>
 <52B2B0A4.8050009@parallels.com>
 <52B2BBB4.3090209@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B2BBB4.3090209@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 19-12-13 13:26:12, Vasily Averin wrote:
> On 12/19/2013 12:39 PM, Vladimir Davydov wrote:
> > On 12/19/2013 12:17 PM, Vasily Averin wrote:
> >> On 12/18/2013 05:16 PM, Vladimir Davydov wrote:
> >>> --- a/mm/slab_common.c
> >>> +++ b/mm/slab_common.c
> >>> @@ -176,8 +176,9 @@ kmem_cache_create_memcg(struct mem_cgroup *memcg, const char *name, size_t size,
> >>>  	get_online_cpus();
> >>>  	mutex_lock(&slab_mutex);
> >>>  
> >>> -	if (!kmem_cache_sanity_check(memcg, name, size) == 0)
> >>> -		goto out_locked;
> >>> +	err = kmem_cache_sanity_check(memcg, name, size);
> >>> +	if (err)
> >>> +		goto out_unlock;
> >>>  
> >>>  	/*
> >>>  	 * Some allocators will constraint the set of valid flags to a subset
> >> Theoretically in future kmem_cache_sanity_check() can return positive value.
> >> Probably it's better to check (err < 0) in caller ?
> > 
> > Hmm, why? What information could positive retval carry here? We have
> > plenty of places throughout the code where we check for (err), not
> > (err<0), simply because it looks clearer, e.g. look at
> > __kmem_cache_create() calls. If it returns a positive value one day, we
> > will have to parse every place where it's called. Anyway, if someone
> > wants to change a function behavior, he must check every place where
> > this function is called and fix them accordingly.
> 
> I believe expected semantic of function -- return negative in case of error.
> So correct error cheek should be (err < 0).
> (err) check is semantically incorrect, and it can lead to troubles in future.

No, this function returns -ERRNO or 0 on success.

-- 
Michal Hocko
SUSE Labs
