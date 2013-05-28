Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab3E1EWc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 00:22:32 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:53921 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab3E1EWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 00:22:30 -0400
MIME-Version: 1.0
In-Reply-To: <1369583597-3801-2-git-send-email-jiang.liu@huawei.com>
References: <1369583597-3801-1-git-send-email-jiang.liu@huawei.com>
	<1369583597-3801-2-git-send-email-jiang.liu@huawei.com>
Date: Mon, 27 May 2013 21:22:29 -0700
X-Google-Sender-Auth: iJxHaLDkTi_cT4Tygkj-6QzovF0
Message-ID: <CAE9FiQUBQRrkiub_EGZ1TZ-iccLts7hDff3kOz70uq=McjpoGg@mail.gmail.com>
Subject: Re: [PATCH v3, part2 01/20] PCI: introduce hotplug-safe PCI bus iterators
From: Yinghai Lu <yinghai@kernel.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 26, 2013 at 8:52 AM, Jiang Liu <liuj97@gmail.com> wrote:
> Introduce hotplug-safe PCI bus iterators as below, which hold a
> reference on the returned PCI bus object.
> bool pci_bus_exists(int domain, int busnr);
> struct pci_bus *pci_get_bus(int domain, int busnr);
> struct pci_bus *pci_get_next_bus(struct pci_bus *from);
> struct pci_bus *pci_get_next_root_bus(struct pci_bus *from);
> #define for_each_pci_bus(b) for (b = NULL; (b = pci_get_next_bus(b)); )
> #define for_each_pci_root_bus(b)  \
>                 for (b = NULL; (b = pci_get_next_root_bus(b)); )
>
> The long-term goal is to remove hotplug-unsafe pci_find_bus(),
> pci_find_next_bus() and the global pci_root_buses list.
>
> These new interfaces may be a littler slower than existing interfaces,
> but it should be acceptable because they are not used on hot paths.

looks like go over all buses to find out several root buses is not good.


>
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Acked-by: Yinghai Lu <yinghai@kernel.org>

I take that back.

> Cc: linux-pci@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/pci/pci.h    |   1 +
>  drivers/pci/probe.c  |   2 +-
>  drivers/pci/search.c | 159 +++++++++++++++++++++++++++++++++++++++++----------
>  include/linux/pci.h  |  23 +++++++-
>  4 files changed, 153 insertions(+), 32 deletions(-)
>
> diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
> index 68678ed..8fe15f6 100644
> --- a/drivers/pci/pci.h
> +++ b/drivers/pci/pci.h
> @@ -126,6 +126,7 @@ static inline void pci_remove_legacy_files(struct pci_bus *bus) { return; }
>
>  /* Lock for read/write access to pci device and bus lists */
>  extern struct rw_semaphore pci_bus_sem;
> +extern struct class pcibus_class;
>
>  extern raw_spinlock_t pci_lock;
>
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 2830070..1004a05 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -93,7 +93,7 @@ static void release_pcibus_dev(struct device *dev)
>         kfree(pci_bus);
>  }
>
> -static struct class pcibus_class = {
> +struct class pcibus_class = {
>         .name           = "pci_bus",
>         .dev_release    = &release_pcibus_dev,
>         .dev_attrs      = pcibus_dev_attrs,
...
> +static int pci_match_next_root_bus(struct device *dev, const void *data)
> +{
> +       return pci_is_root_bus(to_pci_bus(dev));
>  }
...
> +
> +/**
> + * pci_find_next_root_bus - begin or continue searching for a PCI root bus
> + * @from: Previous PCI bus found, or %NULL for new search.
> + *
> + * Iterates through the list of known PCI root busses. If a PCI bus is found,
> + * the reference count to the root bus is incremented and a pointer to it is
> + * returned. Otherwise, %NULL is returned. A new search is initiated by
> + * passing %NULL as the @from argument. Otherwise if @from is not %NULL,
> + * searches continue from next root bus on the global list. The reference
> + * count for @from is always decremented if it is not %NULL.
> + */
> +struct pci_bus *pci_get_next_root_bus(struct pci_bus *from)
> +{
> +       struct device *dev = from ? &from->dev : NULL;
> +
> +       WARN_ON(in_interrupt());
> +       dev = class_find_device(&pcibus_class, dev, NULL,
> +                               &pci_match_next_root_bus);
> +       pci_bus_put(from);
> +       if (dev)
> +               return to_pci_bus(dev);
> +
> +       return NULL;
>  }
> +EXPORT_SYMBOL(pci_get_next_root_bus);

this patchset is most doing same thing like my for_each_host_bridge patchset.
that patchset add bus_type for host_bridge and loop with each_...bus
to find host_bridge
and to its bus.

looks like for each host bridge should be right direction.

also late we could add per host bridge lock instead of whole pci bus sem etc.

Thanks

Yinghai
