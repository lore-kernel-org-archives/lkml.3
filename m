Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553AbaKJA2R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 19:28:17 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58832 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaKJA2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 19:28:16 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <54600665.5090503@jp.fujitsu.com>
Date: Mon, 10 Nov 2014 09:27:17 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tang Chen <tangchen@cn.fujitsu.com>, <akpm@linux-foundation.org>,
        <santosh.shilimkar@ti.com>, <grygorii.strashko@ti.com>,
        <yinghai@kernel.org>, <isimatu.yasuaki@jp.fujitsu.com>,
        <fabf@skynet.be>, <nzimmer@sgi.com>, <wangnan0@huawei.com>,
        <vdavydov@parallels.com>, <toshi.kani@hp.com>,
        <phacht@linux.vnet.ibm.com>, <tj@kernel.org>,
        <kirill.shutemov@linux.intel.com>, <riel@redhat.com>,
        <luto@amacapital.net>, <hpa@linux.intel.com>, <aarcange@redhat.com>,
        <qiuxishi@huawei.com>, <mgorman@suse.de>, <rientjes@google.com>,
        <hannes@cmpxchg.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <miaox@cn.fujitsu.com>
Subject: Re: [PATCH v2 2/2] mem-hotplug: Reset node present pages when hot-adding
 a new pgdat.
References: <1415353481-3140-1-git-send-email-tangchen@cn.fujitsu.com> <1415353481-3140-3-git-send-email-tangchen@cn.fujitsu.com>
In-Reply-To: <1415353481-3140-3-git-send-email-tangchen@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/07 18:44), Tang Chen wrote:
> When onlining memory on node2, node2 zoneinfo and node3 meminfo corrupted:
> 
> # for ((i = 2048; i < 2064; i++)); do echo online_movable > /sys/devices/system/node/node2/memory$i/state; done
> # cat /sys/devices/system/node/node2/meminfo
> Node 2 MemTotal:       33554432 kB
> Node 2 MemFree:        33549092 kB
> Node 2 MemUsed:            5340 kB
> ......
> # cat /sys/devices/system/node/node3/meminfo
> Node 3 MemTotal:              0 kB
> Node 3 MemFree:               248 kB      /* corrupted, should be 0 */
> Node 3 MemUsed:               0 kB
> ......
> 
> # cat /proc/zoneinfo
> ......
> Node 2, zone   Movable
> ......
>          spanned  8388608
>          present  16777216               /* corrupted, should be 8388608 */
>          managed  8388608
> 
> 
> When memory is hot-added, all the memory is in offline state. So
> clear all zone->present_pages because they will be updated in
> online_pages() and offline_pages().
> 
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> ---

Looks good to me.

Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Thanks,
Yasuaki Ishimatsu

>   mm/memory_hotplug.c | 15 +++++++++++++++
>   1 file changed, 15 insertions(+)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 8aba12b..26eac61 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1067,6 +1067,14 @@ out:
>   }
>   #endif /* CONFIG_MEMORY_HOTPLUG_SPARSE */
>   
> +static void reset_node_present_pages(pg_data_t *pgdat)
> +{
> +        struct zone *z;
> +
> +        for (z = pgdat->node_zones; z < pgdat->node_zones + MAX_NR_ZONES; z++)
> +                z->present_pages = 0;
> +}
> +
>   /* we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG */
>   static pg_data_t __ref *hotadd_new_pgdat(int nid, u64 start)
>   {
> @@ -1105,6 +1113,13 @@ static pg_data_t __ref *hotadd_new_pgdat(int nid, u64 start)
>   	 */
>   	reset_node_managed_pages(pgdat);
>   
> +	/*
> +	 * When memory is hot-added, all the memory is in offline state. So
> +	 * clear all zones' present_pages because they will be updated in
> +	 * online_pages() and offline_pages().
> +	 */
> +	reset_node_present_pages(pgdat);
> +
>   	return pgdat;
>   }
>   
> 


