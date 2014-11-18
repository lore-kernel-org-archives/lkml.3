Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386AbaKRR4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 12:56:37 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:59462 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534AbaKRR4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 12:56:36 -0500
MIME-Version: 1.0
In-Reply-To: <tip-45e2a9d4701d8c624d4a4bcdd1084eae31e92f58@git.kernel.org>
References: <20141114194737.GA3091@www.outflux.net>
	<tip-45e2a9d4701d8c624d4a4bcdd1084eae31e92f58@git.kernel.org>
Date: Tue, 18 Nov 2014 09:56:35 -0800
X-Google-Sender-Auth: V5UBR3FhgGVlY59XSYz9DKTRjAU
Message-ID: <CAE9FiQUyU4o=M6zG0q4k2Rfb1ZNyOKwTM2HBAkz+U0ypvKaLbA@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86, mm: Set NX across entire PMD at boot
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        David Vrabel <david.vrabel@citrix.com>,
        Yinghai Lu <yinghai@kernel.org>, Toshi Kani <toshi.kani@hp.com>,
        Wang Nan <wangnan0@huawei.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>
Cc: "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 9:40 AM, tip-bot for Kees Cook <tipbot@zytor.com> wrote:
> Commit-ID:  45e2a9d4701d8c624d4a4bcdd1084eae31e92f58
> Gitweb:     http://git.kernel.org/tip/45e2a9d4701d8c624d4a4bcdd1084eae31e92f58
> Author:     Kees Cook <keescook@chromium.org>
> AuthorDate: Fri, 14 Nov 2014 11:47:37 -0800
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Tue, 18 Nov 2014 18:32:24 +0100
>
> x86, mm: Set NX across entire PMD at boot
>
> When setting up permissions on kernel memory at boot, the end of the
> PMD that was split from bss remained executable. It should be NX like
> the rest. This performs a PMD alignment instead of a PAGE alignment to
> get the correct span of memory.
>
> Before:
> ---[ High Kernel Mapping ]---
> ...
> 0xffffffff8202d000-0xffffffff82200000  1868K     RW       GLB NX pte
> 0xffffffff82200000-0xffffffff82c00000    10M     RW   PSE GLB NX pmd
> 0xffffffff82c00000-0xffffffff82df5000  2004K     RW       GLB NX pte
> 0xffffffff82df5000-0xffffffff82e00000    44K     RW       GLB x  pte
> 0xffffffff82e00000-0xffffffffc0000000   978M                     pmd
>
> After:
> ---[ High Kernel Mapping ]---
> ...
> 0xffffffff8202d000-0xffffffff82200000  1868K     RW       GLB NX pte
> 0xffffffff82200000-0xffffffff82e00000    12M     RW   PSE GLB NX pmd
> 0xffffffff82e00000-0xffffffffc0000000   978M                     pmd
>
> [ tglx: Changed it to roundup(_brk_end, PMD_SIZE) and added a comment.
>         We really should unmap the reminder along with the holes
>         caused by init,initdata etc. but thats a different issue ]
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Toshi Kani <toshi.kani@hp.com>
> Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Cc: David Vrabel <david.vrabel@citrix.com>
> Cc: Wang Nan <wangnan0@huawei.com>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: stable@vger.kernel.org
> Link: http://lkml.kernel.org/r/20141114194737.GA3091@www.outflux.net
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/x86/mm/init_64.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index 4cb8763..4e5dfec 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -1123,7 +1123,7 @@ void mark_rodata_ro(void)
>         unsigned long end = (unsigned long) &__end_rodata_hpage_align;
>         unsigned long text_end = PFN_ALIGN(&__stop___ex_table);
>         unsigned long rodata_end = PFN_ALIGN(&__end_rodata);
> -       unsigned long all_end = PFN_ALIGN(&_end);
> +       unsigned long all_end;
>
>         printk(KERN_INFO "Write protecting the kernel read-only data: %luk\n",
>                (end - start) >> 10);
> @@ -1134,7 +1134,16 @@ void mark_rodata_ro(void)
>         /*
>          * The rodata/data/bss/brk section (but not the kernel text!)
>          * should also be not-executable.
> +        *
> +        * We align all_end to PMD_SIZE because the existing mapping
> +        * is a full PMD. If we would align _brk_end to PAGE_SIZE we
> +        * split the PMD and the reminder between _brk_end and the end
> +        * of the PMD will remain mapped executable.
> +        *
> +        * Any PMD which was setup after the one which covers _brk_end
> +        * has been zapped already via cleanup_highmem().

should be cleanup_highmap()

>          */
> +       all_end = roundup((unsigned long)_brk_end, PMD_SIZE);

Why do you need cast here ?

>         set_memory_nx(rodata_start, (all_end - rodata_start) >> PAGE_SHIFT);
>
>         rodata_test();
