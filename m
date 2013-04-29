Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808Ab3D2SeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 14:34:16 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:26409 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758372Ab3D2SeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 14:34:15 -0400
Date: Mon, 29 Apr 2013 14:34:04 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 8/9] xen/smp/pvhvm: Don't initialize IRQ_WORKER as we are
 using the native one.
Message-ID: <20130429183404.GA9431@phenom.dumpdata.com>
References: <1366142947-18655-1-git-send-email-konrad.wilk@oracle.com>
 <1366142947-18655-9-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.02.1304261726260.4180@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1304261726260.4180@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 05:27:20PM +0100, Stefano Stabellini wrote:
> On Tue, 16 Apr 2013, Konrad Rzeszutek Wilk wrote:
> > There is no need to use the PV version of the IRQ_WORKER mechanism
> > as under PVHVM we are using the native version. The native
> > version is using the SMP API.
> > 
> > They just sit around unused:
> > 
> >   69:          0          0  xen-percpu-ipi       irqwork0
> >   83:          0          0  xen-percpu-ipi       irqwork1
> > 
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> Might be worth trying to make it work instead?
> Is it just because we don't set the apic->send_IPI_* functions to the
> xen specific version on PVHVM?
> 

Right. We use the baremetal mechanism to do it. And it works fine.

> 
> >  arch/x86/xen/smp.c | 13 ++++++++++++-
> >  1 file changed, 12 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
> > index 22c800a..415694c 100644
> > --- a/arch/x86/xen/smp.c
> > +++ b/arch/x86/xen/smp.c
> > @@ -144,6 +144,13 @@ static int xen_smp_intr_init(unsigned int cpu)
> >  		goto fail;
> >  	per_cpu(xen_callfuncsingle_irq, cpu) = rc;
> >  
> > +	/*
> > +	 * The IRQ worker on PVHVM goes through the native path and uses the
> > +	 * IPI mechanism.
> > +	 */
> > +	if (xen_hvm_domain())
> > +		return 0;
> > +
> >  	callfunc_name = kasprintf(GFP_KERNEL, "irqwork%d", cpu);
> >  	rc = bind_ipi_to_irqhandler(XEN_IRQ_WORK_VECTOR,
> >  				    cpu,
> > @@ -167,6 +174,9 @@ static int xen_smp_intr_init(unsigned int cpu)
> >  	if (per_cpu(xen_callfuncsingle_irq, cpu) >= 0)
> >  		unbind_from_irqhandler(per_cpu(xen_callfuncsingle_irq, cpu),
> >  				       NULL);
> > +	if (xen_hvm_domain())
> > +		return rc;
> > +
> >  	if (per_cpu(xen_irq_work, cpu) >= 0)
> >  		unbind_from_irqhandler(per_cpu(xen_irq_work, cpu), NULL);
> >  
> > @@ -661,7 +671,8 @@ static void xen_hvm_cpu_die(unsigned int cpu)
> >  	unbind_from_irqhandler(per_cpu(xen_callfunc_irq, cpu), NULL);
> >  	unbind_from_irqhandler(per_cpu(xen_debug_irq, cpu), NULL);
> >  	unbind_from_irqhandler(per_cpu(xen_callfuncsingle_irq, cpu), NULL);
> > -	unbind_from_irqhandler(per_cpu(xen_irq_work, cpu), NULL);
> > +	if (!xen_hvm_domain())
> > +		unbind_from_irqhandler(per_cpu(xen_irq_work, cpu), NULL);
> >  	xen_uninit_lock_cpu(cpu);
> >  	xen_teardown_timer(cpu);
> >  	native_cpu_die(cpu);
> > -- 
> > 1.8.1.4
> > 
