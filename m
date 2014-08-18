Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbaHRDVb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 23:21:31 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:58821 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaHRDV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 23:21:29 -0400
Message-ID: <53F17068.5000005@huawei.com>
Date: Mon, 18 Aug 2014 11:18:00 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: tangchen <tangchen@cn.fujitsu.com>
CC: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mem-hotplug: let memblock skip the hotpluggable memory
 regions in __next_mem_range()
References: <53E8C5AA.5040506@huawei.com> <20140816130456.GH9305@htj.dyndns.org> <53EF6C79.3000603@huawei.com> <20140817110821.GM9305@htj.dyndns.org> <53F15330.5070606@cn.fujitsu.com>
In-Reply-To: <53F15330.5070606@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.25.179]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020204.53F170E8.00DD,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: d09b3ad69fc51ce95d8baab4901da055
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/8/18 9:13, tangchen wrote:

> Hi tj,
> 
> On 08/17/2014 07:08 PM, Tejun Heo wrote:
>> Hello,
>>
>> On Sat, Aug 16, 2014 at 10:36:41PM +0800, Xishi Qiu wrote:
>>> numa_clear_node_hotplug()? There is only numa_clear_kernel_node_hotplug().
>> Yeah, that one.
>>
>>> If we don't clear hotpluggable flag in free_low_memory_core_early(), the
>>> memory which marked hotpluggable flag will not free to buddy allocator.
>>> Because __next_mem_range() will skip them.
>>>
>>> free_low_memory_core_early
>>>     for_each_free_mem_range
>>>         for_each_mem_range
>>>             __next_mem_range       
>> Ah, okay, so the patch fixes __next_mem_range() and thus makes
>> free_low_memory_core_early() to skip hotpluggable regions unlike
>> before.  Please explain things like that in the changelog.  Also,
>> what's its relationship with numa_clear_kernel_node_hotplug()?  Do we
>> still need them?  If so, what are the different roles that these two
>> separate places serve?
> 
> numa_clear_kernel_node_hotplug() only clears hotplug flags for the nodes
> the kernel resides in, not for hotpluggable nodes. The reason why we did
> this is to enable the kernel to allocate memory in case all the nodes are
> hotpluggable.
> 

Hi TangChen,

I find a problem in numa_init() (arch/x86/mm/numa.c)
numa_init()
	...
	ret = init_func();  // this will mark hotpluggable flag from SRAT
	...
	memblock_set_bottom_up(false);
	...
	ret = numa_register_memblks(&numa_meminfo);  // this will alloc node data(pglist_data) 
	...
	numa_clear_kernel_node_hotplug();  // in case all the nodes are hotpluggable
	...

If all the nodes are marked hotpluggable flag, alloc node data will fail.
Because __next_mem_range_rev() will skip the hotpluggable memory regions.
numa_register_memblks()
	setup_node_data()
		memblock_find_in_range_node()
			__memblock_find_range_top_down()
				for_each_mem_range_rev()
					__next_mem_range_rev()

What do you think?
How about move numa_clear_kernel_node_hotplug() into numa_register_memblks(),
like this:

numa_register_memblks()

...
                memblock_set_node(mb->start, mb->end - mb->start,
                                  &memblock.reserved, mb->nid);
        }

+        numa_clear_kernel_node_hotplug();

        /*
         * If sections array is gonna be used for pfn -> nid mapping, check
...

Thanks,
Xishi Qiu

> And we clear hotplug flags for all the nodes in free_low_memory_core_early()
> is because if we do not, all hotpluggable memory won't be able to be freed
> to buddy after Qiu's patch.
> 
> Thanks.
> 
> 
> .
> 



