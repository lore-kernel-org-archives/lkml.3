Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab3BCEyt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 23:54:49 -0500
Received: from mail-ia0-f175.google.com ([209.85.210.175]:45779 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab3BCEyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 23:54:47 -0500
MIME-Version: 1.0
In-Reply-To: <2566718.DLPxb38Yi2@vostro.rjw.lan>
References: <1873429.MS5RQDxTye@vostro.rjw.lan>
	<1359502048.15120.75.camel@misato.fc.hp.com>
	<25678789.biaFkG0HMW@vostro.rjw.lan>
	<2566718.DLPxb38Yi2@vostro.rjw.lan>
Date: Sat, 2 Feb 2013 20:54:46 -0800
X-Google-Sender-Auth: K9clzDL3qPUN2wqfQ7K9PYg6Uj8
Message-ID: <CAE9FiQWbRyTqYnM7StWSv8=7+hGhPnCDPRb=-Oe5wfnefHAv+A@mail.gmail.com>
Subject: Re: [PATCH] ACPI / scan: Follow priorities of IDs when matching scan handlers
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Toshi Kani <toshi.kani@hp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Jiang Liu <liuj97@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 2, 2013 at 4:52 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> The IDs of ACPI device nodes stored in their pnp.ids member arrays
> are sorted by decreasing priority (i.e. the highest-priority ID is
> the first entry).  This means that when matching scan handlers to
> device nodes, the namespace scanning code should walk the list of
> scan handlers for each device node ID instead of walking the list
> of device node IDs for each handler (the latter causes the first
> handler matching any of the device node IDs to be chosen, although
> there may be another handler matching an ID of a higher priority
> which should be preferred).  Make the code follow this observation.
>
> This change has been suggested and justified by Toshi Kani.
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/acpi/scan.c |   42 +++++++++++++++++++++++++++++-------------
>  1 file changed, 29 insertions(+), 13 deletions(-)
>
> Index: test/drivers/acpi/scan.c
> ===================================================================
> --- test.orig/drivers/acpi/scan.c
> +++ test/drivers/acpi/scan.c
> @@ -1556,26 +1556,42 @@ static acpi_status acpi_bus_check_add(ac
>         return AE_OK;
>  }
>
> -static int acpi_scan_attach_handler(struct acpi_device *device)
> +static int acpi_scan_do_attach_handler(struct acpi_device *device, char *id)
>  {
>         struct acpi_scan_handler *handler;
> -       int ret = 0;
>
>         list_for_each_entry(handler, &acpi_scan_handlers_list, list_node) {
> -               const struct acpi_device_id *id;
> +               const struct acpi_device_id *devid;
>
> -               id = __acpi_match_device(device, handler->ids);
> -               if (!id)
> -                       continue;
> -
> -               ret = handler->attach(device, id);
> -               if (ret > 0) {
> -                       device->handler = handler;
> -                       break;
> -               } else if (ret < 0) {
> -                       break;
> +               for (devid = handler->ids; devid->id[0]; devid++) {
> +                       int ret;
> +
> +                       if (strcmp((char *)devid->id, id))
> +                               continue;
> +
> +                       ret = handler->attach(device, devid);
> +                       if (ret > 0) {
> +                               device->handler = handler;
> +                               return ret;
> +                       } else if (ret < 0) {
> +                               return ret;
> +                       }
>                 }
>         }
> +       return 0;
> +}
> +
> +static int acpi_scan_attach_handler(struct acpi_device *device)
> +{
> +       struct acpi_hardware_id *hwid;
> +       int ret = 0;
> +
> +       list_for_each_entry(hwid, &device->pnp.ids, list) {
> +               ret = acpi_scan_do_attach_handler(device, hwid->id);
> +               if (ret)
> +                       break;
> +
> +       }
>         return ret;
>  }
>
>

Looks like right to honor the order in pnp.ids.

so there is same problem with acpi_bus_match/acpi_match_device_ids
that need to fixed?

Yinghai
