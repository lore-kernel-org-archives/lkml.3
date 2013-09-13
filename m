Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757Ab3IMVzU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 17:55:20 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:34706 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981Ab3IMVzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 17:55:19 -0400
Message-ID: <1379109208.13477.16.camel@misato.fc.hp.com>
Subject: Re: [PATCH v3 2/5] memblock: Improve memblock to support allocation
 from lower address.
From: Toshi Kani <toshi.kani@hp.com>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: rjw@sisk.pl, lenb@kernel.org, tglx@linutronix.de, mingo@elte.hu,
        hpa@zytor.com, akpm@linux-foundation.org, tj@kernel.org,
        zhangyanfei@cn.fujitsu.com, liwanp@linux.vnet.ibm.com, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org
Date: Fri, 13 Sep 2013 15:53:28 -0600
In-Reply-To: <1379064655-20874-3-git-send-email-tangchen@cn.fujitsu.com>
References: <1379064655-20874-1-git-send-email-tangchen@cn.fujitsu.com>
	 <1379064655-20874-3-git-send-email-tangchen@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-09-13 at 17:30 +0800, Tang Chen wrote:
 :
> @@ -100,8 +180,7 @@ phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t start,
>  					phys_addr_t end, phys_addr_t size,
>  					phys_addr_t align, int nid)
>  {
> -	phys_addr_t this_start, this_end, cand;
> -	u64 i;
> +	phys_addr_t ret;
>  
>  	/* pump up @end */
>  	if (end == MEMBLOCK_ALLOC_ACCESSIBLE)
> @@ -111,18 +190,22 @@ phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t start,
>  	start = max_t(phys_addr_t, start, PAGE_SIZE);
>  	end = max(start, end);
>  
> -	for_each_free_mem_range_reverse(i, nid, &this_start, &this_end, NULL) {
> -		this_start = clamp(this_start, start, end);
> -		this_end = clamp(this_end, start, end);
> +	if (memblock_direction_bottom_up()) {
> +		/*
> +		 * MEMBLOCK_ALLOC_ACCESSIBLE is 0, which is less than the end
> +		 * of kernel image. So callers specify MEMBLOCK_ALLOC_ACCESSIBLE
> +		 * as @start is OK.
> +		 */
> +		start =	max(start, __pa_symbol(_end)); /* End of kernel image. */
>  
> -		if (this_end < size)
> -			continue;
> +		ret = __memblock_find_range(start, end, size, align, nid);
> +		if (ret)
> +			return ret;
>  
> -		cand = round_down(this_end - size, align);
> -		if (cand >= this_start)
> -			return cand;
> +		pr_warn("memblock: Failed to allocate memory in bottom up direction. Now try top down direction.\n");

Is there any chance that this retry will succeed given that start and
end are still the same?

Thanks,
-Toshi


>  	}
> -	return 0;
> +
> +	return __memblock_find_range_rev(start, end, size, align, nid);
>  }
>  
>  /**


