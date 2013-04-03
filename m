Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759578Ab3DCOAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:00:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44061 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758531Ab3DCOAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:00:52 -0400
Date: Wed, 3 Apr 2013 16:00:49 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Robin Holt <holt@sgi.com>
Cc: Cliff Wickman <cpw@sgi.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, wli@holomorphy.com
Subject: Re: [PATCH] mm, x86: Do not zero hugetlbfs pages at boot. -v2
Message-ID: <20130403140049.GI16471@dhcp22.suse.cz>
References: <E1UDME8-00041J-B4@eag09.americas.sgi.com>
 <20130314085138.GA11636@dhcp22.suse.cz>
 <20130403024344.GA4384@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130403024344.GA4384@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 02-04-13 21:43:44, Robin Holt wrote:
[...]
> diff --git a/mm/bootmem.c b/mm/bootmem.c
> index 2b0bcb0..b2e4027 100644
> --- a/mm/bootmem.c
> +++ b/mm/bootmem.c
> @@ -705,12 +705,16 @@ void * __init __alloc_bootmem(unsigned long size, unsigned long align,
>  
>  void * __init ___alloc_bootmem_node_nopanic(pg_data_t *pgdat,
>  				unsigned long size, unsigned long align,
> -				unsigned long goal, unsigned long limit)
> +				unsigned long goal, unsigned long limit,
> +				int zeroed)
>  {
>  	void *ptr;
>  
>  	if (WARN_ON_ONCE(slab_is_available()))
> -		return kzalloc(size, GFP_NOWAIT);
> +		if (zeroed)
> +			return kzalloc(size, GFP_NOWAIT);
> +		else
> +			return kmalloc(size, GFP_NOWAIT);
>  again:
>  
>  	/* do not panic in alloc_bootmem_bdata() */

You need to update alloc_bootmem_bdata and alloc_bootmem_core as well.
Otherwise this is a no-op for early allocations when slab is not
available which is the case unless something is broken.

[...]
-- 
Michal Hocko
SUSE Labs
