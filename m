Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbaACSLn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 13:11:43 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:50933 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaACSLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 13:11:42 -0500
Date: Fri, 3 Jan 2014 13:10:32 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        mukesh.rathor@oracle.com
Subject: Re: [PATCH v12 11/18] xen/pvh: Piggyback on PVHVM for event channels
 (v2)
Message-ID: <20140103181032.GB28551@phenom.dumpdata.com>
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com>
 <1388550945-25499-12-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.02.1401031633070.8667@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1401031633070.8667@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 03, 2014 at 04:34:18PM +0000, Stefano Stabellini wrote:
> On Tue, 31 Dec 2013, Konrad Rzeszutek Wilk wrote:
> > From: Mukesh Rathor <mukesh.rathor@oracle.com>
> > 
> > PVH is a PV guest with a twist - there are certain things
> > that work in it like HVM and some like PV. There is
> > a similar mode - PVHVM where we run in HVM mode with
> > PV code enabled - and this patch explores that.
> > 
> > The most notable PV interfaces are the XenBus and event channels.
> > 
> > We will piggyback on how the event channel mechanism is
> > used in PVHVM - that is we want the normal native IRQ mechanism
> > and we will install a vector (hvm callback) for which we
> > will call the event channel mechanism.
> > 
> > This means that from a pvops perspective, we can use
> > native_irq_ops instead of the Xen PV specific. Albeit in the
> > future we could support pirq_eoi_map. But that is
> > a feature request that can be shared with PVHVM.
> > 
> > Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  arch/x86/xen/irq.c   |  5 ++++-
> >  drivers/xen/events.c | 16 ++++++++++------
> >  2 files changed, 14 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arch/x86/xen/irq.c b/arch/x86/xen/irq.c
> > index 0da7f86..76ca326 100644
> > --- a/arch/x86/xen/irq.c
> > +++ b/arch/x86/xen/irq.c
> > @@ -5,6 +5,7 @@
> >  #include <xen/interface/xen.h>
> >  #include <xen/interface/sched.h>
> >  #include <xen/interface/vcpu.h>
> > +#include <xen/features.h>
> >  #include <xen/events.h>
> >  
> >  #include <asm/xen/hypercall.h>
> > @@ -128,6 +129,8 @@ static const struct pv_irq_ops xen_irq_ops __initconst = {
> >  
> >  void __init xen_init_irq_ops(void)
> >  {
> > -	pv_irq_ops = xen_irq_ops;
> > +	/* For PVH we use default pv_irq_ops settings. */
> > +	if (!xen_feature(XENFEAT_hvm_callback_vector))
> > +		pv_irq_ops = xen_irq_ops;
> >  	x86_init.irqs.intr_init = xen_init_IRQ;
> >  }
> > diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> > index 4035e83..bf8fb29 100644
> > --- a/drivers/xen/events.c
> > +++ b/drivers/xen/events.c
> > @@ -1908,20 +1908,24 @@ void __init xen_init_IRQ(void)
> >  	pirq_needs_eoi = pirq_needs_eoi_flag;
> >  
> >  #ifdef CONFIG_X86
> > -	if (xen_hvm_domain()) {
> > +	if (xen_pv_domain()) {
> > +		irq_ctx_init(smp_processor_id());
> > +		if (xen_initial_domain())
> > +			pci_xen_initial_domain();
> > +	}
> > +	if (xen_feature(XENFEAT_hvm_callback_vector))
> >  		xen_callback_vector();
> > +
> > +	if (xen_hvm_domain()) {
> >  		native_init_IRQ();
> >  		/* pci_xen_hvm_init must be called after native_init_IRQ so that
> >  		 * __acpi_register_gsi can point at the right function */
> >  		pci_xen_hvm_init();
> > -	} else {
> > +	} else if (!xen_pvh_domain()) {
> > +		/* TODO: No PVH support for PIRQ EOI */
> >  		int rc;
> >  		struct physdev_pirq_eoi_gmfn eoi_gmfn;
> >  
> > -		irq_ctx_init(smp_processor_id());
> > -		if (xen_initial_domain())
> > -			pci_xen_initial_domain();
> 
> We already have a mechanism to identify whether
> PHYSDEVOP_pirq_eoi_gmfn_v2 is available or not. Can't we just rely on
> that?

Yes, and this code has the right recovery mechanism to deal with let.

Thank you!
