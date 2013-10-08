Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170Ab3JHRhF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 13:37:05 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:46641 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab3JHRhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 13:37:01 -0400
Message-ID: <525442A4.9060709@gmail.com>
Date: Wed, 09 Oct 2013 01:36:36 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J . Wysocki" <rjw@sisk.pl>, lenb@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, mingo@elte.hu,
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
        imtangchen@gmail.com, Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>
Subject: Re: [PATCH part1 v6 4/6] x86/mem-hotplug: Support initialize page
 tables in bottom-up
References: <524E2032.4020106@gmail.com> <524E2127.4090904@gmail.com> <5251F9AB.6000203@zytor.com>
In-Reply-To: <5251F9AB.6000203@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello tejun
CC: Peter

On 10/07/2013 08:00 AM, H. Peter Anvin wrote:
> On 10/03/2013 07:00 PM, Zhang Yanfei wrote:
>> From: Tang Chen <tangchen@cn.fujitsu.com>
>>
>> The Linux kernel cannot migrate pages used by the kernel. As a
>> result, kernel pages cannot be hot-removed. So we cannot allocate
>> hotpluggable memory for the kernel.
>>
>> In a memory hotplug system, any numa node the kernel resides in
>> should be unhotpluggable. And for a modern server, each node could
>> have at least 16GB memory. So memory around the kernel image is
>> highly likely unhotpluggable.
>>
>> ACPI SRAT (System Resource Affinity Table) contains the memory
>> hotplug info. But before SRAT is parsed, memblock has already
>> started to allocate memory for the kernel. So we need to prevent
>> memblock from doing this.
>>
>> So direct memory mapping page tables setup is the case. init_mem_mapping()
>> is called before SRAT is parsed. To prevent page tables being allocated
>> within hotpluggable memory, we will use bottom-up direction to allocate
>> page tables from the end of kernel image to the higher memory.
>>
>> Acked-by: Tejun Heo <tj@kernel.org>
>> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
>> Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> 
> I'm still seriously concerned about this.  This unconditionally
> introduces new behavior which may very well break some classes of
> systems -- the whole point of creating the page tables top down is
> because the kernel tends to be allocated in lower memory, which is also
> the memory that some devices need for DMA.
> 

After thinking for a while, this issue pointed by Peter seems to be really
existing. And looking back to what you suggested the allocation close to the
kernel, 

> so if we allocate memory close to the kernel image,
>   it's likely that we don't contaminate hotpluggable node.  We're
>   talking about few megs at most right after the kernel image.  I
>   can't see how that would make any noticeable difference.

You meant that the memory size is about few megs. But here, page tables
seems to be large enough in big memory machines, so that page tables will
consume the precious lower memory. So I think we may really reorder
the page table setup after we get the hotplug info in some way. Just like
we have done in patch 5, we reorder reserve_crashkernel() to be called
after initmem_init().

So do you still have any objection to the pagetable setup reorder?

-- 
Thanks.
Zhang Yanfei
