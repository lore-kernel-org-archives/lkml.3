Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab3IRQbY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 12:31:24 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:42064 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3IRQbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 12:31:22 -0400
MIME-Version: 1.0
In-Reply-To: <20130918121240.GJ3409@console-pimps.org>
References: <1379391093-27948-1-git-send-email-roy.franz@linaro.org>
	<1379391093-27948-9-git-send-email-roy.franz@linaro.org>
	<20130918121240.GJ3409@console-pimps.org>
Date: Wed, 18 Sep 2013 09:31:21 -0700
Message-ID: <CAFECyb849wjbL9SWhK74Y1dfjKFuYpNwf=c5PYe15VeLwz3AFQ@mail.gmail.com>
Subject: Re: [PATCH 08/17] Generalize relocate_kernel() for use by other architectures.
From: Roy Franz <roy.franz@linaro.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-efi@vger.kernel.org, matt.fleming@intel.com,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Mark Salter <msalter@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 5:12 AM, Matt Fleming <matt@console-pimps.org> wrote:
> On Mon, 16 Sep, at 09:11:24PM, Roy Franz wrote:
>> Rename relocate_kernel() to efi_relocate_kernel(), and take
>> parameters rather than x86 specific structure.  Add max_addr
>> argument as for ARM we have some address constraints that we
>> need to enforce when relocating the kernel.  Add alloc_size
>> parameter for use by ARM64 which uses an uncompressed kernel,
>> and needs to allocate space for BSS.
>>
>> Signed-off-by: Roy Franz <roy.franz@linaro.org>
>> ---
>>  arch/x86/boot/compressed/eboot.c       |   12 ++++--
>>  drivers/firmware/efi/efi-stub-helper.c |   74 ++++++++++++++++++++++----------
>>  2 files changed, 60 insertions(+), 26 deletions(-)
>
> This commit breaks my ASUS machine.
>
>> -     /*
>> -      * The EFI firmware loader could have placed the kernel image
>> -      * anywhere in memory, but the kernel has various restrictions
>> -      * on the max physical address it can run at. Attempt to move
>> -      * the kernel to boot_params.pref_address, or as low as
>> -      * possible.
>> -      */
>
> [...]
>
>> +
>> +     /* The EFI firmware loader could have placed the kernel image
>> +      * anywhere in memory, but the kernel has restrictions on the
>> +      * anywhere in memory, but the kernel has restrictions on the
>> +      * max physical address it can run at.  Some architectures
>> +      * also have a prefered address, so first try to relocate
>> +      * to the preferred address.
>> +      */
>
> Please don't change the comment style of code in the future.
Sorry about that.
>
>> +     nr_pages = round_up(alloc_size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
>> +     status = efi_call_phys4(sys_table_arg->boottime->allocate_pages,
>>                               EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
>> -                             nr_pages, &start);
>> +                             nr_pages, &efi_addr);
>> +     new_addr = efi_addr;
>> +     /* If preferred address allocation failed allocate as low as
>> +      * possible. */
>>       if (status != EFI_SUCCESS) {
>> -             status = efi_low_alloc(sys_table, hdr->init_size,
>> -                                hdr->kernel_alignment, &start);
>> -             if (status != EFI_SUCCESS)
>> -                     efi_printk(sys_table, "Failed to alloc mem for kernel\n");
>> +             status = efi_low_alloc(sys_table_arg, alloc_size, 0,
>> +                                    &new_addr);
>
> This is wrong. You've dropped the hdr->kernel_alignment argument, and
> the relaxed alignment of this allocation stops my machine from booting.
Dropping the alignment was an oversight, and my testing on OVMF didn't
catch that.  I'll add the alignment
and resend the series.

Thanks,
Roy

>
> --
> Matt Fleming, Intel Open Source Technology Center
