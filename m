Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab3FEIiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 04:38:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65019 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753035Ab3FEIiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 04:38:10 -0400
X-IronPort-AV: E=Sophos;i="4.87,805,1363104000"; 
   d="scan'208";a="7466169"
Message-ID: <51AEF898.9080002@cn.fujitsu.com>
Date: Wed, 05 Jun 2013 16:36:40 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jacob Shin <jacob.shin@amd.com>,
        Pekka Enberg <penberg@kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v4 03/22] x86, ACPI, mm: Kill max_low_pfn_mapped
References: <1365728168-32067-1-git-send-email-yinghai@kernel.org> <1365728168-32067-4-git-send-email-yinghai@kernel.org>
In-Reply-To: <1365728168-32067-4-git-send-email-yinghai@kernel.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/05 16:32:04,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/05 16:32:06,
	Serialize complete at 2013/06/05 16:32:06
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi yinghai, HPA,

On 04/12/2013 08:55 AM, Yinghai Lu wrote:
> Now we have arch_pfn_mapped array, and max_low_pfn_mapped should not
> be used anymore.

I'm rebasing this patch-set to the latest kernel, and improving the
comment. But I didn't find any "arch_pfn_mapped array" in the kernel.

Would you please tell me what "arch_pfn_mapped array" is ?

Is it the "struct range pfn_mapped[E820_X_MAX];" in arch/x86/mm/init.c ?

Thanks. :)

>
> User should use arch_pfn_mapped or just 1UL<<(32-PAGE_SHIFT) instead.
>
> Only user is ACPI_INITRD_TABLE_OVERRIDE, and it should not use that,
> as later accessing is using early_ioremap(). We could change to use
> 1U<<(32_PAGE_SHIFT) with it, aka under 4G.
>
> -v2: Leave alone max_low_pfn_mapped in i915 code according to tj.
>
> Suggested-by: H. Peter Anvin<hpa@zytor.com>
> Signed-off-by: Yinghai Lu<yinghai@kernel.org>
> Cc: "Rafael J. Wysocki"<rjw@sisk.pl>
> Cc: Jacob Shin<jacob.shin@amd.com>
> Cc: Pekka Enberg<penberg@kernel.org>
> Cc: linux-acpi@vger.kernel.org
> Tested-by: Thomas Renninger<trenn@suse.de>
> ---
>   arch/x86/include/asm/page_types.h | 1 -
>   arch/x86/kernel/setup.c           | 4 +---
>   arch/x86/mm/init.c                | 4 ----
>   drivers/acpi/osl.c                | 6 +++---
>   4 files changed, 4 insertions(+), 11 deletions(-)
>
> diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
> index 54c9787..b012b82 100644
> --- a/arch/x86/include/asm/page_types.h
> +++ b/arch/x86/include/asm/page_types.h
> @@ -43,7 +43,6 @@
>
>   extern int devmem_is_allowed(unsigned long pagenr);
>
> -extern unsigned long max_low_pfn_mapped;
>   extern unsigned long max_pfn_mapped;
>
>   static inline phys_addr_t get_max_mapped(void)
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 1629577..e75c6e6 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -113,13 +113,11 @@
>   #include<asm/prom.h>
>
>   /*
> - * max_low_pfn_mapped: highest direct mapped pfn under 4GB
> - * max_pfn_mapped:     highest direct mapped pfn over 4GB
> + * max_pfn_mapped:     highest direct mapped pfn
>    *
>    * The direct mapping only covers E820_RAM regions, so the ranges and gaps are
>    * represented by pfn_mapped
>    */
> -unsigned long max_low_pfn_mapped;
>   unsigned long max_pfn_mapped;
>
>   #ifdef CONFIG_DMI
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index 59b7fc4..abcc241 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -313,10 +313,6 @@ static void add_pfn_range_mapped(unsigned long start_pfn, unsigned long end_pfn)
>   	nr_pfn_mapped = clean_sort_range(pfn_mapped, E820_X_MAX);
>
>   	max_pfn_mapped = max(max_pfn_mapped, end_pfn);
> -
> -	if (start_pfn<  (1UL<<(32-PAGE_SHIFT)))
> -		max_low_pfn_mapped = max(max_low_pfn_mapped,
> -					 min(end_pfn, 1UL<<(32-PAGE_SHIFT)));
>   }
>
>   bool pfn_range_is_mapped(unsigned long start_pfn, unsigned long end_pfn)
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index 586e7e9..313d14d 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -624,9 +624,9 @@ void __init acpi_initrd_override(void *data, size_t size)
>   	if (table_nr == 0)
>   		return;
>
> -	acpi_tables_addr =
> -		memblock_find_in_range(0, max_low_pfn_mapped<<  PAGE_SHIFT,
> -				       all_tables_size, PAGE_SIZE);
> +	/* under 4G at first, then above 4G */
> +	acpi_tables_addr = memblock_find_in_range(0, (1ULL<<32) - 1,
> +					all_tables_size, PAGE_SIZE);
>   	if (!acpi_tables_addr) {
>   		WARN_ON(1);
>   		return;
