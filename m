Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631AbaJTTKq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 15:10:46 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:34129 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320AbaJTTKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 15:10:39 -0400
MIME-Version: 1.0
In-Reply-To: <1413830994.2985.55.camel@deneb.redhat.com>
References: <1413829782-12891-1-git-send-email-mark.rutland@arm.com>
	<1413830994.2985.55.camel@deneb.redhat.com>
Date: Mon, 20 Oct 2014 12:10:38 -0700
Message-ID: <CAFECyb9tcrk6NuO9OR9v0ysYeWhZ8cz+xoJwmtu28_UwpTfQ5A@mail.gmail.com>
Subject: Re: [PATCH] efi: efi-stub: notify on DTB absence
From: Roy Franz <roy.franz@linaro.org>
To: Mark Salter <msalter@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Matt Fleming <matt.fleming@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 11:49 AM, Mark Salter <msalter@redhat.com> wrote:
> On Mon, 2014-10-20 at 19:29 +0100, Mark Rutland wrote:
>> In the absence of an DTB configuration table, the EFI stub will happily
>> continue attempting to boot a kernel, despite the fact that this kernel
>> may not function without a description of the hardware. In this case, as
>> with a typo'd "dtb=" option (e.g. "dbt=") or many other possible
>> failures, the only output seen by the user will be the rather terse
>> output from the EFI stub:
>>
>> EFI stub: Booting Linux Kernel...
>>
>> To aid those attempting to debug such failures, this patch adds a notice
>> when no DTB is found, making the output more helpful:
>>
>> EFI stub: Booting Linux Kernel...
>> EFI stub: Generating empty DTB
>>
>> Similarly, a positive acknowledgement is added when a user-specified DTB
>> is in use:
>>
>> EFI stub: Booting Linux Kernel...
>> EFI stub: Using DTB from command line
>

Acked-by: Roy Franz <roy.franz@linaro.org>


> Should we also include a positive acknowledgement of loader-provided
> DTB? This could be UEFI itself or grub devicetree command or grub
> generated minimal tree.

I could go either way on this.  We now identify the source of the DTB for 2 of
the 3 sources, so there is some nice symmetry in always identifying where
it is coming from.  I think that firmware or GRUB (ie from an EFI
configuration table)
will be the common/normal case, so I think it's also reasonable to
just notify the user
when something unusual is being done.

>
>>
>> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
>> Acked-by: Leif Lindholm <leif.lindholm@linaro.org>
>> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> Cc: Mark Salter <msalter@redhat.com>
>> Cc: Matt Fleming <matt.fleming@intel.com>
>> Cc: Roy Franz <roy.franz@linaro.org>
>> ---
>>  drivers/firmware/efi/libstub/arm-stub.c | 9 ++++++++-
>>  1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
>> index 480339b..10abf24 100644
>> --- a/drivers/firmware/efi/libstub/arm-stub.c
>> +++ b/drivers/firmware/efi/libstub/arm-stub.c
>> @@ -243,9 +243,16 @@ unsigned long __init efi_entry(void *handle, efi_system_table_t *sys_table,
>>                       goto fail_free_cmdline;
>>               }
>>       }
>> -     if (!fdt_addr)
>> +
>> +     if (fdt_addr) {
>> +             pr_efi(sys_table, "Using DTB from command line\n");
>> +     } else {
>>               /* Look for a device tree configuration table entry. */
>>               fdt_addr = (uintptr_t)get_fdt(sys_table);
>> +     }
>> +
>> +     if (!fdt_addr)
>> +             pr_efi(sys_table, "Generating empty DTB\n");
>>
>>       status = handle_cmdline_files(sys_table, image, cmdline_ptr,
>>                                     "initrd=", dram_base + SZ_512M,
>
>
