Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab3AZX0J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 18:26:09 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:56777 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710Ab3AZX0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 18:26:07 -0500
MIME-Version: 1.0
In-Reply-To: <2664818.zPRWmg7IFi@vostro.rjw.lan>
References: <1581701.fnbebHrKch@vostro.rjw.lan>
	<2664818.zPRWmg7IFi@vostro.rjw.lan>
Date: Sat, 26 Jan 2013 15:26:06 -0800
X-Google-Sender-Auth: pMaSs88uke7B3V5_SMYKyJ3O2PU
Message-ID: <CAE9FiQVcYdUYbg+X+mOvz9fCVLeYM_ue7YfV6OVUyFnZs+DWMA@mail.gmail.com>
Subject: Re: [PATCH 2/2] ACPI / scan: Make scanning of fixed devices follow
 the general scheme
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <liuj97@gmail.com>,
        Toshi Kani <toshi.kani@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2013 at 2:43 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> Make acpi_bus_scan_fixed() use device_attach() directly to attach
> drivers, if any, to the fixed devices in analogy with how
> acpi_bus_scan() works, which allows the last argument of
> acpi_add_single_object() to be dropped and the manipulation of the
> flags.match_driver bit to be moved to acpi_init_device_object()
> and acpi_device_add_finalize().
>
> After these changes all of the functions for the initialization
> and registration of struct acpi_device objects work in the same
> way for all of them.
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/acpi/scan.c |   35 ++++++++++++++++++++++++-----------
>  1 file changed, 24 insertions(+), 11 deletions(-)
>
> Index: linux-pm/drivers/acpi/scan.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/scan.c
> +++ linux-pm/drivers/acpi/scan.c
> @@ -1437,19 +1437,21 @@ void acpi_init_device_object(struct acpi
>         acpi_device_get_busid(device);
>         acpi_device_set_id(device);
>         acpi_bus_get_flags(device);
> +       device->flags.match_driver = false;
>         device_initialize(&device->dev);
>         dev_set_uevent_suppress(&device->dev, true);
>  }
>
>  void acpi_device_add_finalize(struct acpi_device *device)
>  {
> +       device->flags.match_driver = true;
>         dev_set_uevent_suppress(&device->dev, false);
>         kobject_uevent(&device->dev.kobj, KOBJ_ADD);
>  }
>
>  static int acpi_add_single_object(struct acpi_device **child,
>                                   acpi_handle handle, int type,
> -                                 unsigned long long sta, bool match_driver)
> +                                 unsigned long long sta)
>  {
>         int result;
>         struct acpi_device *device;
> @@ -1465,7 +1467,6 @@ static int acpi_add_single_object(struct
>         acpi_bus_get_power_flags(device);
>         acpi_bus_get_wakeup_device_flags(device);
>
> -       device->flags.match_driver = match_driver;
>         result = acpi_device_add(device, acpi_device_release);
>         if (result) {
>                 acpi_device_release(&device->dev);
> @@ -1558,12 +1559,10 @@ static acpi_status acpi_bus_check_add(ac
>                 return AE_CTRL_DEPTH;
>         }
>
> -       acpi_add_single_object(&device, handle, type, sta, false);
> +       acpi_add_single_object(&device, handle, type, sta);
>         if (!device)
>                 return AE_CTRL_DEPTH;
>
> -       device->flags.match_driver = true;
> -
>   out:
>         if (!*return_value)
>                 *return_value = device;

nice cleanup.

Acked-by: Yinghai Lu <yinghai@kernel.org>

> @@ -1681,25 +1680,39 @@ EXPORT_SYMBOL_GPL(acpi_bus_trim);
>  static int acpi_bus_scan_fixed(void)
>  {
>         int result = 0;
> -       struct acpi_device *device = NULL;
>
>         /*
>          * Enumerate all fixed-feature devices.
>          */
> -       if ((acpi_gbl_FADT.flags & ACPI_FADT_POWER_BUTTON) == 0) {
> +       if (!(acpi_gbl_FADT.flags & ACPI_FADT_POWER_BUTTON)) {
> +               struct acpi_device *device = NULL;
> +
>                 result = acpi_add_single_object(&device, NULL,
>                                                 ACPI_BUS_TYPE_POWER_BUTTON,
> -                                               ACPI_STA_DEFAULT, true);
> +                                               ACPI_STA_DEFAULT);
> +               if (result)
> +                       return result;
> +
> +               result = device_attach(&device->dev);
> +               if (result < 0)
> +                       return result;
> +
>                 device_init_wakeup(&device->dev, true);
>         }
>
> -       if ((acpi_gbl_FADT.flags & ACPI_FADT_SLEEP_BUTTON) == 0) {
> +       if (!(acpi_gbl_FADT.flags & ACPI_FADT_SLEEP_BUTTON)) {
> +               struct acpi_device *device = NULL;
> +
>                 result = acpi_add_single_object(&device, NULL,
>                                                 ACPI_BUS_TYPE_SLEEP_BUTTON,
> -                                               ACPI_STA_DEFAULT, true);
> +                                               ACPI_STA_DEFAULT);
> +               if (result)
> +                       return result;
> +
> +               result = device_attach(&device->dev);
>         }
>
> -       return result;
> +       return result < 0 ? result : 0;
>  }
>
>  int __init acpi_scan_init(void)
>
