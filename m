Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbaHFHPD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 03:15:03 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:33569 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853AbaHFHPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 03:15:00 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        "linux-mm\@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>, linuxppc-dev@ozlabs.org
Subject: Re: mm: BUG in unmap_page_range
In-Reply-To: <20140805144439.GW10819@suse.de>
References: <53DD5F20.8010507@oracle.com> <alpine.LSU.2.11.1408040418500.3406@eggly.anvils> <20140805144439.GW10819@suse.de>
User-Agent: Notmuch/0.18.1 (http://notmuchmail.org) Emacs/24.3.91.1 (x86_64-unknown-linux-gnu)
Date: Wed, 06 Aug 2014 12:44:45 +0530
Message-ID: <871tsudr8a.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080607-0260-0000-0000-0000000A6C73
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman <mgorman@suse.de> writes:

> From d0c77a2b497da46c52792ead066d461e5111a594 Mon Sep 17 00:00:00 2001
> From: Mel Gorman <mgorman@suse.de>
> Date: Tue, 5 Aug 2014 12:06:50 +0100
> Subject: [PATCH] mm: Remove misleading ARCH_USES_NUMA_PROT_NONE
>
> ARCH_USES_NUMA_PROT_NONE was defined for architectures that implemented
> _PAGE_NUMA using _PROT_NONE. This saved using an additional PTE bit and
> relied on the fact that PROT_NONE vmas were skipped by the NUMA hinting
> fault scanner. This was found to be conceptually confusing with a lot of
> implicit assumptions and it was asked that an alternative be found.
>
> Commit c46a7c81 "x86: define _PAGE_NUMA by reusing software bits on the
> PMD and PTE levels" redefined _PAGE_NUMA on x86 to be one of the swap
> PTE bits and shrunk the maximum possible swap size but it did not go far
> enough. There are no architectures that reuse _PROT_NONE as _PROT_NUMA
> but the relics still exist.
>
> This patch removes ARCH_USES_NUMA_PROT_NONE and removes some unnecessary
> duplication in powerpc vs the generic implementation by defining the types
> the core NUMA helpers expected to exist from x86 with their ppc64 equivalent.
> The unification for ppc64 is less than ideal because types do not exist
> that the "generic" code expects to. This patch works around the problem
> but it would be preferred if the powerpc people would look at this to see
> if they have opinions on what might suit them better.
>
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> ---
>  arch/powerpc/include/asm/pgtable.h | 55 ++++++++------------------------------
>  arch/x86/Kconfig                   |  1 -
>  include/asm-generic/pgtable.h      | 35 ++++++++++++------------
>  init/Kconfig                       | 11 --------
>  4 files changed, 29 insertions(+), 73 deletions(-)
>

....

> -
>  #define pmdp_set_numa pmdp_set_numa
>  static inline void pmdp_set_numa(struct mm_struct *mm, unsigned long addr,
>  				 pmd_t *pmdp)
> @@ -109,16 +71,21 @@ static inline void pmdp_set_numa(struct mm_struct *mm, unsigned long addr,
>  	return;
>  }
>  
> -#define pmd_mknonnuma pmd_mknonnuma
> -static inline pmd_t pmd_mknonnuma(pmd_t pmd)
> +/*
> + * Generic NUMA pte helpers expect pteval_t and pmdval_t types to exist
> + * which was inherited from x86. For the purposes of powerpc pte_basic_t is
> + * equivalent
> + */
> +#define pteval_t pte_basic_t
> +#define pmdval_t pmd_t
> +static inline pteval_t pte_flags(pte_t pte)
>  {
> -	return pte_pmd(pte_mknonnuma(pmd_pte(pmd)));
> +	return pte_val(pte) & PAGE_PROT_BITS;

PAGE_PROT_BITS don't get the _PAGE_NUMA and _PAGE_PRESENT. I will have
to check further to find out why the mask doesn't include
_PAGE_PRESENT. 


>  }
>  
> -#define pmd_mknuma pmd_mknuma
> -static inline pmd_t pmd_mknuma(pmd_t pmd)
> +static inline pteval_t pmd_flags(pte_t pte)
>  {


static inline pmdval_t ?

> -	return pte_pmd(pte_mknuma(pmd_pte(pmd)));
> +	return pmd_val(pte) & PAGE_PROT_BITS;
>  }
>  

-aneesh

