Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008AbaKNUMS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 15:12:18 -0500
Received: from www.linutronix.de ([62.245.132.108]:54943 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbaKNUMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 15:12:17 -0500
Date: Fri, 14 Nov 2014 21:12:09 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Kees Cook <keescook@chromium.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>, Toshi Kani <toshi.kani@hp.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        David Vrabel <david.vrabel@citrix.com>, Wang Nan <wangnan0@huawei.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] x86, mm: set NX across entire PMD at boot
In-Reply-To: <20141114194737.GA3091@www.outflux.net>
Message-ID: <alpine.DEB.2.11.1411142109240.3909@nanos>
References: <20141114194737.GA3091@www.outflux.net>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2014, Kees Cook wrote:

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
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/x86/mm/init_64.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index 4cb8763868fc..7da7a4ab46f7 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -1123,7 +1123,9 @@ void mark_rodata_ro(void)
>  	unsigned long end = (unsigned long) &__end_rodata_hpage_align;
>  	unsigned long text_end = PFN_ALIGN(&__stop___ex_table);
>  	unsigned long rodata_end = PFN_ALIGN(&__end_rodata);
> -	unsigned long all_end = PFN_ALIGN(&_end);
> +	/* End of kernel memory will span a PMD, so align to PMD. */
> +	unsigned long all_end = (((unsigned long)(&_end) + (PMD_SIZE - 1))
> +				 & PMD_MASK);

I prefer to free the leftover pages like we do with the init
sections. In the above example it's only 44k, but it can be 2044k in
the worst case, which was enough to boot a embedded box 15 years ago :)

Thanks,

	tglx
