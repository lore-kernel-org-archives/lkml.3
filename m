Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311AbaKOCqX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 21:46:23 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:55044 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755011AbaKOCqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 21:46:21 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQV=i=+tO2Xum0EYdnqjqso1=twHUfjGZHEASVhUGE-x2g@mail.gmail.com>
References: <20141114204517.GA24402@www.outflux.net>
	<CAE9FiQULexNgTYCrQgQK+ccNTVDyiJCWkgiDVgbPG-5SY0uPGQ@mail.gmail.com>
	<CAE9FiQV=i=+tO2Xum0EYdnqjqso1=twHUfjGZHEASVhUGE-x2g@mail.gmail.com>
Date: Fri, 14 Nov 2014 18:46:20 -0800
X-Google-Sender-Auth: F-Vx81_9y-gw8ojLHknJe0G8zU4
Message-ID: <CAGXu5j+8sEhgmHtdky7G5X2arRsSQSjA=xxuBPPZZAP7v046dg@mail.gmail.com>
Subject: Re: [PATCH v2] x86, mm: set NX across entire PMD at boot
From: Kees Cook <keescook@chromium.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Wang Nan <wangnan0@huawei.com>, David Vrabel <david.vrabel@citrix.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 6:29 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Fri, Nov 14, 2014 at 5:29 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Fri, Nov 14, 2014 at 12:45 PM, Kees Cook <keescook@chromium.org> wrote:
>>> v2:
>>>  - added call to free_init_pages(), as suggested by tglx
>
>> something is wrong:
>>
>> [    7.842479] Freeing unused kernel memory: 3844K (ffffffff82e52000 -
>> ffffffff83213000)
>> [    7.843305] Write protecting the kernel read-only data: 28672k
>
> ....
> should use attached one instead.
>
> 1. should use _brk_end instead of &end, as we only use partial of
>    brk.
> 2. [_brk_end, pm_end) page range is already converted. aka
>    is not wasted.

Are you sure? For me, _brk_end isn't far enough:

[    1.475572] all_end: 0xffffffff82df5000
[    1.476736] _brk_end: 0xffffffff82dd6000

>
> ---
>  arch/x86/mm/init_64.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> Index: linux-2.6/arch/x86/mm/init_64.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/mm/init_64.c
> +++ linux-2.6/arch/x86/mm/init_64.c
> @@ -1124,7 +1124,8 @@ void mark_rodata_ro(void)
>      unsigned long end = (unsigned long) &__end_rodata_hpage_align;
>      unsigned long text_end = PFN_ALIGN(&__stop___ex_table);
>      unsigned long rodata_end = PFN_ALIGN(&__end_rodata);
> -    unsigned long all_end = PFN_ALIGN(&_end);
> +    unsigned long all_end = PFN_ALIGN(_brk_end);
> +    unsigned long pmd_end = roundup(all_end, PMD_SIZE);
>
>      printk(KERN_INFO "Write protecting the kernel read-only data: %luk\n",
>             (end - start) >> 10);
> @@ -1136,7 +1137,7 @@ void mark_rodata_ro(void)
>       * The rodata/data/bss/brk section (but not the kernel text!)
>       * should also be not-executable.
>       */
> -    set_memory_nx(rodata_start, (all_end - rodata_start) >> PAGE_SHIFT);
> +    set_memory_nx(rodata_start, (pmd_end - rodata_start) >> PAGE_SHIFT);
>
>      rodata_test();
>
> @@ -1148,6 +1149,7 @@ void mark_rodata_ro(void)
>      set_memory_ro(start, (end-start) >> PAGE_SHIFT);
>  #endif
>
> +    /* all_end to pmd_end is handled via free_all_bootmem() */
>      free_init_pages("unused kernel",
>              (unsigned long) __va(__pa_symbol(text_end)),
>              (unsigned long) __va(__pa_symbol(rodata_start)));

This patch produces the same results as my v1 patch:

0xffffffff8202d000-0xffffffff82200000  1868K     RW       GLB NX pte
0xffffffff82200000-0xffffffff82e00000    12M     RW   PSE GLB NX pmd
0xffffffff82e00000-0xffffffffc0000000   978M                     pmd

Is this correct? It sounded like tglx wanted the pmd split, like this:

0xffffffff82200000-0xffffffff82c00000    10M     RW   PSE GLB NX pmd
0xffffffff82c00000-0xffffffff82df5000  2004K     RW       GLB NX pte
0xffffffff82df5000-0xffffffff82e00000    44K     RW           NX pte
0xffffffff82e00000-0xffffffffc0000000   978M                     pmd


-Kees

-- 
Kees Cook
Chrome OS Security
