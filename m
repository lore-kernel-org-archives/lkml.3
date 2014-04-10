Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935217AbaDJKFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 06:05:22 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:60989 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935022AbaDJKFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 06:05:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140401040705.152847420@linuxfoundation.org>
References: <20140401040703.045139933@linuxfoundation.org>
	<20140401040705.152847420@linuxfoundation.org>
Date: Thu, 10 Apr 2014 03:05:10 -0700
Message-ID: <CAKbGBLj3Ep7DkJsMFfRt0Kv80DTL6FS4RbOZWgZuesSU58JJhg@mail.gmail.com>
Subject: Re: [PATCH 3.13 08/22] Revert "xen: properly account for _PAGE_NUMA
 during xen pte translations"
From: Steven Noonan <steven@uplinklabs.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Kernel mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I realize it's late to protest on this given that 3.13.9 is out, but
what is the path forward for those experiencing the original issue
that the reverted commit was intended to correct?

http://marc.info/?l=linux-kernel&m=139034684731087&w=2

On Mon, Mar 31, 2014 at 9:08 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> 3.13-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: David Vrabel <david.vrabel@citrix.com>
>
> commit 5926f87fdaad4be3ed10cec563bf357915e55a86 upstream.
>
> This reverts commit a9c8e4beeeb64c22b84c803747487857fe424b68.
>
> PTEs in Xen PV guests must contain machine addresses if _PAGE_PRESENT
> is set and pseudo-physical addresses is _PAGE_PRESENT is clear.
>
> This is because during a domain save/restore (migration) the page
> table entries are "canonicalised" and uncanonicalised". i.e., MFNs are
> converted to PFNs during domain save so that on a restore the page
> table entries may be rewritten with the new MFNs on the destination.
> This canonicalisation is only done for PTEs that are present.
>
> This change resulted in writing PTEs with MFNs if _PAGE_PROTNONE (or
> _PAGE_NUMA) was set but _PAGE_PRESENT was clear.  These PTEs would be
> migrated as-is which would result in unexpected behaviour in the
> destination domain.  Either a) the MFN would be translated to the
> wrong PFN/page; b) setting the _PAGE_PRESENT bit would clear the PTE
> because the MFN is no longer owned by the domain; or c) the present
> bit would not get set.
>
> Symptoms include "Bad page" reports when munmapping after migrating a
> domain.
>
> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
> Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> ---
>  arch/x86/include/asm/pgtable.h |   14 ++------------
>  arch/x86/xen/mmu.c             |    4 ++--
>  2 files changed, 4 insertions(+), 14 deletions(-)
>
> --- a/arch/x86/include/asm/pgtable.h
> +++ b/arch/x86/include/asm/pgtable.h
> @@ -445,20 +445,10 @@ static inline int pte_same(pte_t a, pte_
>         return a.pte == b.pte;
>  }
>
> -static inline int pteval_present(pteval_t pteval)
> -{
> -       /*
> -        * Yes Linus, _PAGE_PROTNONE == _PAGE_NUMA. Expressing it this
> -        * way clearly states that the intent is that protnone and numa
> -        * hinting ptes are considered present for the purposes of
> -        * pagetable operations like zapping, protection changes, gup etc.
> -        */
> -       return pteval & (_PAGE_PRESENT | _PAGE_PROTNONE | _PAGE_NUMA);
> -}
> -
>  static inline int pte_present(pte_t a)
>  {
> -       return pteval_present(pte_flags(a));
> +       return pte_flags(a) & (_PAGE_PRESENT | _PAGE_PROTNONE |
> +                              _PAGE_NUMA);
>  }
>
>  #define pte_accessible pte_accessible
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -365,7 +365,7 @@ void xen_ptep_modify_prot_commit(struct
>  /* Assume pteval_t is equivalent to all the other *val_t types. */
>  static pteval_t pte_mfn_to_pfn(pteval_t val)
>  {
> -       if (pteval_present(val)) {
> +       if (val & _PAGE_PRESENT) {
>                 unsigned long mfn = (val & PTE_PFN_MASK) >> PAGE_SHIFT;
>                 unsigned long pfn = mfn_to_pfn(mfn);
>
> @@ -381,7 +381,7 @@ static pteval_t pte_mfn_to_pfn(pteval_t
>
>  static pteval_t pte_pfn_to_mfn(pteval_t val)
>  {
> -       if (pteval_present(val)) {
> +       if (val & _PAGE_PRESENT) {
>                 unsigned long pfn = (val & PTE_PFN_MASK) >> PAGE_SHIFT;
>                 pteval_t flags = val & PTE_FLAGS_MASK;
>                 unsigned long mfn;
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
