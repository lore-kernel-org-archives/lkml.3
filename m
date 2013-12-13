Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab3LMO7z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 09:59:55 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:10718 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab3LMO7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 09:59:54 -0500
X-IronPort-AV: E=Sophos;i="4.95,479,1384300800"; 
   d="scan'208";a="82009006"
Date: Fri, 13 Dec 2013 14:59:24 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: David Vrabel <david.vrabel@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <george.dunlap@eu.citrix.com>, <ian.jackson@eu.citrix.com>,
        <mukesh.rathor@oracle.com>, <tim@xen.org>, <jbeulich@suse.com>,
        <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH V10 02/14] xen/pvh: Extend vcpu_guest_context, p2m, event,
 and XenBus.
In-Reply-To: <20131213142651.GD2923@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1312131453000.8667@kaball.uk.xensource.com>
References: <1386900621-27528-1-git-send-email-konrad.wilk@oracle.com> <1386900621-27528-3-git-send-email-konrad.wilk@oracle.com> <52AAE7D8.2030602@citrix.com> <20131213142651.GD2923@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Dec 2013, Konrad Rzeszutek Wilk wrote:
> On Fri, Dec 13, 2013 at 10:56:24AM +0000, David Vrabel wrote:
> > On 13/12/13 02:10, Konrad Rzeszutek Wilk wrote:
> > > From: Mukesh Rathor <mukesh.rathor@oracle.com>
> > > 
> > > Make gdt_frames[]/gdt_ents into a union with {gdtaddr, gdtsz},
> > > as PVH only needs to send down gdtaddr and gdtsz in the
> > > vcpu_guest_context structure..
> > > 
> > > For interrupts, PVH uses native_irq_ops so we can skip most of the
> > > PV ones. In the future we can support the pirq_eoi_map..
> > > Also VCPU hotplug is currently not available for PVH.
> > > 
> > > For events (and IRQs) we follow what PVHVM does - so use callback
> > > vector.  Lastly, for XenBus we use the same logic that is used in
> > > the PVHVM case.
> > [...]
> > > --- a/arch/x86/include/asm/xen/interface.h
> > > +++ b/arch/x86/include/asm/xen/interface.h
> > > @@ -145,7 +145,16 @@ struct vcpu_guest_context {
> > >      struct cpu_user_regs user_regs;         /* User-level CPU registers     */
> > >      struct trap_info trap_ctxt[256];        /* Virtual IDT                  */
> > >      unsigned long ldt_base, ldt_ents;       /* LDT (linear address, # ents) */
> > > -    unsigned long gdt_frames[16], gdt_ents; /* GDT (machine frames, # ents) */
> > > +    union {
> > > +	struct {
> > > +		/* PV: GDT (machine frames, # ents).*/
> > > +		unsigned long gdt_frames[16], gdt_ents;
> > > +	} pv;
> > > +	struct {
> > > +		/* PVH: GDTR addr and size */
> > > +		unsigned long gdtaddr, gdtsz;
> > > +	} pvh;
> > > +    } u;
> > 
> > Doesn't match the hypervisor.
> 
> Right. Mukesh is going to post follow on patches to fix that.
> 
> > 
> > > --- a/arch/x86/xen/p2m.c
> > > +++ b/arch/x86/xen/p2m.c
> > > @@ -800,8 +800,10 @@ bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn)
> > >  	unsigned topidx, mididx, idx;
> > >  
> > >  	/* don't track P2M changes in autotranslate guests */
> > > -	if (unlikely(xen_feature(XENFEAT_auto_translated_physmap)))
> > > +	if (unlikely(xen_feature(XENFEAT_auto_translated_physmap))) {
> > > +		BUG_ON(pfn != mfn && mfn != INVALID_P2M_ENTRY);
> > >  		return true;
> > > +	}
> > 
> > Isn't this undoing a recent change that removed this BUG_ON()?
> 
> This one:
> commit 2f558d40911c1b8f929b8a382833ae1da5df3293
> Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Date:   Wed Oct 9 20:39:01 2013 +0000
> 
>     xen/x86: allow __set_phys_to_machine for autotranslate guests
>     
>     Allow __set_phys_to_machine to be called for autotranslate guests.
>     It can be used to keep track of phys_to_machine changes, however we
>     don't do anything with the information at the moment.
>     
>     Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> I am not actually sure why the BUG_ON was removed in Stefano's patch.
> Stefano?

The following commit:

commit 3d24bbd7dddbea54358a9795abaf051b0f18973c
Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Date:   Fri Oct 25 10:41:44 2013 +0000

    grant-table: call set_phys_to_machine after mapping grant refs
    
introduces set_phys_to_machine calls for auto_translated guests
(even on x86) in gnttab_map_refs and gnttab_unmap_refs.
They are necessary to allow the kernel to keep track of foreign grant
mappings: without an IOMMU the kernel needs to take special care of
these pages because they can't be used directly in dma operations unless
translated by swiotlb-xen.
