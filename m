Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069Ab3DAUng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 16:43:36 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:49597 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757705Ab3DAUne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 16:43:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Zheng Yan <zheng.z.yan@intel.com>
Subject: Re: [Update][PATCH] PCI / PM: Disable runtime PM of PCIe ports
Date: Mon, 01 Apr 2013 22:51:08 +0200
Message-ID: <3943547.m5K1tfygWn@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAErSpo7kGBNEkLOftJ1J7ivaxZL-yVWyAwmoiQ1=NADpmJ67XA@mail.gmail.com>
References: <2282655.IicBMMa6jN@vostro.rjw.lan> <1378320.ernsY1JWPv@vostro.rjw.lan> <CAErSpo7kGBNEkLOftJ1J7ivaxZL-yVWyAwmoiQ1=NADpmJ67XA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 01, 2013 11:34:46 AM Bjorn Helgaas wrote:
> [+cc Zheng, who added this with 71a83bd727]
> 
> On Sat, Mar 30, 2013 at 4:38 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >
> > The runtime PM of PCIe ports turns out to be quite fragile, as in
> > some cases things work while in some other cases they don't and we
> > don't seem to have a good way to determine whether or not they are
> > going to work in advance.
> 
> Do you have any references to problems encountered when enabling
> runtime PM for PCIe ports?  That information will be useful to anybody
> who wants to take another crack at getting this working.

Well, bug 53811 is one example and problems recently reported by
Martin are another.  Do you want me to dig deeper?

Rafael


> > For this reason, avoid enabling runtime PM for PCIe ports by
> > keeping their runtime PM reference counters always above 0 for the
> > time being.
> >
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > ---
> >
> > This version also removes the no longer necessary (and empty anyway)
> > port_runtime_pm_black_list[] table.
> >
> > Thanks,
> > Rafael
> >
> > ---
> >  drivers/pci/pcie/portdrv_pci.c |   13 -------------
> >  1 file changed, 13 deletions(-)
> >
> > Index: linux-pm/drivers/pci/pcie/portdrv_pci.c
> > ===================================================================
> > --- linux-pm.orig/drivers/pci/pcie/portdrv_pci.c
> > +++ linux-pm/drivers/pci/pcie/portdrv_pci.c
> > @@ -185,14 +185,6 @@ static const struct dev_pm_ops pcie_port
> >  #endif /* !PM */
> >
> >  /*
> > - * PCIe port runtime suspend is broken for some chipsets, so use a
> > - * black list to disable runtime PM for these chipsets.
> > - */
> > -static const struct pci_device_id port_runtime_pm_black_list[] = {
> > -       { /* end: all zeroes */ }
> > -};
> > -
> > -/*
> >   * pcie_portdrv_probe - Probe PCI-Express port devices
> >   * @dev: PCI-Express port device being probed
> >   *
> > @@ -225,16 +217,11 @@ static int pcie_portdrv_probe(struct pci
> >          * it by default.
> >          */
> >         dev->d3cold_allowed = false;
> > -       if (!pci_match_id(port_runtime_pm_black_list, dev))
> > -               pm_runtime_put_noidle(&dev->dev);
> > -
> >         return 0;
> >  }
> >
> >  static void pcie_portdrv_remove(struct pci_dev *dev)
> >  {
> > -       if (!pci_match_id(port_runtime_pm_black_list, dev))
> > -               pm_runtime_get_noresume(&dev->dev);
> >         pcie_port_device_remove(dev);
> >         pci_disable_device(dev);
> >  }
> >
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
