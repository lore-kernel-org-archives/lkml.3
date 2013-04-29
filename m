Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068Ab3D2MV5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 08:21:57 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:48975 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757710Ab3D2MVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 08:21:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Toshi Kani <toshi.kani@hp.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, isimatu.yasuaki@jp.fujitsu.com,
        vasilis.liaskovitis@profitbricks.com
Subject: [PATCH 0/3 RFC] Driver core / ACPI: Add offline/online for graceful hot-removal of devices
Date: Mon, 29 Apr 2013 14:23:59 +0200
Message-ID: <1576321.HU0tZ4cGWk@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc8+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It has been argued for a number of times that in some cases, if a device cannot
be gracefully removed from the system, it shouldn't be removed from it at all,
because that may lead to a kernel crash.  In particular, that will happen if a
memory module holding kernel memory is removed, but also removing the last CPU
in the system may not be a good idea.  [And I can imagine a few other cases
like that.]

The kernel currently only supports "forced" hot-remove which cannot be stopped
once started, so users have no choice but to try to hot-remove stuff and see
whether or not that crashes the kernel which is kind of unpleasant.  That seems
to be based on the "the user knows better" argument according to which users
triggering device hot-removal should really know what they are doing, so the
kernel doesn't have to worry about that.  However, for instance, this pretty
much isn't the case for memory modules, because the users have no way to see
whether or not any kernel memory has been allocated from a given module.

There have been a few attempts to address this issue, but none of them has
gained broader acceptance.  The following 3 patches are the heart of a new
proposal which is based on the idea to introduce device_offline() and
device_online() operations along the lines of the existing CPU offline/online
mechanism (or, rather, to extend the CPU offline/online so that analogous
operations are available for other devices).  The way it is supposed to work is
that device_offline() will fail if the given device cannot be gracefully
removed from the system (in the kernel's view).  Once it succeeds, though, the
device won't be used any more until either it is removed, or device_online() is
run for it.  That will allow the ACPI device hot-remove code, for one example,
to avoid triggering a non-reversible removal procedure for devices that cannot
be removed gracefully.

Patch [1/3] introduces device_offline() and device_online() as outlined above.
The .offline() and .online() callbacks are only added at the bus type level for
now, because that should be sufficient to cover the memory and CPU use cases.

Patch [2/3] modifies the CPU hotplug support code to use device_offline() and
device_online() to support the sysfs 'online' attribute for CPUs.

Patch [3/3] changes the ACPI device hot-remove code to use device_offline()
for checking if graceful removal of devices is possible.  The way it does that
is to walk the list of "physical" companion devices for each struct acpi_device
involved in the operation and call device_offline() for each of them.  If any
of the device_offline() calls fails (and the hot-removal is not "forced", which
is an option), the removal procedure (which is not reversible) is simply not
carried out.

Of some concern is that device_offline() (and possibly device_online()) is
called under physical_node_lock of the corresponding struct acpi_device, which
introduces ordering dependency between that lock and device locks for the
"physical" devices, but I didn't see any cleaner way to do that (I guess it
is avoidable at the expense of added complexity, but for now it's just better
to make the code as clean as possible IMO).

The next step will be to modify the ACPI processor driver to use the new
mechanism.  Unfortunately, this isn't really straightforward, because it
requires untangling some events handling functionality from hotplug support
code, but I don't see any fundamental obstacles to that at the moment.  Then,
the same approach may be applied to memory hotplug and possibly other devices
in the future.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
