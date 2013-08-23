Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab3HWRPu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 13:15:50 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:43729 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810Ab3HWRPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 13:15:48 -0400
Date: Fri, 23 Aug 2013 13:15:38 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: zhenzhong.duan@oracle.com,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        xen-devel <xen-devel@lists.xen.org>, Feng Jin <joe.jin@oracle.com>,
        Sucheta Chakraborty <sucheta.chakraborty@qlogic.com>
Subject: Re: [PATCH 2/3 v2] Refactor msi/msix restore code Part2
Message-ID: <20130823171538.GB14096@phenom.dumpdata.com>
References: <51FF527F.7080904@oracle.com>
 <CAErSpo5JCpJ0=vcTAwjz4VjZ4imBJxM8TP9RWrmiee3VQnjY=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo5JCpJ0=vcTAwjz4VjZ4imBJxM8TP9RWrmiee3VQnjY=w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 03:14:34PM -0600, Bjorn Helgaas wrote:
> On Mon, Aug 5, 2013 at 1:21 AM, Zhenzhong Duan
> <zhenzhong.duan@oracle.com> wrote:
> > xen_initdom_restore_msi_irqs trigger a hypercall to restore addr/data/mask
> > in dom0. It's better to do the same in default_restore_msi_irqs for baremetal.
> >
> > Move restore of mask in default_restore_msi_irqs, this could avoid mask
> > restored twice in dom0, and the logic for baremetal keep same.
> >
> > First mask restore is in xen_initdom_restore_msi_irqs->PHYSDEVOP_restore_msi,
> > Second restore is __pci_restore_msix_state->msix_mask_irq.
> >
> > Mask bits are under full control of xen, and the entry->masked in dom0 kernel
> > is invalid. restore an invalid value to mask register could mask the msix
> > interrupt.
> >
> > Without fix, qlcnic driver calling pci_reset_function will lost interrupt
> > in dom0.
> 
> Konrad, this changelog still doesn't make any sense to me, but if you
> ack this, I guess I can apply it.

Hey Bjorn,

Zhenzhong is patiently working to rewrite up the commit message based on
my naive questions and emails back and forth. Once it is good shape he
will post it. The code will look the same but the commit message will
be a bit more verbose and clear.

Is there an ETA when you would like these? I recall the merge window
is just around the corner - so when is your comfortable cut-off-day
so that you can make a go/no-go decision?

> 
> I guess there are also:
> 
>   Jul 24  [PATCH 1/3] Refactor msi/msix restore code Part1
>   Jul 30  [PATCH 3/3 v2] Update x86_msi.restore_msi_irqs API param
> 
> and all three should be applied as a series?

<scratches his head>.

I think the
   Jul 30  [PATCH 3/3 v2] Update x86_msi.restore_msi_irqs API param

can go in anytime. That is mostly a cosmetic fixup in the API.
Zhenzhong - right?

For the 
   Jul 24  [PATCH 1/3] Refactor msi/msix restore code Part1

I would have to look back at the code - as I can't remember what it was
refactoring :-(

> 
> > Tested-by: Sucheta Chakraborty <sucheta.chakraborty@qlogic.com>
> > Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> > ---
> >  drivers/pci/msi.c |   17 ++++++++++++++---
> >  1 files changed, 14 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> > index 87223ae..922fb49 100644
> > --- a/drivers/pci/msi.c
> > +++ b/drivers/pci/msi.c
> > @@ -216,6 +216,8 @@ void unmask_msi_irq(struct irq_data *data)
> >  #ifdef HAVE_DEFAULT_MSI_RESTORE_IRQS
> >  void default_restore_msi_irqs(struct pci_dev *dev, int irq)
> >  {
> > +       int pos;
> > +       u16 control;
> >         struct msi_desc *entry;
> >
> >         entry = NULL;
> > @@ -228,8 +230,19 @@ void default_restore_msi_irqs(struct pci_dev *dev, int irq)
> >                 entry = irq_get_msi_desc(irq);
> >         }
> >
> > -       if (entry)
> > +       if (entry) {
> >                 write_msi_msg(irq, &entry->msg);
> > +               if (dev->msix_enabled) {
> > +                       msix_mask_irq(entry, entry->masked);
> > +                       readl(entry->mask_base);
> > +               } else {
> > +                       pos = entry->msi_attrib.pos;
> > +                       pci_read_config_word(dev, pos + PCI_MSI_FLAGS,
> > +                                            &control);
> > +                       msi_mask_irq(entry, msi_capable_mask(control),
> > +                                    entry->masked);
> > +               }
> > +       }
> >  }
> >  #endif
> >
> > @@ -406,7 +419,6 @@ static void __pci_restore_msi_state(struct pci_dev *dev)
> >         arch_restore_msi_irqs(dev, dev->irq);
> >
> >         pci_read_config_word(dev, dev->msi_cap + PCI_MSI_FLAGS, &control);
> > -       msi_mask_irq(entry, msi_capable_mask(control), entry->masked);
> >         control &= ~PCI_MSI_FLAGS_QSIZE;
> >         control |= (entry->msi_attrib.multiple << 4) | PCI_MSI_FLAGS_ENABLE;
> >         pci_write_config_word(dev, dev->msi_cap + PCI_MSI_FLAGS, control);
> > @@ -430,7 +442,6 @@ static void __pci_restore_msix_state(struct pci_dev *dev)
> >
> >         list_for_each_entry(entry, &dev->msi_list, list) {
> >                 arch_restore_msi_irqs(dev, entry->irq);
> > -               msix_mask_irq(entry, entry->masked);
> >         }
> >
> >         control &= ~PCI_MSIX_FLAGS_MASKALL;
> > --
> > 1.7.3
> >
