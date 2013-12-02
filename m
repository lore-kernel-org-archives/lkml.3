Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab3LBXLp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:11:45 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:47267 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab3LBXLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:11:37 -0500
MIME-Version: 1.0
In-Reply-To: <1385851238-21085-12-git-send-email-yinghai@kernel.org>
References: <1385851238-21085-1-git-send-email-yinghai@kernel.org> <1385851238-21085-12-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 2 Dec 2013 16:11:16 -0700
Message-ID: <CAErSpo7R4nsP7G0DQ+1yzgd-8ZRLJfvzUZk4gno-x2yhhEMqOA@mail.gmail.com>
Subject: Re: [PATCH v3 11/12] PCI: Sort pci root bus resources list
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 30, 2013 at 3:40 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> Some x86 systems expose above 4G 64bit mmio in _CRS as non-pref mmio range.
> [   49.415281] PCI host bridge to bus 0000:00
> [   49.419921] pci_bus 0000:00: root bus resource [bus 00-1e]
> [   49.426107] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> [   49.433041] pci_bus 0000:00: root bus resource [io  0x1000-0x5fff]
> [   49.440010] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> [   49.447768] pci_bus 0000:00: root bus resource [mem 0xfed8c000-0xfedfffff]
> [   49.455532] pci_bus 0000:00: root bus resource [mem 0x90000000-0x9fffbfff]
> [   49.463259] pci_bus 0000:00: root bus resource [mem 0x380000000000-0x381fffffffff]
>
> During assign unassigned 64bit mmio resource, it will go through
> every non-pref mmio for root bus in pci_bus_alloc_resource().
> As the loop is with pci_bus_for_each_resource(), and could have chance
> to use under 4G mmio range instead of above 4G mmio range if the requested
> range is not big enough, even it could handle above 4G 64bit pref mmio.
>
> For root bus, we can order list from high to low in pci_add_resource_offset(),
> during creating root bus, it will still keep the same order in final bus
> resource list.
>         pci_acpi_scan_root
>                 ==> add_resources
>                         ==> pci_add_resource_offset: # Add to temp resources
>                 ==> pci_create_root_bus
>                         ==> pci_bus_add_resource # add to final bus resources.
>
> After that, we can make sure 64bit pref mmio for pci bridges will be allocated
> higest of mmio non-pref, and in this case it is above 4G instead of under 4G.

It really irritates me when I ask a question [1] and you just repost
the patch without even trying to answer it.

[1] http://lkml.kernel.org/r/CAErSpo4r6eJhgmfpth7haKDiKzDB+ZnEq0p_qdfTPo+kqySGgg@mail.gmail.com

> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  drivers/pci/bus.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
> index 82eb234..30993ab 100644
> --- a/drivers/pci/bus.c
> +++ b/drivers/pci/bus.c
> @@ -21,7 +21,8 @@
>  void pci_add_resource_offset(struct list_head *resources, struct resource *res,
>                              resource_size_t offset)
>  {
> -       struct pci_host_bridge_window *window;
> +       struct pci_host_bridge_window *window, *tmp;
> +       struct list_head *n;
>
>         window = kzalloc(sizeof(struct pci_host_bridge_window), GFP_KERNEL);
>         if (!window) {
> @@ -31,7 +32,17 @@ void pci_add_resource_offset(struct list_head *resources, struct resource *res,
>
>         window->res = res;
>         window->offset = offset;
> -       list_add_tail(&window->list, resources);
> +
> +       /* sorted it according to res end */
> +       n = resources;
> +       list_for_each_entry(tmp, resources, list)
> +               if (window->res->end > tmp->res->end) {
> +                       n = &tmp->list;
> +                       break;
> +               }
> +
> +       /* Insert it just before n */
> +       list_add_tail(&window->list, n);
>  }
>  EXPORT_SYMBOL(pci_add_resource_offset);
>
> --
> 1.8.1.4
>
