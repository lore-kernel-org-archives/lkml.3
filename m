Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935853Ab3BOP3A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 10:29:00 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:11384 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933910Ab3BOP26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 10:28:58 -0500
Message-ID: <1360941494.9542.11.camel@misato.fc.hp.com>
Subject: Re: [Update][PATCH] ACPI / hotplug: Fix concurrency issues and
 memory leaks
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Moore, Robert" <robert.moore@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <liuj97@gmail.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Myron Stowe <mstowe@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Date: Fri, 15 Feb 2013 08:18:14 -0700
In-Reply-To: <1556413.qqfoi7QgzD@vostro.rjw.lan>
References: <1837481.7dT8hTZ4MT@vostro.rjw.lan>
	 <1463882.MtF6rq6lDy@vostro.rjw.lan>
	 <1360888082.3869.163.camel@misato.fc.hp.com>
	 <1556413.qqfoi7QgzD@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-15 at 13:49 +0100, Rafael J. Wysocki wrote:
> On Thursday, February 14, 2013 05:28:02 PM Toshi Kani wrote:
> > On Fri, 2013-02-15 at 01:23 +0100, Rafael J. Wysocki wrote:
> > > On Thursday, February 14, 2013 11:45:27 PM Moore, Robert wrote:
> > > > 
> > > > > -----Original Message-----
> > > > > From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
> > > > > Sent: Thursday, February 14, 2013 12:59 PM
> > > > > To: Moore, Robert
> > > > > Cc: Toshi Kani; ACPI Devel Maling List; LKML; Bjorn Helgaas; Jiang Liu;
> > > > > Yinghai Lu; Yasuaki Ishimatsu; Myron Stowe; linux-pci@vger.kernel.org
> > > > > Subject: Re: [Update][PATCH] ACPI / hotplug: Fix concurrency issues and
> > > > > memory leaks
> > > > > 
> > > > > On Thursday, February 14, 2013 08:45:14 PM Moore, Robert wrote:
> > > > > >
> > > > > > > -----Original Message-----
> > > > > > > From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
> > > > > > > Sent: Thursday, February 14, 2013 4:04 AM
> > > > > > > To: Moore, Robert
> > > > > > > Cc: Toshi Kani; ACPI Devel Maling List; LKML; Bjorn Helgaas; Jiang
> > > > > > > Liu; Yinghai Lu; Yasuaki Ishimatsu; Myron Stowe;
> > > > > > > linux-pci@vger.kernel.org
> > > > > > > Subject: Re: [Update][PATCH] ACPI / hotplug: Fix concurrency issues
> > > > > > > and memory leaks
> > > > > > >
> > > > > > > On Thursday, February 14, 2013 02:31:22 AM Moore, Robert wrote:
> > > > > > > > > > > I thought about that, but actually there's no guarantee that
> > > > > > > > > > > the handle will be valid after _EJ0 as far as I can say.  So
> > > > > > > > > > > the race condition is going to be there anyway and using
> > > > > > > > > > > struct acpi_device just makes it easier to avoid it.
> > > > > > > > > >
> > > > > > > > > > In theory, yes, a stale handle could be a problem, if _EJ0
> > > > > > > > > > performs unload table and if ACPICA frees up its internal data
> > > > > > > > > > structure pointed by the handle as a result.  But we should
> > > > > > > > > > not see such issue now since we do not support dynamic ACPI
> > > > > > > > > > namespace
> > > > > > > yet.
> > > > > > > > >
> > > > > > > > > I'm waiting for information from Bob about that.  If we can
> > > > > > > > > assume ACPI handles to be always valid, that will simplify
> > > > > > > > > things quite a
> > > > > > > bit.
> > > > > > > >
> > > > > > > > If a table is unloaded, all the namespace nodes for that table are
> > > > > > > > removed from the namespace, and thus any ACPI_HANDLE pointers go
> > > > > > > > stale
> > > > > > > and invalid.
> > > > > > >
> > > > > > > OK, thanks!
> > > > > > >
> > > > > > > To me this means that we cannot assume a handle to stay valid
> > > > > > > between a notify handler and acpi_bus_hot_remove_device() run from a
> > > > > workqueue.
> > > > > > >
> > > > > > > Is there a mechanism in ACPICA to ensure that a handle won't become
> > > > > > > stale while a notify handler is running for it or is the OS
> > > > > > > responsible for ensuring that
> > > > > > > _EJ0 won't be run in parallel with notify handlers for device
> > > > > > > objects being ejected?
> > > > > > >
> > > > > >
> > > > > > It is up to the host.
> > > > > 
> > > > > I was afraid that that might be the case. :-)
> > > > > 
> > > > > So far the (Linux) host has been happily ignoring that potential problem,
> > > > > so I guess it can still be ignored for a while, although we'll need to
> > > > > address it eventually at one point.
> > > > 
> > > > I would think it should be fairly simple to setup a mechanism to either tell
> > > > the driver or for the driver to figure it out -- such that the driver knows
> > > > that all handles associated with the device are now invalid. Another way
> > > > to look at it is that when the device is re-installed, the driver should
> > > > reinitialize such that it obtains new handles for the devices and subobjects
> > > > in question.
> > > 
> > > Unfortunately, there is quite strong assumption in our code that ACPI handles
> > > will not become stale before the device objects associated with them are
> > > removed.  For this reason, we need to know in advance which handles will
> > > become stale as a result of a table unload and remove their device objects
> > > beforehand.
> > > 
> > > Moreover, when there's a notify handler installed for a given ACPI handle
> > > and that handle becomes stale while the notify handler is running, we'll be
> > > in trouble.  To avoid that we need to ensure that table unloads and notifies
> > > will always be mutually exclusive.
> > 
> > I wonder if we can make acpi_ns_validate_handle() to actually be able to
> > verify if a given handle is valid.  This way, ACPICA can fail gracefully
> > (AE_BAD_PARAMETER) when a stable handle is passed to the interfaces.
> 
> That'd be good, but to implement it, I think, it would be necessary to
> introduce some reference counting of namespace objects such that the given
> object would only be deleted after the last reference to it had been dropped.
> On table unload it would just be marked as invalid, but it would stay in
> memory as long as there were any references to it.
> 
> So, for example, a notify handler would start from something like
> acpi_add_reference(handle), which would guarantee that the object pointed to by
> handle would stay in memory, and it would finish by doing
> acpi_drop_reference(handle) or a work item scheduled by it would do that.
> 
> We do that for objects based on struct device and it works well.

There is other way to implement it.  Since acpi_handle is defined as an
opaque value, this could be changed to an index to an array of pointers,
instead of a direct pointer.  Then we can safely invalidate an index by
invalidating the pointer associated with the index.

Thanks,
-Toshi

