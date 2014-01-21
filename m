Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbaAUGQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 01:16:45 -0500
Received: from mail-yk0-f176.google.com ([209.85.160.176]:60347 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbaAUGQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 01:16:37 -0500
Date: Mon, 20 Jan 2014 22:16:33 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
cc: akpm@linux-foundation.org, hannes@cmpxchg.org, liuj97@gmail.com,
        santosh.shilimkar@ti.com, grygorii.strashko@ti.com,
        iamjoonsoo.kim@lge.com, robin.m.holt@gmail.com,
        tangchen@cn.fujitsu.com, yinghai@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V5 1/3] mm/nobootmem: Fix unused variable
In-Reply-To: <1390217559-14691-2-git-send-email-phacht@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.02.1401202214540.21729@chino.kir.corp.google.com>
References: <1390217559-14691-1-git-send-email-phacht@linux.vnet.ibm.com> <1390217559-14691-2-git-send-email-phacht@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jan 2014, Philipp Hachtmann wrote:

> diff --git a/mm/nobootmem.c b/mm/nobootmem.c
> index e2906a5..0215c77 100644
> --- a/mm/nobootmem.c
> +++ b/mm/nobootmem.c
> @@ -116,23 +116,29 @@ static unsigned long __init __free_memory_core(phys_addr_t start,
>  static unsigned long __init free_low_memory_core_early(void)
>  {
>  	unsigned long count = 0;
> -	phys_addr_t start, end, size;
> +	phys_addr_t start, end;
>  	u64 i;
>  
> +#ifdef CONFIG_ARCH_DISCARD_MEMBLOCK
> +	phys_addr_t size;
> +#endif
> +
>  	for_each_free_mem_range(i, NUMA_NO_NODE, &start, &end, NULL)
>  		count += __free_memory_core(start, end);
>  
>  #ifdef CONFIG_ARCH_DISCARD_MEMBLOCK
> -
> -	/* Free memblock.reserved array if it was allocated */
> -	size = get_allocated_memblock_reserved_regions_info(&start);
> -	if (size)
> -		count += __free_memory_core(start, start + size);
> -
> -	/* Free memblock.memory array if it was allocated */
> -	size = get_allocated_memblock_memory_regions_info(&start);
> -	if (size)
> -		count += __free_memory_core(start, start + size);
> +	{
> +		phys_addr_t size;

I think you may have misunderstood Andrew's suggestion: "size" here is 
overloading the "size" you have already declared for this configuration.

Not sure why you don't just do a one line patch:

-	phys_addr_t size;
+	phys_addr_t size __maybe_unused;

to fix it.

> +		/* Free memblock.reserved array if it was allocated */
> +		size = get_allocated_memblock_reserved_regions_info(&start);
> +		if (size)
> +			count += __free_memory_core(start, start + size);
> +		
> +		/* Free memblock.memory array if it was allocated */
> +		size = get_allocated_memblock_memory_regions_info(&start);
> +		if (size)
> +			count += __free_memory_core(start, start + size);
> +	}
>  #endif
>  
>  	return count;
