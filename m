Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933484Ab3DDIRI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 04:17:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54655 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764005Ab3DDIRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 04:17:04 -0400
Date: Thu, 4 Apr 2013 10:17:02 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Robin Holt <holt@sgi.com>
Cc: Cliff Wickman <cpw@sgi.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, wli@holomorphy.com
Subject: Re: [PATCH] mm, x86: Do not zero hugetlbfs pages at boot. -v2
Message-ID: <20130404081702.GD29911@dhcp22.suse.cz>
References: <E1UDME8-00041J-B4@eag09.americas.sgi.com>
 <20130314085138.GA11636@dhcp22.suse.cz>
 <20130403024344.GA4384@sgi.com>
 <20130403140049.GI16471@dhcp22.suse.cz>
 <20130403172132.GZ29151@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130403172132.GZ29151@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 03-04-13 12:21:32, Robin Holt wrote:
> On Wed, Apr 03, 2013 at 04:00:49PM +0200, Michal Hocko wrote:
> > On Tue 02-04-13 21:43:44, Robin Holt wrote:
> > [...]
> > > diff --git a/mm/bootmem.c b/mm/bootmem.c
> > > index 2b0bcb0..b2e4027 100644
> > > --- a/mm/bootmem.c
> > > +++ b/mm/bootmem.c
> > > @@ -705,12 +705,16 @@ void * __init __alloc_bootmem(unsigned long size, unsigned long align,
> > >  
> > >  void * __init ___alloc_bootmem_node_nopanic(pg_data_t *pgdat,
> > >  				unsigned long size, unsigned long align,
> > > -				unsigned long goal, unsigned long limit)
> > > +				unsigned long goal, unsigned long limit,
> > > +				int zeroed)
> > >  {
> > >  	void *ptr;
> > >  
> > >  	if (WARN_ON_ONCE(slab_is_available()))
> > > -		return kzalloc(size, GFP_NOWAIT);
> > > +		if (zeroed)
> > > +			return kzalloc(size, GFP_NOWAIT);
> > > +		else
> > > +			return kmalloc(size, GFP_NOWAIT);
> > >  again:
> > >  
> > >  	/* do not panic in alloc_bootmem_bdata() */
> > 
> > You need to update alloc_bootmem_bdata and alloc_bootmem_core as well.
> > Otherwise this is a no-op for early allocations when slab is not
> > available which is the case unless something is broken.
> 
> Michal,
> 
> Does this do what you would expect?  

yes, it looks right when I quickly glanced over it. I haven't checked
deeply yet. I would suggest reposting and adding more *bootmem people
into CC (e.g. Johannes Weiner, Yinghai Lu, Tejun Heo and maybe others).

> I compiled this for ia64, but I have not tested it at all.
> 
> Robin
> 
> ---
>  mm/bootmem.c | 30 +++++++++++++++++++-----------
>  1 file changed, 19 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/bootmem.c b/mm/bootmem.c
> index b2e4027..350e0ab 100644
> --- a/mm/bootmem.c
> +++ b/mm/bootmem.c
> @@ -497,7 +497,8 @@ static unsigned long __init align_off(struct bootmem_data *bdata,
>  
>  static void * __init alloc_bootmem_bdata(struct bootmem_data *bdata,
>  					unsigned long size, unsigned long align,
> -					unsigned long goal, unsigned long limit)
> +					unsigned long goal, unsigned long limit,
> +					int zeroed)
>  {
>  	unsigned long fallback = 0;
>  	unsigned long min, max, start, sidx, midx, step;
> @@ -584,7 +585,8 @@ find_block:
>  
>  		region = phys_to_virt(PFN_PHYS(bdata->node_min_pfn) +
>  				start_off);
> -		memset(region, 0, size);
> +		if (zeroed)
> +			memset(region, 0, size);
>  		/*
>  		 * The min_count is set to 0 so that bootmem allocated blocks
>  		 * are never reported as leaks.
> @@ -605,13 +607,18 @@ find_block:
>  static void * __init alloc_bootmem_core(unsigned long size,
>  					unsigned long align,
>  					unsigned long goal,
> -					unsigned long limit)
> +					unsigned long limit,
> +					int zeroed)
>  {
>  	bootmem_data_t *bdata;
>  	void *region;
>  
> -	if (WARN_ON_ONCE(slab_is_available()))
> -		return kzalloc(size, GFP_NOWAIT);
> +	if (WARN_ON_ONCE(slab_is_available())) {
> +		if (zeroed)
> +			return kzalloc(size, GFP_NOWAIT);
> +		else
> +			return kmalloc(size, GFP_NOWAIT);
> +	}
>  
>  	list_for_each_entry(bdata, &bdata_list, list) {
>  		if (goal && bdata->node_low_pfn <= PFN_DOWN(goal))
> @@ -619,7 +626,7 @@ static void * __init alloc_bootmem_core(unsigned long size,
>  		if (limit && bdata->node_min_pfn >= PFN_DOWN(limit))
>  			break;
>  
> -		region = alloc_bootmem_bdata(bdata, size, align, goal, limit);
> +		region = alloc_bootmem_bdata(bdata, size, align, goal, limit, zeroed);
>  		if (region)
>  			return region;
>  	}
> @@ -635,7 +642,7 @@ static void * __init ___alloc_bootmem_nopanic(unsigned long size,
>  	void *ptr;
>  
>  restart:
> -	ptr = alloc_bootmem_core(size, align, goal, limit);
> +	ptr = alloc_bootmem_core(size, align, goal, limit, 1);
>  	if (ptr)
>  		return ptr;
>  	if (goal) {
> @@ -710,22 +717,23 @@ void * __init ___alloc_bootmem_node_nopanic(pg_data_t *pgdat,
>  {
>  	void *ptr;
>  
> -	if (WARN_ON_ONCE(slab_is_available()))
> +	if (WARN_ON_ONCE(slab_is_available())) {
>  		if (zeroed)
>  			return kzalloc(size, GFP_NOWAIT);
>  		else
>  			return kmalloc(size, GFP_NOWAIT);
> +	}
>  again:
>  
>  	/* do not panic in alloc_bootmem_bdata() */
>  	if (limit && goal + size > limit)
>  		limit = 0;
>  
> -	ptr = alloc_bootmem_bdata(pgdat->bdata, size, align, goal, limit);
> +	ptr = alloc_bootmem_bdata(pgdat->bdata, size, align, goal, limit, zeroed);
>  	if (ptr)
>  		return ptr;
>  
> -	ptr = alloc_bootmem_core(size, align, goal, limit);
> +	ptr = alloc_bootmem_core(size, align, goal, limit, zeroed);
>  	if (ptr)
>  		return ptr;
>  
> @@ -813,7 +821,7 @@ void * __init __alloc_bootmem_node_high(pg_data_t *pgdat, unsigned long size,
>  
>  		new_goal = MAX_DMA32_PFN << PAGE_SHIFT;
>  		ptr = alloc_bootmem_bdata(pgdat->bdata, size, align,
> -						 new_goal, 0);
> +						 new_goal, 0, 1);
>  		if (ptr)
>  			return ptr;
>  	}
> -- 
> 1.8.1.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Michal Hocko
SUSE Labs
