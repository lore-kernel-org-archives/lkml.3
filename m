Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591Ab3FZEPY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 00:15:24 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:42931 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab3FZEPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 00:15:22 -0400
MIME-Version: 1.0
In-Reply-To: <20120712050653.20439.11009.stgit@bling.home>
References: <20120712050653.20439.11009.stgit@bling.home>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 25 Jun 2013 22:15:01 -0600
Message-ID: <CAErSpo7=p7HyUfw4AQ-oQpLvgMfBi5iPfB+Fvrb02FWVHd_FAg@mail.gmail.com>
Subject: Re: [PATCH RFC] pci: ACS quirk for AMD southbridge
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Joerg Roedel <Joerg.Roedel@amd.com>, andihartmann@01019freenet.de,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 11:18 PM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> We've confirmed that peer-to-peer between these devices is
> not possible.  We can therefore claim that they support a
> subset of ACS.
>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> Cc: Joerg Roedel <Joerg.Roedel@amd.com>
> ---
>
> Two things about this patch make me a little nervous.  The
> first is that I'd really like to have a pci_is_pcie() test
> in pci_mf_no_p2p_acs_enabled(), but these devices don't
> have a PCIe capability.  That means that if there was a
> topology where these devices sit on a legacy PCI bus,
> we incorrectly return that we're ACS safe here.  That leads
> to my second problem, pciids seems to suggest that some of
> these functions have been around for a while.  Is it just
> this package that's peer-to-peer safe, or is it safe to
> assume that any previous assembly of these functions is
> also p2p safe.  Maybe we need to factor in device revs if
> that uniquely identifies this package?
>
> Looks like another useful device to potentially quirk
> would be:
>
> 00:15.0 PCI bridge: Advanced Micro Devices [AMD] nee ATI SB700/SB800/SB900 PCI to PCI bridge (PCIE port 0)
> 00:15.1 PCI bridge: Advanced Micro Devices [AMD] nee ATI SB700/SB800/SB900 PCI to PCI bridge (PCIE port 1)
> 00:15.2 PCI bridge: Advanced Micro Devices [AMD] nee ATI SB900 PCI to PCI bridge (PCIE port 2)
> 00:15.3 PCI bridge: Advanced Micro Devices [AMD] nee ATI SB900 PCI to PCI bridge (PCIE port 3)
>
> 00:15.0 0604: 1002:43a0
> 00:15.1 0604: 1002:43a1
> 00:15.2 0604: 1002:43a2
> 00:15.3 0604: 1002:43a3
>
>  drivers/pci/quirks.c |   29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
>
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 4ebc865..2c84961 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -3271,11 +3271,40 @@ struct pci_dev *pci_get_dma_source(struct pci_dev *dev)
>         return pci_dev_get(dev);
>  }
>
> +/*
> + * Multifunction devices that do not support peer-to-peer between
> + * functions can claim to support a subset of ACS.  Such devices
> + * effectively enable request redirect (RR) and completion redirect (CR)
> + * since all transactions are redirected to the upstream root complex.
> + */
> +static int pci_mf_no_p2p_acs_enabled(struct pci_dev *dev, u16 acs_flags)
> +{
> +       if (!dev->multifunction)
> +               return -ENODEV;
> +
> +       /* Filter out flags not applicable to multifunction */
> +       acs_flags &= (PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_EC | PCI_ACS_DT);
> +
> +       return acs_flags & ~(PCI_ACS_RR | PCI_ACS_CR) ? 0 : 1;
> +}
> +
>  static const struct pci_dev_acs_enabled {
>         u16 vendor;
>         u16 device;
>         int (*acs_enabled)(struct pci_dev *dev, u16 acs_flags);
>  } pci_dev_acs_enabled[] = {
> +       /*
> +        * AMD/ATI multifunction southbridge devices.  AMD has confirmed
> +        * that peer-to-peer between these devices is not possible, so
> +        * they do support a subset of ACS even though the capability is
> +        * not exposed in config space.
> +        */
> +       { PCI_VENDOR_ID_ATI, 0x4385, pci_mf_no_p2p_acs_enabled },
> +       { PCI_VENDOR_ID_ATI, 0x439c, pci_mf_no_p2p_acs_enabled },
> +       { PCI_VENDOR_ID_ATI, 0x4383, pci_mf_no_p2p_acs_enabled },
> +       { PCI_VENDOR_ID_ATI, 0x439d, pci_mf_no_p2p_acs_enabled },
> +       { PCI_VENDOR_ID_ATI, 0x4384, pci_mf_no_p2p_acs_enabled },
> +       { PCI_VENDOR_ID_ATI, 0x4399, pci_mf_no_p2p_acs_enabled },
>         { 0 }
>  };
>
>

I was looking for something else and found this old email.  This patch
hasn't been applied and I haven't seen any discussion about it.  Is it
still of interest?  It seems relevant to the current ACS discussion
[1].

If it's relevant, what's the topology?  Apparently they don't have a
PCIe capability.  Is the upstream device a PCIe device (a downstream
port or a root port)?  I assume anything downstream from these AMD
devices (0x4385, 0x439c, etc.) is plain PCI (not PCIe)?

Bjorn

[1] https://lkml.kernel.org/r/20130607163441.7733.23221.stgit@bling.home
