Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab3AYWFz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 17:05:55 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:56021 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977Ab3AYWFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 17:05:51 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <liuj97@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] ACPI scan handlers
Date: Fri, 25 Jan 2013 23:11:55 +0100
Message-ID: <2828434.roIVsRI7Pb@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1359132741.14145.404.camel@misato.fc.hp.com>
References: <1873429.MS5RQDxTye@vostro.rjw.lan> <1359132741.14145.404.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 25, 2013 09:52:21 AM Toshi Kani wrote:
> On Thu, 2013-01-24 at 01:26 +0100, Rafael J. Wysocki wrote:
> > Hi All,
> > 
> > There is a considerable amount of confusion in the ACPI subsystem about what
> > ACPI drivers are used for.  Namely, some of them are used as "normal" device
> > drivers that bind to devices and handle them using ACPI control methods (like
> > the fan or battery drivers), but some of them are just used for handling
> > namespace events, such as the creation or removal of device nodes (I guess it
> > would be fair to call that an abuse of the driver core).  These two roles are
> > quite distinct, which is particularly visible from the confusion about the role
> > of the .remove() callback.
> > 
> > For the "normal" drivers this callback is simply used to handle situations in
> > which the driver needs to be unbound from the device, because one of them
> > (either the device or the driver) is going away.  That operation can't really
> > fail, it just needs to do the necessary cleanup.
> > 
> > However, for the namespace events handling "drivers" .remove() means that not
> > only the device node in question, but generally also the whole subtree below it
> > needs to be prepared for removal, which may involve deleting multiple device
> > objects belonging to different bus types and so on and which very well may fail
> > (for example, those devices may be used for such things like swap or they may be
> > memory banks used by the kernel and it may not be safe to remove them at the
> > moment etc.).  Moreover, for these things the removal of the "driver" doesn't
> > really make sense, because it has to be there to handle the namespace events it
> > is designed to handle or else things will go remarkably awry in some places.
> > 
> > To resolve all that mess I'd like to do the following, which in part is inspired
> > by the recent Toshi Kani's hotplug framework proposal and in part is based on
> > some discussions I had with Bjorn and others (the code references made below are
> > based on the current contens of linux-pm.git/linux-next).
> > 
> > 1) Introduce a special data type for "ACPI namespace event handlers" like:
> > 
> > struct acpi_scan_handler {
> > 	const struct acpi_device_id *ids;
> > 	struct list_head list_node;
> > 	int (*attach)(struct acpi_device *adev);
> > 	int (*untie)(struct acpi_device *adev);
> > 	int (*reclaim)(struct acpi_device *adev);
> > 	void (*detach)(struct acpi_device *adev);
> > };
> > 
> >   an additional ACPI device flag:
> > 
> > struct acpi_device_flags {
> > ...
> > 	u32 untied:1;
> > ...
> > };
> > 
> >   and an additioanl field in struc acpi_device:
> > 
> > struct acpi_device {
> > ...
> > 	struct acpi_scan_handler *scan_handler;
> > ...
> > };
> > 
> >   (the roles of these things are described below).
> > 
> > 2) Introduce a list of struct acpi_scan_handler objects within the ACPI
> >    subsystem such that acpi_bus_device_attach() will search that list first and
> >    if there's a matching object (one whose ids match the device node), it will
> >    run that object's .attach() callback.
> > 
> >   If that returns 1, it will mean that the handler has claimed the device node
> >   and is now responsible for it until its .detach() callback is run.  Thus no
> >   driver can be bound to that device node and no other handler can claim it.
> >   Then, the device node's scan_handler field will be set to point to the handler
> >   that's claimed it and its untied flag will be cleared.
> > 
> >   If .attach() returns 0, it will mean that the handler has not recognized the
> >   device node and some other scan handlers and/or drivers may be tried for it.
> > 
> >   If an error code is returned, it will mean a hard error in which case the
> >   scanning of the namespace will have to be aborted.
> > 
> >   This way ACPI drivers will only be bound to device nodes that haven't been
> >   claimed by any scan handlers.
> > 
> > 3) Introduce an additional function following the format of acpi_bus_trim(),
> >    say acpi_bus_untie(), that will walk the namespace starting at the given
> >    device node and execute the .untie() callbacks from the scan handlers of
> >    all devices as post-order callbacks.
> > 
> >    If the .untie() callback for the given device node returns 0, it will mean
> >    that it is now safe to delete that node as long as its scan handler's
> >    .detach() callback is executed before the deletion.  In that case, the device
> >    node's untied flag will be set.
> > 
> >    Otherwise (i.e. if an error code is returned), it will mean that the scan
> >    handler has vetoed the untying and the whole operation should be reversed.
> >    Then, acpi_bus_untie() will walk the namespace again and execute the
> >    .reclaim() callbacks from the scan handlers of the device nodes whose untied
> >    flags are set as pre-order callbacks.
> > 
> >    If .reclaim() returns 0, the device node's untied flag will be cleared, and
> >    if an error code is returned, it will remain set.
> > 
> >    This will allow us to prepare the subtree below the given device node for
> >    removal in a reversible way, if needed.  Still, though, it will be possible
> >    to carry out a forcible removal calling acpi_bus_trim() after
> >    acpi_bus_untie() even if that has returned an error code (or even
> >    acpi_bus_trim() without acpi_bus_untie()).
> > 
> > 4) Make acpi_bus_device_detach() execute the .detach() callback from the
> >    scan handler of the device node (if the scan handler is present) and clear
> >    its scan_handler field along with its untied flag.  However, the untied flags
> >    will only be cleared after executing the .detach() callbacks, so that those
> >    callbacks can see whether or not the scan handlers have been successfully
> >    "untied" from the device nodes.
> > 
> > 5) Make acpi_bus_hot_remove_device() (and other pieces of code where that is
> >    convenient) call acpi_bus_untie() before acpi_bus_trim() and bail out
> >    cleanly if the untying fails (i.e. is vetoed by one of the scan handlers).
> > 
> > That should take care of the removal problem nicely and as far as I can say
> > the majority of the ACPI drivers used only for handling namespace events can
> > be readily converted to struct acpi_scan_handler objects.
> > 
> > I wonder if anyone is seeing any major problems with this at the high level.

First of all, thanks for the response. :-)

> I agree that the current model is mess.  As shown below, it requires
> that .add() at boot-time only performs acpi dev init, and .add() at
> hot-add needs both acpi dev init and device on-lining.

I'm not sure what you're talking about, though.

You seem to be confusing ACPI device nodes (i.e. things represented by struct
acpi_device objects) with devices, but they are different things.  They are
just used to store static information extracted from device objects in the
ACPI namespace and to expose those objects (and possibly some of their
properties) via sysfs.  Device objects in the ACPI namespace are not devices,
however, and they don't even need to represent devices (for example, the
_SB thing, which is represented by struct acpi_device, is hardly a device).

So the role of struct acpi_device things is analogous to the role of
struct device_node things in the Device Trees world.  In fact, no drivers
should ever bind to them and in my opinion it was a grievous mistake to
let them do that.  But I'm digressing.

So, when you're saying "acpi dev", I'm not sure if you think about a device node
or a device (possibly) represented by that node.  If you mean device node, then
I'm not sure what "acpi dev init" means, because device nodes by definition
don't require any initialization beyond what acpi_add_single_object() does
(and they don't require any off-lining beyod what acpi_device_unregister()
does, for that matter).  In turn, if you mean "device represented by the given
device node", then you can't even say "ACPI device" about it, because it very
well may be a PCI device, or a USB device, or a SATA device etc.

That's part of the whole confusion, by the way.

If the device represented by an ACPI device node is on a natively enumerated
bus, like PCI, then its native bus' init code initializes the device and
creates a "physical" device object for it, like struct pci_dev, which is then
"glued" to the corresponding struct acpi_device by acpi_bind_one().  Then, it
is clear which is which and there's no confusion.  The confusion starts when
there's no native enumeration and we only have the struct acpi_device thing,
because then everybody seems to think "oh, there's no physical device object
now, so this must be something different", but the *only* difference is that
there is no native bus' init code now and we should still be creating a
"physical device" object for the device and we should "glue" it to the
existing struct acpi_device like in the natively enumerated case.

> It then requires .remove() to perform both off-lining and acpi dev
> delete.  .remove() must succeed, but off-lining can fail.  
>
>  acpi dev   online
> |========|=========|
> 
>    add @ boot
> -------->
>    add @ hot-add
> ------------------>
> <------------------
>      remove

That assumes that the "driver" is present during boot (i.e. when acpi_bus_scan()
is run for the first time), but what if it is not?

> Your proposal seems to introduce the following new model.  If so, I do
> not think it addresses all the issues.

It is not supposed to address *all* issues (whatever "all" means).  It is meant
to address precisely *one* problem, which is the abuse of the driver core by
the ACPI subsystem (please see below).

> .attach() still needs to behave differently between boot and hot-add.

Why does it?  I don't see any reason for that.

> The model is also asymmetric since the destructor of .attach() at hot-add
> is the combination of .detach() and .untie().
> .
>  attach @ boot
> -------->
>  attach @ hot-add
> ----------------->
>  detach    untie
> <-------<---------
>         --------->
>            reclaim
> 
> I believe device on-lining and off-lining steps should not be performed
> in .add() and .remove().  With this clarification, the current .add()
> & .remove() model works fine as follows.  That is, .add() only performs
> acpi dev init, and .remove() only perform acpi dev delete (which is same
> as your .detach()).  My system device hot-plug framework is designed to
> work with this model.

Well, if I understand the above correctly, you're basically saying that if we
add a layer on top of the ACPI subsystem, we can separate "online" from "add"
and "offline" from "remove" in such a way that the "add" and "remove" will be
handled by the ACPI subsystem and "online" and "offline" will be done by the
extra layer.

That quite precisely is what we should be doing, but the "add" operation should
include the creation of a "physical device" object, like for example struct
platform_device, and the additional layer should be a proper driver (a platform
driver for example) that will bind to that "physical device" object and
initialize the device (i.e. hardware).

Analogously, the "remove" operation should include the removal of the "physical
device" object from which the driver will have to be unbound first.

That I believe is what Greg meant when he was discussing your earlier proposal
with you.

Now, however, the problem is what kind of a device object we should create
during the "add" phase (struct platform_device may not be suitable in some
cases) and whether that needs to be a single object or a whole bunch of them
(e.g. when the given struct acpi_device represents a bus or bridge, like in the
PCI host bridge case).  That's what the ACPI scan handlers I'm proposing are
for.

So, an ACPI scan handler's .attach() is supposed to recognize what kind of
hardware is there to handle and to create whatever device objects (based on
struct device) are there to create etc.  Then, there should be drivers that
will bind to those objects and so on.  .detach(), in turn, is supposed to
reverse whatever .attach() has done.  There is an additional complication,
though, that there may be an eject request between .attach() and .detach()
and it needs to be responded to.

This really is about responding to three types of events related to the ACPI
namespace.  Those events are, essentially:

(1) Device node (i.e. struct acpi_device) has been registered.
(2) Eject has been requested for a device node.
(3) Device node goes away (i.e. it is going to be unregistered).

Whatever the "model", we have to respond to the above events, this way or
another.

Of course, (2) need not be the same as (3) in general, because one may envision
a refusal to carry out the eject.  Currently, though, there is no distinction
between (2) and (3).

The purpose of ACPI scan handlers I'm proposing is precisely to handle these
three types of events without abusing the driver core.  How exactly they are
going to be handled will depend on the implementation of those handlers.

The idea is that .attach(), .untie(), and .detach() will be called to handle
(1), (2), and (3), respectively, with the additional twist that after an eject
refusal .reclaim() needs to be called to do the cleanup.

Well, perhaps the names .untie() and .reclaim() are not the best ones and it's
better to use names like .eject_requested() and .eject_refused() explicitly
for those callbacks?  And analogously for the flag indicating that
.eject_requested() has succeeded for the given device?

So, this is not about creating any new "model", it's just about doing what
needs to be done in a possibly straightforward way.

Now, perhaps I should just post some code so that it's more clear what I mean. :-)

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
