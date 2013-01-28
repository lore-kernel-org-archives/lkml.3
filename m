Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221Ab3A1Byl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 20:54:41 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:41568 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756457Ab3A1Byi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 20:54:38 -0500
X-IronPort-AV: E=Sophos;i="4.84,549,1355068800"; 
   d="scan'208";a="6651265"
Message-ID: <5105DA2A.9030105@cn.fujitsu.com>
Date: Mon, 28 Jan 2013 09:53:46 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: jiang.liu@huawei.com, wujianguo@huawei.com, hpa@zytor.com,
        wency@cn.fujitsu.com, laijs@cn.fujitsu.com, linfeng@cn.fujitsu.com,
        yinghai@kernel.org, isimatu.yasuaki@jp.fujitsu.com, rob@landley.net,
        kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, mgorman@suse.de,
        rientjes@google.com, guz.fnst@cn.fujitsu.com, rusty@rustcorp.com.au,
        lliubbo@gmail.com, jaegeuk.hanse@gmail.com, tony.luck@intel.com,
        glommer@parallels.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 2/3] acpi, memory-hotplug: Extend movablemem_map ranges
 to the end of node.
References: <1359106929-3034-1-git-send-email-tangchen@cn.fujitsu.com> <1359106929-3034-3-git-send-email-tangchen@cn.fujitsu.com> <20130125163615.4f82bf9d.akpm@linux-foundation.org>
In-Reply-To: <20130125163615.4f82bf9d.akpm@linux-foundation.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/28 09:53:29,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/28 09:53:32,
	Serialize complete at 2013/01/28 09:53:32
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On 01/26/2013 08:36 AM, Andrew Morton wrote:
>
> The patch generates a bunch of rejects, partly due to linux-next
> changes but I think I fixed everything up OK.

Thank you for your fixing. :)

>
>> index 4ddf497..f841d0e 100644
>> --- a/arch/x86/mm/srat.c
>> +++ b/arch/x86/mm/srat.c
>> @@ -141,11 +141,16 @@ static inline int save_add_info(void) {return 1;}
>>   static inline int save_add_info(void) {return 0;}
>>   #endif
>>
>> +#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
>> +extern struct movablemem_map movablemem_map;
>> +#endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
>
> Well.
>
> a) we shouldn't put extern declarations in C files - put them in
>     headers so we can be assured that all compilation units agree on the
>     type.

OK, got it. :)

>
> b) the ifdefs are unneeded - a unused extern declaration is OK (as
>     long as the type itself is always defined!)

I think struct movablemem_map is defined in mm.h, protected by 
CONFIG_HAVE_MEMBLOCK_NODE_MAP.
So the declaration needs to be protected by CONFIG_HAVE_MEMBLOCK_NODE_MAP.

>
> c) movablemem_map is already declared in memblock.h.

Hum, yes, it is defined in mm.h, included by memblock.h :)

>
> So I zapped the above three lines.
>
>> @@ -178,9 +185,57 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
>>
>>   	node_set(node, numa_nodes_parsed);
>>
>> -	printk(KERN_INFO "SRAT: Node %u PXM %u [mem %#010Lx-%#010Lx]\n",
>> +	printk(KERN_INFO "SRAT: Node %u PXM %u [mem %#010Lx-%#010Lx] %s\n",
>>   	       node, pxm,
>> -	       (unsigned long long) start, (unsigned long long) end - 1);
>> +	       (unsigned long long) start, (unsigned long long) end - 1,
>> +	       hotpluggable ? "Hot Pluggable": "");
>> +
>> +#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
>> +	int overlap;
>> +	unsigned long start_pfn, end_pfn;
>
> no, we don't put declarations of locals in the middle of C statements
> like this:
>
> arch/x86/mm/srat.c: In function 'acpi_numa_memory_affinity_init':
> arch/x86/mm/srat.c:185: warning: ISO C90 forbids mixed declarations and code
>
> Did your compiler not emit this warning?

Sorry, I think it did, but I missed it.
THanks for fixing that. :)

>
> I fixed this by moving the code into a new function
> "handle_movablemem".  Feel free to suggest a more appropriate name!
>
>
> From: Andrew Morton<akpm@linux-foundation.org>
> Subject: acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node-fix
>
> clean up code, fix build warning
>
> Cc: "Brown, Len"<len.brown@intel.com>
> Cc: "H. Peter Anvin"<hpa@zytor.com>
> Cc: Ingo Molnar<mingo@elte.hu>
> Cc: Jiang Liu<jiang.liu@huawei.com>
> Cc: Jianguo Wu<wujianguo@huawei.com>
> Cc: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> Cc: Kamezawa Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Lai Jiangshan<laijs@cn.fujitsu.com>
> Cc: Len Brown<lenb@kernel.org>
> Cc: Tang Chen<tangchen@cn.fujitsu.com>
> Cc: Thomas Gleixner<tglx@linutronix.de>
> Cc: Wu Jianguo<wujianguo@huawei.com>
> Cc: Yasuaki Ishimatsu<isimatu.yasuaki@jp.fujitsu.com>
> Signed-off-by: Andrew Morton<akpm@linux-foundation.org>
> ---
>
>   arch/x86/mm/srat.c |   93 ++++++++++++++++++++++---------------------
>   1 file changed, 49 insertions(+), 44 deletions(-)
>
> diff -puN arch/x86/mm/srat.c~acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node-fix arch/x86/mm/srat.c
> --- a/arch/x86/mm/srat.c~acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node-fix
> +++ a/arch/x86/mm/srat.c
> @@ -142,50 +142,8 @@ static inline int save_add_info(void) {r
>   #endif
>
>   #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
> -extern struct movablemem_map movablemem_map;
> -#endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
> -
> -/* Callback for parsing of the Proximity Domain<->  Memory Area mappings */
> -int __init
> -acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
> +static void __init handle_movablemem(int node, u64 start, u64 end)
>   {
> -	u64 start, end;
> -	u32 hotpluggable;
> -	int node, pxm;
> -
> -	if (srat_disabled())
> -		goto out_err;
> -	if (ma->header.length != sizeof(struct acpi_srat_mem_affinity))
> -		goto out_err_bad_srat;
> -	if ((ma->flags&  ACPI_SRAT_MEM_ENABLED) == 0)
> -		goto out_err;
> -	hotpluggable = ma->flags&  ACPI_SRAT_MEM_HOT_PLUGGABLE;
> -	if (hotpluggable&&  !save_add_info())
> -		goto out_err;
> -
> -	start = ma->base_address;
> -	end = start + ma->length;
> -	pxm = ma->proximity_domain;
> -	if (acpi_srat_revision<= 1)
> -		pxm&= 0xff;
> -
> -	node = setup_node(pxm);
> -	if (node<  0) {
> -		printk(KERN_ERR "SRAT: Too many proximity domains.\n");
> -		goto out_err_bad_srat;
> -	}
> -
> -	if (numa_add_memblk(node, start, end)<  0)
> -		goto out_err_bad_srat;
> -
> -	node_set(node, numa_nodes_parsed);
> -
> -	printk(KERN_INFO "SRAT: Node %u PXM %u [mem %#010Lx-%#010Lx] %s\n",
> -	       node, pxm,
> -	       (unsigned long long) start, (unsigned long long) end - 1,
> -	       hotpluggable ? "Hot Pluggable": "");
> -
> -#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
>   	int overlap;
>   	unsigned long start_pfn, end_pfn;
>
> @@ -229,7 +187,54 @@ acpi_numa_memory_affinity_init(struct ac
>   			 */
>   			insert_movablemem_map(start_pfn, end_pfn);
>   	}
> -#endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
> +}
> +#else		/* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
> +static inline void handle_movablemem(int node, u64 start, u64 end)
> +{
> +}
> +#endif		/* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
> +
> +/* Callback for parsing of the Proximity Domain<->  Memory Area mappings */
> +int __init
> +acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
> +{
> +	u64 start, end;
> +	u32 hotpluggable;
> +	int node, pxm;
> +
> +	if (srat_disabled())
> +		goto out_err;
> +	if (ma->header.length != sizeof(struct acpi_srat_mem_affinity))
> +		goto out_err_bad_srat;
> +	if ((ma->flags&  ACPI_SRAT_MEM_ENABLED) == 0)
> +		goto out_err;
> +	hotpluggable = ma->flags&  ACPI_SRAT_MEM_HOT_PLUGGABLE;
> +	if (hotpluggable&&  !save_add_info())
> +		goto out_err;
> +
> +	start = ma->base_address;
> +	end = start + ma->length;
> +	pxm = ma->proximity_domain;
> +	if (acpi_srat_revision<= 1)
> +		pxm&= 0xff;
> +
> +	node = setup_node(pxm);
> +	if (node<  0) {
> +		printk(KERN_ERR "SRAT: Too many proximity domains.\n");
> +		goto out_err_bad_srat;
> +	}
> +
> +	if (numa_add_memblk(node, start, end)<  0)
> +		goto out_err_bad_srat;
> +
> +	node_set(node, numa_nodes_parsed);
> +
> +	printk(KERN_INFO "SRAT: Node %u PXM %u [mem %#010Lx-%#010Lx] %s\n",
> +	       node, pxm,
> +	       (unsigned long long) start, (unsigned long long) end - 1,
> +	       hotpluggable ? "Hot Pluggable": "");
> +
> +	handle_movablemem(node, start, end);
>
>   	return 0;
>   out_err_bad_srat:
> diff -puN include/linux/mm.h~acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node-fix include/linux/mm.h
> diff -puN mm/page_alloc.c~acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node-fix mm/page_alloc.c
> _
>
>
