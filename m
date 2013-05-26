Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab3EZO0u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 10:26:50 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:42695 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab3EZO0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 10:26:48 -0400
Message-ID: <51A21B9A.1090206@gmail.com>
Date: Sun, 26 May 2013 22:26:34 +0800
From: Liu Jiang <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
CC: Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        David Rientjes <rientjes@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Tang Chen <tangchen@cn.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 1/6] mm/memory-hotplug: fix lowmem count overflow when
 offline pages
References: <1369547921-24264-1-git-send-email-liwanp@linux.vnet.ibm.com>
In-Reply-To: <1369547921-24264-1-git-send-email-liwanp@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 26 May 2013 01:58:36 PM CST, Wanpeng Li wrote:
> Changelog:
>  v1 -> v2:
> 	* show number of HighTotal before hotremove
> 	* remove CONFIG_HIGHMEM
> 	* cc stable kernels
> 	* add Michal reviewed-by
>
> Logic memory-remove code fails to correctly account the Total High Memory
> when a memory block which contains High Memory is offlined as shown in the
> example below. The following patch fixes it.
>
> Stable for 2.6.24+.
>
> Before logic memory remove:
>
> MemTotal:        7603740 kB
> MemFree:         6329612 kB
> Buffers:           94352 kB
> Cached:           872008 kB
> SwapCached:            0 kB
> Active:           626932 kB
> Inactive:         519216 kB
> Active(anon):     180776 kB
> Inactive(anon):   222944 kB
> Active(file):     446156 kB
> Inactive(file):   296272 kB
> Unevictable:           0 kB
> Mlocked:               0 kB
> HighTotal:       7294672 kB
> HighFree:        5704696 kB
> LowTotal:         309068 kB
> LowFree:          624916 kB
>
> After logic memory remove:
>
> MemTotal:        7079452 kB
> MemFree:         5805976 kB
> Buffers:           94372 kB
> Cached:           872000 kB
> SwapCached:            0 kB
> Active:           626936 kB
> Inactive:         519236 kB
> Active(anon):     180780 kB
> Inactive(anon):   222944 kB
> Active(file):     446156 kB
> Inactive(file):   296292 kB
> Unevictable:           0 kB
> Mlocked:               0 kB
> HighTotal:       7294672 kB
> HighFree:        5181024 kB
> LowTotal:       4294752076 kB
> LowFree:          624952 kB
>
> Reviewed-by: Michal Hocko <mhocko@suse.cz>
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> ---
>  mm/page_alloc.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 98cbdf6..23b921f 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6140,6 +6140,8 @@ __offline_isolated_pages(unsigned long start_pfn, unsigned long end_pfn)
>  		list_del(&page->lru);
>  		rmv_page_order(page);
>  		zone->free_area[order].nr_free--;
> +		if (PageHighMem(page))
> +			totalhigh_pages -= 1 << order;
>  		for (i = 0; i < (1 << order); i++)
>  			SetPageReserved((page+i));
>  		pfn += (1 << order);

Hi Wanpeng,
         The memory hotplug code adjusts totalram_pages, 
totalhigh_pages,  zone->present_pages
and zone->managed_pages all in memory_hotplug.c, so suggest to move 
this into memory_hotplug.c
too.
          One of my patch fixes this issue in another way, please refer 
to:
http://marc.info/?l=linux-mm&m=136957578620221&w=2
Regards!
Gerry
