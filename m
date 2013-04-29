Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758873Ab3D2Sfa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 14:35:30 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:27101 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758848Ab3D2Sf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 14:35:27 -0400
Date: Mon, 29 Apr 2013 14:35:19 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 6/9] xen/spinlock:  Check against default value of -1 for
 IRQ line.
Message-ID: <20130429183519.GC9431@phenom.dumpdata.com>
References: <1366142947-18655-1-git-send-email-konrad.wilk@oracle.com>
 <1366142947-18655-7-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.02.1304261717300.4180@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1304261717300.4180@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 05:18:01PM +0100, Stefano Stabellini wrote:
> On Tue, 16 Apr 2013, Konrad Rzeszutek Wilk wrote:
> > The default (uninitialized) value of the IRQ line is -1.
> > Check if we already have allocated an spinlock interrupt line
> > and if somebody is trying to do it again. Also set it to -1
> > when we offline the CPU.
> > 
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  arch/x86/xen/spinlock.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
> > index f7a080e..47ae032 100644
> > --- a/arch/x86/xen/spinlock.c
> > +++ b/arch/x86/xen/spinlock.c
> > @@ -364,6 +364,9 @@ void __cpuinit xen_init_lock_cpu(int cpu)
> >  	int irq;
> >  	const char *name;
> >  
> > +	WARN(per_cpu(lock_kicker_irq, cpu) > 0, "spinlock on CPU%d exists on IRQ%d!\n",
>                   shouldn't this be >= ^
> 

Yes. Thanks for catching.
> 
> > +	     cpu, per_cpu(lock_kicker_irq, cpu));
> >
> >  	name = kasprintf(GFP_KERNEL, "spinlock%d", cpu);
> >  	irq = bind_ipi_to_irqhandler(XEN_SPIN_UNLOCK_VECTOR,
> >  				     cpu,
> > @@ -383,6 +386,7 @@ void __cpuinit xen_init_lock_cpu(int cpu)
> >  void xen_uninit_lock_cpu(int cpu)
> >  {
> >  	unbind_from_irqhandler(per_cpu(lock_kicker_irq, cpu), NULL);
> > +	per_cpu(lock_kicker_irq, cpu) = -1;
> >  }
> >  
> >  void __init xen_init_spinlocks(void)
> > -- 
> > 1.8.1.4
> > 
