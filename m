Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab3FQXgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 19:36:17 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:33014 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab3FQXgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 19:36:12 -0400
MIME-Version: 1.0
In-Reply-To: <1371511164.27152.22.camel@misato.fc.hp.com>
References: <1371257800-11720-1-git-send-email-yinghai@kernel.org>
	<1371257800-11720-4-git-send-email-yinghai@kernel.org>
	<1371511164.27152.22.camel@misato.fc.hp.com>
Date: Mon, 17 Jun 2013 16:36:12 -0700
X-Google-Sender-Auth: jQjuJRSn8ZKAXGnFXjhYE7s7ikA
Message-ID: <CAE9FiQUsLp2p3yGV0oTzMvJK0YJQvibXg+LD+Dt+Q8D6cfUg_g@mail.gmail.com>
Subject: Re: [PATCH v5 03/22] x86, ACPI, mm: Kill max_low_pfn_mapped
From: Yinghai Lu <yinghai@kernel.org>
To: Toshi Kani <toshi.kani@hp.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Thomas Renninger <trenn@suse.de>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jacob Shin <jacob.shin@amd.com>,
        Pekka Enberg <penberg@kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 4:19 PM, Toshi Kani <toshi.kani@hp.com> wrote:
> On Fri, 2013-06-14 at 17:56 -0700, Yinghai Lu wrote:
>> Now we have arch_pfn_mapped array, and max_low_pfn_mapped should not
>> be used anymore.
>
> Can you describe why max_low_pfn_mapped should not be used?  Is this to
> allow moving the code of acpi_initrd_override() up before
> init_mem_mapping() in a succeeding patch, or is there also another
> reason behind it?  Also, I think arch_pfn_mapped should be pfn_mapped[].

ok, assumption that from [0, max_low_pfn_mapped) all mapped.

Now we only map the  RAM or KERNL_RESERVED, to prevent user from
taking it granted that only check it is below max_low_pfn_mapped to assume
it mapped.

Yes, is should be pfn_mapped[]

>
> Thanks,
> -Toshi
>
>
>> User should use arch_pfn_mapped or just 1UL<<(32-PAGE_SHIFT) instead.
>>
>> Only user is ACPI_INITRD_TABLE_OVERRIDE, and it should not use that,
>> as later accessing is using early_ioremap(). We could change to use
>> 1U<<(32_PAGE_SHIFT) with it, aka under 4G.
>>
>> -v2: Leave alone max_low_pfn_mapped in i915 code according to tj.
>>
>> Suggested-by: H. Peter Anvin <hpa@zytor.com>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
>> Cc: Jacob Shin <jacob.shin@amd.com>
>> Cc: Pekka Enberg <penberg@kernel.org>
>> Cc: linux-acpi@vger.kernel.org
>> Tested-by: Thomas Renninger <trenn@suse.de>
>> Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
>> Tested-by: Tang Chen <tangchen@cn.fujitsu.com>
>> ---
>>  arch/x86/include/asm/page_types.h | 1 -
>>  arch/x86/kernel/setup.c           | 4 +---
>>  arch/x86/mm/init.c                | 4 ----
>>  drivers/acpi/osl.c                | 6 +++---
>>  4 files changed, 4 insertions(+), 11 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
>> index 54c9787..b012b82 100644
>> --- a/arch/x86/include/asm/page_types.h
>> +++ b/arch/x86/include/asm/page_types.h
>> @@ -43,7 +43,6 @@
>>
>>  extern int devmem_is_allowed(unsigned long pagenr);
>>
>> -extern unsigned long max_low_pfn_mapped;
>>  extern unsigned long max_pfn_mapped;
>>
>>  static inline phys_addr_t get_max_mapped(void)
>> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
>> index 66ab495..6ca5f2c 100644
>> --- a/arch/x86/kernel/setup.c
>> +++ b/arch/x86/kernel/setup.c
>> @@ -112,13 +112,11 @@
>>  #include <asm/prom.h>
>>
>>  /*
>> - * max_low_pfn_mapped: highest direct mapped pfn under 4GB
>> - * max_pfn_mapped:     highest direct mapped pfn over 4GB
>> + * max_pfn_mapped:     highest direct mapped pfn
>>   *
>>   * The direct mapping only covers E820_RAM regions, so the ranges and gaps are
>>   * represented by pfn_mapped
>>   */
>> -unsigned long max_low_pfn_mapped;
>>  unsigned long max_pfn_mapped;
>>
>>  #ifdef CONFIG_DMI
>> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
>> index eaac174..8554656 100644
>> --- a/arch/x86/mm/init.c
>> +++ b/arch/x86/mm/init.c
>> @@ -313,10 +313,6 @@ static void add_pfn_range_mapped(unsigned long start_pfn, unsigned long end_pfn)
>>       nr_pfn_mapped = clean_sort_range(pfn_mapped, E820_X_MAX);
>>
>>       max_pfn_mapped = max(max_pfn_mapped, end_pfn);
>> -
>> -     if (start_pfn < (1UL<<(32-PAGE_SHIFT)))
>> -             max_low_pfn_mapped = max(max_low_pfn_mapped,
>> -                                      min(end_pfn, 1UL<<(32-PAGE_SHIFT)));
>>  }
>>
>>  bool pfn_range_is_mapped(unsigned long start_pfn, unsigned long end_pfn)
>> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
>> index e721863..93e3194 100644
>> --- a/drivers/acpi/osl.c
>> +++ b/drivers/acpi/osl.c
>> @@ -624,9 +624,9 @@ void __init acpi_initrd_override(void *data, size_t size)
>>       if (table_nr == 0)
>>               return;
>>
>> -     acpi_tables_addr =
>> -             memblock_find_in_range(0, max_low_pfn_mapped << PAGE_SHIFT,
>> -                                    all_tables_size, PAGE_SIZE);
>> +     /* under 4G at first, then above 4G */
>> +     acpi_tables_addr = memblock_find_in_range(0, (1ULL<<32) - 1,
>> +                                     all_tables_size, PAGE_SIZE);
>>       if (!acpi_tables_addr) {
>>               WARN_ON(1);
>>               return;
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
