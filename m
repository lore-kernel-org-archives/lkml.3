Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915Ab3HAPQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 11:16:33 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:43519 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756003Ab3HAPQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 11:16:29 -0400
Date: Thu, 1 Aug 2013 11:16:19 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: zhenzhong.duan@oracle.com,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        xen-devel <xen-devel@lists.xen.org>, Feng Jin <joe.jin@oracle.com>,
        Sucheta Chakraborty <sucheta.chakraborty@qlogic.com>
Subject: Re: [PATCH 2/3] Refactor msi/msix restore code Part2
Message-ID: <20130801151616.GE21528@konrad-lan.dumpdata.com>
References: <51EF451A.8050003@oracle.com>
 <CAErSpo5phkLpdR35eaMnYthVXiAAAr-JLD44QkntOZi2-NppOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo5phkLpdR35eaMnYthVXiAAAr-JLD44QkntOZi2-NppOg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 04:41:32PM -0600, Bjorn Helgaas wrote:
> On Tue, Jul 23, 2013 at 9:08 PM, Zhenzhong Duan
> <zhenzhong.duan@oracle.com> wrote:
> > xen_initdom_restore_msi_irqs trigger a hypercall to restore addr/data/mask
> > in dom0. It's better to do the same for default_restore_msi_irqs in baremetal.
> >
> > Move restore of mask in default_restore_msi_irqs, this could avoid mask
> > restored twice in dom0, once in hypercall, the other in kernel.
> >
> > Without that, qlcnic driver calling pci_reset_function will lost interrupt
> > in dom0.
> >
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
> 
> Konrad, are you OK with this patch now?

Yes, I wanted to make sure that the existing behavior under baremetal
was not altered.

And Duan had confirmed it was not  - thought to be on a safe side it
would be good to confirm this via testing just in case.

> 
> If so, can you (Zhenzhong) update the changelog with some of the info
> from the conversation with Konrad?  It seems like a few more details
> are needed to make it clear why we need this change.
> 
> Bjorn
