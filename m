Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442AbaAIAYY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 19:24:24 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:59285 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756882AbaAIAYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 19:24:22 -0500
MIME-Version: 1.0
In-Reply-To: <CA+2TWzXvZrVZDJA-KkuUVuCP8kwX3GENL_rTf=_dZ_HBqJUArw@mail.gmail.com>
References: <CA+2TWzXvZrVZDJA-KkuUVuCP8kwX3GENL_rTf=_dZ_HBqJUArw@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 8 Jan 2014 17:24:01 -0700
Message-ID: <CAErSpo4BpCYQ1q8ogqAtn7pbCXkKHM4M4DCffF9m+Gd4tjit1w@mail.gmail.com>
Subject: Re: [PATCH] PCI: Allocate prefetch mmio resource first when possible
To: threeTigers Lin <threeflytigers@gmail.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>, Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Yinghai]

On Wed, Jan 8, 2014 at 11:17 AM, threeTigers Lin
<threeflytigers@gmail.com> wrote:
> From f7a37ed1c61b5939ccef810e28b25ecf3bfa9077 Mon Sep 17 00:00:00 2001
> From: linmuhui <linmuhui@huawei.com>
> Date: Thu, 9 Jan 2014 01:03:12 +0800
> Subject: [PATCH] PCI: Allocate prefetch mmio resource first when possible

This patch is not in the standard format and does not apply cleanly.
See Documentation/SubmittingPatches.

> Hi Bjorn,
>
> PCI bus resources will be set up at pci_bridge_check_ranges() or
> pci_read_bridge_bases(). In both cases, we can find that the PCI bus'
> non-pref mmio will be assigned to bus->resource[1] and pref mmio will be
> assigned to bus->resource[2]. So, in the scenario that we need to allocate
> pref resources from PCI bus such as hotplug operation, the bus' non-pref
> mmio will be quickly eaten up first if we try to allocate bus resources in
> the order from bus->resource[0] to bus->resource[PCI_BRIDGE_RESOURCE_NUM -
> 1] in the function pci_bus_alloc_resource(), even though there is enough
> pref mmio resource of the bus. This may lead to the later requester who want
> to allocate non-pref mmio cannot allocate the resource from the bus. So, I
> think the order of allocating PCI bus resources in function
> pci_bus_alloc_resource() should be changed to try pref mmio first when
> possible.

Don't we do this already?  The code in __pci_assign_resource() looks
like it should prefer an exact prefetching match.

If that code doesn't work, we should fix it there.  I don't want to
fiddle with pci_bus_for_each_resource() for this -- that's a really
arcane place to hide such a fix.

Bjorn

> Signed-off-by: Lin Muhui <linmuhui@huawei.com>
> ---
>  include/linux/pci.h |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 1084a15..238df8f 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1064,7 +1064,8 @@ void pci_bus_remove_resources(struct pci_bus *bus);
>
>  #define pci_bus_for_each_resource(bus, res, i)                         \
>         for (i = 0;                                                     \
> -           (res = pci_bus_resource_n(bus, i)) || i <
> PCI_BRIDGE_RESOURCE_NUM; \
> +           (res = pci_bus_resource_n(bus, (i < PCI_BRIDGE_RESOURCE_NUM ?
> (PCI_BRIDGE_RESOURCE_NUM - 1 - i) : i)))\
> +                                        || i < PCI_BRIDGE_RESOURCE_NUM; \
>              i++)
>
>  int __must_check pci_bus_alloc_resource(struct pci_bus *bus,
> --
> 1.7.1
>
