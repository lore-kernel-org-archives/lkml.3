Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832AbaLJShE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 13:37:04 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:45282 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087AbaLJShC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 13:37:02 -0500
MIME-Version: 1.0
In-Reply-To: <f0f3eab5f68f74bfabf42d745ccf1e2ecf642683.1418006970.git.shli@fb.com>
References: <f0f3eab5f68f74bfabf42d745ccf1e2ecf642683.1418006970.git.shli@fb.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 10 Dec 2014 10:36:39 -0800
Message-ID: <CALCETrUaR_wdSQOZJwhPJzr78-gVX=fLo=Uz-Xd=EYZfJSuJfg@mail.gmail.com>
Subject: Re: [PATCH 1/3] X86: make VDSO data support multiple pages
To: Shaohua Li <shli@fb.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, kernel-team@fb.com,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 7, 2014 at 7:03 PM, Shaohua Li <shli@fb.com> wrote:
> Currently vdso data is one page. Next patches will add per-cpu data to
> vdso, which requires several pages if CPU number is big. This makes VDSO
> data support multiple pages.

Can you rename __vvar_page to __vvar_pages?

>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  arch/x86/include/asm/vvar.h     | 6 +++++-
>  arch/x86/kernel/asm-offsets.c   | 5 +++++
>  arch/x86/kernel/vmlinux.lds.S   | 4 +---
>  arch/x86/vdso/vdso-layout.lds.S | 5 +++--
>  arch/x86/vdso/vma.c             | 3 ++-
>  5 files changed, 16 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/include/asm/vvar.h b/arch/x86/include/asm/vvar.h
> index 5d2b9ad..fcbe621 100644
> --- a/arch/x86/include/asm/vvar.h
> +++ b/arch/x86/include/asm/vvar.h
> @@ -47,7 +47,11 @@ extern char __vvar_page;
>  DECLARE_VVAR(0, volatile unsigned long, jiffies)
>  DECLARE_VVAR(16, int, vgetcpu_mode)
>  DECLARE_VVAR(128, struct vsyscall_gtod_data, vsyscall_gtod_data)
> -
> +/*
> + * you must update VVAR_TOTAL_SIZE to reflect all of the variables we're
> + * stuffing into the vvar area.  Don't change any of the above without
> + * also changing this math of VVAR_TOTAL_SIZE
> + */
>  #undef DECLARE_VVAR
>
>  #endif
> diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
> index 9f6b934..0ab31a9 100644
> --- a/arch/x86/kernel/asm-offsets.c
> +++ b/arch/x86/kernel/asm-offsets.c
> @@ -16,6 +16,7 @@
>  #include <asm/sigframe.h>
>  #include <asm/bootparam.h>
>  #include <asm/suspend.h>
> +#include <asm/vgtod.h>
>
>  #ifdef CONFIG_XEN
>  #include <xen/interface/xen.h>
> @@ -71,4 +72,8 @@ void common(void) {
>
>         BLANK();
>         DEFINE(PTREGS_SIZE, sizeof(struct pt_regs));
> +
> +       BLANK();
> +       DEFINE(VVAR_TOTAL_SIZE,
> +               ALIGN(128 + sizeof(struct vsyscall_gtod_data), PAGE_SIZE));

Perhaps add:

BUILD_BUG_ON(VVAR_TOTAL_SIZE % PAGE_SIZE != 0);

or just keep the alignment stuff that you removed.

Although, TBH, this is still rather ugly IMO.  Maybe we should just
have struct vvar somewhere and make everything use it.  We couldn't do
that before because of jiffies and such, but those are all gone now.

--Andy

--Andy

>  }
> diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
> index 49edf2d..8b11307 100644
> --- a/arch/x86/kernel/vmlinux.lds.S
> +++ b/arch/x86/kernel/vmlinux.lds.S
> @@ -168,11 +168,9 @@ SECTIONS
>                  * Pad the rest of the page with zeros.  Otherwise the loader
>                  * can leave garbage here.
>                  */
> -               . = __vvar_beginning_hack + PAGE_SIZE;
> +               . = __vvar_beginning_hack + VVAR_TOTAL_SIZE;
>         } :data
>
> -       . = ALIGN(__vvar_page + PAGE_SIZE, PAGE_SIZE);
> -
>         /* Init code and data - will be freed after init */
>         . = ALIGN(PAGE_SIZE);
>         .init.begin : AT(ADDR(.init.begin) - LOAD_OFFSET) {
> diff --git a/arch/x86/vdso/vdso-layout.lds.S b/arch/x86/vdso/vdso-layout.lds.S
> index de2c921..acaf8ce 100644
> --- a/arch/x86/vdso/vdso-layout.lds.S
> +++ b/arch/x86/vdso/vdso-layout.lds.S
> @@ -1,4 +1,5 @@
>  #include <asm/vdso.h>
> +#include <asm/asm-offsets.h>
>
>  /*
>   * Linker script for vDSO.  This is an ELF shared object prelinked to
> @@ -25,7 +26,7 @@ SECTIONS
>          * segment.
>          */
>
> -       vvar_start = . - 2 * PAGE_SIZE;
> +       vvar_start = . - (VVAR_TOTAL_SIZE + PAGE_SIZE);
>         vvar_page = vvar_start;
>
>         /* Place all vvars at the offsets in asm/vvar.h. */
> @@ -35,7 +36,7 @@ SECTIONS
>  #undef __VVAR_KERNEL_LDS
>  #undef EMIT_VVAR
>
> -       hpet_page = vvar_start + PAGE_SIZE;
> +       hpet_page = vvar_start + VVAR_TOTAL_SIZE;
>
>         . = SIZEOF_HEADERS;
>
> diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
> index 970463b..fc37067 100644
> --- a/arch/x86/vdso/vma.c
> +++ b/arch/x86/vdso/vma.c
> @@ -16,6 +16,7 @@
>  #include <asm/vdso.h>
>  #include <asm/page.h>
>  #include <asm/hpet.h>
> +#include <asm/asm-offsets.h>
>
>  #if defined(CONFIG_X86_64)
>  unsigned int __read_mostly vdso64_enabled = 1;
> @@ -150,7 +151,7 @@ static int map_vdso(const struct vdso_image *image, bool calculate_addr)
>                 ret = remap_pfn_range(vma,
>                                       text_start + image->sym_vvar_page,
>                                       __pa_symbol(&__vvar_page) >> PAGE_SHIFT,
> -                                     PAGE_SIZE,
> +                                     VVAR_TOTAL_SIZE,
>                                       PAGE_READONLY);
>
>         if (ret)
> --
> 1.8.1
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
