Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934904Ab3BNUF6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 15:05:58 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:64827 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758666Ab3BNUFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 15:05:55 -0500
MIME-Version: 1.0
In-Reply-To: <1459286.L93riBCyLC@vostro.rjw.lan>
References: <1837481.7dT8hTZ4MT@vostro.rjw.lan>
	<1459286.L93riBCyLC@vostro.rjw.lan>
Date: Thu, 14 Feb 2013 12:05:43 -0800
X-Google-Sender-Auth: A3zQhP7_a5R496ssz3XkGSA5FlM
Message-ID: <CAE9FiQW344Q3t6VJYTYTCL_LOvsWFktkzf1doHKdspU-LGU2MA@mail.gmail.com>
Subject: Re: [Update][PATCH] ACPI / hotplug: Fix concurrency issues and memory leaks
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <liuj97@gmail.com>,
        Toshi Kani <toshi.kani@hp.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Myron Stowe <mstowe@redhat.com>, linux-pci@vger.kernel.org
Content-Type: multipart/mixed; boundary=14dae9340a7fb3ecfe04d5b4c809
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--14dae9340a7fb3ecfe04d5b4c809
Content-Type: text/plain; charset=ISO-8859-1

On Wed, Feb 13, 2013 at 5:16 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> This changeset is aimed at fixing a few different but related
> problems in the ACPI hotplug infrastructure.
>
> First of all, since notify handlers may be run in parallel with
> acpi_bus_scan(), acpi_bus_trim() and acpi_bus_hot_remove_device()
> and some of them are installed for ACPI handles that have no struct
> acpi_device objects attached (i.e. before those objects are created),
> those notify handlers have to take acpi_scan_lock to prevent races
> from taking place (e.g. a struct acpi_device is found to be present
> for the given ACPI handle, but right after that it is removed by
> acpi_bus_trim() running in parallel to the given notify handler).
> Moreover, since some of them call acpi_bus_scan() and
> acpi_bus_trim(), this leads to the conclusion that acpi_scan_lock
> should be acquired by the callers of these two funtions rather by
> these functions themselves.
>
> For these reasons, make all notify handlers that can handle device
> addition and eject events take acpi_scan_lock and remove the
> acpi_scan_lock locking from acpi_bus_scan() and acpi_bus_trim().
> Accordingly, update all of their users to make sure that they
> are always called under acpi_scan_lock.
>
> Furthermore, since eject operations are carried out asynchronously
> with respect to the notify events that trigger them, with the help
> of acpi_bus_hot_remove_device(), even if notify handlers take the
> ACPI scan lock, it still is possible that, for example,
> acpi_bus_trim() will run between acpi_bus_hot_remove_device() and
> the notify handler that scheduled its execution and that
> acpi_bus_trim() will remove the device node passed to
> acpi_bus_hot_remove_device() for ejection.  In that case, the struct
> acpi_device object obtained by acpi_bus_hot_remove_device() will be
> invalid and not-so-funny things will ensue.  To protect agaist that,
> make the users of acpi_bus_hot_remove_device() run get_device() on
> ACPI device node objects that are about to be passed to it and make
> acpi_bus_hot_remove_device() run put_device() on them and check if
> their ACPI handles are not NULL (make acpi_device_unregister() clear
> the device nodes' ACPI handles for that check to work).
>
> Finally, observe that acpi_os_hotplug_execute() actually can fail,
> in which case its caller ought to free memory allocated for the
> context object to prevent leaks from happening.  It also needs to
> run put_device() on the device node that it ran get_device() on
> previously in that case.  Modify the code accordingly.
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Acked-by: Yinghai Lu <yinghai@kernel.org>
> ---
>
> This includes fixes for two issues spotted by Yasuaki Ishimatsu.
>

this one will make pci/next and pm/linux-next conflicts

Please check if attached fix is right.

Thanks

Yinghai

> Thanks,
> Rafael
>
> ---
>  drivers/acpi/acpi_memhotplug.c     |   56 +++++++++++++++++++-----------
>  drivers/acpi/container.c           |   12 ++++--
>  drivers/acpi/dock.c                |   19 ++++++++--
>  drivers/acpi/processor_driver.c    |   24 +++++++++---
>  drivers/acpi/scan.c                |   69 +++++++++++++++++++++++++------------
>  drivers/pci/hotplug/acpiphp_glue.c |    6 +++
>  drivers/pci/hotplug/sgi_hotplug.c  |    5 ++
>  include/acpi/acpi_bus.h            |    3 +
>  8 files changed, 139 insertions(+), 55 deletions(-)
>
> Index: test/drivers/acpi/scan.c
> ===================================================================
> --- test.orig/drivers/acpi/scan.c
> +++ test/drivers/acpi/scan.c
> @@ -42,6 +42,18 @@ struct acpi_device_bus_id{
>         struct list_head node;
>  };
>
> +void acpi_scan_lock_acquire(void)
> +{
> +       mutex_lock(&acpi_scan_lock);
> +}
> +EXPORT_SYMBOL_GPL(acpi_scan_lock_acquire);
> +
> +void acpi_scan_lock_release(void)
> +{
> +       mutex_unlock(&acpi_scan_lock);
> +}
> +EXPORT_SYMBOL_GPL(acpi_scan_lock_release);
> +
>  int acpi_scan_add_handler(struct acpi_scan_handler *handler)
>  {
>         if (!handler || !handler->attach)
> @@ -95,8 +107,6 @@ acpi_device_modalias_show(struct device
>  }
>  static DEVICE_ATTR(modalias, 0444, acpi_device_modalias_show, NULL);
>
> -static void __acpi_bus_trim(struct acpi_device *start);
> -
>  /**
>   * acpi_bus_hot_remove_device: hot-remove a device and its children
>   * @context: struct acpi_eject_event pointer (freed in this func)
> @@ -107,7 +117,7 @@ static void __acpi_bus_trim(struct acpi_
>   */
>  void acpi_bus_hot_remove_device(void *context)
>  {
> -       struct acpi_eject_event *ej_event = (struct acpi_eject_event *) context;
> +       struct acpi_eject_event *ej_event = context;
>         struct acpi_device *device = ej_event->device;
>         acpi_handle handle = device->handle;
>         acpi_handle temp;
> @@ -118,11 +128,19 @@ void acpi_bus_hot_remove_device(void *co
>
>         mutex_lock(&acpi_scan_lock);
>
> +       /* If there is no handle, the device node has been unregistered. */
> +       if (!device->handle) {
> +               dev_dbg(&device->dev, "ACPI handle missing\n");
> +               put_device(&device->dev);
> +               goto out;
> +       }
> +
>         ACPI_DEBUG_PRINT((ACPI_DB_INFO,
>                 "Hot-removing device %s...\n", dev_name(&device->dev)));
>
> -       __acpi_bus_trim(device);
> -       /* Device node has been released. */
> +       acpi_bus_trim(device);
> +       /* Device node has been unregistered. */
> +       put_device(&device->dev);
>         device = NULL;
>
>         if (ACPI_SUCCESS(acpi_get_handle(handle, "_LCK", &temp))) {
> @@ -151,6 +169,7 @@ void acpi_bus_hot_remove_device(void *co
>                                           ost_code, NULL);
>         }
>
> + out:
>         mutex_unlock(&acpi_scan_lock);
>         kfree(context);
>         return;
> @@ -212,6 +231,7 @@ acpi_eject_store(struct device *d, struc
>                 goto err;
>         }
>
> +       get_device(&acpi_device->dev);
>         ej_event->device = acpi_device;
>         if (acpi_device->flags.eject_pending) {
>                 /* event originated from ACPI eject notification */
> @@ -224,7 +244,11 @@ acpi_eject_store(struct device *d, struc
>                         ej_event->event, ACPI_OST_SC_EJECT_IN_PROGRESS, NULL);
>         }
>
> -       acpi_os_hotplug_execute(acpi_bus_hot_remove_device, (void *)ej_event);
> +       status = acpi_os_hotplug_execute(acpi_bus_hot_remove_device, ej_event);
> +       if (ACPI_FAILURE(status)) {
> +               put_device(&acpi_device->dev);
> +               kfree(ej_event);
> +       }
>  err:
>         return ret;
>  }
> @@ -779,6 +803,7 @@ static void acpi_device_unregister(struc
>          * no more references.
>          */
>         acpi_device_set_power(device, ACPI_STATE_D3_COLD);
> +       device->handle = NULL;
>         put_device(&device->dev);
>  }
>
> @@ -1626,14 +1651,14 @@ static acpi_status acpi_bus_device_attac
>   * there has been a real error.  There just have been no suitable ACPI objects
>   * in the table trunk from which the kernel could create a device and add an
>   * appropriate driver.
> + *
> + * Must be called under acpi_scan_lock.
>   */
>  int acpi_bus_scan(acpi_handle handle)
>  {
>         void *device = NULL;
>         int error = 0;
>
> -       mutex_lock(&acpi_scan_lock);
> -
>         if (ACPI_SUCCESS(acpi_bus_check_add(handle, 0, NULL, &device)))
>                 acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
>                                     acpi_bus_check_add, NULL, NULL, &device);
> @@ -1644,7 +1669,6 @@ int acpi_bus_scan(acpi_handle handle)
>                 acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
>                                     acpi_bus_device_attach, NULL, NULL, NULL);
>
> -       mutex_unlock(&acpi_scan_lock);
>         return error;
>  }
>  EXPORT_SYMBOL(acpi_bus_scan);
> @@ -1681,7 +1705,13 @@ static acpi_status acpi_bus_remove(acpi_
>         return AE_OK;
>  }
>
> -static void __acpi_bus_trim(struct acpi_device *start)
> +/**
> + * acpi_bus_trim - Remove ACPI device node and all of its descendants
> + * @start: Root of the ACPI device nodes subtree to remove.
> + *
> + * Must be called under acpi_scan_lock.
> + */
> +void acpi_bus_trim(struct acpi_device *start)
>  {
>         /*
>          * Execute acpi_bus_device_detach() as a post-order callback to detach
> @@ -1698,13 +1728,6 @@ static void __acpi_bus_trim(struct acpi_
>                             acpi_bus_remove, NULL, NULL);
>         acpi_bus_remove(start->handle, 0, NULL, NULL);
>  }
> -
> -void acpi_bus_trim(struct acpi_device *start)
> -{
> -       mutex_lock(&acpi_scan_lock);
> -       __acpi_bus_trim(start);
> -       mutex_unlock(&acpi_scan_lock);
> -}
>  EXPORT_SYMBOL_GPL(acpi_bus_trim);
>
>  static int acpi_bus_scan_fixed(void)
> @@ -1761,23 +1784,27 @@ int __init acpi_scan_init(void)
>         acpi_csrt_init();
>         acpi_container_init();
>
> +       mutex_lock(&acpi_scan_lock);
>         /*
>          * Enumerate devices in the ACPI namespace.
>          */
>         result = acpi_bus_scan(ACPI_ROOT_OBJECT);
>         if (result)
> -               return result;
> +               goto out;
>
>         result = acpi_bus_get_device(ACPI_ROOT_OBJECT, &acpi_root);
>         if (result)
> -               return result;
> +               goto out;
>
>         result = acpi_bus_scan_fixed();
>         if (result) {
>                 acpi_device_unregister(acpi_root);
> -               return result;
> +               goto out;
>         }
>
>         acpi_update_all_gpes();
> -       return 0;
> +
> + out:
> +       mutex_unlock(&acpi_scan_lock);
> +       return result;
>  }
> Index: test/include/acpi/acpi_bus.h
> ===================================================================
> --- test.orig/include/acpi/acpi_bus.h
> +++ test/include/acpi/acpi_bus.h
> @@ -395,6 +395,9 @@ int acpi_bus_receive_event(struct acpi_b
>  static inline int acpi_bus_generate_proc_event(struct acpi_device *device, u8 type, int data)
>         { return 0; }
>  #endif
> +
> +void acpi_scan_lock_acquire(void);
> +void acpi_scan_lock_release(void);
>  int acpi_scan_add_handler(struct acpi_scan_handler *handler);
>  int acpi_bus_register_driver(struct acpi_driver *driver);
>  void acpi_bus_unregister_driver(struct acpi_driver *driver);
> Index: test/drivers/acpi/acpi_memhotplug.c
> ===================================================================
> --- test.orig/drivers/acpi/acpi_memhotplug.c
> +++ test/drivers/acpi/acpi_memhotplug.c
> @@ -153,14 +153,16 @@ acpi_memory_get_device_resources(struct
>         return 0;
>  }
>
> -static int
> -acpi_memory_get_device(acpi_handle handle,
> -                      struct acpi_memory_device **mem_device)
> +static int acpi_memory_get_device(acpi_handle handle,
> +                                 struct acpi_memory_device **mem_device)
>  {
>         struct acpi_device *device = NULL;
> -       int result;
> +       int result = 0;
> +
> +       acpi_scan_lock_acquire();
>
> -       if (!acpi_bus_get_device(handle, &device) && device)
> +       acpi_bus_get_device(handle, &device);
> +       if (device)
>                 goto end;
>
>         /*
> @@ -169,23 +171,28 @@ acpi_memory_get_device(acpi_handle handl
>          */
>         result = acpi_bus_scan(handle);
>         if (result) {
> -               acpi_handle_warn(handle, "Cannot add acpi bus\n");
> -               return -EINVAL;
> +               acpi_handle_warn(handle, "ACPI namespace scan failed\n");
> +               result = -EINVAL;
> +               goto out;
>         }
>         result = acpi_bus_get_device(handle, &device);
>         if (result) {
>                 acpi_handle_warn(handle, "Missing device object\n");
> -               return -EINVAL;
> +               result = -EINVAL;
> +               goto out;
>         }
>
> -      end:
> + end:
>         *mem_device = acpi_driver_data(device);
>         if (!(*mem_device)) {
>                 dev_err(&device->dev, "driver data not found\n");
> -               return -ENODEV;
> +               result = -ENODEV;
> +               goto out;
>         }
>
> -       return 0;
> + out:
> +       acpi_scan_lock_release();
> +       return result;
>  }
>
>  static int acpi_memory_check_device(struct acpi_memory_device *mem_device)
> @@ -305,6 +312,7 @@ static void acpi_memory_device_notify(ac
>         struct acpi_device *device;
>         struct acpi_eject_event *ej_event = NULL;
>         u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE; /* default */
> +       acpi_status status;
>
>         switch (event) {
>         case ACPI_NOTIFY_BUS_CHECK:
> @@ -327,29 +335,40 @@ static void acpi_memory_device_notify(ac
>                 ACPI_DEBUG_PRINT((ACPI_DB_INFO,
>                                   "\nReceived EJECT REQUEST notification for device\n"));
>
> +               status = AE_ERROR;
> +               acpi_scan_lock_acquire();
> +
>                 if (acpi_bus_get_device(handle, &device)) {
>                         acpi_handle_err(handle, "Device doesn't exist\n");
> -                       break;
> +                       goto unlock;
>                 }
>                 mem_device = acpi_driver_data(device);
>                 if (!mem_device) {
>                         acpi_handle_err(handle, "Driver Data is NULL\n");
> -                       break;
> +                       goto unlock;
>                 }
>
>                 ej_event = kmalloc(sizeof(*ej_event), GFP_KERNEL);
>                 if (!ej_event) {
>                         pr_err(PREFIX "No memory, dropping EJECT\n");
> -                       break;
> +                       goto unlock;
>                 }
>
> +               get_device(&device->dev);
>                 ej_event->device = device;
>                 ej_event->event = ACPI_NOTIFY_EJECT_REQUEST;
> -               acpi_os_hotplug_execute(acpi_bus_hot_remove_device,
> -                                       (void *)ej_event);
> +               /* The eject is carried out asynchronously. */
> +               status = acpi_os_hotplug_execute(acpi_bus_hot_remove_device,
> +                                                ej_event);
> +               if (ACPI_FAILURE(status)) {
> +                       put_device(&device->dev);
> +                       kfree(ej_event);
> +               }
>
> -               /* eject is performed asynchronously */
> -               return;
> + unlock:
> +               acpi_scan_lock_release();
> +               if (ACPI_SUCCESS(status))
> +                       return;
>         default:
>                 ACPI_DEBUG_PRINT((ACPI_DB_INFO,
>                                   "Unsupported event [0x%x]\n", event));
> @@ -360,7 +379,6 @@ static void acpi_memory_device_notify(ac
>
>         /* Inform firmware that the hotplug operation has completed */
>         (void) acpi_evaluate_hotplug_ost(handle, event, ost_code, NULL);
> -       return;
>  }
>
>  static void acpi_memory_device_free(struct acpi_memory_device *mem_device)
> Index: test/drivers/acpi/processor_driver.c
> ===================================================================
> --- test.orig/drivers/acpi/processor_driver.c
> +++ test/drivers/acpi/processor_driver.c
> @@ -683,8 +683,11 @@ static void acpi_processor_hotplug_notif
>         struct acpi_device *device = NULL;
>         struct acpi_eject_event *ej_event = NULL;
>         u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE; /* default */
> +       acpi_status status;
>         int result;
>
> +       acpi_scan_lock_acquire();
> +
>         switch (event) {
>         case ACPI_NOTIFY_BUS_CHECK:
>         case ACPI_NOTIFY_DEVICE_CHECK:
> @@ -733,25 +736,32 @@ static void acpi_processor_hotplug_notif
>                         break;
>                 }
>
> +               get_device(&device->dev);
>                 ej_event->device = device;
>                 ej_event->event = ACPI_NOTIFY_EJECT_REQUEST;
> -               acpi_os_hotplug_execute(acpi_bus_hot_remove_device,
> -                                       (void *)ej_event);
> -
> -               /* eject is performed asynchronously */
> -               return;
> +               /* The eject is carried out asynchronously. */
> +               status = acpi_os_hotplug_execute(acpi_bus_hot_remove_device,
> +                                                ej_event);
> +               if (ACPI_FAILURE(status)) {
> +                       put_device(&device->dev);
> +                       kfree(ej_event);
> +                       break;
> +               }
> +               goto out;
>
>         default:
>                 ACPI_DEBUG_PRINT((ACPI_DB_INFO,
>                                   "Unsupported event [0x%x]\n", event));
>
>                 /* non-hotplug event; possibly handled by other handler */
> -               return;
> +               goto out;
>         }
>
>         /* Inform firmware that the hotplug operation has completed */
>         (void) acpi_evaluate_hotplug_ost(handle, event, ost_code, NULL);
> -       return;
> +
> + out:
> +       acpi_scan_lock_release();
>  }
>
>  static acpi_status is_processor_device(acpi_handle handle)
> Index: test/drivers/acpi/container.c
> ===================================================================
> --- test.orig/drivers/acpi/container.c
> +++ test/drivers/acpi/container.c
> @@ -88,6 +88,8 @@ static void container_notify_cb(acpi_han
>         acpi_status status;
>         u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE; /* default */
>
> +       acpi_scan_lock_acquire();
> +
>         switch (type) {
>         case ACPI_NOTIFY_BUS_CHECK:
>                 /* Fall through */
> @@ -103,7 +105,7 @@ static void container_notify_cb(acpi_han
>                                 /* device exist and this is a remove request */
>                                 device->flags.eject_pending = 1;
>                                 kobject_uevent(&device->dev.kobj, KOBJ_OFFLINE);
> -                               return;
> +                               goto out;
>                         }
>                         break;
>                 }
> @@ -130,18 +132,20 @@ static void container_notify_cb(acpi_han
>                 if (!acpi_bus_get_device(handle, &device) && device) {
>                         device->flags.eject_pending = 1;
>                         kobject_uevent(&device->dev.kobj, KOBJ_OFFLINE);
> -                       return;
> +                       goto out;
>                 }
>                 break;
>
>         default:
>                 /* non-hotplug event; possibly handled by other handler */
> -               return;
> +               goto out;
>         }
>
>         /* Inform firmware that the hotplug operation has completed */
>         (void) acpi_evaluate_hotplug_ost(handle, type, ost_code, NULL);
> -       return;
> +
> + out:
> +       acpi_scan_lock_release();
>  }
>
>  static bool is_container(acpi_handle handle)
> Index: test/drivers/acpi/dock.c
> ===================================================================
> --- test.orig/drivers/acpi/dock.c
> +++ test/drivers/acpi/dock.c
> @@ -744,7 +744,9 @@ static void acpi_dock_deferred_cb(void *
>  {
>         struct dock_data *data = context;
>
> +       acpi_scan_lock_acquire();
>         dock_notify(data->handle, data->event, data->ds);
> +       acpi_scan_lock_release();
>         kfree(data);
>  }
>
> @@ -757,20 +759,31 @@ static int acpi_dock_notifier_call(struc
>         if (event != ACPI_NOTIFY_BUS_CHECK && event != ACPI_NOTIFY_DEVICE_CHECK
>            && event != ACPI_NOTIFY_EJECT_REQUEST)
>                 return 0;
> +
> +       acpi_scan_lock_acquire();
> +
>         list_for_each_entry(dock_station, &dock_stations, sibling) {
>                 if (dock_station->handle == handle) {
>                         struct dock_data *dd;
> +                       acpi_status status;
>
>                         dd = kmalloc(sizeof(*dd), GFP_KERNEL);
>                         if (!dd)
> -                               return 0;
> +                               break;
> +
>                         dd->handle = handle;
>                         dd->event = event;
>                         dd->ds = dock_station;
> -                       acpi_os_hotplug_execute(acpi_dock_deferred_cb, dd);
> -                       return 0 ;
> +                       status = acpi_os_hotplug_execute(acpi_dock_deferred_cb,
> +                                                        dd);
> +                       if (ACPI_FAILURE(status))
> +                               kfree(dd);
> +
> +                       break;
>                 }
>         }
> +
> +       acpi_scan_lock_release();
>         return 0;
>  }
>
> Index: test/drivers/pci/hotplug/acpiphp_glue.c
> ===================================================================
> --- test.orig/drivers/pci/hotplug/acpiphp_glue.c
> +++ test/drivers/pci/hotplug/acpiphp_glue.c
> @@ -1218,6 +1218,8 @@ static void _handle_hotplug_event_bridge
>         handle = hp_work->handle;
>         type = hp_work->type;
>
> +       acpi_scan_lock_acquire();
> +
>         if (acpi_bus_get_device(handle, &device)) {
>                 /* This bridge must have just been physically inserted */
>                 handle_bridge_insertion(handle, type);
> @@ -1295,6 +1297,7 @@ static void _handle_hotplug_event_bridge
>         }
>
>  out:
> +       acpi_scan_lock_release();
>         kfree(hp_work); /* allocated in handle_hotplug_event_bridge */
>  }
>
> @@ -1341,6 +1344,8 @@ static void _handle_hotplug_event_func(s
>
>         func = (struct acpiphp_func *)context;
>
> +       acpi_scan_lock_acquire();
> +
>         switch (type) {
>         case ACPI_NOTIFY_BUS_CHECK:
>                 /* bus re-enumerate */
> @@ -1371,6 +1376,7 @@ static void _handle_hotplug_event_func(s
>                 break;
>         }
>
> +       acpi_scan_lock_release();
>         kfree(hp_work); /* allocated in handle_hotplug_event_func */
>  }
>
> Index: test/drivers/pci/hotplug/sgi_hotplug.c
> ===================================================================
> --- test.orig/drivers/pci/hotplug/sgi_hotplug.c
> +++ test/drivers/pci/hotplug/sgi_hotplug.c
> @@ -425,6 +425,7 @@ static int enable_slot(struct hotplug_sl
>                         pdevice = NULL;
>                 }
>
> +               acpi_scan_lock_acquire();
>                 /*
>                  * Walk the rootbus node's immediate children looking for
>                  * the slot's device node(s). There can be more than
> @@ -458,6 +459,7 @@ static int enable_slot(struct hotplug_sl
>                                 }
>                         }
>                 }
> +               acpi_scan_lock_release();
>         }
>
>         /* Call the driver for the new device */
> @@ -508,6 +510,7 @@ static int disable_slot(struct hotplug_s
>                 /* Get the rootbus node pointer */
>                 phandle = PCI_CONTROLLER(slot->pci_bus)->acpi_handle;
>
> +               acpi_scan_lock_acquire();
>                 /*
>                  * Walk the rootbus node's immediate children looking for
>                  * the slot's device node(s). There can be more than
> @@ -538,7 +541,7 @@ static int disable_slot(struct hotplug_s
>                                         acpi_bus_trim(device);
>                         }
>                 }
> -
> +               acpi_scan_lock_release();
>         }
>
>         /* Free the SN resources assigned to the Linux device.*/
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--14dae9340a7fb3ecfe04d5b4c809
Content-Type: application/octet-stream; name="acpi_pci_merge_fix.patch"
Content-Disposition: attachment; filename="acpi_pci_merge_fix.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hd6bupql0

LS0tCiBkcml2ZXJzL2FjcGkvaW50ZXJuYWwuaCAgICAgICAgICAgIHwgICAgNCAtLS0tCiBkcml2
ZXJzL2FjcGkvc2Nhbi5jICAgICAgICAgICAgICAgIHwgICAgNCAtLS0tCiBkcml2ZXJzL3BjaS9o
b3RwbHVnL2FjcGlwaHBfZ2x1ZS5jIHwgICAyOSAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LQogMyBmaWxlcyBjaGFuZ2VkLCAzNyBkZWxldGlvbnMoLSkKCkluZGV4OiBsaW51eC0yLjYvZHJp
dmVycy9hY3BpL2ludGVybmFsLmgKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvZHJpdmVy
cy9hY3BpL2ludGVybmFsLmgKKysrIGxpbnV4LTIuNi9kcml2ZXJzL2FjcGkvaW50ZXJuYWwuaApA
QCAtOTQsMTEgKzk0LDcgQEAgc3RydWN0IGFjcGlfZWMgewogCiBleHRlcm4gc3RydWN0IGFjcGlf
ZWMgKmZpcnN0X2VjOwogCi08PDw8PDw8IEhFQUQKLWludCBhY3BpX3BjaV9yb290X2luaXQodm9p
ZCk7CiB2b2lkIGFjcGlfcGNpX3Jvb3RfaHBfaW5pdCh2b2lkKTsKLT09PT09PT0KLT4+Pj4+Pj4g
cG0vbGludXgtbmV4dAogaW50IGFjcGlfZWNfaW5pdCh2b2lkKTsKIGludCBhY3BpX2VjX2VjZHRf
cHJvYmUodm9pZCk7CiBpbnQgYWNwaV9ib290X2VjX2VuYWJsZSh2b2lkKTsKSW5kZXg6IGxpbnV4
LTIuNi9kcml2ZXJzL2FjcGkvc2Nhbi5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2Ry
aXZlcnMvYWNwaS9zY2FuLmMKKysrIGxpbnV4LTIuNi9kcml2ZXJzL2FjcGkvc2Nhbi5jCkBAIC0x
ODA0LDEzICsxODA0LDkgQEAgaW50IF9faW5pdCBhY3BpX3NjYW5faW5pdCh2b2lkKQogCiAJYWNw
aV91cGRhdGVfYWxsX2dwZXMoKTsKIAotPDw8PDw8PCBIRUFECiAJYWNwaV9wY2lfcm9vdF9ocF9p
bml0KCk7CiAKLQlyZXR1cm4gMDsKLT09PT09PT0KICBvdXQ6CiAJbXV0ZXhfdW5sb2NrKCZhY3Bp
X3NjYW5fbG9jayk7CiAJcmV0dXJuIHJlc3VsdDsKLT4+Pj4+Pj4gcG0vbGludXgtbmV4dAogfQpJ
bmRleDogbGludXgtMi42L2RyaXZlcnMvcGNpL2hvdHBsdWcvYWNwaXBocF9nbHVlLmMKPT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PQotLS0gbGludXgtMi42Lm9yaWcvZHJpdmVycy9wY2kvaG90cGx1Zy9hY3BpcGhwX2dsdWUu
YworKysgbGludXgtMi42L2RyaXZlcnMvcGNpL2hvdHBsdWcvYWNwaXBocF9nbHVlLmMKQEAgLTEx
MzUsMzAgKzExMzUsMTAgQEAgc3RhdGljIHZvaWQgX2hhbmRsZV9ob3RwbHVnX2V2ZW50X2JyaWRn
ZQogCWhwX3dvcmsgPSBjb250YWluZXJfb2Yod29yaywgc3RydWN0IGFjcGlfaHBfd29yaywgd29y
ayk7CiAJaGFuZGxlID0gaHBfd29yay0+aGFuZGxlOwogCXR5cGUgPSBocF93b3JrLT50eXBlOwot
PDw8PDw8PCBIRUFECiAJYnJpZGdlID0gKHN0cnVjdCBhY3BpcGhwX2JyaWRnZSAqKWhwX3dvcmst
PmNvbnRleHQ7Ci09PT09PT09CiAKIAlhY3BpX3NjYW5fbG9ja19hY3F1aXJlKCk7CiAKLQlpZiAo
YWNwaV9idXNfZ2V0X2RldmljZShoYW5kbGUsICZkZXZpY2UpKSB7Ci0JCS8qIFRoaXMgYnJpZGdl
IG11c3QgaGF2ZSBqdXN0IGJlZW4gcGh5c2ljYWxseSBpbnNlcnRlZCAqLwotCQloYW5kbGVfYnJp
ZGdlX2luc2VydGlvbihoYW5kbGUsIHR5cGUpOwotCQlnb3RvIG91dDsKLQl9Ci0KLQlicmlkZ2Ug
PSBhY3BpcGhwX2hhbmRsZV90b19icmlkZ2UoaGFuZGxlKTsKLQlpZiAodHlwZSA9PSBBQ1BJX05P
VElGWV9CVVNfQ0hFQ0spIHsKLQkJYWNwaV93YWxrX25hbWVzcGFjZShBQ1BJX1RZUEVfREVWSUNF
LCBoYW5kbGUsIEFDUElfVUlOVDMyX01BWCwKLQkJCWNvdW50X3N1Yl9icmlkZ2VzLCBOVUxMLCAm
bnVtX3N1Yl9icmlkZ2VzLCBOVUxMKTsKLQl9Ci0KLQlpZiAoIWJyaWRnZSAmJiAhbnVtX3N1Yl9i
cmlkZ2VzKSB7Ci0JCWVycigiY2Fubm90IGdldCBicmlkZ2UgaW5mb1xuIik7Ci0JCWdvdG8gb3V0
OwotCX0KLT4+Pj4+Pj4gcG0vbGludXgtbmV4dAotCiAJYWNwaV9nZXRfbmFtZShoYW5kbGUsIEFD
UElfRlVMTF9QQVRITkFNRSwgJmJ1ZmZlcik7CiAKIAlzd2l0Y2ggKHR5cGUpIHsKQEAgLTEyMTMs
MTEgKzExOTMsNyBAQCBzdGF0aWMgdm9pZCBfaGFuZGxlX2hvdHBsdWdfZXZlbnRfYnJpZGdlCiAJ
CWJyZWFrOwogCX0KIAotPDw8PDw8PCBIRUFECi09PT09PT09Ci1vdXQ6CiAJYWNwaV9zY2FuX2xv
Y2tfcmVsZWFzZSgpOwotPj4+Pj4+PiBwbS9saW51eC1uZXh0CiAJa2ZyZWUoaHBfd29yayk7IC8q
IGFsbG9jYXRlZCBpbiBoYW5kbGVfaG90cGx1Z19ldmVudF9icmlkZ2UgKi8KIH0KIApAQCAtMTI2
MCwxMyArMTIzNiw4IEBAIHN0YXRpYyB2b2lkIF9oYW5kbGVfaG90cGx1Z19ldmVudF9mdW5jKHMK
IAogCWFjcGlfZ2V0X25hbWUoaGFuZGxlLCBBQ1BJX0ZVTExfUEFUSE5BTUUsICZidWZmZXIpOwog
Ci08PDw8PDw8IEhFQUQKLT09PT09PT0KLQlmdW5jID0gKHN0cnVjdCBhY3BpcGhwX2Z1bmMgKilj
b250ZXh0OwotCiAJYWNwaV9zY2FuX2xvY2tfYWNxdWlyZSgpOwogCi0+Pj4+Pj4+IHBtL2xpbnV4
LW5leHQKIAlzd2l0Y2ggKHR5cGUpIHsKIAljYXNlIEFDUElfTk9USUZZX0JVU19DSEVDSzoKIAkJ
LyogYnVzIHJlLWVudW1lcmF0ZSAqLwo=
--14dae9340a7fb3ecfe04d5b4c809--
