Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab3BFPjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 10:39:18 -0500
Received: from mail-vc0-f173.google.com ([209.85.220.173]:44046 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755962Ab3BFPjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 10:39:17 -0500
Date: Wed, 6 Feb 2013 10:39:13 -0500
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Mukesh Rathor <mukesh.rathor@oracle.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>
Subject: Re: [PATCH] PVH: remove code to map iomem from guest
Message-ID: <20130206153910.GA23029@konrad-lan.dumpdata.com>
References: <20130130145529.3900dca1@mantra.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130130145529.3900dca1@mantra.us.oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 02:55:29PM -0800, Mukesh Rathor wrote:
> It was decided during xen patch review that xen map the iomem
> transparently, so remove xen_set_clr_mmio_pvh_pte() and the sub
> hypercall PHYSDEVOP_map_iomem.
> 

Grrrr..

No Signed-off-by??

> ---
>  arch/x86/xen/mmu.c              |   14 --------------
>  arch/x86/xen/setup.c            |   16 ++++------------
>  include/xen/interface/physdev.h |   10 ----------
>  3 files changed, 4 insertions(+), 36 deletions(-)
> 
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index b4be4c9..fbf6a63 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -333,20 +333,6 @@ static void xen_set_pte(pte_t *ptep, pte_t pteval)
>  	__xen_set_pte(ptep, pteval);
>  }
>  
> -void xen_set_clr_mmio_pvh_pte(unsigned long pfn, unsigned long mfn,
> -			      int nr_mfns, int add_mapping)
> -{
> -	struct physdev_map_iomem iomem;
> -
> -	iomem.first_gfn = pfn;
> -	iomem.first_mfn = mfn;
> -	iomem.nr_mfns = nr_mfns;
> -	iomem.add_mapping = add_mapping;
> -
> -	if (HYPERVISOR_physdev_op(PHYSDEVOP_map_iomem, &iomem))
> -		BUG();
> -}
> -
>  static void xen_set_pte_at(struct mm_struct *mm, unsigned long addr,
>  		    pte_t *ptep, pte_t pteval)
>  {
> diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
> index 7e93ec9..6532172 100644
> --- a/arch/x86/xen/setup.c
> +++ b/arch/x86/xen/setup.c
> @@ -235,20 +235,12 @@ static void __init xen_set_identity_and_release_chunk(
>  	*identity += set_phys_range_identity(start_pfn, end_pfn);
>  }
>  
> -/* For PVH, the pfns [0..MAX] are mapped to mfn's in the EPT/NPT. The mfns
> - * are released as part of this 1:1 mapping hypercall back to the dom heap.
> - * Also, we map the entire IO space, ie, beyond max_pfn_mapped.
> - */
> -static void __init xen_pvh_identity_map_chunk(unsigned long start_pfn,
> +/* PVH: xen has already mapped the IO space in the EPT/NPT for us, so we
> + * just need to adjust the released and identity count */
> +static void __init xen_pvh_adjust_stats(unsigned long start_pfn,
>  		unsigned long end_pfn, unsigned long max_pfn,
>  		unsigned long *released, unsigned long *identity)
>  {
> -	unsigned long pfn;
> -	int numpfns = 1, add_mapping = 1;
> -
> -	for (pfn = start_pfn; pfn < end_pfn; pfn++)
> -		xen_set_clr_mmio_pvh_pte(pfn, pfn, numpfns, add_mapping);
> -
>  	if (start_pfn <= max_pfn) {
>  		unsigned long end = min(max_pfn_mapped, end_pfn);
>  		*released += end - start_pfn;
> @@ -288,7 +280,7 @@ static unsigned long __init xen_set_identity_and_release(
>  
>  			if (start_pfn < end_pfn) {
>  				if (xlated_phys) {
> -					xen_pvh_identity_map_chunk(start_pfn,
> +					xen_pvh_adjust_stats(start_pfn,
>  						end_pfn, nr_pages, &released, 
>  						&identity);
>  				} else {
> diff --git a/include/xen/interface/physdev.h b/include/xen/interface/physdev.h
> index 83050d3..1844d31 100644
> --- a/include/xen/interface/physdev.h
> +++ b/include/xen/interface/physdev.h
> @@ -274,16 +274,6 @@ struct physdev_dbgp_op {
>      } u;
>  };
>  
> -#define PHYSDEVOP_map_iomem        30
> -struct physdev_map_iomem {
> -    /* IN */
> -    uint64_t first_gfn;
> -    uint64_t first_mfn;
> -    uint32_t nr_mfns;
> -    uint32_t add_mapping; /* 1 == add mapping;  0 == unmap */
> -
> -};
> -
>  /*
>   * Notify that some PIRQ-bound event channels have been unmasked.
>   * ** This command is obsolete since interface version 0x00030202 and is **
> -- 
> 1.7.2.3
> 
