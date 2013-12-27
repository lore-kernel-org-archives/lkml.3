Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab3L0WQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 17:16:17 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:57823 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755057Ab3L0WQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 17:16:14 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Toshi Kani <toshi.kani@hp.com>,
        Yinghai Lu <yinghai@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH 0/2] ACPI / hotplug / driver core: Special handling for container devices
Date: Fri, 27 Dec 2013 23:21:59 +0100
Message-ID: <63118574.0bgUpLnDbK@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <2686210.6vSP0yehxh@vostro.rjw.lan>
References: <1421028.Rsfpmhnym3@vostro.rjw.lan> <52BD0DC1.2000909@jp.fujitsu.com> <2686210.6vSP0yehxh@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

The following series of 2 patches (patch [2/2] in particular) make changes
needed to handle hot-removal of system container devices (represented by
ACPI container and module device objects) on Fujitsu systems.  Those devices
represent things like CPU packages, so we need to be able to take care of them
cleanly for things like in-the-field CPU socked replacement to work.

The problem being addressed here is that on the systems in question the removal
of container devices has to be carried out with the help of user space that
needs to be notified of the container removal before the kernel attempts to
offline any devices below the container (e.g. in the package represented by the
container device object in the ACPI tables).  However, our current code works
the other way around and the entire thing is messed up.

This patchset adds the bare bones of what's needed to address that issue and it
should be possible to build on top of the code added by it in the future if
need be.

Patch [1/2] introduces a new demand_offline flag for struct acpi_hotplug_profile
that makes acpi_scan_hot_remove() check the offline status of the device object's
companion physical devices to start with and return -EBUSY if at least one of them
is not offline.

Patch [2/2] uses that flag to implement the container handling.  The details are
in the changelog, but that's how it works.

During the initial namespace scan the container ACPI scan handler creates
"physical" system container device under /sys/devices/system/container/ for
each ACPI container object whose status is "present" at that time (the sysfs
name of that device is the same as the sysfs name of the corresponding
container object and they are linked to each other via the firmware_node and
physical_node symbolic links, respectively).  Those system container devices
are initially online.

The container ACPI scan handler has the demand_offline flag set in its hotplug
profile, so when a container eject event happens, acpi_scan_hot_remove() will
notice that the flag is set in the device object's scan handler and will
check the online status of its "physical" companion device, which is online
(that is the system container device the above paragraph is about).  That will
cause KOBJ_CHANGE to be emitted for the system container device and -EBUSY to
be returned by acpi_scan_hot_remove().  User space is expected to respond to
that KOBJ_CHANGE by doing what's necessary to remove the container.

To that end, it needs to offline the system container device through its online
sysfs attribute (which is present, because the bus type for containers provides
the online and offline callbacks).  However, the offline for system container
devices will only succeed if the physical devices right below the container
(e.g. in the package represented by it) are all offline, so user space will
have to offline those devices before attempting to offline the system container
device itself.  When finished, user space can trigger the container removal
with the help of the eject sysfs attribute of the ACPI container object pointed
to by the system container device's firmware_node link (this time the check in
acpi_scan_hot_remove() will succeed, because the system container device in
question is now offline).

Please let me know if you have any objections.  If not, I'd like to queue up
these patches for 3.14.

Thanks,
Rafael

