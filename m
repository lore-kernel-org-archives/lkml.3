Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423441Ab3FVAEV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 20:04:21 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:46068 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161521Ab3FVAEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 20:04:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiang Liu <liuj97@gmail.com>
Cc: "Alexander E. Patrakov" <patrakov@gmail.com>,
        Jiang Liu <jiang.liu@huawei.com>, alexdeucher@gmail.com,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, linux-acpi@vger.kernel.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUGFIX v2 0/4] fix bug 56531, 59501 and 59581
Date: Sat, 22 Jun 2013 02:13:40 +0200
Message-ID: <2686036.58bcYhGNts@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51C4853D.7040705@gmail.com>
References: <1371238081-32260-1-git-send-email-jiang.liu@huawei.com> <1436701.V8egnZxOqz@vostro.rjw.lan> <51C4853D.7040705@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, June 22, 2013 12:54:21 AM Jiang Liu wrote:
> On 06/21/2013 03:06 AM, Rafael J. Wysocki wrote:
> > On Wednesday, June 19, 2013 11:18:41 AM Alexander E. Patrakov wrote:
> >> 2013/6/19 Rafael J. Wysocki <rjw@sisk.pl>:
> >>> OK, let's try to untangle this a bit.
> >>>
> >>> If you applyt patches [1/4] and [4/4] from the $subject series only, what
> >>> does remain unfixed?
> >>
> >> [not tested, can do so in 12 hours if needed]
> >>
> >> I think there will be problems on undocking and/or on the second
> >> docking, as described in comments #6 - #8 of
> >> https://bugzilla.kernel.org/show_bug.cgi?id=59501
> > 
> > OK, I think I have something that might work.  It may not solve all problems,
> > but maybe it helps a bit.  Unfortunately, I can't really test it, so please do
> > if you can.
> > 
> > Please apply [1/4] and [4/4] and the one below and see what happens.
> > 
> > Thanks,
> > Rafael
> > 
> > 
> > ---
> > Rationale:
> > 	acpiphp_glue.c:disable_device() trims the underlying ACPI device objects
> > 	after removing the companion PCI devices, so the dock station code
> > 	doesn't need to trim them separately for the dependent devices handled
> > 	by acpiphp.
> > 
> > 	Moreover, acpiphp_glue.c is the only user of
> > 	[un]register_hotplug_dock_device(), so *all* devices on the
> > 	ds->hotplug_devices list are handled by acpiphp and ops is set for all
> > 	of them.
> Hi Rafael,
>     There's an ongoing patch to fix a disk bay hotplug regression, which
> may add a second caller of register_hotplug_device(). Please refer to
> bug 59871, and the proposed patch is at:
> https://bugzilla.kernel.org/attachment.cgi?id=105581
> 
> > 
> > 	This means that (1) the ds->hotplug_devices list is not necessary (we
> > 	can always walk ds->dependent_devices instead and look for those that
> > 	have dd->ops set) and (2) we don't need to call
> > 	dock_remove_acpi_device(dd->handle) on eject for any of those devices,
> > 	because dd->ops->handler() is going to take care of the ACPI device
> > 	objects trimming for them anyway.
> > 
> > 	Taking the above into account make the following changes:
> > 	(1) Drop hotplug_devices from struct dock_station.
> > 	(2) Drop dock_{add|del}_hotplug_device()
> > 	(3) Make [un]register_hotplug_dock_device() [un]set 'ops' and
> > 	    'context' for the given device under ds->hp_lock.
> > 	(4) Add hot_remove_dock_devices() that walks ds->dependent_devices and
> > 	    either calls dd->ops->handler(), if present, or trims the underlying
> > 	    ACPI device object, otherwise.
> > 	(5) Replace hotplug_dock_devices(ds, ACPI_NOTIFY_EJECT_REQUEST) calls
> > 	    with hot_remove_dock_devices(ds).
> > 	(6) Rename hotplug_dock_devices() to hot_add_dock_devices() and make
> > 	    it only handle bus check and device check requests.  Make it walk
> > 	    ds->dependent_devices instead of ds->hotplug devices.
> > 	(7) Make dock_event() walk ds->dependent_devices (instead of
> > 	    ds->hotplug devices) under ds->hp_lock.
> > ---
> >  drivers/acpi/dock.c |  111 ++++++++++++++++++++++++----------------------------
> >  1 file changed, 53 insertions(+), 58 deletions(-)
> > 
> > Index: linux-pm/drivers/acpi/dock.c
> > ===================================================================
> > --- linux-pm.orig/drivers/acpi/dock.c
> > +++ linux-pm/drivers/acpi/dock.c
> > @@ -66,7 +66,6 @@ struct dock_station {
> >  	spinlock_t dd_lock;
> >  	struct mutex hp_lock;
> >  	struct list_head dependent_devices;
> > -	struct list_head hotplug_devices;
> >  
> >  	struct list_head sibling;
> >  	struct platform_device *dock_device;
> > @@ -121,38 +120,6 @@ add_dock_dependent_device(struct dock_st
> >  }
> >  
> >  /**
> > - * dock_add_hotplug_device - associate a hotplug handler with the dock station
> > - * @ds: The dock station
> > - * @dd: The dependent device struct
> > - *
> > - * Add the dependent device to the dock's hotplug device list
> > - */
> > -static void
> > -dock_add_hotplug_device(struct dock_station *ds,
> > -			struct dock_dependent_device *dd)
> > -{
> > -	mutex_lock(&ds->hp_lock);
> > -	list_add_tail(&dd->hotplug_list, &ds->hotplug_devices);
> > -	mutex_unlock(&ds->hp_lock);
> > -}
> > -
> > -/**
> > - * dock_del_hotplug_device - remove a hotplug handler from the dock station
> > - * @ds: The dock station
> > - * @dd: the dependent device struct
> > - *
> > - * Delete the dependent device from the dock's hotplug device list
> > - */
> > -static void
> > -dock_del_hotplug_device(struct dock_station *ds,
> > -			struct dock_dependent_device *dd)
> > -{
> > -	mutex_lock(&ds->hp_lock);
> > -	list_del(&dd->hotplug_list);
> > -	mutex_unlock(&ds->hp_lock);
> > -}
> > -
> > -/**
> >   * find_dock_dependent_device - get a device dependent on this dock
> >   * @ds: the dock station
> >   * @handle: the acpi_handle of the device we want
> > @@ -342,40 +309,60 @@ static void dock_remove_acpi_device(acpi
> >  }
> >  
> >  /**
> > - * hotplug_dock_devices - insert or remove devices on the dock station
> > - * @ds: the dock station
> > - * @event: either bus check or eject request
> > + * hot_remove_dock_devices - Remove devices on a dock station.
> > + * @ds: Dock station to remove devices for.
> > + *
> > + * For each device depending on @ds, if a dock event handler is registered,
> > + * call it for the device, or trim the underlying ACPI device object otherwise.
> > + *
> > + * Dock event handlers are responsible for trimming the underlying ACPI device
> > + * objects if present.
> > + */
> > +static void hot_remove_dock_devices(struct dock_station *ds)
> > +{
> > +	struct dock_dependent_device *dd;
> > +
> > +	mutex_lock(&ds->hp_lock);
> > +
> > +	list_for_each_entry(dd, &ds->dependent_devices, list) {
> > +		if (dd->ops && dd->ops->handler)
> > +			dd->ops->handler(dd->handle, ACPI_NOTIFY_EJECT_REQUEST,
> > +					 dd->context);
> > +		else
> > +			dock_remove_acpi_device(dd->handle);
> > +	}
> The proposed patch for bug 59871 may not be safe with above changes
> because the ACPI ATA hotplug handler may not remove ACPI devices as
> acpiphp driver does.

Well, since there's not ATA hotplug handler in 3.10-rc6, as far as I can say,
I suppose that you're talking about a new patch scheduled for 3.11.  If so,
can you please give me a pointer to that patch, possibly the tree it is
queued on etc.?

> On the other hand, the above change does get rid of the warning message
> "Oops, 'acpi_handle' corrupt", but it may hide the real issue. With
> current implementation, devices on the dock station are stopped and
> removed after invoking ACPI _DCK method, which seems a little dangerous.

Yes, that's something I actually overlooked.  In fact, the execution of
_DCK has to wait for all of the asynchronous work items spawned by
hotplug_dock_devices() to complete, so we *have* *to* run the acpiphp
stuff (the internals of _handle_hotplug_event_func() basically)
synchronously from the dock context.

> I think ACPI _DCK method should be called to power off the dock station
> after stopping all affected devices.

That's correct.  Not really to power off, but to disconnect ("isolate from
connector" as the spec puts that), although from the kernel's point of view
the result is pretty much the same - the devices are gone.

I have attached a new patch for Alexander to try at
https://bugzilla.kernel.org/show_bug.cgi?id=59501#c25

It kind of combines your patches [2/4] and [3/4] from the $subject series with
my last patch.  The most obvious difference is that it doesn't use klists. :-)

Seriously, I really think we don't need a separate "hotplug devices" list
for docking stations, one "dependent devices" list should be sufficient for
everything (it doesn't change anyway after the initialization), but I stole
your idea with the "get" and "put" routines (I called them "init" and
"release").  However, I didn't add them to struct acpi_dock_ops, but modified
register_hotplug_dock_device() to pass them directly instead (I believe this is
less prone to errors that way, because the callers of
register_hotplug_dock_device() cannot really overlook them).

We still may need to modify find_dock_devices() on top of that.

To summarize, we have multiple different problems in that code.

First, there is the ordering issue of the dock initialization versus PCI
enumeration, so basically dock_init() has to run before the main ACPI namespace
scan.  This is addressed by your patch [1/4] in the $subject series, but I'm
not 100% happy with that approach (I believe we need it as a stopgap fix for
now, though), because it means we have to carry out a full namespace walk
(possibly several of them even) before we even start to create struct
acpi_device objects and that doesn't sound quite right.

Second, there is the resources allocation issue addressed by your patch [4/4]
from the $subject series.  I believe that this patch is correct and Yinghai
seems to agree with me.

Next, there is the problem with asynchronous handling of dock events by acpiphp
that we're trying to solve at the moment and a couple of things are clear to
me here:

 1. Clearly, the dock driver assumes that dd->ops->handler() will always be
    synchronous, because otherwise there would have been a completion mechanism
    preventing _DCK from being executed before all of the handlers return.
    Since there's no such thing, we're dealing with a genuine acpiphp bug
    in its implementation of the dock handler and I'm not sure how it's ever
    been supposed to work.

 2. Whoever wrote find_dock_devices() didn't seem to know how
    acpi_bus_scan() worked, or that function would have been arranged
    differently and (moreover) the whay acpi_bus_scan() works has changed
    since then, so the assumptions made there may not be valid any more.
    Moreover, it looks like ds->dependent_list should be walked in the
    reverse order during removal.

 3. When we remove dock_{add|del}_hotplug_device(), this way or another,
    ds->hp_lock will be pointless, because its only user is
    hotplug_dock_devices() and it is always called under acpi_scan_lock.

Finally, there seem to be problems with PCI device drivers' .remove() callbacks
not working correctly in some cases and causing problems to happen.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
