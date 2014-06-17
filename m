Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965809AbaFQQuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:50:21 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:35721 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964808AbaFQQuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:50:16 -0400
MIME-Version: 1.0
In-Reply-To: <1402982995-13747-16-git-send-email-jiang.liu@linux.intel.com>
References: <1402982995-13747-1-git-send-email-jiang.liu@linux.intel.com> <1402982995-13747-16-git-send-email-jiang.liu@linux.intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 17 Jun 2014 10:49:56 -0600
Message-ID: <CAErSpo4hmav+JTepA2cGC2Nwi1PHxBWpy+GG2t_dRfw1nbKqLA@mail.gmail.com>
Subject: Re: [RFC Patch V2 15/16] pci, ioapic: kill ioapic PCI driver
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Your subject lines aren't even consistent in the same patch series.  I suggest:

  PCI: Remove PCI ioapic driver

On Mon, Jun 16, 2014 at 11:29 PM, Jiang Liu <jiang.liu@linux.intel.com> wrote:
> Originally the ioapic PCI driver is designed to support IOAPIC hotplug,
> but it never works because no architecture has implemented required
> interface to support it.

Please be specific about what these "required interfaces" are that no
architecture has implemented.  Otherwise it's hard for me to be
convinced that it's safe to remove this.

> We plan to reimplement it as an ACPI driver
> instead of PCI driver due to:
> 1) To support IOAPIC hotplug, an IOAPIC unit must have an companion
>    ACPI device, but it may or may not be presented in PCI domain.

Please include the reason why there must be a companion ACPI device.

What about hotplugging IOAPICs on non-ACPI systems?  How would that
work?  Will that require totally separate IOAPIC drivers?  I guess
pci/ioapic.c isn't very big and contains mostly ACPI stuff, so maybe
there's nothing worth sharing.

If there must be a companion ACPI device, I guess that implies that we
can't support an IOAPIC on a plug-in card, because there won't be
anything in the ACPI namespace about the card.  Is it possible to have
an IOAPIC on a plug-in card?  I guess I don't know what we could do
with it, since I don't know how we would learn about what is connected
to the IOAPIC input pins.  There's no standard for describing that for
plug-in IOAPICs, is there?

> 2) All other PCI devices have dependency on IOAPIC, so we must hot-add
>    it before all other PCI devices and hot-remove it after all other
>    PCI devices. So we need to explicitly control the order to add/remove
>    IOAPIC devices.
>
> So kill the ioapic PCI driver and will reimplement it as an ACPI driver.
>
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> ---
>  drivers/pci/Kconfig  |    7 ---
>  drivers/pci/Makefile |    2 -
>  drivers/pci/ioapic.c |  121 --------------------------------------------------
>  3 files changed, 130 deletions(-)
>  delete mode 100644 drivers/pci/ioapic.c
>
> diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
> index 893503fa1782..39866d18004e 100644
> --- a/drivers/pci/Kconfig
> +++ b/drivers/pci/Kconfig
> @@ -104,13 +104,6 @@ config PCI_PASID
>
>           If unsure, say N.
>
> -config PCI_IOAPIC
> -       bool "PCI IO-APIC hotplug support" if X86
> -       depends on PCI
> -       depends on ACPI
> -       depends on X86_IO_APIC
> -       default !X86
> -
>  config PCI_LABEL
>         def_bool y if (DMI || ACPI)
>         select NLS
> diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
> index e04fe2d9df3b..73e4af400a5a 100644
> --- a/drivers/pci/Makefile
> +++ b/drivers/pci/Makefile
> @@ -13,8 +13,6 @@ obj-$(CONFIG_PCI_QUIRKS) += quirks.o
>  # Build PCI Express stuff if needed
>  obj-$(CONFIG_PCIEPORTBUS) += pcie/
>
> -obj-$(CONFIG_PCI_IOAPIC) += ioapic.o
> -
>  # Build the PCI Hotplug drivers if we were asked to
>  obj-$(CONFIG_HOTPLUG_PCI) += hotplug/
>  ifdef CONFIG_HOTPLUG_PCI
> diff --git a/drivers/pci/ioapic.c b/drivers/pci/ioapic.c
> deleted file mode 100644
> index 6b2b7dddbbdb..000000000000
> --- a/drivers/pci/ioapic.c
> +++ /dev/null
> @@ -1,121 +0,0 @@
> -/*
> - * IOAPIC/IOxAPIC/IOSAPIC driver
> - *
> - * Copyright (C) 2009 Fujitsu Limited.
> - * (c) Copyright 2009 Hewlett-Packard Development Company, L.P.
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 as
> - * published by the Free Software Foundation.
> - */
> -
> -/*
> - * This driver manages PCI I/O APICs added by hotplug after boot.  We try to
> - * claim all I/O APIC PCI devices, but those present at boot were registered
> - * when we parsed the ACPI MADT, so we'll fail when we try to re-register
> - * them.
> - */
> -
> -#include <linux/pci.h>
> -#include <linux/module.h>
> -#include <linux/acpi.h>
> -#include <linux/slab.h>
> -
> -struct ioapic {
> -       acpi_handle     handle;
> -       u32             gsi_base;
> -};
> -
> -static int ioapic_probe(struct pci_dev *dev, const struct pci_device_id *ent)
> -{
> -       acpi_handle handle;
> -       acpi_status status;
> -       unsigned long long gsb;
> -       struct ioapic *ioapic;
> -       int ret;
> -       char *type;
> -       struct resource *res;
> -
> -       handle = ACPI_HANDLE(&dev->dev);
> -       if (!handle)
> -               return -EINVAL;
> -
> -       status = acpi_evaluate_integer(handle, "_GSB", NULL, &gsb);
> -       if (ACPI_FAILURE(status))
> -               return -EINVAL;
> -
> -       /*
> -        * The previous code in acpiphp evaluated _MAT if _GSB failed, but
> -        * ACPI spec 4.0 sec 6.2.2 requires _GSB for hot-pluggable I/O APICs.
> -        */
> -
> -       ioapic = kzalloc(sizeof(*ioapic), GFP_KERNEL);
> -       if (!ioapic)
> -               return -ENOMEM;
> -
> -       ioapic->handle = handle;
> -       ioapic->gsi_base = (u32) gsb;
> -
> -       if (dev->class == PCI_CLASS_SYSTEM_PIC_IOAPIC)
> -               type = "IOAPIC";
> -       else
> -               type = "IOxAPIC";
> -
> -       ret = pci_enable_device(dev);
> -       if (ret < 0)
> -               goto exit_free;
> -
> -       pci_set_master(dev);
> -
> -       if (pci_request_region(dev, 0, type))
> -               goto exit_disable;
> -
> -       res = &dev->resource[0];
> -       if (acpi_register_ioapic(ioapic->handle, res->start, ioapic->gsi_base))
> -               goto exit_release;
> -
> -       pci_set_drvdata(dev, ioapic);
> -       dev_info(&dev->dev, "%s at %pR, GSI %u\n", type, res, ioapic->gsi_base);
> -       return 0;
> -
> -exit_release:
> -       pci_release_region(dev, 0);
> -exit_disable:
> -       pci_disable_device(dev);
> -exit_free:
> -       kfree(ioapic);
> -       return -ENODEV;
> -}
> -
> -static void ioapic_remove(struct pci_dev *dev)
> -{
> -       struct ioapic *ioapic = pci_get_drvdata(dev);
> -
> -       acpi_unregister_ioapic(ioapic->handle, ioapic->gsi_base);
> -       pci_release_region(dev, 0);
> -       pci_disable_device(dev);
> -       kfree(ioapic);
> -}
> -
> -
> -static DEFINE_PCI_DEVICE_TABLE(ioapic_devices) = {
> -       { PCI_DEVICE_CLASS(PCI_CLASS_SYSTEM_PIC_IOAPIC, ~0) },
> -       { PCI_DEVICE_CLASS(PCI_CLASS_SYSTEM_PIC_IOXAPIC, ~0) },
> -       { }
> -};
> -MODULE_DEVICE_TABLE(pci, ioapic_devices);
> -
> -static struct pci_driver ioapic_driver = {
> -       .name           = "ioapic",
> -       .id_table       = ioapic_devices,
> -       .probe          = ioapic_probe,
> -       .remove         = ioapic_remove,
> -};
> -
> -static int __init ioapic_init(void)
> -{
> -       return pci_register_driver(&ioapic_driver);
> -}
> -module_init(ioapic_init);
> -
> -MODULE_LICENSE("GPL");
> --
> 1.7.10.4
>
