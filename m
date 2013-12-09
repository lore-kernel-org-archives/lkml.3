Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761437Ab3LIRyo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 12:54:44 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:58976 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755891Ab3LIRyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 12:54:41 -0500
MIME-Version: 1.0
In-Reply-To: <1386546869-31900-3-git-send-email-yinghai@kernel.org>
References: <1386546869-31900-1-git-send-email-yinghai@kernel.org> <1386546869-31900-3-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 9 Dec 2013 10:54:20 -0700
Message-ID: <CAErSpo6VvV21DyHuHLcsA+_KPQcYdAWXtaVbZGUA-M9+iji0fw@mail.gmail.com>
Subject: Re: [PATCH 2/2] PCI: Only enable realloc auto when root bus has 64bit mmio
To: Yinghai Lu <yinghai@kernel.org>
Cc: Joseph Salisbury <joseph.salisbury@canonical.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 8, 2013 at 4:54 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> Joseph found
> | commit b07f2ebc109b607789f648dedcff4b125f9afec6
> | Date:   Thu Feb 23 19:23:32 2012 -0800
> |
> |    PCI: add a PCI resource reallocation config option
>
> cause one system can not load driver for Intel x520 NIC's.
>
> The root resource:
> [    1.212470] PCI host bridge to bus 0000:20
> [    1.212475] pci_bus 0000:20: root bus resource [bus 20-3e]
> [    1.212479] pci_bus 0000:20: root bus resource [io  0xc000-0xdfff]
> [    1.212483] pci_bus 0000:20: root bus resource [mem 0xfecc0000-0xfecfffff]
> [    1.212487] pci_bus 0000:20: root bus resource [mem 0xe9400000-0xe97fffff]
>
> and bios does not assign sriov, also have two function ROM bar point to same
> position.
> [    1.213197] pci 0000:22:00.0: [8086:10fb] type 00 class 0x020000
> ...
> [    1.213240] pci 0000:22:00.0: reg 0x30: [mem 0xe9500000-0xe957ffff pref]
> [    1.213303] pci 0000:22:00.0: reg 0x184: [mem 0x00000000-0x00003fff 64bit]
> [    1.213317] pci 0000:22:00.0: reg 0x190: [mem 0x00000000-0x00003fff 64bit]
> [    1.213366] pci 0000:22:00.1: [8086:10fb] type 00 class 0x020000
> ...
> [    1.213408] pci 0000:22:00.1: reg 0x30: [mem 0xe9500000-0xe957ffff pref]
> [    1.213468] pci 0000:22:00.1: reg 0x184: [mem 0x00000000-0x00003fff 64bit]
> [    1.213481] pci 0000:22:00.1: reg 0x190: [mem 0x00000000-0x00003fff 64bit]
> [    1.218527] pci 0000:20:03.0: PCI bridge to [bus 22]
> [    1.218534] pci 0000:20:03.0:   bridge window [io  0xd000-0xdfff]
> [    1.218537] pci 0000:20:03.0:   bridge window [mem 0xe9400000-0xe95fffff]
> ...
> [    1.254103] pci 0000:22:00.1: address space collision: [mem 0xe9500000-0xe957ffff pref] conflicts with 0000:22:00.0 [mem 0xe9500000-0xe957ffff pref]
> [    1.254111] pci 0000:23:00.1: address space collision: [mem 0xe9700000-0xe977ffff pref] conflicts with 0000:23:00.0 [mem 0xe9700000-0xe977ffff pref]
>
> We don't need to enable realloc for this case, as we can not alter root bus mmio
> range to get big one to hold two rom bar, and sriov under 4G.
>
> Add checking if pci root bus have 4G above mmio res, and don't enable
> realloc auto accordingly.
>
> bug report at: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1245938
>
> Reported-by: Joseph Salisbury <joseph.salisbury@canonical.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: stable@vger.kernel.org
> ---
>  drivers/pci/setup-bus.c | 32 +++++++++++++++++++++++++++-----
>  1 file changed, 27 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> index 219a410..f9e6efb 100644
> --- a/drivers/pci/setup-bus.c
> +++ b/drivers/pci/setup-bus.c
> @@ -1432,17 +1432,39 @@ static int iov_resources_unassigned(struct pci_dev *dev, void *data)
>         return 0;
>  }
>
> +static bool pci_bus_mem_above_4g(struct pci_bus *bus)
> +{
> +       int i;
> +       struct resource *res;
> +
> +       pci_bus_for_each_resource(bus, res, i) {
> +               struct pci_bus_region region;
> +
> +               if (!res || !(res->flags & IORESOURCE_MEM))
> +                       continue;
> +
> +               __pcibios_resource_to_bus(bus, &region, res);
> +               if (region.end > 0xffffffff)
> +                       return true;
> +       }
> +
> +       return false;
> +}
> +
>  static enum enable_type pci_realloc_detect(struct pci_bus *bus,
>                          enum enable_type enable_local)
>  {
> -       bool unassigned = false;
> -
>         if (enable_local != undefined)
>                 return enable_local;
>
> -       pci_walk_bus(bus, iov_resources_unassigned, &unassigned);
> -       if (unassigned)
> -               return auto_enabled;
> +       /* only enable auto when root bus does support 64bit mmio */
> +       if (pci_bus_mem_above_4g(bus)) {
> +               bool unassigned = false;
> +
> +               pci_walk_bus(bus, iov_resources_unassigned, &unassigned);
> +               if (unassigned)
> +                       return auto_enabled;

I don't see how the question of whether the host bridge has an
aperture above 4G is related to whether we should automatically
reassign resources.  They seem orthogonal to me.  No doubt it "fixes"
the current problem, but it doesn't make sense conceptually.

Bjorn

> +       }
>
>         return enable_local;
>  }
> --
> 1.8.4
>
