Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960Ab3J1QxH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 12:53:07 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:44127 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323Ab3J1QxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 12:53:05 -0400
Date: Mon, 28 Oct 2013 12:52:39 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <dvrabel@cantab.net>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Santosh.Jodh@citrix.com, JBeulich@suse.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, mukesh.rathor@oracle.com,
        xhejtman@ics.muni.cz, yuval.shaia@oracle.com
Subject: Re: [Xen-devel] [PATCH v1] Set 1-1 P2M for PCI BARs and MCFG regions
 - if needed.
Message-ID: <20131028165239.GG4353@phenom.dumpdata.com>
References: <1382713401-4882-1-git-send-email-konrad.wilk@oracle.com>
 <526AF79A.3050002@cantab.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <526AF79A.3050002@cantab.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 11:58:34PM +0100, David Vrabel wrote:
> On 25/10/13 16:03, Konrad Rzeszutek Wilk wrote:
> >
> >  2). Assume that INVALID_P2M_ENTRY is considered 1-1. That would require
> >     auditing of the code and also making sure that any xen_privcmd_mmap
> >     calls use the m2p_add_override.
> 
> I'm not sure I understand the concern about the privcmd driver's
> foreign mapping ioctls (MMAPBATCH_V2 and friends) as these all deal
> with MFNs directly and don't use the p2m.
> 
> >     However there are some
> >     valid cases in which we need to check for INVALID_P2M_ENTRY -
> >     balloon driver - that might be relaxed.
> 
> Yes.  And this behaviour will be retained.   I think we only need to
> do the INVALID_P2M_ENTRY => 1:1 when constructing PTEs so all other
> callers will see INVALID_P2M_ENTRY as before.
> 
> 
> >     However again the P2M code
> >     and the ABI it places are not for the faint of the heart.
> 
> I have no fear.

<sigh> I booted up the kernel on the machine that has the affected
hardware and hit this:

 806         if (unlikely(pfn >= MAX_P2M_PFN)) {                                     
 807                 BUG_ON(mfn != INVALID_P2M_ENTRY);                               
 808                 return true;                                                    
 809         }                                                                       
 810                     

in __set_phys_to_machine. This is of course b/c the region is way
out of the 500GB limit we have for P2M. 

My original idea of fiddling with P2M is insufficient for this
particular bug (thought it would work for PCI devices under MAX_PAGES).

Anyhow, that means going down the P2M path as you suggested is the
only way (well, besides the work-around). So you got any patches ready :-) ?

> 
> If the above suggestion does work out it will reduce the amount of
> p2m code /and/ remove a Xen-specific PTE bit.  So I think it is
> worth pursuing.
> 
> In the meantime, the following minimal patch is a likely workaround.
> 
> David
> 
> 8<-------------------------------
> x86/mm: set _PAGE_IOMAP in io_remap_pfn_range().
> 
> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
> ---
>  arch/x86/include/asm/pgtable.h |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
> index 3d19994..d59b22a 100644
> --- a/arch/x86/include/asm/pgtable.h
> +++ b/arch/x86/include/asm/pgtable.h
> @@ -868,6 +868,9 @@ static inline pte_t pte_swp_clear_soft_dirty(pte_t pte)
>  	return pte_clear_flags(pte, _PAGE_SWP_SOFT_DIRTY);
>  }
> 
> +#define io_remap_pfn_range(vma, addr, pfn, size, prot) \
> +  remap_pfn_range(vma, addr, pfn, size, (prot) | _PAGE_IOMAP)
> +
>  #include <asm-generic/pgtable.h>
>  #endif	/* __ASSEMBLY__ */
> 
> -- 
> 1.7.10.4
> 
