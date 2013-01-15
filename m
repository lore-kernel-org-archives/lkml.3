Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384Ab3AOLUL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 06:20:11 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:41164 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963Ab3AOLUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 06:20:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v8 14/22] ACPI: update ej_event interface to take acpi_device
Date: Tue, 15 Jan 2013 12:26:01 +0100
Message-ID: <3209605.7vX7Iug6cS@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQUb7d2Sud6gGkqW+aJ-rVi2nUF=nGK6_Afzf8VE7K-dDw@mail.gmail.com>
References: <1357944049-29620-1-git-send-email-yinghai@kernel.org> <1908840.G1WFmde11m@vostro.rjw.lan> <CAE9FiQUb7d2Sud6gGkqW+aJ-rVi2nUF=nGK6_Afzf8VE7K-dDw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 14, 2013 10:55:49 PM Yinghai Lu wrote:
> On Sat, Jan 12, 2013 at 3:40 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Friday, January 11, 2013 02:40:41 PM Yinghai Lu wrote:
> >> Should use acpi_device pointer directly instead of use handle and
> >> get the device pointer again later.
> >
> > Looks good.
> >
> > I can take this one right now if you want.
> 
> yes, in acpi-scan branch?
> 
> othewise i can not base on pci/next again.

OK

So I think there will be more patches in acpi-scan you'll need anyway, so
I'll put this one on that branch too.

Thanks,
Rafael


> >> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >> ---
> >>  drivers/acpi/acpi_memhotplug.c  |    2 +-
> >>  drivers/acpi/processor_driver.c |    2 +-
> >>  drivers/acpi/scan.c             |   14 ++++----------
> >>  include/acpi/acpi_bus.h         |    2 +-
> >>  4 files changed, 7 insertions(+), 13 deletions(-)
> >>
> >> diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
> >> index 327ab44..eaddb7a 100644
> >> --- a/drivers/acpi/acpi_memhotplug.c
> >> +++ b/drivers/acpi/acpi_memhotplug.c
> >> @@ -361,7 +361,7 @@ static void acpi_memory_device_notify(acpi_handle handle, u32 event, void *data)
> >>                       break;
> >>               }
> >>
> >> -             ej_event->handle = handle;
> >> +             ej_event->device = device;
> >>               ej_event->event = ACPI_NOTIFY_EJECT_REQUEST;
> >>               acpi_os_hotplug_execute(acpi_bus_hot_remove_device,
> >>                                       (void *)ej_event);
> >> diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
> >> index 0777663..a24ee43 100644
> >> --- a/drivers/acpi/processor_driver.c
> >> +++ b/drivers/acpi/processor_driver.c
> >> @@ -733,7 +733,7 @@ static void acpi_processor_hotplug_notify(acpi_handle handle,
> >>                       break;
> >>               }
> >>
> >> -             ej_event->handle = handle;
> >> +             ej_event->device = device;
> >>               ej_event->event = ACPI_NOTIFY_EJECT_REQUEST;
> >>               acpi_os_hotplug_execute(acpi_bus_hot_remove_device,
> >>                                       (void *)ej_event);
> >> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> >> index 8883539..f4c6305 100644
> >> --- a/drivers/acpi/scan.c
> >> +++ b/drivers/acpi/scan.c
> >> @@ -116,20 +116,14 @@ static DEVICE_ATTR(modalias, 0444, acpi_device_modalias_show, NULL);
> >>  void acpi_bus_hot_remove_device(void *context)
> >>  {
> >>       struct acpi_eject_event *ej_event = (struct acpi_eject_event *) context;
> >> -     struct acpi_device *device;
> >> -     acpi_handle handle = ej_event->handle;
> >> +     struct acpi_device *device = ej_event->device;
> >> +     acpi_handle handle = device->handle;
> >>       acpi_handle temp;
> >>       struct acpi_object_list arg_list;
> >>       union acpi_object arg;
> >>       acpi_status status = AE_OK;
> >>       u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE; /* default */
> >>
> >> -     if (acpi_bus_get_device(handle, &device))
> >> -             goto err_out;
> >> -
> >> -     if (!device)
> >> -             goto err_out;
> >> -
> >>       ACPI_DEBUG_PRINT((ACPI_DB_INFO,
> >>               "Hot-removing device %s...\n", dev_name(&device->dev)));
> >>
> >> @@ -215,7 +209,7 @@ acpi_eject_store(struct device *d, struct device_attribute *attr,
> >>               goto err;
> >>       }
> >>
> >> -     ej_event->handle = acpi_device->handle;
> >> +     ej_event->device = acpi_device;
> >>       if (acpi_device->flags.eject_pending) {
> >>               /* event originated from ACPI eject notification */
> >>               ej_event->event = ACPI_NOTIFY_EJECT_REQUEST;
> >> @@ -223,7 +217,7 @@ acpi_eject_store(struct device *d, struct device_attribute *attr,
> >>       } else {
> >>               /* event originated from user */
> >>               ej_event->event = ACPI_OST_EC_OSPM_EJECT;
> >> -             (void) acpi_evaluate_hotplug_ost(ej_event->handle,
> >> +             (void) acpi_evaluate_hotplug_ost(acpi_device->handle,
> >>                       ej_event->event, ACPI_OST_SC_EJECT_IN_PROGRESS, NULL);
> >>       }
> >>
> >> diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
> >> index 2246ba9..181ff2d 100644
> >> --- a/include/acpi/acpi_bus.h
> >> +++ b/include/acpi/acpi_bus.h
> >> @@ -309,7 +309,7 @@ struct acpi_bus_event {
> >>  };
> >>
> >>  struct acpi_eject_event {
> >> -     acpi_handle     handle;
> >> +     struct acpi_device      *device;
> >>       u32             event;
> >>  };
> >>
> >>
> > --
> > I speak only for myself.
> > Rafael J. Wysocki, Intel Open Source Technology Center.
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
