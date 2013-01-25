Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab3AYXRk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 18:17:40 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:14040 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab3AYXRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 18:17:38 -0500
Message-ID: <1359155258.14145.464.camel@misato.fc.hp.com>
Subject: Re: [RFC] ACPI scan handlers
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <liuj97@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 25 Jan 2013 16:07:38 -0700
In-Reply-To: <2828434.roIVsRI7Pb@vostro.rjw.lan>
References: <1873429.MS5RQDxTye@vostro.rjw.lan>
	 <1359132741.14145.404.camel@misato.fc.hp.com>
	 <2828434.roIVsRI7Pb@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-01-25 at 23:11 +0100, Rafael J. Wysocki wrote:
> On Friday, January 25, 2013 09:52:21 AM Toshi Kani wrote:
> > On Thu, 2013-01-24 at 01:26 +0100, Rafael J. Wysocki wrote:
 :
> > > 
> > > I wonder if anyone is seeing any major problems with this at the high level.
> 
> First of all, thanks for the response. :-)
> 
> > I agree that the current model is mess.  As shown below, it requires
> > that .add() at boot-time only performs acpi dev init, and .add() at
> > hot-add needs both acpi dev init and device on-lining.
> 
> I'm not sure what you're talking about, though.
> 
> You seem to be confusing ACPI device nodes (i.e. things represented by struct
> acpi_device objects) with devices, but they are different things.  They are
> just used to store static information extracted from device objects in the
> ACPI namespace and to expose those objects (and possibly some of their
> properties) via sysfs.  Device objects in the ACPI namespace are not devices,
> however, and they don't even need to represent devices (for example, the
> _SB thing, which is represented by struct acpi_device, is hardly a device).
> 
> So the role of struct acpi_device things is analogous to the role of
> struct device_node things in the Device Trees world.  In fact, no drivers
> should ever bind to them and in my opinion it was a grievous mistake to
> let them do that.  But I'm digressing.
> 
> So, when you're saying "acpi dev", I'm not sure if you think about a device node
> or a device (possibly) represented by that node.  If you mean device node, then
> I'm not sure what "acpi dev init" means, because device nodes by definition
> don't require any initialization beyond what acpi_add_single_object() does
> (and they don't require any off-lining beyod what acpi_device_unregister()
> does, for that matter).  In turn, if you mean "device represented by the given
> device node", then you can't even say "ACPI device" about it, because it very
> well may be a PCI device, or a USB device, or a SATA device etc.

Let me clarify my point with the ACPI memory driver as an example since
it is the one that has caused a problem in .remove().

acpi_memory_device_add() implements .add() and does two things below.

 1. Call _CRS and initialize a list of struct acpi_memory_info that is
attached to acpi_device->driver_data.  This step is what I described as
"acpi dev init".  ACPI drivers perform driver-specific initialization to
ACPI device objects.

 2. Call add_memory() to add a target memory range to the mm module.
This step is what I described as "on-lining".  This step is not
necessary at boot-time since the mm module has already on-lined the
memory ranges at early boot-time.  At hot-add, however, it needs to call
add_memory() with the current framework.

Similarly, acpi_memory_device_remove() implements .remove() and does two
things below.

 1. Call remove_memory() to offline a target memory range.  This step,
"off-lining", can fail since the mm module may or may not be able to
delete non-movable ranges.  This failure cannot be handled properly and
causes the system to crash at this point.

 2. Free up the list of struct acpi_memory_info.  This step deletes
driver-specific data from an ACPI device object.


> That's part of the whole confusion, by the way.
> 
> If the device represented by an ACPI device node is on a natively enumerated
> bus, like PCI, then its native bus' init code initializes the device and
> creates a "physical" device object for it, like struct pci_dev, which is then
> "glued" to the corresponding struct acpi_device by acpi_bind_one().  Then, it
> is clear which is which and there's no confusion.  The confusion starts when
> there's no native enumeration and we only have the struct acpi_device thing,
> because then everybody seems to think "oh, there's no physical device object
> now, so this must be something different", but the *only* difference is that
> there is no native bus' init code now and we should still be creating a
> "physical device" object for the device and we should "glue" it to the
> existing struct acpi_device like in the natively enumerated case.
> 
> > It then requires .remove() to perform both off-lining and acpi dev
> > delete.  .remove() must succeed, but off-lining can fail.  
> >
> >  acpi dev   online
> > |========|=========|
> > 
> >    add @ boot
> > -------->
> >    add @ hot-add
> > ------------------>
> > <------------------
> >      remove
> 
> That assumes that the "driver" is present during boot (i.e. when acpi_bus_scan()
> is run for the first time), but what if it is not?

With memory's example, the mm module must be present at boot.  The
system does not boot without it.

> > Your proposal seems to introduce the following new model.  If so, I do
> > not think it addresses all the issues.
> 
> It is not supposed to address *all* issues (whatever "all" means).  It is meant
> to address precisely *one* problem, which is the abuse of the driver core by
> the ACPI subsystem (please see below).
> 
> > .attach() still needs to behave differently between boot and hot-add.
> 
> Why does it?  I don't see any reason for that.

With memory's example, calling add_memory() at boot is not necessary
(which just fails and this failure cannot cause an error), but is
necessary at hot-add (which should succeed in this case). 

> > The model is also asymmetric since the destructor of .attach() at hot-add
> > is the combination of .detach() and .untie().
> > .
> >  attach @ boot
> > -------->
> >  attach @ hot-add
> > ----------------->
> >  detach    untie
> > <-------<---------
> >         --------->
> >            reclaim
> > 
> > I believe device on-lining and off-lining steps should not be performed
> > in .add() and .remove().  With this clarification, the current .add()
> > & .remove() model works fine as follows.  That is, .add() only performs
> > acpi dev init, and .remove() only perform acpi dev delete (which is same
> > as your .detach()).  My system device hot-plug framework is designed to
> > work with this model.
> 
> Well, if I understand the above correctly, you're basically saying that if we
> add a layer on top of the ACPI subsystem, we can separate "online" from "add"
> and "offline" from "remove" in such a way that the "add" and "remove" will be
> handled by the ACPI subsystem and "online" and "offline" will be done by the
> extra layer.

Right.  In memory's example, the "online" part should be done by the mm
module itself.

> That quite precisely is what we should be doing, but the "add" operation should
> include the creation of a "physical device" object, like for example struct
> platform_device, and the additional layer should be a proper driver (a platform
> driver for example) that will bind to that "physical device" object and
> initialize the device (i.e. hardware).
>
> Analogously, the "remove" operation should include the removal of the "physical
> device" object from which the driver will have to be unbound first.

Agreed.  With memory's example, the "remove" is also required to do
"off-lining" (i.e. call remove_memory), which should not be the role of
ACPI driver.

> That I believe is what Greg meant when he was discussing your earlier proposal
> with you.
> 
> Now, however, the problem is what kind of a device object we should create
> during the "add" phase (struct platform_device may not be suitable in some
> cases) and whether that needs to be a single object or a whole bunch of them
> (e.g. when the given struct acpi_device represents a bus or bridge, like in the
> PCI host bridge case).  That's what the ACPI scan handlers I'm proposing are
> for.

OK, so, we are thinking of different issues... :-)

> So, an ACPI scan handler's .attach() is supposed to recognize what kind of
> hardware is there to handle and to create whatever device objects (based on
> struct device) are there to create etc.  Then, there should be drivers that
> will bind to those objects and so on.  .detach(), in turn, is supposed to
> reverse whatever .attach() has done.  There is an additional complication,
> though, that there may be an eject request between .attach() and .detach()
> and it needs to be responded to.
> 
> This really is about responding to three types of events related to the ACPI
> namespace.  Those events are, essentially:
> 
> (1) Device node (i.e. struct acpi_device) has been registered.
> (2) Eject has been requested for a device node.
> (3) Device node goes away (i.e. it is going to be unregistered).
> 
> Whatever the "model", we have to respond to the above events, this way or
> another.
> 
> Of course, (2) need not be the same as (3) in general, because one may envision
> a refusal to carry out the eject.  Currently, though, there is no distinction
> between (2) and (3).
> 
> The purpose of ACPI scan handlers I'm proposing is precisely to handle these
> three types of events without abusing the driver core.  How exactly they are
> going to be handled will depend on the implementation of those handlers.
> 
> The idea is that .attach(), .untie(), and .detach() will be called to handle
> (1), (2), and (3), respectively, with the additional twist that after an eject
> refusal .reclaim() needs to be called to do the cleanup.
> 
> Well, perhaps the names .untie() and .reclaim() are not the best ones and it's
> better to use names like .eject_requested() and .eject_refused() explicitly
> for those callbacks?  And analogously for the flag indicating that
> .eject_requested() has succeeded for the given device?
> 
> So, this is not about creating any new "model", it's just about doing what
> needs to be done in a possibly straightforward way.
> 
> Now, perhaps I should just post some code so that it's more clear what I mean. :-)

Sounds like I did confuse completely!

Anyway, even we have .untie() or .eject_requested(), I think all the
hot-delete procedure may not be done within this function since an ACPI
driver is not responsible for managing/controlling actual device.


Thanks,
-Toshi


