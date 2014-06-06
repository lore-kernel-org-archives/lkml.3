Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396AbaFFFTX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 01:19:23 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:18731 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751204AbaFFFTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 01:19:22 -0400
X-IronPort-AV: E=Sophos;i="4.98,986,1392134400"; 
   d="scan'208";a="31548319"
Date: Fri, 6 Jun 2014 13:15:35 +0800
From: Hu Tao <hutao@cn.fujitsu.com>
To: Tang Chen <tangchen@cn.fujitsu.com>
CC: <gregkh@linuxfoundation.org>, <akpm@linux-foundation.org>,
        <toshi.kani@hp.com>, <tj@kernel.org>, <hpa@zytor.com>, <mingo@elte.hu>,
        <laijs@cn.fujitsu.com>, <isimatu.yasuaki@jp.fujitsu.com>,
        <guz.fnst@cn.fujitsu.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: Re: [PATCH v2 2/2] mem-hotplug: Introduce MMOP_OFFLINE to replace
 the hard coding -1.
Message-ID: <20140606051535.GC4454@G08FNSTD100614.fnst.cn.fujitsu.com>
References: <1402027134-14423-1-git-send-email-tangchen@cn.fujitsu.com>
 <1402027134-14423-3-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1402027134-14423-3-git-send-email-tangchen@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [10.167.226.102]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 11:58:54AM +0800, Tang Chen wrote:
> In store_mem_state(), we have:
> ......
>  334         else if (!strncmp(buf, "offline", min_t(int, count, 7)))
>  335                 online_type = -1;
> ......
>  355         case -1:
>  356                 ret = device_offline(&mem->dev);
>  357                 break;
> ......
> 
> Here, "offline" is hard coded as -1.
> 
> This patch does the following renaming:
>  ONLINE_KEEP     ->  MMOP_ONLINE_KEEP
>  ONLINE_KERNEL   ->  MMOP_ONLINE_KERNEL
>  ONLINE_MOVABLE  ->  MMOP_ONLINE_MOVABLE
> 
> and introduce MMOP_OFFLINE = -1 to avoid hard coding.
> 
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> ---
>  drivers/base/memory.c          | 16 ++++++++--------
>  include/linux/memory_hotplug.h |  9 +++++----
>  mm/memory_hotplug.c            |  9 ++++++---
>  3 files changed, 19 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> index fa664b9..0f3fa8c 100644
> --- a/drivers/base/memory.c
> +++ b/drivers/base/memory.c
> @@ -294,7 +294,7 @@ static int memory_subsys_online(struct device *dev)
>  	 * attribute and need to set the online_type.
>  	 */
>  	if (mem->online_type < 0)
> -		mem->online_type = ONLINE_KEEP;
> +		mem->online_type = MMOP_ONLINE_KEEP;
>  
>  	ret = memory_block_change_state(mem, MEM_ONLINE, MEM_OFFLINE);
>  
> @@ -326,22 +326,22 @@ store_mem_state(struct device *dev,
>  		return ret;
>  
>  	if (sysfs_streq(buf, "online_kernel"))
> -		online_type = ONLINE_KERNEL;
> +		online_type = MMOP_ONLINE_KERNEL;
>  	else if (sysfs_streq(buf, "online_movable"))
> -		online_type = ONLINE_MOVABLE;
> +		online_type = MMOP_ONLINE_MOVABLE;
>  	else if (sysfs_streq(buf, "online"))
> -		online_type = ONLINE_KEEP;
> +		online_type = MMOP_ONLINE_KEEP;
>  	else if (sysfs_streq(buf, "offline"))
> -		online_type = -1;
> +		online_type = MMOP_OFFLINE;
>  	else {
>  		ret = -EINVAL;
>  		goto err;
>  	}
>  
>  	switch (online_type) {
> -	case ONLINE_KERNEL:
> -	case ONLINE_MOVABLE:
> -	case ONLINE_KEEP:
> +	case MMOP_ONLINE_KERNEL:
> +	case MMOP_ONLINE_MOVABLE:
> +	case MMOP_ONLINE_KEEP:

There is a `case -1' several lines below should have been converted.

>  		/*
>  		 * mem->online_type is not protected so there can be a
>  		 * race here.  However, when racing online, the first
> diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
> index 4ca3d95..b4240cf 100644
> --- a/include/linux/memory_hotplug.h
> +++ b/include/linux/memory_hotplug.h
> @@ -26,11 +26,12 @@ enum {
>  	MEMORY_HOTPLUG_MAX_BOOTMEM_TYPE = NODE_INFO,
>  };
>  
> -/* Types for control the zone type of onlined memory */
> +/* Types for control the zone type of onlined and offlined memory */
>  enum {
> -	ONLINE_KEEP,
> -	ONLINE_KERNEL,
> -	ONLINE_MOVABLE,
> +	MMOP_OFFLINE = -1,
> +	MMOP_ONLINE_KEEP,
> +	MMOP_ONLINE_KERNEL,
> +	MMOP_ONLINE_MOVABLE,
>  };
>  
>  /*
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index a650db2..6075f04 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -907,19 +907,22 @@ int __ref online_pages(unsigned long pfn, unsigned long nr_pages, int online_typ
>  	 */
>  	zone = page_zone(pfn_to_page(pfn));
>  
> -	if ((zone_idx(zone) > ZONE_NORMAL || online_type == ONLINE_MOVABLE) &&
> +	if ((zone_idx(zone) > ZONE_NORMAL ||
> +	     online_type == MMOP_ONLINE_MOVABLE) &&
>  	    !can_online_high_movable(zone)) {
>  		unlock_memory_hotplug();
>  		return -EINVAL;
>  	}
>  
> -	if (online_type == ONLINE_KERNEL && zone_idx(zone) == ZONE_MOVABLE) {
> +	if (online_type == MMOP_ONLINE_KERNEL &&
> +	    zone_idx(zone) == ZONE_MOVABLE) {
>  		if (move_pfn_range_left(zone - 1, zone, pfn, pfn + nr_pages)) {
>  			unlock_memory_hotplug();
>  			return -EINVAL;
>  		}
>  	}
> -	if (online_type == ONLINE_MOVABLE && zone_idx(zone) == ZONE_MOVABLE - 1) {
> +	if (online_type == MMOP_ONLINE_MOVABLE &&
> +	    zone_idx(zone) == ZONE_MOVABLE - 1) {
>  		if (move_pfn_range_right(zone, zone + 1, pfn, pfn + nr_pages)) {
>  			unlock_memory_hotplug();
>  			return -EINVAL;
> -- 
> 1.8.3.1
