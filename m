Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab3F1LM4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 07:12:56 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:41426 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab3F1LMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 07:12:55 -0400
X-IronPort-AV: E=Sophos;i="4.87,958,1363132800"; 
   d="scan'208";a="32428233"
Date: Fri, 28 Jun 2013 12:12:47 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Zhenzhong Duan <zhenzhong.duan@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Feng Jin <joe.jin@oracle.com>, Yuval Shaia <yuval.shaia@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chien Yen <chien.yen@oracle.com>
Subject: Re: [Xen-devel] [PATCH] xen: reuse the same pirq allocated when
 driver load first time
In-Reply-To: <51CCF5E0.908@oracle.com>
Message-ID: <alpine.DEB.2.02.1306281209160.4782@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1305131753070.4799@kaball.uk.xensource.com> <20130520175706.GA27973@phenom.dumpdata.com> <20130520203855.GA30616@phenom.dumpdata.com> <519B474E.4000202@citrix.com> <20130521134059.GE492@phenom.dumpdata.com>
 <alpine.DEB.2.02.1305211748030.4799@kaball.uk.xensource.com> <alpine.DEB.2.02.1305291850030.4799@kaball.uk.xensource.com> <51AECC3A.7060803@oracle.com> <alpine.DEB.2.02.1306051349380.4589@kaball.uk.xensource.com> <51C26F98.8070103@oracle.com>
 <alpine.DEB.2.02.1306201507010.4548@kaball.uk.xensource.com> <51C7F2FE.3090803@oracle.com> <alpine.DEB.2.02.1306241807100.4782@kaball.uk.xensource.com> <51C92B8F.6010904@oracle.com> <alpine.DEB.2.02.1306251208260.4782@kaball.uk.xensource.com>
 <51CA674B.3090807@oracle.com> <alpine.DEB.2.02.1306261856420.4782@kaball.uk.xensource.com> <51CBB908.1050909@oracle.com> <alpine.DEB.2.02.1306271247350.4782@kaball.uk.xensource! .com> <51CCF5E0.908@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Jun 2013, Zhenzhong Duan wrote:
> On 2013-06-27 19:52, Stefano Stabellini wrote:
> > On Thu, 27 Jun 2013, Zhenzhong Duan wrote:
> > > On 2013-06-27 02:08, Stefano Stabellini wrote:
> > > > On Wed, 26 Jun 2013, Zhenzhong Duan wrote:
> > > > > On 2013-06-26 01:51, Stefano Stabellini wrote:
> > > > > > On Tue, 25 Jun 2013, DuanZhenzhong wrote:
> > > > > > > Stefano Stabellini wrote:
> > > > > > > > Trimming some of the people in CC
> > > > > > > > 
> > > > > > > > On Mon, 24 Jun 2013, Zhenzhong Duan wrote:
> > > > > > > >      
> > > > > > > > > On 2013-06-20 22:21, Stefano Stabellini wrote:
> > > > > > > > >        
> > > > > > > > > > On Thu, 20 Jun 2013, Zhenzhong Duan wrote:
> > > > > > > > > >          
> > > > > > > > > > > On 2013-06-05 20:50, Stefano Stabellini wrote:
> > > > > > > > > > >            
> > > > > > > > > > > > On Wed, 5 Jun 2013, Zhenzhong Duan wrote:
> > > > > > > > > > > >              
> > > > > > > > > > > > > Stefano Stabellini wrote:
> > > > > > > > > > > > > 
> > > > > > > > > > > > > On Tue, 21 May 2013, Stefano Stabellini wrote:
> > > > > > > > > > > > >        On Tue, 21 May 2013, Konrad Rzeszutek Wilk
> > > > > > > > > > > > > wrote:
> > > > > > > > > > > > >          Looking at the hypervisor code I couldn't see
> > > > > > > > > > > > > anything
> > > > > > > > > > > > > obviously
> > > > > > > > > > > > > wrong.
> > > > > > > > > > > > >              I think the culprit is
> > > > > > > > > > > > > "physdev_unmap_pirq":
> > > > > > > > > > > > > 
> > > > > > > > > > > > >         if ( is_hvm_domain(d) )
> > > > > > > > > > > > >          {
> > > > > > > > > > > > >              spin_lock(&d->event_lock);
> > > > > > > > > > > > >              gdprintk(XENLOG_WARNING,"d%d, pirq: %d is
> > > > > > > > > > > > > %x
> > > > > > > > > > > > > %s,
> > > > > > > > > > > > > irq:
> > > > > > > > > > > > > %d\n",
> > > > > > > > > > > > >                  d->domain_id, pirq,
> > > > > > > > > > > > > domain_pirq_to_emuirq(d,
> > > > > > > > > > > > > pirq),
> > > > > > > > > > > > >                  domain_pirq_to_emuirq(d, pirq) ==
> > > > > > > > > > > > > IRQ_UNBOUND ?
> > > > > > > > > > > > > "unbound" :
> > > > > > > > > > > > > "",
> > > > > > > > > > > > >                  domain_pirq_to_irq(d, pirq));
> > > > > > > > > > > > >                                                                                               if
> > > > > > > > > > > > > ( domain_pirq_to_emuirq(d, pirq) != IRQ_UNBOUND )
> > > > > > > > > > > > >                  ret = unmap_domain_pirq_emuirq(d,
> > > > > > > > > > > > > pirq);
> > > > > > > > > > > > >              spin_unlock(&d->event_lock);
> > > > > > > > > > > > >              if ( domid == DOMID_SELF || ret )
> > > > > > > > > > > > >                  goto free_domain;
> > > > > > > > > > > > > 
> > > > > > > > > > > > > It always tells me unbound:
> > > > > > > > > > > > > 
> > > > > > > > > > > > > (XEN) physdev.c:237:d14 14, pirq: 54 is ffffffff
> > > > > > > > > > > > > (XEN) irq.c:1873:d14 14, nr_pirqs: 56
> > > > > > > > > > > > > (XEN) physdev.c:237:d14 14, pirq: 53 is ffffffff
> > > > > > > > > > > > > (XEN) irq.c:1873:d14 14, nr_pirqs: 56
> > > > > > > > > > > > > (XEN) physdev.c:237:d14 14, pirq: 52 is ffffffff
> > > > > > > > > > > > > (XEN) irq.c:1873:d14 14, nr_pirqs: 56
> > > > > > > > > > > > > (XEN) physdev.c:237:d14 14, pirq: 51 is ffffffff
> > > > > > > > > > > > > (XEN) irq.c:1873:d14 14, nr_pirqs: 56
> > > > > > > > > > > > > (XEN) physdev.c:237:d14 14, pirq: 50 is ffffffff
> > > > > > > > > > > > > (XEN) irq.c:1873:d14 14, nr_pirqs: 56
> > > > > > > > > > > > > (a bit older debug code, so the 'unbound' does not
> > > > > > > > > > > > > show up
> > > > > > > > > > > > > here).
> > > > > > > > > > > > > 
> > > > > > > > > > > > > Which means that the call to unmap_domain_pirq_emuirq
> > > > > > > > > > > > > does
> > > > > > > > > > > > > not
> > > > > > > > > > > > > happen.
> > > > > > > > > > > > > The checks in unmap_domain_pirq_emuirq also look to be
> > > > > > > > > > > > > depend
> > > > > > > > > > > > > on the code being IRQ_UNBOUND.
> > > > > > > > > > > > > 
> > > > > > > > > > > > > In other words, all of that code looks to only clear
> > > > > > > > > > > > > things
> > > > > > > > > > > > > when
> > > > > > > > > > > > > they are !IRQ_UNBOUND.
> > > > > > > > > > > > > 
> > > > > > > > > > > > > But the other logic (IRQ_UNBOUND) looks to be missing
> > > > > > > > > > > > > a
> > > > > > > > > > > > > removal
> > > > > > > > > > > > > in the radix tree:
> > > > > > > > > > > > > 
> > > > > > > > > > > > >        if ( emuirq != IRQ_PT )
> > > > > > > > > > > > >              radix_tree_delete(&d->arch.hvm_domain.emuirq_pirq,
> > > > > > > > > > > > > emuirq);
> > > > > > > > > > > > >                                                                              And
> > > > > > > > > > > > > I think that is what is causing the leak - the radix
> > > > > > > > > > > > > tree
> > > > > > > > > > > > > needs to be pruned? Or perhaps the allocate_pirq
> > > > > > > > > > > > > should
> > > > > > > > > > > > > check
> > > > > > > > > > > > > the radix tree for IRQ_UNBOUND ones and re-use them?
> > > > > > > > > > > > >            I think that you are looking in the wrong
> > > > > > > > > > > > > place.
> > > > > > > > > > > > > The issue is that QEMU doesn't call pt_msi_disable in
> > > > > > > > > > > > > pt_msgctrl_reg_write if (!val & PCI_MSI_FLAGS_ENABLE).
> > > > > > > > > > > > > 
> > > > > > > > > > > > > The code above is correct as is because it is trying
> > > > > > > > > > > > > to
> > > > > > > > > > > > > handle
> > > > > > > > > > > > > emulated
> > > > > > > > > > > > > IRQs and MSIs, not real passthrough MSIs. They latter
> > > > > > > > > > > > > are
> > > > > > > > > > > > > not
> > > > > > > > > > > > > added to
> > > > > > > > > > > > > that radix tree, see physdev_hvm_map_pirq and
> > > > > > > > > > > > > physdev_map_pirq.
> > > > > > > > > > > > >          This patch fixes the issue, I have only
> > > > > > > > > > > > > tested MSI
> > > > > > > > > > > > > (MSI-X
> > > > > > > > > > > > > completely
> > > > > > > > > > > > > untested).
> > > > > > > > > > > > > 
> > > > > > > > > > > > > 
> > > > > > > > > > > > > diff --git a/hw/pass-through.c b/hw/pass-through.c
> > > > > > > > > > > > > index 304c438..079e465 100644
> > > > > > > > > > > > > --- a/hw/pass-through.c
> > > > > > > > > > > > > +++ b/hw/pass-through.c
> > > > > > > > > > > > > @@ -3866,7 +3866,11 @@ static int
> > > > > > > > > > > > > pt_msgctrl_reg_write(struct
> > > > > > > > > > > > > pt_dev
> > > > > > > > > > > > > *ptdev,
> > > > > > > > > > > > >               ptdev->msi->flags |=
> > > > > > > > > > > > > PCI_MSI_FLAGS_ENABLE;
> > > > > > > > > > > > >           }
> > > > > > > > > > > > >           else
> > > > > > > > > > > > > -        ptdev->msi->flags &= ~PCI_MSI_FLAGS_ENABLE;
> > > > > > > > > > > > > +    {
> > > > > > > > > > > > > +        if (ptdev->msi->flags & PT_MSI_MAPPED) {
> > > > > > > > > > > > > +            pt_msi_disable(ptdev);
> > > > > > > > > > > > > +        }
> > > > > > > > > > > > > +    }
> > > > > > > > > > > > >             /* pass through MSI_ENABLE bit when no
> > > > > > > > > > > > > MSI-INTx
> > > > > > > > > > > > > translation
> > > > > > > > > > > > > */
> > > > > > > > > > > > >           if (!ptdev->msi_trans_en) {
> > > > > > > > > > > > > @@ -4013,6 +4017,8 @@ static int
> > > > > > > > > > > > > pt_msixctrl_reg_write(struct
> > > > > > > > > > > > > pt_dev
> > > > > > > > > > > > > *ptdev,
> > > > > > > > > > > > >                   pt_disable_msi_translate(ptdev);
> > > > > > > > > > > > >               }
> > > > > > > > > > > > >               pt_msix_update(ptdev);
> > > > > > > > > > > > > +    } else if (!(*value & PCI_MSIX_ENABLE) &&
> > > > > > > > > > > > > ptdev->msix->enabled) {
> > > > > > > > > > > > > +        pt_msix_delete(ptdev);
> > > > > > > > > > > > >        Hi Stefano,
> > > > > > > > > > > > > I made a test with this patch, os reboot when driver
> > > > > > > > > > > > > reload.
> > > > > > > > > > > > > If
> > > > > > > > > > > > > use
> > > > > > > > > > > > > pt_msix_disable
> > > > > > > > > > > > > instead of pt_msix_delete, driver could be reloaded.
> > > > > > > > > > > > > But I still see some error in qemu.log and xen
> > > > > > > > > > > > > console.
> > > > > > > > > > > > > Seems
> > > > > > > > > > > > > four
> > > > > > > > > > > > > IRQs
> > > > > > > > > > > > > are not freed
> > > > > > > > > > > > > when unmap.
> > > > > > > > > > > > > --------------first load---------------------------
> > > > > > > > > > > > > pt_msix_update_one: pt_msix_update_one requested pirq
> > > > > > > > > > > > > =
> > > > > > > > > > > > > 103
> > > > > > > > > > > > > pt_msix_update_one: Update msix entry 0 with pirq 67
> > > > > > > > > > > > > gvec
> > > > > > > > > > > > > 0
> > > > > > > > > > > > > pt_msix_update_one: pt_msix_update_one requested pirq
> > > > > > > > > > > > > =
> > > > > > > > > > > > > 102
> > > > > > > > > > > > > pt_msix_update_one: Update msix entry 1 with pirq 66
> > > > > > > > > > > > > gvec
> > > > > > > > > > > > > 0
> > > > > > > > > > > > > pt_msix_update_one: pt_msix_update_one requested pirq
> > > > > > > > > > > > > =
> > > > > > > > > > > > > 101
> > > > > > > > > > > > > pt_msix_update_one: Update msix entry 2 with pirq 65
> > > > > > > > > > > > > gvec
> > > > > > > > > > > > > 0
> > > > > > > > > > > > > pt_msix_update_one: pt_msix_update_one requested pirq
> > > > > > > > > > > > > =
> > > > > > > > > > > > > 100
> > > > > > > > > > > > > pt_msix_update_one: Update msix entry 3 with pirq 64
> > > > > > > > > > > > > gvec
> > > > > > > > > > > > > 0
> > > > > > > > > > > > > ------------- first unload---------------------------
> > > > > > > > > > > > > pt_msix_disable: Unbind msix with pirq 67, gvec 0
> > > > > > > > > > > > > pt_msix_disable: Unmap msix with pirq 67
> > > > > > > > > > > > > pt_msix_disable: Error: Unmapping of MSI-X failed.
> > > > > > > > > > > > > [00:04.0]
> > > > > > > > > > > > > pt_msix_disable: Unbind msix with pirq 66, gvec 0
> > > > > > > > > > > > > pt_msix_disable: Unmap msix with pirq 66
> > > > > > > > > > > > > pt_msix_disable: Error: Unmapping of MSI-X failed.
> > > > > > > > > > > > > [00:04.0]
> > > > > > > > > > > > > pt_msix_disable: Unbind msix with pirq 65, gvec 0
> > > > > > > > > > > > > pt_msix_disable: Unmap msix with pirq 65
> > > > > > > > > > > > > pt_msix_disable: Error: Unmapping of MSI-X failed.
> > > > > > > > > > > > > [00:04.0]
> > > > > > > > > > > > > pt_msix_disable: Unbind msix with pirq 64, gvec 0
> > > > > > > > > > > > > pt_msix_disable: Unmap msix with pirq 64
> > > > > > > > > > > > > pt_msix_disable: Error: Unmapping of MSI-X failed.
> > > > > > > > > > > > > [00:04.0]
> > > > > > > > > > > > >                
> > > > > > > > > > > > Can you add some printks in Xen (the hypercall name is
> > > > > > > > > > > > PHYSDEVOP_unmap_pirq) to figure out exactly why they are
> > > > > > > > > > > > failing?
> > > > > > > > > > > >              
> > > > > > > > > > > Did some test, domain_pirq_to_emuirq(d, unmap->pirq) =
> > > > > > > > > > > IRQ_UNBOUND
> > > > > > > > > > > in
> > > > > > > > > > > physdev_unmap_pirq.
> > > > > > > > > > >            
> > > > > > > > > > That means that Linux didn't call irq_enable on the MSI-X in
> > > > > > > > > > question:
> > > > > > > > > > 
> > > > > > > > > > irq_enable -> __startup_pirq -> EVTCHNOP_bind_pirq
> > > > > > > > > > 
> > > > > > > > > > EVTCHNOP_bind_pirq is implemented by evtchn_bind_pirq in Xen
> > > > > > > > > > and
> > > > > > > > > > calls
> > > > > > > > > > map_domain_emuirq_pirq, so domain_pirq_to_emuirq(d,
> > > > > > > > > > unmap->pirq)
> > > > > > > > > > should
> > > > > > > > > > be IRQ_PT.
> > > > > > > > > > 
> > > > > > > > > > I don't know if that's a normal condition, but in any case
> > > > > > > > > > it
> > > > > > > > > > should
> > > > > > > > > > not create any problems to physdev_unmap_pirq, in fact the
> > > > > > > > > > folloing
> > > > > > > > > > check:
> > > > > > > > > > 
> > > > > > > > > >         if ( domid == DOMID_SELF || ret )
> > > > > > > > > >                 goto free_domain;
> > > > > > > > > > 
> > > > > > > > > > should fail so Xen should continue and execute
> > > > > > > > > > unmap_domain_pirq.
> > > > > > > > > > That's
> > > > > > > > > > what we want.
> > > > > > > > > >          
> > > > > > > > >    From linux side, request_irq->  request_threaded_irq->
> > > > > > > > > __setup_irq->
> > > > > > > > > irq_startup->  startup_pirq-> EVTCHNOP_bind_pirq
> > > > > > > > > If irq_enable isn't called, how does the driver receive
> > > > > > > > > interrupt,
> > > > > > > > > I
> > > > > > > > > did
> > > > > > > > > see
> > > > > > > > > four interrupts in /proc/interrupt and driver works ok.
> > > > > > > > >        
> > > > > > > > Good to know
> > > > > > > > 
> > > > > > > >      
> > > > > > > > > Could you have a look if there is something wrong in xen side
> > > > > > > > > of
> > > > > > > > > clearing
> > > > > > > > > the
> > > > > > > > > mapping?
> > > > > > > > >        
> > > > > > > > What I am saying is that the error you are getting:
> > > > > > > > 
> > > > > > > > pt_msix_disable: Unbind msix with pirq 67, gvec 0
> > > > > > > > pt_msix_disable: Unmap msix with pirq 67
> > > > > > > > pt_msix_disable: Error: Unmapping of MSI-X failed. [00:04.0]
> > > > > > > > 
> > > > > > > > cannot be caused by domain_pirq_to_emuirq(d, pirq) returning
> > > > > > > > IRQ_UNBOUND.
> > > > > > > > So, why are you getting this error? What is failing?
> > > > > > > > I am ready to believe the problem is in Xen but Without
> > > > > > > > understanding
> > > > > > > > why you are getting the error it's hard to find a solution.
> > > > > > > >      
> > > > > > > I found the reason, you are looking at xen-unstable, I was working
> > > > > > > with
> > > > > > > 4.1.30-OVM, it has patch of CVE-2012-4536 / XSA-21.
> > > > > > > That patch set ret to -EINVAL initially. After remove that line,
> > > > > > > unmap
> > > > > > > succeed.
> > > > > > > But we still need below patch to let driver reload succeed
> > > > > > > everytime.
> > > > > > > Without
> > > > > > > that, 1st reload failed, 2nd succeed, 3 failed, ...
> > > > > > > 
> > > > > > > diff -up --new-file ./hw/pt-msi.c.old1 ./hw/pt-msi.c
> > > > > > > --- ./hw/pt-msi.c.old1  2013-06-26 01:36:08.000000000 +0800
> > > > > > > +++ ./hw/pt-msi.c       2013-06-26 01:37:41.000000000 +0800
> > > > > > > @@ -469,7 +469,7 @@ static void pci_msix_writel(void *opaque
> > > > > > >            return;
> > > > > > >        }
> > > > > > > 
> > > > > > > -    if ( offset != 3 && entry->io_mem[offset] != val )
> > > > > > > +    if ( offset != 3 && (entry->io_mem[offset] != val ||
> > > > > > > entry->pirq
> > > > > > > ==
> > > > > > > -1))
> > > > > > >            entry->flags = 1;
> > > > > > >        entry->io_mem[offset] = val;
> > > > > > Interesting. I don't think this is the proper fix though.
> > > > > > Does the appended patch change anything?
> > > > > > 
> > > > > > diff --git a/hw/pt-msi.c b/hw/pt-msi.c
> > > > > > index 71fa6f0..cd5d9c7 100644
> > > > > > --- a/hw/pt-msi.c
> > > > > > +++ b/hw/pt-msi.c
> > > > > > @@ -302,7 +302,7 @@ static int pt_msix_update_one(struct pt_dev
> > > > > > *dev,
> > > > > > int
> > > > > > entry_nr)
> > > > > >         uint32_t gflags = __get_msi_gflags(entry->io_mem[2], gaddr);
> > > > > >         int ret;
> > > > > >     -    if ( !entry->flags )
> > > > > > +    if ( !entry->flags && ptdev->msix->enabled )
> > > > > >             return 0;
> > > > > >           if (!gvec) {
> > > > > Tested, not work.
> > > > > If you look at msix_capability_init in kernel, line 707,722,
> > > > > dev->msix->enabled is already set when pt_msix_update is called.
> > > > Yeah, but it shouldn't be already set in QEMU. In fact in QEMU
> > > > dev->msix->enabled is modified in pt_msixctrl_reg_write after calling to
> > > > pt_msix_update.
> > > It does.
> > > line 707,  PCI_MSIX_FLAGS_MASKALL | PCI_MSIX_FLAGS_ENABLE is set
> > >                   this will set dev->msix->enabled first time
> > > line 722, PCI_MSIX_FLAGS_ENABLE set
> > >                   this trigger call of pt_msix_update
> > >                   then dev->msix->enabled was set a second time
> > > > I was assuming that you needed to add "|| entry->pirq == -1" because you
> > > > needed to pass the check:
> > > > 
> > > >       if ( !entry->flags )
> > > >           return 0;
> > > > 
> > > > at the beginning of pt_msix_update_one. Am I getting it right?
> > > Right, as entry->pirq is set to -1 when driver unload.
> > > > If that is case that I thought that we just needed to make sure that
> > > > when ptdev->msix->enabled is still zero then we go through the test in
> > > > pt_msix_update_one. Where is the mistake?
> > > If you want to use dev->msix->enabled for checking, below patch could
> > > work.
> > > But in this case, dev->msix->enabled doesn't represent PCI_MSIX_ENABLE any
> > > more,
> > > but a combination of PCI_MSIX_ENABLE and ~PCI_MSIX_MASK
> > > 
> > > zduan
> > > ***********************************************************
> > > diff -up ./hw/pass-through.c.old2 ./hw/pass-through.c
> > > --- ./hw/pass-through.c.old2    2013-06-27 11:05:30.000000000 +0800
> > > +++ ./hw/pass-through.c 2013-06-27 11:07:35.000000000 +0800
> > > @@ -4027,7 +4027,7 @@ static int pt_msixctrl_reg_write(struct
> > >           pt_msix_disable(ptdev);
> > >       }
> > > 
> > > -    ptdev->msix->enabled = !!(*value & PCI_MSIX_ENABLE);
> > > +    ptdev->msix->enabled = (*value & PCI_MSIX_ENABLE) && !(*value &
> > > PCI_MSIX_MASK);
> > > 
> > >       return 0;
> > >   }
> > > diff -up ./hw/pt-msi.c.old2 ./hw/pt-msi.c
> > > --- ./hw/pt-msi.c.old2  2013-06-27 11:26:12.000000000 +0800
> > > +++ ./hw/pt-msi.c       2013-06-27 11:27:13.000000000 +0800
> > > @@ -294,7 +294,7 @@ static int pt_msix_update_one(struct pt_
> > >       uint32_t gflags = __get_msi_gflags(entry->io_mem[2], gaddr);
> > >       int ret;
> > > 
> > > -    if ( !entry->flags )
> > > +    if ( !entry->flags && dev->msix->enabled )
> > >           return 0;
> > > 
> > >       if (!gvec) {
> > I understand now, thanks for the explanation.
> > Among the two alternatives, I think that your first change is actually
> > better.
> > 
> > However we can probably still improve it a little bit by setting
> > entry->flags to 1 directly in pt_msix_disable? So that we don't confuse
> > the driver reload case from the first driver initialization.
> > 
> > diff --git a/hw/pt-msi.c b/hw/pt-msi.c
> > index 71fa6f0..cc4e280 100644
> > --- a/hw/pt-msi.c
> > +++ b/hw/pt-msi.c
> > @@ -408,7 +408,7 @@ void pt_msix_disable(struct pt_dev *dev)
> >           }
> >           /* clear msi-x info */
> >           entry->pirq = -1;
> > -        entry->flags = 0;
> > +        entry->flags = 1;
> >       }
> >   }
> Test passed.
> But this change set entry->flags in all entrys, dev->msix->total_entries count
> of pirqs are
> mapped when driver reload, no matter how many msix entrys driver is
> initializing.

OK, you convinced me, let's go with your initial solution to this
problem :-)

Can you please resend a patch for qemu-xen-traditional and qemu-xen to
xen-devel with all the changes?

Thanks!
