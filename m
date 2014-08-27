Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965514AbaH0X5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 19:57:45 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43547 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935798AbaH0X5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 19:57:43 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <53FE7035.4000807@jp.fujitsu.com>
Date: Thu, 28 Aug 2014 08:56:37 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Zhang Zhen <zhenzhang.zhang@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave.hansen@intel.com>, Toshi Kani <toshi.kani@hp.com>
CC: <wangnan0@huawei.com>, Linux MM <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] memory-hotplug: fix not enough check of valid zones
References: <1409124238-18635-1-git-send-email-zhenzhang.zhang@huawei.com> <53FDBDF0.5000200@huawei.com>
In-Reply-To: <53FDBDF0.5000200@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/08/27 20:16), Zhang Zhen wrote:
> As Yasuaki Ishimatsu described the check here is not enough
> if memory has hole as follows:
>
> PFN       0x00          0xd0          0xe0          0xf0
>               +-------------+-------------+-------------+
> zone type   |   Normal    |     hole    |   Normal    |
>               +-------------+-------------+-------------+
> In this case, the check can't guarantee that this is "the last
> block of memory".
> The check of ZONE_MOVABLE has the same problem.
>
> Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>

Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Thanks,
Yasuaki Ishimatsu

> ---
>   drivers/base/memory.c | 36 ++++++------------------------------
>   1 file changed, 6 insertions(+), 30 deletions(-)
>
> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> index ccaf37c..0fc1d25 100644
> --- a/drivers/base/memory.c
> +++ b/drivers/base/memory.c
> @@ -374,20 +374,6 @@ static ssize_t show_phys_device(struct device *dev,
>   }
>
>   #ifdef CONFIG_MEMORY_HOTREMOVE
> -static int __zones_online_to(unsigned long end_pfn,
> -				struct page *first_page, unsigned long nr_pages)
> -{
> -	struct zone *zone_next;
> -
> -	/* The mem block is the last block of memory. */
> -	if (!pfn_valid(end_pfn + 1))
> -		return 1;
> -	zone_next = page_zone(first_page + nr_pages);
> -	if (zone_idx(zone_next) == ZONE_MOVABLE)
> -		return 1;
> -	return 0;
> -}
> -
>   static ssize_t show_zones_online_to(struct device *dev,
>   				struct device_attribute *attr, char *buf)
>   {
> @@ -407,28 +393,18 @@ static ssize_t show_zones_online_to(struct device *dev,
>
>   	zone = page_zone(first_page);
>
> -#ifdef CONFIG_HIGHMEM
> -	if (zone_idx(zone) == ZONE_HIGHMEM) {
> -		if (__zones_online_to(end_pfn, first_page, nr_pages))
> +	if (zone_idx(zone) == ZONE_MOVABLE - 1) {
> +		/*The mem block is the last memoryblock of this zone.*/
> +		if (end_pfn == zone_end_pfn(zone))
>   			return sprintf(buf, "%s %s\n",
>   					zone->name, (zone + 1)->name);
>   	}
> -#else
> -	if (zone_idx(zone) == ZONE_NORMAL) {
> -		if (__zones_online_to(end_pfn, first_page, nr_pages))
> -			return sprintf(buf, "%s %s\n",
> -					zone->name, (zone + 1)->name);
> -	}
> -#endif
>
>   	if (zone_idx(zone) == ZONE_MOVABLE) {
> -		if (!pfn_valid(start_pfn - nr_pages))
> -			return sprintf(buf, "%s %s\n",
> -						zone->name, (zone - 1)->name);
> -		zone_prev = page_zone(first_page - nr_pages);
> -		if (zone_idx(zone_prev) != ZONE_MOVABLE)
> +		/*The mem block is the first memoryblock of ZONE_MOVABLE.*/
> +		if (start_pfn == zone->zone_start_pfn)
>   			return sprintf(buf, "%s %s\n",
> -						zone->name, (zone - 1)->name);
> +					zone->name, (zone - 1)->name);
>   	}
>
>   	return sprintf(buf, "%s\n", zone->name);
>


