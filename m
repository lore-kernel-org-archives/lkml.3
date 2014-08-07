Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339AbaHGIkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 04:40:55 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:51127 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800AbaHGIkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 04:40:52 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>, Sasha Levin <sasha.levin@oracle.com>,
        "linux-mm\@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>, linuxppc-dev@ozlabs.org
Subject: Re: mm: BUG in unmap_page_range
In-Reply-To: <20140806102316.GX10819@suse.de>
References: <53DD5F20.8010507@oracle.com> <alpine.LSU.2.11.1408040418500.3406@eggly.anvils> <20140805144439.GW10819@suse.de> <871tsudr8a.fsf@linux.vnet.ibm.com> <20140806102316.GX10819@suse.de>
User-Agent: Notmuch/0.18.1 (http://notmuchmail.org) Emacs/24.3.91.1 (x86_64-unknown-linux-gnu)
Date: Thu, 07 Aug 2014 14:10:42 +0530
Message-ID: <87vbq44rqt.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080708-5816-0000-0000-000000602357
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman <mgorman@suse.de> writes:

> On Wed, Aug 06, 2014 at 12:44:45PM +0530, Aneesh Kumar K.V wrote:
>> > -#define pmd_mknonnuma pmd_mknonnuma
>> > -static inline pmd_t pmd_mknonnuma(pmd_t pmd)
>> > +/*
>> > + * Generic NUMA pte helpers expect pteval_t and pmdval_t types to exist
>> > + * which was inherited from x86. For the purposes of powerpc pte_basic_t is
>> > + * equivalent
>> > + */
>> > +#define pteval_t pte_basic_t
>> > +#define pmdval_t pmd_t
>> > +static inline pteval_t pte_flags(pte_t pte)
>> >  {
>> > -	return pte_pmd(pte_mknonnuma(pmd_pte(pmd)));
>> > +	return pte_val(pte) & PAGE_PROT_BITS;
>> 
>> PAGE_PROT_BITS don't get the _PAGE_NUMA and _PAGE_PRESENT. I will have
>> to check further to find out why the mask doesn't include
>> _PAGE_PRESENT. 
>> 
>
> Dumb of me, not sure how I managed that. For the purposes of what is required
> it doesn't matter what PAGE_PROT_BITS does. It is clearer if there is a mask
> that defines what bits are of interest to the generic helpers which is what
> this version attempts to do. It's not tested on powerpc at all
> unfortunately.


Boot tested on ppc64.

# grep numa /proc/vmstat 
numa_hit 156722
numa_miss 0
numa_foreign 0
numa_interleave 6365
numa_local 153457
numa_other 3265
numa_pte_updates 169
numa_huge_pte_updates 0
numa_hint_faults 150
numa_hint_faults_local 138
numa_pages_migrated 10

>
> ---8<---
> mm: Remove misleading ARCH_USES_NUMA_PROT_NONE
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
> This necessitated that a PTE bit mask be created that identified the bits
> that distinguish present from NUMA pte entries but it is expected this
> will only differ between arches based on _PAGE_PROTNONE. The naming for
> the generic helpers was taken from x86 originally but ppc64 has types that
> are equivalent for the purposes of the helper so they are mapped instead
> of duplicating code.
>
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> ---
>  arch/powerpc/include/asm/pgtable.h    | 57 ++++++++---------------------------
>  arch/powerpc/include/asm/pte-common.h |  5 +++
>  arch/x86/Kconfig                      |  1 -
>  arch/x86/include/asm/pgtable_types.h  |  7 +++++
>  include/asm-generic/pgtable.h         | 27 ++++++-----------
>  init/Kconfig                          | 11 -------
>  6 files changed, 33 insertions(+), 75 deletions(-)
>
> diff --git a/arch/powerpc/include/asm/pgtable.h b/arch/powerpc/include/asm/pgtable.h
> index d98c1ec..beeb09e 100644
> --- a/arch/powerpc/include/asm/pgtable.h
> +++ b/arch/powerpc/include/asm/pgtable.h
> @@ -38,10 +38,9 @@ static inline int pte_none(pte_t pte)		{ return (pte_val(pte) & ~_PTE_NONE_MASK)
>  static inline pgprot_t pte_pgprot(pte_t pte)	{ return __pgprot(pte_val(pte) & PAGE_PROT_BITS); }
>
>  #ifdef CONFIG_NUMA_BALANCING
> -
>  static inline int pte_present(pte_t pte)
>  {
> -	return pte_val(pte) & (_PAGE_PRESENT | _PAGE_NUMA);
> +	return pte_val(pte) & _PAGE_NUMA_MASK;
>  }
>
>  #define pte_present_nonuma pte_present_nonuma
> @@ -50,37 +49,6 @@ static inline int pte_present_nonuma(pte_t pte)
>  	return pte_val(pte) & (_PAGE_PRESENT);
>  }
>
> -#define pte_numa pte_numa
> -static inline int pte_numa(pte_t pte)
> -{
> -	return (pte_val(pte) &
> -		(_PAGE_NUMA|_PAGE_PRESENT)) == _PAGE_NUMA;
> -}
> -
> -#define pte_mknonnuma pte_mknonnuma
> -static inline pte_t pte_mknonnuma(pte_t pte)
> -{
> -	pte_val(pte) &= ~_PAGE_NUMA;
> -	pte_val(pte) |=  _PAGE_PRESENT | _PAGE_ACCESSED;
> -	return pte;
> -}
> -
> -#define pte_mknuma pte_mknuma
> -static inline pte_t pte_mknuma(pte_t pte)
> -{
> -	/*
> -	 * We should not set _PAGE_NUMA on non present ptes. Also clear the
> -	 * present bit so that hash_page will return 1 and we collect this
> -	 * as numa fault.
> -	 */
> -	if (pte_present(pte)) {
> -		pte_val(pte) |= _PAGE_NUMA;
> -		pte_val(pte) &= ~_PAGE_PRESENT;
> -	} else
> -		VM_BUG_ON(1);
> -	return pte;
> -}
> -
>  #define ptep_set_numa ptep_set_numa
>  static inline void ptep_set_numa(struct mm_struct *mm, unsigned long addr,
>  				 pte_t *ptep)
> @@ -92,12 +60,6 @@ static inline void ptep_set_numa(struct mm_struct *mm, unsigned long addr,
>  	return;
>  }
>
> -#define pmd_numa pmd_numa
> -static inline int pmd_numa(pmd_t pmd)
> -{
> -	return pte_numa(pmd_pte(pmd));
> -}
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
> + * which was inherited from x86. For the purposes of powerpc pte_basic_t and
> + * pmd_t are equivalent
> + */
> +#define pteval_t pte_basic_t
> +#define pmdval_t pmd_t
> +static inline pteval_t ptenuma_flags(pte_t pte)
>  {
> -	return pte_pmd(pte_mknonnuma(pmd_pte(pmd)));
> +	return pte_val(pte) & _PAGE_NUMA_MASK;
>  }
>
> -#define pmd_mknuma pmd_mknuma
> -static inline pmd_t pmd_mknuma(pmd_t pmd)
> +static inline pmdval_t pmdnuma_flags(pte_t pte)
>  {
> -	return pte_pmd(pte_mknuma(pmd_pte(pmd)));
> +	return pmd_val(pte) & _PAGE_NUMA_MASK;
>  }
>
>  # else

....

> --- a/include/asm-generic/pgtable.h
> +++ b/include/asm-generic/pgtable.h
> @@ -660,11 +660,12 @@ static inline int pmd_trans_unstable(pmd_t *pmd)
>  }
>
>  #ifdef CONFIG_NUMA_BALANCING
> -#ifdef CONFIG_ARCH_USES_NUMA_PROT_NONE
>  /*
> - * _PAGE_NUMA works identical to _PAGE_PROTNONE (it's actually the
> - * same bit too). It's set only when _PAGE_PRESET is not set and it's
> - * never set if _PAGE_PRESENT is set.
> + * _PAGE_NUMA distinguishes between an unmapped page table entry, an entry that
> + * is protected for PROT_NONE and a NUMA hinting fault entry. If the
> + * architecture defines __PAGE_PROTNONE then it should take that into account
> + * but those that do not can rely on the fact that the NUMA hinting scanner
> + * skips inaccessible VMAs.
>   *
>   * pte/pmd_present() returns true if pte/pmd_numa returns true. Page
>   * fault triggers on those regions if pte/pmd_numa returns true
> @@ -673,16 +674,14 @@ static inline int pmd_trans_unstable(pmd_t *pmd)
>  #ifndef pte_numa
>  static inline int pte_numa(pte_t pte)
>  {
> -	return (pte_flags(pte) &
> -		(_PAGE_NUMA|_PAGE_PROTNONE|_PAGE_PRESENT)) == _PAGE_NUMA;
> +	return (ptenuma_flags(pte) & _PAGE_NUMA_MASK) == _PAGE_NUMA;
>  }


Can we avoid & _PAGE_NUMA_MASK ?. I understand that you need that for
x86 because you have

#define ptenuma_flags pte_flags

But on ppc64 you already have

static inline pteval_t ptenuma_flags(pte_t pte)
{
	return pte_val(pte) & _PAGE_NUMA_MASK;
}

-aneesh

