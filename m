Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705Ab3EVEk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 00:40:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:20927 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750777Ab3EVEk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 00:40:26 -0400
X-IronPort-AV: E=Sophos;i="4.87,719,1363104000"; 
   d="scan'208";a="7330449"
Message-ID: <519C4CE2.4030204@cn.fujitsu.com>
Date: Wed, 22 May 2013 12:43:14 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "vasilis.liaskovitis@profitbricks.com >> Vasilis Liaskovitis" 
	<vasilis.liaskovitis@profitbricks.com>
CC: mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, tj@kernel.org, laijs@cn.fujitsu.com,
        davem@davemloft.net, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 12/13] x86, numa, acpi, memory-hotplug: Make movablecore=acpi
 have higher priority.
References: <1367313683-10267-1-git-send-email-tangchen@cn.fujitsu.com> <1367313683-10267-13-git-send-email-tangchen@cn.fujitsu.com>
In-Reply-To: <1367313683-10267-13-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/22 12:39:00,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/22 12:39:06,
	Serialize complete at 2013/05/22 12:39:06
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vasilis,

Maybe the following two problems are the cause of the reboot panic
problem in qemu you mentioned.

On 04/30/2013 05:21 PM, Tang Chen wrote:
......
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index b9ea143..2fe9ebf 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4793,9 +4793,31 @@ static void __init find_zone_movable_pfns_for_nodes(void)
>   	nodemask_t saved_node_state = node_states[N_MEMORY];
>   	unsigned long totalpages = early_calculate_totalpages();
>   	int usable_nodes = nodes_weight(node_states[N_MEMORY]);
> +	struct memblock_type *reserved =&memblock.reserved;
>

Need to call find_usable_zone_for_movable() here before goto out.

>   	/*
> -	 * If movablecore was specified, calculate what size of
> +	 * If movablecore=acpi was specified, then zone_movable_pfn[] has been
> +	 * initialized, and no more work needs to do.
> +	 * NOTE: In this case, we ignore kernelcore option.
> +	 */
> +	if (movablecore_enable_srat) {
> +		for (i = 0; i<  reserved->cnt; i++) {
> +			if (!memblock_is_hotpluggable(&reserved->regions[i]))
> +				continue;
> +
> +			nid = reserved->regions[i].nid;
> +
> +			usable_startpfn = reserved->regions[i].base;

Here, it should be PFN_DOWN(reserved->regions[i].base).

Thanks. :)

> +			zone_movable_pfn[nid] = zone_movable_pfn[nid] ?
> +				min(usable_startpfn, zone_movable_pfn[nid]) :
> +				usable_startpfn;
> +		}
> +
> +		goto out;
> +	}
> +
> +	/*
> +	 * If movablecore=nn[KMG] was specified, calculate what size of
>   	 * kernelcore that corresponds so that memory usable for
>   	 * any allocation type is evenly spread. If both kernelcore
>   	 * and movablecore are specified, then the value of kernelcore
