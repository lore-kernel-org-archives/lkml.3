Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875Ab3HGRK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 13:10:56 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:36500 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab3HGRKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 13:10:55 -0400
MIME-Version: 1.0
In-Reply-To: <20130807130851.GC2515@console-pimps.org>
References: <1375847113-24884-1-git-send-email-roy.franz@linaro.org>
	<1375847113-24884-4-git-send-email-roy.franz@linaro.org>
	<20130807130851.GC2515@console-pimps.org>
Date: Wed, 7 Aug 2013 10:10:54 -0700
Message-ID: <CAFECyb8NbZ=hrAGyoV-UPUhh-Jst6ZVRk9RUQj_Kb1qq_xuUAg@mail.gmail.com>
Subject: Re: [PATCH 03/17] Add system pointer argument to shared EFI stub
 related functions so they no longer use global system table pointer as they
 did when part of eboot.c.
From: Roy Franz <roy.franz@linaro.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        matt.fleming@intel.com,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Dave Martin <dave.martin@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 7, 2013 at 6:08 AM, Matt Fleming <matt@console-pimps.org> wrote:
> On Tue, 06 Aug, at 08:44:59PM, Roy Franz wrote:
>> Signed-off-by: Roy Franz <roy.franz@linaro.org>
>> ---
>>  arch/x86/boot/compressed/eboot.c       |   38 +++++++------
>>  drivers/firmware/efi/efi-stub-helper.c |   96 +++++++++++++++++---------------
>>  2 files changed, 72 insertions(+), 62 deletions(-)
>
> For future reference you should really use a shorter first line in your
> git commit message, which would produe a shorter subject when mailing
> your patches.
>
> I'll fix up the commit messages when I apply these patches, so don't
> worry about it for now.
>
> [...]
>
>> @@ -19,15 +19,16 @@ struct initrd {
>>
>>
>>
>> -static void efi_char16_printk(efi_char16_t *str)
>> +static void efi_char16_printk(efi_system_table_t *sys_table_arg,
>> +                           efi_char16_t *str)
>>  {
>>       struct efi_simple_text_output_protocol *out;
>>
>> -     out = (struct efi_simple_text_output_protocol *)sys_table->con_out;
>> +     out = (struct efi_simple_text_output_protocol *)sys_table_arg->con_out;
>>       efi_call_phys2(out->output_string, out, str);
>>  }
>>
>> -static void efi_printk(char *str)
>> +static void efi_printk(efi_system_table_t *sys_table_arg, char *str)
>>  {
>>       char *s8;
>>
>
> Hmm... I'm not necessarily convinced this is an improvement over using
> some kind of a global pointer to the EFI System Table.
>
> Parameterizing stuff like this is useful when the argument changes at
> runtime from call to call, but that isn't the case for the boot stubs. I
> don't think there's anything wrong with a global in this scenario, and
> this patch is a fair amount of churn for no real improvement.
>
> --
> Matt Fleming, Intel Open Source Technology Center

Hi Matt,

I went this way since the shared code is in a separate file - I really
didn't like using a global variable as part of the interface to
the shared code.  This has the nice side benefit of allowing the ARM
stub to not use any global variables, so we don't have to do
any GOT fixups to relocate the code - it is position independent if we
don't use global variables.

Roy
