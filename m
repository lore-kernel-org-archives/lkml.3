Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab3GIW2G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 18:28:06 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:52110 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab3GIW2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 18:28:03 -0400
MIME-Version: 1.0
In-Reply-To: <1373356564-21668-1-git-send-email-wangyijing@huawei.com>
References: <1373356564-21668-1-git-send-email-wangyijing@huawei.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 9 Jul 2013 16:27:42 -0600
Message-ID: <CAErSpo51x7Q6cFnJ-8RfmikDh3FtCWyjy9tYouH=sjkXdNPo7Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] PCI,pciehp: avoid add a device already exist during pciehp_resume
To: Yijing Wang <wangyijing@huawei.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Rafael <rjw@sisk.pl>, Hanjun Guo <guohanjun@huawei.com>,
        Jiang Liu <jiang.liu@huawei.com>, Paul Bolle <pebolle@tiscali.nl>,
        Oliver Neukum <oneukum@suse.de>, Gu Zheng <guz.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 9, 2013 at 1:56 AM, Yijing Wang <wangyijing@huawei.com> wrote:
> Currently, pciehp_resume will call pciehp_enable_slot() to add
> device if there is a device in the slot. But if the device was
> present before suspend, it's no necessary to add again. Now in
> such case, there is some uncomfortable message like
>
>     pciehp 0000:00:1c.1:pcie04: Device 0000:03:00.0 already exists at 0000:03:00, cannot hot-add
>         pciehp 0000:00:1c.1:pcie04: Cannot add device at 0000:03:00
>
> This problem was reported by Paul Bolle <pebolle@tiscali.nl>
> The discussion link: http://comments.gmane.org/gmane.linux.kernel.pci/19876
>
> We can use PCIe Device Serial Number to identify the device if
> device support DSN.

I think I like the idea of this, especially because the Microsoft PCI
Hardware Compliance Test apparently requires DSN for hot-pluggable
PCIe devices [1], so it should be pretty universal.

[1] http://www.techtalkz.com/microsoft-device-drivers-dtm/341362-dtm-pcihct-test-violates-pci-express-base-specification-revision-1-a.html

> currently:
> 1. slot is empty before suspend, insert card during suspend.
>         In this case, is safe, pciehp will add device by check adapter
> status register in pciehp_resume.

Your patch doesn't change anything here.

> 2. slot is non empty before suspend, remove card during suspend.
>         Also be safe, pciehp will remove device by check adapter
> status register in pciehp_resume.

Your patch doesn't change anything here.  (But I think the driver
.remove() method will try to poke at the non-existent device; see
below.)

> 3. slot is non empty before suspend, remove card during suspend
> and insert a new card.
>         Now pciehp just call pciehp_enable_slot() roughly. We should
> remove the old card firstly, then add the new card.

With your patch, I think we'll call the old driver's .remove() method
on the new device.  This seems bad; see below.

With your patch, if we remove and reinsert the same device while
suspended, we do nothing because the DSN didn't change.  Previously we
called pciehp_enable_slot().  I don't know if we need to do anything
here or not.

> 4. slot is non empty before suspend, no action during suspend.
>         We should do nothing in pciehp_resume, but we call
> pciehp_enable_slot(), so some uncomfortable messages show like above.
> In this case, we can improve it a little by add a guard
> if (!list_empty(bus->devices)).

This is the common case.  Previously we called pciehp_enable_slot(),
and with your patch we do nothing.  I think that seems sensible, but
this part should be split into a separate patch.  That way we can keep
the benefit of this change even if we trip over something with the
other changes.

> Reported-by: Paul Bolle <pebolle@tiscali.nl>
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> Cc: Paul Bolle <pebolle@tiscali.nl>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: Oliver Neukum <oneukum@suse.de>
> Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>
> Cc: linux-pci@vger.kernel.org
> ---
>  drivers/pci/hotplug/pciehp_core.c |   38 +++++++++++++++++++++++++++++++++---
>  1 files changed, 34 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
> index 7d72c5e..d01e093 100644
> --- a/drivers/pci/hotplug/pciehp_core.c
> +++ b/drivers/pci/hotplug/pciehp_core.c
> @@ -291,6 +291,28 @@ static void pciehp_remove(struct pcie_device *dev)
>  }
>
>  #ifdef CONFIG_PM
> +
> +/* If device support Device Serial Numner, use DSN

s/support/supports/
s/Numner/Number/
Use conventional comment style:
  /*
   * If device ...
   */

> + * to identify the device
> + */
> +static bool device_in_slot_is_changed(struct pci_bus *pbus)
> +{
> +       u64 old_dsn, new_dsn;
> +       struct pci_dev *pdev;
> +
> +       pdev = pci_get_slot(pbus, PCI_DEVFN(0, 0));

pci_get_slot() can fail.

> +       old_dsn = pdev->sn;
> +
> +       /* get func 0 device serial number */
> +       pci_get_dsn(pdev, &new_dsn);
> +       pci_dev_put(pdev);
> +
> +       if (old_dsn != new_dsn)
> +               return true;
> +
> +       return false;
> +}
> +
>  static int pciehp_suspend (struct pcie_device *dev)
>  {
>         return 0;
> @@ -300,6 +322,7 @@ static int pciehp_resume (struct pcie_device *dev)
>  {
>         struct controller *ctrl;
>         struct slot *slot;
> +       struct pci_bus *pbus = dev->port->subordinate;
>         u8 status;
>
>         ctrl = get_service_data(dev);
> @@ -311,10 +334,17 @@ static int pciehp_resume (struct pcie_device *dev)
>
>         /* Check if slot is occupied */
>         pciehp_get_adapter_status(slot, &status);
> -       if (status)
> -               pciehp_enable_slot(slot);
> -       else
> -               pciehp_disable_slot(slot);
> +       if (status) {
> +               if (list_empty(&pbus->devices))
> +                       pciehp_enable_slot(slot);
> +               else if (device_in_slot_is_changed(pbus)) {
> +                       pciehp_disable_slot(slot);

pciehp_disable_slot() ultimately calls the .remove() method for the
device that has already been removed.  That method is likely to poke
at the device, which will do something unexpected because the new
device is likely to be completely different.

I think the call path is this:

    pciehp_resume
      pciehp_disable_slot
        remove_board
          pciehp_unconfigure_device
            pci_stop_and_remove_bus_device
              pci_stop_bus_device
                pci_stop_dev
                  device_del
                    bus_remove_device
                      device_release_driver
                        __device_release_driver
                          pci_device_remove     # pci_bus_type.remove
                            dev->driver->remove

I think we already had this problem for case 2 (card removed while
suspended), but at least in that case, the driver .remove() method
doesn't have a device to poke at, so it's less likely to do something
bad.

> +                       pciehp_enable_slot(slot);
> +               }
> +       } else {
> +               if (!list_empty(&pbus->devices))
> +                       pciehp_disable_slot(slot);
> +       }
>         return 0;
>  }
>  #endif /* PM */
> --
> 1.7.1
>
>
