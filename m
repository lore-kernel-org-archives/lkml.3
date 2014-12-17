Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbaLQJPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 04:15:52 -0500
Received: from www.linutronix.de ([62.245.132.108]:53522 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbaLQJPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 04:15:50 -0500
Date: Wed, 17 Dec 2014 10:15:40 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Fenghua Yu <fenghua.yu@intel.com>
cc: "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Glenn Williamson <glenn.p.williamson@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH] X86-32: Allocate 256 bytes for pgd in PAE paging
In-Reply-To: <1418784331-8465-1-git-send-email-fenghua.yu@intel.com>
Message-ID: <alpine.DEB.2.11.1412171013400.17382@nanos>
References: <1418784331-8465-1-git-send-email-fenghua.yu@intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2014, Fenghua Yu wrote:
> @@ -1,5 +1,6 @@
>  #include <linux/mm.h>
>  #include <linux/gfp.h>
> +#include <linux/slab.h>
>  #include <asm/pgalloc.h>
>  #include <asm/pgtable.h>
>  #include <asm/tlb.h>
> @@ -276,7 +277,27 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
>  	pgd_t *pgd;
>  	pmd_t *pmds[PREALLOCATED_PMDS];
>  
> +	/*
> +	 * Xen paravirt assumes pgd table should be in one page. pgd in
> +	 * 64 bit also needs to be in one page.
> +	 *
> +	 * But PAE without Xen only needs to allocate 256 bytes for pgd.
> +	 *
> +	 * So if kernel is compiled as PAE model without Xen, we allocate
> +	 * 256 bytes for pgd entries to save memory space.
> +	 *
> +	 * In other cases, one page is allocated for pgd. In theory, a kernel
> +	 * in PAE mode not running in Xen could allocate 256 bytes for pgd
> +	 * as well. But that will make the allocation and free more complex
> +	 * but not useful in reality. To simplify the code and testing, we just
> +	 * allocate one page when CONFIG_XEN is enabled regardelss kernel
> +	 * is running in Xen or not.
> +	 */
> +#if defined(CONFIG_X86_PAE) && !defined(CONFIG_XEN)
> +	pgd = kmalloc(sizeof(pgdval_t) * PTRS_PER_PGD, PGALLOC_GFP);
> +#else
>  	pgd = (pgd_t *)__get_free_page(PGALLOC_GFP);
> +#endif
>  
>  	if (pgd == NULL)
>  		goto out;
> @@ -306,7 +327,11 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
>  out_free_pmds:
>  	free_pmds(pmds);
>  out_free_pgd:
> +#if defined(CONFIG_X86_PAE) && !defined(CONFIG_XEN)
> +	kfree(pgd);
> +#else
>  	free_page((unsigned long)pgd);
> +#endif
>  out:
>  	return NULL;
>  }
> @@ -316,7 +341,12 @@ void pgd_free(struct mm_struct *mm, pgd_t *pgd)
>  	pgd_mop_up_pmds(mm, pgd);
>  	pgd_dtor(pgd);
>  	paravirt_pgd_free(mm, pgd);
> +#if defined(CONFIG_X86_PAE) && !defined(CONFIG_XEN)
> +	kfree(pgd);
> +#else
>  	free_page((unsigned long)pgd);
> +#endif

Can you make that please readable with proper inline helpers? This
#ifdef maze is horrible.

Thanks,

	tglx


