Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757770Ab3G3UoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 16:44:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47357 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756924Ab3G3UoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 16:44:23 -0400
Date: Tue, 30 Jul 2013 13:44:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Konstantin Weitz <konstantin.weitz@gmail.com>
Subject: Re: [PATCH 1/2] mm: add support for discard of unused ptes
Message-Id: <20130730134422.98c0977eada81d3ac41a08bb@linux-foundation.org>
In-Reply-To: <1374742461-29160-2-git-send-email-schwidefsky@de.ibm.com>
References: <1374742461-29160-1-git-send-email-schwidefsky@de.ibm.com>
	<1374742461-29160-2-git-send-email-schwidefsky@de.ibm.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jul 2013 10:54:20 +0200 Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> From: Konstantin Weitz <konstantin.weitz@gmail.com>
> 
> In a virtualized environment and given an appropriate interface the guest
> can mark pages as unused while they are free (for the s390 implementation
> see git commit 45e576b1c3d00206 "guest page hinting light"). For the host
> the unused state is a property of the pte.
> 
> This patch adds the primitive 'pte_unused' and code to the host swap out
> handler so that pages marked as unused by all mappers are not swapped out
> but discarded instead, thus saving one IO for swap out and potentially
> another one for swap in.
> 
> ...
>
> --- a/include/asm-generic/pgtable.h
> +++ b/include/asm-generic/pgtable.h
> @@ -193,6 +193,19 @@ static inline int pte_same(pte_t pte_a, pte_t pte_b)
>  }
>  #endif
>  
> +#ifndef __HAVE_ARCH_PTE_UNUSED
> +/*
> + * Some architectures provide facilities to virtualization guests
> + * so that they can flag allocated pages as unused. This allows the
> + * host to transparently reclaim unused pages. This function returns
> + * whether the pte's page is unused.
> + */
> +static inline int pte_unused(pte_t pte)
> +{
> +	return 0;
> +}
> +#endif
> +
>  #ifndef __HAVE_ARCH_PMD_SAME
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>  static inline int pmd_same(pmd_t pmd_a, pmd_t pmd_b)
> diff --git a/mm/rmap.c b/mm/rmap.c
> index cd356df..2291f25 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1234,6 +1234,16 @@ int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
>  		}
>  		set_pte_at(mm, address, pte,
>  			   swp_entry_to_pte(make_hwpoison_entry(page)));
> +	} else if (pte_unused(pteval)) {
> +		/*
> +		 * The guest indicated that the page content is of no
> +		 * interest anymore. Simply discard the pte, vmscan
> +		 * will take care of the rest.
> +		 */
> +		if (PageAnon(page))
> +			dec_mm_counter(mm, MM_ANONPAGES);
> +		else
> +			dec_mm_counter(mm, MM_FILEPAGES);
>  	} else if (PageAnon(page)) {
>  		swp_entry_t entry = { .val = page_private(page) };

Obviously harmless.  Please include this in whatever tree carries
"[PATCH 2/2] s390/kvm: support collaborative memory management".
