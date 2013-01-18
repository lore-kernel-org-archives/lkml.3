Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab3ARRrY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 12:47:24 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:40459 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab3ARRrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 12:47:22 -0500
MIME-Version: 1.0
In-Reply-To: <6681740.NxX6Su8EKC@vostro.rjw.lan>
References: <6681740.NxX6Su8EKC@vostro.rjw.lan>
Date: Fri, 18 Jan 2013 09:47:21 -0800
X-Google-Sender-Auth: as5TsRGKw-C6z59FH7GdtyKbpvo
Message-ID: <CAE9FiQXU_KQfoND=rQDczB65jxKYxWpnnQT4pSW296sUscG8HA@mail.gmail.com>
Subject: Re: [PATCH] ACPI / scan: Fold acpi_bus_scan() into acpi_bus_add()
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Moore, Robert" <robert.moore@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 4:35 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> The only difference between acpi_bus_scan() into acpi_bus_add() is
> the invocation of acpi_update_all_gpes() in the latter which in fact
> is unnecessary, because acpi_update_all_gpes() has already been
> called by acpi_scan_init() and the way it is implemented causes the
> next invocations of it to do nothing.
>
> For this reason, drop the acpi_update_all_gpes() call from
> acpi_bus_add() and fold acpi_bus_scan() into it.  Additionally,
> rename acpi_bus_scan_fixed() to acpi_bus_add_fixed(), because
> acpi_bus_scan() is not present any more, and rearrange the code
> in acpi_scan_init() slightly.
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/acpi/scan.c |   52 +++++++++++++++++++++-------------------------------
>  1 file changed, 21 insertions(+), 31 deletions(-)
>
> Index: linux-pm/drivers/acpi/scan.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/scan.c
> +++ linux-pm/drivers/acpi/scan.c
> @@ -1584,24 +1584,6 @@ static acpi_status acpi_bus_device_attac
>         return status;
>  }
>
> -static int acpi_bus_scan(acpi_handle handle)
> -{
> -       void *device = NULL;
> -
> -       if (ACPI_SUCCESS(acpi_bus_check_add(handle, 0, NULL, &device)))
> -               acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
> -                                   acpi_bus_check_add, NULL, NULL, &device);
> -
> -       if (!device)
> -               return -ENODEV;
> -
> -       if (ACPI_SUCCESS(acpi_bus_device_attach(handle, 0, NULL, NULL)))
> -               acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
> -                                   acpi_bus_device_attach, NULL, NULL, NULL);
> -
> -       return 0;
> -}
> -
>  /**
>   * acpi_bus_add - Add ACPI device node objects in a given namespace scope.
>   * @handle: Root of the namespace scope to scan.
> @@ -1616,13 +1598,19 @@ static int acpi_bus_scan(acpi_handle han
>   */
>  int acpi_bus_add(acpi_handle handle)

looks like scan is good name.

scan = add + attach better than
add = add + attach?

>  {
> -       int err;
> +       void *device = NULL;
> +
> +       if (ACPI_SUCCESS(acpi_bus_check_add(handle, 0, NULL, &device)))
> +               acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
> +                                   acpi_bus_check_add, NULL, NULL, &device);
> +
> +       if (!device)
> +               return -ENODEV;
>
> -       err = acpi_bus_scan(handle);
> -       if (err)
> -               return err;
> +       if (ACPI_SUCCESS(acpi_bus_device_attach(handle, 0, NULL, NULL)))
> +               acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
> +                                   acpi_bus_device_attach, NULL, NULL, NULL);
>
> -       acpi_update_all_gpes();
>         return 0;
>  }
>  EXPORT_SYMBOL(acpi_bus_add);
> @@ -1670,7 +1658,7 @@ int acpi_bus_trim(struct acpi_device *st
>  }
>  EXPORT_SYMBOL_GPL(acpi_bus_trim);
>
> -static int acpi_bus_scan_fixed(void)
> +static int acpi_bus_add_fixed(void)
>  {
>         int result = 0;
>         struct acpi_device *device = NULL;
> @@ -1709,18 +1697,20 @@ int __init acpi_scan_init(void)
>         /*
>          * Enumerate devices in the ACPI namespace.
>          */
> -       result = acpi_bus_scan(ACPI_ROOT_OBJECT);
> +       result = acpi_bus_add(ACPI_ROOT_OBJECT);
>         if (result)
>                 return result;
>
>         result = acpi_bus_get_device(ACPI_ROOT_OBJECT, &acpi_root);
> -       if (!result)
> -               result = acpi_bus_scan_fixed();
> -
>         if (result)
> +               return result;
> +
> +       result = acpi_bus_add_fixed();
> +       if (result) {
>                 acpi_device_unregister(acpi_root);
> -       else
> -               acpi_update_all_gpes();
> +               return result;
> +       }
>
> -       return result;
> +       acpi_update_all_gpes();
> +       return 0;
>  }
>
