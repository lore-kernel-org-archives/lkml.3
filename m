Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933674Ab3CHGve (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 01:51:34 -0500
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:46651 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753117Ab3CHGvd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 01:51:33 -0500
From: Xiangliang Yu <yuxiangl@marvell.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: yxlraid <yxlraid@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 7 Mar 2013 22:51:26 -0800
Subject: RE: [PATCH 2/2] PCI: fix system hang issue of Marvell SATA host
 controller
Thread-Topic: [PATCH 2/2] PCI: fix system hang issue of Marvell SATA host
 controller
Thread-Index: Ac4btDSYBvrcPfIaRy263BXYJlk5RQAEIE6Q
Message-ID: <F766E4F80769BD478052FB6533FA745D25F436861C@SC-VEXCH4.marvell.com>
References: <1362666556-10036-1-git-send-email-yxlraid@gmail.com>
 <CAErSpo7feQK7pXD=moA_hf=Y-j82oZZKwfDNzfo2Ea7i9VPxtA@mail.gmail.com>
 <F766E4F80769BD478052FB6533FA745D25F436856A@SC-VEXCH4.marvell.com>
 <CAErSpo6RDC+QyyN4kwt7-kU5d8b1iu+zCQZTGZPxCJU2UicTCA@mail.gmail.com>
In-Reply-To: <CAErSpo6RDC+QyyN4kwt7-kU5d8b1iu+zCQZTGZPxCJU2UicTCA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Bjorn

> >> > Fix system hang issue: if first accessed resource file of BAR0 ~
> >> > BAR4, system will hang after executing lspci command
> >>
> >> This needs more explanation.  We've already read the BARs by the time
> >> header quirks are run, so apparently it's not just the mere act of
> >> accessing a BAR that causes a hang.
> >>
> >> We need to know exactly what's going on here.  For example, do BARs
> >> 0-4 exist?  Does the device decode accesses to the regions described
> >> by the BARs?  The PCI core has to know what resources the device uses,
> >> so if the device decodes accesses, we can't just throw away the
> >> start/end information.
> > The BARs 0-4 is exist and the PCI device is enable IO space, but user access
> the regions file by udevadm command with info parameter, the system will hang.
> > Like this: udevadmin info --attribut-walk
> --path=/sys/device/pci-device/000:*.
> > Because the device is just AHCI host controller, don't need the BAR0 ~ 4 region
> file.
> > Is my explanation ok for the patch?
> 
> No, I still don't know what causes the hang; I only know that udevadm
> can trigger it.  I don't want to just paper over the problem until we
> know what the root cause is.
> 
> Does "lspci -H1 -vv" also cause a hang?  What about "setpci -s<dev>
> BASE_ADDRESS_0"?  "setpci -H1 -s<dev> BASE_ADDRESS_0"?
The commands are ok because the commands can't find the device after accessing IO port.
The root cause is that accessing of IO port will make the chip go bad. So, the point of the patch is don't export capability of the IO accessing.

> 
> >>
> >> > ---
> >> >  drivers/pci/quirks.c |   15 +++++++++++++++
> >> >  1 files changed, 15 insertions(+), 0 deletions(-)
> >> >
> >> > diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> >> > index 0369fb6..d49f8dc 100644
> >> > --- a/drivers/pci/quirks.c
> >> > +++ b/drivers/pci/quirks.c
> >> > @@ -44,6 +44,21 @@ static void quirk_mmio_always_on(struct pci_dev *dev)
> >> >  DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_ANY_ID, PCI_ANY_ID,
> >> >                                 PCI_CLASS_BRIDGE_HOST, 8,
> >> quirk_mmio_always_on);
> >> >
> >> > +/* The BAR0 ~ BAR4 of Marvell 9125 device can't be accessed
> >> > +*  by IO resource file, and need to skip the files
> >> > +*/
> >> > +static void quirk_marvell_mask_bar(struct pci_dev *dev)
> >> > +{
> >> > +       int i;
> >> > +
> >> > +       for (i = 0; i < 5; i++)
> >> > +               if (dev->resource[i].start)
> >> > +                       dev->resource[i].start =
> >> > +                               dev->resource[i].end = 0;
> >> > +}
> >> > +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MARVELL_EXT, 0x9125,
> >> > +                               quirk_marvell_mask_bar);
> >> > +
> >> >  /* The Mellanox Tavor device gives false positive parity errors
> >> >   * Mark this device with a broken_parity_status, to allow
> >> >   * PCI scanning code to "skip" this now blacklisted device.
> >> > --
> >> > 1.7.5.4
> >> >
