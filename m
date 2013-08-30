Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab3H3WMr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 18:12:47 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:53923 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599Ab3H3WMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 18:12:45 -0400
MIME-Version: 1.0
In-Reply-To: <20130830130131.D7CE63E102A@localhost>
References: <1376090777-20090-1-git-send-email-roy.franz@linaro.org>
	<1376090777-20090-5-git-send-email-roy.franz@linaro.org>
	<20130830130131.D7CE63E102A@localhost>
Date: Fri, 30 Aug 2013 15:12:44 -0700
Message-ID: <CAFECyb_FkxzmbFJhMO8L1T2ZKV1OOru3uqpQOfou6NwugF3+tg@mail.gmail.com>
Subject: Re: [PATCH 04/16] Add minimum address parameter to efi_low_alloc()
From: Roy Franz <roy.franz@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-efi@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        matt.fleming@intel.com,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dave Martin <dave.martin@arm.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Mark Salter <msalter@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 6:01 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Fri,  9 Aug 2013 16:26:05 -0700, Roy Franz <roy.franz@linaro.org> wrote:
>> This allows allocations to be made low in memory while
>> avoiding allocations at the base of memory.
>
> Your commit message should include /why/ the change is needed. From the
> above I understand what the patch does, but I don't understand why it is
> necessary.

This was used to avoid relocating the zImage so low in memory that it
would conflict
with memory range that it was decompressed into.  This is now handled
by allocating
the memory for the decompressed kernel, so the lower limit is no
longer required.
I'll remove it, as it is not necessary any more.

>
> The patch looks fine to me, but it would be worth investigating merging
> alloc_low and alloc_high. It looks like they both do pretty close to the
> same calculations. A single core function could do both, could have both
> minimum and maximum constraints, and could have a flag to determine if
> low or high addresses should be preferred.
>
> g.
>
> Reviewed-by: Grant Likely <grant.likely@linaro.org>
>
>>
>> Signed-off-by: Roy Franz <roy.franz@linaro.org>
>> ---
>>  arch/x86/boot/compressed/eboot.c       |   11 ++++++-----
>>  drivers/firmware/efi/efi-stub-helper.c |    7 +++++--
>>  2 files changed, 11 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
>> index 2a4430a..f44ef2f 100644
>> --- a/arch/x86/boot/compressed/eboot.c
>> +++ b/arch/x86/boot/compressed/eboot.c
>> @@ -458,7 +458,7 @@ struct boot_params *make_boot_params(void *handle, efi_system_table_t *_table)
>>       }
>>
>>       status = efi_low_alloc(sys_table, 0x4000, 1,
>> -                            (unsigned long *)&boot_params);
>> +                            (unsigned long *)&boot_params, 0);
>>       if (status != EFI_SUCCESS) {
>>               efi_printk(sys_table, "Failed to alloc lowmem for boot params\n");
>>               return NULL;
>> @@ -505,7 +505,7 @@ struct boot_params *make_boot_params(void *handle, efi_system_table_t *_table)
>>                       options_size++; /* NUL termination */
>>
>>                       status = efi_low_alloc(sys_table, options_size, 1,
>> -                                        &cmdline);
>> +                                        &cmdline, 0);
>>                       if (status != EFI_SUCCESS) {
>>                               efi_printk(sys_table, "Failed to alloc mem for cmdline\n");
>>                               goto fail;
>> @@ -563,7 +563,8 @@ static efi_status_t exit_boot(struct boot_params *boot_params,
>>  again:
>>       size += sizeof(*mem_map) * 2;
>>       _size = size;
>> -     status = efi_low_alloc(sys_table, size, 1, (unsigned long *)&mem_map);
>> +     status = efi_low_alloc(sys_table, size, 1,
>> +                            (unsigned long *)&mem_map, 0);
>>       if (status != EFI_SUCCESS)
>>               return status;
>>
>> @@ -697,7 +698,7 @@ static efi_status_t relocate_kernel(struct setup_header *hdr)
>>                               nr_pages, &start);
>>       if (status != EFI_SUCCESS) {
>>               status = efi_low_alloc(sys_table, hdr->init_size,
>> -                                hdr->kernel_alignment, &start);
>> +                                hdr->kernel_alignment, &start, 0);
>>               if (status != EFI_SUCCESS)
>>                       efi_printk(sys_table, "Failed to alloc mem for kernel\n");
>>       }
>> @@ -745,7 +746,7 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table,
>>
>>       gdt->size = 0x800;
>>       status = efi_low_alloc(sys_table, gdt->size, 8,
>> -                        (unsigned long *)&gdt->address);
>> +                        (unsigned long *)&gdt->address, 0);
>>       if (status != EFI_SUCCESS) {
>>               efi_printk(sys_table, "Failed to alloc mem for gdt\n");
>>               goto fail;
>> diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
>> index 0218d535..40cd16e 100644
>> --- a/drivers/firmware/efi/efi-stub-helper.c
>> +++ b/drivers/firmware/efi/efi-stub-helper.c
>> @@ -163,11 +163,11 @@ fail:
>>  }
>>
>>  /*
>> - * Allocate at the lowest possible address.
>> + * Allocate at the lowest possible address, that is not below min.
>>   */
>>  static efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
>>                             unsigned long size, unsigned long align,
>> -                           unsigned long *addr)
>> +                           unsigned long *addr, unsigned long min)
>>  {
>>       unsigned long map_size, desc_size;
>>       efi_memory_desc_t *map;
>> @@ -204,6 +204,9 @@ static efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
>>               if (start == 0x0)
>>                       start += 8;
>>
>> +             if (start < min)
>> +                     start = min;
>> +
>>               start = round_up(start, align);
>>               if ((start + size) > end)
>>                       continue;
>> --
>> 1.7.10.4
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
