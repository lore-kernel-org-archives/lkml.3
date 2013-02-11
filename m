Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932834Ab3BKWls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 17:41:48 -0500
Received: from mail-ie0-f202.google.com ([209.85.223.202]:55592 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932641Ab3BKWlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 17:41:45 -0500
Date: Mon, 11 Feb 2013 15:41:42 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Lan Tianyu <tianyu.lan@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Kosina <jkosina@suse.cz>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [Bisected] [-next-20130204] usb/hcd: irq 18: nobody cared
Message-ID: <20130211224142.GA9782@google.com>
References: <Pine.LNX.4.44L0.1302051520220.2245-100000@iolanthe.rowland.org>
 <1360466060.3703.15.camel@thor.lan>
 <1360506199.3461.5.camel@thor.lan>
 <CAE9FiQX0Jzqi=Dy=r3MoU9vK7HgAf+919LvbgLygW7VH3O4=bg@mail.gmail.com>
 <CAE9FiQX5wQ8zFzPfgmvm0BESyLVxzDRQ33XPgj+QjBZ0kxuHXg@mail.gmail.com>
 <1360587768.3454.2.camel@thor.lan>
 <CAE9FiQWUZ3BgLOtcGePppLzWBv-uR8L+7abditH2MNA7zZW-WA@mail.gmail.com>
 <CAE9FiQXcgxY_vW6gjqU7Jtxc71J=sKt_2SPsN8x1O9EfDRN_0g@mail.gmail.com>
 <CAE9FiQXnb-op9vsQJroMisDQt_-X2UpBB1R_WJ1Lifnk5pPpGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQXnb-op9vsQJroMisDQt_-X2UpBB1R_WJ1Lifnk5pPpGg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc linux-acpi, linux-pci]

On Mon, Feb 11, 2013 at 01:06:27PM -0800, Yinghai Lu wrote:
> On Mon, Feb 11, 2013 at 11:57 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> >>
> >> Bjorn, Rafael,
> >>
> >> acpi_pci_irq_add_prt need to be called after pci bridge get scanned,
> >> so we can not call it from pci_acpi_setup, after we move dev_register
> >> for pci_dev early.
> >>
> >> The attached debug patch move down that calling into
> >> pci_bus_add_devices and that will make prt works again.
> >>
> >> Can acpi provide another hook after bridge get scanned?
> 
> Rafael, Bjorn,
> 
> Can you check attached patch?

[Yinghai's patch included below for ease of review]

> Subject: [PATCH] ACPI, PCI: add acpi_platform_notify_scan()
> 
> Peter Hurley found irq nobody cared, and dmesg has
> 
> [    8.983246] pci 0000:00:1e.0: can't derive routing for PCI INT A
> [    8.983600] snd_ctxfi 0000:09:02.0: PCI INT A: no GSI - using ISA IRQ 5
> 
> bisect to
> | commit 4f535093cf8f6da8cfda7c36c2c1ecd2e9586ee4
> |     PCI: Put pci_dev in device tree as early as possible
> 
> It turns out we need to call acpi_pci_irq_add_prt() after the pci bridges
> are scanned.
> 
> Add acpi_platform_notify_scan() to call acpi_pci_irq_add_prt later.
> 
> Reported-and-tested-by: Peter Hurley <peter@hurleysoftware.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  drivers/acpi/glue.c     |   12 ++++++++++++
>  drivers/base/core.c     |    1 +
>  drivers/pci/bus.c       |    4 ++++
>  drivers/pci/pci-acpi.c  |   27 +++++++++++++++++----------
>  include/acpi/acpi_bus.h |    1 +
>  include/linux/device.h  |    3 +--
>  6 files changed, 36 insertions(+), 12 deletions(-)
> 
> Index: linux-2.6/drivers/acpi/glue.c
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/glue.c
> +++ linux-2.6/drivers/acpi/glue.c
> @@ -312,6 +312,17 @@ static int acpi_platform_notify(struct d
>  	return ret;
>  }
>  
> +static int acpi_platform_notify_scan(struct device *dev)
> +{
> +	struct acpi_bus_type *type;
> +
> +	type = acpi_get_bus_type(dev->bus);
> +	if (type && type->setup_scan)
> +		type->setup_scan(dev);
> +
> +	return 0;
> +}
> +
>  static int acpi_platform_notify_remove(struct device *dev)
>  {
>  	struct acpi_bus_type *type;
> @@ -331,6 +342,7 @@ int __init init_acpi_device_notify(void)
>  		return 0;
>  	}
>  	platform_notify = acpi_platform_notify;
> +	platform_notify_scan = acpi_platform_notify_scan;
>  	platform_notify_remove = acpi_platform_notify_remove;
>  	return 0;
>  }
> Index: linux-2.6/drivers/base/core.c
> ===================================================================
> --- linux-2.6.orig/drivers/base/core.c
> +++ linux-2.6/drivers/base/core.c
> @@ -44,6 +44,7 @@ early_param("sysfs.deprecated", sysfs_de
>  #endif
>  
>  int (*platform_notify)(struct device *dev) = NULL;
> +int (*platform_notify_scan)(struct device *dev) = NULL;

I don't like the idea of adding another global function pointer just
for this.  That seems like overkill for a small, local, problem.

>  int (*platform_notify_remove)(struct device *dev) = NULL;
>  static struct kobject *dev_kobj;
>  struct kobject *sysfs_dev_char_kobj;
> Index: linux-2.6/drivers/pci/bus.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/bus.c
> +++ linux-2.6/drivers/pci/bus.c
> @@ -170,6 +170,10 @@ int pci_bus_add_device(struct pci_dev *d
>  {
>  	int retval;
>  
> +	/* need to be called after bridge is scanned */
> +	if (platform_notify_scan)
> +		platform_notify_scan(&dev->dev);
> +
>  	/*
>  	 * Can not put in pci_device_add yet because resources
>  	 * are not assigned yet for some devices.
> Index: linux-2.6/drivers/pci/pci-acpi.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/pci-acpi.c
> +++ linux-2.6/drivers/pci/pci-acpi.c
> @@ -307,6 +307,22 @@ static void pci_acpi_setup(struct device
>  	struct pci_dev *pci_dev = to_pci_dev(dev);
>  	acpi_handle handle = ACPI_HANDLE(dev);
>  	struct acpi_device *adev;
> +
> +	if (acpi_bus_get_device(handle, &adev) || !adev->wakeup.flags.valid)
> +		return;
> +
> +	device_set_wakeup_capable(dev, true);
> +	acpi_pci_sleep_wake(pci_dev, false);
> +
> +	pci_acpi_add_pm_notifier(adev, pci_dev);
> +	if (adev->wakeup.flags.run_wake)
> +		device_set_run_wake(dev, true);
> +}
> +
> +static void pci_acpi_setup_scan(struct device *dev)
> +{
> +	struct pci_dev *pci_dev = to_pci_dev(dev);
> +	acpi_handle handle = ACPI_HANDLE(dev);
>  	acpi_status status;
>  	acpi_handle dummy;
>  
> @@ -326,16 +342,6 @@ static void pci_acpi_setup(struct device
>  			pci_dev->subordinate->number : pci_dev->bus->number;
>  		acpi_pci_irq_add_prt(handle, pci_domain_nr(pci_dev->bus), bus);

The _PRT describes motherboard interrupt wiring, which has nothing to
do with PCI bus numbers.  Our current drivers/acpi/pci_irq.c caches
the PCI bus number along with the _PRT, and I think that's a mistake.

The bus number binding means acpi_pci_irq_add_prt() has to happen
after enumerating everything below a bridge, and it will prevent us
from doing any bus number reassignment for hotplug.

I think we should remove the bus numbers from the cached _PRT (or
maybe even remove the _PRT caching completely).  When we enable a PCI
device's IRQ, we should search up the PCI device tree looking for a
_PRT associated with each node, and applying normal PCI bridge
swizzling when we don't find a _PRT.  I think this can be done without
using PCI bus numbers at all.

>  	}
> -
> -	if (acpi_bus_get_device(handle, &adev) || !adev->wakeup.flags.valid)
> -		return;
> -
> -	device_set_wakeup_capable(dev, true);
> -	acpi_pci_sleep_wake(pci_dev, false);
> -
> -	pci_acpi_add_pm_notifier(adev, pci_dev);
> -	if (adev->wakeup.flags.run_wake)
> -		device_set_run_wake(dev, true);
>  }
>  
>  static void pci_acpi_cleanup(struct device *dev)
> @@ -359,6 +365,7 @@ static struct acpi_bus_type acpi_pci_bus
>  	.bus = &pci_bus_type,
>  	.find_device = acpi_pci_find_device,
>  	.setup = pci_acpi_setup,
> +	.setup_scan = pci_acpi_setup_scan,
>  	.cleanup = pci_acpi_cleanup,
>  };
>  
> Index: linux-2.6/include/acpi/acpi_bus.h
> ===================================================================
> --- linux-2.6.orig/include/acpi/acpi_bus.h
> +++ linux-2.6/include/acpi/acpi_bus.h
> @@ -440,6 +440,7 @@ struct acpi_bus_type {
>  	/* For bridges, such as PCI root bridge, IDE controller */
>  	int (*find_bridge) (struct device *, acpi_handle *);
>  	void (*setup)(struct device *);
> +	void (*setup_scan)(struct device *);
>  	void (*cleanup)(struct device *);
>  };
>  int register_acpi_bus_type(struct acpi_bus_type *);
> Index: linux-2.6/include/linux/device.h
> ===================================================================
> --- linux-2.6.orig/include/linux/device.h
> +++ linux-2.6/include/linux/device.h
> @@ -897,10 +897,9 @@ extern void device_destroy(struct class
>   */
>  /* Notify platform of device discovery */
>  extern int (*platform_notify)(struct device *dev);
> -
> +extern int (*platform_notify_scan)(struct device *dev);
>  extern int (*platform_notify_remove)(struct device *dev);
>  
> -
>  /*
>   * get_device - atomically increment the reference count for the device.
>   *
