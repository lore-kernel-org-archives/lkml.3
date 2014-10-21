Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933275AbaJURKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 13:10:13 -0400
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:58756 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932913AbaJURKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 13:10:11 -0400
Message-ID: <1413910581.12798.25.camel@misato.fc.hp.com>
Subject: Re: [PATCH] memory-hotplug: Clear pgdat which is allocated by
 bootmem in try_offline_node()
From: Toshi Kani <toshi.kani@hp.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, zhenzhang.zhang@huawei.com,
        wangnan0@huawei.com, tangchen@cn.fujitsu.com, dave.hansen@intel.com,
        rientjes@google.com
Date: Tue, 21 Oct 2014 10:56:21 -0600
In-Reply-To: <5444DE75.6010206@jp.fujitsu.com>
References: <5444DE75.6010206@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-20 at 19:05 +0900, Yasuaki Ishimatsu wrote:
 :
> When hot removing memory, pgdat is set to 0 in try_offline_node().
> But if the pgdat is allocated by bootmem allocator, the clearing
> step is skipped. And when hot adding the same memory, the uninitialized
> pgdat is reused. But free_area_init_node() chacks wether pgdat is set

s/chacks/checks


> to zero. As a result, free_area_init_node() hits WARN_ON().
> 
> This patch clears pgdat which is allocated by bootmem allocator
> in try_offline_node().
> 
> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> CC: Zhang Zhen <zhenzhang.zhang@huawei.com>
> CC: Wang Nan <wangnan0@huawei.com>
> CC: Tang Chen <tangchen@cn.fujitsu.com>
> CC: Toshi Kani <toshi.kani@hp.com>
> CC: Dave Hansen <dave.hansen@intel.com>
> CC: David Rientjes <rientjes@google.com>
> 
> ---
>  mm/memory_hotplug.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 29d8693..7649f7c 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1943,7 +1943,7 @@ void try_offline_node(int nid)
> 
>  	if (!PageSlab(pgdat_page) && !PageCompound(pgdat_page))
>  		/* node data is allocated from boot memory */
> -		return;
> +		goto out;

Do we still need this if-statement?  That is, do we have to skip the
for-loop below even though it checks with is_vmalloc_addr()?

Thanks,
-Toshi


>  	/* free waittable in each zone */
>  	for (i = 0; i < MAX_NR_ZONES; i++) {
> @@ -1957,6 +1957,7 @@ void try_offline_node(int nid)
>  			vfree(zone->wait_table);
>  	}
> 
> +out:
>  	/*
>  	 * Since there is no way to guarentee the address of pgdat/zone is not
>  	 * on stack of any kernel threads or used by other kernel objects


