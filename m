Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759889Ab3BHBP5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 20:15:57 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:12493 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759874Ab3BHBPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 20:15:55 -0500
Message-ID: <1360285519.3869.49.camel@misato.fc.hp.com>
Subject: Re: [PATCH 2/2] ACPI / scan: Simplify container driver
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <liuj97@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 07 Feb 2013 18:05:19 -0700
In-Reply-To: <1619279.PL3OLF99br@vostro.rjw.lan>
References: <1873429.MS5RQDxTye@vostro.rjw.lan>
	 <2629080.ji4YWC94Sj@vostro.rjw.lan>
	 <1360247527.14416.8.camel@misato.fc.hp.com>
	 <1619279.PL3OLF99br@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-07 at 23:42 +0100, Rafael J. Wysocki wrote:
> On Thursday, February 07, 2013 07:32:07 AM Toshi Kani wrote:
> > On Thu, 2013-02-07 at 02:32 +0100, Rafael J. Wysocki wrote:
> > > On Wednesday, February 06, 2013 05:51:42 PM Toshi Kani wrote:
> > > > On Thu, 2013-02-07 at 01:55 +0100, Rafael J. Wysocki wrote:
> > > > > On Wednesday, February 06, 2013 03:32:18 PM Toshi Kani wrote:
> > > > > > On Mon, 2013-02-04 at 00:47 +0100, Rafael J. Wysocki wrote:
 :
> > > > > Moreover, I'm wondering if the #ifndef FORCE_EJECT thing in acpi_eject_store()
> > > > > actually makes sense after the recent changes to acpi_bus_trim(), because that
> > > > > can't fail now, so the eject will always be carried out.  So perhaps we can
> > > > > simply remove the acpi_device->driver check from there entirely in the first
> > > > > place?
> > > > >
> > > > > If we really want to be able to prevent ejects from happening in some cases,
> > > > > we need to implement something along the lines discussed with Greg.
> > > > 
> > > > acpi_bus_trim() cannot fail, but sysfs eject can fail.  So, I think it
> > > > makes sense to do some validation before calling acpi_bus_trim().  If we
> > > > are to implement the no_eject flag thing, that check needs to be made
> > > > before calling acpi_bus_trim().
> > > 
> > > Sure, but now the logic seems to be "if FORCE_EJECT is not set, don't eject
> > > devices that have no ACPI drivers", so I'm wondering what the purpose of this
> > > is.  It definitely isn't too obvious. :-)
> > 
> > The check sounds odd for container, but is necessary for CPU and memory
> > for now.  CPU and memory go online without their ACPI drivers at boot.
> > So, without this check (i.e. FORCE_EJECT is set), it simply ejects them
> > without attempting to offline when the ACPI drivers are not bound.  Of
> > course, we have the issue of a failure in offline be ignored, so this
> > offlining part needs to be moved out from acpi_bus_trim() in one way or
> > the other.
> 
> That was my point.
> 
> I'm going to add that change for now, but I think we need to take a step back
> and talk about how we want the whole eject machinery to work, regardless of
> the offline/online problem.

Right.

> I think that it should work in the same way for all things that may be ejected
> or inserted.  Namely, they all should use the same notify handler, for example,
> and if we generate a uevent for one, we should do that for all of them.

Agreed.

> Question is how that notify handler should work and here there are two chices
> in my view: Either we'll always emit a uevent and wait for user space to start
> the eject procedure via sysfs, or we won't emit uevents at all and rely on the
> "no_eject" flag to trigger if something is not ready.  I'm basically fine with
> any of them (the "no_eject" flag may be useful even if we rely on user space
> to offline stuff before triggering the eject in my opinion), but if we're going
> to rely on user space, then there needs to be a timeout for letting the BIOS
> know that the eject has failed.
> 
> [There may be a flag for the common code telling it whether to emit a uevent
> and wait for user space to trigger eject or to trigger eject by itself.]

IMHO, the kernel waiting for a user program to complete is a recipe for
future problems.  So, I think two possible implementation choices are:

1. Upon an eject request, off-line all devices and eject
 => Implement a kernel sequencer (my RFC patchset)

2. Upon an eject request, eject if all devices are off-lined beforehand 
 => Implement the "no_eject" approach

Since we are heading to the user space approach, we need to go with #2.
There are some challenges with #2, ex. if sysfs memory online/offline
interfaces can correspond with ACPI memory objects, which we will also
need to look into.

> Next, I think there needs to be a global list of IDs for which we'll install
> hot-plug notify handlers and which we'll allow to be ejected via /sys/.../eject.
> So, if a device ID is on that list, we'll install the (common) hot-plug notify
> handler for its ACPI handle and we'll set an "eject_possible" flag in its
> struct acpi_device (when created).  That will need to be done for every scan
> of the ACPI namespace and not just once, BTW.  And we'll check the
> "eject_possible" flag in acpi_eject_store() instead of the "does it have a
> driver or scan handler" check.
>
> Then, the scan handlers for hot-plug devices will be able to add their IDs to
> that global list instead of walking the namespace and installing notify handlers
> by themselves (which as I said has a problem that it's done once, while it
> should be done every time acpi_bus_scan() runs).

I agree.  I think we can use the global notify handler (as the common
notify handler) to look up the eject_possible ID list, instead of
installing a notify handler to each device.


Thanks,
-Toshi


