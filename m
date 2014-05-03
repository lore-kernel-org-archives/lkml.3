Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750920AbaECFPR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 01:15:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbaECFPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 01:15:15 -0400
Message-ID: <1399094110.24318.505.camel@ul30vt.home>
Subject: Re: [PATCH 03/13] PCI: quirk dma_func_alias for Ricoh devices
From: Alex Williamson <alex.williamson@redhat.com>
To: Andrew Cooks <acooks@gmail.com>
Cc: "open list:PCI SUBSYSTEM" <linux-pci@vger.kernel.org>,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        open list <linux-kernel@vger.kernel.org>
Date: Fri, 02 May 2014 23:15:10 -0600
In-Reply-To: <CAJtEV7bZ10fAE-JoTO6Gg1rg8sWxwzQUR5FkQpLZ1nTF_+dk5w@mail.gmail.com>
References: <20140501160128.17512.23609.stgit@bling.home>
	 <20140501162723.17512.96286.stgit@bling.home>
	 <CAJtEV7bZ10fAE-JoTO6Gg1rg8sWxwzQUR5FkQpLZ1nTF_+dk5w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-05-03 at 10:29 +0800, Andrew Cooks wrote:
> Hi Alex
> 
> On Fri, May 2, 2014 at 12:27 AM, Alex Williamson
> <alex.williamson@redhat.com> wrote:
> > The existing quirk for these devices doesn't really solve the problem,
> > re-implement it using the DMA alias iterator.  We'll come back later
> > and remove the existing quirk and dma_source interface.
> >
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> >  drivers/pci/quirks.c |   16 ++++++++++++++++
> >  1 file changed, 16 insertions(+)
> >
> > diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> > index e729206..a458c6b 100644
> > --- a/drivers/pci/quirks.c
> > +++ b/drivers/pci/quirks.c
> > @@ -3333,6 +3333,22 @@ int pci_dev_specific_reset(struct pci_dev *dev, int probe)
> >         return -ENOTTY;
> >  }
> >
> > +static void quirk_dma_func0_alias(struct pci_dev *dev)
> > +{
> > +       if (PCI_SLOT(dev->devfn) != 0)
> > +               dev->dma_func_alias |= (1 << 0);
> > +}
> > +
> > +/*
> > + * https://bugzilla.redhat.com/show_bug.cgi?id=605888
> > + *
> > + * Some Ricoh devices use function 0 as the PCIe requester ID for DMA.
> > + */
> > +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_RICOH, 0xe822, quirk_dma_func0_alias);
> > +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_RICOH, 0xe230, quirk_dma_func0_alias);
> > +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_RICOH, 0xe832, quirk_dma_func0_alias);
> > +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_RICOH, 0xe832, quirk_dma_func0_alias);
> 
> 0xe832 is listed twice.

oops, copy-paste error

> Previously only 0xe832 needed the dma alias on my thinkpad T410, which
> has all three devices.
> 
> > +
> >  static struct pci_dev *pci_func_0_dma_source(struct pci_dev *dev)
> >  {
> >         if (!PCI_FUNC(dev->devfn))
> >
> 
> Unfortunately, this quirk doesn't work for me. I tried it without
> modification, as well as with each alias individually. I get:
> 
> Set context mapping for 0d:00.3
> firewire_ohci 0000:0d:00.3: added OHCI v1.10 device as card 0, 4 IR +
> 4 IT contexts, quirks 0x11
> dmar: DRHD: handling fault status reg 2
> dmar: DMAR:[DMA Read] Request device [0d:00.0] fault addr fffff000
> DMAR:[fault reason 02] Present bit in context entry is clear
> 
> I think I need to see
> Set context mapping for 0d:00.0
> before
> Set context mapping for 0d:00.3

It would actually be the reverse, we always set the device, then the
alias for the device.

> in the log, but it's not there. I'd love to look into this and
> understand it properly, but I don't have time for the next four weeks.
> 
> The devices are attached as follows:
> BDF, device ID
> 0d:00.0, e822
> 0d:00.1, e230
> 0d:00.3, e832
> 
> The kernel log is attached.

Hmm, there are only a few reasons why you'd never see 0d:00.3 followed
by 0d:00.0...

1) dma_func_alias bit 0 isn't getting set on 0d:00.3; we are building
with CONFIG_PCI_QUIRKS=y, right?
2) domain_context_mapping_one called from domain_context_mapping_cb
returns !0; there's only one possible non-zero return for a non-vm,
non-si domain
3) something is broken in the first loop of pci_for_each_dma_alias; I'm
not seeing anything obvious

Anyway, appreciate an debugging you're able to fit in, my only ricoh
device has only function 0.  Thanks,

Alex


