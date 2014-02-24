Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbaBXVMZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 16:12:25 -0500
Received: from www.linutronix.de ([62.245.132.108]:60587 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbaBXVMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 16:12:24 -0500
Date: Mon, 24 Feb 2014 22:12:30 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Vrabel <david.vrabel@citrix.com>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Xen <xen-devel@lists.xenproject.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Xen-devel] [patch 21/26] xen: Get rid of the last irq_desc
 abuse
In-Reply-To: <530B5856.7080900@citrix.com>
Message-ID: <alpine.DEB.2.02.1402242210470.21251@ionos.tec.linutronix.de>
References: <20140223212703.511977310@linutronix.de> <20140223212738.579581220@linutronix.de> <530B5856.7080900@citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Feb 2014, David Vrabel wrote:
> On 23/02/14 21:40, Thomas Gleixner wrote:
> > I'd prefer to drop that completely but there seems to be some mystic
> > value to the error printout and the allocation check.
> 
>     Warn if any PIRQ cannot be bound to an event channel.  Remove an
>     unnecessary test for !desc in xen_destroy_irq() since the only caller
>     will only do so if the irq was previously allocated.
> 
> > --- tip.orig/drivers/xen/events/events_base.c
> > +++ tip/drivers/xen/events/events_base.c
> [...]
> > @@ -535,7 +528,7 @@ static unsigned int __startup_pirq(unsig
> >  					BIND_PIRQ__WILL_SHARE : 0;
> >  	rc = HYPERVISOR_event_channel_op(EVTCHNOP_bind_pirq, &bind_pirq);
> >  	if (rc != 0) {
> > -		if (!probing_irq(irq))
> > +		if (!data || irqd_irq_has_action(data))
> >  			pr_info("Failed to obtain physical IRQ %d\n", irq);
> 
> Remove this if and change the pr_info() to a pr_warn().
> 
> This hypercall never fails in practice, but it's still useful to have the
> message in case on some systems it does.

Sure, I understood the value of the printk, but I failed to see the
reason for probing_irq(). Will change it.
 
> >  		return 0;
> >  	}
> > @@ -769,15 +762,13 @@ error_irq:
> >  
> >  int xen_destroy_irq(int irq)
> >  {
> > -	struct irq_desc *desc;
> >  	struct physdev_unmap_pirq unmap_irq;
> >  	struct irq_info *info = info_for_irq(irq);
> >  	int rc = -ENOENT;
> >  
> >  	mutex_lock(&irq_mapping_update_lock);
> >  
> > -	desc = irq_to_desc(irq);
> > -	if (!desc)
> > +	if (!irq_is_allocated(irq))
> >  		goto out;
> 
> Remove this test.  The only caller of xen_destroy_irq() will only do
> so if the irq was previously fully setup.

I was not sure about that, but thanks for confirming.
 
> I think this means you don't need to introduce the irqd_irq_has_action()
> and irq_is_allocated() helpers.

I just invented them in case xen really needs those tests.

Thanks,

	tglx
