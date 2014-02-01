Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932552AbaBAB4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 20:56:33 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:39685 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220AbaBAB4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 20:56:31 -0500
MIME-Version: 1.0
In-Reply-To: <1676758.QjUXk2223P@vostro.rjw.lan>
References: <20140130131236.GW18029@intel.com>
	<1676758.QjUXk2223P@vostro.rjw.lan>
Date: Fri, 31 Jan 2014 17:56:30 -0800
X-Google-Sender-Auth: 0p3GJm1qUT5jYXEZOjMWwm2pLfY
Message-ID: <CAE9FiQX_AuSPq159AwDHP+n0k6FK3pS2CNttPFAJP2K-84ho1w@mail.gmail.com>
Subject: Re: [PATCH] Revert "PCI: Remove from bus_list and release resources
 in pci_release_dev()"
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 31, 2014 at 3:34 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> Revert commit ef83b0781a73 "PCI: Remove from bus_list and release
> resources in pci_release_dev()" that made some nasty race conditions
> become possible.  For example, if a Thunderbolt link is unplugged
> and then replugged immediately, the pci_release_dev() resulting from
> the hot-remove code path may be racing with the hot-add code path
> which after that commit causes various kinds of breakage to happen
> (up to and including a hard crash of the whole system).
>
> Moreover, the problem that commit ef83b0781a73 attempted to address
> cannot happen any more after commit 8a4c5c329de7 "PCI: Check parent
> kobject in pci_destroy_dev()", because pci_destroy_dev() will now
> return immediately if it has already been executed for the given
> device.
>
> Fixes: ef83b0781a73 (PCI: Remove from bus_list and release resources in pci_release_dev())
> Reported-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 04796c056d12..6e34498ec9f0 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1208,18 +1208,6 @@ static void pci_release_capabilities(struct pci_dev *dev)
>         pci_free_cap_save_buffers(dev);
>  }
>
> -static void pci_free_resources(struct pci_dev *dev)
> -{
> -       int i;
> -
> -       pci_cleanup_rom(dev);
> -       for (i = 0; i < PCI_NUM_RESOURCES; i++) {
> -               struct resource *res = dev->resource + i;
> -               if (res->parent)
> -                       release_resource(res);
> -       }
> -}
> -
>  /**
>   * pci_release_dev - free a pci device structure when all users of it are finished.
>   * @dev: device that's been disconnected
> @@ -1229,14 +1217,9 @@ static void pci_free_resources(struct pci_dev *dev)
>   */
>  static void pci_release_dev(struct device *dev)
>  {
> -       struct pci_dev *pci_dev = to_pci_dev(dev);
> -
> -       down_write(&pci_bus_sem);
> -       list_del(&pci_dev->bus_list);
> -       up_write(&pci_bus_sem);
> -
> -       pci_free_resources(pci_dev);
> +       struct pci_dev *pci_dev;
>
> +       pci_dev = to_pci_dev(dev);
>         pci_release_capabilities(pci_dev);
>         pci_release_of_node(pci_dev);
>         pcibios_release_device(pci_dev);
> diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
> index 4ff36bfa785e..b8c93c90daf5 100644
> --- a/drivers/pci/remove.c
> +++ b/drivers/pci/remove.c
> @@ -3,6 +3,20 @@
>  #include <linux/pci-aspm.h>
>  #include "pci.h"
>
> +static void pci_free_resources(struct pci_dev *dev)
> +{
> +       int i;
> +
> +       msi_remove_pci_irq_vectors(dev);

looks like you are in a rush. Why do you put back msi_remove_pci_irq_vectors?

> +
> +       pci_cleanup_rom(dev);
> +       for (i = 0; i < PCI_NUM_RESOURCES; i++) {
> +               struct resource *res = dev->resource + i;
> +               if (res->parent)
> +                       release_resource(res);
> +       }
> +}
> +
>  static void pci_stop_dev(struct pci_dev *dev)
>  {
>         pci_pme_active(dev, false);
> @@ -25,6 +39,11 @@ static void pci_destroy_dev(struct pci_dev *dev)
>
>         device_del(&dev->dev);
>
> +       down_write(&pci_bus_sem);
> +       list_del(&dev->bus_list);
> +       up_write(&pci_bus_sem);
> +
> +       pci_free_resources(dev);
>         put_device(&dev->dev);
>  }
>
>
