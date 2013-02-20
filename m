Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964785Ab3BTNU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 08:20:56 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:40265 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934923Ab3BTNUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 08:20:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Jiang Liu <liuj97@gmail.com>
Subject: Re: [PATCH 2/7] ACPI / scan: Introduce common code for ACPI-based device hotplug
Date: Wed, 20 Feb 2013 14:27:30 +0100
Message-ID: <1502998.UgYRH5gaN4@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51232557.2050302@jp.fujitsu.com>
References: <3260206.bhaAobGhpZ@vostro.rjw.lan> <51231EFC.5080006@jp.fujitsu.com> <51232557.2050302@jp.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 19, 2013 04:10:15 PM Yasuaki Ishimatsu wrote:
> 2013/02/19 15:43, Yasuaki Ishimatsu wrote:
> > Hi Rafael,
> >
> > I have comments. Please see below.
> >
> > 2013/02/18 0:21, Rafael J. Wysocki wrote:
> >> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >>
> >> Multiple drivers handling hotplug-capable ACPI device nodes install
> >> notify handlers covering the same types of events in a very similar
> >> way.  Moreover, those handlers are installed in separate namespace
> >> walks, although that really should be done during namespace scans
> >> carried out by acpi_bus_scan().  This leads to substantial code
> >> duplication, unnecessary overhead and behavior that is hard to
> >> follow.
> >>
> >> For this reason, introduce common code in drivers/acpi/scan.c for
> >> handling hotplug-related notification and carrying out device
> >> insertion and eject operations in a generic fashion, such that it
> >> may be used by all of the relevant drivers in the future.  To cover
> >> the existing differences between those drivers introduce struct
> >> acpi_hotplug_profile for representing collections of hotplug
> >> settings associated with different ACPI scan handlers that can be
> >> used by the drivers to make the common code reflect their current
> >> behavior.
> >>
> >> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >> ---
> >>   drivers/acpi/scan.c     |  271 +++++++++++++++++++++++++++++++++++++-----------
> >>   include/acpi/acpi_bus.h |    7 +
> >>   2 files changed, 220 insertions(+), 58 deletions(-)
> >>
[...]
> 
> >> +static void acpi_scan_bus_device_check(acpi_handle handle, u32 ost_source)
> >> +{
> >> +    struct acpi_device *device = NULL;
> >> +    u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
> >> +    int error;
> >> +
> >> +    mutex_lock(&acpi_scan_lock);
> >> +
> >> +    acpi_bus_get_device(handle, &device);
> >> +    if (device) {
> >> +        dev_warn(&device->dev, "Attempt to re-insert\n");
> >> +        goto out;
> >> +    }
> >> +    acpi_evaluate_hotplug_ost(handle, ost_source,
> >> +                  ACPI_OST_SC_INSERT_IN_PROGRESS, NULL);
> >> +    ost_source = ACPI_OST_EC_OSPM_INSERTION;
> >> +    error = acpi_bus_scan(handle);
> >> +    if (error) {
> >> +        acpi_handle_warn(handle, "Namespace scan failure\n");
> >> +        goto out;
> >> +    }
> >> +    error = acpi_bus_get_device(handle, &device);
> >> +    if (error) {
> >> +        acpi_handle_warn(handle, "Missing device node object\n");
> >> +        goto out;
> >> +    }
> >> +    ost_code = ACPI_OST_SC_SUCCESS;
> >> +    if (device->handler && device->handler->hotplug.uevents)
> >> +        kobject_uevent(&device->dev.kobj, KOBJ_ONLINE);
> >>
> >>    out:
> >> +    acpi_evaluate_hotplug_ost(handle, ost_source, ost_code, NULL);
> >> +    mutex_unlock(&acpi_scan_lock);
> >> +}
> 
> Why don't you check _STA method in acpi_scan_bus_device_check()?
> When hot adding new device, we must check _STA method of the device.

Yes, which is going to happen in acpi_bus_scan().

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
