Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610Ab3DARfK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 13:35:10 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:38248 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757321Ab3DARfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 13:35:08 -0400
MIME-Version: 1.0
In-Reply-To: <1378320.ernsY1JWPv@vostro.rjw.lan>
References: <2282655.IicBMMa6jN@vostro.rjw.lan> <51548C9E.9090703@fold.natur.cuni.cz>
 <2990024.LMTIBUbM3d@vostro.rjw.lan> <1378320.ernsY1JWPv@vostro.rjw.lan>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 1 Apr 2013 11:34:46 -0600
Message-ID: <CAErSpo7kGBNEkLOftJ1J7ivaxZL-yVWyAwmoiQ1=NADpmJ67XA@mail.gmail.com>
Subject: Re: [Update][PATCH] PCI / PM: Disable runtime PM of PCIe ports
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Zheng Yan <zheng.z.yan@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Zheng, who added this with 71a83bd727]

On Sat, Mar 30, 2013 at 4:38 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> The runtime PM of PCIe ports turns out to be quite fragile, as in
> some cases things work while in some other cases they don't and we
> don't seem to have a good way to determine whether or not they are
> going to work in advance.

Do you have any references to problems encountered when enabling
runtime PM for PCIe ports?  That information will be useful to anybody
who wants to take another crack at getting this working.

> For this reason, avoid enabling runtime PM for PCIe ports by
> keeping their runtime PM reference counters always above 0 for the
> time being.
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>
> This version also removes the no longer necessary (and empty anyway)
> port_runtime_pm_black_list[] table.
>
> Thanks,
> Rafael
>
> ---
>  drivers/pci/pcie/portdrv_pci.c |   13 -------------
>  1 file changed, 13 deletions(-)
>
> Index: linux-pm/drivers/pci/pcie/portdrv_pci.c
> ===================================================================
> --- linux-pm.orig/drivers/pci/pcie/portdrv_pci.c
> +++ linux-pm/drivers/pci/pcie/portdrv_pci.c
> @@ -185,14 +185,6 @@ static const struct dev_pm_ops pcie_port
>  #endif /* !PM */
>
>  /*
> - * PCIe port runtime suspend is broken for some chipsets, so use a
> - * black list to disable runtime PM for these chipsets.
> - */
> -static const struct pci_device_id port_runtime_pm_black_list[] = {
> -       { /* end: all zeroes */ }
> -};
> -
> -/*
>   * pcie_portdrv_probe - Probe PCI-Express port devices
>   * @dev: PCI-Express port device being probed
>   *
> @@ -225,16 +217,11 @@ static int pcie_portdrv_probe(struct pci
>          * it by default.
>          */
>         dev->d3cold_allowed = false;
> -       if (!pci_match_id(port_runtime_pm_black_list, dev))
> -               pm_runtime_put_noidle(&dev->dev);
> -
>         return 0;
>  }
>
>  static void pcie_portdrv_remove(struct pci_dev *dev)
>  {
> -       if (!pci_match_id(port_runtime_pm_black_list, dev))
> -               pm_runtime_get_noresume(&dev->dev);
>         pcie_port_device_remove(dev);
>         pci_disable_device(dev);
>  }
>
