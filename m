Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102AbaLIVxo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 16:53:44 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:36354 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbaLIVxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 16:53:42 -0500
MIME-Version: 1.0
In-Reply-To: <1418160871-5605-1-git-send-email-yinghai@kernel.org>
References: <1418160871-5605-1-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 9 Dec 2014 14:53:20 -0700
Message-ID: <CAErSpo5tZU=zBKNDt2UtUE_AMG3zzrdq2CX2A4ZL7tdLELXgqA@mail.gmail.com>
Subject: Re: [PATCH] PCI: Clear all bridge res MEM_64 if host bridge has non mem64
To: Yinghai Lu <yinghai@kernel.org>
Cc: Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?UTF-8?Q?Marek_Kord=C3=ADk?= <kordikmarek@gmail.com>,
        Alexey Voronkov <zermond@gmail.com>,
        Wei Yang <weiyang@linux.vnet.ibm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 9, 2014 at 2:34 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> So we could use bridge 64bit mem pref for children mem pref instead of
> forcing them into bridge mem.
>
> Could help Marek's system as his system is using _CRS, and all mem res is under
> 4G.
>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=85491
> Reported-by: Marek Kordik <kordikmarek@gmail.com>
> Fixes: 5b28541552ef ("PCI: Restrict 64-bit prefetchable bridge windows to 64-bit resources")
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>
> ---
>  drivers/pci/host-bridge.c |    7 +++++++
>  drivers/pci/pci.h         |    1 +
>  drivers/pci/probe.c       |    9 +++++++++
>  drivers/pci/setup-bus.c   |    3 +++
>  include/linux/pci.h       |    1 +
>  5 files changed, 21 insertions(+)
>
> Index: linux-2.6/drivers/pci/host-bridge.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/host-bridge.c
> +++ linux-2.6/drivers/pci/host-bridge.c
> @@ -31,6 +31,13 @@ void pci_set_host_bridge_release(struct
>         bridge->release_data = release_data;
>  }
>
> +bool pcibios_host_bridge_has_mem64_res(struct pci_bus *bus)
> +{
> +       struct pci_host_bridge *bridge = find_pci_host_bridge(bus);
> +
> +       return bridge->has_mem64_res;
> +}
> +
>  void pcibios_resource_to_bus(struct pci_bus *bus, struct pci_bus_region *region,
>                              struct resource *res)
>  {
> Index: linux-2.6/drivers/pci/pci.h
> ===================================================================
> --- linux-2.6.orig/drivers/pci/pci.h
> +++ linux-2.6/drivers/pci/pci.h
> @@ -196,6 +196,7 @@ enum pci_bar_type {
>         pci_bar_mem64,          /* A 64-bit memory BAR */
>  };
>
> +bool pcibios_host_bridge_has_mem64_res(struct pci_bus *bus);
>  bool pci_bus_read_dev_vendor_id(struct pci_bus *bus, int devfn, u32 *pl,
>                                 int crs_timeout);
>  int pci_setup_device(struct pci_dev *dev);
> Index: linux-2.6/drivers/pci/probe.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/probe.c
> +++ linux-2.6/drivers/pci/probe.c
> @@ -1980,6 +1980,15 @@ struct pci_bus *pci_create_root_bus(stru
>                 dev_info(&b->dev, "root bus resource %pR%s\n", res, bus_addr);
>         }
>
> +       list_for_each_entry(window, &bridge->windows, list) {
> +               res = window->res;
> +               if (resource_type(res) == IORESOURCE_MEM ||
> +                   res->end > 0xffffffff) {
> +                       bridge->has_mem64_res = true;

This is an interesting idea, but I think you're checking CPU addresses
here, and you need to check PCI bus addresses.

Bjorn
