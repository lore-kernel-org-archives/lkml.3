Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab3BORdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 12:33:25 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:12657 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486Ab3BORdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 12:33:21 -0500
Message-ID: <1360948952.9542.43.camel@misato.fc.hp.com>
Subject: Re: [Update][PATCH] ACPI / hotplug: Fix concurrency issues and
 memory leaks
From: Toshi Kani <toshi.kani@hp.com>
To: "Moore, Robert" <robert.moore@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <liuj97@gmail.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Myron Stowe <mstowe@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Zheng, Lv" <lv.zheng@intel.com>, "Brown, Len" <len.brown@intel.com>
Date: Fri, 15 Feb 2013 10:22:32 -0700
In-Reply-To: <94F2FBAB4432B54E8AACC7DFDE6C92E368CB6125@ORSMSX101.amr.corp.intel.com>
References: <1837481.7dT8hTZ4MT@vostro.rjw.lan>
	 <1463882.MtF6rq6lDy@vostro.rjw.lan>
	 <1360888082.3869.163.camel@misato.fc.hp.com>
	 <1556413.qqfoi7QgzD@vostro.rjw.lan>
	 <1360941494.9542.11.camel@misato.fc.hp.com>
	 <94F2FBAB4432B54E8AACC7DFDE6C92E368CB6125@ORSMSX101.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-15 at 16:33 +0000, Moore, Robert wrote:
> > > > > > > > > Is there a mechanism in ACPICA to ensure that a handle
> > > > > > > > > won't become stale while a notify handler is running for
> > > > > > > > > it or is the OS responsible for ensuring that
> > > > > > > > > _EJ0 won't be run in parallel with notify handlers for
> > > > > > > > > device objects being ejected?
> > > > > > > > >
> > > > > > > >
> > > > > > > > It is up to the host.
> > > > > > >
> > > > > > > I was afraid that that might be the case. :-)
> > > > > > >
> > > > > > > So far the (Linux) host has been happily ignoring that
> > > > > > > potential problem, so I guess it can still be ignored for a
> > > > > > > while, although we'll need to address it eventually at one
> > point.
> > > > > >
> > > > > > I would think it should be fairly simple to setup a mechanism to
> > > > > > either tell the driver or for the driver to figure it out --
> > > > > > such that the driver knows that all handles associated with the
> > > > > > device are now invalid. Another way to look at it is that when
> > > > > > the device is re-installed, the driver should reinitialize such
> > > > > > that it obtains new handles for the devices and subobjects in
> > question.
> > > > >
> > > > > Unfortunately, there is quite strong assumption in our code that
> > > > > ACPI handles will not become stale before the device objects
> > > > > associated with them are removed.  For this reason, we need to
> > > > > know in advance which handles will become stale as a result of a
> > > > > table unload and remove their device objects beforehand.
> > > > >
> > > > > Moreover, when there's a notify handler installed for a given ACPI
> > > > > handle and that handle becomes stale while the notify handler is
> > > > > running, we'll be in trouble.  To avoid that we need to ensure
> > > > > that table unloads and notifies will always be mutually exclusive.
> > > >
> > > > I wonder if we can make acpi_ns_validate_handle() to actually be
> > > > able to verify if a given handle is valid.  This way, ACPICA can
> > > > fail gracefully
> > > > (AE_BAD_PARAMETER) when a stable handle is passed to the interfaces.
> > >
> > > That'd be good, but to implement it, I think, it would be necessary to
> > > introduce some reference counting of namespace objects such that the
> > > given object would only be deleted after the last reference to it had
> > been dropped.
> > > On table unload it would just be marked as invalid, but it would stay
> > > in memory as long as there were any references to it.
> > >
> > > So, for example, a notify handler would start from something like
> > > acpi_add_reference(handle), which would guarantee that the object
> > > pointed to by handle would stay in memory, and it would finish by
> > > doing
> > > acpi_drop_reference(handle) or a work item scheduled by it would do
> > that.
> > >
> > > We do that for objects based on struct device and it works well.
> > 
> > There is other way to implement it.  Since acpi_handle is defined as an
> > opaque value, this could be changed to an index to an array of pointers,
> > instead of a direct pointer.  Then we can safely invalidate an index by
> > invalidating the pointer associated with the index.
> 
> 
> 
> We have of course thought about adding a mechanism to validate/invalidate acpica namespace handles. In fact, this is why the ACPI_HANDLE data type was introduced in the first place, so that if we ever wanted or needed to implement something like this, it would not break a lot of existing code.
> 
> However, we have never had a real need to implement such a mechanism, nor has the ever been a request from any of the operating systems that run ACPICA.
> 
> The existing model is that the host has knowledge of what objects will go away when a table is unloaded, and can simply assume that all related acpi handles will go bad after the unload (and table unload is the only case where parts of the namespace go away, as far as I remember). Upon a reload of the table, the host knows to reinitialize all handles associated with the table/device.
> 
> ACPCI has a table handler mechanism, where the host handler is invoked *before* an ACPI table is actually unloaded, so the host can prepare for the unload. For example, before returning from the table handler, the host may want to synchronize by waiting for any outstanding notifies to complete, then simply ignoring any further notifies from any devices associated with the table.
> 
> In summary, it has always been felt that the fairly large overhead of implementing a mechanism like this is not worth the cost, as well as not really needed.
> 
> I suggest that the implementation of eject support proceed by using the existing mechanisms such as the table handler. If additional support/interfaces are needed in ACPICA, we can discuss it. However, just about the last thing I would like to do is add a level of indirection between the ACPI_HANDLE and the ACPI_NAMESPACE_NODE -- which would require a large, global change to ACPICA that would be only applicable for a single rather rare issue, the unloading of an ACPI table. Just the fact that we are discussing this in 2013 and ACPICA has been running since 1999 should confirm the rarity of this case and/or that the existing mechanism has been sufficient for other hosts that run ACPICA.
> 

Thanks for the info.  I understand that making such changes requires a
lot of effort.  This is just a brainstorming, and as you said, I do not
think there is any platform that can cause this issue on Linux today.
We are still in the process of handling load/unload table properly in
the kernel.  Given your input, Rafael's approach of using reference
counting on struct device seems to be the best choice for us. 

BTW, I did work on other OS that supports load/unload table (which might
be the first OS that supported this feature.)  It protects from this
race condition with serialization between the OS and FW with _OST.
However, we cannot expect all platforms to do the same for Linux.

Thanks,
-Toshi


