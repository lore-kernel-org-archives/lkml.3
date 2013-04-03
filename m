Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760486Ab3DCB3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 21:29:13 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33661 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759992Ab3DCB3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 21:29:12 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <515B85D0.6030403@jp.fujitsu.com>
Date: Wed, 3 Apr 2013 10:28:48 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <linuxram@us.ibm.com>, <tmac@hp.com>,
        <wency@cn.fujitsu.com>, <tangchen@cn.fujitsu.com>,
        <jiang.liu@huawei.com>
Subject: Re: [PATCH 3/3] mm: Change __remove_pages() to call release_mem_region_adjustable()
References: <1364919450-8741-1-git-send-email-toshi.kani@hp.com> <1364919450-8741-4-git-send-email-toshi.kani@hp.com>
In-Reply-To: <1364919450-8741-4-git-send-email-toshi.kani@hp.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Toshi,

2013/04/03 1:17, Toshi Kani wrote:
> Changed __remove_pages() to call release_mem_region_adjustable().
> This allows a requested memory range to be released from
> the iomem_resource table even if it does not match exactly to
> an resource entry but still fits into.  The resource entries
> initialized at bootup usually cover the whole contiguous
> memory ranges and may not necessarily match with the size of
> memory hot-delete requests.
> 
> If release_mem_region_adjustable() failed, __remove_pages() logs
> an error message and continues to proceed as it was the case
> with release_mem_region().  release_mem_region(), which is defined
> to __release_region(), logs an error message and returns no error
> since a void function.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>

The patch looks good.
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Thanks,
Yasuaki Ishimatsu

> ---
>   mm/memory_hotplug.c |   11 +++++++++--
>   1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 57decb2..c916582 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -705,8 +705,10 @@ EXPORT_SYMBOL_GPL(__add_pages);
>   int __remove_pages(struct zone *zone, unsigned long phys_start_pfn,
>   		 unsigned long nr_pages)
>   {
> -	unsigned long i, ret = 0;
> +	unsigned long i;
>   	int sections_to_remove;
> +	resource_size_t start, size;
> +	int ret = 0;
>   
>   	/*
>   	 * We can only remove entire sections
> @@ -714,7 +716,12 @@ int __remove_pages(struct zone *zone, unsigned long phys_start_pfn,
>   	BUG_ON(phys_start_pfn & ~PAGE_SECTION_MASK);
>   	BUG_ON(nr_pages % PAGES_PER_SECTION);
>   
> -	release_mem_region(phys_start_pfn << PAGE_SHIFT, nr_pages * PAGE_SIZE);
> +	start = phys_start_pfn << PAGE_SHIFT;
> +	size = nr_pages * PAGE_SIZE;
> +	ret = release_mem_region_adjustable(&iomem_resource, start, size);
> +	if (ret)
> +		pr_warn("Unable to release resource <%016llx-%016llx> (%d)\n",
> +				start, start + size - 1, ret);
>   
>   	sections_to_remove = nr_pages / PAGES_PER_SECTION;
>   	for (i = 0; i < sections_to_remove; i++) {
> 


