Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761619Ab3IDAjE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 20:39:04 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:41267 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761437Ab3IDAjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 20:39:00 -0400
Message-ID: <1378255041.10300.931.camel@misato.fc.hp.com>
Subject: Re: [PATCH 07/11] x86, memblock: Set lowest limit for
 memblock_alloc_base_nid().
From: Toshi Kani <toshi.kani@hp.com>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: rjw@sisk.pl, lenb@kernel.org, tglx@linutronix.de, mingo@elte.hu,
        hpa@zytor.com, akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org
Date: Tue, 03 Sep 2013 18:37:21 -0600
In-Reply-To: <1377596268-31552-8-git-send-email-tangchen@cn.fujitsu.com>
References: <1377596268-31552-1-git-send-email-tangchen@cn.fujitsu.com>
	 <1377596268-31552-8-git-send-email-tangchen@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-27 at 17:37 +0800, Tang Chen wrote:
> memblock_alloc_base_nid() is a common API of memblock. And it calls
> memblock_find_in_range_node() with %start = 0, which means it has no
> limit for the lowest address by default.
> 
> 	memblock_find_in_range_node(0, max_addr, size, align, nid);
> 
> Since we introduced current_limit_low to memblock, if we have no limit
> for the lowest address or we are not sure, we should pass
> MEMBLOCK_ALLOC_ACCESSIBLE to %start so that it will be limited by the
> default low limit.
> 
> dma_contiguous_reserve() and setup_log_buf() will eventually call
> memblock_alloc_base_nid() to allocate memory. So if the allocation order
> is from low to high, they will allocate memory from the lowest limit
> to higher memory.

This requires the callers to use MEMBLOCK_ALLOC_ACCESSIBLE instead of 0.
Is there a good way to make sure that all callers will follow this rule
going forward?  Perhaps, memblock_find_in_range_node() should emit some
message if 0 is passed when current_order is low to high and the boot
option is specified?

Similarly, I wonder if we should have a check to the allocation size to
make sure that all allocations will stay small in this case.

Thanks,
-Toshi


> 
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> ---
>  mm/memblock.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 961d4a5..be8c4d1 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -851,7 +851,8 @@ static phys_addr_t __init memblock_alloc_base_nid(phys_addr_t size,
>  	/* align @size to avoid excessive fragmentation on reserved array */
>  	size = round_up(size, align);
>  
> -	found = memblock_find_in_range_node(0, max_addr, size, align, nid);
> +	found = memblock_find_in_range_node(MEMBLOCK_ALLOC_ACCESSIBLE,
> +					    max_addr, size, align, nid);
>  	if (found && !memblock_reserve(found, size))
>  		return found;
>  


