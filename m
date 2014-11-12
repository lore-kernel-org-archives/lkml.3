Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543AbaKLGoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 01:44:34 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57345 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaKLGoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 01:44:32 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <546301A4.3090209@jp.fujitsu.com>
Date: Wed, 12 Nov 2014 15:43:48 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: <tony.luck@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Philipp Hachtmann <phacht@linux.vnet.ibm.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Emil Medve <Emilian.Medve@freescale.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: memblock: Refactor functions to set/clear MEMBLOCK_HOTPLUG
References: <54610c79308447c79c@agluck-desk.sc.intel.com>
In-Reply-To: <54610c79308447c79c@agluck-desk.sc.intel.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/11 4:05), tony.luck@intel.com wrote:
> There is a lot of duplication in the rubric around actually setting or
> clearing a mem region flag. Create a new helper function to do this and
> reduce each of memblock_mark_hotplug() and memblock_clear_hotplug() to
> a single line.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> 
> ---

The refactoring looks good.

Thanks,
Yasuaki Ishimatsu

> 
> This will be useful if someone were to add a new mem region flag - which
> I hope to be doing some day soon. But it looks like a plausible cleanup
> even without that - so I'd like to get it out of the way now.
> 
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 6ecb0d937fb5..252b77bdf65e 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -715,16 +715,13 @@ int __init_memblock memblock_reserve(phys_addr_t base, phys_addr_t size)
>   }
>   
>   /**
> - * memblock_mark_hotplug - Mark hotpluggable memory with flag MEMBLOCK_HOTPLUG.
> - * @base: the base phys addr of the region
> - * @size: the size of the region
>    *
> - * This function isolates region [@base, @base + @size), and mark it with flag
> - * MEMBLOCK_HOTPLUG.
> + * This function isolates region [@base, @base + @size), and sets/clears flag
>    *
>    * Return 0 on succees, -errno on failure.
>    */
> -int __init_memblock memblock_mark_hotplug(phys_addr_t base, phys_addr_t size)
> +static int __init_memblock memblock_setclr_flag(phys_addr_t base,
> +				phys_addr_t size, int set, int flag)
>   {
>   	struct memblock_type *type = &memblock.memory;
>   	int i, ret, start_rgn, end_rgn;
> @@ -734,37 +731,37 @@ int __init_memblock memblock_mark_hotplug(phys_addr_t base, phys_addr_t size)
>   		return ret;
>   
>   	for (i = start_rgn; i < end_rgn; i++)
> -		memblock_set_region_flags(&type->regions[i], MEMBLOCK_HOTPLUG);
> +		if (set)
> +			memblock_set_region_flags(&type->regions[i], flag);
> +		else
> +			memblock_clear_region_flags(&type->regions[i], flag);
>   
>   	memblock_merge_regions(type);
>   	return 0;
>   }
>   
>   /**
> - * memblock_clear_hotplug - Clear flag MEMBLOCK_HOTPLUG for a specified region.
> + * memblock_mark_hotplug - Mark hotpluggable memory with flag MEMBLOCK_HOTPLUG.
>    * @base: the base phys addr of the region
>    * @size: the size of the region
>    *
> - * This function isolates region [@base, @base + @size), and clear flag
> - * MEMBLOCK_HOTPLUG for the isolated regions.
> + * Return 0 on succees, -errno on failure.
> + */
> +int __init_memblock memblock_mark_hotplug(phys_addr_t base, phys_addr_t size)
> +{
> +	return memblock_setclr_flag(base, size, 1, MEMBLOCK_HOTPLUG);
> +}
> +
> +/**
> + * memblock_clear_hotplug - Clear flag MEMBLOCK_HOTPLUG for a specified region.
> + * @base: the base phys addr of the region
> + * @size: the size of the region
>    *
>    * Return 0 on succees, -errno on failure.
>    */
>   int __init_memblock memblock_clear_hotplug(phys_addr_t base, phys_addr_t size)
>   {
> -	struct memblock_type *type = &memblock.memory;
> -	int i, ret, start_rgn, end_rgn;
> -
> -	ret = memblock_isolate_range(type, base, size, &start_rgn, &end_rgn);
> -	if (ret)
> -		return ret;
> -
> -	for (i = start_rgn; i < end_rgn; i++)
> -		memblock_clear_region_flags(&type->regions[i],
> -					    MEMBLOCK_HOTPLUG);
> -
> -	memblock_merge_regions(type);
> -	return 0;
> +	return memblock_setclr_flag(base, size, 0, MEMBLOCK_HOTPLUG);
>   }
>   
>   /**
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 


