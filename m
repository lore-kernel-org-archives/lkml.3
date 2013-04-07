Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161305Ab3DGB40 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 21:56:26 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:56213 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765123Ab3DGB4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 21:56:25 -0400
Message-ID: <5160D242.4010404@gmail.com>
Date: Sun, 07 Apr 2013 09:56:18 +0800
From: Simon Jeons <simon.jeons@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Cody P Schafer <cody@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] mm: when handling percpu_pagelist_fraction, use on_each_cpu()
 to set percpu pageset fields.
References: <1365194030-28939-1-git-send-email-cody@linux.vnet.ibm.com> <1365194030-28939-4-git-send-email-cody@linux.vnet.ibm.com>
In-Reply-To: <1365194030-28939-4-git-send-email-cody@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cody,
On 04/06/2013 04:33 AM, Cody P Schafer wrote:
> In free_hot_cold_page(), we rely on pcp->batch remaining stable.
> Updating it without being on the cpu owning the percpu pageset
> potentially destroys this stability.

If cpu is off, can its pcp pageset be used in free_hot_code_page()?

>
> Change for_each_cpu() to on_each_cpu() to fix.
>
> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
> ---
>   mm/page_alloc.c | 21 +++++++++++----------
>   1 file changed, 11 insertions(+), 10 deletions(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 48f2faa..507db31 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5475,30 +5475,31 @@ int lowmem_reserve_ratio_sysctl_handler(ctl_table *table, int write,
>   	return 0;
>   }
>   
> +static void _zone_set_pageset_highmark(void *data)
> +{
> +	struct zone *zone = data;
> +	unsigned long  high;
> +	high = zone->managed_pages / percpu_pagelist_fraction;
> +	setup_pagelist_highmark(
> +			per_cpu_ptr(zone->pageset, smp_processor_id()), high);
> +}
> +
>   /*
>    * percpu_pagelist_fraction - changes the pcp->high for each zone on each
>    * cpu.  It is the fraction of total pages in each zone that a hot per cpu pagelist
>    * can have before it gets flushed back to buddy allocator.
>    */
> -
>   int percpu_pagelist_fraction_sysctl_handler(ctl_table *table, int write,
>   	void __user *buffer, size_t *length, loff_t *ppos)
>   {
>   	struct zone *zone;
> -	unsigned int cpu;
>   	int ret;
>   
>   	ret = proc_dointvec_minmax(table, write, buffer, length, ppos);
>   	if (!write || (ret < 0))
>   		return ret;
> -	for_each_populated_zone(zone) {
> -		for_each_possible_cpu(cpu) {
> -			unsigned long  high;
> -			high = zone->managed_pages / percpu_pagelist_fraction;
> -			setup_pagelist_highmark(
> -				per_cpu_ptr(zone->pageset, cpu), high);
> -		}
> -	}
> +	for_each_populated_zone(zone)
> +		on_each_cpu(_zone_set_pageset_highmark, zone, true);
>   	return 0;
>   }
>   

