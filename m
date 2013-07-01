Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab3GAUWL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 16:22:11 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:54970 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755493Ab3GAUWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 16:22:06 -0400
MIME-Version: 1.0
In-Reply-To: <1771749.8rDXNf8giR@vostro.rjw.lan>
References: <1640211.P0jyS5muX2@vostro.rjw.lan> <1515394.L46AJCfCTt@vostro.rjw.lan>
 <1771749.8rDXNf8giR@vostro.rjw.lan>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 1 Jul 2013 14:21:45 -0600
Message-ID: <CAErSpo6965m7aWMkuuTrgkCRW6nmSbb14abAVXMFAYGrYZQjyQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] ACPI / dock: Rework the handling of notifications
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiang Liu <liuj97@gmail.com>,
        Yinghai Lu <yinghai@kernel.org>,
        "Alexander E. Patrakov" <patrakov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 4:53 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> The ACPI dock driver uses register_acpi_bus_notifier() which
> installs a notifier triggered globally for all system notifications.
> That first of all is inefficient, because the dock driver is only
> interested in notifications associated with the devices it handles,
> but it has to handle all system notifies for all devices.  Moreover,
> it does that even if no docking stations are present in the system
> (CONFIG_ACPI_DOCK set is sufficient for that to happen).  Besides,
> that is inconvenient, because it requires the driver to do extra work
> for each notification to find the target dock station object.
>
> For these reasons, rework the dock driver to install a notify
> handler individually for each dock station in the system using
> acpi_install_notify_handler().  This allows the dock station
> object to be passed directly to the notify handler and makes it
> possible to simplify the dock driver quite a bit.  It also
> reduces the overhead related to the handling of all system
> notifies when CONFIG_ACPI_DOCK is set.

I fully support what you're doing, even though I haven't read it in
enough detail to actually review it.  I'm pretty sure that whatever
you do, you won't make things worse :)

It sounds like you are keeping the approach of "look for certain AML
features to identify a dock, and install notify handlers when you find
one."  I think acpiphp uses a similar approach, and I'm not sure it's
a good one.  The spec is not explicit about how the AML should be
organized, and AML writers are very creative.  I think acpiphp suffers
because it only works with certain arrangements of _ADR, _EJ0, _RMV,
etc., and I think that has led to a brittle design and possibly more
separation between dock and acpiphp than is necessary.

I think it would be better if we *always* had a more generic notify
handler installed and figured out where to route the notification
based on its type and what services are configured in.  The ultimate
handler might do different things based on what methods are present,
of course.

I don't know if this rambling makes sense for docks (or even for
acpiphp), so if it doesn't, feel free to just ignore it :)

Bjorn

> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/acpi/dock.c |   69 ++++++++++++++++++----------------------------------
>  1 file changed, 25 insertions(+), 44 deletions(-)
>
> Index: linux-pm/drivers/acpi/dock.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/dock.c
> +++ linux-pm/drivers/acpi/dock.c
> @@ -718,18 +718,17 @@ static int handle_eject_request(struct d
>
>  /**
>   * dock_notify - act upon an acpi dock notification
> - * @handle: the dock station handle
> + * @ds: dock station
>   * @event: the acpi event
> - * @data: our driver data struct
>   *
>   * If we are notified to dock, then check to see if the dock is
>   * present and then dock.  Notify all drivers of the dock event,
>   * and then hotplug and devices that may need hotplugging.
>   */
> -static void dock_notify(acpi_handle handle, u32 event, void *data)
> +static void dock_notify(struct dock_station *ds, u32 event)
>  {
> -       struct dock_station *ds = data;
> -       struct acpi_device *tmp;
> +       acpi_handle handle = ds->handle;
> +       struct acpi_device *ad;
>         int surprise_removal = 0;
>
>         /*
> @@ -752,8 +751,7 @@ static void dock_notify(acpi_handle hand
>         switch (event) {
>         case ACPI_NOTIFY_BUS_CHECK:
>         case ACPI_NOTIFY_DEVICE_CHECK:
> -               if (!dock_in_progress(ds) && acpi_bus_get_device(ds->handle,
> -                  &tmp)) {
> +               if (!dock_in_progress(ds) && acpi_bus_get_device(handle, &ad)) {
>                         begin_dock(ds);
>                         dock(ds);
>                         if (!dock_present(ds)) {
> @@ -790,9 +788,8 @@ static void dock_notify(acpi_handle hand
>  }
>
>  struct dock_data {
> -       acpi_handle handle;
> -       unsigned long event;
>         struct dock_station *ds;
> +       u32 event;
>  };
>
>  static void acpi_dock_deferred_cb(void *context)
> @@ -800,52 +797,31 @@ static void acpi_dock_deferred_cb(void *
>         struct dock_data *data = context;
>
>         acpi_scan_lock_acquire();
> -       dock_notify(data->handle, data->event, data->ds);
> +       dock_notify(data->ds, data->event);
>         acpi_scan_lock_release();
>         kfree(data);
>  }
>
> -static int acpi_dock_notifier_call(struct notifier_block *this,
> -       unsigned long event, void *data)
> +static void dock_notify_handler(acpi_handle handle, u32 event, void *data)
>  {
> -       struct dock_station *dock_station;
> -       acpi_handle handle = data;
> +       struct dock_data *dd;
>
>         if (event != ACPI_NOTIFY_BUS_CHECK && event != ACPI_NOTIFY_DEVICE_CHECK
>            && event != ACPI_NOTIFY_EJECT_REQUEST)
> -               return 0;
> -
> -       acpi_scan_lock_acquire();
> +               return;
>
> -       list_for_each_entry(dock_station, &dock_stations, sibling) {
> -               if (dock_station->handle == handle) {
> -                       struct dock_data *dd;
> -                       acpi_status status;
> -
> -                       dd = kmalloc(sizeof(*dd), GFP_KERNEL);
> -                       if (!dd)
> -                               break;
> -
> -                       dd->handle = handle;
> -                       dd->event = event;
> -                       dd->ds = dock_station;
> -                       status = acpi_os_hotplug_execute(acpi_dock_deferred_cb,
> -                                                        dd);
> -                       if (ACPI_FAILURE(status))
> -                               kfree(dd);
> -
> -                       break;
> -               }
> +       dd = kmalloc(sizeof(*dd), GFP_KERNEL);
> +       if (dd) {
> +               acpi_status status;
> +
> +               dd->ds = data;
> +               dd->event = event;
> +               status = acpi_os_hotplug_execute(acpi_dock_deferred_cb, dd);
> +               if (ACPI_FAILURE(status))
> +                       kfree(dd);
>         }
> -
> -       acpi_scan_lock_release();
> -       return 0;
>  }
>
> -static struct notifier_block dock_acpi_notifier = {
> -       .notifier_call = acpi_dock_notifier_call,
> -};
> -
>  /**
>   * find_dock_devices - find devices on the dock station
>   * @handle: the handle of the device we are examining
> @@ -979,6 +955,7 @@ static int __init dock_add(acpi_handle h
>         int ret, id;
>         struct dock_station ds, *dock_station;
>         struct platform_device *dd;
> +       acpi_status status;
>
>         id = dock_station_count;
>         memset(&ds, 0, sizeof(ds));
> @@ -1021,6 +998,11 @@ static int __init dock_add(acpi_handle h
>         if (ret)
>                 goto err_rmgroup;
>
> +       status = acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
> +                                            dock_notify_handler, dock_station);
> +       if (ACPI_FAILURE(status))
> +               goto err_rmgroup;
> +
>         dock_station_count++;
>         list_add(&dock_station->sibling, &dock_stations);
>         return 0;
> @@ -1065,7 +1047,6 @@ int __init acpi_dock_init(void)
>                 return 0;
>         }
>
> -       register_acpi_bus_notifier(&dock_acpi_notifier);
>         pr_info(PREFIX "%s: %d docks/bays found\n",
>                 ACPI_DOCK_DRIVER_DESCRIPTION, dock_station_count);
>         return 0;
>
