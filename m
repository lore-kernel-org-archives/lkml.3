Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbaKDBwM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 20:52:12 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:55099 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbaKDBwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 20:52:08 -0500
Message-ID: <545830E3.1020907@huawei.com>
Date: Tue, 4 Nov 2014 09:50:27 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tang Chen <tangchen@cn.fujitsu.com>
CC: <akpm@linux-foundation.org>, <santosh.shilimkar@ti.com>,
        <grygorii.strashko@ti.com>, <yinghai@kernel.org>,
        <isimatu.yasuaki@jp.fujitsu.co>, <fabf@skynet.be>, <nzimmer@sgi.com>,
        <wangnan0@huawei.com>, <vdavydov@parallels.com>, <toshi.kani@hp.com>,
        <phacht@linux.vnet.ibm.com>, <tj@kernel.org>,
        <kirill.shutemov@linux.intel.com>, <riel@redhat.com>,
        <luto@amacapital.net>, <hpa@linux.intel.com>, <aarcange@redhat.com>,
        <mgorman@suse.de>, <rientjes@google.com>, <hannes@cmpxchg.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH 1/2] mem-hotplug: Reset node managed pages when hot-adding
 a new pgdat.
References: <1414748812-22610-1-git-send-email-tangchen@cn.fujitsu.com> <1414748812-22610-2-git-send-email-tangchen@cn.fujitsu.com>
In-Reply-To: <1414748812-22610-2-git-send-email-tangchen@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.25.179]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/10/31 17:46, Tang Chen wrote:

> In free_area_init_core(), zone->managed_pages is set to an approximate
> value for lowmem, and will be adjusted when the bootmem allocator frees
> pages into the buddy system. But free_area_init_core() is also called
> by hotadd_new_pgdat() when hot-adding memory. As a result, zone->managed_pages
> of the newly added node's pgdat is set to an approximate value in the
> very beginning. Even if the memory on that node has node been onlined,
> /sys/device/system/node/nodeXXX/meminfo has wrong value.
> 
> hot-add node2 (memory not onlined)
> cat /sys/device/system/node/node2/meminfo
> Node 2 MemTotal:       33554432 kB
> Node 2 MemFree:               0 kB
> Node 2 MemUsed:        33554432 kB
> Node 2 Active:                0 kB
> 
> This patch fixes this problem by reset node managed pages to 0 after hot-adding
> a new node.
> 
> 1. Move reset_managed_pages_done from reset_node_managed_pages() to reset_all_zones_managed_pages()
> 2. Make reset_node_managed_pages() non-static
> 3. Call reset_node_managed_pages() in hotadd_new_pgdat() after pgdat is initialized
> 
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> ---
>  include/linux/bootmem.h | 1 +
>  mm/bootmem.c            | 9 +++++----
>  mm/memory_hotplug.c     | 9 +++++++++
>  mm/nobootmem.c          | 8 +++++---
>  4 files changed, 20 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/bootmem.h b/include/linux/bootmem.h
> index 4e2bd4c..0995c2d 100644
> --- a/include/linux/bootmem.h
> +++ b/include/linux/bootmem.h
> @@ -46,6 +46,7 @@ extern unsigned long init_bootmem_node(pg_data_t *pgdat,
>  extern unsigned long init_bootmem(unsigned long addr, unsigned long memend);
>  
>  extern unsigned long free_all_bootmem(void);
> +extern void reset_node_managed_pages(pg_data_t *pgdat);
>  extern void reset_all_zones_managed_pages(void);
>  
>  extern void free_bootmem_node(pg_data_t *pgdat,
> diff --git a/mm/bootmem.c b/mm/bootmem.c
> index 8a000ce..477be69 100644
> --- a/mm/bootmem.c
> +++ b/mm/bootmem.c
> @@ -243,13 +243,10 @@ static unsigned long __init free_all_bootmem_core(bootmem_data_t *bdata)
>  
>  static int reset_managed_pages_done __initdata;
>  
> -static inline void __init reset_node_managed_pages(pg_data_t *pgdat)
> +void reset_node_managed_pages(pg_data_t *pgdat)
>  {
>  	struct zone *z;
>  
> -	if (reset_managed_pages_done)
> -		return;
> -
>  	for (z = pgdat->node_zones; z < pgdat->node_zones + MAX_NR_ZONES; z++)
>  		z->managed_pages = 0;
>  }
> @@ -258,8 +255,12 @@ void __init reset_all_zones_managed_pages(void)
>  {
>  	struct pglist_data *pgdat;
>  
> +	if (reset_managed_pages_done)
> +		return;
> +
>  	for_each_online_pgdat(pgdat)
>  		reset_node_managed_pages(pgdat);
> +
>  	reset_managed_pages_done = 1;
>  }
>  
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 29d8693..3ab01b2 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -31,6 +31,7 @@
>  #include <linux/stop_machine.h>
>  #include <linux/hugetlb.h>
>  #include <linux/memblock.h>
> +#include <linux/bootmem.h>
>  
>  #include <asm/tlbflush.h>
>  
> @@ -1096,6 +1097,14 @@ static pg_data_t __ref *hotadd_new_pgdat(int nid, u64 start)
>  	build_all_zonelists(pgdat, NULL);
>  	mutex_unlock(&zonelists_mutex);
>  
> +	/*
> +	 *  zone->managed_pages is set to an approximate value in
> +	 *  free_area_init_core(), which will cause
> +	 *  /sys/device/system/node/nodeX/meminfo has wrong data.
> +	 *  So reset it to 0 before any memory is onlined.
> +	 */
> +	reset_node_managed_pages(pgdat);
> +

I aggree with you, we should reset it before online pages.

Thanks,
Xishi Qiu

>  	return pgdat;
>  }
>  
> diff --git a/mm/nobootmem.c b/mm/nobootmem.c
> index 7c7ab32..90b5046 100644
> --- a/mm/nobootmem.c
> +++ b/mm/nobootmem.c
> @@ -145,12 +145,10 @@ static unsigned long __init free_low_memory_core_early(void)
>  
>  static int reset_managed_pages_done __initdata;
>  
> -static inline void __init reset_node_managed_pages(pg_data_t *pgdat)
> +void reset_node_managed_pages(pg_data_t *pgdat)
>  {
>  	struct zone *z;
>  
> -	if (reset_managed_pages_done)
> -		return;
>  	for (z = pgdat->node_zones; z < pgdat->node_zones + MAX_NR_ZONES; z++)
>  		z->managed_pages = 0;
>  }
> @@ -159,8 +157,12 @@ void __init reset_all_zones_managed_pages(void)
>  {
>  	struct pglist_data *pgdat;
>  
> +	if (reset_managed_pages_done)
> +		return;
> +
>  	for_each_online_pgdat(pgdat)
>  		reset_node_managed_pages(pgdat);
> +
>  	reset_managed_pages_done = 1;
>  }
>  



