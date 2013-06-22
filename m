Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613Ab3FVVjn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 17:39:43 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:50513 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab3FVVji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 17:39:38 -0400
MIME-Version: 1.0
In-Reply-To: <1409252.T5jEfLdPAg@vostro.rjw.lan>
References: <2737587.I0nULev1kj@vostro.rjw.lan>
	<1409252.T5jEfLdPAg@vostro.rjw.lan>
Date: Sat, 22 Jun 2013 14:39:37 -0700
X-Google-Sender-Auth: 0XDrAzcEvaOZrT8Og3m2WaBZ4oY
Message-ID: <CAE9FiQUCovi1mMJrkbFBfr0em1B_gQKxYQSYha0d6-CpvMTAng@mail.gmail.com>
Subject: Re: [PATCH 1/3] ACPI / dock: Initialize ACPI dock subsystem upfront
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Alexander E . Patrakov" <patrakov@gmail.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 22, 2013 at 2:21 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Jiang Liu <jiang.liu@huawei.com>
>
> Commit 3b63aaa70e1 (PCI: acpiphp: Do not use ACPI PCI subdriver
> mechanism) introduced an ACPI dock support regression, because it
> changed the relative initialization order of the ACPI dock subsystem
> and the ACPI-based PCI hotplug (acpiphp).
>
> Namely, the ACPI dock subsystem has to be initialized before
> acpiphp_enumerate_slots() is first run, which after commit
> 3b63aaa70e1 happens during the initial enumeration of the PCI
> hierarchy triggered by the initial ACPI namespace scan in
> acpi_scan_init().  For this reason, the dock subsystem has to be
> initialized before the initial ACPI namespace scan in
> acpi_scan_init().
>
> To make that happen, modify the ACPI dock subsystem to be
> non-modular and add the invocation of its initialization routine,
> acpi_dock_init(), to acpi_scan_init() directly before the initial
> namespace scan.
>
> [rjw: Changelog, removal of dock_exit().]
> References: https://bugzilla.kernel.org/show_bug.cgi?id=59501
> Reported-and-tested-by: Alexander E. Patrakov <patrakov@gmail.com>
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: 3.9+ <stable@vger.kernel.org>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/acpi/dock.c     |   42 +-----------------------------------------
>  drivers/acpi/internal.h |    5 +++++
>  drivers/acpi/scan.c     |    1 +
>  3 files changed, 7 insertions(+), 41 deletions(-)
>
> Index: linux-pm/drivers/acpi/dock.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/dock.c
> +++ linux-pm/drivers/acpi/dock.c
> @@ -994,30 +994,6 @@ err_unregister:
>  }
>
>  /**
> - * dock_remove - free up resources related to the dock station
> - */
> -static int dock_remove(struct dock_station *ds)
> -{
> -       struct dock_dependent_device *dd, *tmp;
> -       struct platform_device *dock_device = ds->dock_device;
> -
> -       if (!dock_station_count)
> -               return 0;
> -
> -       /* remove dependent devices */
> -       list_for_each_entry_safe(dd, tmp, &ds->dependent_devices, list)
> -               kfree(dd);
> -
> -       list_del(&ds->sibling);
> -
> -       /* cleanup sysfs */
> -       sysfs_remove_group(&dock_device->dev.kobj, &dock_attribute_group);
> -       platform_device_unregister(dock_device);
> -
> -       return 0;
> -}
> -
> -/**
>   * find_dock_and_bay - look for dock stations and bays
>   * @handle: acpi handle of a device
>   * @lvl: unused
> @@ -1035,7 +1011,7 @@ find_dock_and_bay(acpi_handle handle, u3
>         return AE_OK;
>  }
>
> -static int __init dock_init(void)
> +int __init acpi_dock_init(void)
>  {
>         if (acpi_disabled)
>                 return 0;
> @@ -1054,19 +1030,3 @@ static int __init dock_init(void)
>                 ACPI_DOCK_DRIVER_DESCRIPTION, dock_station_count);
>         return 0;
>  }
> -
> -static void __exit dock_exit(void)
> -{
> -       struct dock_station *tmp, *dock_station;
> -
> -       unregister_acpi_bus_notifier(&dock_acpi_notifier);
> -       list_for_each_entry_safe(dock_station, tmp, &dock_stations, sibling)
> -               dock_remove(dock_station);
> -}
> -
> -/*
> - * Must be called before drivers of devices in dock, otherwise we can't know
> - * which devices are in a dock
> - */
> -subsys_initcall(dock_init);
> -module_exit(dock_exit);

Finally that weird pair is gone.

Acked-by: Yinghai Lu <yinghai@kernel.org>

> Index: linux-pm/drivers/acpi/internal.h
> ===================================================================
> --- linux-pm.orig/drivers/acpi/internal.h
> +++ linux-pm/drivers/acpi/internal.h
> @@ -41,6 +41,11 @@ void acpi_container_init(void);
>  #else
>  static inline void acpi_container_init(void) {}
>  #endif
> +#ifdef CONFIG_ACPI_DOCK
> +void acpi_dock_init(void);
> +#else
> +static inline void acpi_dock_init(void) {}
> +#endif
>  #ifdef CONFIG_ACPI_HOTPLUG_MEMORY
>  void acpi_memory_hotplug_init(void);
>  #else
> Index: linux-pm/drivers/acpi/scan.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/scan.c
> +++ linux-pm/drivers/acpi/scan.c
> @@ -2134,6 +2134,7 @@ int __init acpi_scan_init(void)
>         acpi_cmos_rtc_init();
>         acpi_container_init();
>         acpi_memory_hotplug_init();
> +       acpi_dock_init();
>
>         mutex_lock(&acpi_scan_lock);
>         /*
>
