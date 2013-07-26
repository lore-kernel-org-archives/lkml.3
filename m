Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262Ab3GZARp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 20:17:45 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:47057 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757107Ab3GZARk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 20:17:40 -0400
MIME-Version: 1.0
In-Reply-To: <1373621543-54836-4-git-send-email-wangyijing@huawei.com>
References: <1373621543-54836-1-git-send-email-wangyijing@huawei.com> <1373621543-54836-4-git-send-email-wangyijing@huawei.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 25 Jul 2013 18:17:19 -0600
Message-ID: <CAErSpo4XhONYq3CZnPKgdMD4V5o8fgFc=NGVUGgFz0y5zM3GyA@mail.gmail.com>
Subject: Re: [PATCH -v3 3/3] PCI,pciehp: use PCIe DSN to identify device
 change during suspend
To: Yijing Wang <wangyijing@huawei.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>, Paul Bolle <pebolle@tiscali.nl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Rafael <rjw@sisk.pl>, Hanjun Guo <guohanjun@huawei.com>,
        Jiang Liu <jiang.liu@huawei.com>, Oliver Neukum <oneukum@suse.de>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 3:32 AM, Yijing Wang <wangyijing@huawei.com> wrote:
> If device was removed from slot and reinsert a new device during
> suspend, pciehp can not identify the physical device change now.
> So the old driver .resume() method will be called for the new device,
> this is bad. If device support device serial number capability,
> we can identify this by DSN. So the reasonable way is first remove
> the old device, then enable the new device.
>
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> Cc: Paul Bolle <pebolle@tiscali.nl>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: Oliver Neukum <oneukum@suse.de>
> Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>
> Cc: linux-pci@vger.kernel.org
> ---
>  drivers/pci/hotplug/pciehp_core.c |   45 +++++++++++++++++++++++++++++++++++++
>  1 files changed, 45 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
> index 7fe9dbd..bc47f8e 100644
> --- a/drivers/pci/hotplug/pciehp_core.c
> +++ b/drivers/pci/hotplug/pciehp_core.c
> @@ -296,11 +296,38 @@ static int pciehp_suspend (struct pcie_device *dev)
>         return 0;
>  }
>
> +/*
> + * check the func 0 device serial number is changed,
> + * if device does not support device serial number,
> + * return false.
> + */
> +static bool device_serial_number_changed(struct pci_bus *pbus)
> +{
> +       u64 old_dsn, new_dsn;
> +       struct pci_dev *pdev;
> +
> +       pdev = pci_get_slot(pbus, PCI_DEVFN(0, 0));
> +       if (!pdev)
> +               return false;
> +
> +       old_dsn = pdev->sn;
> +
> +       /* get func 0 device serial number */
> +       new_dsn = pci_device_serial_number(pdev);
> +       pci_dev_put(pdev);
> +
> +       if (old_dsn != new_dsn)
> +               return true;
> +
> +       return false;
> +}
> +
>  static int pciehp_resume (struct pcie_device *dev)
>  {
>         struct controller *ctrl;
>         struct slot *slot;
>         struct pci_bus *pbus = dev->port->subordinate;
> +       int retval = 0;
>         u8 status;
>
>         ctrl = get_service_data(dev);
> @@ -315,6 +342,24 @@ static int pciehp_resume (struct pcie_device *dev)
>         if (status) {
>                 if (list_empty(&pbus->devices))
>                         pciehp_enable_slot(slot);
> +
> +               if (device_serial_number_changed(pbus)) {
> +                       /*
> +                        * first power off slot, avoid the old driver
> +                        * .remove() method touch the new hardware
> +                        */
> +                       if (POWER_CTRL(ctrl)) {
> +                               retval = pciehp_power_off_slot(slot);
> +                               if (retval) {
> +                                       ctrl_err(ctrl,
> +                                               "Issue of Slot Disable command failed\n");
> +                                       return 0;
> +                               }
> +                               msleep(1000);
> +                               pciehp_unconfigure_device(slot);
> +                               pciehp_enable_slot(slot);
> +                       }
> +               }

I'm not sure this is implemented at the correct place.  The idea of
using the serial number to detect card swaps is not really specific to
pciehp.  I know the Device Serial Number capability is defined in the
PCIe spec, but it doesn't *require* any PCIe functionality, and
there's no reason a similar capability couldn't be defined for
conventional PCI.

I don't know much about it, but conventional PCI *does* in fact
support the VPD capability, which can contain a serial number.  I
wonder if we should enhance pci_device_serial_number() to look for a
VPD serial number if there's no PCIe DSN.  Then we would want this
check for card swap in a more generic place, e.g., somewhere in
pci_scan_slot(), so all forms of hotplug would benefit from it.

Also, I think it's possible to use acpiphp for ExpressCard slots, and
this patch doesn't help acpiphp detect card swaps.  I don't see any
mention of suspend/resume in acpiphp, so I don't know if it does
anything at all to detect card changes while suspended.  Maybe Rafael
can shed some light?

I put the first two patches on a pci/yijing-dsn-v3 branch while we
work out the details of this one.

Bjorn

>         } else if (!list_empty(&pbus->devices)) {
>                 pciehp_disable_slot(slot);
>         }
> --
> 1.7.1
>
>
