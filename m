Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab3EUUnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 16:43:17 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:45195 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836Ab3EUUnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 16:43:15 -0400
Date: Tue, 21 May 2013 16:42:45 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: David Vrabel <david.vrabel@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Feng Jin <joe.jin@oracle.com>,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        Yuval Shaia <yuval.shaia@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chien Yen <chien.yen@oracle.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] [PATCH] xen: reuse the same pirq allocated when
 driver load first time
Message-ID: <20130521204245.GA7073@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1305141440500.4799@kaball.uk.xensource.com>
 <20130514142013.GA10173@konrad-lan.dumpdata.com>
 <alpine.DEB.2.02.1305151037100.4799@kaball.uk.xensource.com>
 <5195944A.3050608@oracle.com>
 <alpine.DEB.2.02.1305201121370.4799@kaball.uk.xensource.com>
 <20130520175706.GA27973@phenom.dumpdata.com>
 <20130520203855.GA30616@phenom.dumpdata.com>
 <519B474E.4000202@citrix.com>
 <20130521134059.GE492@phenom.dumpdata.com>
 <alpine.DEB.2.02.1305211748030.4799@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1305211748030.4799@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 05:51:02PM +0100, Stefano Stabellini wrote:
> On Tue, 21 May 2013, Konrad Rzeszutek Wilk wrote:
> > > Looking at the hypervisor code I couldn't see anything obviously wrong.
> > 
> > I think the culprit is "physdev_unmap_pirq":
> > 
> >    if ( is_hvm_domain(d) )                                                     
> >     {                                                                           
> >         spin_lock(&d->event_lock);                                              
> >         gdprintk(XENLOG_WARNING,"d%d, pirq: %d is %x %s, irq: %d\n",            
> >             d->domain_id, pirq, domain_pirq_to_emuirq(d, pirq),                 
> >             domain_pirq_to_emuirq(d, pirq) == IRQ_UNBOUND ? "unbound" : "",        
> >             domain_pirq_to_irq(d, pirq));                                       
> >                                                                                 
> >         if ( domain_pirq_to_emuirq(d, pirq) != IRQ_UNBOUND )                    
> >             ret = unmap_domain_pirq_emuirq(d, pirq);                            
> >         spin_unlock(&d->event_lock);                                            
> >         if ( domid == DOMID_SELF || ret )                                       
> >             goto free_domain;                                             
> > 
> > It always tells me unbound:
> > 
> > (XEN) physdev.c:237:d14 14, pirq: 54 is ffffffff
> > (XEN) irq.c:1873:d14 14, nr_pirqs: 56
> > (XEN) physdev.c:237:d14 14, pirq: 53 is ffffffff
> > (XEN) irq.c:1873:d14 14, nr_pirqs: 56
> > (XEN) physdev.c:237:d14 14, pirq: 52 is ffffffff
> > (XEN) irq.c:1873:d14 14, nr_pirqs: 56
> > (XEN) physdev.c:237:d14 14, pirq: 51 is ffffffff
> > (XEN) irq.c:1873:d14 14, nr_pirqs: 56
> > (XEN) physdev.c:237:d14 14, pirq: 50 is ffffffff
> > (XEN) irq.c:1873:d14 14, nr_pirqs: 56
> > (a bit older debug code, so the 'unbound' does not show up here).
> > 
> > Which means that the call to unmap_domain_pirq_emuirq does not happen.
> > The checks in unmap_domain_pirq_emuirq also look to be depend
> > on the code being IRQ_UNBOUND.
> > 
> > In other words, all of that code looks to only clear things when
> > they are !IRQ_UNBOUND.
> > 
> > But the other logic (IRQ_UNBOUND) looks to be missing a removal
> > in the radix tree:
> > 
> >   if ( emuirq != IRQ_PT )                                                     
> >         radix_tree_delete(&d->arch.hvm_domain.emuirq_pirq, emuirq);             
> >                                                                         
> > And I think that is what is causing the leak - the radix tree
> > needs to be pruned? Or perhaps the allocate_pirq should check
> > the radix tree for IRQ_UNBOUND ones and re-use them?
> 
> I think that you are looking in the wrong place.
> The issue is that QEMU doesn't call pt_msi_disable in
> pt_msgctrl_reg_write if (!val & PCI_MSI_FLAGS_ENABLE).

In my test-case I am not even calling QEMU. I am just doing two hypercalls 
hypercall - get_free_pirq and unmap.
> 
> The code above is correct as is because it is trying to handle emulated
> IRQs and MSIs, not real passthrough MSIs. They latter are not added to
> that radix tree, see physdev_hvm_map_pirq and physdev_map_pirq.

The bug is in the hypervisor. This little patch solves the test-case
(I hadn't tried to do the PCI passthrough yet)


diff --git a/xen/arch/x86/irq.c b/xen/arch/x86/irq.c
index b0b0c65..b78717a 100644
--- a/xen/arch/x86/irq.c
+++ b/xen/arch/x86/irq.c
@@ -1851,8 +1851,8 @@ static int pirq_guest_force_unbind(struct domain *d, struct pirq *pirq)
 static inline bool_t is_free_pirq(const struct domain *d,
                                   const struct pirq *pirq)
 {
-    return !pirq || (!pirq->arch.irq && (!is_hvm_domain(d) ||
-        pirq->arch.hvm.emuirq == IRQ_UNBOUND));
+    return !pirq || ((pirq->arch.irq == 0 || (pirq->arch.irq == PIRQ_ALLOCATED)) &&
+           (!is_hvm_domain(d) || pirq->arch.hvm.emuirq == IRQ_UNBOUND));
 }
 
 int get_free_pirq(struct domain *d, int type)


The reason is that pirq->arch.irq in PHYSDEVOP_get_free_pirq is set to
from the value of zero to -1 (PIRQ_ALLOCATED). Then in map_domain_pirq
we check it first:

904     old_irq = domain_pirq_to_irq(d, pirq);                  
.. snip..                    
1907     if ( (old_irq > 0 && (old_irq != irq) ) ||                                  

and since the 'old_irq' is -1 (or zero), and the irq passed in
is different, then all checks pass and the value is over-written:

 1988         set_domain_irq_pirq(d, irq, info);                                      

And that is it.

