Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964946Ab3BMRyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:54:46 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:31245 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934504Ab3BMRyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:54:44 -0500
Message-ID: <1360777438.3869.100.camel@misato.fc.hp.com>
Subject: Re: [Update][PATCH] ACPI / hotplug: Fix concurrency issues and
 memory leaks
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <liuj97@gmail.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Myron Stowe <mstowe@redhat.com>, linux-pci@vger.kernel.org
Date: Wed, 13 Feb 2013 10:43:58 -0700
In-Reply-To: <1459286.L93riBCyLC@vostro.rjw.lan>
References: <1837481.7dT8hTZ4MT@vostro.rjw.lan>
	 <1459286.L93riBCyLC@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-13 at 14:16 +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> This changeset is aimed at fixing a few different but related
> problems in the ACPI hotplug infrastructure.
> 
> First of all, since notify handlers may be run in parallel with
> acpi_bus_scan(), acpi_bus_trim() and acpi_bus_hot_remove_device()
> and some of them are installed for ACPI handles that have no struct
> acpi_device objects attached (i.e. before those objects are created),
> those notify handlers have to take acpi_scan_lock to prevent races
> from taking place (e.g. a struct acpi_device is found to be present
> for the given ACPI handle, but right after that it is removed by
> acpi_bus_trim() running in parallel to the given notify handler).
> Moreover, since some of them call acpi_bus_scan() and
> acpi_bus_trim(), this leads to the conclusion that acpi_scan_lock
> should be acquired by the callers of these two funtions rather by
> these functions themselves.
> 
> For these reasons, make all notify handlers that can handle device
> addition and eject events take acpi_scan_lock and remove the
> acpi_scan_lock locking from acpi_bus_scan() and acpi_bus_trim().
> Accordingly, update all of their users to make sure that they
> are always called under acpi_scan_lock.
> 
> Furthermore, since eject operations are carried out asynchronously
> with respect to the notify events that trigger them, with the help
> of acpi_bus_hot_remove_device(), even if notify handlers take the
> ACPI scan lock, it still is possible that, for example,
> acpi_bus_trim() will run between acpi_bus_hot_remove_device() and
> the notify handler that scheduled its execution and that
> acpi_bus_trim() will remove the device node passed to
> acpi_bus_hot_remove_device() for ejection.  In that case, the struct
> acpi_device object obtained by acpi_bus_hot_remove_device() will be
> invalid and not-so-funny things will ensue.  To protect agaist that,
> make the users of acpi_bus_hot_remove_device() run get_device() on
> ACPI device node objects that are about to be passed to it and make
> acpi_bus_hot_remove_device() run put_device() on them and check if
> their ACPI handles are not NULL (make acpi_device_unregister() clear
> the device nodes' ACPI handles for that check to work).
> 
> Finally, observe that acpi_os_hotplug_execute() actually can fail,
> in which case its caller ought to free memory allocated for the
> context object to prevent leaks from happening.  It also needs to
> run put_device() on the device node that it ran get_device() on
> previously in that case.  Modify the code accordingly.

I am concerned with this approach.  ACPICA calls notify handlers through
kacpi_notify_wq, which has the max active set to 1.  We then use
kacpi_hotplug_wq (which also has the max active set to 1) so that a
hotplug procedure does not block the notify handlers since they can be
used for non-hotplug events as well.  Acquiring the scan lock in a
notify handler means that a hotplug procedure can block any notify
events.

So, I'd prefer the following approach.

 - Change all hot-plug procedures (i.e. both add and delete) to proceed
under kacpi_hotplug_wq by calling acpi_os_hotplug_execute(). This
serializes all hotplug procedures, and prevents blocking other notify
events.  (Ideally, we should also run all online/offline procedures
under a same work-queue, just like my RFC patchset did, but this is a
different topic for now.)

 - Revert 5993c4670 unless this change is absolutely necessary.  From
the change log, it is not clear to me why this change was needed.  It
changed acpi_bus_hot_remove_device() to take an acpi_device, instead of
an acpi_handle, which introduced a race condition with acpi_device.
acpi_bus_hot_remove_device() should take an acpi_handle, and then obtain
its acpi_device from the acpi_handle since this function is serialized.

 - Remove sanity checks with an acpi_device in the notify handlers,
which have a race condition with acpi_device.  These type-specific
checks will need to be removed when we have a common notify handler
anyway.  The notify handler can continue to check the status of ACPI
device object with an acpi_handle.  Type-specific sanity checks /
validations can be performed within a hotplug procedure, instead.

Thanks,
-Toshi

