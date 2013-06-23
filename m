Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018Ab3FWTt1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 15:49:27 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:35652 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab3FWTtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 15:49:23 -0400
MIME-Version: 1.0
In-Reply-To: <1410772.iYNzcAkY0L@vostro.rjw.lan>
References: <2737587.I0nULev1kj@vostro.rjw.lan>
	<15269989.ojxutYs2L1@vostro.rjw.lan>
	<CAE9FiQV7R5mQKEFx+JhE7E1MjWSSxe2+WeK0aN_hVh6sZJ2GdQ@mail.gmail.com>
	<1410772.iYNzcAkY0L@vostro.rjw.lan>
Date: Sun, 23 Jun 2013 12:49:22 -0700
X-Google-Sender-Auth: dSz-hhiLEzsnqqVTp0Jx6t4dUiU
Message-ID: <CAE9FiQWt94D+gwOv3dDOX7m4Wm-tsJyHaLonPmyfU4JLWG6Dzw@mail.gmail.com>
Subject: Re: [PATCH 3/3] ACPI / dock / PCI: Synchronous handling of dock
 events for PCI devices
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

On Sun, Jun 23, 2013 at 2:59 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Saturday, June 22, 2013 05:22:20 PM Yinghai Lu wrote:
>> On Sat, Jun 22, 2013 at 2:25 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> >
>> > To resolve that deadlock use the observation that
>> > unregister_hotplug_dock_device() won't need to acquire hp_lock
>> > if PCI bridges the devices on the dock station depend on are
>> > prevented from being removed prematurely while the first loop in
>> > hotplug_dock_devices() is in progress.
>> >
>> > To make that possible, introduce a mechanism by which the callers of
>> > register_hotplug_dock_device() can provide "init" and "release"
>> > routines that will be executed, respectively, after the addition
>> > and removal of the physical device object associated with the
>> > given ACPI device handle.  Make acpiphp use two new functions,
>> > acpiphp_dock_init() and acpiphp_dock_release(), respectively,
>> > calling get_bridge() and put_bridge() on the PCI bridge holding the
>> > given device, respectively, for this purpose.
>> >
>> > In addition to that, remove the dock station's list of
>> > "hotplug devices" and make the dock code always walk the whole list
>> > of "dependent devices" instead in such a way that the loops in
>> > hotplug_dock_devices() and dock_event() (replacing the loops over
>> > "hotplug devices") will take references to the list entries that
>> > register_hotplug_dock_device() has been called for.  That prevents
>> > the "release" routines associated with those entries from being
>> > called while the given entry is being processed and for PCI
>> > devices this means that their bridges won't be removed (by a
>> > concurrent thread) while hotplug_event_func() handling them is
>> > being executed.
>> ..
>> > -static void
>> > -dock_del_hotplug_device(struct dock_station *ds,
>> > -                       struct dock_dependent_device *dd)
>> > +static void dock_release_hotplug(struct dock_dependent_device *dd)
>> >  {
>> > -       mutex_lock(&ds->hp_lock);
>> > -       list_del(&dd->hotplug_list);
>> > -       mutex_unlock(&ds->hp_lock);
>> > +       void (*release)(void *) = NULL;
>> > +       void *context = NULL;
>> > +
>> > +       mutex_lock(&hotplug_lock);
>> > +
>> > +       if (dd->hp_context && !--dd->hp_refcount) {
>> > +               dd->hp_ops = NULL;
>> > +               context = dd->hp_context;
>> > +               dd->hp_context = NULL;
>> > +               release = dd->hp_release;
>> > +               dd->hp_release = NULL;
>> > +       }
>> > +
>> > +       if (release && context)
>> > +               release(context);
>> > +
>> > +       mutex_unlock(&hotplug_lock);
>> > +}
>> > +
>> > +static void dock_hotplug_event(struct dock_dependent_device *dd, u32 event,
>> > +                              bool uevent)
>> > +{
>> > +       acpi_notify_handler cb = NULL;
>> > +       bool run = false;
>> > +
>> > +       mutex_lock(&hotplug_lock);
>> > +
>> > +       if (dd->hp_context) {
>> > +               run = true;
>> > +               dd->hp_refcount++;
>> > +               if (dd->hp_ops)
>> > +                       cb = uevent ? dd->hp_ops->uevent : dd->hp_ops->handler;
>> > +       }
>> > +
>> > +       mutex_unlock(&hotplug_lock);
>> > +
>> > +       if (!run)
>> > +               return;
>> > +
>> > +       if (cb)
>> > +               cb(dd->handle, event, dd->hp_context);
>> > +
>> > +       dock_release_hotplug(dd);
>>
>> during DOCKING, dock_release_hotplug get called too?
>
> Yes, we need to drop down the refcount we've just bumped up.
>

ok, I see.

Acked-by: Yinghai Lu <yinghai@kernel.org>
