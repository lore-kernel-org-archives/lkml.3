Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab3EYC0i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 22:26:38 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:8205 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612Ab3EYC0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 22:26:37 -0400
Message-ID: <51A02074.3020202@huawei.com>
Date: Sat, 25 May 2013 10:22:44 +0800
From: Jianguo Wu <wujianguo@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tang Chen <tangchen@cn.fujitsu.com>
CC: <akpm@linux-foundation.org>, <mgorman@suse.de>, <mingo@redhat.com>,
        <hpa@zytor.com>, <minchan@kernel.org>, <wency@cn.fujitsu.com>,
        <laijs@cn.fujitsu.com>, <yinghai@kernel.org>, <jiang.liu@huawei.com>,
        <tj@kernel.org>, <liwanp@linux.vnet.ibm.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] mem-hotplug: Do not free LOCAL_NODE_DATA pages to
 buddy system in hot-remove procedure.
References: <1369387807-17956-1-git-send-email-tangchen@cn.fujitsu.com> <1369387807-17956-5-git-send-email-tangchen@cn.fujitsu.com>
In-Reply-To: <1369387807-17956-5-git-send-email-tangchen@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.216]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/5/24 17:30, Tang Chen wrote:

> In memory hot-remove procedure, we free pagetable pages to buddy system.
> But for local pagetable pages, do not free them to buddy system because
> they were skipped in offline procedure. The memory block they reside in
> could have been offlined, and we won't offline it again.
> 
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> ---
>  mm/memory_hotplug.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 21d6fcb..c30e819 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -119,6 +119,14 @@ void __ref put_page_bootmem(struct page *page)
>  		INIT_LIST_HEAD(&page->lru);
>  
>  		/*
> +		 * Do not free pages with local node kernel data (for now, just
> +		 * local pagetables) to the buddy system because we skipped
> +		 * these pages when offlining the corresponding block.
> +		 */
> +		if (type == LOCAL_NODE_DATA)
> +			return;

Hi Tang,

I think this should be check in free_pagetable(), like:

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 474e28f..08fe80e 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -725,7 +725,7 @@ static void __meminit free_pagetable(struct page *page, int order)
                if (magic == SECTION_INFO || magic == MIX_SECTION_INFO) {
                        while (nr_pages--)
                                put_page_bootmem(page++);
-           } else
+         } else if (magic != LOCAL_NODE_DATA)
                        __free_pages_bootmem(page, order);
        } else
                free_pages((unsigned long)page_address(page), order);

Thanks,
Jianguo Wu.

> +
> +		/*
>  		 * Please refer to comment for __free_pages_bootmem()
>  		 * for why we serialize here.
>  		 */



