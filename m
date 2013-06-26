Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab3FZPvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 11:51:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581Ab3FZPvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 11:51:13 -0400
Message-ID: <1372261864.30572.553.camel@ul30vt.home>
Subject: Re: [PATCH RFC] pci: ACS quirk for AMD southbridge
From: Alex Williamson <alex.williamson@redhat.com>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>
Date: Wed, 26 Jun 2013 09:51:04 -0600
In-Reply-To: <20130626171428.33940803@dualc.maya.org>
References: <20120712050653.20439.11009.stgit@bling.home>
	 <CAErSpo7=p7HyUfw4AQ-oQpLvgMfBi5iPfB+Fvrb02FWVHd_FAg@mail.gmail.com>
	 <CAErSpo6Xf=eF3xv=9CLmDYVMpWT6FSv634s8V-YfreiN6icDUA@mail.gmail.com>
	 <20130626171428.33940803@dualc.maya.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-26 at 17:14 +0200, Andreas Hartmann wrote:
> Bjorn Helgaas wrote:
> > [fix Joerg's email address]
> > 
> > On Tue, Jun 25, 2013 at 10:15 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> >> On Wed, Jul 11, 2012 at 11:18 PM, Alex Williamson
> >> <alex.williamson@redhat.com> wrote:
> >>> We've confirmed that peer-to-peer between these devices is
> >>> not possible.  We can therefore claim that they support a
> >>> subset of ACS.
> >>>
> >>> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> >>> Cc: Joerg Roedel <Joerg.Roedel@amd.com>
> >>> ---
> >>>
> >>> Two things about this patch make me a little nervous.  The
> >>> first is that I'd really like to have a pci_is_pcie() test
> >>> in pci_mf_no_p2p_acs_enabled(), but these devices don't
> >>> have a PCIe capability.  That means that if there was a
> >>> topology where these devices sit on a legacy PCI bus,
> >>> we incorrectly return that we're ACS safe here.  That leads
> >>> to my second problem, pciids seems to suggest that some of
> >>> these functions have been around for a while.  Is it just
> >>> this package that's peer-to-peer safe, or is it safe to
> >>> assume that any previous assembly of these functions is
> >>> also p2p safe.  Maybe we need to factor in device revs if
> >>> that uniquely identifies this package?
> >>>
> >>> Looks like another useful device to potentially quirk
> >>> would be:
> >>>
> >>> 00:15.0 PCI bridge: Advanced Micro Devices [AMD] nee ATI SB700/SB800/SB900 PCI to PCI bridge (PCIE port 0)
> >>> 00:15.1 PCI bridge: Advanced Micro Devices [AMD] nee ATI SB700/SB800/SB900 PCI to PCI bridge (PCIE port 1)
> >>> 00:15.2 PCI bridge: Advanced Micro Devices [AMD] nee ATI SB900 PCI to PCI bridge (PCIE port 2)
> >>> 00:15.3 PCI bridge: Advanced Micro Devices [AMD] nee ATI SB900 PCI to PCI bridge (PCIE port 3)
> >>>
> >>> 00:15.0 0604: 1002:43a0
> >>> 00:15.1 0604: 1002:43a1
> >>> 00:15.2 0604: 1002:43a2
> >>> 00:15.3 0604: 1002:43a3
> >>>
> >>>  drivers/pci/quirks.c |   29 +++++++++++++++++++++++++++++
> >>>  1 file changed, 29 insertions(+)
> >>>
> >>> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> >>> index 4ebc865..2c84961 100644
> >>> --- a/drivers/pci/quirks.c
> >>> +++ b/drivers/pci/quirks.c
> >>> @@ -3271,11 +3271,40 @@ struct pci_dev *pci_get_dma_source(struct pci_dev *dev)
> >>>         return pci_dev_get(dev);
> >>>  }
> >>>
> >>> +/*
> >>> + * Multifunction devices that do not support peer-to-peer between
> >>> + * functions can claim to support a subset of ACS.  Such devices
> >>> + * effectively enable request redirect (RR) and completion redirect (CR)
> >>> + * since all transactions are redirected to the upstream root complex.
> >>> + */
> >>> +static int pci_mf_no_p2p_acs_enabled(struct pci_dev *dev, u16 acs_flags)
> >>> +{
> >>> +       if (!dev->multifunction)
> >>> +               return -ENODEV;
> >>> +
> >>> +       /* Filter out flags not applicable to multifunction */
> >>> +       acs_flags &= (PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_EC | PCI_ACS_DT);
> >>> +
> >>> +       return acs_flags & ~(PCI_ACS_RR | PCI_ACS_CR) ? 0 : 1;
> >>> +}
> >>> +
> >>>  static const struct pci_dev_acs_enabled {
> >>>         u16 vendor;
> >>>         u16 device;
> >>>         int (*acs_enabled)(struct pci_dev *dev, u16 acs_flags);
> >>>  } pci_dev_acs_enabled[] = {
> >>> +       /*
> >>> +        * AMD/ATI multifunction southbridge devices.  AMD has confirmed
> >>> +        * that peer-to-peer between these devices is not possible, so
> >>> +        * they do support a subset of ACS even though the capability is
> >>> +        * not exposed in config space.
> >>> +        */
> >>> +       { PCI_VENDOR_ID_ATI, 0x4385, pci_mf_no_p2p_acs_enabled },
> >>> +       { PCI_VENDOR_ID_ATI, 0x439c, pci_mf_no_p2p_acs_enabled },
> >>> +       { PCI_VENDOR_ID_ATI, 0x4383, pci_mf_no_p2p_acs_enabled },
> >>> +       { PCI_VENDOR_ID_ATI, 0x439d, pci_mf_no_p2p_acs_enabled },
> >>> +       { PCI_VENDOR_ID_ATI, 0x4384, pci_mf_no_p2p_acs_enabled },
> >>> +       { PCI_VENDOR_ID_ATI, 0x4399, pci_mf_no_p2p_acs_enabled },
> >>>         { 0 }
> >>>  };
> >>>
> >>>
> >>
> >> I was looking for something else and found this old email.  This patch
> >> hasn't been applied and I haven't seen any discussion about it.  Is it
> >> still of interest?  It seems relevant to the current ACS discussion
> >> [1].
> 
> It is absolutely relevant. I always have to patch my kernel to get it
> working to put my pci device to VM. Meanwhile I'm doing it for
> kernel 3.9. I would be very glad to get these patches to the kernel as
> they don't do anything bad!

I'd still like to see this get in too.  IIRC, where we left off was that
Joerg had confirmed with the hardware folks that there is no
peer-to-peer between these devices, but we still had questions about
whether that was true for any instance of these vendor/device IDs.
These devices are re-used in several packages and I'm not sure if we
need to somehow figure out what package (ie. which chipset generation)
we're looking at to know if p2p is used.  Thanks,

Alex


