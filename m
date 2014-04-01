Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574AbaDASgv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 14:36:51 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:58963 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbaDASgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 14:36:49 -0400
MIME-Version: 1.0
In-Reply-To: <533AFF77.5030106@codeaurora.org>
References: <1396346657-7166-1-git-send-email-holler@ahsoftware.de>
	<533AFF77.5030106@codeaurora.org>
Date: Tue, 1 Apr 2014 11:36:48 -0700
X-Google-Sender-Auth: Lz27gCpGrlCcRU-Bc-5kq0zbzLs
Message-ID: <CAGXu5jKMF9n9svQBhyQFvCoUe86QhLycDTt-fWyiRfySbn=Fug@mail.gmail.com>
Subject: Re: [PATCH] arm: don't allow CONFIG_DEBUG_SET_MODULE_RONX if
 CONFIG_JUMP_LABEL is enabled
From: Kees Cook <keescook@chromium.org>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: Alexander Holler <holler@ahsoftware.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 1, 2014 at 11:03 AM, Laura Abbott <lauraa@codeaurora.org> wrote:
> On 4/1/2014 3:04 AM, Alexander Holler wrote:
>> CONFIG_DEBUG_SET_MODULE_RONX sounds like a nice security feature, but
>> things might fail late (and unexpected) if module code is set to read-only
>> while CONFIG_JUMP_LABEL is enabled (e.g. modprobe bridge).

Isn't this a ordering problem? I thought jump labels got set up once,
and then after that, the memory could be made RO?

>>
>> Avoid this.
>>
>> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
>> ---
>>  arch/arm/Kconfig.debug | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
>> index 0531da8..6627b9e 100644
>> --- a/arch/arm/Kconfig.debug
>> +++ b/arch/arm/Kconfig.debug
>> @@ -1197,7 +1197,7 @@ config PID_IN_CONTEXTIDR
>>
>>  config DEBUG_SET_MODULE_RONX
>>       bool "Set loadable kernel module data as NX and text as RO"
>> -     depends on MODULES
>> +     depends on MODULES && !JUMP_LABEL
>>       ---help---
>>         This option helps catch unintended modifications to loadable
>>         kernel module's text and read-only data. It also prevents execution
>>
>
> Kees Cook has something similar[1] for not-module space as well, we probably want
> this there as well. A shame we keep finding reasons these features will be turned
> off. Looks good to me otherwise.
>
> Laura
>
> [1]http://lists.infradead.org/pipermail/linux-arm-kernel/2014-February/232644.html

I've solidly stumbled over ftrace with my series now. I can't figure
out why it doesn't work, though. I wrote code to flip the PMD flags
back to writable (via set_kernel_text_rw), but it seems like the
system is ignoring the changes, even though I call flush_pmd_entry.

struct section_perm section_perms[] = {
       /* Make kernel code and rodata RX (set RO). */
       [ARM_TEXT_SECTION] = {
              .start       = (unsigned long)_stext,
              .end       = (unsigned long)__init_begin,
#ifdef CONFIG_ARM_LPAE
              .mask       = ~PMD_SECT_RDONLY,
              .prot       = PMD_SECT_RDONLY,
#else
              .mask       = ~(PMD_SECT_APX | PMD_SECT_AP_WRITE),
              .prot       = PMD_SECT_APX | PMD_SECT_AP_WRITE,
              .clear       = PMD_SECT_AP_WRITE,
#endif
       },

...

static inline void section_update(unsigned long addr, pmdval_t mask,
                              pmdval_t prot)
{
       pmd_t *pmd = pmd_off_k(addr);

#ifdef CONFIG_ARM_LPAE
       pmd[0] = __pmd((pmd_val(pmd[0]) & mask) | prot);
#else
       if (addr & SECTION_SIZE)
              pmd[1] = __pmd((pmd_val(pmd[1]) & mask) | prot);
       else
              pmd[0] = __pmd((pmd_val(pmd[0]) & mask) | prot);
#endif
       flush_pmd_entry(pmd);
}

...

void set_kernel_text_rw(void)
{
       unsigned long addr;

       if (!arch_can_set_perms())
              return;

       for (addr = section_perms[ARM_TEXT_SECTION].start;
            addr < section_perms[ARM_TEXT_SECTION].end;
            addr += SECTION_SIZE)
              section_update(addr, section_perms[ARM_TEXT_SECTION].mask,
                            section_perms[ARM_TEXT_SECTION].clear);
}

Is there something "sticky" about PMD sections that I'm not aware of?
Even after calling set_kernel_text_rw(), any writes to kernel memory
fault. :(

-Kees

-- 
Kees Cook
Chrome OS Security
