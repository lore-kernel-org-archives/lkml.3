Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124Ab3L2D6l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 22:58:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38619 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab3L2D63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 22:58:29 -0500
Date: Sat, 28 Dec 2013 19:59:09 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Toshi Kani <toshi.kani@hp.com>,
        Yinghai Lu <yinghai@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH 0/2] ACPI / hotplug / driver core: Special handling for
 container devices
Message-ID: <20131229035909.GB26111@kroah.com>
References: <1421028.Rsfpmhnym3@vostro.rjw.lan>
 <52BD0DC1.2000909@jp.fujitsu.com>
 <2686210.6vSP0yehxh@vostro.rjw.lan>
 <63118574.0bgUpLnDbK@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63118574.0bgUpLnDbK@vostro.rjw.lan>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 27, 2013 at 11:21:59PM +0100, Rafael J. Wysocki wrote:
> Hi Greg,
> 
> The following series of 2 patches (patch [2/2] in particular) make changes
> needed to handle hot-removal of system container devices (represented by
> ACPI container and module device objects) on Fujitsu systems.  Those devices
> represent things like CPU packages, so we need to be able to take care of them
> cleanly for things like in-the-field CPU socked replacement to work.
> 
> The problem being addressed here is that on the systems in question the removal
> of container devices has to be carried out with the help of user space that
> needs to be notified of the container removal before the kernel attempts to
> offline any devices below the container (e.g. in the package represented by the
> container device object in the ACPI tables).  However, our current code works
> the other way around and the entire thing is messed up.
> 
> This patchset adds the bare bones of what's needed to address that issue and it
> should be possible to build on top of the code added by it in the future if
> need be.
> 
> Patch [1/2] introduces a new demand_offline flag for struct acpi_hotplug_profile
> that makes acpi_scan_hot_remove() check the offline status of the device object's
> companion physical devices to start with and return -EBUSY if at least one of them
> is not offline.
> 
> Patch [2/2] uses that flag to implement the container handling.  The details are
> in the changelog, but that's how it works.
> 
> During the initial namespace scan the container ACPI scan handler creates
> "physical" system container device under /sys/devices/system/container/ for
> each ACPI container object whose status is "present" at that time (the sysfs
> name of that device is the same as the sysfs name of the corresponding
> container object and they are linked to each other via the firmware_node and
> physical_node symbolic links, respectively).  Those system container devices
> are initially online.
> 
> The container ACPI scan handler has the demand_offline flag set in its hotplug
> profile, so when a container eject event happens, acpi_scan_hot_remove() will
> notice that the flag is set in the device object's scan handler and will
> check the online status of its "physical" companion device, which is online
> (that is the system container device the above paragraph is about).  That will
> cause KOBJ_CHANGE to be emitted for the system container device and -EBUSY to
> be returned by acpi_scan_hot_remove().  User space is expected to respond to
> that KOBJ_CHANGE by doing what's necessary to remove the container.
> 
> To that end, it needs to offline the system container device through its online
> sysfs attribute (which is present, because the bus type for containers provides
> the online and offline callbacks).  However, the offline for system container
> devices will only succeed if the physical devices right below the container
> (e.g. in the package represented by it) are all offline, so user space will
> have to offline those devices before attempting to offline the system container
> device itself.  When finished, user space can trigger the container removal
> with the help of the eject sysfs attribute of the ACPI container object pointed
> to by the system container device's firmware_node link (this time the check in
> acpi_scan_hot_remove() will succeed, because the system container device in
> question is now offline).
> 
> Please let me know if you have any objections.  If not, I'd like to queue up
> these patches for 3.14.

No objection from me, I've acked the second patch, feel free to take
both of them in your tree.

thanks,

greg k-h
