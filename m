Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758833Ab3D2SfC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 14:35:02 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:24760 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758372Ab3D2SfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 14:35:00 -0400
Date: Mon, 29 Apr 2013 14:34:50 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 7/9] xen/spinlock: Disable IRQ spinlock (PV) allocation
 on PVHVM
Message-ID: <20130429183450.GB9431@phenom.dumpdata.com>
References: <1366142947-18655-1-git-send-email-konrad.wilk@oracle.com>
 <1366142947-18655-8-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.02.1304261718420.4180@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1304261718420.4180@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 05:20:23PM +0100, Stefano Stabellini wrote:
> On Tue, 16 Apr 2013, Konrad Rzeszutek Wilk wrote:
> > See git commit f10cd522c5fbfec9ae3cc01967868c9c2401ed23
> > (xen: disable PV spinlocks on HVM) for details.
> > 
> > But we did not disable it everywhere - which means that when
> > we boot as PVHVM we end up allocating per-CPU irq line for
> > spinlock. This fixes that.
> > 
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> Is there any point in calling xen_init_lock_cpu in PVHVM guests?

I was thinking about it.. but I still have hope that I will be able to
take Jeremy's patches for paravirt locking and redo them a bit.

> At that point we might as well remove the call from xen_hvm_cpu_notify.
> 
> 
> >  arch/x86/xen/spinlock.c | 21 +++++++++++++++++++++
> >  1 file changed, 21 insertions(+)
> > 
> > diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
> > index 47ae032..8b54603 100644
> > --- a/arch/x86/xen/spinlock.c
> > +++ b/arch/x86/xen/spinlock.c
> > @@ -367,6 +367,13 @@ void __cpuinit xen_init_lock_cpu(int cpu)
> >  	WARN(per_cpu(lock_kicker_irq, cpu) > 0, "spinlock on CPU%d exists on IRQ%d!\n",
> >  	     cpu, per_cpu(lock_kicker_irq, cpu));
> >  
> > +	/*
> > +	 * See git commit f10cd522c5fbfec9ae3cc01967868c9c2401ed23
> > +	 * (xen: disable PV spinlocks on HVM)
> > +	 */
> > +	if (xen_hvm_domain())
> > +		return;
> > +
> >  	name = kasprintf(GFP_KERNEL, "spinlock%d", cpu);
> >  	irq = bind_ipi_to_irqhandler(XEN_SPIN_UNLOCK_VECTOR,
> >  				     cpu,
> > @@ -385,12 +392,26 @@ void __cpuinit xen_init_lock_cpu(int cpu)
> >  
> >  void xen_uninit_lock_cpu(int cpu)
> >  {
> > +	/*
> > +	 * See git commit f10cd522c5fbfec9ae3cc01967868c9c2401ed23
> > +	 * (xen: disable PV spinlocks on HVM)
> > +	 */
> > +	if (xen_hvm_domain())
> > +		return;
> > +
> >  	unbind_from_irqhandler(per_cpu(lock_kicker_irq, cpu), NULL);
> >  	per_cpu(lock_kicker_irq, cpu) = -1;
> >  }
> >  
> >  void __init xen_init_spinlocks(void)
> >  {
> > +	/*
> > +	 * See git commit f10cd522c5fbfec9ae3cc01967868c9c2401ed23
> > +	 * (xen: disable PV spinlocks on HVM)
> > +	 */
> > +	if (xen_hvm_domain())
> > +		return;
> > +
> >  	BUILD_BUG_ON(sizeof(struct xen_spinlock) > sizeof(arch_spinlock_t));
> >  
> >  	pv_lock_ops.spin_is_locked = xen_spin_is_locked;
> > -- 
> > 1.8.1.4
> > 
