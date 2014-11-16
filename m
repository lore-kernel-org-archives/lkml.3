Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345AbaKPV0s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 16:26:48 -0500
Received: from www.linutronix.de ([62.245.132.108]:58780 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbaKPV0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 16:26:47 -0500
Date: Sun, 16 Nov 2014 22:26:41 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: Kees Cook <keescook@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Wang Nan <wangnan0@huawei.com>, David Vrabel <david.vrabel@citrix.com>
Subject: Re: [PATCH v2] x86, mm: set NX across entire PMD at boot
In-Reply-To: <CAE9FiQWFa3e=XBzQOHQWv68L_H8OpH=k2fxcN-tJy4o0MccBGQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1411162216180.3909@nanos>
References: <20141114204517.GA24402@www.outflux.net> <CAE9FiQULexNgTYCrQgQK+ccNTVDyiJCWkgiDVgbPG-5SY0uPGQ@mail.gmail.com> <CAE9FiQV=i=+tO2Xum0EYdnqjqso1=twHUfjGZHEASVhUGE-x2g@mail.gmail.com> <CAGXu5j+8sEhgmHtdky7G5X2arRsSQSjA=xxuBPPZZAP7v046dg@mail.gmail.com>
 <CAE9FiQVAWYdZvq3QDn-=06QX0+H=RynSS+VVmvTyAaU1BECR_g@mail.gmail.com> <CAE9FiQWFa3e=XBzQOHQWv68L_H8OpH=k2fxcN-tJy4o0MccBGQ@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Nov 2014, Yinghai Lu wrote:
> +static pmd_t *last_pmd;
>  /*
>   * The head.S code sets up the kernel high mapping:
>   *
> @@ -408,9 +409,26 @@ void __init cleanup_highmap(void)
>              continue;
>          if (vaddr < (unsigned long) _text || vaddr > end)
>              set_pmd(pmd, __pmd(0));
> +        else
> +            last_pmd = pmd;

Why do you need to store this? You can compute this.
 
> +static void __init cleanup_highmap_tail(unsigned long addr)

Brilliant stuff. mark_rodata_ro() is called AFTER free_initmem() which
will free exactly that code.

> +{
> +    int i;
> +    pte_t *pte;
> +
> +    if (!last_pmd || pmd_none(*last_pmd))
> +        return;

Aside of the above: This is complete and utter crap. Just another
useless function which can be avoided by switching on brain before
coding.

> Index: linux-2.6/arch/x86/mm/pageattr.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/mm/pageattr.c
> +++ linux-2.6/arch/x86/mm/pageattr.c
> @@ -100,7 +100,7 @@ static inline unsigned long highmap_star
> 
>  static inline unsigned long highmap_end_pfn(void)
>  {
> -    return __pa_symbol(roundup(_brk_end, PMD_SIZE)) >> PAGE_SHIFT;
> +    return __pa_symbol(PFN_ALIGN(_brk_end)) >> PAGE_SHIFT;
>  }

Wrong as well for CONFIG_DEBUG_RODATA=n for obvious reasons.

I know why I have your patches on blacklist ....

Thanks,

	tglx
