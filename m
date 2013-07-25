Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612Ab3GYKq1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 06:46:27 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:35699 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab3GYKqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 06:46:24 -0400
Message-ID: <51F101F9.3090308@de.ibm.com>
Date: Thu, 25 Jul 2013 12:46:17 +0200
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Konstantin Weitz <konstantin.weitz@gmail.com>
Subject: Re: [PATCH 1/2] mm: add support for discard of unused ptes
References: <1374742461-29160-1-git-send-email-schwidefsky@de.ibm.com> <1374742461-29160-2-git-send-email-schwidefsky@de.ibm.com>
In-Reply-To: <1374742461-29160-2-git-send-email-schwidefsky@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072510-5024-0000-0000-000006AFBB06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/07/13 10:54, Martin Schwidefsky wrote:
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
> [ Martin Schwidefsky: patch reordering and simplification ]
> 
> Signed-off-by: Konstantin Weitz <konstantin.weitz@gmail.com>
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>

> ---
>  include/asm-generic/pgtable.h |   13 +++++++++++++
>  mm/rmap.c                     |   10 ++++++++++
>  2 files changed, 23 insertions(+)
> 
> diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
> index 2f47ade..ec540c5 100644
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
> 

