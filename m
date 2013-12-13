Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab3LMOdd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 09:33:33 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:35307 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599Ab3LMOdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 09:33:32 -0500
Date: Fri, 13 Dec 2013 09:32:17 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, george.dunlap@eu.citrix.com,
        ian.jackson@eu.citrix.com, mukesh.rathor@oracle.com, tim@xen.org,
        jbeulich@suse.com, boris.ostrovsky@oracle.com
Subject: Re: [PATCH V10 01/14] xen/pvh: Support ParaVirtualized Hardware
 extensions.
Message-ID: <20131213143217.GG2923@phenom.dumpdata.com>
References: <1386900621-27528-1-git-send-email-konrad.wilk@oracle.com>
 <1386900621-27528-2-git-send-email-konrad.wilk@oracle.com>
 <52AAE50F.3000009@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52AAE50F.3000009@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 10:44:31AM +0000, David Vrabel wrote:
> On 13/12/13 02:10, Konrad Rzeszutek Wilk wrote:
> > From: Mukesh Rathor <mukesh.rathor@oracle.com>
> > 
> > PVH allows PV linux guest to utilize hardware extended capabilities, such
> > as running MMU updates in a HVM container.
> > 
> > This patch allows it to be configured and enabled. Also, basic header file
> > changes to add new subcalls to physmap hypercall.
> > 
> > Lastly, mfn_to_local_pfn must return mfn for paging mode translate
> > (since we let the hypervisor - or CPU - do them for us).
> [...]
> > --- a/arch/x86/include/asm/xen/page.h
> > +++ b/arch/x86/include/asm/xen/page.h
> > @@ -168,6 +168,9 @@ static inline xpaddr_t machine_to_phys(xmaddr_t machine)
> >  static inline unsigned long mfn_to_local_pfn(unsigned long mfn)
> >  {
> >  	unsigned long pfn = mfn_to_pfn(mfn);
> > +
> > +	if (xen_feature(XENFEAT_auto_translated_physmap))
> > +		return mfn;
> 
> This does the mfn_to_pfn() call first and then ignores the result.
> 
> >  	if (get_phys_to_machine(pfn) != mfn)
> >  		return -1; /* force !pfn_valid() */
> >  	return pfn;
> > diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
> > index 1a3c765..4d890c3 100644
> > --- a/arch/x86/xen/Kconfig
> > +++ b/arch/x86/xen/Kconfig
> > @@ -51,3 +51,13 @@ config XEN_DEBUG_FS
> >  	  Enable statistics output and various tuning options in debugfs.
> >  	  Enabling this option may incur a significant performance overhead.
> >  
> > +config XEN_X86_PVH
> > +	bool "Support for running as a PVH guest (EXPERIMENTAL)"
> > +	depends on X86_64 && XEN && EXPERIMENTAL
> 
> Drop EXPERIMENTAL here (not in the follow up patch).
> 
> > +	default n
> 
> default y or don't provide this as a user selectable choice.
> 
> > diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
> > index 7faed58..1a6bca1 100644
> > --- a/arch/x86/xen/xen-head.S
> > +++ b/arch/x86/xen/xen-head.S
> > @@ -13,6 +13,15 @@
> >  #include <xen/interface/elfnote.h>
> >  #include <asm/xen/interface.h>
> >  
> > +#ifdef CONFIG_XEN_X86_PVH
> > +#define FEATURES_PVH "|writable_descriptor_tables" \
> > +		     "|auto_translated_physmap" \
> > +		     "|supervisor_mode_kernel" \
> > +		     "|hvm_callback_vector"
> > +#else
> > +#define FEATURES_PVH /* Not supported */
> > +#endif
> > +
> >  	__INIT
> >  ENTRY(startup_xen)
> >  	cld
> > @@ -95,7 +104,7 @@ NEXT_HYPERCALL(arch_6)
> >  #endif
> >  	ELFNOTE(Xen, XEN_ELFNOTE_ENTRY,          _ASM_PTR startup_xen)
> >  	ELFNOTE(Xen, XEN_ELFNOTE_HYPERCALL_PAGE, _ASM_PTR hypercall_page)
> > -	ELFNOTE(Xen, XEN_ELFNOTE_FEATURES,       .asciz "!writable_page_tables|pae_pgdir_above_4gb")
> > +	ELFNOTE(Xen, XEN_ELFNOTE_FEATURES,       .asciz "!writable_page_tables|pae_pgdir_above_4gb"FEATURES_PVH)
> >  	ELFNOTE(Xen, XEN_ELFNOTE_PAE_MODE,       .asciz "yes")
> >  	ELFNOTE(Xen, XEN_ELFNOTE_LOADER,         .asciz "generic")
> >  	ELFNOTE(Xen, XEN_ELFNOTE_L1_MFN_VALID,
> 
> Not clear how this can be part of the first patch.  A guest with only
> this patch cannot actually work in PVH mode, right?

Good point. We should make this one of the last patches or split
this part out.

> 
> > diff --git a/include/xen/interface/memory.h b/include/xen/interface/memory.h
> > index 2ecfe4f..a122164 100644
> > --- a/include/xen/interface/memory.h
> > +++ b/include/xen/interface/memory.h
> > @@ -175,7 +175,10 @@ struct xen_add_to_physmap {
> >      uint16_t    size;
> >  
> >      /* Source mapping space. */
> > -    unsigned int space;
> > +    uint16_t space;
> > +    domid_t foreign_domid;         /* IFF XENMAPSPACE_gmfn_foreign */
> > +
> > +#define XENMAPIDX_grant_table_status 0x80000000
> 
> What's this change?  It doesn't match the hypervisor.
> 
> > --- a/include/xen/interface/physdev.h
> > +++ b/include/xen/interface/physdev.h
> > @@ -291,6 +291,16 @@ struct physdev_dbgp_op {
> >      } u;
> >  };
> >  
> > +#define PHYSDEVOP_map_iomem        30
> > +struct physdev_map_iomem {
> > +    /* IN */
> > +    uint64_t first_gfn;
> > +    uint64_t first_mfn;
> > +    uint32_t nr_mfns;
> > +    uint32_t add_mapping; /* 1 == add mapping;  0 == unmap */
> > +
> > +};
> > +
> 
> Not provided by the hypervisor.

Mukesh, could you send a followup patch to the entire patchset which
fixes the change so I can make sure to have the right hypervisor ABI please?


> 
> David
