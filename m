Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab3LMO2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 09:28:09 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:32236 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab3LMO2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 09:28:06 -0500
Date: Fri, 13 Dec 2013 09:26:51 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, george.dunlap@eu.citrix.com,
        ian.jackson@eu.citrix.com, mukesh.rathor@oracle.com, tim@xen.org,
        jbeulich@suse.com, boris.ostrovsky@oracle.com
Subject: Re: [PATCH V10 02/14] xen/pvh: Extend vcpu_guest_context, p2m,
 event, and XenBus.
Message-ID: <20131213142651.GD2923@phenom.dumpdata.com>
References: <1386900621-27528-1-git-send-email-konrad.wilk@oracle.com>
 <1386900621-27528-3-git-send-email-konrad.wilk@oracle.com>
 <52AAE7D8.2030602@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52AAE7D8.2030602@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 10:56:24AM +0000, David Vrabel wrote:
> On 13/12/13 02:10, Konrad Rzeszutek Wilk wrote:
> > From: Mukesh Rathor <mukesh.rathor@oracle.com>
> > 
> > Make gdt_frames[]/gdt_ents into a union with {gdtaddr, gdtsz},
> > as PVH only needs to send down gdtaddr and gdtsz in the
> > vcpu_guest_context structure..
> > 
> > For interrupts, PVH uses native_irq_ops so we can skip most of the
> > PV ones. In the future we can support the pirq_eoi_map..
> > Also VCPU hotplug is currently not available for PVH.
> > 
> > For events (and IRQs) we follow what PVHVM does - so use callback
> > vector.  Lastly, for XenBus we use the same logic that is used in
> > the PVHVM case.
> [...]
> > --- a/arch/x86/include/asm/xen/interface.h
> > +++ b/arch/x86/include/asm/xen/interface.h
> > @@ -145,7 +145,16 @@ struct vcpu_guest_context {
> >      struct cpu_user_regs user_regs;         /* User-level CPU registers     */
> >      struct trap_info trap_ctxt[256];        /* Virtual IDT                  */
> >      unsigned long ldt_base, ldt_ents;       /* LDT (linear address, # ents) */
> > -    unsigned long gdt_frames[16], gdt_ents; /* GDT (machine frames, # ents) */
> > +    union {
> > +	struct {
> > +		/* PV: GDT (machine frames, # ents).*/
> > +		unsigned long gdt_frames[16], gdt_ents;
> > +	} pv;
> > +	struct {
> > +		/* PVH: GDTR addr and size */
> > +		unsigned long gdtaddr, gdtsz;
> > +	} pvh;
> > +    } u;
> 
> Doesn't match the hypervisor.

Right. Mukesh is going to post follow on patches to fix that.

> 
> > --- a/arch/x86/xen/p2m.c
> > +++ b/arch/x86/xen/p2m.c
> > @@ -800,8 +800,10 @@ bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn)
> >  	unsigned topidx, mididx, idx;
> >  
> >  	/* don't track P2M changes in autotranslate guests */
> > -	if (unlikely(xen_feature(XENFEAT_auto_translated_physmap)))
> > +	if (unlikely(xen_feature(XENFEAT_auto_translated_physmap))) {
> > +		BUG_ON(pfn != mfn && mfn != INVALID_P2M_ENTRY);
> >  		return true;
> > +	}
> 
> Isn't this undoing a recent change that removed this BUG_ON()?

This one:
commit 2f558d40911c1b8f929b8a382833ae1da5df3293
Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Date:   Wed Oct 9 20:39:01 2013 +0000

    xen/x86: allow __set_phys_to_machine for autotranslate guests
    
    Allow __set_phys_to_machine to be called for autotranslate guests.
    It can be used to keep track of phys_to_machine changes, however we
    don't do anything with the information at the moment.
    
    Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

I am not actually sure why the BUG_ON was removed in Stefano's patch.
Stefano?

> 
> David
