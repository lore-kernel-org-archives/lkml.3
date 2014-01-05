Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550AbaAETnG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 14:43:06 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:17372 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaAETnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 14:43:03 -0500
Date: Sun, 5 Jan 2014 14:41:55 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com, hpa@zytor.com,
        Mukesh Rathor <mukesh.rathor@oracle.com>
Subject: Re: [PATCH v13 08/19] xen/pvh/mmu: Use PV TLB instead of native.
Message-ID: <20140105194155.GC12263@phenom.dumpdata.com>
References: <1388777916-1328-1-git-send-email-konrad.wilk@oracle.com>
 <1388777916-1328-9-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.02.1401051757260.8667@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1401051757260.8667@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 05, 2014 at 06:11:39PM +0000, Stefano Stabellini wrote:
> On Fri, 3 Jan 2014, Konrad Rzeszutek Wilk wrote:
> > From: Mukesh Rathor <mukesh.rathor@oracle.com>
> > 
> > We also optimize one - the TLB flush. The native operation would
> > needlessly IPI offline VCPUs causing extra wakeups. Using the
> > Xen one avoids that and lets the hypervisor determine which
> > VCPU needs the TLB flush.
> > 
> > Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  arch/x86/xen/mmu.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> > 
> > diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> > index 490ddb3..c1d406f 100644
> > --- a/arch/x86/xen/mmu.c
> > +++ b/arch/x86/xen/mmu.c
> > @@ -2222,6 +2222,15 @@ static const struct pv_mmu_ops xen_mmu_ops __initconst = {
> >  void __init xen_init_mmu_ops(void)
> >  {
> >  	x86_init.paging.pagetable_init = xen_pagetable_init;
> > +
> > +	/* Optimization - we can use the HVM one but it has no idea which
> > +	 * VCPUs are descheduled - which means that it will needlessly IPI
> > +	 * them. Xen knows so let it do the job.
> > +	 */
> > +	if (xen_feature(XENFEAT_auto_translated_physmap)) {
> > +		pv_mmu_ops.flush_tlb_others = xen_flush_tlb_others;
> > +		return;
> > +	}
> >  	pv_mmu_ops = xen_mmu_ops;
> >  
> >  	memset(dummy_mapping, 0xff, PAGE_SIZE);
> 
> Regarding this patch, the next one and the other changes to
> xen_setup_shared_info, xen_setup_mfn_list_list,
> xen_setup_vcpu_info_placement, etc: considering that the mmu related
> stuff is very different between PV and PVH guests, I wonder if it makes
> any sense to keep calling xen_init_mmu_ops on PVH.
> 
> I would introduce a new function, xen_init_pvh_mmu_ops, that sets
> pv_mmu_ops.flush_tlb_others and only calls whatever is needed for PVH
> under a new xen_pvh_pagetable_init.
> Just to give you an idea, not even compiled tested:

There is something to be said about sharing the same code path
that "old-style" PV is using with the new-style - code coverage.

That is the code gets tested under both platforms and if I (or
anybody else) introduce a bug in the "common-PV-paths" it will
be immediately obvious as hopefully the regression tests
will pick it up.

It is not nice - as low-level code is sprinkled with the one-offs
for the PVH - which mostly is doing _less_.

What I was thinking is to flip this around. Make the PVH paths
the default and then have something like 'if (!xen_pvh_domain())'
... the big code.

Would you be OK with this line of thinking going forward say
after this patchset?

Thanks!
