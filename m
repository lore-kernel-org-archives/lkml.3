Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723Ab3FIVhW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 17:37:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51567 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449Ab3FIVhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 17:37:21 -0400
Date: Sun, 9 Jun 2013 14:37:18 -0700
From: Tejun Heo <tj@kernel.org>
To: Wang YanQing <udknight@gmail.com>, akpm@linux-foundation.org,
        yinghai@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        liwanp@linux.vnet.ibm.com, tangchen@cn.fujitsu.com
Subject: Re: [PATCH]memblock: do double array and add merge directly path in
 memblock_insert_region
Message-ID: <20130609213718.GA8045@mtj.dyndns.org>
References: <20130609173430.GA2592@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130609173430.GA2592@udknight>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jun 10, 2013 at 01:34:30AM +0800, Wang YanQing wrote:
> If we allow do merge directly when insertion, we can get better performance,
> this patch add support to do merge directly in memblock_insert_region.

Do you have actual case where performance in this patch is
problematic?

> -static void __init_memblock memblock_insert_region(struct memblock_type *type,
> +static int __init_memblock memblock_insert_region(struct memblock_type *type,
>  						   int idx, phys_addr_t base,
> -						   phys_addr_t size, int nid)
> +						   phys_addr_t size, int nid, int merge)

bool merge and you need to update comment accordingly.

>  {
>  	struct memblock_region *rgn = &type->regions[idx];
>  
> -	BUG_ON(type->cnt >= type->max);
> +	if (merge && (base + size) == rgn->base &&
> +	        nid == memblock_get_region_node(rgn)) {
> +		rgn->base = base;
> +		rgn->size += size;
> +		type->total_size += size;
> +		return 0;
> +	}

What if merge is from upside down or this connects two disjoint
regions?

>  static int __init_memblock memblock_add_region(struct memblock_type *type,
>  				phys_addr_t base, phys_addr_t size, int nid)
...
>  		if (rbase > base) {
> -			nr_new++;
> -			if (insert)
> -				memblock_insert_region(type, i++, base,
> -						       rbase - base, nid);
> +			ret = memblock_insert_region(type, i++, base,
> +					rbase - base, nid, 1);
> +			if (ret) {
> +				return ret;
> +			}

Superflous { } and you need roll back what you've done upto this point
before returning.  That's the reason why the function is structured
the way it is.  If insertion fails due to array expansion failure, the
previous code doesn't change the memblock tables at all.  Your new
code leaves it half-updated.

> @@ -498,8 +488,11 @@ static int __init_memblock memblock_isolate_range(struct memblock_type *type,
>  			rgn->base = base;
>  			rgn->size -= base - rbase;
>  			type->total_size -= base - rbase;
> -			memblock_insert_region(type, i, rbase, base - rbase,
> -					       memblock_get_region_node(rgn));
> +			ret = memblock_insert_region(type, i, rbase, base - rbase,
> +					memblock_get_region_node(rgn), 0);
> +			if (ret) {
> +				return ret;
> +			}

Ditto, you need to roll back on failure.

> @@ -533,6 +529,7 @@ static int __init_memblock __memblock_remove(struct memblock_type *type,
>  
>  	for (i = end_rgn - 1; i >= start_rgn; i--)
>  		memblock_remove_region(type, i);
> +	memblock_merge_regions(type);

Why is this added?

Thanks.

-- 
tejun
