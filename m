Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab3FQVEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 17:04:34 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:49632 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673Ab3FQVEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 17:04:32 -0400
Date: Mon, 17 Jun 2013 14:04:22 -0700
From: Tejun Heo <tj@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, trenn@suse.de, yinghai@kernel.org,
        jiang.liu@huawei.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jacob Shin <jacob.shin@amd.com>, Pekka Enberg <penberg@kernel.org>,
        linux-acpi@vger.kernel.org
Subject: Re: [Part1 PATCH v5 03/22] x86, ACPI, mm: Kill max_low_pfn_mapped
Message-ID: <20130617210422.GN32663@mtj.dyndns.org>
References: <1371128589-8953-1-git-send-email-tangchen@cn.fujitsu.com>
 <1371128589-8953-4-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371128589-8953-4-git-send-email-tangchen@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jun 13, 2013 at 09:02:50PM +0800, Tang Chen wrote:
> From: Yinghai Lu <yinghai@kernel.org>
> 
> Now we have pfn_mapped[] array, and max_low_pfn_mapped should not
> be used anymore. Users should use pfn_mapped[] or just
> 1UL<<(32-PAGE_SHIFT) instead.
> 
> The only user of max_low_pfn_mapped is ACPI_INITRD_TABLE_OVERRIDE.
> We could change to use 1U<<(32_PAGE_SHIFT) with it, aka under 4G.

                                ^ typo

...
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index e721863..93e3194 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -624,9 +624,9 @@ void __init acpi_initrd_override(void *data, size_t size)
>  	if (table_nr == 0)
>  		return;
>  
> -	acpi_tables_addr =
> -		memblock_find_in_range(0, max_low_pfn_mapped << PAGE_SHIFT,
> -				       all_tables_size, PAGE_SIZE);
> +	/* under 4G at first, then above 4G */
> +	acpi_tables_addr = memblock_find_in_range(0, (1ULL<<32) - 1,
> +					all_tables_size, PAGE_SIZE);

No bigge, but why (1ULL << 32) - 1?  Shouldn't it be just 1ULL << 32?
memblock deals with [@start, @end) areas, right?

Other than that,

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
