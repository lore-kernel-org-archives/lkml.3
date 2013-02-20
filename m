Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935361Ab3BTMcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 07:32:19 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:47684 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S935035Ab3BTMcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 07:32:18 -0500
X-IronPort-AV: E=Sophos;i="4.84,702,1355068800"; 
   d="scan'208";a="6736884"
Message-ID: <5124C22B.8030401@cn.fujitsu.com>
Date: Wed, 20 Feb 2013 20:31:39 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: akpm@linux-foundation.org, jiang.liu@huawei.com, wujianguo@huawei.com,
        hpa@zytor.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        linfeng@cn.fujitsu.com, yinghai@kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, rob@landley.net,
        kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, mgorman@suse.de,
        rientjes@google.com, guz.fnst@cn.fujitsu.com, rusty@rustcorp.com.au,
        lliubbo@gmail.com, jaegeuk.hanse@gmail.com, tony.luck@intel.com,
        glommer@parallels.com
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [Bug fix PATCH 1/2] acpi, movablemem_map: Exclude memblock.reserved
 ranges when parsing SRAT.
References: <1361358056-1793-1-git-send-email-tangchen@cn.fujitsu.com> <1361358056-1793-2-git-send-email-tangchen@cn.fujitsu.com>
In-Reply-To: <1361358056-1793-2-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/20 20:31:34,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/20 20:31:35,
	Serialize complete at 2013/02/20 20:31:35
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 07:00 PM, Tang Chen wrote:
> As mentioned by HPA before, when we are using movablemem_map=acpi, if all the
> memory ranges in SRAT is hotpluggable, then no memory can be used by kernel.
>
> Before parsing SRAT, memblock has already reserve some memory ranges for other
> purposes, such as for kernel image, and so on. We cannot prevent kernel from
> using these memory. So we need to exclude these ranges even if these memory is
> hotpluggable.
>
> This patch changes the movablemem_map=acpi option's behavior. The memory ranges
> reserved by memblock will not be added into movablemem_map.map[]. So even if
> all the memory is hotpluggable, there will always be memory that could be used
> by the kernel.
>
> Reported-by: H Peter Anvin<hpa@zytor.com>
> Signed-off-by: Tang Chen<tangchen@cn.fujitsu.com>
> ---
>   arch/x86/mm/srat.c |   18 +++++++++++++++++-
>   1 files changed, 17 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
> index 62ba97b..b8028b2 100644
> --- a/arch/x86/mm/srat.c
> +++ b/arch/x86/mm/srat.c
> @@ -145,7 +145,7 @@ static inline int save_add_info(void) {return 0;}
>   static void __init
>   handle_movablemem(int node, u64 start, u64 end, u32 hotpluggable)
>   {
> -	int overlap;
> +	int overlap, i;
>   	unsigned long start_pfn, end_pfn;
>
>   	start_pfn = PFN_DOWN(start);
> @@ -161,8 +161,24 @@ handle_movablemem(int node, u64 start, u64 end, u32 hotpluggable)
>   	 *
>   	 * Using movablemem_map, we can prevent memblock from allocating memory
>   	 * on ZONE_MOVABLE at boot time.
> +	 *
> +	 * Before parsing SRAT, memblock has already reserve some memory ranges
> +	 * for other purposes, such as for kernel image. We cannot prevent
> +	 * kernel from using these memory, so we need to exclude these memory
> +	 * even if it is hotpluggable.
>   	 */
>   	if (hotpluggable&&  movablemem_map.acpi) {
> +		/* Exclude ranges reserved by memblock. */
> +		struct memblock_type *rgn =&memblock.reserved;
> +
> +		for (i = 0; i<  rgn->cnt; i++) {
> +			if (end<= rgn->regions[i].base ||
> +			    start>= rgn->regions[i].base +
> +			    rgn->regions[i].size)

Hi all,

Here, I scan the memblock.reserved each time we parse an entry because the
rgn->regions[i].nid is set to MAX_NUMNODES in memblock_reserve(). So I 
cannot
obtain the nid which the kernel resides in directly from memblock.reserved.

I think there could be some problems if the memory ranges in SRAT are not in
increasing order, since if [3,4) [1,2) are all on node0, and kernel is not
using [3,4), but using [1,2), then I cannot remove [3,4) because I don't 
know
on which node [3,4) is.

Any idea for this ?

And by the way, I think this approach works well when the memory entries in
SRAT are arranged in increasing order.

Thanks. :)

> +				continue;
> +			goto out;
> +		}
> +
>   		insert_movablemem_map(start_pfn, end_pfn);
>
>   		/*
