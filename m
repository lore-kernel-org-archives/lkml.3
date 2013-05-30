Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966011Ab3E3RtL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 13:49:11 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:18354 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965904Ab3E3RtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 13:49:01 -0400
Date: Thu, 30 May 2013 13:48:39 -0400
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
Message-ID: <20130530174839.GA11686@phenom.dumpdata.com>
References: <20130514142013.GA10173@konrad-lan.dumpdata.com>
 <alpine.DEB.2.02.1305151037100.4799@kaball.uk.xensource.com>
 <5195944A.3050608@oracle.com>
 <alpine.DEB.2.02.1305201121370.4799@kaball.uk.xensource.com>
 <20130520175706.GA27973@phenom.dumpdata.com>
 <20130520203855.GA30616@phenom.dumpdata.com>
 <519B474E.4000202@citrix.com>
 <20130521134059.GE492@phenom.dumpdata.com>
 <alpine.DEB.2.02.1305211748030.4799@kaball.uk.xensource.com>
 <alpine.DEB.2.02.1305291850030.4799@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1305291850030.4799@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 06:50:41PM +0100, Stefano Stabellini wrote:
> On Tue, 21 May 2013, Stefano Stabellini wrote:
> > On Tue, 21 May 2013, Konrad Rzeszutek Wilk wrote:
> > > > Looking at the hypervisor code I couldn't see anything obviously wrong.
> > > 
> > > I think the culprit is "physdev_unmap_pirq":
> > > 
> > >    if ( is_hvm_domain(d) )                                                     
> > >     {                                                                           
> > >         spin_lock(&d->event_lock);                                              
> > >         gdprintk(XENLOG_WARNING,"d%d, pirq: %d is %x %s, irq: %d\n",            
> > >             d->domain_id, pirq, domain_pirq_to_emuirq(d, pirq),                 
> > >             domain_pirq_to_emuirq(d, pirq) == IRQ_UNBOUND ? "unbound" : "",        
> > >             domain_pirq_to_irq(d, pirq));                                       
> > >                                                                                 
> > >         if ( domain_pirq_to_emuirq(d, pirq) != IRQ_UNBOUND )                    
> > >             ret = unmap_domain_pirq_emuirq(d, pirq);                            
> > >         spin_unlock(&d->event_lock);                                            
> > >         if ( domid == DOMID_SELF || ret )                                       
> > >             goto free_domain;                                             
> > > 
> > > It always tells me unbound:
> > > 
> > > (XEN) physdev.c:237:d14 14, pirq: 54 is ffffffff
> > > (XEN) irq.c:1873:d14 14, nr_pirqs: 56
> > > (XEN) physdev.c:237:d14 14, pirq: 53 is ffffffff
> > > (XEN) irq.c:1873:d14 14, nr_pirqs: 56
> > > (XEN) physdev.c:237:d14 14, pirq: 52 is ffffffff
> > > (XEN) irq.c:1873:d14 14, nr_pirqs: 56
> > > (XEN) physdev.c:237:d14 14, pirq: 51 is ffffffff
> > > (XEN) irq.c:1873:d14 14, nr_pirqs: 56
> > > (XEN) physdev.c:237:d14 14, pirq: 50 is ffffffff
> > > (XEN) irq.c:1873:d14 14, nr_pirqs: 56
> > > (a bit older debug code, so the 'unbound' does not show up here).
> > > 
> > > Which means that the call to unmap_domain_pirq_emuirq does not happen.
> > > The checks in unmap_domain_pirq_emuirq also look to be depend
> > > on the code being IRQ_UNBOUND.
> > > 
> > > In other words, all of that code looks to only clear things when
> > > they are !IRQ_UNBOUND.
> > > 
> > > But the other logic (IRQ_UNBOUND) looks to be missing a removal
> > > in the radix tree:
> > > 
> > >   if ( emuirq != IRQ_PT )                                                     
> > >         radix_tree_delete(&d->arch.hvm_domain.emuirq_pirq, emuirq);             
> > >                                                                         
> > > And I think that is what is causing the leak - the radix tree
> > > needs to be pruned? Or perhaps the allocate_pirq should check
> > > the radix tree for IRQ_UNBOUND ones and re-use them?
> > 
> > I think that you are looking in the wrong place.
> > The issue is that QEMU doesn't call pt_msi_disable in
> > pt_msgctrl_reg_write if (!val & PCI_MSI_FLAGS_ENABLE).
> > 
> > The code above is correct as is because it is trying to handle emulated
> > IRQs and MSIs, not real passthrough MSIs. They latter are not added to
> > that radix tree, see physdev_hvm_map_pirq and physdev_map_pirq.
> 
> 
> This patch fixes the issue, I have only tested MSI (MSI-X completely
> untested).

I tested it on my NIC which has MSI and it worked nicely. The other box
with MSI-X is giving me a bit of trouble so will have to wait.

Duan,

Could you - when you get a moment - also try this with the PCI device
that was having issues please?
> 
> 
> diff --git a/hw/pass-through.c b/hw/pass-through.c
> index 304c438..079e465 100644
> --- a/hw/pass-through.c
> +++ b/hw/pass-through.c
> @@ -3866,7 +3866,11 @@ static int pt_msgctrl_reg_write(struct pt_dev *ptdev,
>          ptdev->msi->flags |= PCI_MSI_FLAGS_ENABLE;
>      }
>      else
> -        ptdev->msi->flags &= ~PCI_MSI_FLAGS_ENABLE;
> +    {
> +        if (ptdev->msi->flags & PT_MSI_MAPPED) {
> +            pt_msi_disable(ptdev);
> +        }
> +    }
>  
>      /* pass through MSI_ENABLE bit when no MSI-INTx translation */
>      if (!ptdev->msi_trans_en) {
> @@ -4013,6 +4017,8 @@ static int pt_msixctrl_reg_write(struct pt_dev *ptdev,
>              pt_disable_msi_translate(ptdev);
>          }
>          pt_msix_update(ptdev);
> +    } else if (!(*value & PCI_MSIX_ENABLE) && ptdev->msix->enabled) {
> +        pt_msix_delete(ptdev);
>      }
>  
>      ptdev->msix->enabled = !!(*value & PCI_MSIX_ENABLE);
> diff --git a/hw/pt-msi.c b/hw/pt-msi.c
> index b03b989..65fa7d6 100644
> --- a/hw/pt-msi.c
> +++ b/hw/pt-msi.c
> @@ -213,7 +213,8 @@ void pt_msi_disable(struct pt_dev *dev)
>  
>  out:
>      /* clear msi info */
> -    dev->msi->flags &= ~(MSI_FLAG_UNINIT | PT_MSI_MAPPED | PCI_MSI_FLAGS_ENABLE);
> +    dev->msi->flags &= ~(PT_MSI_MAPPED | PCI_MSI_FLAGS_ENABLE);
> +    dev->msi->flags |= MSI_FLAG_UNINIT;
>      dev->msi->pirq = -1;
>      dev->msi_trans_en = 0;
>  }
