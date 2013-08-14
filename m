Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933313Ab3HNVWl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 17:22:41 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:36276 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933298Ab3HNVWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 17:22:38 -0400
MIME-Version: 1.0
In-Reply-To: <20130808200943.2932.42781.stgit@bling.home>
References: <20130808200444.2932.17381.stgit@bling.home> <20130808200943.2932.42781.stgit@bling.home>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 14 Aug 2013 15:22:17 -0600
Message-ID: <CAErSpo4rvankxEA-wQ-yGg2MRVtS49dKctEGdn08GVFt8PdjeQ@mail.gmail.com>
Subject: Re: [PATCH v5 4/9] pci: Add slot reset option to pci_dev_reset
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        Don Dutile <ddutile@redhat.com>,
        Takao Indoh <indou.takao@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 8, 2013 at 2:09 PM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> If the hotplug controller provides a way to reset a slot, use that
> before a direct parent bus reset.  Like the bus reset option, this is
> only available when a single pci_dev occupies the slot.
>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/pci/pci.c |   34 ++++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
>
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index d468608..9407aab 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -22,6 +22,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/device.h>
>  #include <linux/pm_runtime.h>
> +#include <linux/pci_hotplug.h>
>  #include <asm-generic/pci-bridge.h>
>  #include <asm/setup.h>
>  #include "pci.h"
> @@ -3256,6 +3257,35 @@ static int pci_parent_bus_reset(struct pci_dev *dev, int probe)
>         return 0;
>  }
>
> +static int pci_reset_hotplug_slot(struct hotplug_slot *hotplug, int probe)
> +{
> +       int rc = -ENOTTY;
> +
> +       if (!hotplug || !try_module_get(hotplug->ops->owner))
> +               return rc;
> +
> +       if (hotplug->ops->reset_slot)
> +               rc = hotplug->ops->reset_slot(hotplug, probe);
> +
> +       module_put(hotplug->ops->owner);
> +
> +       return rc;
> +}
> +
> +static int pci_dev_reset_slot_function(struct pci_dev *dev, int probe)
> +{
> +       struct pci_dev *pdev;
> +
> +       if (dev->subordinate || !dev->slot)
> +               return -ENOTTY;
> +
> +       list_for_each_entry(pdev, &dev->bus->devices, bus_list)
> +               if (pdev != dev && pdev->slot == dev->slot)
> +                       return -ENOTTY;
> +
> +       return pci_reset_hotplug_slot(dev->slot->hotplug, probe);

I don't think this is hotplug-safe.  It looks like pci_bus_sem might
be the right semaphore to hold while verifying that we won't reset any
unintended devices.  But I think most users of the bus->devices list
are unprotected, so there's no point in trying to fix just this one.

> +}
> +
>  static int __pci_dev_reset(struct pci_dev *dev, int probe)
>  {
>         int rc;
> @@ -3278,6 +3308,10 @@ static int __pci_dev_reset(struct pci_dev *dev, int probe)
>         if (rc != -ENOTTY)
>                 goto done;
>
> +       rc = pci_dev_reset_slot_function(dev, probe);
> +       if (rc != -ENOTTY)
> +               goto done;
> +
>         rc = pci_parent_bus_reset(dev, probe);
>  done:
>         return rc;
>
