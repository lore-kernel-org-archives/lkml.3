Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab3IXNR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 09:17:59 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57326 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab3IXNR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 09:17:57 -0400
Message-ID: <524190DC.4060605@gmail.com>
Date: Tue, 24 Sep 2013 21:17:16 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>, lenb@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, mingo@elte.hu,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Toshi Kani <toshi.kani@hp.com>, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Thomas Renninger <trenn@suse.de>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>, Wen Congyang <wency@cn.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>, mina86@mina86.com,
        gong.chen@linux.intel.com, vasilis.liaskovitis@profitbricks.com,
        lwoodman@redhat.com, Rik van Riel <riel@redhat.com>,
        jweiner@redhat.com, prarit@redhat.com,
        "x86@kernel.org" <x86@kernel.org>, linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, linux-acpi@vger.kernel.org,
        imtangchen@gmail.com
Subject: Re: [PATCH 2/6] memblock: Introduce bottom-up allocation mode
References: <524162DA.30004@cn.fujitsu.com> <524163CF.3010303@cn.fujitsu.com> <20130924121725.GC2366@htj.dyndns.org>
In-Reply-To: <20130924121725.GC2366@htj.dyndns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello tejun,

On 09/24/2013 08:17 PM, Tejun Heo wrote:
> On Tue, Sep 24, 2013 at 06:05:03PM +0800, Zhang Yanfei wrote:
>> +/* Allocation direction */
>> +enum {
>> +	MEMBLOCK_DIRECTION_TOP_DOWN,
>> +	MEMBLOCK_DIRECTION_BOTTOM_UP,
>> +	NR_MEMLBOCK_DIRECTIONS
>> +};
>> +
>>  struct memblock_region {
>>  	phys_addr_t base;
>>  	phys_addr_t size;
>> @@ -35,6 +42,7 @@ struct memblock_type {
>>  };
>>  
>>  struct memblock {
>> +	int current_direction;  /* current allocation direction */
> 
> Just use boolean bottom_up here too?  No need for the constants.

OKay. Will try this way.

> 
>> @@ -20,6 +20,8 @@
>>  #include <linux/seq_file.h>
>>  #include <linux/memblock.h>
>>  
>> +#include <asm-generic/sections.h>
>> +
> 
> Why is the above added by this patch?

Oh, we use _end in this file which is defined in that header file.

> 
>>  /**
>> + * __memblock_find_range - find free area utility
>> + * @start: start of candidate range
>> + * @end: end of candidate range, can be %MEMBLOCK_ALLOC_{ANYWHERE|ACCESSIBLE}
>> + * @size: size of free area to find
>> + * @align: alignment of free area to find
>> + * @nid: nid of the free area to find, %MAX_NUMNODES for any node
>> + *
>> + * Utility called from memblock_find_in_range_node(), find free area bottom-up.
>> + *
>> + * RETURNS:
>> + * Found address on success, %0 on failure.
> 
> I don't think we prefix numeric literals with %.

OKay. Will remove %

> 
> ...
>> @@ -127,6 +162,10 @@ __memblock_find_range_rev(phys_addr_t start, phys_addr_t end,
>>   *
>>   * Find @size free area aligned to @align in the specified range and node.
>>   *
>> + * When allocation direction is bottom-up, the @start should be greater
>> + * than the end of the kernel image. Otherwise, it will be trimmed. And also,
>> + * if bottom-up allocation failed, will try to allocate memory top-down.
> 
> It'd be nice to explain that bottom-up allocation is limited to above
> kernel image and what it's used for here.

OK. Will add the comment.

> 
>> + *
>>   * RETURNS:
>>   * Found address on success, %0 on failure.
>>   */
>> @@ -134,6 +173,8 @@ phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t start,
>>  					phys_addr_t end, phys_addr_t size,
>>  					phys_addr_t align, int nid)
>>  {
>> +	int ret;
>> +
>>  	/* pump up @end */
>>  	if (end == MEMBLOCK_ALLOC_ACCESSIBLE)
>>  		end = memblock.current_limit;
>> @@ -142,6 +183,28 @@ phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t start,
>>  	start = max_t(phys_addr_t, start, PAGE_SIZE);
>>  	end = max(start, end);
>>  
>> +	if (memblock_bottom_up()) {
>> +		phys_addr_t bottom_up_start;
>> +
>> +		/* make sure we will allocate above the kernel */
>> +		bottom_up_start = max_t(phys_addr_t, start, __pa_symbol(_end));
>> +
>> +		/* ok, try bottom-up allocation first */
>> +		ret = __memblock_find_range(bottom_up_start, end,
>> +					    size, align, nid);
>> +		if (ret)
>> +			return ret;
>> +
>> +		/*
>> +		 * we always limit bottom-up allocation above the kernel,
>> +		 * but top-down allocation doesn't have the limit, so
>> +		 * retrying top-down allocation may succeed when bottom-up
>> +		 * allocation failed.
>> +		 */
>> +		pr_warn("memblock: Failed to allocate memory in bottom up "
>> +			"direction. Now try top down direction.\n");
> 
> Maybe just print warning only on the first failure?

Hmmm... This message is for each memblock allocation, that said, if the
allocation this time fails, it prints the message and we use so called top-down.
But next time, we still use bottom up first again.

Did you mean if we fail on one bottom-up allocation, then we never try
bottom-up again and will always use top-down? 

Thanks. 

> 
> Otherwise, looks good to me.
> 
> Thanks.
> 


-- 
Thanks.
Zhang Yanfei
