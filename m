Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478Ab3FEUFB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 16:05:01 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:54524 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757286Ab3FEUE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 16:04:59 -0400
MIME-Version: 1.0
In-Reply-To: <1369489718-25869-5-git-send-email-jiang.liu@huawei.com>
References: <1369489718-25869-1-git-send-email-jiang.liu@huawei.com> <1369489718-25869-5-git-send-email-jiang.liu@huawei.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 5 Jun 2013 14:04:36 -0600
Message-ID: <CAErSpo5bysp-s-twUWgZEyJD01skjW=vXkcQBYkn_TALP83r1g@mail.gmail.com>
Subject: Re: [PATCH v3, part1 04/10] PCI: mark pci_scan_bus_parented() as __deprecated
To: Jiang Liu <liuj97@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Jiang Liu <jiang.liu@huawei.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        xen-devel <xen-devel@lists.xensource.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Konrad, Jeremy, xen-devel (users of interface you're deprecating)]

On Sat, May 25, 2013 at 7:48 AM, Jiang Liu <liuj97@gmail.com> wrote:
> Mark pci_scan_bus_parented() as __deprecated and clean up outdated
> comments.
>
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Thierry Reding <thierry.reding@avionic-design.de>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> ---
>  arch/tile/kernel/pci.c | 3 ---
>  include/linux/pci.h    | 4 ++--
>  2 files changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/arch/tile/kernel/pci.c b/arch/tile/kernel/pci.c
> index 67237d3..936e087 100644
> --- a/arch/tile/kernel/pci.c
> +++ b/arch/tile/kernel/pci.c
> @@ -309,9 +309,6 @@ int __init pcibios_init(void)
>                          *
>                          * It reads the PCI tree for this bus into the Linux
>                          * data structures.
> -                        *
> -                        * This is inlined in linux/pci.h and calls into
> -                        * pci_scan_bus_parented() in probe.c.
>                          */
>                         pci_add_resource(&resources, &ioport_resource);
>                         pci_add_resource(&resources, &iomem_resource);
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index b0f4a82..7b23fa0 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -720,8 +720,8 @@ void pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
>  void pcibios_scan_specific_bus(int busn);
>  struct pci_bus *pci_find_bus(int domain, int busnr);
>  void pci_bus_add_devices(const struct pci_bus *bus);
> -struct pci_bus *pci_scan_bus_parented(struct device *parent, int bus,
> -                                     struct pci_ops *ops, void *sysdata);
> +struct pci_bus * __deprecated pci_scan_bus_parented(struct device *parent,
> +                       int bus, struct pci_ops *ops, void *sysdata);
>  struct pci_bus *pci_scan_bus(int bus, struct pci_ops *ops, void *sysdata);
>  struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
>                                     struct pci_ops *ops, void *sysdata,

I think this patch is a good idea, but I think we need to change the
only existing user of pci_scan_bus_parented() (pcifront_scan_root() in
drivers/pci/xen-pcifront.c) at the same time, so xen doesn't start
getting build warnings.  The deprecation warnings are really intended
for out-of-tree users that we aren't able to fix ourselves.

I'm getting this series queued up in
http://git.kernel.org/cgit/linux/kernel/git/helgaas/pci.git/log/?h=pci/jiang-bus-lock-v3,
so if you want to send a patch just for xen, I can fold that in.

Bjorn
