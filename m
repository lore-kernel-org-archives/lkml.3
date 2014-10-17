Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbaJQRkD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 13:40:03 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:35411 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbaJQRkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 13:40:01 -0400
MIME-Version: 1.0
In-Reply-To: <CAJd=RBCyxxm9rD4W_rMZmvu20aVA9CbP8sa8AptRGXtW1QU-Jg@mail.gmail.com>
References: <CAJd=RBCyxxm9rD4W_rMZmvu20aVA9CbP8sa8AptRGXtW1QU-Jg@mail.gmail.com>
Date: Fri, 17 Oct 2014 12:40:00 -0500
X-Google-Sender-Auth: Aom3JpGa72yoYJnspcPoHEpXP_w
Message-ID: <CAGXu5j+0mh6zgT-nw4e=mstdwDecSi17JLcDubf=52XSPhr6sw@mail.gmail.com>
Subject: Re: [PATCH v6 8/8] ARM: mm: allow text and rodata sections to be read-only
From: Kees Cook <keescook@chromium.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>, Rabin Vincent <rabin@rab.in>,
        Laura Abbott <lauraa@codeaurora.org>, Rob Herring <robh@kernel.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Mark Salter <msalter@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "hillf.zj" <hillf.zj@alibaba-inc.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2014 at 1:15 AM, Hillf Danton <dhillf@gmail.com> wrote:
> Hey Kees
>
>> From: Kees Cook <keescook@chromium.org>
>> To:   linux-kernel@vger.kernel.org
>> Cc:   Kees Cook <keescook@chromium.org>, Will Deacon <will.deacon@arm.com>,
>> Rabin Vincent <rabin@rab.in>, Laura Abbott <lauraa@codeaurora.org>, Rob
>> Herring <robh@kernel.org>, Leif Lindholm <leif.lindholm@linaro.org>, Mark
>> Salter <msalter@redhat.com>, Liu hua <
>> Subject: [PATCH v6 8/8] ARM: mm: allow text and rodata sections to be
>> read-only
>> Date: Thu, 18 Sep 2014 12:19:09 -0700
>>
>> This introduces CONFIG_DEBUG_RODATA, making kernel text and rodata
>> read-only. Additionally, this splits rodata from text so that rodata can
>> also be NX, which may lead to wasted memory when aligning to SECTION_SIZE.
>> The read-only areas are made writable during ftrace updates and kexec.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> Tested-by: Laura Abbott <lauraa@codeaurora.org>
>> Acked-by: Nicolas Pitre <nico@linaro.org>
>> ---
>> [...]
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
>
> [1] after set_kernel_text_ro, PMD_SECT_AP_WRITE is set
> in corresponding PMD.
>
> [2] after set_kernel_text_rw, PMD_SECT_AP_WRITE is also set
> in corresponding PMD.
>
> as shown in [7/8] in this patch series.
>
> +#ifdef CONFIG_ARM_LPAE
> +       pmd[0] = __pmd((pmd_val(pmd[0]) & mask) | prot);
> +#else
> +       if (addr & SECTION_SIZE)
> +               pmd[1] = __pmd((pmd_val(pmd[1]) & mask) | prot);
> +       else
> +               pmd[0] = __pmd((pmd_val(pmd[0]) & mask) | prot);
> +#endif
>
> [3] As far as I could understand,
> I wonder if PMD_SECT_AP_WRITE should be cleared
> when setting RO.

The bit names are confusing. PMD_SECT_APX is what actually controls
the ROness. As in, the region is read-only when PMD_SECT_APX=1 and
PMD_SECT_AP_WRITE=1, and writable when PMD_SECT_APX=0 and
PMD_SECT_AP_WRITE=1.

> btw, would you please shed light on PMD_SECT_APX,
> since it is not included in both MT_MEMORY_RWX and
> MT_MEMORY_RW mm types.
>
>         [MT_MEMORY_RWX] = {
>                 .prot_pte  = L_PTE_PRESENT | L_PTE_YOUNG | L_PTE_DIRTY,
>                 .prot_l1   = PMD_TYPE_TABLE,
>                 .prot_sect = PMD_TYPE_SECT | PMD_SECT_AP_WRITE,
>                 .domain    = DOMAIN_KERNEL,
>         },
>         [MT_MEMORY_RW] = {
>                 .prot_pte  = L_PTE_PRESENT | L_PTE_YOUNG | L_PTE_DIRTY |
>                              L_PTE_XN,
>                 .prot_l1   = PMD_TYPE_TABLE,
>                 .prot_sect = PMD_TYPE_SECT | PMD_SECT_AP_WRITE,
>                 .domain    = DOMAIN_KERNEL,
>         },

Correct, both of those are read-write, so PMD_SECT_APX is not set. If
there were an MT_MEMORY_RO type, it would have PMD_SECT_APX set. For
example, see that MT_ROM gets it set when extended page tables are
available (which the ro-nx code similarly checks via
arch_has_strict_perms()).

I hope that helps!

-Kees

-- 
Kees Cook
Chrome OS Security
