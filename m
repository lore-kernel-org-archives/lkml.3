Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933095Ab3GCQJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 12:09:58 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:37865 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933072Ab3GCQJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 12:09:54 -0400
MIME-Version: 1.0
In-Reply-To: <1372864578-6925-1-git-send-email-haicheng.li@linux.intel.com>
References: <1372864578-6925-1-git-send-email-haicheng.li@linux.intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 3 Jul 2013 10:09:32 -0600
Message-ID: <CAErSpo5dR_2tUDFoFO49N3Ut569+6Cfosx8Q=91U_w-8mvFVkg@mail.gmail.com>
Subject: Re: [PATCH 1/3] PCI: Add hide_device support to pci subsystem.
To: Haicheng Li <haicheng.li@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haicheng Li <haicheng.lee@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 3, 2013 at 9:16 AM, Haicheng Li <haicheng.li@linux.intel.com> wrote:
> With more and more SOCs having pci device integrated into chip (e.g. Intel
> Atom series), it's useful to add an interface to cleanly hide pci devices from
> pci device scanning, which is because:
>
> 1. phone or tablet OEMs may choose disabling some pci device in the SOC,
>    such as camera ISP in Intel Atom Z2580 chip, and etc.
> 2. if such disabled devices are not cleanly removed from pci device tree,
>    then pci-core will still try to operate on the relative device control
>    registers while S3 suspend and resume.
> 3. so hiding such devices from early begining will not only reduce the kernel
>    boot time, but also optimize the latency of system suspend and resume.

Normally the chip provides a way to disable devices by writing a
configuration register.  Then the device doesn't respond when Linux
enumerates devices, so nothing special is required in the kernel.
What's different about the Z2580?  I'd be surprised if Intel forgot to
include such a register.  Maybe the firmware just isn't smart enough
to disable the device?  If so, it would be better to fix the firmware
than to add kludges in the kernel.

> To hide pci devices, just pass such parameters to kernel at boot stage:
>         pci=hide=[<domain>:]<bus>:<slot>.<func>[; ...]
>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: linux-pci@vger.kernel.org
> Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
> ---
>  drivers/pci/pci.c   |    2 ++
>  drivers/pci/pci.h   |    2 ++
>  drivers/pci/probe.c |   94 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 98 insertions(+)
>
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index a899d8b..e228d00 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -3915,6 +3915,8 @@ static int __init pci_setup(char *str)
>                                 pcie_bus_config = PCIE_BUS_PEER2PEER;
>                         } else if (!strncmp(str, "pcie_scan_all", 13)) {
>                                 pci_add_flags(PCI_SCAN_ALL_PCIE_DEVS);
> +                       } else if (!strncmp(str, "hide=", 5)) {
> +                               pci_hide_devices(str + 5, strlen(str + 5));
>                         } else {
>                                 printk(KERN_ERR "PCI: Unknown option `%s'\n",
>                                                 str);
> diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
> index d1182c4..783703a 100644
> --- a/drivers/pci/pci.h
> +++ b/drivers/pci/pci.h
> @@ -317,4 +317,6 @@ static inline int pci_dev_specific_reset(struct pci_dev *dev, int probe)
>  }
>  #endif
>
> +void pci_hide_devices(const char *, size_t);
> +
>  #endif /* DRIVERS_PCI_H */
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 70f10fa..4223ef3 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -11,6 +11,7 @@
>  #include <linux/cpumask.h>
>  #include <linux/pci-aspm.h>
>  #include <asm-generic/pci-bridge.h>
> +#include <asm/setup.h>
>  #include "pci.h"
>
>  #define CARDBUS_LATENCY_TIMER  176     /* secondary latency timer */
> @@ -1352,10 +1353,103 @@ void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
>         pci_proc_attach_device(dev);
>  }
>
> +static LIST_HEAD(pci_hidden_dev_list);
> +struct pci_hidden_dev {
> +       struct list_head list;
> +       int domain_nr;
> +       int devfn;
> +       unsigned char bus_nr;
> +};
> +
> +static void do_pci_hide_device(int domain_nr, unsigned char bus_nr, int devfn)
> +{
> +       struct pci_hidden_dev *d;
> +
> +       list_for_each_entry(d, &pci_hidden_dev_list, list)
> +               if (devfn == d->devfn && bus_nr == d->bus_nr &&
> +                               domain_nr == d->domain_nr)
> +                       return;
> +
> +       d = kzalloc(sizeof(*d), GFP_KERNEL);
> +       if (!d)
> +               return;
> +
> +       d->domain_nr = domain_nr;
> +       d->bus_nr = bus_nr;
> +       d->devfn = devfn;
> +
> +       list_add_tail(&d->list, &pci_hidden_dev_list);
> +}
> +
> +static bool init_hidden = true;
> +
> +#define PCI_HIDE_PARAM_SIZE COMMAND_LINE_SIZE
> +static char pci_hide_param[PCI_HIDE_PARAM_SIZE] = {'\0'};
> +
> +static void parse_hidden_devices(void)
> +{
> +       char *p = pci_hide_param;
> +       int seg, bus, slot, func, devfn, count;
> +
> +       /* parse pci.hide= command-line */
> +       while (*p != '\0') {
> +               count = 0;
> +               if (sscanf(p, "%x:%x:%x.%x%n",
> +                       &seg, &bus, &slot, &func, &count) != 4) {
> +                       seg = 0;
> +                       if (sscanf(p, "%x:%x.%x%n",
> +                                       &bus, &slot, &func, &count) != 3) {
> +                               /* Invalid format */
> +                               printk(KERN_ERR "PCI: Can't parse "
> +                                               "hide parameter: %s\n", p);
> +                               break;
> +                       }
> +               }
> +               p += count;
> +               devfn = (slot << 3) | func;
> +
> +               do_pci_hide_device(seg, bus, devfn);
> +               if (*p != ';') {
> +                       /* End of param or invalid format */
> +                       break;
> +               }
> +               p++;
> +       }
> +       init_hidden = false;
> +}
> +
> +static bool is_device_hidden(struct pci_bus *bus, int devfn)
> +{
> +       struct pci_hidden_dev *d;
> +
> +       if (unlikely(init_hidden))
> +               parse_hidden_devices();
> +
> +       list_for_each_entry(d, &pci_hidden_dev_list, list)
> +               if (d->devfn == devfn && d->bus_nr == bus->number &&
> +                               d->domain_nr == pci_domain_nr(bus))
> +                       return true;
> +
> +       return false;
> +}
> +
> +void pci_hide_devices(const char *str, size_t count)
> +{
> +       if (!str)
> +               return;
> +       if (count > PCI_HIDE_PARAM_SIZE - 1)
> +               count = PCI_HIDE_PARAM_SIZE - 1;
> +       strncpy(pci_hide_param, str, count);
> +       pci_hide_param[count] = '\0';
> +}
> +
>  struct pci_dev *__ref pci_scan_single_device(struct pci_bus *bus, int devfn)
>  {
>         struct pci_dev *dev;
>
> +       if (unlikely(is_device_hidden(bus, devfn)))
> +               return NULL;
> +
>         dev = pci_get_slot(bus, devfn);
>         if (dev) {
>                 pci_dev_put(dev);
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
