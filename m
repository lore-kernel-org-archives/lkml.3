Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbaKCTBl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 14:01:41 -0500
Received: from www.linutronix.de ([62.245.132.108]:55006 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329AbaKCTBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 14:01:40 -0500
Date: Mon, 3 Nov 2014 20:01:26 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Toshi Kani <toshi.kani@hp.com>
cc: hpa@zytor.com, mingo@redhat.com, akpm@linux-foundation.org, arnd@arndb.de,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, jgross@suse.com,
        stefan.bader@canonical.com, luto@amacapital.net, hmh@hmh.eng.br,
        yigal@plexistor.com, konrad.wilk@oracle.com
Subject: Re: [PATCH v4 5/7] x86, mm, pat: Refactor !pat_enabled handling
In-Reply-To: <1414450545-14028-6-git-send-email-toshi.kani@hp.com>
Message-ID: <alpine.DEB.2.11.1411031957330.5308@nanos>
References: <1414450545-14028-1-git-send-email-toshi.kani@hp.com> <1414450545-14028-6-git-send-email-toshi.kani@hp.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2014, Toshi Kani wrote:
> diff --git a/arch/x86/mm/iomap_32.c b/arch/x86/mm/iomap_32.c
> index ee58a0b..96aa8bf 100644
> --- a/arch/x86/mm/iomap_32.c
> +++ b/arch/x86/mm/iomap_32.c
> @@ -70,29 +70,23 @@ void *kmap_atomic_prot_pfn(unsigned long pfn, pgprot_t prot)
>  	return (void *)vaddr;
>  }
>  
> -/*
> - * Map 'pfn' using protections 'prot'
> - */
> -#define __PAGE_KERNEL_WC	(__PAGE_KERNEL | \
> -				 cachemode2protval(_PAGE_CACHE_MODE_WC))
> -
>  void __iomem *
>  iomap_atomic_prot_pfn(unsigned long pfn, pgprot_t prot)
>  {
>  	/*
> -	 * For non-PAT systems, promote PAGE_KERNEL_WC to PAGE_KERNEL_UC_MINUS.
> -	 * PAGE_KERNEL_WC maps to PWT, which translates to uncached if the
> -	 * MTRR is UC or WC.  UC_MINUS gets the real intention, of the
> -	 * user, which is "WC if the MTRR is WC, UC if you can't do that."
> +	 * For non-PAT systems, translate non-WB request to UC- just in
> +	 * case the caller set the PWT bit to prot directly without using
> +	 * pgprot_writecombine(). UC- translates to uncached if the MTRR
> +	 * is UC or WC. UC- gets the real intention, of the user, which is
> +	 * "WC if the MTRR is WC, UC if you can't do that."
>  	 */
> -	if (!pat_enabled && pgprot_val(prot) == __PAGE_KERNEL_WC)
> +	if (!pat_enabled && pgprot2cachemode(prot) != _PAGE_CACHE_MODE_WB)
>  		prot = __pgprot(__PAGE_KERNEL |
>  				cachemode2protval(_PAGE_CACHE_MODE_UC_MINUS));
>  
>  	return (void __force __iomem *) kmap_atomic_prot_pfn(pfn, prot);
>  }
>  EXPORT_SYMBOL_GPL(iomap_atomic_prot_pfn);
> -#undef __PAGE_KERNEL_WC

Rejects. Please update against Juergens latest.
  
Thanks,

	tglx
