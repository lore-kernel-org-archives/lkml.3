Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab3HEGYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 02:24:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:38068 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753923Ab3HEGYP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 02:24:15 -0400
X-IronPort-AV: E=Sophos;i="4.89,816,1367942400"; 
   d="scan'208";a="8119328"
Message-ID: <51FF44B7.8050704@cn.fujitsu.com>
Date: Mon, 05 Aug 2013 14:22:47 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: robert.moore@intel.com, lv.zheng@intel.com, rjw@sisk.pl, lenb@kernel.org,
        tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com
CC: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 RESEND 13/18] x86, numa, mem_hotplug: Skip all the
 regions the kernel resides in.
References: <1375434877-20704-1-git-send-email-tangchen@cn.fujitsu.com> <1375434877-20704-14-git-send-email-tangchen@cn.fujitsu.com>
In-Reply-To: <1375434877-20704-14-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/05 14:22:51,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/05 14:22:53
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi tj,

I have resent the v2 patch-set. Would you please give some more
comments about the memblock and x86 booting code modification ?

And I'm also discussing with the ACPICA guys about the implementation
on ACPI side. I hope we can catch up with 3.12 this time.

Thanks.

On 08/02/2013 05:14 PM, Tang Chen wrote:
> At early time, memblock will reserve some memory for the kernel,
> such as the kernel code and data segments, initrd file, and so on，
> which means the kernel resides in these memory regions.
>
> Even if these memory regions are hotpluggable, we should not
> mark them as hotpluggable. Otherwise the kernel won't have enough
> memory to boot.
>
> This patch finds out which memory regions the kernel resides in,
> and skip them when finding all hotpluggable memory regions.
>
> Signed-off-by: Tang Chen<tangchen@cn.fujitsu.com>
> Reviewed-by: Zhang Yanfei<zhangyanfei@cn.fujitsu.com>
> ---
>   mm/memory_hotplug.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
>   1 files changed, 45 insertions(+), 0 deletions(-)
>
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index ef9ccf8..10a30ef 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -31,6 +31,7 @@
>   #include<linux/firmware-map.h>
>   #include<linux/stop_machine.h>
>   #include<linux/acpi.h>
> +#include<linux/memblock.h>
>
>   #include<asm/tlbflush.h>
>
> @@ -93,6 +94,40 @@ static void release_memory_resource(struct resource *res)
>
>   #ifdef CONFIG_ACPI_NUMA
>   /**
> + * kernel_resides_in_range - Check if kernel resides in a memory region.
> + * @base: The base address of the memory region.
> + * @length: The length of the memory region.
> + *
> + * This function is used at early time. It iterates memblock.reserved and check
> + * if the kernel has used any memory in [@base, @base + @length).
> + *
> + * Return true if the kernel resides in the memory region, false otherwise.
> + */
> +static bool __init kernel_resides_in_region(phys_addr_t base, u64 length)
> +{
> +	int i;
> +	phys_addr_t start, end;
> +	struct memblock_region *region;
> +	struct memblock_type *reserved =&memblock.reserved;
> +
> +	for (i = 0; i<  reserved->cnt; i++) {
> +		region =&reserved->regions[i];
> +
> +		if (region->flags != MEMBLOCK_HOTPLUG)
> +			continue;
> +
> +		start = region->base;
> +		end = region->base + region->size;
> +		if (end<= base || start>= base + length)
> +			continue;
> +
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
> +/**
>    * find_hotpluggable_memory - Find out hotpluggable memory from ACPI SRAT.
>    *
>    * This function did the following:
> @@ -129,6 +164,16 @@ void __init find_hotpluggable_memory(void)
>
>   	while (ACPI_SUCCESS(acpi_hotplug_mem_affinity(srat_vaddr,&base,
>   						&size,&offset))) {
> +		/*
> +		 * At early time, memblock will reserve some memory for the
> +		 * kernel, such as the kernel code and data segments, initrd
> +		 * file, and so on，which means the kernel resides in these
> +		 * memory regions. These regions should not be hotpluggable.
> +		 * So do not mark them as hotpluggable.
> +		 */
> +		if (kernel_resides_in_region(base, size))
> +			continue;
> +
>   		/* Will mark hotpluggable memory regions here */
>   	}
>
