Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbaHTMwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:52:18 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:61860 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbaHTMwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 08:52:16 -0400
MIME-Version: 1.0
In-Reply-To: <20140819123607.GK23128@arm.com>
References: <1407949593-16121-1-git-send-email-keescook@chromium.org>
	<1407949593-16121-9-git-send-email-keescook@chromium.org>
	<20140819123607.GK23128@arm.com>
Date: Wed, 20 Aug 2014 07:52:15 -0500
X-Google-Sender-Auth: VezmEoo5zE8JO-H_FpKbwNpUJvc
Message-ID: <CAGXu5jL-Fgd5dLQfu8NjgpXBDit1gU4Lqtq=6Y_2zjPF4tYGWw@mail.gmail.com>
Subject: Re: [PATCH v4 8/8] ARM: mm: allow text and rodata sections to be read-only
From: Kees Cook <keescook@chromium.org>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh@kernel.org>, Laura Abbott <lauraa@codeaurora.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "msalter@redhat.com" <msalter@redhat.com>,
        Rabin Vincent <rabin@rab.in>, Liu hua <sdu.liu@huawei.com>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, Doug Anderson <dianders@google.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 7:36 AM, Will Deacon <will.deacon@arm.com> wrote:
> On Wed, Aug 13, 2014 at 06:06:33PM +0100, Kees Cook wrote:
>> This introduces CONFIG_DEBUG_RODATA, making kernel text and rodata
>> read-only. Additionally, this splits rodata from text so that rodata can
>> also be NX, which may lead to wasted memory when aligning to SECTION_SIZE.
>> The read-only areas are made writable during ftrace updates and kexec.
>
> [...]
>
>> diff --git a/arch/arm/kernel/ftrace.c b/arch/arm/kernel/ftrace.c
>> index af9a8a927a4e..b8c75e45a950 100644
>> --- a/arch/arm/kernel/ftrace.c
>> +++ b/arch/arm/kernel/ftrace.c
>> @@ -15,6 +15,7 @@
>>  #include <linux/ftrace.h>
>>  #include <linux/uaccess.h>
>>  #include <linux/module.h>
>> +#include <linux/stop_machine.h>
>>
>>  #include <asm/cacheflush.h>
>>  #include <asm/opcodes.h>
>> @@ -35,6 +36,22 @@
>>
>>  #define      OLD_NOP         0xe1a00000      /* mov r0, r0 */
>>
>> +static int __ftrace_modify_code(void *data)
>> +{
>> +     int *command = data;
>> +
>> +     set_kernel_text_rw();
>> +     ftrace_modify_all_code(*command);
>> +     set_kernel_text_ro();
>> +
>> +     return 0;
>> +}
>> +
>> +void arch_ftrace_update_code(int command)
>> +{
>> +     stop_machine(__ftrace_modify_code, &command, NULL);
>> +}
>> +
>>  static unsigned long ftrace_nop_replace(struct dyn_ftrace *rec)
>>  {
>>       return rec->arch.old_mcount ? OLD_NOP : NOP;
>> @@ -73,6 +90,8 @@ int ftrace_arch_code_modify_prepare(void)
>>  int ftrace_arch_code_modify_post_process(void)
>>  {
>>       set_all_modules_text_ro();
>> +     /* Make sure any TLB misses during machine stop are cleared. */
>> +     flush_tlb_all();
>
> I'm afraid I don't understand what you're trying to achieve here. What do
> you mean by `clearing a TLB miss'?

The concern with the local TLB flush when using section_update is that
another CPU might come along and load the temporarily-writable page
permissions during the time the first CPU has called
set_kernel_text_rw() and set_kernel_text_ro(). The call here to
flush_tlb_all() is to make sure all CPUs have the correct page
permissions visible again.

(This is all to work around the a15 errata, and also part of the
output from the thread I mentioned in my 7/8 comment reply.)

>
> [...]
>
>> diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
>> index ccf392ef40d4..35c838da90d5 100644
>> --- a/arch/arm/mm/init.c
>> +++ b/arch/arm/mm/init.c
>> @@ -626,9 +626,10 @@ struct section_perm {
>>       unsigned long end;
>>       pmdval_t mask;
>>       pmdval_t prot;
>> +     pmdval_t clear;
>>  };
>>
>> -struct section_perm nx_perms[] = {
>> +static struct section_perm nx_perms[] = {
>>       /* Make pages tables, etc before _stext RW (set NX). */
>>       {
>>               .start  = PAGE_OFFSET,
>> @@ -643,8 +644,35 @@ struct section_perm nx_perms[] = {
>>               .mask   = ~PMD_SECT_XN,
>>               .prot   = PMD_SECT_XN,
>>       },
>> +#ifdef CONFIG_DEBUG_RODATA
>> +     /* Make rodata NX (set RO in ro_perms below). */
>> +     {
>> +             .start  = (unsigned long)__start_rodata,
>> +             .end    = (unsigned long)__init_begin,
>> +             .mask   = ~PMD_SECT_XN,
>> +             .prot   = PMD_SECT_XN,
>> +     },
>> +#endif
>>  };
>>
>> +#ifdef CONFIG_DEBUG_RODATA
>> +static struct section_perm ro_perms[] = {
>> +     /* Make kernel code and rodata RX (set RO). */
>> +     {
>> +             .start  = (unsigned long)_stext,
>> +             .end    = (unsigned long)__init_begin,
>> +#ifdef CONFIG_ARM_LPAE
>> +             .mask   = ~PMD_SECT_RDONLY,
>> +             .prot   = PMD_SECT_RDONLY,
>> +#else
>> +             .mask   = ~(PMD_SECT_APX | PMD_SECT_AP_WRITE),
>> +             .prot   = PMD_SECT_APX | PMD_SECT_AP_WRITE,
>> +             .clear  = PMD_SECT_AP_WRITE,
>> +#endif
>> +     },
>> +};
>> +#endif
>> +
>>  /*
>>   * Updates section permissions only for the current mm (sections are
>>   * copied into each mm). During startup, this is the init_mm.
>> @@ -713,6 +741,24 @@ static inline void fix_kernmem_perms(void)
>>  {
>>       set_section_perms(nx_perms, prot);
>>  }
>> +
>> +#ifdef CONFIG_DEBUG_RODATA
>> +void mark_rodata_ro(void)
>> +{
>> +     set_section_perms(ro_perms, prot);
>> +}
>> +
>> +void set_kernel_text_rw(void)
>> +{
>> +     set_section_perms(ro_perms, clear);
>> +}
>
> How does this work with LPAE? I don't see a populated clear field there.

LPAE's case has .clear=0 since it only needs the mask -- it has no
bits from the mask to set when clearing. Maybe I need better field
names. It was "'mask' used to unset bits" with "bits to set when
'prot'ecting" and "bits to set when 'clear'ing".

The non-LPAE case masks out "~(PMD_SECT_APX | PMD_SECT_AP_WRITE)" and
then sets either "PMD_SECT_APX | PMD_SECT_AP_WRITE" to set the ro
state, or sets "PMD_SECT_AP_WRITE" to clear the ro state.

The LPAE case masks out "~PMD_SECT_RDONLY" and then sets either
"PMD_SECT_RDONLY" to set the ro state, or sets nothing to clear the ro
state (the mask did everything needed to clear the ro state).

-Kees

-- 
Kees Cook
Chrome OS Security
